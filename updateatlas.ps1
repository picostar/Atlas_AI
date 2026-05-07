[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$ProjectRoot = ".",
    [string]$SourcePath,
    [string]$RepoOwner = "picostar",
    [string]$RepoName = "Atlas_AI",
    [string]$Ref = "main",
    [switch]$SkipLayoutMigration,
    [switch]$KeepDownloadedSource,
    [switch]$SkipGitSafetyChecks,
    [switch]$SkipGitFetch,
    [switch]$NoRollbackTag,
    [switch]$PushRollbackTag,
    [switch]$KeepSeedArtifacts,
    [switch]$NoSelfDelete
)

$ErrorActionPreference = 'Stop'

function Resolve-FullPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    return [System.IO.Path]::GetFullPath($Path)
}

function Get-PowerShellCommand {
    $powerShellCommand = Get-Command pwsh -ErrorAction SilentlyContinue
    if (-not $powerShellCommand) {
        $powerShellCommand = Get-Command powershell -ErrorAction SilentlyContinue
    }

    if (-not $powerShellCommand) {
        throw "Could not locate pwsh or powershell on PATH."
    }

    return $powerShellCommand.Source
}

function Start-SelfDelete {
    param(
        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )

    if (-not (Test-Path -LiteralPath $FilePath)) {
        return
    }

    $powerShellPath = Get-PowerShellCommand
    $escapedPath = $FilePath.Replace("'", "''")
    $cleanupScript = @"
`$target = '$escapedPath'
for (`$attempt = 0; `$attempt -lt 100; `$attempt++) {
    try {
        if (-not (Test-Path -LiteralPath `$target)) {
            exit 0
        }

        Remove-Item -LiteralPath `$target -Force -ErrorAction Stop
        if (-not (Test-Path -LiteralPath `$target)) {
            exit 0
        }
    } catch {
    }
}

exit 1
"@

    $encodedScript = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($cleanupScript))
    $workingDirectory = Split-Path -Parent $FilePath

    Start-Process -FilePath $powerShellPath -WindowStyle Hidden -WorkingDirectory $workingDirectory -ArgumentList @(
        '-NoProfile',
        '-ExecutionPolicy',
        'Bypass',
        '-EncodedCommand',
        $encodedScript
    ) | Out-Null
}

function Start-PathCleanup {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PathToRemove
    )

    if (-not (Test-Path -LiteralPath $PathToRemove)) {
        return
    }

    $powerShellPath = Get-PowerShellCommand
    $escapedPath = $PathToRemove.Replace("'", "''")
    $cleanupScript = @"
`$target = '$escapedPath'
for (`$attempt = 0; `$attempt -lt 100; `$attempt++) {
    try {
        if (-not (Test-Path -LiteralPath `$target)) {
            exit 0
        }

        `$item = Get-Item -LiteralPath `$target -Force -ErrorAction Stop
        `$isLink = `$false
        if (`$item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
            if (`$item.PSObject.Properties.Name -contains 'LinkType') {
                `$isLink = -not [string]::IsNullOrWhiteSpace([string]`$item.LinkType)
            }

            if (-not `$isLink -and (`$item.PSObject.Properties.Name -contains 'Target')) {
                `$targetValue = `$item.Target
                if (`$targetValue -is [System.Array]) {
                    `$isLink = `$targetValue.Count -gt 0
                } else {
                    `$isLink = -not [string]::IsNullOrWhiteSpace([string]`$targetValue)
                }
            }
        }

        if (`$isLink) {
            Remove-Item -LiteralPath `$target -Force -ErrorAction Stop
        } else {
            Remove-Item -LiteralPath `$target -Recurse -Force -ErrorAction Stop
        }

        if (-not (Test-Path -LiteralPath `$target)) {
            exit 0
        }
    } catch {
    }

    Start-Sleep -Milliseconds 200
}

exit 1
"@

    $encodedScript = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($cleanupScript))
    $workingDirectory = Split-Path -Parent $PathToRemove

    Start-Process -FilePath $powerShellPath -WindowStyle Hidden -WorkingDirectory $workingDirectory -ArgumentList @(
        '-NoProfile',
        '-ExecutionPolicy',
        'Bypass',
        '-EncodedCommand',
        $encodedScript
    ) | Out-Null
}

function Get-SeedArtifactCleanupTarget {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectRoot,
        [string]$ScriptPath
    )

    if ([string]::IsNullOrWhiteSpace($ScriptPath)) {
        return $null
    }

    $resolvedProjectRoot = (Get-Item -LiteralPath (Resolve-FullPath -Path $ProjectRoot) -Force).FullName
    $resolvedScriptPath = (Get-Item -LiteralPath (Resolve-FullPath -Path $ScriptPath) -Force).FullName
    $scriptDirectory = Split-Path -Parent $resolvedScriptPath

    $normalizedProjectRoot = $resolvedProjectRoot.TrimEnd('\\')
    $projectRootWithSeparator = $normalizedProjectRoot + '\\'
    if (-not $scriptDirectory.StartsWith($projectRootWithSeparator, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $null
    }

    $relativeScriptDir = $scriptDirectory.Substring($projectRootWithSeparator.Length)
    if ([string]::IsNullOrWhiteSpace($relativeScriptDir)) {
        return $null
    }

    $topSegment = ($relativeScriptDir -split '[\\/]')[0]
    if ($topSegment.Equals('atlas_ai', [System.StringComparison]::OrdinalIgnoreCase)) {
        return Join-Path $resolvedProjectRoot $topSegment
    }

    return $null
}

function Test-IsPathTrackedByGit {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath,
        [Parameter(Mandatory = $true)]
        [string]$PathToCheck
    )

    $gitCommand = Get-Command git -ErrorAction SilentlyContinue
    if (-not $gitCommand) {
        return $false
    }

    if (-not (Test-Path -LiteralPath (Join-Path $RootPath '.git'))) {
        return $false
    }

    $normalizedRoot = (Resolve-FullPath -Path $RootPath).TrimEnd('\\')
    $normalizedCheckPath = (Resolve-FullPath -Path $PathToCheck).TrimEnd('\\')
    $rootWithSeparator = $normalizedRoot + '\\'

    if (-not $normalizedCheckPath.StartsWith($rootWithSeparator, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $false
    }

    $relativePath = [System.IO.Path]::GetRelativePath($normalizedRoot, $normalizedCheckPath) -replace '\\', '/'
    if ([string]::IsNullOrWhiteSpace($relativePath) -or $relativePath.StartsWith('../')) {
        return $false
    }

    $topSegment = ($relativePath -split '/')[0]
    if ([string]::IsNullOrWhiteSpace($topSegment)) {
        return $false
    }

    $tracked = & git -C $normalizedRoot ls-files -- "$topSegment" "$topSegment/*"
    return $LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace("$tracked")
}

function Get-ToolkitSource {
    param(
        [string]$LocalSource,
        [Parameter(Mandatory = $true)]
        [string]$Owner,
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [Parameter(Mandatory = $true)]
        [string]$Branch
    )

    if ($LocalSource) {
        $resolvedLocalSource = Resolve-FullPath -Path $LocalSource
        $installerPath = Join-Path $resolvedLocalSource "atlas_ai.ps1"
        if (-not (Test-Path -LiteralPath $installerPath)) {
            throw "SourcePath does not contain atlas_ai.ps1: $resolvedLocalSource"
        }

        return [pscustomobject]@{
            RootPath = $resolvedLocalSource
            TemporaryRoot = $null
            Downloaded = $false
        }
    }

    $temporaryRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("atlas-update-" + [guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Path $temporaryRoot -Force | Out-Null

    $zipPath = Join-Path $temporaryRoot "atlas-source.zip"
    $downloadUrl = "https://github.com/$Owner/$Name/archive/refs/heads/$Branch.zip"
    Write-Host "Downloading latest atlas kit: $downloadUrl"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath

    $extractPath = Join-Path $temporaryRoot "source"
    Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

    $candidateRoots = Get-ChildItem -Path $extractPath -Directory -ErrorAction Stop
    $resolvedRoot = $null
    foreach ($candidate in $candidateRoots) {
        if (Test-Path -LiteralPath (Join-Path $candidate.FullName "atlas_ai.ps1")) {
            $resolvedRoot = $candidate.FullName
            break
        }
    }

    if (-not $resolvedRoot) {
        throw "Downloaded source did not contain atlas_ai.ps1."
    }

    return [pscustomobject]@{
        RootPath = $resolvedRoot
        TemporaryRoot = $temporaryRoot
        Downloaded = $true
    }
}

function New-StagedSourceKit {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourceRoot,
        [Parameter(Mandatory = $true)]
        [string]$ProjectRoot
    )

    $stagingRoot = Join-Path $ProjectRoot (".atlas-update-source-" + [guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Path $stagingRoot -Force | Out-Null

    $sourceItems = Get-ChildItem -LiteralPath $SourceRoot -Force
    foreach ($item in $sourceItems) {
        if ($item.Name -eq ".git") {
            continue
        }

        Copy-Item -LiteralPath $item.FullName -Destination $stagingRoot -Recurse -Force
    }

    return $stagingRoot
}

function Get-ProjectSignals {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath
    )

    $legacyPaths = @(
        "docs/projects",
        "docs/reference/stack-patterns",
        "docs/reference/ux-patterns"
    )

    $foundLegacyPaths = @()
    foreach ($legacyPath in $legacyPaths) {
        if (Test-Path -LiteralPath (Join-Path $RootPath $legacyPath)) {
            $foundLegacyPaths += $legacyPath
        }
    }

    return [pscustomobject]@{
        HasPS = Test-Path -LiteralPath (Join-Path $RootPath "PS.md")
        HasCGR = Test-Path -LiteralPath (Join-Path $RootPath "CGR.md")
        HasSkillsFolder = Test-Path -LiteralPath (Join-Path $RootPath ".github/skills")
        HasAgileDocs = Test-Path -LiteralPath (Join-Path $RootPath "docs/agile/devcycle.md")
        LegacyPaths = $foundLegacyPaths
    }
}

function Invoke-AtlasInstallPass {
    param(
        [Parameter(Mandatory = $true)]
        [string]$InstallerPath,
        [Parameter(Mandatory = $true)]
        [string]$TargetRoot,
        [switch]$IncludePS,
        [switch]$IncludeCGR,
        [switch]$IncludeScaffold,
        [switch]$IncludeSkills,
        [switch]$Force,
        [switch]$Verify,
        [string]$PassName
    )

    $installParams = @{
        TargetRoot = $TargetRoot
    }

    if ($IncludePS) { $installParams.IncludePS = $true }
    if ($IncludeCGR) { $installParams.IncludeCGR = $true }
    if ($IncludeScaffold) { $installParams.IncludeScaffold = $true }
    if ($IncludeSkills) { $installParams.IncludeSkills = $true }
    if ($Force) { $installParams.Force = $true }
    if ($Verify) { $installParams.Verify = $true }

    $operationName = if ($PassName) { $PassName } else { "atlas installer pass" }
    if ($PSCmdlet.ShouldProcess($TargetRoot, $operationName)) {
        Write-Host "Running $operationName ..."
        & $InstallerPath @installParams
    }
}

function Test-PostUpdateState {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath,
        [switch]$ExpectPS,
        [switch]$ExpectCGR,
        [switch]$ExpectMigration
    )

    $requiredPaths = @(
        ".github/copilot-instructions.md",
        "ATLAS.md",
        "AGENTS.md",
        "CLAUDE.md",
        "CHATGPT.md",
        "GEMINI.md",
        "docs/agile/devcycle.md",
        "docs/agile/backlog.md",
        "docs/agile/status.md",
        "docs/agile/retro.md",
        "scripts/README.md",
        "archive/README.md"
    )

    if ($ExpectPS) {
        $requiredPaths += "PS.md"
    }

    if ($ExpectCGR) {
        $requiredPaths += "CGR.md"
    }

    $missing = @()
    foreach ($relativePath in $requiredPaths) {
        if (-not (Test-Path -LiteralPath (Join-Path $RootPath $relativePath))) {
            $missing += $relativePath
        }
    }

    if ($missing.Count -gt 0) {
        throw "Post-update verification failed. Missing files: $($missing -join ', ')"
    }

    if ($ExpectMigration) {
        $legacyChecks = @(
            "docs/projects",
            "docs/reference/stack-patterns",
            "docs/reference/ux-patterns"
        )

        $stillLegacy = @()
        foreach ($legacyPath in $legacyChecks) {
            if (Test-Path -LiteralPath (Join-Path $RootPath $legacyPath)) {
                $stillLegacy += $legacyPath
            }
        }

        if ($stillLegacy.Count -gt 0) {
            throw "Legacy layout paths still exist after migration: $($stillLegacy -join ', ')"
        }
    }
}

function Invoke-GitSafetyPreflight {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath,
        [switch]$SkipChecks,
        [switch]$SkipFetch,
        [switch]$CreateRollbackTag,
        [switch]$PushRollbackTag
    )

    $context = [pscustomobject]@{
        IsGitRepo = $false
        Branch = $null
        Upstream = $null
        Ahead = 0
        Behind = 0
        RollbackTag = $null
    }

    if ($SkipChecks) {
        if ($PushRollbackTag) {
            throw "Cannot use -PushRollbackTag when -SkipGitSafetyChecks is set."
        }

        Write-Warning "Git safety checks skipped by parameter."
        return $context
    }

    $gitCommand = Get-Command git -ErrorAction SilentlyContinue
    $gitMetadataPath = Join-Path $RootPath ".git"
    if (-not (Test-Path -LiteralPath $gitMetadataPath)) {
        Write-Host "No git repository detected. Skipping git safety checks."
        return $context
    }

    if (-not $gitCommand) {
        throw "This project is a git repository, but git is not available on PATH."
    }

    $context.IsGitRepo = $true

    $statusOutput = & git -C $RootPath status --porcelain
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to read git status for safety checks."
    }

    if ($statusOutput) {
        throw "Working tree is not clean. Commit or stash changes before running updateatlas."
    }

    $branchOutput = & git -C $RootPath rev-parse --abbrev-ref HEAD
    $branch = $null
    if ($LASTEXITCODE -eq 0 -and $branchOutput) {
        $branch = "$branchOutput".Trim()
    }

    if ([string]::IsNullOrWhiteSpace($branch)) {
        throw "Could not determine current git branch."
    }
    $context.Branch = $branch

    & git -C $RootPath remote get-url origin *> $null
    $hasOrigin = $LASTEXITCODE -eq 0

    if ($hasOrigin -and -not $SkipFetch) {
        Write-Host "Fetching origin to verify GitHub sync state ..."
        & git -C $RootPath fetch --prune origin
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to fetch from origin. Resolve git connectivity issues before updateatlas."
        }
    }

    $upstreamOutput = & git -C $RootPath rev-parse --abbrev-ref --symbolic-full-name "@{u}" 2>$null
    $upstream = $null
    if ($LASTEXITCODE -eq 0 -and $upstreamOutput) {
        $upstream = "$upstreamOutput".Trim()
    }

    if (-not [string]::IsNullOrWhiteSpace($upstream)) {
        $context.Upstream = $upstream
        $countsOutput = & git -C $RootPath rev-list --left-right --count "HEAD...$upstream"
        $countsRaw = $null
        if ($LASTEXITCODE -eq 0 -and $countsOutput) {
            $countsRaw = "$countsOutput".Trim()
        }

        if ($LASTEXITCODE -eq 0) {
            $parts = $countsRaw -split '\s+'
            if ($parts.Count -ge 2) {
                $context.Ahead = [int]$parts[0]
                $context.Behind = [int]$parts[1]
            }
        }

        if ($context.Behind -gt 0) {
            throw "Current branch is behind upstream by $($context.Behind) commit(s). Pull or rebase before updateatlas."
        }

        if ($context.Ahead -gt 0) {
            Write-Warning "Current branch is ahead of upstream by $($context.Ahead) commit(s)."
        }
    } else {
        Write-Warning "No upstream tracking branch found. Sync safety check against GitHub is limited."
    }

    if ($CreateRollbackTag) {
        $tagName = "pre-updateatlas-{0}" -f (Get-Date -Format "yyyyMMdd-HHmmss")
        & git -C $RootPath tag $tagName
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to create rollback tag: $tagName"
        }

        $context.RollbackTag = $tagName
        Write-Host "Created rollback tag: $tagName"

        if ($PushRollbackTag) {
            if (-not $hasOrigin) {
                throw "Cannot push rollback tag because no origin remote is configured."
            }

            & git -C $RootPath push origin $tagName
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to push rollback tag to origin: $tagName"
            }

            Write-Host "Pushed rollback tag to origin: $tagName"
        }
    } elseif ($PushRollbackTag) {
        throw "Cannot use -PushRollbackTag with -NoRollbackTag."
    }

    return $context
}

$runSucceeded = $false
$resolvedProjectRoot = Resolve-FullPath -Path $ProjectRoot
$source = $null
$stagedSourceRoot = $null
$gitContext = $null
$seedCleanupTarget = $null
$seedCleanupScheduled = $false

try {
    if (-not (Test-Path -LiteralPath $resolvedProjectRoot)) {
        throw "Project root does not exist: $resolvedProjectRoot"
    }

    Write-Host ""
    Write-Host "Atlas update target: $resolvedProjectRoot"

    if ($PushRollbackTag -and $NoRollbackTag) {
        throw "Cannot use -PushRollbackTag with -NoRollbackTag."
    }

    $seedCleanupTarget = Get-SeedArtifactCleanupTarget -ProjectRoot $resolvedProjectRoot -ScriptPath $PSCommandPath
    if (-not $seedCleanupTarget -and $PSScriptRoot) {
        $normalizedProjectRoot = $resolvedProjectRoot.TrimEnd('\\')
        $normalizedScriptRoot = (Resolve-FullPath -Path $PSScriptRoot).TrimEnd('\\')
        $scriptRootName = Split-Path -Leaf $normalizedScriptRoot
        $scriptRootParent = (Split-Path -Parent $normalizedScriptRoot).TrimEnd('\\')

        if ($scriptRootName.Equals('atlas_ai', [System.StringComparison]::OrdinalIgnoreCase) -and $scriptRootParent.Equals($normalizedProjectRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            $seedCleanupTarget = $normalizedScriptRoot
        }
    }

    $signals = Get-ProjectSignals -RootPath $resolvedProjectRoot
    Write-Host ""
    Write-Host "Structure review"
    Write-Host "- PS.md present: $($signals.HasPS)"
    Write-Host "- CGR.md present: $($signals.HasCGR)"
    Write-Host "- .github/skills present: $($signals.HasSkillsFolder)"
    Write-Host "- docs/agile/devcycle.md present: $($signals.HasAgileDocs)"

    if ($signals.LegacyPaths.Count -gt 0) {
        Write-Host "- Legacy layout detected: $($signals.LegacyPaths -join ', ')"
    } else {
        Write-Host "- Legacy layout detected: none"
    }

    if ($seedCleanupTarget) {
        Write-Host "- Seed artifact cleanup target: $seedCleanupTarget"
    }

    if ($WhatIfPreference) {
        Write-Host ""
        Write-Host "WhatIf preview"
        Write-Host "- Would run git safety preflight (clean tree, upstream sync, rollback tag)."
        if ($PushRollbackTag) {
            Write-Host "- Would push rollback tag to origin for team-visible rollback."
        }
        Write-Host "- Would run core refresh with Force (preserving project-specific files outside kit targets)."
        Write-Host "- Would run non-destructive scaffold pass and installer verification."
        if ($NoSelfDelete) {
            Write-Host "- Would keep updater artifacts because -NoSelfDelete was specified."
        } elseif ($KeepSeedArtifacts) {
            Write-Host "- Would keep the atlas_ai seed folder because -KeepSeedArtifacts was specified."
        } elseif ($seedCleanupTarget) {
            Write-Host "- Would remove seed artifacts after success: $seedCleanupTarget"
        } else {
            Write-Host "- No seed artifact cleanup target detected for this run."
        }
        if ($signals.LegacyPaths.Count -gt 0 -and -not $SkipLayoutMigration) {
            Write-Host "- Would run legacy layout migration for: $($signals.LegacyPaths -join ', ')"
        } elseif ($SkipLayoutMigration) {
            Write-Host "- Layout migration is explicitly skipped by parameter."
        } else {
            Write-Host "- No legacy layout migration needed."
        }

        $runSucceeded = $true
        return
    }

    $gitContext = Invoke-GitSafetyPreflight -RootPath $resolvedProjectRoot -SkipChecks:$SkipGitSafetyChecks -SkipFetch:$SkipGitFetch -CreateRollbackTag:(-not $NoRollbackTag) -PushRollbackTag:$PushRollbackTag

    $source = Get-ToolkitSource -LocalSource $SourcePath -Owner $RepoOwner -Name $RepoName -Branch $Ref
    $stagedSourceRoot = New-StagedSourceKit -SourceRoot $source.RootPath -ProjectRoot $resolvedProjectRoot
    $installerPath = Join-Path $stagedSourceRoot "atlas_ai.ps1"
    $migrationPath = Join-Path $stagedSourceRoot "scripts/migrate-layout-v2.ps1"

    if (-not (Test-Path -LiteralPath $installerPath)) {
        throw "Installer not found in source kit: $installerPath"
    }

    $sourceRootNormalized = $stagedSourceRoot.TrimEnd('\\')
    $targetRootNormalized = $resolvedProjectRoot.TrimEnd('\\')
    if ($sourceRootNormalized.Equals($targetRootNormalized, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Staging folder and project root unexpectedly resolved to the same path."
    }

    Invoke-AtlasInstallPass -InstallerPath $installerPath -TargetRoot ".." -IncludePS:$signals.HasPS -IncludeCGR:$signals.HasCGR -Force -PassName "core refresh"

    Invoke-AtlasInstallPass -InstallerPath $installerPath -TargetRoot ".." -IncludePS:$signals.HasPS -IncludeCGR:$signals.HasCGR -IncludeScaffold -IncludeSkills:$signals.HasSkillsFolder -Verify -PassName "non-destructive scaffold and verification"

    if (-not $SkipLayoutMigration -and $signals.LegacyPaths.Count -gt 0) {
        if (-not (Test-Path -LiteralPath $migrationPath)) {
            throw "Migration script not found in source kit: $migrationPath"
        }

        if ($PSCmdlet.ShouldProcess($resolvedProjectRoot, "legacy layout migration")) {
            Write-Host "Running legacy layout migration ..."
            & $migrationPath -RepoRoot $resolvedProjectRoot
        }
    }

    if (-not $WhatIfPreference) {
        Test-PostUpdateState -RootPath $resolvedProjectRoot -ExpectPS:$signals.HasPS -ExpectCGR:$signals.HasCGR -ExpectMigration:($signals.LegacyPaths.Count -gt 0 -and -not $SkipLayoutMigration)
    } else {
        Write-Host "WhatIf mode detected, skipping strict post-update state assertions."
    }

    Write-Host ""
    Write-Host "Atlas update complete. Verification passed."
    $runSucceeded = $true
}
catch {
    Write-Host "Atlas update failed: $($_.Exception.Message)"

    if ($gitContext -and $gitContext.IsGitRepo -and $gitContext.RollbackTag) {
        Write-Host ""
        Write-Host "Rollback guidance"
        Write-Host "- git switch $($gitContext.Branch)"
        Write-Host "- git reset --hard $($gitContext.RollbackTag)"
        Write-Host "- git clean -fd    # optional, removes untracked files"
    }
}
finally {
    if ($stagedSourceRoot -and (Test-Path -LiteralPath $stagedSourceRoot)) {
        if ($PSCmdlet.ShouldProcess($stagedSourceRoot, "remove staged source kit")) {
            Remove-Item -LiteralPath $stagedSourceRoot -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    if ($source -and $source.Downloaded -and -not $KeepDownloadedSource) {
        if ($PSCmdlet.ShouldProcess($source.TemporaryRoot, "remove downloaded source")) {
            Remove-Item -LiteralPath $source.TemporaryRoot -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    if ($runSucceeded -and -not $WhatIfPreference -and -not $NoSelfDelete -and -not $KeepSeedArtifacts -and $seedCleanupTarget -and (Test-Path -LiteralPath $seedCleanupTarget)) {
        if (Test-IsPathTrackedByGit -RootPath $resolvedProjectRoot -PathToCheck $seedCleanupTarget) {
            Write-Warning "Skipping seed artifact cleanup because the path appears tracked by git: $seedCleanupTarget"
            Write-Warning "Use -KeepSeedArtifacts if you intend to keep it, or remove it manually after untracking."
        } elseif ($PSCmdlet.ShouldProcess($seedCleanupTarget, "remove seed artifacts")) {
            Write-Host "Scheduling seed artifact cleanup: $seedCleanupTarget"
            Start-PathCleanup -PathToRemove $seedCleanupTarget
            $seedCleanupScheduled = $true
        }
    }

    if ($runSucceeded -and -not $NoSelfDelete -and -not $WhatIfPreference -and -not $seedCleanupScheduled -and $PSCommandPath) {
        Write-Host "Scheduling self-delete: $PSCommandPath"
        Start-SelfDelete -FilePath $PSCommandPath
    }

    if (-not $runSucceeded) {
        exit 1
    } else {
        $global:LASTEXITCODE = 0
    }
}
