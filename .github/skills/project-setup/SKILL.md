---
name: project-setup
description: 'Set up a new project with atlas_ai. Use when bootstrapping a new repository, running the installer, initializing git, or creating a GitHub repo.'
---

# Project Setup with atlas_ai

## When to Use

- Setting up a new project with the atlas_ai process kit
- Bootstrapping a new repository
- Initializing git or creating a new GitHub repository for a new project

## Procedure

1. Read these kit files for context:
   - [README.md](../../../README.md)
   - [copilot-instructions.md](../../copilot-instructions.md)
   - [ATLAS.md](../../../ATLAS.md)
   - [AGENTS.md](../../../AGENTS.md)
2. Run the installer: `pwsh -File ./atlas_ai/atlas_ai.ps1 -IncludeScaffold`
   - Add `-IncludePS` for formal release stages
   - Add `-IncludeCGR` for governance review
   - Add `-InitGit` for git initialization
   - Add `-GitHubRepo "name"` for GitHub repo creation
3. If Atlas control files are already present at the repo root, stop and use `atlas_update.md` from the kit for a plan-first legacy project update instead
   - Otherwise preserve pre-existing user files by moving them into `docs/reference/preexisting-root/`
   - If `.git` already exists, adopt that repository rather than reinitializing it
4. Create committed `accounts.md` for non-secret cloud account and deployment destination binding
5. Summarize what was installed

## File Placement Rules

Refer to [ATLAS.md](../../../ATLAS.md) for the full doc structure table. Key rules:

- Active tasks in `docs/agile/devcycle.md`
- Completed work in `docs/agile/retro.md`
- Future work in `docs/agile/backlog.md`
- Live state in `docs/agile/status.md`
- Keep reusable instruction files generic -- no project-specific values
- No secrets in committed files
- Use committed `accounts.md` for non-secret cloud account binding such as subscriptions, resource groups, project IDs, account IDs, regions, zones, and deployment target names
- Check `accounts.md` before cloud, hosting, infrastructure, deployment, or provider CLI work
- Before asking the user for credentials, tokens, keys, or other secret values, check `secrets.md` at the repository root first if it exists
- Do not place secrets in any other file by default; if the user requests an override, warn first and proceed only after confirmation
