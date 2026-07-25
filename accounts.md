# Project Accounts

This file records non-secret cloud destination and provider account bindings for this repository.

Do not store credentials, keys, tokens, passwords, connection strings, or deployment secrets here. Put local-only secret notes in `secrets.md`, and store operational secrets in the provider or CI/CD secret store.

## Status

- Account binding status: Not set
- Last reviewed: TBD
- Owner: TBD
- Notes: Fill in the provider sections that apply to this project. Leave unused providers as `TBD` or `Not used`.

## Azure

- Tenant ID or name: TBD
- Subscription ID: TBD
- Subscription name: TBD
- Resource group: TBD
- Region: TBD
- Function app name: TBD
- Static Web App name: TBD
- App Service name: TBD
- Storage account name: TBD
- Key Vault name: TBD
- Other Azure resources: TBD
- Deployment environment notes: TBD

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

- Owner or organization: TBD
- Repository: TBD
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
