# Seed Notes For Project Startup

## Purpose
This file captures startup context for a new atlas_ai project setup run.
Use it to describe project intent and first-cycle priorities before generating an initial devcycle.

## How To Use
1. Update the Project Outline section in this file.
2. Install atlas_ai into the repository root.
3. Recommended chat-only command:

```powershell
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -ApiFirst -InitGit
```

Optional stack pattern selection:

```powershell
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -ApiFirst -InitGit -StackPattern "sp-01-functions-tables-swa-keyvault.md"
```

Optional UX pattern selection:

```powershell
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -ApiFirst -InitGit -UxPattern "uxp-01-modern-app-shell-layout.md"
```

You can also just say `newproject` in AI chat and the agent should run this same command flow.

4. Review and adjust scope, priorities, and CU estimates.

## Project Outline (Brief)
Project name: atlas_ai

Project goal:
- Provide a reusable process kit that installs root-level AI instruction files and a practical delivery workflow for software repositories.

Primary outcomes:
- Consistent AI instruction loading at repository root.
- ATLAS workflow for devtasks, smoketest, UAT, retro, and closeout.
- Optional PS stage-gate model and optional CGR governance review.
- Predictable setup path for new repositories.

Current implementation scope:
- Installer and setup flow (atlas_ai.ps1 and NewProject.bat).
- Root instruction stack (.github/copilot-instructions.md, ATLAS.md, AGENTS.md, CLAUDE.md).
- Docs scaffold under docs/agile, docs/cgr, docs/reference, patterns, scripts, and archive.
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
- Tighten documentation around setup and closeout.
