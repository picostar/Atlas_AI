# Azure Infrastructure as Code (Bicep)

> **Purpose:** Reproducible Azure Bicep templates for deploying the full cloud infrastructure for Atlas_AI patterns (SP-01 through SP-05 and UXP-05) with default FinOps cost controls applied.

---

## 1. Directory Contents

- [`main.bicep`](file:///c:/Sources/Atlas_AI/infra/main.bicep) -- Main infrastructure template for Resource Group-level provisioning.
- [`parameters.dev.json`](file:///c:/Sources/Atlas_AI/infra/parameters.dev.json) -- Parameters for Development environment (Static Web Apps on Free Tier, minimum limits).
- [`parameters.prod.json`](file:///c:/Sources/Atlas_AI/infra/parameters.prod.json) -- Parameters for Production environment (Static Web Apps on Standard Tier with SLA).

---

## 2. Provisioned Resources

1. **Azure Storage Account:** Tier `Standard_LRS` for low-cost tables and blobs.
2. **Azure Key Vault:** SKU `Standard` with RBAC authorization enabled.
3. **Log Analytics Workspace:** Daily ingestion cap (*Daily Cap*) of 1 GB and strict 30-day retention to prevent unexpected cost overruns.
4. **Application Insights:** Linked to the Log Analytics workspace.
5. **Azure Functions (Consumption Plan Y1):** Serverless compute with scale-to-zero instances ($0 at rest).
6. **Managed Identity + RBAC:** Automatic assignment of the `Key Vault Secrets User` role to the Function App system identity.
7. **Azure Static Web Apps:** `Free` tier (development) or `Standard` tier (production).
8. **Azure SQL Serverless (Optional):** With **Auto-Pause Delay at 60 minutes** and minimum 0.5 vCore.

---

## 3. Deployment Instructions via Azure CLI

### Step 1: Authenticate and set subscription
```powershell
az login --use-device-code
az account set --subscription "<Subscription-ID>"
```

### Step 2: Create Resource Group (if not already existing)
```powershell
$rgName = "rg-atlasdemo-dev-eastus"
$location = "eastus"

az group create --name $rgName --location $location --tags Project=atlasdemo Environment=dev
```

### Step 3: Validate template (What-If preview)
```powershell
az deployment group what-if `
  --resource-group $rgName `
  --template-file infra/main.bicep `
  --parameters @infra/parameters.dev.json
```

### Step 4: Execute deployment
```powershell
az deployment group create `
  --resource-group $rgName `
  --template-file infra/main.bicep `
  --parameters @infra/parameters.dev.json
```

Record generated outputs (web app URLs, API endpoints, and Key Vault names) into [`accounts.md`](file:///c:/Sources/Atlas_AI/accounts.md).
