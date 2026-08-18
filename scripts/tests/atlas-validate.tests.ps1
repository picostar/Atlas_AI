[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '../..')).Path
$validatorPath = Join-Path $repoRoot 'scripts/atlas-validate.ps1'
$manifestPath = Join-Path $repoRoot '.atlas/install-manifest.json'
$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
$failures = [System.Collections.Generic.List[string]]::new()
$fixtureRoots = [System.Collections.Generic.List[string]]::new()

function Assert-True {
    param(
        [bool]$Condition,
        [string]$Message
    )

    if (-not $Condition) {
        $failures.Add($Message)
    }
}

function Copy-RelativePath {
    param(
        [string]$RelativePath,
        [string]$DestinationRoot
    )

    $nativePath = $RelativePath.Replace('/', [IO.Path]::DirectorySeparatorChar)
    $source = Join-Path $repoRoot $nativePath
    $destination = Join-Path $DestinationRoot $nativePath
    $destinationParent = Split-Path -Parent $destination
    if (-not (Test-Path -LiteralPath $destinationParent)) {
        New-Item -ItemType Directory -Path $destinationParent -Force | Out-Null
    }
    Copy-Item -LiteralPath $source -Destination $destination -Force
}

function New-Answers {
    param(
        [bool]$Scaffold = $false,
        [bool]$InitializeGit = $false,
        [bool]$IncludePS = $false,
        [bool]$IncludeCGR = $false,
        [AllowNull()][string]$StackPattern = $null,
        [AllowNull()][Nullable[bool]]$ApiFirst = $null,
        [AllowNull()][string]$UxPattern = $null,
        [bool]$CreateGitHubRepository = $false
    )

    return [ordered]@{
        scaffold = $Scaffold
        initializeGit = $InitializeGit
        includePS = $IncludePS
        includeCGR = $IncludeCGR
        stackPattern = if ([string]::IsNullOrWhiteSpace($StackPattern)) { $null } else { $StackPattern }
        apiFirst = $ApiFirst
        uxPattern = if ([string]::IsNullOrWhiteSpace($UxPattern)) { $null } else { $UxPattern }
        createGitHubRepository = $CreateGitHubRepository
    }
}

function New-AtlasFixture {
    param(
        [System.Collections.IDictionary]$Answers,
        [string[]]$RelocatedRootEntries = @(),
        [string]$GitOutcome = 'skipped',
        [string]$GitHubOutcome = 'skipped'
    )

    $fixtureRoot = Join-Path ([IO.Path]::GetTempPath()) ("atlas-validator-$([guid]::NewGuid().ToString('N'))")
    New-Item -ItemType Directory -Path $fixtureRoot | Out-Null
    $fixtureRoots.Add($fixtureRoot)

    $groups = [System.Collections.Generic.List[string]]::new()
    $groups.Add('core')
    if ($Answers.scaffold) { $groups.Add('scaffold') }
    if ($Answers.includeCGR) { $groups.Add('cgr') }
    if ($Answers.includePS) { $groups.Add('ps') }

    $selectedStack = $null
    if (-not [string]::IsNullOrWhiteSpace([string]$Answers.stackPattern)) {
        $selectedStack = @($manifest.catalogs.stackPatterns | Where-Object id -eq $Answers.stackPattern)[0]
        if ($null -ne $selectedStack.group -and -not $groups.Contains([string]$selectedStack.group)) {
            $groups.Add([string]$selectedStack.group)
        }
    }

    $selectedUx = $null
    if (-not [string]::IsNullOrWhiteSpace([string]$Answers.uxPattern)) {
        $selectedUx = @($manifest.catalogs.uxPatterns | Where-Object id -eq $Answers.uxPattern)[0]
    }

    $copiedPaths = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach ($groupName in $groups) {
        $group = $manifest.groups.PSObject.Properties[$groupName].Value
        foreach ($relativePath in @($group.requiredPaths)) {
            if ($copiedPaths.Add([string]$relativePath)) {
                Copy-RelativePath -RelativePath ([string]$relativePath) -DestinationRoot $fixtureRoot
            }
        }
    }

    $secretsPath = Join-Path $fixtureRoot 'secrets.md'
    Set-Content -LiteralPath $secretsPath -Value '# Local Secrets' -Encoding utf8

    if ($Answers.initializeGit) {
        & git -C $fixtureRoot init --quiet
        if ($LASTEXITCODE -ne 0) {
            throw "Could not initialize fixture git repository: $fixtureRoot"
        }
    }

    if ($null -ne $selectedStack) {
        $sourceLines = Get-Content -LiteralPath (Join-Path $repoRoot $selectedStack.sourcePath)
        $activePath = Join-Path $fixtureRoot $selectedStack.destinationPath
        New-Item -ItemType Directory -Path (Split-Path -Parent $activePath) -Force | Out-Null
        $apiStatus = if ($Answers.apiFirst) { 'Enabled' } else { 'Disabled' }
        @($sourceLines[0], "Atlas Pattern ID: $($selectedStack.id)", "API-First: $apiStatus") + @($sourceLines | Select-Object -Skip 1) |
            Set-Content -LiteralPath $activePath -Encoding utf8
    }

    if ($null -ne $selectedUx) {
        $sourceLines = Get-Content -LiteralPath (Join-Path $repoRoot $selectedUx.sourcePath)
        $activePath = Join-Path $fixtureRoot $selectedUx.destinationPath
        New-Item -ItemType Directory -Path (Split-Path -Parent $activePath) -Force | Out-Null
        @($sourceLines[0], "Atlas Pattern ID: $($selectedUx.id)") + @($sourceLines | Select-Object -Skip 1) |
            Set-Content -LiteralPath $activePath -Encoding utf8
    }

    foreach ($relativePath in $RelocatedRootEntries) {
        $preservedPath = Join-Path $fixtureRoot "docs/reference/preexisting-root/$relativePath"
        New-Item -ItemType Directory -Path (Split-Path -Parent $preservedPath) -Force | Out-Null
        Set-Content -LiteralPath $preservedPath -Value 'preserved fixture content' -Encoding utf8
    }

    $receipt = [ordered]@{
        schemaVersion = 1
        manifestVersion = $manifest.manifestVersion
        source = [ordered]@{
            repository = 'picostar/Atlas_AI'
            revision = 'fixture-revision'
        }
        answers = $Answers
        relocatedRootEntries = @($RelocatedRootEntries)
        outcomes = [ordered]@{
            git = $GitOutcome
            github = $GitHubOutcome
        }
    }
    $receiptPath = Join-Path $fixtureRoot '.atlas/setup.json'
    $receipt | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $receiptPath -Encoding utf8

    return $fixtureRoot
}

function Invoke-AtlasValidator {
    param(
        [string]$FixtureRoot,
        [switch]$SourceKit
    )

    $arguments = @('-NoProfile', '-File', $validatorPath, '-TargetPath', $FixtureRoot)
    if ($SourceKit) { $arguments += '-SourceKit' }
    $output = & pwsh @arguments 2>&1 | Out-String
    return [pscustomobject]@{
        ExitCode = $LASTEXITCODE
        Output = $output
    }
}

function Assert-ValidatorPasses {
    param(
        [string]$FixtureRoot,
        [string]$CaseName
    )

    $result = Invoke-AtlasValidator -FixtureRoot $FixtureRoot
    Assert-True -Condition ($result.ExitCode -eq 0) -Message "$CaseName should pass. Output: $($result.Output)"
}

function Assert-ValidatorFails {
    param(
        [string]$FixtureRoot,
        [string]$ExpectedText,
        [string]$CaseName
    )

    $result = Invoke-AtlasValidator -FixtureRoot $FixtureRoot
    Assert-True -Condition ($result.ExitCode -ne 0) -Message "$CaseName should fail."
    Assert-True -Condition ($result.Output -match [regex]::Escape($ExpectedText)) -Message "$CaseName should report '$ExpectedText'. Output: $($result.Output)"
}

try {
    $sourceResult = Invoke-AtlasValidator -FixtureRoot $repoRoot -SourceKit
    Assert-True -Condition ($sourceResult.ExitCode -eq 0) -Message "Source-kit validation should pass. Output: $($sourceResult.Output)"

    $defaultFixture = New-AtlasFixture -Answers (New-Answers -Scaffold $true -InitializeGit $true) -GitOutcome initialized
    Assert-ValidatorPasses -FixtureRoot $defaultFixture -CaseName 'Default setup'

    $minimalFixture = New-AtlasFixture -Answers (New-Answers)
    Assert-ValidatorPasses -FixtureRoot $minimalFixture -CaseName 'Minimal setup'

    $governanceFixture = New-AtlasFixture -Answers (New-Answers -IncludePS $true -IncludeCGR $true -CreateGitHubRepository $true) -GitHubOutcome blocked
    Assert-ValidatorPasses -FixtureRoot $governanceFixture -CaseName 'PS, CGR, and GitHub setup'

    foreach ($stackPattern in $manifest.catalogs.stackPatterns) {
        $fixture = New-AtlasFixture -Answers (New-Answers -StackPattern $stackPattern.id -ApiFirst $true)
        Assert-ValidatorPasses -FixtureRoot $fixture -CaseName "Stack catalog entry $($stackPattern.id)"
    }

    foreach ($uxPattern in $manifest.catalogs.uxPatterns) {
        $fixture = New-AtlasFixture -Answers (New-Answers -UxPattern $uxPattern.id)
        Assert-ValidatorPasses -FixtureRoot $fixture -CaseName "UX catalog entry $($uxPattern.id)"
    }

    $combinedFixture = New-AtlasFixture -Answers (New-Answers -StackPattern $manifest.catalogs.stackPatterns[0].id -ApiFirst $false -UxPattern $manifest.catalogs.uxPatterns[0].id) -RelocatedRootEntries @('domain-notes.md')
    Assert-ValidatorPasses -FixtureRoot $combinedFixture -CaseName 'Combined patterns and relocation setup'

    $missingSkillFixture = New-AtlasFixture -Answers (New-Answers)
    Remove-Item -LiteralPath (Join-Path $missingSkillFixture '.github/skills/project-setup/SKILL.md')
    Assert-ValidatorFails -FixtureRoot $missingSkillFixture -ExpectedText 'Missing required path: .github/skills/project-setup/SKILL.md' -CaseName 'Missing base skill'

    $unexpectedRootFixture = New-AtlasFixture -Answers (New-Answers)
    Set-Content -LiteralPath (Join-Path $unexpectedRootFixture 'package.json') -Value '{}' -Encoding utf8
    Assert-ValidatorFails -FixtureRoot $unexpectedRootFixture -ExpectedText 'Unexpected root entry: package.json' -CaseName 'Unexpected root entry'

    $temporarySourceFixture = New-AtlasFixture -Answers (New-Answers)
    New-Item -ItemType Directory -Path (Join-Path $temporarySourceFixture 'Atlas_AI') | Out-Null
    Assert-ValidatorFails -FixtureRoot $temporarySourceFixture -ExpectedText 'Temporary source-kit directory remains' -CaseName 'Temporary source kit'

    $staleReceiptFixture = New-AtlasFixture -Answers (New-Answers)
    $staleReceiptPath = Join-Path $staleReceiptFixture '.atlas/setup.json'
    $staleReceipt = Get-Content -LiteralPath $staleReceiptPath -Raw | ConvertFrom-Json
    $staleReceipt.manifestVersion = 99
    $staleReceipt | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $staleReceiptPath -Encoding utf8
    Assert-ValidatorFails -FixtureRoot $staleReceiptFixture -ExpectedText 'manifestVersion must match' -CaseName 'Stale receipt'

    $invalidSelectionFixture = New-AtlasFixture -Answers (New-Answers)
    $invalidReceiptPath = Join-Path $invalidSelectionFixture '.atlas/setup.json'
    $invalidReceipt = Get-Content -LiteralPath $invalidReceiptPath -Raw | ConvertFrom-Json
    $invalidReceipt.answers.stackPattern = 'sp-invalid'
    $invalidReceipt.answers.apiFirst = $true
    $invalidReceipt | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $invalidReceiptPath -Encoding utf8
    Assert-ValidatorFails -FixtureRoot $invalidSelectionFixture -ExpectedText 'Unknown stackPattern selection' -CaseName 'Invalid pattern selection'

    $missingAnswerFixture = New-AtlasFixture -Answers (New-Answers)
    $missingAnswerReceiptPath = Join-Path $missingAnswerFixture '.atlas/setup.json'
    $missingAnswerReceipt = Get-Content -LiteralPath $missingAnswerReceiptPath -Raw | ConvertFrom-Json
    $missingAnswerReceipt.answers.PSObject.Properties.Remove('includeCGR')
    $missingAnswerReceipt | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $missingAnswerReceiptPath -Encoding utf8
    Assert-ValidatorFails -FixtureRoot $missingAnswerFixture -ExpectedText 'missing questionnaire answer: includeCGR' -CaseName 'Missing questionnaire answer'

    $unselectedCgrFixture = New-AtlasFixture -Answers (New-Answers)
    Copy-RelativePath -RelativePath '.github/prompts/cgr.prompt.md' -DestinationRoot $unselectedCgrFixture
    Assert-ValidatorFails -FixtureRoot $unselectedCgrFixture -ExpectedText 'Path is present but its setup option is not selected' -CaseName 'Unselected optional component'

    $unsafeRelocationFixture = New-AtlasFixture -Answers (New-Answers)
    $unsafeReceiptPath = Join-Path $unsafeRelocationFixture '.atlas/setup.json'
    $unsafeReceipt = Get-Content -LiteralPath $unsafeReceiptPath -Raw | ConvertFrom-Json
    $unsafeReceipt.relocatedRootEntries = @('../outside.md')
    $unsafeReceipt | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $unsafeReceiptPath -Encoding utf8
    Assert-ValidatorFails -FixtureRoot $unsafeRelocationFixture -ExpectedText 'must contain root entry names, not paths' -CaseName 'Unsafe relocation receipt'

    $unrecordedRelocationFixture = New-AtlasFixture -Answers (New-Answers)
    $unrecordedPath = Join-Path $unrecordedRelocationFixture 'docs/reference/preexisting-root/unrecorded.md'
    New-Item -ItemType Directory -Path (Split-Path -Parent $unrecordedPath) -Force | Out-Null
    Set-Content -LiteralPath $unrecordedPath -Value 'unrecorded fixture content' -Encoding utf8
    Assert-ValidatorFails -FixtureRoot $unrecordedRelocationFixture -ExpectedText 'Preserved root entry is not recorded' -CaseName 'Unrecorded relocation'

    $missingMetadataFixture = New-AtlasFixture -Answers (New-Answers -StackPattern $manifest.catalogs.stackPatterns[0].id -ApiFirst $true)
    $activeStackPath = Join-Path $missingMetadataFixture 'patterns/stack-patterns/active-stack-pattern.md'
    (Get-Content -LiteralPath $activeStackPath | Where-Object { $_ -notmatch '^API-First:' }) |
        Set-Content -LiteralPath $activeStackPath -Encoding utf8
    Assert-ValidatorFails -FixtureRoot $missingMetadataFixture -ExpectedText 'Active stack pattern must record API-First: Enabled' -CaseName 'Missing API-first metadata'

    $trackedSecretFixture = New-AtlasFixture -Answers (New-Answers)
    & git -C $trackedSecretFixture init --quiet
    & git -C $trackedSecretFixture add -f secrets.md
    Assert-ValidatorFails -FixtureRoot $trackedSecretFixture -ExpectedText 'secrets.md is tracked by git' -CaseName 'Tracked secrets file'

    $readmeText = Get-Content -LiteralPath (Join-Path $repoRoot 'README.md') -Raw
    $instructionsText = Get-Content -LiteralPath (Join-Path $repoRoot '.github/copilot-instructions.md') -Raw
    $newProjectText = Get-Content -LiteralPath (Join-Path $repoRoot 'atlas_newproject.md') -Raw
    $validatePromptText = Get-Content -LiteralPath (Join-Path $repoRoot 'atlas_validate.md') -Raw
    $validatorText = Get-Content -LiteralPath $validatorPath -Raw

    Assert-True -Condition ($readmeText -match 'set this Atlas project up with github/picostar/Atlas_AI readme\.md') -Message 'README should recognize the reported natural-language setup phrase.'
    Assert-True -Condition ($instructionsText -match 'asks to set up or bootstrap an Atlas project') -Message 'Shared instructions should route natural-language Atlas setup requests.'
    Assert-True -Condition ($newProjectText.IndexOf('Run the required setup questionnaire') -lt $newProjectText.IndexOf('After confirmation')) -Message 'The questionnaire must appear before the first mutation step.'
    Assert-True -Condition ($newProjectText -match 'interrupted bootstrap') -Message 'The new-project prompt should define interrupted bootstrap recovery.'
    Assert-True -Condition ($newProjectText -match 'instead of overwriting') -Message 'The new-project prompt should stop on preservation or install collisions.'

    foreach ($parityTerm in @('relocatedRootEntries', 'temporary', 'secrets.md', 'Atlas Pattern ID', 'Unexpected root entry')) {
        Assert-True -Condition ($validatePromptText -match [regex]::Escape($parityTerm)) -Message "Validation prompt should cover $parityTerm."
        Assert-True -Condition ($validatorText -match [regex]::Escape($parityTerm)) -Message "PowerShell validator should cover $parityTerm."
    }
} finally {
    $tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd([IO.Path]::DirectorySeparatorChar)
    foreach ($fixtureRoot in $fixtureRoots) {
        $resolvedFixture = [IO.Path]::GetFullPath($fixtureRoot)
        if ($resolvedFixture.StartsWith($tempRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase) -and
            [IO.Path]::GetFileName($resolvedFixture).StartsWith('atlas-validator-', [StringComparison]::OrdinalIgnoreCase)) {
            Remove-Item -LiteralPath $resolvedFixture -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

if ($failures.Count -gt 0) {
    foreach ($failure in $failures) {
        Write-Error $failure -ErrorAction Continue
    }
    Write-Output "Atlas validator tests failed with $($failures.Count) failure(s)."
    exit 1
}

Write-Output 'Atlas validator tests passed.'
exit 0
