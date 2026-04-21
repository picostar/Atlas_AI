[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$TargetRoot = "..",
    [switch]$IncludeCGR,
    [switch]$IncludePS,
    [switch]$IncludeScaffold,
    [switch]$OrganizeExisting,
    [switch]$IncludeSkills,
    [string]$SkillsSource,
    [switch]$InitGit,
    [string]$GitHubRepo,
    [switch]$Public,
    [switch]$Force,
    [switch]$Verify,
    [string]$SeedPath,
    [switch]$RemoveSeed
)

$templateRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$resolvedTargetRoot = [System.IO.Path]::GetFullPath((Join-Path $templateRoot $TargetRoot))
$resolvedSeedPath = $null
$seedGitPath = $null

if ($SeedPath) {
    $resolvedSeedPath = [System.IO.Path]::GetFullPath($SeedPath)
    $targetRootWithSeparator = $resolvedTargetRoot.TrimEnd('\') + '\'

    if ($resolvedSeedPath.Equals($resolvedTargetRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        Write-Warning "SeedPath points at the target root and will not be excluded from the initial commit."
        $resolvedSeedPath = $null
    } elseif ($resolvedSeedPath.StartsWith($targetRootWithSeparator, [System.StringComparison]::OrdinalIgnoreCase)) {
        $seedGitPath = $resolvedSeedPath.Substring($targetRootWithSeparator.Length) -replace '\\', '/'
    } else {
        Write-Warning "SeedPath is outside the target root and will not be excluded from the initial commit: $resolvedSeedPath"
        $resolvedSeedPath = $null
    }
}

function Start-SeedCleanup {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PathToRemove
    )

    $powerShellCommand = Get-Command pwsh -ErrorAction SilentlyContinue
    if (-not $powerShellCommand) {
        $powerShellCommand = Get-Command powershell -ErrorAction SilentlyContinue
    }

    if (-not $powerShellCommand) {
        Write-Warning "Could not schedule seed cleanup because no PowerShell executable was found on PATH."
        return
    }

    $escapedPath = $PathToRemove.Replace("'", "''")
    $cleanupScript = @"
`$seed = '$escapedPath'
for (`$attempt = 0; `$attempt -lt 100; `$attempt++) {
    try {
        if (-not (Test-Path -LiteralPath `$seed)) {
            exit 0
        }

        `$item = Get-Item -LiteralPath `$seed -Force -ErrorAction Stop
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
            Remove-Item -LiteralPath `$seed -Force -ErrorAction Stop
        } else {
            Remove-Item -LiteralPath `$seed -Recurse -Force -ErrorAction Stop
        }

        if (-not (Test-Path -LiteralPath `$seed)) {
            exit 0
        }
    } catch {
    }

    Start-Sleep -Milliseconds 200
}

exit 1
"@

    $encodedCleanupScript = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($cleanupScript))
    $cleanupWorkingDirectory = Split-Path -Parent $PathToRemove

    Start-Process -FilePath $powerShellCommand.Source -WindowStyle Hidden -WorkingDirectory $cleanupWorkingDirectory -ArgumentList @(
        '-NoProfile',
        '-ExecutionPolicy',
        'Bypass',
        '-EncodedCommand',
        $encodedCleanupScript
    ) | Out-Null
}

function Test-IsStartupPlanningArtifact {
    param(
        [Parameter(Mandatory = $true)]
        [string]$FileName
    )

    $normalizedName = $FileName.ToLowerInvariant()
    return $normalizedName -match '(^|[_\-.])(todo|seed|startup|start|start-here|kickoff|bootstrap|init|newproject|new-project|project-start|project-setup)([_\-.]|$)'
}

function Get-NtelioDestinationRoot {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RelativePath,
        [Parameter(Mandatory = $true)]
        [string]$FileName,
        [string]$Extension
    )

    $normalizedRelative = ($RelativePath -replace '\\', '/').ToLowerInvariant()
    $normalizedName = $FileName.ToLowerInvariant()
    $normalizedExtension = ($Extension ?? '').ToLowerInvariant()
    $firstSegment = ($normalizedRelative -split '/')[0]

    if ($firstSegment -match '^(scripts?|tools?|automation|ops)$') {
        return 'scripts'
    }

    if ($firstSegment -match '^(archive|archived|old|legacy|backup)$') {
        return 'archive'
    }

    if ($firstSegment -match '^(agile|planning|plan|sprint)$') {
        return 'docs/agile'
    }

    if ($firstSegment -match '^(project|projects|product|requirements|design|architecture|adr|spec|specs)$') {
        return 'docs/projects'
    }

    if ($normalizedName -match '(^|[_\-.])(backlog|devcycle|status|retro|sprint|kanban)([_\-.]|$)') {
        return 'docs/agile'
    }

    if ($normalizedName -match '(^|[_\-.])(mrd|prd|esd|adr|rfc|requirements?|spec|specification|design|architecture|roadmap|proposal)([_\-.]|$)') {
        return 'docs/projects'
    }

    if ($normalizedName -match '(^|[_\-.])(archive|archived|legacy|old|deprecated|backup)([_\-.]|$)') {
        return 'archive'
    }

    if (Test-IsStartupPlanningArtifact -FileName $FileName) {
        return 'docs/reference'
    }

    $scriptExtensions = @('.ps1', '.psm1', '.psd1', '.bat', '.cmd', '.sh', '.zsh', '.bash', '.py')
    if ($scriptExtensions -contains $normalizedExtension) {
        return 'scripts'
    }

    $docExtensions = @('.md', '.txt', '.rst', '.adoc', '.rtf', '.pdf', '.doc', '.docx')
    if ($docExtensions -contains $normalizedExtension) {
        return 'docs/reference'
    }

    return $null
}

function Get-UniqueDestinationPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        return $Path
    }

    $directory = Split-Path -Parent $Path
    $name = [System.IO.Path]::GetFileNameWithoutExtension($Path)
    $extension = [System.IO.Path]::GetExtension($Path)

    $counter = 1
    do {
        $candidate = Join-Path $directory ("{0}-migrated-{1}{2}" -f $name, $counter, $extension)
        $counter++
    } while (Test-Path -LiteralPath $candidate)

    return $candidate
}

function Move-ExistingArtifacts {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath,
        [string]$SeedPath
    )

    $normalizedRoot = $RootPath.TrimEnd('\')
    $rootWithSeparator = $normalizedRoot + '\'
    $normalizedSeed = $null
    if ($SeedPath) {
        $normalizedSeed = $SeedPath.TrimEnd('\')
    }

    $skipTopLevel = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    @(
        '.git',
        '.github',
        '.vscode',
        '.idea',
        'docs',
        'scripts',
        'archive',
        'src',
        'app',
        'api',
        'web',
        'frontend',
        'backend',
        'client',
        'server',
        'lib',
        'libs',
        'pkg',
        'packages',
        'test',
        'tests',
        'node_modules',
        'dist',
        'build',
        'out',
        'bin',
        'obj',
        'vendor'
    ) | ForEach-Object {
        $null = $skipTopLevel.Add($_)
    }

    if ($normalizedSeed) {
        $seedFolderName = Split-Path -Leaf $normalizedSeed
        if ($seedFolderName) {
            $null = $skipTopLevel.Add($seedFolderName)
        }
    }

    $movedCount = 0
    $startupReferenceFiles = [System.Collections.Generic.List[string]]::new()
    $candidates = Get-ChildItem -LiteralPath $normalizedRoot -Recurse -File -Force -ErrorAction SilentlyContinue

    foreach ($candidate in $candidates) {
        if ($normalizedSeed -and (
            $candidate.FullName.Equals($normalizedSeed, [System.StringComparison]::OrdinalIgnoreCase) -or
            $candidate.FullName.StartsWith($normalizedSeed + '\', [System.StringComparison]::OrdinalIgnoreCase)
        )) {
            continue
        }

        if (-not $candidate.FullName.StartsWith($rootWithSeparator, [System.StringComparison]::OrdinalIgnoreCase)) {
            continue
        }

        $relativePath = $candidate.FullName.Substring($rootWithSeparator.Length)
        if ([string]::IsNullOrWhiteSpace($relativePath)) {
            continue
        }

        $firstSegment = ($relativePath -split '[\\/]')[0]
        if ($skipTopLevel.Contains($firstSegment)) {
            continue
        }

        $destinationRoot = Get-NtelioDestinationRoot -RelativePath $relativePath -FileName $candidate.Name -Extension $candidate.Extension
        if (-not $destinationRoot) {
            continue
        }

        $relativeDirectory = Split-Path -Path $relativePath -Parent
        $destinationDirectory = Join-Path $normalizedRoot $destinationRoot
        if ($relativeDirectory -and $relativeDirectory -ne '.') {
            $destinationDirectory = Join-Path $destinationDirectory $relativeDirectory
        }

        if (-not (Test-Path -LiteralPath $destinationDirectory)) {
            New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
        }

        $destinationPath = Join-Path $destinationDirectory $candidate.Name
        $destinationPath = Get-UniqueDestinationPath -Path $destinationPath

        if ($PSCmdlet.ShouldProcess($destinationPath, "Move existing artifact: $relativePath")) {
            Move-Item -LiteralPath $candidate.FullName -Destination $destinationPath -Force
            $movedCount++
            $relativeDestinationPath = $destinationPath.Substring($rootWithSeparator.Length) -replace '\\', '/'
            Write-Host "Reorganized $relativePath -> $relativeDestinationPath"

            if ($destinationRoot -eq 'docs/reference' -and (Test-IsStartupPlanningArtifact -FileName $candidate.Name)) {
                $startupReferenceFiles.Add($relativeDestinationPath) | Out-Null
            }
        }
    }

    if ($movedCount -gt 0) {
        Write-Host "Reorganized $movedCount existing files into project folders."
    } else {
        Write-Host "No existing files matched ntelio_ai reorganization rules."
    }

    return [pscustomobject]@{
        MovedCount = $movedCount
        StartupReferenceFiles = @($startupReferenceFiles)
    }
}

function Get-GitTopLevelSegment {
    param(
        [Parameter(Mandatory = $true)]
        [string]$GitPath
    )

    $normalizedPath = ($GitPath -replace '\\', '/').Trim('/')
    if ([string]::IsNullOrWhiteSpace($normalizedPath)) {
        return $null
    }

    return ($normalizedPath -split '/')[0]
}

function Get-PathsUnderTopLevelSegment {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Paths,
        [Parameter(Mandatory = $true)]
        [string]$TopLevelSegment
    )

    $matches = @()
    foreach ($path in $Paths) {
        if ([string]::IsNullOrWhiteSpace($path)) {
            continue
        }

        $normalizedPath = ($path -replace '\\', '/').Trim('/')
        if ([string]::IsNullOrWhiteSpace($normalizedPath)) {
            continue
        }

        $firstSegment = ($normalizedPath -split '/')[0]
        if ($firstSegment.Equals($TopLevelSegment, [System.StringComparison]::OrdinalIgnoreCase)) {
            $matches += $path
        }
    }

    return $matches
}

function Remove-SeedChangesFromIndex {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SeedGitPath
    )

    $seedTopLevel = Get-GitTopLevelSegment -GitPath $SeedGitPath
    if (-not $seedTopLevel) {
        return
    }

    $headExists = $false
    git rev-parse --verify HEAD 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        $headExists = $true
    }

    $stagedPaths = @(git diff --cached --name-only)
    $seedStagedPaths = Get-PathsUnderTopLevelSegment -Paths $stagedPaths -TopLevelSegment $seedTopLevel

    foreach ($stagedPath in $seedStagedPaths) {
        if ($headExists) {
            git reset -q HEAD -- "$stagedPath" 2>&1 | Out-Null
        } else {
            git rm -r -f --cached --ignore-unmatch -- "$stagedPath" 2>&1 | Out-Null
        }
    }
}

function Test-SeedTrackedInIndex {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SeedGitPath
    )

    $seedTopLevel = Get-GitTopLevelSegment -GitPath $SeedGitPath
    if (-not $seedTopLevel) {
        return $false
    }

    $trackedPaths = @(git ls-files)
    $seedTrackedPaths = Get-PathsUnderTopLevelSegment -Paths $trackedPaths -TopLevelSegment $seedTopLevel
    return $seedTrackedPaths.Count -gt 0
}

$filesToCopy = @(
    ".github/copilot-instructions.md",
    "CLAUDE.md",
    "AGENTS.md",
    "ATLAS.md"
)

$promptRoot = Join-Path $templateRoot ".github/prompts"
if (Test-Path $promptRoot) {
    $promptFiles = Get-ChildItem -Path $promptRoot -Recurse -File | ForEach-Object {
        $_.FullName.Substring($templateRoot.Length + 1) -replace '\\', '/'
    }
    $filesToCopy += $promptFiles
}

$scaffoldFiles = @(
    "docs/agile/devcycle.md",
    "docs/agile/backlog.md",
    "docs/agile/status.md",
    "docs/agile/retro.md",
    "docs/projects/README.md",
    "docs/reference/README.md",
    "docs/reference/stack-patterns/README.md",
    "scripts/README.md",
    "archive/README.md"
)

# Discover skill folders and add all files within them
$skillsRoot = Join-Path $templateRoot ".github/skills"
if ($IncludeSkills -and -not $SkillsSource) {
    # Use default skills from the kit
    if (Test-Path $skillsRoot) {
        $skillFiles = Get-ChildItem -Path $skillsRoot -Recurse -File | ForEach-Object {
            $_.FullName.Substring($templateRoot.Length + 1) -replace '\\', '/'
        }
        $scaffoldFiles += $skillFiles
    }
} elseif ($SkillsSource) {
    # Copy skills from an external location
    $resolvedSkillsSource = [System.IO.Path]::GetFullPath($SkillsSource)
    if (Test-Path $resolvedSkillsSource) {
        $skillsDest = Join-Path $resolvedTargetRoot ".github/skills"
        if (-not (Test-Path $skillsDest)) {
            New-Item -ItemType Directory -Path $skillsDest -Force | Out-Null
        }
        if ($PSCmdlet.ShouldProcess($skillsDest, "Copy skills from $resolvedSkillsSource")) {
            Copy-Item -Path "$resolvedSkillsSource\*" -Destination $skillsDest -Recurse -Force:$Force
            Write-Host "Copied skills from $resolvedSkillsSource"
        }
    } else {
        Write-Warning "Skills source not found: $resolvedSkillsSource"
    }
}

if ($IncludeCGR) {
    $filesToCopy += "CGR.md"
}

if ($IncludePS) {
    $filesToCopy += "PS.md"
}

if ($IncludePS -or $IncludeCGR) {
    $filesToCopy += @(
        "docs/projects/MRD_TEMPLATE.md",
        "docs/projects/PRD_TEMPLATE.md",
        "docs/projects/ESD_TEMPLATE.md"
    )
}

if ($IncludeScaffold) {
    $filesToCopy += $scaffoldFiles
}

$organizeResult = $null
if ($OrganizeExisting) {
    $organizeResult = Move-ExistingArtifacts -RootPath $resolvedTargetRoot -SeedPath $resolvedSeedPath
}

foreach ($relativePath in $filesToCopy) {
    $sourcePath = Join-Path $templateRoot $relativePath
    $destinationPath = Join-Path $resolvedTargetRoot $relativePath
    $destinationDir = Split-Path -Parent $destinationPath

    if (-not (Test-Path $sourcePath)) {
        Write-Warning "Skipping missing source file: $sourcePath"
        continue
    }

    if (-not (Test-Path $destinationDir)) {
        New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
    }

    if ((Test-Path $destinationPath) -and -not $Force) {
        Write-Warning "Skipping existing file: $destinationPath. Use -Force to overwrite."
        continue
    }

    if ($PSCmdlet.ShouldProcess($destinationPath, "Copy ntelio_ai file")) {
        Copy-Item -Path $sourcePath -Destination $destinationPath -Force:$Force
        Write-Host "Copied $relativePath"
    }
}

# --- Git initialization ---
if ($InitGit -or $GitHubRepo) {
    $gitAvailable = Get-Command git -ErrorAction SilentlyContinue
    if (-not $gitAvailable) {
        Write-Error "git is not installed or not on PATH. Install git first."
        return
    }

    Push-Location $resolvedTargetRoot
    try {
        # Copy .gitignore if source exists
        $gitignoreSrc = Join-Path $templateRoot ".gitignore"
        $gitignoreDst = Join-Path $resolvedTargetRoot ".gitignore"
        if (Test-Path $gitignoreSrc) {
            if (-not (Test-Path $gitignoreDst) -or $Force) {
                if ($PSCmdlet.ShouldProcess($gitignoreDst, "Copy .gitignore")) {
                    Copy-Item -Path $gitignoreSrc -Destination $gitignoreDst -Force:$Force
                    Write-Host "Copied .gitignore"
                }
            } else {
                Write-Warning "Skipping existing .gitignore. Use -Force to overwrite."
            }
        }

        # Initialize git repo if needed
        $isGitRepo = Test-Path (Join-Path $resolvedTargetRoot ".git")
        if (-not $isGitRepo) {
            if ($PSCmdlet.ShouldProcess($resolvedTargetRoot, "Initialize git repository")) {
                git init 2>&1 | Out-Null
                Write-Host "Initialized git repository."
            }
        } else {
            Write-Host "Git repository already initialized."
        }

        # Stage and commit if there are changes
        if ($PSCmdlet.ShouldProcess("all files", "Stage and commit initial files")) {
            git add -A 2>&1 | Out-Null
            if ($seedGitPath) {
                Remove-SeedChangesFromIndex -SeedGitPath $seedGitPath
            }
            $status = git status --porcelain
            if ($status) {
                git commit -m "chore: initialize project artifacts" 2>&1 | Out-Null
                Write-Host "Created initial commit."
            } else {
                Write-Host "No changes to commit."
            }
        }
    } finally {
        Pop-Location
    }
}

# --- GitHub repository creation ---
if ($GitHubRepo) {
    $ghAvailable = Get-Command gh -ErrorAction SilentlyContinue
    if (-not $ghAvailable) {
        Write-Error "GitHub CLI (gh) is not installed. Install it from https://cli.github.com/ and run 'gh auth login'."
        return
    }

    Push-Location $resolvedTargetRoot
    try {
        $visibility = if ($Public) { "--public" } else { "--private" }
        if ($PSCmdlet.ShouldProcess($GitHubRepo, "Create GitHub repository ($visibility)")) {
            # Check auth status before attempting repo creation
            $authStatus = gh auth status 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Error "GitHub CLI is not authenticated. Run 'gh auth login' first. gh output: $authStatus"
                return
            }

            $output = gh repo create $GitHubRepo $visibility --source . --push 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Error "Failed to create GitHub repository. gh output: $output"
                Write-Host "The local git repository was still created successfully. You can create the GitHub repo manually or retry later."
            } else {
                Write-Host "Created GitHub repository: $GitHubRepo"
            }
        }
    } finally {
        Pop-Location
    }
}

Write-Host "ntelio_ai install complete."
Write-Host "Target root: $resolvedTargetRoot"

if ($RemoveSeed -and $resolvedSeedPath) {
    $seedCleanupAllowed = $true
    if ($seedGitPath -and (Test-Path (Join-Path $resolvedTargetRoot ".git"))) {
        Push-Location $resolvedTargetRoot
        try {
            if (Test-SeedTrackedInIndex -SeedGitPath $seedGitPath) {
                $seedCleanupAllowed = $false
            }
        } finally {
            Pop-Location
        }
    }

    if ($seedCleanupAllowed) {
        Start-SeedCleanup -PathToRemove $resolvedSeedPath
        Write-Host "Seed cleanup scheduled: $resolvedSeedPath"
    } else {
        Write-Warning "Seed cleanup skipped because that seed path is currently tracked by git."
        Write-Warning "Keeping it avoids staging seed-folder deletions in unrelated commits."
    }
}

if ($organizeResult) {
    $startupReferenceFiles = @($organizeResult.StartupReferenceFiles)
    if ($startupReferenceFiles.Count -gt 0) {
        Write-Host ""
        Write-Host "Startup-oriented files were moved into docs/reference:"
        foreach ($startupFile in $startupReferenceFiles) {
            Write-Host " - $startupFile"
        }
        Write-Host "After seed cleanup is complete, ask your AI agent whether it should build an initial devcycle from these reference files."
    }
}

# --- Post-install verification ---
if ($Verify) {
    Write-Host ""
    Write-Host "Verifying installation ..."
    $missing = @()
    foreach ($relativePath in $filesToCopy) {
        $checkPath = Join-Path $resolvedTargetRoot $relativePath
        if (-not (Test-Path $checkPath)) {
            $missing += $relativePath
        }
    }
    if ($missing.Count -gt 0) {
        Write-Warning "Missing files:"
        foreach ($f in $missing) { Write-Warning "  $f" }
    } else {
        Write-Host "All expected files present."
    }

    # Validate SKILL.md frontmatter if skills were installed
    $skillsDir = Join-Path $resolvedTargetRoot ".github/skills"
    if (Test-Path $skillsDir) {
        $skillFiles = Get-ChildItem -Path $skillsDir -Filter "SKILL.md" -Recurse
        foreach ($sf in $skillFiles) {
            $content = Get-Content $sf.FullName -Raw
            if ($content -notmatch '(?m)^---') {
                Write-Warning "Missing YAML frontmatter: $($sf.FullName)"
            }
        }
    }
}