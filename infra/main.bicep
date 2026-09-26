// Atlas_AI - Enterprise Azure Bicep Infrastructure Template
// Automates provisioning of the Atlas Stack Patterns with FinOps cost optimization

targetScope = 'resourceGroup'

@description('Project name used as a prefix for all provisioned resources.')
@minLength(3)
@maxLength(24)
param projectName string = 'atlas'

@description('Target environment.')
@allowed([
  'dev'
  'staging'
  'prod'
])
param environment string = 'dev'

@description('Primary Azure region for all regional resources.')
param location string = resourceGroup().location

@description('Corporate Cost Center for billing allocation.')
param costCenter string = 'CC-Engineering'

@description('Technical owner email for incident alerting.')
param owner string = 'techlead@company.com'

@description('Azure Static Web Apps pricing tier. Use Free for dev/test, Standard for prod.')
@allowed([
  'Free'
  'Standard'
])
param swaTier string = (environment == 'prod') ? 'Standard' : 'Free'

@description('Set to true to deploy Azure SQL Serverless database (Patron SP-02 / SP-04).')
param deploySql bool = false

@description('SQL Serverless auto-pause delay in minutes. 60 minutes recommended for maximum savings.')
param sqlAutoPauseDelayMinutes int = 60

@description('SQL Serverless minimum capacity in vCores.')
param sqlMinVcores string = '0.5'

@description('SQL Serverless maximum capacity in vCores.')
param sqlMaxVcores int = 1

@description('SQL Server Administrator login name.')
param sqlAdminLogin string = 'sqladminuser'

@description('SQL Server Administrator password (leave empty if deploySql is false).')
@secure()
param sqlAdminPassword string = ''

// Variables
var uniqueSuffix = substring(uniqueString(resourceGroup().id), 0, 6)
var cleanProjectName = toLower(replace(projectName, '-', ''))

var storageAccountName = '${cleanProjectName}st${environment}${uniqueSuffix}'
var keyVaultName = '${cleanProjectName}-kv-${environment}-${uniqueSuffix}'
var logAnalyticsName = '${cleanProjectName}-law-${environment}-${uniqueSuffix}'
var appInsightsName = '${cleanProjectName}-ai-${environment}-${uniqueSuffix}'
var functionPlanName = '${cleanProjectName}-plan-${environment}-${uniqueSuffix}'
var functionAppName = '${cleanProjectName}-func-${environment}-${uniqueSuffix}'
var staticWebAppName = '${cleanProjectName}-swa-${environment}-${uniqueSuffix}'
var sqlServerName = '${cleanProjectName}-sql-${environment}-${uniqueSuffix}'
var sqlDatabaseName = '${cleanProjectName}-db-${environment}'

// Mandatory Corporate FinOps Tags
var defaultTags = {
  Project: projectName
  Environment: environment
  CostCenter: costCenter
  Owner: owner
  DataClassification: 'Internal'
  AutoShutdown: (environment != 'prod') ? 'true' : 'false'
  ManagedBy: 'Atlas-Bicep'
}

// 1. Storage Account (Standard LRS Hot for Tables and Blobs)
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: take(storageAccountName, 24)
  location: location
  tags: defaultTags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
  }
}

// Table Service
resource tableService 'Microsoft.Storage/storageAccounts/tableServices@2023-01-01' = {
  parent: storageAccount
  name: 'default'
}

// 2. Azure Key Vault (Standard, RBAC Enabled)
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: take(keyVaultName, 24)
  location: location
  tags: defaultTags
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
  }
}

// 3. Log Analytics Workspace (30-day retention, 1 GB daily cap for FinOps safety)
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: take(logAnalyticsName, 63)
  location: location
  tags: defaultTags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    workspaceCapping: {
      dailyQuotaGb: 1
    }
  }
}

// 4. Application Insights
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: take(appInsightsName, 63)
  location: location
  tags: defaultTags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalytics.id
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

// 5. Functions Hosting Plan (Consumption Y1 - Serverless Zero-Cost at Idle)
resource functionPlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: take(functionPlanName, 40)
  location: location
  tags: defaultTags
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {
    reserved: true // Linux
  }
}

// 6. Azure Function App (with System-Assigned Managed Identity)
resource functionApp 'Microsoft.Web/sites@2023-01-01' = {
  name: take(functionAppName, 60)
  location: location
  tags: defaultTags
  kind: 'functionapp,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: functionPlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'NODE|20'
      minTlsVersion: '1.2'
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
        {
          name: 'KEY_VAULT_URL'
          value: keyVault.properties.vaultUri
        }
      ]
    }
  }
}

// 7. Role Assignment: Grant Function App Managed Identity 'Key Vault Secrets User'
var keyVaultSecretsUserRoleId = '4633458b-17de-408a-b874-0445c86b69e6' // Built-in Azure RBAC role

resource keyVaultRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, functionApp.id, keyVaultSecretsUserRoleId)
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', keyVaultSecretsUserRoleId)
    principalId: functionApp.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

// 8. Azure Static Web Apps (Frontend)
resource staticWebApp 'Microsoft.Web/staticSites@2023-01-01' = {
  name: take(staticWebAppName, 40)
  location: location
  tags: defaultTags
  sku: {
    name: swaTier
    tier: swaTier
  }
  properties: {
    allowConfigFileUpdates: true
  }
}

// 9. Azure SQL Database Serverless (Conditional)
resource sqlServer 'Microsoft.Sql/servers@2023-05-01-preview' = if (deploySql) {
  name: take(sqlServerName, 63)
  location: location
  tags: defaultTags
  properties: {
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: sqlAdminPassword
    version: '12.0'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2023-05-01-preview' = if (deploySql) {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  tags: defaultTags
  sku: {
    name: 'GP_S_Gen5'
    tier: 'GeneralPurpose'
    family: 'Gen5'
    capacity: sqlMaxVcores
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 34359738368 // 32 GB
    autoPauseDelay: sqlAutoPauseDelayMinutes // FinOps: pauses after 60 min inactivity
    minCapacity: json(sqlMinVcores)
  }
}

// Outputs
output storageAccountName string = storageAccount.name
output keyVaultName string = keyVault.name
output keyVaultUri string = keyVault.properties.vaultUri
output functionAppName string = functionApp.name
output functionAppEndpoint string = 'https://${functionApp.properties.defaultHostName}'
output staticWebAppName string = staticWebApp.name
output staticWebAppDefaultHostname string = staticWebApp.properties.defaultHostname
output logAnalyticsWorkspaceName string = logAnalytics.name
output sqlServerFqdn string = deploySql ? sqlServer.properties.fullyQualifiedDomainName : 'N/A'
