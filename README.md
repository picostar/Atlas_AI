# atlas_ai

This folder is a reusable AI coding agent process kit for software repositories.

An AI coding agent process kit and agentic workflow scaffold built around ATLAS, the AI Task Lifecycle Automation System.

In current developer terminology, atlas_ai is best described as an agentic workflow scaffold or AI agent instruction scaffold: it installs root-level agent instructions, prompt workflows, and lightweight delivery governance so coding agents can operate consistently in a repository.

It gives you:
- root-level AI instruction files for Copilot, Claude Code, ChatGPT, and Codex-style agents
- reusable ATLAS prompt files for realignment and closeout checks
- a default workflow for task execution and delivery tracking
- optional release stages and document gates for formal projects
- optional compliance and governance review prompt
- a starter docs scaffold for active work, backlog, status, retro, project docs, reference docs, stack-baseline guidance, and UX-baseline guidance

## AI Dev SOP Summary

ATLAS keeps AI-assisted development fast without letting it become loose. The standard operating procedure is:

1. Start from `docs/agile/devcycle.md`, the current active burn-down.
2. Work one `DT` or `RDT` at a time.
3. Keep each task small enough to validate, usually 5 CU or less.
4. If a task is larger than 5 CU, split it into sub devtasks such as `DT3.1`, `DT3.2`, and `DT3.3` so each piece has a clear outcome, smoketest, and UAT or non-UAT validation path.
5. Smoke test with CLI commands or scripts before treating the task as complete.
6. Record UAT handoff or explicit non-UAT validation.
7. Move completed work into `docs/agile/retro.md` with `eMOE`, `aMOE`, results, decisions, and lessons learned.
8. Remove completed items from `devcycle.md` so the active list stays clean.

This gives coding agents a tight loop: select, implement, validate, record, commit, and move on. It supports multiple devcycles per day when the work is flowing, while preserving enough structure for review, governance, and later calibration.

## What atlas_ai Solves

The main problem with reusable instruction folders is that most AI tools do not reliably auto-load nested files. They usually look at the repository root.

atlas_ai is designed for that reality.

You can keep this folder as your source kit, drop a copy into a new repository, and then install the correct files into the repo root.

## AI Ecosystem Fit

atlas_ai sits one layer above individual AI coding agents. It does not replace Copilot, Claude Code, ChatGPT, Codex-style agents, Gemini, Grok, DeepSeek, or future LLM tools. It gives those tools a consistent repository contract: where to read instructions, how to understand the active task, how to preserve project context, and how to validate work before handoff.

In the current AI development ecosystem, most tools provide the model, chat surface, editor integration, or command execution. atlas_ai provides the project-side operating model those tools can share. It standardizes root instruction files, reusable prompt workflows, task lifecycle docs, governance artifacts, and optional stack and UX baselines so different agents can work from the same map.

That makes atlas_ai closer to an agentic workflow scaffold than a runtime harness. A harness usually drives or measures execution. atlas_ai prepares the repository so agents can orient, execute, smoke test, document, and hand off work consistently across tools.

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
- `GEMINI.md` -- optional thin pointer for Gemini-oriented workflows, not installed by default
- `GROK.md` -- optional thin pointer for Grok-oriented workflows, not installed by default
- `DEEPSEEK.md` -- optional thin pointer for DeepSeek-oriented workflows, not installed by default
- `AGENTS.md` -- thin pointer for Codex-style agents and similar tooling
- `ATLAS.md` -- default development process

### AI governance docs
- `.github/TOOLING-ASSUMPTIONS.md` -- capability and tooling assumptions
- `.github/TOOL-CAPABILITY-MATRIX.md` -- portability matrix across agent environments
- `.github/FRONTMATTER-SCHEMA.md` -- prompt and skill metadata contract
- `.github/INSTRUCTION-MAINTENANCE.md` -- instruction update and drift rules

### Workflow prompts (installed by default)
- `.github/prompts/atlas-realign.prompt.md` -- ATLAS health check and realignment prompt
- `.github/prompts/atlas-closeout.prompt.md` -- ATLAS closeout readiness prompt
- `.github/prompts/atlas-update.prompt.md` -- guided legacy atlas update planning prompt
- `.github/prompts/cgr.prompt.md` -- compliance and governance review workflow
- `.github/prompts/cgr-seed-to-cgr.prompt.md` -- generate draft MRD PRD ESD from seed and reference material, then run CGR outputs
- `.github/prompts/cgr-iterate.prompt.md` -- iterate and improve governance docs using CGR-results and score

### Installer
- `atlas_ai.ps1` -- copies kit files into the target repository root
- `.gitignore` -- default ignore patterns, copied to the target when `-InitGit` is used

### Startup seed file
- `seed.md` -- optional startup brief and usage notes for new project setup runs.
- `accounts.md` -- committed non-secret cloud account and deployment destination binding. Keep credentials, keys, tokens, and secrets out of this file.
- `secrets.md` -- local-only secrets note file stored at repo root and ignored by git. Keep credentials and keys here, not in committed files.

This `README.md` is for the kit itself. It is not copied into the target repository by the installer.

### Scaffold
- `docs/agile/devcycle.md` -- active burn-down list
- `docs/agile/backlog.md` -- future work queue
- `docs/agile/status.md` -- current live state
- `docs/agile/retro.md` -- completed work log
- `docs/cgr/README.md` -- governance document guidance
- `docs/cgr/PS.md` -- optional project stages and document gates (EVT/DVT/PVT/GA)
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
- `.github/skills/project-setup/SKILL.md` -- new project setup and repo bootstrapping
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

Chat shortcut: in AI chat, type `CGR` to run the CGR workflow from `.github/prompts/cgr.prompt.md`.

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

The simplest way to start a new project with atlas_ai is to copy or clone it into an otherwise empty project folder, then tell your AI coding agent to set it up. This works in VS Code with Copilot, Claude Code, ChatGPT-oriented workflows, or any Codex-style agent.

**Step 1:** Copy the `atlas_ai` folder into your project root. You can clone it, copy it, or drop it in manually. Your project should look like this:

```
my-project/
  atlas_ai/          <-- the kit
```

**Step 2:** Open the project in VS Code (or your editor with an AI agent). Then use one of these prompts.

#### Basic setup (most projects, POC, internal tools)

```text
atlas_ai

Set up this project with atlas_ai.

Tasks:
1. Read atlas_ai/README.md, atlas_ai/.github/copilot-instructions.md, atlas_ai/ATLAS.md, and atlas_ai/AGENTS.md.
2. Install the kit into the repository root using atlas_ai/atlas_ai.ps1 with -IncludeScaffold.
3. If this repository already contains real project files, stop. Do not move, rewrite, reorganize, or overwrite them. Use `.github/prompts/atlas-update.prompt.md` from the kit for a plan-first legacy project update instead.
4. Summarize what was installed.
```

This installs the core workflow, AI instruction files, and docs scaffold. No release stages, no governance review. Good for POC work, internal tools, and exploratory development.

#### Setup with formal release stages (optional)

If the project needs EVT/DVT/PVT/GA release gates and MRD/PRD/ESD document requirements, add `-IncludePS` to the install step:

```text
atlas_ai

Set up this project with atlas_ai including formal release stages.

Tasks:
1. Read atlas_ai/README.md, atlas_ai/.github/copilot-instructions.md, atlas_ai/ATLAS.md, atlas_ai/docs/cgr/PS.md, and atlas_ai/AGENTS.md.
2. Install the kit into the repository root using atlas_ai/atlas_ai.ps1 with -IncludeScaffold -IncludePS.
3. If this repository already contains real project files, stop. Do not move, rewrite, reorganize, or overwrite them. Use `.github/prompts/atlas-update.prompt.md` from the kit for a plan-first legacy project update instead.
4. Summarize what was installed.
```

#### Setup with governance review (optional)

If the project needs compliance and governance review (CGR), add `-IncludeCGR`. CGR works independently -- you can use it with or without PS:

```text
atlas_ai

Set up this project with atlas_ai including CGR.

Tasks:
1. Read atlas_ai/README.md, atlas_ai/.github/copilot-instructions.md, atlas_ai/ATLAS.md, atlas_ai/.github/prompts/cgr.prompt.md, and atlas_ai/AGENTS.md.
2. Install the kit into the repository root using atlas_ai/atlas_ai.ps1 with -IncludeScaffold -IncludeCGR.
3. If this repository already contains real project files, stop. Do not move, rewrite, reorganize, or overwrite them. Use `.github/prompts/atlas-update.prompt.md` from the kit for a plan-first legacy project update instead.
4. Summarize what was installed.
```

#### Setup with both PS and CGR (optional)

If the project needs both project stages and governance review:

```text
atlas_ai

Set up this project with atlas_ai including PS and CGR.

Tasks:
1. Read atlas_ai/README.md, atlas_ai/.github/copilot-instructions.md, atlas_ai/ATLAS.md, atlas_ai/docs/cgr/PS.md, atlas_ai/.github/prompts/cgr.prompt.md, and atlas_ai/AGENTS.md.
2. Install the kit into the repository root using atlas_ai/atlas_ai.ps1 with -IncludeScaffold -IncludePS -IncludeCGR.
3. If this repository already contains real project files, stop. Do not move, rewrite, reorganize, or overwrite them. Use `.github/prompts/atlas-update.prompt.md` from the kit for a plan-first legacy project update instead.
4. Summarize what was installed.
```

#### Adding release stages or CGR later

You can start with the basic setup and add `docs/cgr/PS.md` or `.github/prompts/cgr.prompt.md` later at any time:

```text
atlas_ai

Add project stages to this project. Install docs/cgr/PS.md from the atlas_ai kit.
```

```text
atlas_ai

Add governance review to this project. Install .github/prompts/cgr.prompt.md from the atlas_ai kit.
```

#### Adding git and GitHub to any setup

Add `-InitGit` to any install step above to initialize a git repository with a `.gitignore` and an initial commit. Add `-GitHubRepo "repo-name"` to also create a GitHub repository and push. Use `-GitHubOwner "account-or-org"` to specify which GitHub account or organization the repo is created under. Defaults to private -- add `-Public` for a public repo. If the GitHub CLI is not authenticated, the script will launch `gh auth login` automatically. Examples:

- `-IncludeScaffold -InitGit` -- scaffold plus git init
- `-IncludeScaffold -IncludePS -InitGit -GitHubRepo "my-project" -GitHubOwner "myusername"` -- scaffold, PS, git, private GitHub repo under a specific account
- `-IncludeScaffold -IncludeCGR -InitGit -GitHubRepo "my-project" -GitHubOwner "my-org" -Public` -- scaffold, CGR, git, public GitHub repo under an org

Requires `git` on PATH. For `-GitHubRepo`, install the [GitHub CLI](https://cli.github.com/). Login is handled automatically if needed.

### Existing repo updates

Do not use `atlas_ai.ps1` or `NewProject.bat` to update an existing repository. Those entry points are new-project only. For legacy atlas projects, run or copy `.github/prompts/atlas-update.prompt.md` from the kit and use it as a plan-first prompt. The prompt compares the target against the public `picostar/Atlas_AI` source of truth and stops before making edits until a human approves the plan.

If a legacy `accounts.txt` exists, the update plan should replace it with committed `accounts.md` for non-secret provider binding, then remove `accounts.txt` after approval. Do not keep both as active account sources.

Add `-IncludePS` and/or `-IncludeCGR` to the install step if the project needs project stages or governance review.

### Manual setup (no agent)

If you do not want to use an agent prompt, run the installer directly:

```powershell
# Chat-only equivalent of NewProject.bat (run from an otherwise empty project root)
pwsh -File .\atlas_ai\atlas_ai.ps1 -IncludeScaffold -ApiFirst -InitGit

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

```

Chat shortcut: in AI chat, you can say `newproject` and the agent should execute the same non-interactive installer flow.

`-StackPattern` accepts a stack pattern template filename or template-relative path and sets `patterns/stack-patterns/active-stack-pattern.md` from that template. `-UxPattern` accepts a UX pattern template filename or template-relative path and sets `patterns/ux-patterns/active-ux-pattern.md` from that template. `-InitGit` copies the `.gitignore` from the kit, runs `git init` if needed, and makes an initial commit with project artifacts only. `-GitHubRepo` creates a GitHub repository using the `gh` CLI. Use `-GitHubOwner` to specify the GitHub account or org. If not logged in, the script runs `gh auth login` automatically. `-GitHubRepo` implies `-InitGit`.

Prerequisites: `git` must be on PATH. For `-GitHubRepo`, install the [GitHub CLI](https://cli.github.com/). Login is handled automatically if needed.

### One-time layout migration (legacy repos)

If an existing repo still uses legacy paths (`docs/projects/` and `docs/reference/*-patterns`), run the migration from a disposable git worktree, not the live checkout:

```powershell
pwsh -File .\scripts\migrate-layout-v2.ps1 -RepoRoot .
```

Dry run:

```powershell
pwsh -File .\scripts\migrate-layout-v2.ps1 -RepoRoot . -WhatIf
```

This migration is idempotent and safe to re-run, but it still moves files and rewrites references. Preview first and use a disposable git worktree for the real migration.

### Guided update for older atlas projects

Older atlas projects should be updated with the prompt in `.github/prompts/atlas-update.prompt.md`, not with a hard updater script.

Run `.github/prompts/atlas-update.prompt.md` from the kit, copy it into the legacy project, or paste its prompt into the agent while the legacy project is open in VS Code. The prompt sends the agent to `picostar/Atlas_AI` as the source of truth, then asks for update suggestions as a plan. The first pass is plan-only and must stop for human review before any file changes.

Use this flow:
1. Open the legacy project in VS Code.
2. Run `.github/prompts/atlas-update.prompt.md`, copy it into the legacy project root, or paste it into the agent as the update prompt.
3. Give the agent access to the current Atlas_AI kit, preferably the public `picostar/Atlas_AI` repository or a local checkout of this repo.
4. Let the agent compare the legacy project against the Atlas_AI source of truth.
5. Review the proposed update plan before files are moved, renamed, deleted, rewritten, or generated.
6. Answer any questions about legacy layout paths, account binding, pattern folders, and local project-specific files.
7. Approve the plan explicitly before execution.
8. Apply the agreed changes deliberately, then review the diff and commit.

The guided update flow is designed to catch project-specific decisions before editing, especially:
- whether `docs/projects` should become `docs/cgr`
- whether `docs/reference/stack-patterns` and `docs/reference/ux-patterns` should become `patterns/stack-patterns` and `patterns/ux-patterns`
- whether legacy `accounts.txt` should be replaced by committed `accounts.md` and removed
- which local instructions, prompts, skills, docs, and reference files should be preserved

The planning pass should not modify the legacy project. It should produce file-by-file recommendations, questions, and a proposed validation checklist for human approval.

The migration script `scripts/migrate-layout-v2.ps1` remains available as an optional manual utility, but it should only be used after the guided update plan confirms that the layout migration is wanted.

Placement guidance:
- `atlas_ai.ps1` stays at the kit root because setup flows and docs call it there.
- `.github/prompts/atlas-update.prompt.md` is the recommended legacy update workflow.
- `scripts/migrate-layout-v2.ps1` is a reusable optional migration utility and should remain in `scripts/`.

Or manually copy the files you want from `atlas_ai/` to the repository root:
- `.github/copilot-instructions.md` -- always
- `.github/prompts/atlas-realign.prompt.md` -- recommended
- `.github/prompts/atlas-closeout.prompt.md` -- recommended
- `.github/prompts/atlas-update.prompt.md` -- recommended for guided legacy atlas updates
- `.github/prompts/cgr.prompt.md` -- only if the project uses governance review
- `CLAUDE.md` -- always
- `CHATGPT.md` -- always
- `GEMINI.md` -- optional pointer for Gemini-oriented workflows
- `GROK.md` -- optional pointer for Grok-oriented workflows
- `DEEPSEEK.md` -- optional pointer for DeepSeek-oriented workflows
- `AGENTS.md` -- always
- `ATLAS.md` -- always
- `accounts.md` -- recommended for non-secret cloud account and deployment destination binding
- `docs/cgr/PS.md` -- only if the project uses formal project stages
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

### ChatGPT

ChatGPT-oriented workflows can use `CHATGPT.md` as a thin pointer to the source of truth and `ATLAS.md`. Because ChatGPT is commonly used for coding workflows, the installer copies `CHATGPT.md` by default.

### Optional hosted LLMs

Gemini, Grok, DeepSeek, and similar hosted LLM workflows can use `GEMINI.md`, `GROK.md`, or `DEEPSEEK.md` as optional thin pointers when a project wants tool-specific session instructions. If auto-loading is not available in the current tool, load the relevant pointer, `.github/copilot-instructions.md`, and `ATLAS.md` manually at session start.

### Important limitation

If this kit remains nested and you do not copy the files to the repository root, automatic loading may not happen.

## Stack Patterns

If the repository has an agreed stack baseline, create `patterns/stack-patterns/active-stack-pattern.md` and keep it current.

The atlas_ai instruction files and prompts treat that file as the source of truth for stack-sensitive work, such as architecture, hosting, deployment, infrastructure, and platform-selection changes.

## UX Patterns

If the repository has an agreed UX baseline, create `patterns/ux-patterns/active-ux-pattern.md` and keep it current.

The atlas_ai instruction files and prompts treat that file as the source of truth for UX-sensitive work, such as layout, navigation, page hierarchy, and UI generation changes.

## Existing Repo Updates

Use `.github/prompts/atlas-update.prompt.md` for existing repositories. The first pass is planning only and should not execute edits, migrations, moves, renames, deletes, or destructive commands until a human reviews and approves the plan.

## AI Development Velocity

ATLAS uses `devcycle`, `devtask`, `reset devtask`, and `retro` because AI-assisted development moves at a different cadence than traditional agile delivery. Classic agile terms like sprint, story, and ceremony often imply multi-day or multi-week planning loops, human-only execution speed, and team rituals that are heavier than a coding-agent workflow needs.

A `devcycle` is the active burn-down for the next focused unit of work. It can represent a morning, an afternoon, a release push, or any short execution window. In AI-assisted delivery, multiple devcycles can happen in a single day because agents can implement, revise, and validate small tasks much faster than a human-only team cadence.

A `devtask` is a concrete planned implementation task inside the current devcycle. It is intentionally smaller and more operational than a traditional user story. A good devtask names the change, expected outcome, smoketest, and UAT or non-UAT validation path. The goal is to give the agent enough context to execute safely without turning every small change into a heavyweight planning artifact.

A `reset devtask`, or `RDT`, is unplanned work discovered during the current devcycle that must interrupt the planned order. This replaces vague mid-cycle churn with a visible reset point: the interruption is named, estimated, validated, recorded, and then removed from the active list when complete.

The `retro` is the completed-work ledger. Completed devtasks and reset devtasks move out of `devcycle.md` and into `retro.md` with outcome notes, smoketest evidence, UAT status, decisions, issues, and effort calibration. This keeps `devcycle.md` clean as a burn-down list while preserving the history needed for learning and governance.

ATLAS uses `CU`, `eMOE`, and `aMOE` for effort because AI velocity makes elapsed human time a poor planning unit. `CU` means Complexity Unit. It measures combined human-plus-agent delivery effort: uncertainty, decision load, dependencies, review depth, test burden, integration risk, and handoff cost. `eMOE` is the estimated Measure of Effort in CU before work starts. `aMOE` is the actual Measure of Effort in CU after the task is complete.

As a rule of thumb, a devtask estimated above 5 CU should be split before execution. For example, `DT3 -- Add customer dashboard` at 8 CU should become smaller sub devtasks such as `DT3.1 -- Add dashboard data contract`, `DT3.2 -- Build dashboard API`, and `DT3.3 -- Build dashboard UI`. Each sub devtask should carry its own `eMOE`, smoketest, and UAT or non-UAT validation path so the agent can close work safely in smaller loops.

This makes effort tracking useful again in AI development. A task may take an agent one minute to draft but still require meaningful review, validation, integration, and release judgment. By comparing `eMOE` to `aMOE`, the team can calibrate future devtasks around real delivery friction instead of pretending that wall-clock generation time equals effort.

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
- `CHATGPT.md`
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
6. Optionally, add `docs/cgr/PS.md` later if the project grows into formal release stages.
7. Optionally, add `.github/prompts/cgr.prompt.md` later if the project needs governance review.

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
- `PS`: Project Stages. The optional EVT/DVT/PVT/GA release lifecycle defined in `docs/cgr/PS.md`.
- `CGR`: Compliance and Governance Review.

## Acronym Rules

- Use `DT` for planned devtasks in `devcycle.md`.
- Use `RDT` for reset devtasks that interrupt the current devcycle.
- New `RDT` items are inserted ahead of the remaining unfinished planned `DT` items.
- Record both `eMOE` and `aMOE` in `retro.md` for completed `DT` and `RDT` items.
- Estimate in `CU` before starting, then record the actual `CU` after completion.