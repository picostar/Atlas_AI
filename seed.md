# Seed Notes For Project Startup

## Purpose
This file captures startup context for an atlas_ai adoption run.
Use it to describe project intent and first-cycle priorities before generating an initial devcycle.

## How To Use
1. Update the Project Outline section in this file.
2. Install atlas_ai into the repository root.
3. Recommended chat-only command:

```powershell
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -OrganizeExisting -InitGit -SeedPath .\atlas_ai -RemoveSeed
```

Optional stack pattern selection:

```powershell
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -OrganizeExisting -InitGit -SeedPath .\atlas_ai -RemoveSeed -StackPattern "sp-01-functions-tables-swa-keyvault.md"
```

You can also just say `newproject` in AI chat and the agent should run this same command flow.

4. With -OrganizeExisting, startup files like this one are moved to docs/reference.
5. After seed cleanup is complete, ask the agent: build an initial docs/agile/devcycle.md from docs/reference startup files.
6. Review and adjust scope, priorities, and CU estimates.

## Project Outline (Brief)
Project name: atlas_ai

Project goal:
- Provide a reusable process kit that installs root-level AI instruction files and a practical delivery workflow for software repositories.

Primary outcomes:
- Consistent AI instruction loading at repository root.
- ATLAS workflow for devtasks, smoketest, UAT, retro, and closeout.
- Optional PS stage-gate model and optional CGR governance review.
- Predictable adoption path for both new and existing repositories.

Current implementation scope:
- Installer and setup flow (atlas_ai.ps1 and NewProject.bat).
- Root instruction stack (.github/copilot-instructions.md, ATLAS.md, AGENTS.md, CLAUDE.md).
- Docs scaffold under docs/agile, docs/projects, docs/reference, scripts, and archive.
- Skill scaffolding under .github/skills.

Near-term focus:
- Keep seed handling safe so seed paths are not included in task commits.
- Keep startup artifacts in docs/reference and optionally derive initial devcycle tasks from them.
- Keep instruction files aligned to source-of-truth behavior.

Known constraints:
- Root-level instruction files are required for reliable auto-loading across tools.
- Reusable kit files should stay generic and avoid project-specific secrets.

Initial devcycle candidates:
- Improve installer ergonomics and post-install guidance.
- Expand or standardize high-value skills.
- Tighten documentation around adoption and closeout.
