# Project Accounts

This file records non-secret cloud destination and provider account bindings for this repository.

Do not store credentials, keys, tokens, passwords, connection strings, or deployment secrets here. Put local-only secret notes in `secrets.md`, and store operational secrets in the provider or CI/CD secret store.

## Status

- Account binding status: Set for Azure MCAPS Foundry demo environment
- Last reviewed: 2026-07-25
- Owner: Tiannaumann MCAPS demo environment
- Notes: Non-secret account binding only. Do not store Foundry keys, Claude keys, bearer tokens, passwords, or connection strings in this file.

## Azure

- Tenant ID or name: c233258c-8c06-4734-abdd-e35de3419f97, Contoso, MngEnvMCAP529719.onmicrosoft.com
- Subscription ID: aa0595d7-ce29-4cac-a3f0-38face8b3fda
- Subscription name: ME-MngEnvMCAP529719-tiannaumann-1
- Resource group: rg-hcsc-uw-poc
- Region: eastus2
- Function app name: TBD
- Static Web App name: TBD
- App Service name: TBD
- Storage account name: TBD
- Key Vault name: TBD
- Other Azure resources: Microsoft Foundry account fdy-hcsc-uw-poc; Foundry project idp-claude-code; existing model deployments gpt-4o-mini and gpt-4o; requested Anthropic quota for claude-sonnet-5.Azure at 10K TPM and claude-haiku-4-5.Azure at 5K TPM.
- Deployment environment notes: Azure extension auth context is signed in as `admin@mngenvmcap529719.onmicrosoft.com`. Azure CLI context can differ from VS Code Azure extension context, so verify both before deployment or quota operations.

## AWS

- Account ID: TBD
- Account alias: TBD
- Region: TBD
- IAM role or deployment role name: TBD
- Resource group, stack, or project tag: TBD
- Deployment environment notes: TBD

## Google Cloud

- Organization ID or name: TBD
- Billing account reference: TBD
- Project ID: TBD
- Project name: TBD
- Region: TBD
- Service account name: TBD
- Deployment environment notes: TBD

## Cloudflare

- Account ID: TBD
- Account name: TBD
- Zone ID or zone name: TBD
- Pages project: TBD
- Workers service: TBD
- Deployment environment notes: TBD

## GitHub

- Owner or organization: picostar
- Repository: Atlas_AI source kit used for Atlas setup reference; HCSC project repository target TBD
- Environment names: TBD
- Deployment branch policy: TBD
- Actions environment notes: TBD

## Other Providers

- Provider name: TBD
- Account, project, or tenant reference: TBD
- Region or location: TBD
- Deployment target names: TBD
- Notes: TBD

## Validation Rules

- Cloud, hosting, infrastructure, deployment, and provider CLI work must check this file before selecting a subscription, account, resource group, project, zone, or deployment target.
- If this file conflicts with live CLI state, stop and ask for confirmation before making changes.
- Use explicit provider scoping on commands whenever supported, for example Azure `--subscription` and `--resource-group`.
