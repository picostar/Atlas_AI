[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$TargetRoot = "..",
    [switch]$IncludeCGR,
    [switch]$IncludePS,
    [switch]$IncludeScaffold,
    [switch]$IncludeSkills,
    [string]$SkillsSource,
    [string]$StackPattern,
    [switch]$InitGit,
    [string]$GitHubRepo,
    [string]$GitHubOwner,
    [switch]$Public,
    [switch]$Verify,
    [string]$UxPattern,
    [switch]$ApiFirst,
    [switch]$NoApiFirst
)

$templateRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
if ([System.IO.Path]::IsPathRooted($TargetRoot)) {
    $resolvedTargetRoot = [System.IO.Path]::GetFullPath($TargetRoot)
} else {
    $resolvedTargetRoot = [System.IO.Path]::GetFullPath((Join-Path $templateRoot $TargetRoot))
}
$installerGitPath = $null
$targetRootWithSeparator = $resolvedTargetRoot.TrimEnd('\') + '\'
if ($templateRoot.StartsWith($targetRootWithSeparator, [System.StringComparison]::OrdinalIgnoreCase)) {
    $installerGitPath = $templateRoot.Substring($targetRootWithSeparator.Length) -replace '\\', '/'
}

$apiFirstEnabled = $true
if ($NoApiFirst) {
    $apiFirstEnabled = $false
} elseif ($ApiFirst) {
    $apiFirstEnabled = $true
}

if ($GitHubRepo -and [string]::IsNullOrWhiteSpace($GitHubOwner)) {
    throw "GitHubOwner is required when GitHubRepo is specified. Provide the GitHub username or organization that should own the new repository."
}

function Get-InstallerTopLevelSegment {
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

function New-AccountsFile {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath
    )

    $sourcePath = Join-Path $templateRoot "accounts.md"
    $accountsPath = Join-Path $RootPath "accounts.md"
    if (-not (Test-Path -LiteralPath $sourcePath)) {
        Write-Warning "accounts.md template not found: $sourcePath"
        return
    }

    if (Test-Path -LiteralPath $accountsPath) {
        return
    }

    if ($PSCmdlet.ShouldProcess($accountsPath, "Create project accounts.md")) {
        Copy-Item -LiteralPath $sourcePath -Destination $accountsPath
        Write-Host "Set project accounts file: accounts.md"
    }
}

function Get-PathsUnderTopLevelSegment {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Paths,
        [Parameter(Mandatory = $true)]
        [string]$TopLevelSegment
    )

    $matchingPaths = @()
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
            $matchingPaths += $path
        }
    }

    return $matchingPaths
}

function Get-ExistingAtlasInstallMarkers {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath,
        [string]$InstallerPath
    )

    if (-not (Test-Path -LiteralPath $RootPath)) {
        return @()
    }

    $normalizedInstallerPath = $null
    if ($InstallerPath) {
        $normalizedInstallerPath = $InstallerPath.TrimEnd('\')
    }

    $markerPaths = @(
        'ATLAS.md',
        '.github/copilot-instructions.md',
        'docs/agile/devcycle.md',
        'docs/agile/backlog.md',
        'docs/agile/status.md',
        'docs/agile/retro.md'
    )

    $existingMarkers = @()
    foreach ($markerPath in $markerPaths) {
        $fullPath = Join-Path $RootPath $markerPath
        if (-not (Test-Path -LiteralPath $fullPath)) {
            continue
        }

        if ($normalizedInstallerPath -and $fullPath.TrimEnd('\').Equals($normalizedInstallerPath, [System.StringComparison]::OrdinalIgnoreCase)) {
            continue
        }

        $existingMarkers += $markerPath
    }

    return $existingMarkers
}

function Get-PreExistingUserItems {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath,
        [string]$InstallerPath
    )

    if (-not (Test-Path -LiteralPath $RootPath)) {
        return @()
    }

    $allowedNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    @('.git', '.gitignore', '.gitattributes', '.gitmodules', '.git-blame-ignore-revs') | ForEach-Object {
        $null = $allowedNames.Add($_)
    }

    $normalizedInstallerPath = $null
    if ($InstallerPath) {
        $normalizedInstallerPath = $InstallerPath.TrimEnd('\')
    }

    $items = Get-ChildItem -LiteralPath $RootPath -Force -ErrorAction SilentlyContinue
    $movableItems = @()
    foreach ($item in $items) {
        if ($allowedNames.Contains($item.Name)) {
            continue
        }

        if ($normalizedInstallerPath -and $item.FullName.TrimEnd('\').Equals($normalizedInstallerPath, [System.StringComparison]::OrdinalIgnoreCase)) {
            continue
        }

        $movableItems += $item
    }

    return $movableItems
}

function Get-AvailablePath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$BasePath
    )

    if (-not (Test-Path -LiteralPath $BasePath)) {
        return $BasePath
    }

    $suffix = 2
    while ($true) {
        $candidatePath = "$BasePath-$suffix"
        if (-not (Test-Path -LiteralPath $candidatePath)) {
            return $candidatePath
        }

        $suffix++
    }
}

function Stage-PreExistingReferenceItems {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath,
        [string]$InstallerPath
    )

    $movableItems = @(Get-PreExistingUserItems -RootPath $RootPath -InstallerPath $InstallerPath)
    if ($movableItems.Count -eq 0) {
        return $null
    }

    $stagingPath = Get-AvailablePath -BasePath (Join-Path $RootPath '.atlas_ai-preexisting-reference')
    if (-not (Test-Path -LiteralPath $stagingPath)) {
        New-Item -ItemType Directory -Path $stagingPath -Force | Out-Null
    }

    foreach ($item in $movableItems) {
        $destinationPath = Join-Path $stagingPath $item.Name
        if ($PSCmdlet.ShouldProcess($item.FullName, "Move pre-existing user material into atlas_ai staging")) {
            Move-Item -LiteralPath $item.FullName -Destination $destinationPath
            Write-Host "Staged pre-existing user material: $($item.Name)"
        }
    }

    return $stagingPath
}

function Finalize-PreExistingReferenceItems {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath,
        [string]$StagingPath
    )

    if ([string]::IsNullOrWhiteSpace($StagingPath) -or -not (Test-Path -LiteralPath $StagingPath)) {
        return $null
    }

    $referenceRoot = Join-Path $RootPath 'docs/reference'
    if (-not (Test-Path -LiteralPath $referenceRoot)) {
        New-Item -ItemType Directory -Path $referenceRoot -Force | Out-Null
    }

    $referenceImportPath = Get-AvailablePath -BasePath (Join-Path $referenceRoot 'preexisting-root')
    if (-not (Test-Path -LiteralPath $referenceImportPath)) {
        New-Item -ItemType Directory -Path $referenceImportPath -Force | Out-Null
    }

    $stagedItems = Get-ChildItem -LiteralPath $StagingPath -Force -ErrorAction SilentlyContinue
    foreach ($item in $stagedItems) {
        $destinationPath = Join-Path $referenceImportPath $item.Name
        if ($PSCmdlet.ShouldProcess($item.FullName, "Move pre-existing user material into docs/reference")) {
            Move-Item -LiteralPath $item.FullName -Destination $destinationPath
            Write-Host "Preserved pre-existing user material in docs/reference: $($item.Name)"
        }
    }

    if ($PSCmdlet.ShouldProcess($StagingPath, 'Remove temporary atlas_ai staging folder')) {
        Remove-Item -LiteralPath $StagingPath -Recurse -Force -ErrorAction SilentlyContinue
    }

    return $referenceImportPath
}

function Resolve-StackPatternRelativePath {
    param(
        [string]$PatternValue
    )

    if ([string]::IsNullOrWhiteSpace($PatternValue)) {
        return $null
    }

    $normalizedValue = ($PatternValue.Trim() -replace '\\', '/').Trim('/')
    if ([string]::IsNullOrWhiteSpace($normalizedValue)) {
        return $null
    }

    if ($normalizedValue -match '^(none|no|null|skip)$') {
        return $null
    }

    $candidates = [System.Collections.Generic.List[string]]::new()
    $candidates.Add($normalizedValue)
    if (-not $normalizedValue.StartsWith("patterns/stack-patterns/stack-pattern-templates/", [System.StringComparison]::OrdinalIgnoreCase)) {
        $candidates.Add("patterns/stack-patterns/stack-pattern-templates/$normalizedValue")
    }

    foreach ($candidate in ($candidates | Select-Object -Unique)) {
        $candidatePath = Join-Path $templateRoot $candidate
        if (Test-Path -LiteralPath $candidatePath) {
            return $candidate
        }
    }

    Write-Warning "Stack pattern template not found: $PatternValue"
    return $null
}

function Resolve-UxPatternRelativePath {
    param(
        [string]$PatternValue
    )

    if ([string]::IsNullOrWhiteSpace($PatternValue)) {
        return $null
    }

    $normalizedValue = ($PatternValue.Trim() -replace '\\', '/').Trim('/')
    if ([string]::IsNullOrWhiteSpace($normalizedValue)) {
        return $null
    }

    if ($normalizedValue -match '^(none|no|null|skip)$') {
        return $null
    }

    $candidates = [System.Collections.Generic.List[string]]::new()
    $candidates.Add($normalizedValue)
    if (-not $normalizedValue.StartsWith("patterns/ux-patterns/ux-pattern-templates/", [System.StringComparison]::OrdinalIgnoreCase)) {
        $candidates.Add("patterns/ux-patterns/ux-pattern-templates/$normalizedValue")
    }

    foreach ($candidate in ($candidates | Select-Object -Unique)) {
        $candidatePath = Join-Path $templateRoot $candidate
        if (Test-Path -LiteralPath $candidatePath) {
            return $candidate
        }
    }

    Write-Warning "UX pattern template not found: $PatternValue"
    return $null
}

function Add-StackPatternApiFirstPosture {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackPatternPath,
        [Parameter(Mandatory = $true)]
        [bool]$Enabled
    )

    if (-not (Test-Path -LiteralPath $StackPatternPath)) {
        return
    }

    $status = if ($Enabled) { "Enabled" } else { "Disabled" }
    $expectation = if ($Enabled) {
        "DTs or RDTs should include an API result when feasible, and smoketests should verify endpoints plus OpenAPI or Swagger docs when feasible."
    } else {
        "API-first outputs are not required by default. API work remains allowed when the task calls for it."
    }
    $section = @(
        "",
        "## API Posture",
        "- API-first mode: $status",
        "- Delivery expectation: $expectation"
    ) -join [Environment]::NewLine

    if ($PSCmdlet.ShouldProcess($StackPatternPath, "Set API-first posture in active stack pattern")) {
        Add-Content -Path $StackPatternPath -Value $section -Encoding UTF8
        Write-Host "Set API-first posture in active stack pattern"
    }
}

function New-LocalSecretsFile {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath
    )

    $secretsPath = Join-Path $RootPath "secrets.md"
    if (Test-Path -LiteralPath $secretsPath) {
        return
    }

    $content = @(
        "# Local Secrets",
        "",
        "Store local secrets here.",
        "",
        "- This file is local-only and should not be committed.",
        "- This file should be ignored by git via .gitignore.",
        "- Do not copy secret values into any other repository file."
    ) -join [Environment]::NewLine

    if ($PSCmdlet.ShouldProcess($secretsPath, "Create local secrets.md")) {
        Set-Content -Path $secretsPath -Value $content -Encoding UTF8
        Write-Host "Created local secrets file: secrets.md"
    }
}

function Remove-InstallerChangesFromIndex {
    param(
        [Parameter(Mandatory = $true)]
        [string]$InstallerGitPath
    )

    $installerTopLevel = Get-InstallerTopLevelSegment -GitPath $InstallerGitPath
    if (-not $installerTopLevel) {
        return
    }

    $headExists = $false
    git rev-parse --verify HEAD 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        $headExists = $true
    }

    $stagedPaths = @(git diff --cached --name-only)
    $installerStagedPaths = Get-PathsUnderTopLevelSegment -Paths $stagedPaths -TopLevelSegment $installerTopLevel

    foreach ($stagedPath in $installerStagedPaths) {
        if ($headExists) {
            git reset -q HEAD -- "$stagedPath" 2>&1 | Out-Null
        } else {
            git rm -r -f --cached --ignore-unmatch -- "$stagedPath" 2>&1 | Out-Null
        }
    }
}

if (-not (Test-Path -LiteralPath $resolvedTargetRoot)) {
    if ($PSCmdlet.ShouldProcess($resolvedTargetRoot, "Create new project target folder")) {
        New-Item -ItemType Directory -Path $resolvedTargetRoot -Force | Out-Null
    }
}

$existingAtlasMarkers = @(Get-ExistingAtlasInstallMarkers -RootPath $resolvedTargetRoot -InstallerPath $templateRoot)
if ($existingAtlasMarkers.Count -gt 0) {
    throw "Target already contains Atlas project control files: $($existingAtlasMarkers -join ', '). Use atlas_update.md from the kit for a plan-first legacy project update instead of atlas_ai.ps1."
}

$stagedReferenceItemsPath = Stage-PreExistingReferenceItems -RootPath $resolvedTargetRoot -InstallerPath $templateRoot

$filesToCopy = @(
    ".github/copilot-instructions.md",
    ".github/TOOLING-ASSUMPTIONS.md",
    ".github/TOOL-CAPABILITY-MATRIX.md",
    ".github/FRONTMATTER-SCHEMA.md",
    ".github/INSTRUCTION-MAINTENANCE.md",
    "CLAUDE.md",
    "CHATGPT.md",
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
    "docs/cgr/README.md",
    "docs/reference/README.md",
    "patterns/README.md",
    "patterns/stack-patterns/README.md",
    "patterns/ux-patterns/README.md",
    "scripts/README.md",
    "archive/README.md"
)

$stackPatternTemplateRoot = Join-Path $templateRoot "patterns/stack-patterns/stack-pattern-templates"
if (Test-Path $stackPatternTemplateRoot) {
    $stackPatternTemplateFiles = Get-ChildItem -Path $stackPatternTemplateRoot -Recurse -File | ForEach-Object {
        $_.FullName.Substring($templateRoot.Length + 1) -replace '\\', '/'
    }
    $scaffoldFiles += $stackPatternTemplateFiles
}

$uxPatternTemplateRoot = Join-Path $templateRoot "patterns/ux-patterns/ux-pattern-templates"
if (Test-Path $uxPatternTemplateRoot) {
    $uxPatternTemplateFiles = Get-ChildItem -Path $uxPatternTemplateRoot -Recurse -File | ForEach-Object {
        $_.FullName.Substring($templateRoot.Length + 1) -replace '\\', '/'
    }
    $scaffoldFiles += $uxPatternTemplateFiles
}

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
            Copy-Item -Path "$resolvedSkillsSource\*" -Destination $skillsDest -Recurse
            Write-Host "Copied skills from $resolvedSkillsSource"
        }
    } else {
        Write-Warning "Skills source not found: $resolvedSkillsSource"
    }
}

if ($IncludePS) {
    $filesToCopy += "docs/cgr/PS.md"
}

if ($IncludePS -or $IncludeCGR) {
    $filesToCopy += @(
        "docs/cgr/MRD_TEMPLATE.md",
        "docs/cgr/PRD_TEMPLATE.md",
        "docs/cgr/ESD_TEMPLATE.md"
    )
}

if ($IncludeScaffold) {
    $filesToCopy += $scaffoldFiles
}

$resolvedStackPatternTemplate = Resolve-StackPatternRelativePath -PatternValue $StackPattern
$resolvedUxPatternTemplate = Resolve-UxPatternRelativePath -PatternValue $UxPattern

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

    if (Test-Path $destinationPath) {
        Write-Warning "Skipping existing file: $destinationPath. This installer does not overwrite existing project files."
        continue
    }

    if ($PSCmdlet.ShouldProcess($destinationPath, "Copy atlas_ai file")) {
        Copy-Item -Path $sourcePath -Destination $destinationPath
        Write-Host "Copied $relativePath"
    }
}

if ($resolvedStackPatternTemplate) {
    $selectedStackPatternSource = Join-Path $templateRoot $resolvedStackPatternTemplate
    $activeStackPatternPath = Join-Path $resolvedTargetRoot "patterns/stack-patterns/active-stack-pattern.md"
    $activeStackPatternDirectory = Split-Path -Parent $activeStackPatternPath

    if (-not (Test-Path $activeStackPatternDirectory)) {
        New-Item -ItemType Directory -Path $activeStackPatternDirectory -Force | Out-Null
    }

    if (Test-Path $activeStackPatternPath) {
        Write-Warning "Skipping existing file: $activeStackPatternPath. This installer does not overwrite existing project files."
    } else {
        if ($PSCmdlet.ShouldProcess($activeStackPatternPath, "Set active stack pattern from $resolvedStackPatternTemplate")) {
            Copy-Item -Path $selectedStackPatternSource -Destination $activeStackPatternPath
            Write-Host "Set active stack pattern from $resolvedStackPatternTemplate"
            Add-StackPatternApiFirstPosture -StackPatternPath $activeStackPatternPath -Enabled $apiFirstEnabled
        }
    }
}

if ($resolvedUxPatternTemplate) {
    $selectedUxPatternSource = Join-Path $templateRoot $resolvedUxPatternTemplate
    $activeUxPatternPath = Join-Path $resolvedTargetRoot "patterns/ux-patterns/active-ux-pattern.md"
    $activeUxPatternDirectory = Split-Path -Parent $activeUxPatternPath

    if (-not (Test-Path $activeUxPatternDirectory)) {
        New-Item -ItemType Directory -Path $activeUxPatternDirectory -Force | Out-Null
    }

    if (Test-Path $activeUxPatternPath) {
        Write-Warning "Skipping existing file: $activeUxPatternPath. This installer does not overwrite existing project files."
    } else {
        if ($PSCmdlet.ShouldProcess($activeUxPatternPath, "Set active UX pattern from $resolvedUxPatternTemplate")) {
            Copy-Item -Path $selectedUxPatternSource -Destination $activeUxPatternPath
            Write-Host "Set active UX pattern from $resolvedUxPatternTemplate"
        }
    }
}

if ($IncludeScaffold) {
    New-AccountsFile -RootPath $resolvedTargetRoot
    New-LocalSecretsFile -RootPath $resolvedTargetRoot
}

$referenceImportPath = Finalize-PreExistingReferenceItems -RootPath $resolvedTargetRoot -StagingPath $stagedReferenceItemsPath
if ($referenceImportPath) {
    Write-Host "Pre-existing user material preserved under: $referenceImportPath"
}

# --- Git initialization ---
if ($InitGit -or $GitHubRepo) {
    $gitAvailable = Get-Command git -ErrorAction SilentlyContinue
    if (-not $gitAvailable) {
        throw "git is not installed or not on PATH. Install git first."
    }

    Push-Location $resolvedTargetRoot
    try {
        # Copy .gitignore if source exists
        $gitignoreSrc = Join-Path $templateRoot ".gitignore"
        $gitignoreDst = Join-Path $resolvedTargetRoot ".gitignore"
        if (Test-Path $gitignoreSrc) {
            if (-not (Test-Path $gitignoreDst)) {
                if ($PSCmdlet.ShouldProcess($gitignoreDst, "Copy .gitignore")) {
                    Copy-Item -Path $gitignoreSrc -Destination $gitignoreDst
                    Write-Host "Copied .gitignore"
                }
            } else {
                Write-Warning "Skipping existing .gitignore. This installer does not overwrite existing project files."
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
            Write-Host "Adopting existing git repository."
        }

        # Stage and commit if there are changes
        if ($PSCmdlet.ShouldProcess("all files", "Stage and commit initial files")) {
            git add -A 2>&1 | Out-Null
            if ($installerGitPath) {
                Remove-InstallerChangesFromIndex -InstallerGitPath $installerGitPath
            }
            $status = git status --porcelain
            if ($status) {
                $commitMessage = if ($isGitRepo) { "chore: install atlas_ai project artifacts" } else { "chore: initialize project artifacts" }
                git commit -m $commitMessage 2>&1 | Out-Null
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
        throw "GitHub CLI (gh) is not installed. Install it from https://cli.github.com/ and try again."
    }

    # Ensure the user is authenticated -- prompt for login if not
    gh auth status 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "GitHub CLI is not authenticated. Launching login flow..."
        gh auth login
        if ($LASTEXITCODE -ne 0) {
            throw "GitHub login failed or was cancelled. The local git repository was still created successfully. You can create the GitHub repo manually or retry later."
        }
    }

    $fullRepoName = "$GitHubOwner/$GitHubRepo"

    Push-Location $resolvedTargetRoot
    try {
        $visibility = if ($Public) { "--public" } else { "--private" }
        if ($PSCmdlet.ShouldProcess($fullRepoName, "Create GitHub repository ($visibility)")) {
            $output = gh repo create $fullRepoName $visibility --source . --push 2>&1
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to create GitHub repository '$fullRepoName'. gh output: $output The local git repository was still created successfully. You can create the GitHub repo manually or retry later."
            } else {
                Write-Host "Created GitHub repository: $fullRepoName"
            }
        }
    } finally {
        Pop-Location
    }
}

Write-Host "atlas_ai install complete."
Write-Host "Target root: $resolvedTargetRoot"

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
    if ($IncludeScaffold) {
        $accountsCheckPath = Join-Path $resolvedTargetRoot "accounts.md"
        if (-not (Test-Path $accountsCheckPath)) {
            $missing += "accounts.md"
        }
        $secretsCheckPath = Join-Path $resolvedTargetRoot "secrets.md"
        if (-not (Test-Path $secretsCheckPath)) {
            $missing += "secrets.md"
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
