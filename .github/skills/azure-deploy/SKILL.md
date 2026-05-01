---
name: azure-deploy
description: 'Deploy to Azure. Use when deploying Azure Functions, Static Web Apps, or any Azure resource. Covers az CLI login, subscription verification, func publish, swa deploy, and resource group targeting.'
---

# Azure Deployment

## When to Use

- Deploying Azure Functions with `func azure functionapp publish`
- Deploying Static Web Apps with `swa deploy`
- Any `az` CLI operation against a project's Azure resources
- Verifying Azure subscription and login state

## Procedure

1. Check for Azure setup docs in `docs/reference/` -- look for files with "azure" or "deploy" in the name
2. Verify login state: `az account show`
3. If not logged in: `az login --use-device-code`
4. Set the correct subscription: `az account set --subscription "<subscription name>"`
5. Confirm resource group and target resources before any destructive operation
6. Run the deployment command
7. Verify the deployment succeeded

## Pre-Deploy Checklist

- Subscription is set correctly (`az account show`)
- Resource group exists and is correct
- No hardcoded secrets in deployed code
- Environment variables and app settings are configured
- Rollback plan is known (redeploy previous version)

## Common Commands

```powershell
# Check current account
az account show

# Set subscription
az account set --subscription "<subscription name>"

# Deploy Azure Functions
func azure functionapp publish <app-name>

# Deploy Static Web App
$token = az staticwebapp secrets list --name <swa-name> --resource-group <rg> --query "properties.apiKey" -o tsv
swa deploy "<build-dir>" --deployment-token $token --env production
```

## Rules

- ALWAYS verify subscription before deploying
- NEVER hardcode credentials, tokens, or tenant IDs in scripts
- Read project-specific Azure config from `docs/reference/` if it exists
- Before asking the user for credentials, tokens, keys, or other secret values, check `accounts.txt` at the repository root first if it exists
- Confirm with the user before deploying to production
