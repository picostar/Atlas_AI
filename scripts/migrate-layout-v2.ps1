[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$RepoRoot = ".",
    [switch]$SkipReferenceRewrite
)

$resolvedRoot = [System.IO.Path]::GetFullPath($RepoRoot)

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

    $items = Get-ChildItem -LiteralPath $SourcePath -Force
    foreach ($item in $items) {
        $targetPath = Join-Path $DestinationPath $item.Name
        if (Test-Path -LiteralPath $targetPath) {
            if ($item.PSIsContainer) {
                Merge-DirectoryContent -SourcePath $item.FullName -DestinationPath $targetPath
                if ((Get-ChildItem -LiteralPath $item.FullName -Force | Measure-Object).Count -eq 0) {
                    Remove-Item -LiteralPath $item.FullName -Force
                }
            } else {
                $base = [System.IO.Path]::GetFileNameWithoutExtension($item.Name)
                $ext = [System.IO.Path]::GetExtension($item.Name)
                $counter = 1
                do {
                    $altName = "{0}-migrated-{1}{2}" -f $base, $counter, $ext
                    $altPath = Join-Path $DestinationPath $altName
                    $counter++
                } while (Test-Path -LiteralPath $altPath)

                Move-Item -LiteralPath $item.FullName -Destination $altPath -Force
                Write-Host "Conflict resolved by rename: $($item.FullName) -> $altPath"
            }
        } else {
            Move-Item -LiteralPath $item.FullName -Destination $targetPath -Force
        }
    }

    if ((Get-ChildItem -LiteralPath $SourcePath -Force | Measure-Object).Count -eq 0) {
        Remove-Item -LiteralPath $SourcePath -Force
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

$textFiles = Get-ChildItem -Path $resolvedRoot -Recurse -File -Include *.md,*.ps1,*.bat |
    Where-Object { $_.FullName -ne $PSCommandPath }
$updated = 0

foreach ($file in $textFiles) {
    $content = Get-Content -LiteralPath $file.FullName -Raw
    $rewritten = $content.Replace("docs/projects/", "docs/cgr/")
    $rewritten = $rewritten.Replace("docs/projects\\", "docs/cgr\\")
    $rewritten = $rewritten.Replace("docs/reference/stack-patterns/", "patterns/stack-patterns/")
    $rewritten = $rewritten.Replace("docs/reference/ux-patterns/", "patterns/ux-patterns/")
    $rewritten = $rewritten.Replace("docs/reference/stack-patterns", "patterns/stack-patterns")
    $rewritten = $rewritten.Replace("docs/reference/ux-patterns", "patterns/ux-patterns")

    if ($rewritten -ne $content) {
        if ($PSCmdlet.ShouldProcess($file.FullName, "Rewrite legacy references")) {
            Set-Content -LiteralPath $file.FullName -Value $rewritten
            $updated++
        }
    }
}

Write-Host "Reference rewrite completed. Files updated: $updated"
