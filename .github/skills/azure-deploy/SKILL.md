---
name: azure-deploy
description: 'Deploy to Azure. Use when deploying Azure Functions, Static Web Apps, or any Azure resource. Covers az CLI login, explicit subscription scoping, func publish, swa deploy, and resource group targeting.'
---

# Azure Deployment

## When to Use

- Deploying Azure Functions with `func azure functionapp publish`
- Deploying Static Web Apps with `swa deploy`
- Any `az` CLI operation against a project's Azure resources
- Verifying Azure subscription and login state without mutating shared Azure CLI defaults

## Procedure

1. Check for Azure setup docs in `docs/reference/` -- look for files with "azure" or "deploy" in the name
2. Capture the target subscription ID or name before any Azure command
3. If you need isolated Azure CLI state for this VS Code session, set `$env:AZURE_CONFIG_DIR` to a session-specific folder before login
4. Verify login state against the target subscription: `az account show --subscription "<subscription id or name>"`
5. If not logged in: `az login --use-device-code`
6. Prefer `--subscription "<subscription id or name>"` on every `az` command, and do not use `az account set` against a shared Azure CLI profile
7. Confirm resource group and target resources before any destructive operation
8. Run the deployment command
9. Verify the deployment succeeded

## Pre-Deploy Checklist

- Target subscription is explicit on every `az` command
- If using multiple concurrent Azure sessions, `AZURE_CONFIG_DIR` is isolated for this terminal session
- Resource group exists and is correct
- No hardcoded secrets in deployed code
- Environment variables and app settings are configured
- Rollback plan is known (redeploy previous version)

## Common Commands

```powershell
$subscription = "<subscription id or name>"
$resourceGroup = "<resource-group>"
$appName = "<app-name>"

# Optional: isolate Azure CLI state for this terminal session before login
$env:AZURE_CONFIG_DIR = Join-Path $PWD ".azure-session"

# Check current account against the target subscription
az account show --subscription $subscription

# Log in if needed
az login --use-device-code

# Verify the target function app before publish
az functionapp show --subscription $subscription --resource-group $resourceGroup --name $appName

# Deploy Azure Functions
func azure functionapp publish $appName

# Get a Static Web App deployment token from the target subscription
$token = az staticwebapp secrets list --subscription $subscription --name <swa-name> --resource-group $resourceGroup --query "properties.apiKey" -o tsv

# Deploy Static Web App
swa deploy "<build-dir>" --deployment-token $token --env production
```

## Rules

- ALWAYS keep subscription scoping explicit before deploying
- NEVER use `az account set` in repo guidance or shared Azure CLI sessions
- If you must work across multiple concurrent subscriptions, isolate Azure CLI state with `AZURE_CONFIG_DIR` before login
- NEVER hardcode credentials, tokens, or tenant IDs in scripts
- Read project-specific Azure config from `docs/reference/` if it exists
- Before asking the user for credentials, tokens, keys, or other secret values, check `accounts.txt` at the repository root first if it exists
- Confirm with the user before deploying to production
