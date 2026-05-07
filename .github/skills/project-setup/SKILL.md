---
name: project-setup
description: 'Set up a project with atlas_ai. Use when adopting atlas_ai into a new or existing repository, running the installer, reorganizing existing files into the atlas_ai structure, or bootstrapping a project.'
---

# Project Setup with atlas_ai

## When to Use

- Setting up a new project with the atlas_ai process kit
- Adopting atlas_ai into an existing repository
- Reorganizing existing docs into the atlas_ai structure

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
3. If existing files are present, review and reorganize:
   - With `-OrganizeExisting`, move existing files into `docs/reference/` first for triage
   - Keep `seed.md` and `secrets.md` in place when present
   - Treat existing MRD, PRD, and ESD files as reference inputs and create source-of-truth artifacts in `docs/cgr/`
   - If the runnable app lives in a child directory one level down, keep atlas_ai files and the `docs/` tree at the repo root and treat the child directory as code-only
4. Do not overwrite existing project content -- merge or adapt it
5. Summarize what was installed and reorganized

## File Placement Rules

Refer to [ATLAS.md](../../../ATLAS.md) for the full doc structure table. Key rules:

- Active tasks in `docs/agile/devcycle.md`
- Completed work in `docs/agile/retro.md`
- Future work in `docs/agile/backlog.md`
- Live state in `docs/agile/status.md`
- Keep reusable instruction files generic -- no project-specific values
- No secrets in committed files
- Before asking the user for credentials, tokens, keys, or other secret values, check `secrets.md` at the repository root first if it exists
- Do not place secrets in any other file by default; if the user requests an override, warn first and proceed only after confirmation
