[CmdletBinding()]
param(
    [string]$FrontendPath = './frontend',
    [string]$ApiPath = './api',
    [int]$Port = 4280,
    [switch]$StartAzurite,
    [switch]$CheckOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Write-Host "=========================================================="
Write-Host " Atlas_AI Local Development & Offline Environment Launcher"
Write-Host "=========================================================="

function Test-CommandAvailable {
    param([string]$CommandName)
    $cmd = Get-Command -Name $CommandName -ErrorAction SilentlyContinue
    return ($null -ne $cmd)
}

$prereqs = @(
    @{ Name = 'node'; Package = 'Node.js LTS (https://nodejs.org)' },
    @{ Name = 'swa'; Package = 'npm install -g @azure/static-web-apps-cli' },
    @{ Name = 'func'; Package = 'npm install -g azure-functions-core-tools@4 --unsafe-perm true' },
    @{ Name = 'azurite'; Package = 'npm install -g azurite' }
)

$missingCount = 0
Write-Host "`nChecking developer prerequisites:"
foreach ($prereq in $prereqs) {
    if (Test-CommandAvailable -CommandName $prereq.Name) {
        Write-Host "  [OK] $($prereq.Name) is installed." -ForegroundColor Green
    } else {
        Write-Host "  [MISSING] $($prereq.Name) is not found. Install with: $($prereq.Package)" -ForegroundColor Yellow
        $missingCount++
    }
}

if ($CheckOnly) {
    Write-Host "`nPrerequisite check completed ($missingCount missing)."
    exit 0
}

if ($missingCount -gt 0) {
    Write-Warning "`nSome prerequisites are missing. You can still proceed if your current task only requires a subset of tools."
}

# Start Azurite if requested or available
if ($StartAzurite -or (Test-CommandAvailable -CommandName 'azurite')) {
    $azuriteDir = Join-Path $PWD '.azurite'
    if (-not (Test-Path -LiteralPath $azuriteDir)) {
        New-Item -ItemType Directory -Path $azuriteDir -Force | Out-Null
    }
    Write-Host "`nStarting Azurite Storage Emulator in background..."
    Start-Process -FilePath 'azurite' -ArgumentList "--silent --location `"$azuriteDir`"" -WindowStyle Hidden
    Write-Host "  -> Azurite active on ports 10000 (Blob) and 10002 (Table)." -ForegroundColor Cyan
}

# Check frontend and api folders
$hasFrontend = Test-Path -LiteralPath $FrontendPath
$hasApi = Test-Path -LiteralPath $ApiPath

Write-Host "`nEnvironment Status:"
Write-Host "  Frontend directory: $FrontendPath (Exists: $hasFrontend)"
Write-Host "  API directory:      $ApiPath (Exists: $hasApi)"
Write-Host "  Target Port:        $Port"

if (-not $hasFrontend -and -not $hasApi) {
    Write-Host "`nNotice: Neither $FrontendPath nor $ApiPath directories exist yet."
    Write-Host "Create your frontend/api scaffolding, or run 'swa init' to begin."
    Write-Host "Offline Entra ID mock login will be available at: http://localhost:$Port/.auth/login/aad"
    exit 0
}

Write-Host "`nLaunching Azure Static Web Apps emulator..."
$swaArgs = "start"
if ($hasFrontend) { $swaArgs += " $FrontendPath" }
if ($hasApi) { $swaArgs += " --api-location $ApiPath" }
$swaArgs += " --port $Port"

Write-Host "Running: swa $swaArgs"
Write-Host "`nMock SSO Login will be accessible at: http://localhost:$Port/.auth/login/aad"
& swa $swaArgs
