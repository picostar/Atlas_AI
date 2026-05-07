# atlas_ai

This folder is a reusable project-start kit for software repositories.

It gives you:
- root-level AI instruction files for Copilot, Claude Code, and Codex-style agents
- reusable ATLAS prompt files for realignment and closeout checks
- a default workflow for task execution and delivery tracking
- optional release stages and document gates for formal projects
- optional compliance and governance review prompt
- a starter docs scaffold for active work, backlog, status, retro, project docs, reference docs, stack-baseline guidance, and UX-baseline guidance

## What atlas_ai Solves

The main problem with reusable instruction folders is that most AI tools do not reliably auto-load nested files. They usually look at the repository root.

atlas_ai is designed for that reality.

You can keep this folder as your source kit, drop a copy into a new repository, and then install the correct files into the repo root.

## Split Repo Layouts

Some repositories keep control docs and AI instruction files at the repo root while the runnable application lives one level down, for example in `web/`, `api/`, or another product folder.

In that layout:
- keep the atlas_ai instruction files at the repo root
- keep MRD, PRD, ESD, and `CGR-results.md` in the existing `docs/cgr/` directory at the repo root
- use the nested application folder for runtime code work only
- only treat a child directory as the effective project root if the repo root has no `docs/cgr/` directory and exactly one immediate child directory does

## Included Files

### Root instruction files
- `.github/copilot-instructions.md` -- source of truth for Copilot
- `CLAUDE.md` -- thin pointer for Claude Code
- `CHATGPT.md` -- thin pointer for ChatGPT-oriented workflows
- `GEMINI.md` -- thin pointer for Gemini-oriented workflows
- `AGENTS.md` -- thin pointer for Codex-style agents and similar tooling
- `ATLAS.md` -- default development process
- `PS.md` -- optional project stages and document gates (EVT/DVT/PVT/GA)
- `CGR.md` -- optional compliance and governance review prompt

### AI governance docs
- `.github/TOOLING-ASSUMPTIONS.md` -- capability and tooling assumptions
- `.github/TOOL-CAPABILITY-MATRIX.md` -- portability matrix across agent environments
- `.github/FRONTMATTER-SCHEMA.md` -- prompt and skill metadata contract
- `.github/INSTRUCTION-MAINTENANCE.md` -- instruction update and drift rules

### Workflow prompts (installed by default)
- `.github/prompts/atlas-realign.prompt.md` -- ATLAS health check and realignment prompt
- `.github/prompts/atlas-closeout.prompt.md` -- ATLAS closeout readiness prompt
- `.github/prompts/cgr-seed-to-cgr.prompt.md` -- generate draft MRD PRD ESD from seed and reference material, then run CGR outputs
- `.github/prompts/cgr-iterate.prompt.md` -- iterate and improve governance docs using CGR-results and score

### Installer
- `atlas_ai.ps1` -- copies kit files into the target repository root
- `.gitignore` -- default ignore patterns, copied to the target when `-InitGit` is used

### Startup seed file
- `seed.md` -- optional startup brief and usage notes for adoption runs. Keep high-level project intent here, then move it to `docs/reference/` during `-OrganizeExisting`.
- `secrets.md` -- local-only secrets note file stored at repo root and ignored by git. Keep credentials and keys here, not in committed files.

This `README.md` is for the kit itself. It is not copied into the target repository by the installer.

### Scaffold
- `docs/agile/devcycle.md` -- active burn-down list
- `docs/agile/backlog.md` -- future work queue
- `docs/agile/status.md` -- current live state
- `docs/agile/retro.md` -- completed work log
- `docs/cgr/README.md` -- governance document guidance
- `docs/reference/README.md` -- reference docs guidance
- `patterns/README.md` -- pattern catalog root guidance
- `patterns/stack-patterns/README.md` -- stack baseline guidance
- `patterns/stack-patterns/stack-pattern-templates/` -- reusable Azure stack pattern templates
- `patterns/ux-patterns/README.md` -- UX baseline guidance
- `patterns/ux-patterns/ux-pattern-templates/` -- reusable UX pattern templates
- `scripts/README.md` -- scripts guidance
- `archive/README.md` -- archive guidance

### Skills (installed with -IncludeSkills)
- `.github/skills/azure-deploy/SKILL.md` -- Azure Functions and SWA deployment procedures
- `.github/skills/devcycle-management/SKILL.md` -- DT/RDT task lifecycle, retro logging, CU scoring
- `.github/skills/project-setup/SKILL.md` -- atlas_ai adoption and repo bootstrapping
- `.github/skills/powershell-style/SKILL.md` -- PowerShell scripting conventions
- `.github/skills/git-workflow/SKILL.md` -- branch strategy, commit format, PR conventions
- `.github/skills/example-skill/SKILL.md` -- template for creating new skills

Skills reference existing kit files (ATLAS.md, copilot-instructions.md) rather than duplicating content. Use `-SkillsSource "path"` to copy skills from another location instead of the defaults.

### Stack pattern support

If a repository has an agreed architecture, hosting, deployment, infrastructure, or platform baseline, capture it in `patterns/stack-patterns/active-stack-pattern.md`.

When that file exists, the atlas_ai instruction stack reads it before stack-sensitive work so architecture changes stay consistent with the repo's approved baseline.

`NewProject.bat` now prompts for a stack pattern choice during setup. You can choose a template or none.
If a template is selected, setup creates `patterns/stack-patterns/active-stack-pattern.md` from that template.

### UX pattern support

If a repository has an agreed layout and navigation baseline, capture it in `patterns/ux-patterns/active-ux-pattern.md`.

When that file exists, the atlas_ai instruction stack reads it before UX-sensitive work so generated UI and page structure stay consistent with the repo's approved baseline.

`NewProject.bat` now prompts for a UX pattern choice during setup. You can choose a template or none.
If a template is selected, setup creates `patterns/ux-patterns/active-ux-pattern.md` from that template.

### API-first policy support

`NewProject.bat` prompts for API-first defaults and uses Yes as the default.

The installer writes `docs/reference/api-first-policy.md` to record the selected mode.

When API-first mode is enabled, each DT or RDT should produce an API result when feasible, and smoketests should verify API endpoints plus OpenAPI or Swagger docs when feasible.

### Project document templates (installed with -IncludePS or -IncludeCGR)
- `docs/cgr/MRD_TEMPLATE.md` -- market or business requirements template
- `docs/cgr/PRD_TEMPLATE.md` -- product requirements template
- `docs/cgr/ESD_TEMPLATE.md` -- engineering design template

These are bootstrap files only. On the first CGR run, remove `MRD_TEMPLATE.md` and `PRD_TEMPLATE.md` if they are still present. In all cases, once a live MRD, PRD, or ESD artifact exists, remove the matching `*_TEMPLATE.md` file from `docs/cgr/`.

When a governance review runs, save the output as `docs/cgr/CGR-results.md`.

Chat shortcut: in AI chat, type `CGR` to run the CGR workflow from `CGR.md`.

Optional scoring extension: teams that want numeric governance tracking can derive a scorecard from `docs/cgr/CGR-results.md` and save it as `docs/cgr/score.md`.

For seeded projects, teams can bootstrap governance drafts from `seed.md` and `docs/reference/` using `.github/prompts/cgr-seed-to-cgr.prompt.md`, then iteratively improve with `.github/prompts/cgr-iterate.prompt.md` using `docs/cgr/CGR-results.md` and `docs/cgr/score.md`.

### What CGR Means And Why It Matters

CGR means Compliance and Governance Review.

In atlas_ai, CGR is a structured governance gate that reviews live project documents for completeness, decision quality, risk controls, and readiness to proceed.

Why this matters:
- It detects documentation and governance gaps before downstream delivery risk increases.
- It aligns product, engineering, security, and operations expectations before release progression.
- It produces a durable review artifact (`docs/cgr/CGR-results.md`) that teams can track and close.

## Recommended Use

### Quick Start -- Point a project at atlas_ai

The simplest way to adopt atlas_ai is to copy or clone it into your project folder, then tell your AI agent to set it up. This works in VS Code with Copilot, Claude Code, or any Codex-style agent.

**Step 1:** Copy the `atlas_ai` folder into your project root. You can clone it, copy it, or drop it in manually. Your project should look like this:

```
my-project/
  atlas_ai/          <-- the kit
  src/              <-- your existing code
  ...
```

**Step 2:** Open the project in VS Code (or your editor with an AI agent). Then use one of these prompts.

#### Basic setup (most projects, POC, internal tools)

```text
atlas_ai

Set up this project with atlas_ai.

Tasks:
1. Read atlas_ai/README.md, atlas_ai/.github/copilot-instructions.md, atlas_ai/ATLAS.md, and atlas_ai/AGENTS.md.
2. Install the kit into the repository root using atlas_ai/atlas_ai.ps1 with -IncludeScaffold.
3. If this repository is messy and you use `-OrganizeExisting`, existing files are moved into `docs/reference/` for triage. Keep `seed.md` and `secrets.md` in place.
4. Do not blindly overwrite useful existing project files. Merge, move, or adapt existing content into the new structure.
5. Summarize what was installed, what was reorganized, and what was left untouched.
```

This installs the core workflow, AI instruction files, and docs scaffold. No release stages, no governance review. Good for POC work, internal tools, and exploratory development.

#### Setup with formal release stages (optional)

If the project needs EVT/DVT/PVT/GA release gates and MRD/PRD/ESD document requirements, add `-IncludePS` to the install step:

```text
atlas_ai

Set up this project with atlas_ai including formal release stages.

Tasks:
1. Read atlas_ai/README.md, atlas_ai/.github/copilot-instructions.md, atlas_ai/ATLAS.md, atlas_ai/PS.md, and atlas_ai/AGENTS.md.
2. Install the kit into the repository root using atlas_ai/atlas_ai.ps1 with -IncludeScaffold -IncludePS.
3. If this repository is messy and you use `-OrganizeExisting`, existing files are moved into `docs/reference/` for triage. Keep `seed.md` and `secrets.md` in place.
4. Do not blindly overwrite useful existing project files. Merge, move, or adapt existing content into the new structure.
5. Summarize what was installed, what was reorganized, and what was left untouched.
```

#### Setup with governance review (optional)

If the project needs compliance and governance review (CGR), add `-IncludeCGR`. CGR works independently -- you can use it with or without PS:

```text
atlas_ai

Set up this project with atlas_ai including CGR.

Tasks:
1. Read atlas_ai/README.md, atlas_ai/.github/copilot-instructions.md, atlas_ai/ATLAS.md, atlas_ai/CGR.md, and atlas_ai/AGENTS.md.
2. Install the kit into the repository root using atlas_ai/atlas_ai.ps1 with -IncludeScaffold -IncludeCGR.
3. If this repository is messy and you use `-OrganizeExisting`, existing files are moved into `docs/reference/` for triage. Keep `seed.md` and `secrets.md` in place.
4. Do not blindly overwrite useful existing project files. Merge, move, or adapt existing content into the new structure.
5. Summarize what was installed, what was reorganized, and what was left untouched.
```

#### Setup with both PS and CGR (optional)

If the project needs both project stages and governance review:

```text
atlas_ai

Set up this project with atlas_ai including PS and CGR.

Tasks:
1. Read atlas_ai/README.md, atlas_ai/.github/copilot-instructions.md, atlas_ai/ATLAS.md, atlas_ai/PS.md, atlas_ai/CGR.md, and atlas_ai/AGENTS.md.
2. Install the kit into the repository root using atlas_ai/atlas_ai.ps1 with -IncludeScaffold -IncludePS -IncludeCGR.
3. If this repository is messy and you use `-OrganizeExisting`, existing files are moved into `docs/reference/` for triage. Keep `seed.md` and `secrets.md` in place.
4. Do not blindly overwrite useful existing project files. Merge, move, or adapt existing content into the new structure.
5. Summarize what was installed, what was reorganized, and what was left untouched.
```

#### Adding release stages or CGR later

You can start with the basic setup and add `PS.md` or `CGR.md` later at any time:

```text
atlas_ai

Add project stages to this project. Install PS.md from the atlas_ai kit.
```

```text
atlas_ai

Add governance review to this project. Install CGR.md from the atlas_ai kit.
```

#### Adding git and GitHub to any setup

Add `-InitGit` to any install step above to initialize a git repository with a `.gitignore` and an initial commit. Add `-GitHubRepo "repo-name"` to also create a GitHub repository and push. Use `-GitHubOwner "account-or-org"` to specify which GitHub account or organization the repo is created under. Defaults to private -- add `-Public` for a public repo. If the GitHub CLI is not authenticated, the script will launch `gh auth login` automatically. Examples:

- `-IncludeScaffold -InitGit` -- scaffold plus git init
- `-IncludeScaffold -IncludePS -InitGit -GitHubRepo "my-project" -GitHubOwner "myusername"` -- scaffold, PS, git, private GitHub repo under a specific account
- `-IncludeScaffold -IncludeCGR -InitGit -GitHubRepo "my-project" -GitHubOwner "my-org" -Public` -- scaffold, CGR, git, public GitHub repo under an org

Requires `git` on PATH. For `-GitHubRepo`, install the [GitHub CLI](https://cli.github.com/). Login is handled automatically if needed.

### Full agent-driven adoption for an existing repo

If the project already has substantial docs, plans, scripts, and references that need sorting into the atlas_ai structure, use this more detailed prompt:

```text
atlas_ai

Adopt the atlas_ai process into this repository.

Tasks:
1. Read atlas_ai/README.md, atlas_ai/.github/copilot-instructions.md, atlas_ai/ATLAS.md, and atlas_ai/AGENTS.md.
2. Install the kit into the repository root using atlas_ai/atlas_ai.ps1 with -IncludeScaffold.
3. If this repository is messy and you use `-OrganizeExisting`, existing files are moved into `docs/reference/` for triage. Keep `seed.md` and `secrets.md` in place.
4. Create or update these folders and files when needed:
	- docs/agile/devcycle.md
	- docs/agile/backlog.md
	- docs/agile/status.md
	- docs/agile/retro.md
	- docs/cgr/
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
- With `-OrganizeExisting`, move existing files into docs/reference first for triage, except seed.md and secrets.md.
- Treat existing MRD, PRD, and ESD files as reference inputs and create source-of-truth MRD, PRD, and ESD artifacts in docs/cgr/.
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
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -ApiFirst -OrganizeExisting -InitGit -SeedPath .\atlas_ai -RemoveSeed

# Update an older atlas project to the latest kit (safe refresh + verification + self-delete)
pwsh -File .\atlas_ai\updateatlas.ps1 -ProjectRoot .

# Batch wrapper for the updater
.\atlas_ai\UpdateAtlas.bat

# Basic -- core workflow and scaffold only
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold

# Include scaffold with API-first defaults explicitly enabled
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -ApiFirst

# Include scaffold and explicitly disable API-first defaults
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -NoApiFirst

# Add project stages
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -IncludePS

# Add governance review
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -IncludeCGR

# Everything
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -IncludePS -IncludeCGR

# Include scaffold and set active stack pattern from template by filename
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -StackPattern "sp-01-functions-tables-swa-keyvault.md"

# Include scaffold and set active stack pattern using full template-relative path
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -StackPattern "patterns/stack-patterns/stack-pattern-templates/sp-02-functions-tables-sqlserverless-swa-keyvault.md"

# Include scaffold and set active UX pattern from template by filename
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -UxPattern "uxp-01-modern-app-shell-layout.md"

# Include scaffold and set active UX pattern using full template-relative path
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -UxPattern "patterns/ux-patterns/ux-pattern-templates/uxp-01-modern-app-shell-layout.md"

# Reorganize existing files into docs/reference for triage before install copy
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -OrganizeExisting

# Initialize git repo with .gitignore and initial commit
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -InitGit

# Initialize git and create a private GitHub repo under a specific account
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -InitGit -GitHubRepo "my-project" -GitHubOwner "myusername"

# Initialize git and create a public GitHub repo under an org
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -InitGit -GitHubRepo "my-project" -GitHubOwner "my-org" -Public

# Everything -- scaffold, PS, CGR, git, and GitHub
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -IncludePS -IncludeCGR -InitGit -GitHubRepo "my-project" -GitHubOwner "myusername"

# Preview without copying
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -IncludePS -IncludeCGR -InitGit -WhatIf

# Overwrite existing files
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -IncludePS -IncludeCGR -Force
```

Chat shortcut: in AI chat, you can say `newproject` and the agent should execute the same non-interactive installer flow.

`-OrganizeExisting` reviews existing non-code artifacts in the target root and moves matched files into `docs/agile`, `docs/cgr`, `docs/reference`, `scripts`, or `archive` using filename and extension heuristics. Startup-oriented files such as `todo`, `seed`, `startup`, `kickoff`, and `project-start` are treated as reference inputs and moved to `docs/reference`. It does not reorganize the seed folder itself. `-StackPattern` accepts a stack pattern template filename or template-relative path and sets `patterns/stack-patterns/active-stack-pattern.md` from that template. `-UxPattern` accepts a UX pattern template filename or template-relative path and sets `patterns/ux-patterns/active-ux-pattern.md` from that template. `-InitGit` copies the `.gitignore` from the kit, runs `git init` (if needed), and makes an initial commit with project artifacts only. `-GitHubRepo` creates a GitHub repository using the `gh` CLI (defaults to private, add `-Public` for public). Use `-GitHubOwner` to specify the GitHub account or org. If not logged in, the script runs `gh auth login` automatically. `-GitHubRepo` implies `-InitGit`.

Prerequisites: `git` must be on PATH. For `-GitHubRepo`, install the [GitHub CLI](https://cli.github.com/). Login is handled automatically if needed.

### One-time layout migration (legacy repos)

If an existing repo still uses legacy paths (`docs/projects/` and `docs/reference/*-patterns`), run:

```powershell
pwsh -File .\scripts\migrate-layout-v2.ps1 -RepoRoot .
```

Dry run:

```powershell
pwsh -File .\scripts\migrate-layout-v2.ps1 -RepoRoot . -WhatIf
```

This migration is idempotent and safe to re-run.

### One-step updater for older atlas projects

If your repository was created with an older atlas kit, run:

```powershell
pwsh -File .\atlas_ai\updateatlas.ps1 -ProjectRoot .
```

What it does:
- reviews the current project structure and detects optional components already in use (`PS.md`, `CGR.md`, `.github/skills`)
- runs git safety preflight in git repos (clean working tree, fetch and sync check against upstream when available)
- creates a rollback tag before making changes (default behavior)
- refreshes core instruction files with `-Force` so old kit logic is updated
- runs a non-destructive scaffold pass (no `-Force`) plus installer verification
- runs legacy layout migration when needed (`docs/projects` and `docs/reference/*-patterns`)
- performs post-update checks for required files and migration completion
- removes updater seed artifacts after a successful run by default

Useful options:
- `-SourcePath "C:\path\to\atlas_ai"` to use a local kit instead of downloading from GitHub
- `-SkipLayoutMigration` to skip path migration even if legacy paths are detected
- `-SkipGitSafetyChecks` to bypass clean-tree and upstream sync preflight (not recommended)
- `-SkipGitFetch` to skip `git fetch --prune origin` during preflight
- `-NoRollbackTag` to skip creating the pre-update rollback tag
- `-PushRollbackTag` to push the rollback tag to `origin` for team-visible rollback
- `-KeepSeedArtifacts` to keep the copied `atlas_ai` folder after success
- `-NoSelfDelete` to keep the updater script after success
- `-WhatIf` to preview actions

Windows batch wrapper:

```bat
.\atlas_ai\UpdateAtlas.bat
```

`UpdateAtlas.bat` auto-selects `ProjectRoot` by location:
- if the wrapper is inside an `atlas_ai` folder, it targets the parent folder
- otherwise it targets the wrapper's current folder

The wrapper forwards any arguments to the PowerShell updater, for example:

```bat
.\atlas_ai\UpdateAtlas.bat -WhatIf -NoSelfDelete
```

Quick checklist:
1. Put `atlas_ai` in the old project root (copy, symlink, or junction).
2. Clean your git working tree (`git status` should be clean).
3. Preview: `.\atlas_ai\UpdateAtlas.bat -WhatIf`
4. Run update: `.\atlas_ai\UpdateAtlas.bat`
5. Optional team rollback tag: `.\atlas_ai\UpdateAtlas.bat -PushRollbackTag`
6. Review diff and commit.

### UpdateAtlas.bat step by step

Prerequisite:
- This flow assumes your old project has an `atlas_ai` folder at project root (copied kit or symlink/junction).

1. Copy or link `atlas_ai` into your old project root if it is not already present.
2. Commit or stash your current work so the repository is clean.
3. Open a terminal in the project root (the folder that contains `atlas_ai`).
4. Run a preview first:

```bat
.\atlas_ai\UpdateAtlas.bat -WhatIf
```

5. Run the real update:

```bat
.\atlas_ai\UpdateAtlas.bat
```

6. Optional, create and push a team-visible rollback tag before update:

```bat
.\atlas_ai\UpdateAtlas.bat -PushRollbackTag
```

7. Review changes:

```powershell
git status
git diff
```

8. If you need rollback:

```powershell
git tag --list "pre-updateatlas-*"
git reset --hard <tag-name>
```

Cleanup behavior after success:
- By default, `updateatlas` removes seed artifacts used only for update, including the copied `atlas_ai` folder it ran from, when that path is not tracked by git.
- If that seed path appears tracked by git, cleanup is skipped for safety and a warning is printed.
- Use `-KeepSeedArtifacts` to always keep the copied `atlas_ai` folder.
- Use `-NoSelfDelete` to keep updater artifacts for debugging, which also skips automatic seed artifact cleanup.

Placement guidance:
- `atlas_ai.ps1` stays at the kit root because existing setup flows and docs call it there.
- `updateatlas.ps1` can live at kit root or under `scripts/`. `UpdateAtlas.bat` checks both locations.
- `updateatlas.ps1` is intended as a one-shot updater and self-deletes by default on success.
- `scripts/migrate-layout-v2.ps1` is a reusable migration utility and should remain in `scripts/`.

Or manually copy the files you want from `atlas_ai/` to the repository root:
- `.github/copilot-instructions.md` -- always
- `.github/prompts/atlas-realign.prompt.md` -- recommended
- `.github/prompts/atlas-closeout.prompt.md` -- recommended
- `CLAUDE.md` -- always
- `CHATGPT.md` -- optional pointer for ChatGPT-oriented workflows
- `GEMINI.md` -- optional pointer for Gemini-oriented workflows
- `AGENTS.md` -- always
- `ATLAS.md` -- always
- `PS.md` -- only if the project uses formal project stages
- `CGR.md` -- only if the project uses governance review
- the `docs/`, `scripts/`, and `archive/` scaffold as needed

## Symlink and Cleanup

### Using a symlink or junction instead of copying

You can keep one master copy of atlas_ai and link it into any project instead of copying the folder each time:

```powershell
# From your project root
New-Item -ItemType SymbolicLink -Path .\atlas_ai -Target "C:\path\to\your\master\atlas_ai"
```

If symbolic links are restricted on your machine, a junction also works:

```powershell
# From your project root
New-Item -ItemType Junction -Path .\atlas_ai -Target "C:\path\to\your\master\atlas_ai"
```

The installer resolves paths through symlinks and junctions, so it works the same as a real copy. Files get installed into the project root, not into the link target.

### Deleting atlas_ai after install

The installer copies all selected files out of `atlas_ai/` into the repository root. After that, the `atlas_ai/` folder is no longer needed for the project to function.

`NewProject.bat` treats `atlas_ai/` as a one-shot seed. During git initialization, the seed path is excluded from staging so commits contain only installed project artifacts.

After a successful run, it schedules removal of the seed path it ran from, unless that seed path is currently tracked by git.

If startup-oriented files were moved into `docs/reference`, decide whether to generate the initial `docs/agile/devcycle.md` from those reference files only after seed cleanup is complete.

If that path is a symlink or junction, only the link is removed. The master atlas_ai folder that the link points to is left untouched.

If you want to keep the seed folder or link around so you can re-run installs later, use `atlas_ai.ps1` directly instead of `NewProject.bat`.

## Auto-Loading Notes

### Copilot

Copilot is most likely to honor `.github/copilot-instructions.md` when it exists in the repository root.

### Claude Code

Claude Code commonly checks `CLAUDE.md` in the repository root.

### Codex-style agents

Many Codex-style tools and repo agents check `AGENTS.md` in the repository root.

### ChatGPT and Gemini

ChatGPT and Gemini workflows can use `CHATGPT.md` and `GEMINI.md` as thin pointers to the source of truth and `ATLAS.md` when auto-loading is available. If auto-loading is not available in the current tool, load these files manually at session start.

### Important limitation

If this kit remains nested and you do not copy the files to the repository root, automatic loading may not happen.

## Stack Patterns

If the repository has an agreed stack baseline, create `patterns/stack-patterns/active-stack-pattern.md` and keep it current.

The atlas_ai instruction files and prompts treat that file as the source of truth for stack-sensitive work, such as architecture, hosting, deployment, infrastructure, and platform-selection changes.

## UX Patterns

If the repository has an agreed UX baseline, create `patterns/ux-patterns/active-ux-pattern.md` and keep it current.

The atlas_ai instruction files and prompts treat that file as the source of truth for UX-sensitive work, such as layout, navigation, page hierarchy, and UI generation changes.

## Existing Repo Adoption

Use the Quick Start prompts above. The "Full agent-driven adoption" prompt handles repos with existing docs, plans, and scripts. The agent will sort existing content into the atlas_ai structure without erasing it.

## How To Customize For A New Project

Safe to customize:
- `docs/agile/devcycle.md`
- `docs/agile/backlog.md`
- `docs/agile/status.md`
- `docs/agile/retro.md`
- project docs under `docs/cgr/`
- reference docs under `docs/reference/`
- repo config files

Keep generic unless the repo itself needs a different process:
- `.github/copilot-instructions.md`
- `CLAUDE.md`
- `AGENTS.md`
- `ATLAS.md`

Project-specific values belong in:
- `docs/cgr/`
- `docs/reference/`
- non-secret config files
- secret stores and environment variables for credentials

## Suggested New Repo Setup

After installing the kit into a new repository:

1. Create or update `.gitignore` to ignore local config overrides, `.env`, secrets, and `archive/` if desired.
2. Create the initial `devcycle.md` items for the first build phase.
3. Add CLI or script smoketests and a `UAT:` section to each devtask. For non-user-facing work, use `Not UAT-eligible` and name the internal validation.
4. Add repo-specific setup notes in `docs/reference/`, and if the repo has agreed architecture or UX baselines, capture them in `patterns/stack-patterns/active-stack-pattern.md` and `patterns/ux-patterns/active-ux-pattern.md`.
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