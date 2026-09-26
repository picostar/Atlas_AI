[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Region = 'eastus',

    [Parameter(Position = 1)]
    [string]$Currency = 'USD',

    [Parameter(Position = 2)]
    [string[]]$Services = @('Functions', 'SQL', 'Storage', 'StaticWebApps', 'KeyVault', 'AppService', 'LogAnalytics'),

    [ValidateSet('Table', 'Markdown', 'Json', 'Object')]
    [string]$OutputFormat = 'Table'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Invoke-AzurePricingQuery {
    param(
        [string]$ODataFilter,
        [int]$MaxRetries = 3
    )

    $encoded = [System.Uri]::EscapeDataString($ODataFilter)
    $uri = "https://prices.azure.com/api/retail/prices?`$filter=$encoded"

    for ($attempt = 1; $attempt -le $MaxRetries; $attempt++) {
        try {
            Start-Sleep -Milliseconds 400
            $response = Invoke-RestMethod -Uri $uri -Method Get
            if ($null -ne $response -and $null -ne $response.Items) {
                return @($response.Items)
            }
            return @()
        } catch {
            $err = $_.Exception.Message
            if ($err -match '429' -and $attempt -lt $MaxRetries) {
                Write-Verbose "Rate limit encountered. Sleeping 2 seconds before retry $attempt..."
                Start-Sleep -Seconds 2
            } else {
                Write-Warning "Query failed for filter: $ODataFilter ($err)"
                return @()
            }
        }
    }
    return @()
}

$results = [System.Collections.Generic.List[PSCustomObject]]::new()

Write-Verbose "Fetching Azure Retail Prices for region: $Region (Currency: $Currency)..."

# 1. Azure Functions
if ($Services -contains 'Functions') {
    $fnItems = Invoke-AzurePricingQuery "armRegionName eq '$Region' and serviceName eq 'Functions' and contains(meterName, 'Total Executions') and priceType eq 'Consumption'"
    $activeItem = $fnItems | Where-Object { $_.retailPrice -gt 0 } | Select-Object -First 1
    if ($null -ne $activeItem) {
        $results.Add([pscustomobject]@{
            Category        = 'Compute'
            Service         = 'Azure Functions (Consumption)'
            SkuName         = [string]$activeItem.skuName
            MeterName       = [string]$activeItem.meterName
            UnitOfMeasure   = [string]$activeItem.unitOfMeasure
            RetailPrice     = [double]$activeItem.retailPrice
            Currency        = [string]$activeItem.currencyCode
            FinOpsGuidance  = 'First 1M executions/month free. Pay-as-you-go, 0 cost at idle.'
        })
    }
}

# 2. Azure Static Web Apps
if ($Services -contains 'StaticWebApps') {
    $swaItems = Invoke-AzurePricingQuery "serviceName eq 'Azure App Service' and productName eq 'Static Web Apps' and contains(meterName, 'Standard App')"
    $activeItem = $swaItems | Select-Object -First 1
    if ($null -ne $activeItem) {
        $results.Add([pscustomobject]@{
            Category        = 'Frontend'
            Service         = 'Azure Static Web Apps (Standard)'
            SkuName         = [string]$activeItem.skuName
            MeterName       = [string]$activeItem.meterName
            UnitOfMeasure   = [string]$activeItem.unitOfMeasure
            RetailPrice     = [double]$activeItem.retailPrice
            Currency        = [string]$activeItem.currencyCode
            FinOpsGuidance  = 'Free Tier available ($0/mo) for Dev/Test. Standard provides SLA and enterprise auth.'
        })
    }
}

# 3. Azure SQL Database Serverless
if ($Services -contains 'SQL') {
    $sqlItems = Invoke-AzurePricingQuery "armRegionName eq '$Region' and serviceName eq 'SQL Database' and priceType eq 'Consumption' and contains(meterName, 'vCore') and contains(skuName, '1 vCore')"
    $activeItem = $sqlItems | Select-Object -First 1
    if ($null -ne $activeItem) {
        $results.Add([pscustomobject]@{
            Category        = 'Database'
            Service         = 'Azure SQL Database (Serverless GP)'
            SkuName         = [string]$activeItem.skuName
            MeterName       = [string]$activeItem.meterName
            UnitOfMeasure   = [string]$activeItem.unitOfMeasure
            RetailPrice     = [double]$activeItem.retailPrice
            Currency        = [string]$activeItem.currencyCode
            FinOpsGuidance  = 'Enable auto-pause delay at 60 min. Min vCore 0.5 saves ~75% vs provisioned DB.'
        })
    }
}

# 4. Storage Accounts (Tables and Blobs)
if ($Services -contains 'Storage') {
    $stItems = Invoke-AzurePricingQuery "armRegionName eq '$Region' and serviceName eq 'Storage' and priceType eq 'Consumption' and contains(meterName, 'Tables Capacity') and contains(skuName, 'Standard LRS')"
    $activeItem = $stItems | Select-Object -First 1
    if ($null -ne $activeItem) {
        $results.Add([pscustomobject]@{
            Category        = 'Storage'
            Service         = 'Azure Table Storage (Standard LRS)'
            SkuName         = [string]$activeItem.skuName
            MeterName       = [string]$activeItem.meterName
            UnitOfMeasure   = [string]$activeItem.unitOfMeasure
            RetailPrice     = [double]$activeItem.retailPrice
            Currency        = [string]$activeItem.currencyCode
            FinOpsGuidance  = 'Standard LRS is ultra low-cost ($0.045/GB-mo). Avoid GRS in non-prod.'
        })
    }
}

# 5. Key Vault
if ($Services -contains 'KeyVault') {
    $kvItems = Invoke-AzurePricingQuery "armRegionName eq '$Region' and serviceName eq 'Key Vault' and priceType eq 'Consumption' and contains(meterName, 'Operations') and contains(skuName, 'Standard')"
    $activeItem = $kvItems | Select-Object -First 1
    if ($null -ne $activeItem) {
        $results.Add([pscustomobject]@{
            Category        = 'Security'
            Service         = 'Azure Key Vault (Standard)'
            SkuName         = [string]$activeItem.skuName
            MeterName       = [string]$activeItem.meterName
            UnitOfMeasure   = [string]$activeItem.unitOfMeasure
            RetailPrice     = [double]$activeItem.retailPrice
            Currency        = [string]$activeItem.currencyCode
            FinOpsGuidance  = '$0.03 per 10k ops. Use local caching of secrets in memory to minimize calls.'
        })
    }
}

# 6. App Service (Basic Linux B1)
if ($Services -contains 'AppService') {
    $asItems = Invoke-AzurePricingQuery "armRegionName eq '$Region' and serviceName eq 'Azure App Service' and contains(productName, 'Basic Plan - Linux') and contains(skuName, 'B1')"
    $activeItem = $asItems | Select-Object -First 1
    if ($null -ne $activeItem) {
        $results.Add([pscustomobject]@{
            Category        = 'Compute'
            Service         = 'Azure App Service (Basic B1 Linux)'
            SkuName         = [string]$activeItem.skuName
            MeterName       = [string]$activeItem.meterName
            UnitOfMeasure   = [string]$activeItem.unitOfMeasure
            RetailPrice     = [double]$activeItem.retailPrice
            Currency        = [string]$activeItem.currencyCode
            FinOpsGuidance  = 'Schedule auto-stop outside business hours (08:00 - 18:00) to save ~70%.'
        })
    }
}

# 7. Log Analytics / Azure Monitor
if ($Services -contains 'LogAnalytics') {
    $laItems = Invoke-AzurePricingQuery "armRegionName eq '$Region' and serviceName eq 'Log Analytics' and contains(meterName, 'Data Ingestion') and priceType eq 'Consumption'"
    $activeItem = $laItems | Where-Object { $_.retailPrice -gt 0 } | Select-Object -First 1
    if ($null -ne $activeItem) {
        $results.Add([pscustomobject]@{
            Category        = 'Observability'
            Service         = 'Log Analytics Workspace (Data Ingestion)'
            SkuName         = [string]$activeItem.skuName
            MeterName       = [string]$activeItem.meterName
            UnitOfMeasure   = [string]$activeItem.unitOfMeasure
            RetailPrice     = [double]$activeItem.retailPrice
            Currency        = [string]$activeItem.currencyCode
            FinOpsGuidance  = 'First 5 GB/month free. Set Daily Cap (e.g. 1.0 GB/day) and 30-day retention.'
        })
    }
}

# Output rendering
switch ($OutputFormat) {
    'Json' {
        $results | ConvertTo-Json -Depth 3
    }
    'Object' {
        $results
    }
    'Markdown' {
        $mdLines = [System.Collections.Generic.List[string]]::new()
        $mdLines.Add("| Category | Service | SKU | Metric | Retail Unit Price ($Currency) | FinOps Guidance |")
        $mdLines.Add("| :--- | :--- | :--- | :--- | :--- | :--- |")
        foreach ($item in $results) {
            $formattedPrice = [string]::Format([System.Globalization.CultureInfo]::InvariantCulture, "{0:F6}", $item.RetailPrice).TrimEnd('0').TrimEnd('.')
            $priceText = "$formattedPrice $($item.Currency) / $($item.UnitOfMeasure)"
            $mdLines.Add("| $($item.Category) | $($item.Service) | $($item.SkuName) | $($item.MeterName) | $priceText | $($item.FinOpsGuidance) |")
        }
        $mdLines -join "`r`n"
    }
    default {
        $results | Format-Table -Property Category, Service, SkuName, RetailPrice, UnitOfMeasure, FinOpsGuidance -AutoSize
    }
}
