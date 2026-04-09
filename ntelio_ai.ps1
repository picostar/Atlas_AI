[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$TargetRoot = "..",
    [switch]$IncludeCGR,
    [switch]$IncludePS,
    [switch]$IncludeScaffold,
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
                git rm -r --cached --ignore-unmatch -- "$seedGitPath" 2>&1 | Out-Null
            }
            $status = git status --porcelain
            if ($status) {
                git commit -m "Initial commit with ntelio_ai" 2>&1 | Out-Null
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
                Write-Error "GitHub CLI is not authenticated. Run 'gh auth login' first."
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
    Start-SeedCleanup -PathToRemove $resolvedSeedPath
    Write-Host "Seed cleanup scheduled: $resolvedSeedPath"
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