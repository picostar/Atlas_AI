# Status

Current live state of the project.

## Summary

- Stage: Workshop and pilot planning
- Overall state: Atlas workspace initialized from `picostar/Atlas_AI`; HCSC Claude Code on Foundry planning docs are being activated.
- Current branch or release line: main
- Last meaningful update: 2026-07-25

## Live Capabilities

- Foundry account `fdy-hcsc-uw-poc` exists in resource group `rg-hcsc-uw-poc`.
- Foundry project `idp-claude-code` exists for the IDP Claude Code demo.
- Sonnet 5 and Haiku 4.5 quota requests have been submitted for the MCAPS subscription.
- A 5-minute Claude Code on Foundry demo script exists outside the repo at `c:\Users\tiannaumann\Downloads\claude-code-foundry-setup.md` and should be consolidated into repo reference docs.

## Current Constraints

- Anthropic Claude deployments are blocked until quota is approved for the MCAPS subscription.
- Do not represent personal Anthropic traffic as Foundry-governed traffic.
- Azure extension auth context and Azure CLI auth context can differ, so verify both before Azure operations.

## Next Focus

- Next task or phase: Complete DT1 validation, then consolidate the demo script into `docs/reference/` as DT2.
