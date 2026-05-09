[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$RepoRoot = ".",
    [switch]$SkipReferenceRewrite,
    [switch]$Approved
)

$ErrorActionPreference = 'Stop'

$resolvedRoot = [System.IO.Path]::GetFullPath($RepoRoot)

if (-not $WhatIfPreference -and -not $Approved) {
    Write-Error "Refusing to run a real layout migration without explicit approval. Preview with -WhatIf first, then rerun with -Approved after human review."
    return
}

function Merge-DirectoryContent {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourcePath,
        [Parameter(Mandatory = $true)]
        [string]$DestinationPath
    )

    if (-not (Test-Path -LiteralPath $SourcePath)) {
        return
    }

    if (-not (Test-Path -LiteralPath $DestinationPath)) {
        New-Item -ItemType Directory -Path $DestinationPath -Force | Out-Null
    }

    $items = Get-ChildItem -LiteralPath $SourcePath -Force -ErrorAction Stop
    foreach ($item in $items) {
        $targetPath = Join-Path $DestinationPath $item.Name
        if (Test-Path -LiteralPath $targetPath) {
            if ($item.PSIsContainer) {
                Merge-DirectoryContent -SourcePath $item.FullName -DestinationPath $targetPath
            } else {
                $base = [System.IO.Path]::GetFileNameWithoutExtension($item.Name)
                $ext = [System.IO.Path]::GetExtension($item.Name)
                $counter = 1
                do {
                    $altName = "{0}-migrated-{1}{2}" -f $base, $counter, $ext
                    $altPath = Join-Path $DestinationPath $altName
                    $counter++
                } while (Test-Path -LiteralPath $altPath)

                Move-Item -LiteralPath $item.FullName -Destination $altPath -Force -ErrorAction Stop
                Write-Host "Conflict resolved by rename: $($item.FullName) -> $altPath"
            }
        } else {
            Move-Item -LiteralPath $item.FullName -Destination $targetPath -Force -ErrorAction Stop
        }
    }

    if ((Test-Path -LiteralPath $SourcePath) -and (Get-ChildItem -LiteralPath $SourcePath -Force -ErrorAction Stop | Measure-Object).Count -eq 0) {
        Remove-Item -LiteralPath $SourcePath -Force -ErrorAction Stop
    }
}

$legacyToV2 = @(
    @{ Source = "docs/projects"; Destination = "docs/cgr" },
    @{ Source = "docs/reference/stack-patterns"; Destination = "patterns/stack-patterns" },
    @{ Source = "docs/reference/ux-patterns"; Destination = "patterns/ux-patterns" }
)

Write-Host "Repository root: $resolvedRoot"

foreach ($mapping in $legacyToV2) {
    $sourcePath = Join-Path $resolvedRoot $mapping.Source
    $destinationPath = Join-Path $resolvedRoot $mapping.Destination

    if (-not (Test-Path -LiteralPath $sourcePath)) {
        continue
    }

    if ($PSCmdlet.ShouldProcess($sourcePath, "Migrate to $destinationPath")) {
        Merge-DirectoryContent -SourcePath $sourcePath -DestinationPath $destinationPath
        Write-Host "Migrated $($mapping.Source) -> $($mapping.Destination)"
    }
}

if ($SkipReferenceRewrite) {
    Write-Host "Skipped reference rewrite as requested."
    return
}

$textFiles = Get-ChildItem -Path $resolvedRoot -Recurse -File -Include *.md,*.ps1,*.bat -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -ne $PSCommandPath }
$updated = 0

foreach ($file in $textFiles) {
    if (-not (Test-Path -LiteralPath $file.FullName)) {
        continue
    }

    try {
        $content = Get-Content -LiteralPath $file.FullName -Raw -ErrorAction Stop
    } catch {
        if ($_.Exception -is [System.Management.Automation.ItemNotFoundException] -or $_.Exception -is [System.IO.DirectoryNotFoundException] -or $_.Exception -is [System.IO.FileNotFoundException]) {
            continue
        }

        throw
    }

    $rewritten = $content.Replace("docs/projects/", "docs/cgr/")
    $rewritten = $rewritten.Replace("docs/projects\\", "docs/cgr\\")
    $rewritten = $rewritten.Replace("docs/reference/stack-patterns/", "patterns/stack-patterns/")
    $rewritten = $rewritten.Replace("docs/reference/ux-patterns/", "patterns/ux-patterns/")
    $rewritten = $rewritten.Replace("docs/reference/stack-patterns", "patterns/stack-patterns")
    $rewritten = $rewritten.Replace("docs/reference/ux-patterns", "patterns/ux-patterns")

    if ($rewritten -ne $content) {
        if ($PSCmdlet.ShouldProcess($file.FullName, "Rewrite legacy references")) {
            Set-Content -LiteralPath $file.FullName -Value $rewritten -Encoding UTF8
            $updated++
        }
    }
}

Write-Host "Reference rewrite completed. Files updated: $updated"
