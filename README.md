# ntelio_ai

This folder is a reusable project-start kit for software repositories.

It gives you:
- root-level AI instruction files for Copilot, Claude Code, and Codex-style agents
- reusable ATLAS prompt files for realignment and closeout checks
- a default workflow for task execution and delivery tracking
- optional release stages and document gates for formal projects
- optional compliance and governance review prompt
- a starter docs scaffold for active work, backlog, status, retro, project docs, reference docs, and stack-baseline guidance

## What ntelio_ai Solves

The main problem with reusable instruction folders is that most AI tools do not reliably auto-load nested files. They usually look at the repository root.

ntelio_ai is designed for that reality.

You can keep this folder as your source kit, drop a copy into a new repository, and then install the correct files into the repo root.

## Split Repo Layouts

Some repositories keep control docs and AI instruction files at the repo root while the runnable application lives one level down, for example in `web/`, `api/`, or another product folder.

In that layout:
- keep the ntelio_ai instruction files at the repo root
- keep MRD, PRD, ESD, and `CGR-results.md` in the existing `docs/projects/` directory at the repo root
- use the nested application folder for runtime code work only
- only treat a child directory as the effective project root if the repo root has no `docs/projects/` directory and exactly one immediate child directory does

## Included Files

### Root instruction files
- `.github/copilot-instructions.md` -- source of truth for Copilot
- `CLAUDE.md` -- thin pointer for Claude Code
- `AGENTS.md` -- thin pointer for Codex-style agents and similar tooling
- `ATLAS.md` -- default development process
- `PS.md` -- optional project stages and document gates (EVT/DVT/PVT/GA)
- `CGR.md` -- optional compliance and governance review prompt

### Workflow prompts (installed by default)
- `.github/prompts/atlas-realign.prompt.md` -- ATLAS health check and realignment prompt
- `.github/prompts/atlas-closeout.prompt.md` -- ATLAS closeout readiness prompt

### Installer
- `ntelio_ai.ps1` -- copies kit files into the target repository root
- `.gitignore` -- default ignore patterns, copied to the target when `-InitGit` is used

### Startup seed file
- `seed.md` -- optional startup brief and usage notes for adoption runs. Keep high-level project intent here, then move it to `docs/reference/` during `-OrganizeExisting`.

This `README.md` is for the kit itself. It is not copied into the target repository by the installer.

### Scaffold
- `docs/agile/devcycle.md` -- active burn-down list
- `docs/agile/backlog.md` -- future work queue
- `docs/agile/status.md` -- current live state
- `docs/agile/retro.md` -- completed work log
- `docs/reference/README.md` -- reference docs guidance
- `docs/reference/stack-patterns/README.md` -- stack baseline guidance
- `scripts/README.md` -- scripts guidance
- `archive/README.md` -- archive guidance

### Skills (installed with -IncludeSkills)
- `.github/skills/azure-deploy/SKILL.md` -- Azure Functions and SWA deployment procedures
- `.github/skills/devcycle-management/SKILL.md` -- DT/RDT task lifecycle, retro logging, CU scoring
- `.github/skills/project-setup/SKILL.md` -- ntelio_ai adoption and repo bootstrapping
- `.github/skills/powershell-style/SKILL.md` -- PowerShell scripting conventions
- `.github/skills/git-workflow/SKILL.md` -- branch strategy, commit format, PR conventions
- `.github/skills/example-skill/SKILL.md` -- template for creating new skills

Skills reference existing kit files (ATLAS.md, copilot-instructions.md) rather than duplicating content. Use `-SkillsSource "path"` to copy skills from another location instead of the defaults.

### Stack pattern support

If a repository has an agreed architecture, hosting, deployment, infrastructure, or platform baseline, capture it in `docs/reference/stack-patterns/active-stack-pattern.md`.

When that file exists, the ntelio_ai instruction stack reads it before stack-sensitive work so architecture changes stay consistent with the repo's approved baseline.

### Project document templates (installed with -IncludePS or -IncludeCGR)
- `docs/projects/MRD_TEMPLATE.md` -- market or business requirements template
- `docs/projects/PRD_TEMPLATE.md` -- product requirements template
- `docs/projects/ESD_TEMPLATE.md` -- engineering design template

These are bootstrap files only. On the first CGR run, remove `MRD_TEMPLATE.md` and `PRD_TEMPLATE.md` if they are still present. In all cases, once a live MRD, PRD, or ESD artifact exists, remove the matching `*_TEMPLATE.md` file from `docs/projects/`.

When a governance review runs, save the output as `docs/projects/CGR-results.md`.

## Recommended Use

### Quick Start -- Point a project at ntelio_ai

The simplest way to adopt ntelio_ai is to copy or clone it into your project folder, then tell your AI agent to set it up. This works in VS Code with Copilot, Claude Code, or any Codex-style agent.

**Step 1:** Copy the `ntelio_ai` folder into your project root. You can clone it, copy it, or drop it in manually. Your project should look like this:

```
my-project/
  ntelio_ai/          <-- the kit
  src/              <-- your existing code
  ...
```

**Step 2:** Open the project in VS Code (or your editor with an AI agent). Then use one of these prompts.

#### Basic setup (most projects, POC, internal tools)

```text
ntelio_ai

Set up this project with ntelio_ai.

Tasks:
1. Read ntelio_ai/README.md, ntelio_ai/.github/copilot-instructions.md, ntelio_ai/ATLAS.md, and ntelio_ai/AGENTS.md.
2. Install the kit into the repository root using ntelio_ai/ntelio_ai.ps1 with -IncludeScaffold.
3. If this repository already has docs, plans, runbooks, notes, scripts, or project files, review them and reorganize them into the ntelio_ai structure where appropriate.
4. Do not blindly overwrite useful existing project files. Merge, move, or adapt existing content into the new structure.
5. Summarize what was installed, what was reorganized, and what was left untouched.
```

This installs the core workflow, AI instruction files, and docs scaffold. No release stages, no governance review. Good for POC work, internal tools, and exploratory development.

#### Setup with formal release stages (optional)

If the project needs EVT/DVT/PVT/GA release gates and MRD/PRD/ESD document requirements, add `-IncludePS` to the install step:

```text
ntelio_ai

Set up this project with ntelio_ai including formal release stages.

Tasks:
1. Read ntelio_ai/README.md, ntelio_ai/.github/copilot-instructions.md, ntelio_ai/ATLAS.md, ntelio_ai/PS.md, and ntelio_ai/AGENTS.md.
2. Install the kit into the repository root using ntelio_ai/ntelio_ai.ps1 with -IncludeScaffold -IncludePS.
3. If this repository already has docs, plans, runbooks, notes, scripts, or project files, review them and reorganize them into the ntelio_ai structure where appropriate.
4. Do not blindly overwrite useful existing project files. Merge, move, or adapt existing content into the new structure.
5. Summarize what was installed, what was reorganized, and what was left untouched.
```

#### Setup with governance review (optional)

If the project needs compliance and governance review (CGR), add `-IncludeCGR`. CGR works independently -- you can use it with or without PS:

```text
ntelio_ai

Set up this project with ntelio_ai including CGR.

Tasks:
1. Read ntelio_ai/README.md, ntelio_ai/.github/copilot-instructions.md, ntelio_ai/ATLAS.md, ntelio_ai/CGR.md, and ntelio_ai/AGENTS.md.
2. Install the kit into the repository root using ntelio_ai/ntelio_ai.ps1 with -IncludeScaffold -IncludeCGR.
3. If this repository already has docs, plans, runbooks, notes, scripts, or project files, review them and reorganize them into the ntelio_ai structure where appropriate.
4. Do not blindly overwrite useful existing project files. Merge, move, or adapt existing content into the new structure.
5. Summarize what was installed, what was reorganized, and what was left untouched.
```

#### Setup with both PS and CGR (optional)

If the project needs both project stages and governance review:

```text
ntelio_ai

Set up this project with ntelio_ai including PS and CGR.

Tasks:
1. Read ntelio_ai/README.md, ntelio_ai/.github/copilot-instructions.md, ntelio_ai/ATLAS.md, ntelio_ai/PS.md, ntelio_ai/CGR.md, and ntelio_ai/AGENTS.md.
2. Install the kit into the repository root using ntelio_ai/ntelio_ai.ps1 with -IncludeScaffold -IncludePS -IncludeCGR.
3. If this repository already has docs, plans, runbooks, notes, scripts, or project files, review them and reorganize them into the ntelio_ai structure where appropriate.
4. Do not blindly overwrite useful existing project files. Merge, move, or adapt existing content into the new structure.
5. Summarize what was installed, what was reorganized, and what was left untouched.
```

#### Adding release stages or CGR later

You can start with the basic setup and add `PS.md` or `CGR.md` later at any time:

```text
ntelio_ai

Add project stages to this project. Install PS.md from the ntelio_ai kit.
```

```text
ntelio_ai

Add governance review to this project. Install CGR.md from the ntelio_ai kit.
```

#### Adding git and GitHub to any setup

Add `-InitGit` to any install step above to initialize a git repository with a `.gitignore` and an initial commit. Add `-GitHubRepo "repo-name"` to also create a GitHub repository and push. Defaults to private -- add `-Public` for a public repo. Examples:

- `-IncludeScaffold -InitGit` -- scaffold plus git init
- `-IncludeScaffold -IncludePS -InitGit -GitHubRepo "my-project"` -- scaffold, PS, git, private GitHub repo
- `-IncludeScaffold -IncludeCGR -InitGit -GitHubRepo "org/my-project" -Public` -- scaffold, CGR, git, public GitHub repo under an org

Requires `git` on PATH. For `-GitHubRepo`, install the [GitHub CLI](https://cli.github.com/) and run `gh auth login` first.

### Full agent-driven adoption for an existing repo

If the project already has substantial docs, plans, scripts, and references that need sorting into the ntelio_ai structure, use this more detailed prompt:

```text
ntelio_ai

Adopt the ntelio_ai process into this repository.

Tasks:
1. Read ntelio_ai/README.md, ntelio_ai/.github/copilot-instructions.md, ntelio_ai/ATLAS.md, and ntelio_ai/AGENTS.md.
2. Install the kit into the repository root using ntelio_ai/ntelio_ai.ps1 with -IncludeScaffold.
3. If this repository already has docs, plans, runbooks, notes, scripts, or project files, review them and reorganize them into the ntelio_ai structure where appropriate.
4. Create or update these folders and files when needed:
	- docs/agile/devcycle.md
	- docs/agile/backlog.md
	- docs/agile/status.md
	- docs/agile/retro.md
	- docs/projects/
	- docs/reference/
	- scripts/
	- archive/
5. Do not blindly overwrite useful existing project files. Merge, move, or adapt existing content into the new structure.
6. Preserve project-specific facts, but keep reusable AI instruction files generic.
7. If existing files overlap with the kit, prefer the repo's real project content and fit it into the process.
8. Update the active task list, status, and retro docs based on the repository's current state if enough information exists.
9. Summarize what was installed, what was reorganized, what was left untouched, and any ambiguities that still need a human decision.
10. If unplanned blocker work appears during the current devcycle, add it as an `RDT` reset devtask ahead of the remaining unfinished planned devtasks.

Rules:
- Treat ATLAS.md as the default process.
- Keep completed work out of devcycle.md.
- Use `RDT` for reset devtasks.
- Insert new `RDT` items ahead of the remaining unfinished planned devcycle tasks.
- Put active work in devcycle.md, future work in backlog.md, current live state in status.md, and completed work in retro.md.
- Put project requirements and design docs in docs/projects/.
- Put setup notes, runbooks, integration details, and operational references in docs/reference/.
- Put reusable scripts in scripts/.
- Put superseded or one-off artifacts in archive/.
- Do not hardcode secrets, tenants, URLs, or credentials into reusable instruction files.
- Ask only if a decision cannot be made from the repo contents.
```

Add `-IncludePS` and/or `-IncludeCGR` to the install step if the project needs project stages or governance review.

### Manual setup (no agent)

If you do not want to use an agent prompt, run the installer directly:

```powershell
# Chat-only equivalent of NewProject.bat (run from project root)
pwsh -File .\ntelio_ai\ntelio_ai.ps1 -IncludeScaffold -OrganizeExisting -InitGit -SeedPath .\ntelio_ai -RemoveSeed

# Basic -- core workflow and scaffold only
pwsh -File .\ntelio_ai\ntelio_ai.ps1 -IncludeScaffold

# Add project stages
pwsh -File .\ntelio_ai\ntelio_ai.ps1 -IncludeScaffold -IncludePS

# Add governance review
pwsh -File .\ntelio_ai\ntelio_ai.ps1 -IncludeScaffold -IncludeCGR

# Everything
pwsh -File .\ntelio_ai\ntelio_ai.ps1 -IncludeScaffold -IncludePS -IncludeCGR

# Reorganize existing docs and scripts into project folders before install copy
pwsh -File .\ntelio_ai\ntelio_ai.ps1 -IncludeScaffold -OrganizeExisting

# Initialize git repo with .gitignore and initial commit
pwsh -File .\ntelio_ai\ntelio_ai.ps1 -IncludeScaffold -InitGit

# Initialize git and create a private GitHub repo
pwsh -File .\ntelio_ai\ntelio_ai.ps1 -IncludeScaffold -InitGit -GitHubRepo "my-project"

# Initialize git and create a public GitHub repo
pwsh -File .\ntelio_ai\ntelio_ai.ps1 -IncludeScaffold -InitGit -GitHubRepo "my-project" -Public

# Everything -- scaffold, PS, CGR, git, and GitHub
pwsh -File .\ntelio_ai\ntelio_ai.ps1 -IncludeScaffold -IncludePS -IncludeCGR -InitGit -GitHubRepo "my-project"

# Preview without copying
pwsh -File .\ntelio_ai\ntelio_ai.ps1 -IncludeScaffold -IncludePS -IncludeCGR -InitGit -WhatIf

# Overwrite existing files
pwsh -File .\ntelio_ai\ntelio_ai.ps1 -IncludeScaffold -IncludePS -IncludeCGR -Force
```

Chat shortcut: in AI chat, you can say `newproject` and the agent should execute the same non-interactive installer flow.

`-OrganizeExisting` reviews existing non-code artifacts in the target root and moves matched files into `docs/agile`, `docs/projects`, `docs/reference`, `scripts`, or `archive` using filename and extension heuristics. Startup-oriented files such as `todo`, `seed`, `startup`, `kickoff`, and `project-start` are treated as reference inputs and moved to `docs/reference`. It does not reorganize the seed folder itself. `-InitGit` copies the `.gitignore` from the kit, runs `git init` (if needed), and makes an initial commit with project artifacts only. `-GitHubRepo` creates a GitHub repository using the `gh` CLI (defaults to private, add `-Public` for public). `-GitHubRepo` implies `-InitGit`.

Prerequisites: `git` must be on PATH. For `-GitHubRepo`, install the [GitHub CLI](https://cli.github.com/) and run `gh auth login` first.

Or manually copy the files you want from `ntelio_ai/` to the repository root:
- `.github/copilot-instructions.md` -- always
- `.github/prompts/atlas-realign.prompt.md` -- recommended
- `.github/prompts/atlas-closeout.prompt.md` -- recommended
- `CLAUDE.md` -- always
- `AGENTS.md` -- always
- `ATLAS.md` -- always
- `PS.md` -- only if the project uses formal project stages
- `CGR.md` -- only if the project uses governance review
- the `docs/`, `scripts/`, and `archive/` scaffold as needed

## Symlink and Cleanup

### Using a symlink or junction instead of copying

You can keep one master copy of ntelio_ai and link it into any project instead of copying the folder each time:

```powershell
# From your project root
New-Item -ItemType SymbolicLink -Path .\ntelio_ai -Target "C:\path\to\your\master\ntelio_ai"
```

If symbolic links are restricted on your machine, a junction also works:

```powershell
# From your project root
New-Item -ItemType Junction -Path .\ntelio_ai -Target "C:\path\to\your\master\ntelio_ai"
```

The installer resolves paths through symlinks and junctions, so it works the same as a real copy. Files get installed into the project root, not into the link target.

### Deleting ntelio_ai after install

The installer copies all selected files out of `ntelio_ai/` into the repository root. After that, the `ntelio_ai/` folder is no longer needed for the project to function.

`NewProject.bat` treats `ntelio_ai/` as a one-shot seed. During git initialization, the seed path is excluded from staging so commits contain only installed project artifacts.

After a successful run, it schedules removal of the seed path it ran from, unless that seed path is currently tracked by git.

If startup-oriented files were moved into `docs/reference`, decide whether to generate the initial `docs/agile/devcycle.md` from those reference files only after seed cleanup is complete.

If that path is a symlink or junction, only the link is removed. The master ntelio_ai folder that the link points to is left untouched.

If you want to keep the seed folder or link around so you can re-run installs later, use `ntelio_ai.ps1` directly instead of `NewProject.bat`.

## Auto-Loading Notes

### Copilot

Copilot is most likely to honor `.github/copilot-instructions.md` when it exists in the repository root.

### Claude Code

Claude Code commonly checks `CLAUDE.md` in the repository root.

### Codex-style agents

Many Codex-style tools and repo agents check `AGENTS.md` in the repository root.

### Important limitation

If this kit remains nested and you do not copy the files to the repository root, automatic loading may not happen.

## Stack Patterns

If the repository has an agreed stack baseline, create `docs/reference/stack-patterns/active-stack-pattern.md` and keep it current.

The ntelio_ai instruction files and prompts treat that file as the source of truth for stack-sensitive work, such as architecture, hosting, deployment, infrastructure, and platform-selection changes.

## Existing Repo Adoption

Use the Quick Start prompts above. The "Full agent-driven adoption" prompt handles repos with existing docs, plans, and scripts. The agent will sort existing content into the ntelio_ai structure without erasing it.

## How To Customize For A New Project

Safe to customize:
- `docs/agile/devcycle.md`
- `docs/agile/backlog.md`
- `docs/agile/status.md`
- `docs/agile/retro.md`
- project docs under `docs/projects/`
- reference docs under `docs/reference/`
- repo config files

Keep generic unless the repo itself needs a different process:
- `.github/copilot-instructions.md`
- `CLAUDE.md`
- `AGENTS.md`
- `ATLAS.md`

Project-specific values belong in:
- `docs/projects/`
- `docs/reference/`
- non-secret config files
- secret stores and environment variables for credentials

## Suggested New Repo Setup

After installing the kit into a new repository:

1. Create or update `.gitignore` to ignore local config overrides, `.env`, secrets, and `archive/` if desired.
2. Create the initial `devcycle.md` items for the first build phase.
3. Add CLI or script smoketests and a `UAT:` section to each devtask. For non-user-facing work, use `Not UAT-eligible` and name the internal validation.
4. Add repo-specific setup notes in `docs/reference/`, and if the repo has an agreed architecture baseline, capture it in `docs/reference/stack-patterns/active-stack-pattern.md`.
5. If the repo uses git, create one commit per completed `DT` or `RDT`. If the repo has a GitHub remote, push the branch and update or create the related pull request after each completed task.
6. Optionally, add `PS.md` later if the project grows into formal release stages.
7. Optionally, add `CGR.md` later if the project needs governance review.

## Design Principles

- Reusable by default
- Project-specific details live outside the AI instruction files
- No secrets in committed instruction files
- Root-level instruction files for tool compatibility
- Active work kept separate from historical logs

## Maintenance

If you improve the process, update these files in this kit folder first, then copy or reinstall them into target repositories.

## Glossary

- `Phase`: A larger delivery grouping. In practice, treat a phase like an epic-level container for related work.
- `Devcycle`: The active burn-down of current planned work.
- `Devtask`: A discrete unit of planned implementation work inside the current devcycle.
- `DT`: Planned devtask identifier, for example `DT1`, `DT2`, `DT3`.
- `Reset Devtask`: An unplanned task discovered during the current devcycle that must interrupt the planned sequence.
- `RDT`: Reset devtask identifier, for example `RDT1`, `RDT2`, `RDT3`.
- `MOE`: Measure of Effort. The effort model used in this process.
- `CU`: Complexity Unit. The base effort-sizing unit in this process. A `CU` measures combined human-plus-agent delivery effort, including complexity, uncertainty, coordination, validation, and decision load, not just human time.
- `eMOE`: Estimated Measure of Effort. The planned effort score assigned before the work starts, expressed in `CU`.
- `aMOE`: Actual Measure of Effort. The final effort score recorded after the work is complete, expressed in `CU`.
- `CU`, `eMOE`, and `aMOE` relate like this: `CU` is the unit, `eMOE` is the estimated number of `CU`, and `aMOE` is the actual number of `CU`.
- Why this matters: in a human-only workflow, MOE often tracked human time. In an agent workflow, human time alone is misleading. A task that once took a human 1 hour might take an agent 1 minute, but the real effort still includes prompting, review, testing, integration, and ship decisions.
- `UAT`: User Acceptance Testing. Every devtask should include a `UAT:` section. For internal work, use `Not UAT-eligible` and record the required internal validation instead of a human handoff.
- `Smoketest`: The minimum repeatable verification that confirms the task works, executed by CLI commands or a script.
- `MRD`: Market Requirements Document.
- `PRD`: Product Requirements Document.
- `ESD`: Engineering Specification or Engineering Design document.
- `PS`: Project Stages. The optional EVT/DVT/PVT/GA release lifecycle defined in `PS.md`.
- `CGR`: Compliance and Governance Review.

## Acronym Rules

- Use `DT` for planned devtasks in `devcycle.md`.
- Use `RDT` for reset devtasks that interrupt the current devcycle.
- New `RDT` items are inserted ahead of the remaining unfinished planned `DT` items.
- Record both `eMOE` and `aMOE` in `retro.md` for completed `DT` and `RDT` items.
- Estimate in `CU` before starting, then record the actual `CU` after completion.