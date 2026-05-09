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
    Write-Error "GitHubOwner is required when GitHubRepo is specified. Provide the GitHub username or organization that should own the new repository."
    return
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

function Get-NonNewProjectItems {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath,
        [string]$InstallerPath
    )

    if (-not (Test-Path -LiteralPath $RootPath)) {
        return @()
    }

    $allowedNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    @('.git', '.gitignore', '.gitattributes') | ForEach-Object {
        $null = $allowedNames.Add($_)
    }

    $normalizedInstallerPath = $null
    if ($InstallerPath) {
        $normalizedInstallerPath = $InstallerPath.TrimEnd('\')
    }

    $items = Get-ChildItem -LiteralPath $RootPath -Force -ErrorAction SilentlyContinue
    $blockingItems = @()
    foreach ($item in $items) {
        if ($allowedNames.Contains($item.Name)) {
            continue
        }

        if ($normalizedInstallerPath -and $item.FullName.TrimEnd('\').Equals($normalizedInstallerPath, [System.StringComparison]::OrdinalIgnoreCase)) {
            continue
        }

        $blockingItems += $item.Name
    }

    return $blockingItems
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

function Write-ApiFirstPolicyFile {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath,
        [Parameter(Mandatory = $true)]
        [bool]$Enabled
    )

    $policyPath = Join-Path $RootPath "docs/reference/api-first-policy.md"
    $policyDirectory = Split-Path -Parent $policyPath

    if (-not (Test-Path -LiteralPath $policyDirectory)) {
        New-Item -ItemType Directory -Path $policyDirectory -Force | Out-Null
    }

    if (Test-Path -LiteralPath $policyPath) {
        Write-Warning "Skipping existing file: $policyPath. This installer does not overwrite existing project files."
        return
    }

    $status = if ($Enabled) { "Enabled" } else { "Disabled" }
    $generatedDate = (Get-Date -Format "yyyy-MM-dd")
    $content = @(
        "# API-First Policy",
        "",
        "This file records API-first setup intent for this repository.",
        "",
        "- Generated by atlas_ai installer: $generatedDate",
        "- API-first mode: $status",
        "- Default: Enabled",
        "",
        "## Policy",
        "",
        "- When API-first mode is enabled, each DT or RDT should include an API result when feasible.",
        "- When API output is in scope, Smoketest should verify endpoints and OpenAPI or Swagger documentation when feasible.",
        "- If API-first mode is disabled, API work is still allowed when the task requires it.",
        "",
        "## Notes",
        "",
        "- This policy file is not a place for secrets.",
        "- Store local secrets only in secrets.md at repository root, which should stay gitignored.",
        "- Store non-secret cloud account and deployment destination binding in accounts.md at repository root."
    ) -join [Environment]::NewLine

    if ($PSCmdlet.ShouldProcess($policyPath, "Write API-first policy file")) {
        Set-Content -Path $policyPath -Value $content -Encoding UTF8
        Write-Host "Set API-first policy file: docs/reference/api-first-policy.md"
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

$blockingItems = @(Get-NonNewProjectItems -RootPath $resolvedTargetRoot -InstallerPath $templateRoot)
if ($blockingItems.Count -gt 0) {
    Write-Error "Target does not look like a new project. Found existing top-level item(s): $($blockingItems -join ', '). Use .github/prompts/atlas-update.prompt.md from the kit for a plan-first legacy project update instead of atlas_ai.ps1."
    return
}

$filesToCopy = @(
    ".github/copilot-instructions.md",
    ".github/TOOLING-ASSUMPTIONS.md",
    ".github/TOOL-CAPABILITY-MATRIX.md",
    ".github/FRONTMATTER-SCHEMA.md",
    ".github/INSTRUCTION-MAINTENANCE.md",
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
    Write-ApiFirstPolicyFile -RootPath $resolvedTargetRoot -Enabled $apiFirstEnabled
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
            Write-Host "Git repository already initialized."
        }

        # Stage and commit if there are changes
        if ($PSCmdlet.ShouldProcess("all files", "Stage and commit initial files")) {
            git add -A 2>&1 | Out-Null
            if ($installerGitPath) {
                Remove-InstallerChangesFromIndex -InstallerGitPath $installerGitPath
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
        Write-Error "GitHub CLI (gh) is not installed. Install it from https://cli.github.com/ and try again."
        return
    }

    # Ensure the user is authenticated -- prompt for login if not
    gh auth status 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "GitHub CLI is not authenticated. Launching login flow..."
        gh auth login
        if ($LASTEXITCODE -ne 0) {
            Write-Error "GitHub login failed or was cancelled. Skipping repo creation."
            Write-Host "The local git repository was still created successfully. You can create the GitHub repo manually or retry later."
            return
        }
    }

    $fullRepoName = "$GitHubOwner/$GitHubRepo"

    Push-Location $resolvedTargetRoot
    try {
        $visibility = if ($Public) { "--public" } else { "--private" }
        if ($PSCmdlet.ShouldProcess($fullRepoName, "Create GitHub repository ($visibility)")) {
            $output = gh repo create $fullRepoName $visibility --source . --push 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Error "Failed to create GitHub repository '$fullRepoName'. gh output: $output"
                Write-Host "The local git repository was still created successfully. You can create the GitHub repo manually or retry later."
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
        $apiPolicyCheckPath = Join-Path $resolvedTargetRoot "docs/reference/api-first-policy.md"
        if (-not (Test-Path $apiPolicyCheckPath)) {
            $missing += "docs/reference/api-first-policy.md"
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
