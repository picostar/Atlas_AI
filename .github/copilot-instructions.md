# Project Process Instructions

## atlas_ai Use
- This file is the source of truth for AI instructions in this repository.
- For automatic loading by common tools, keep these files at the repository root:
	- `.github/copilot-instructions.md`
	- `CLAUDE.md`
	- `CHATGPT.md`
	- `GEMINI.md` when Gemini workflows are in scope
	- `GROK.md` when Grok workflows are in scope
	- `DEEPSEEK.md` when DeepSeek workflows are in scope
	- `AGENTS.md`
	- `ATLAS.md`
- If you copy this kit into another repository, copy the files to that repository root. Do not leave them buried in a nested subfolder if you expect auto-loading to work.

## Project Context
- This is a reusable AI coding agent process kit for any software project. Modern labels for this kind of repository include agentic workflow scaffold, AI agent instruction scaffold, and agent-ready project scaffold.
- Keep project-specific values in repo docs, config files, or secret stores, not in these instruction files.
- Keep environment URLs, credentials, tokens, tenant IDs, and deployment targets out of committed instruction files.
- Keep reusable stack-pattern choices in `patterns/stack-patterns/`, not in `ATLAS.md` or the thin agent pointer files.
- Keep reusable UX-pattern choices in `patterns/ux-patterns/`, not in `ATLAS.md` or the thin agent pointer files.

## Local Secrets File
- Use `secrets.md` at the repository root for local secure secrets, credentials, and keys.
- Keep `secrets.md` gitignored and local-only.
- Do not place secrets in any other file by default.
- If the user explicitly asks for a different location, warn about commit and leakage risk first, then proceed only after confirmation.
- Before asking the user for credentials, tokens, keys, or other secret values, check `secrets.md` first if it exists.

## Project Accounts File
- Use `accounts.md` at the repository root for non-secret cloud destination and provider account binding.
- Keep `accounts.md` committed when it exists. It may contain subscription IDs, resource group names, project IDs, account IDs, regions, zones, deployment target names, and provider account notes.
- Do not store credentials, keys, tokens, passwords, connection strings, or deployment secrets in `accounts.md`.
- Before cloud, hosting, deployment, infrastructure, or provider CLI work, check `accounts.md` first if it exists.
- If `accounts.md` conflicts with live CLI state, repo guardrails, or user instructions, stop and ask which account, subscription, resource group, project, zone, or target to use.

## Split Repo Layout Handling
- Some repositories keep control docs and AI instruction files at the repo root while the runnable application lives in a child directory one level down.
- In that layout, treat the directory that contains `.github/copilot-instructions.md`, `ATLAS.md`, and `docs/` as the control root.
- Keep MRD, PRD, ESD, CGR results, and other governance artifacts under the existing `docs/cgr/` directory at that control root.
- If runtime code is needed and the repo root does not contain the application, inspect immediate child directories and use the best-fit child directory as the code root without moving docs or instruction files there.
- If the repo root does not have `docs/cgr/` but exactly one immediate child directory does, use that child as the effective project root for document work. If multiple child directories qualify, ask the user which one to use.
- Do not create a duplicate `docs/` tree inside a nested app folder when a repo-root `docs/` tree already exists.

## Template And Scaffold Repo Behavior
- This repository may be operating either as a reusable kit or as an adopted live project.
- If `docs/agile/` files still contain obvious placeholder markers, such as `<!-- PLACEHOLDER:` comments, repeated `TBD` values, or example devtasks, treat the repository as a scaffold or template unless there is clear evidence it has been activated as a live project.
- In scaffold or template mode, do not treat placeholder agile docs as ATLAS failures by themselves.
- In scaffold or template mode, assess template integrity, installer behavior, prompt coverage, instruction coherence, and adoption readiness instead of live delivery readiness.
- When giving startup, launch, realignment, or closeout guidance in scaffold or template mode, describe the next step in terms of maintaining the kit or adopting it into a real project.

## Response Guidelines
- No em-dashes. Use commas, periods, or " -- " instead.
- No special symbols or Unicode characters.
- No emoji.
- Plain ASCII text only.
- Standard markdown formatting is fine.
- When generating or editing project files, follow the same rules.

## Read Order
1. `.github/copilot-instructions.md` -- this file
2. `ATLAS.md` -- default development process and task lifecycle
3. `docs/cgr/PS.md` -- optional project stages and document gates, only when the project uses formal EVT/DVT/PVT/GA stages
4. `.github/prompts/cgr.prompt.md` -- optional governance review prompt, only when governance or stage-gate review is requested
5. If `patterns/stack-patterns/active-stack-pattern.md` exists and the task affects architecture, hosting, deployment, infrastructure, or platform selection, read it before proposing or changing the stack.
6. If `patterns/ux-patterns/active-ux-pattern.md` exists and the task affects layout, navigation, page hierarchy, interaction flow, or UI generation, read it before proposing or changing UX structure.
7. Repo-specific planning docs if they exist, such as `docs/agile/devcycle.md`, `docs/agile/retro.md`, `docs/agile/backlog.md`, `docs/agile/status.md`
8. Repo-specific project docs if they exist, such as MRD, PRD, ESD, architecture docs, ADRs, runbooks, and config references

## Startup And Greeting Behavior
- If the user opens with a greeting or start-of-session phrase, such as `hi`, `hello`, `good morning`, `goodmorning`, or `ready to start`, treat it as a request for a quick project check-in.
- Review where the project stands before proposing work. Use the read order above, then prioritize `docs/agile/status.md` for current state, `docs/agile/devcycle.md` for active work, and `docs/agile/backlog.md` if the active cycle is empty or unclear.
- If the user opens with `atlas`, treat it as the same startup check-in flow.
- During startup check-in, if `.github/prompts/cgr.prompt.md` is present and governance is enabled for this project, check whether live MRD, PRD, and ESD artifacts exist in `docs/cgr/`.
- If governance is enabled and live MRD, PRD, or ESD artifacts are missing, ask a single yes or no question: "Do you want to run CGR bootstrap now to generate draft MRD, PRD, and ESD from seed and reference materials?"
- If the repository appears to be a scaffold or template, review template integrity and adoption readiness instead of expecting live project status.
- Confirm whether the project appears ready to begin the next task. Mention obvious blockers, missing planning artifacts, or stale status if they affect readiness.
- Suggest the next step using the ATLAS dev cycle loop. Prefer the next active dev task, or if none is active, recommend pulling the next priority into a new cycle.
- Keep this startup response brief and operational. It should orient the user, confirm readiness, and point to the next concrete action.

## Launch And Execute Behavior
- If the user uses a short launch phrase, such as `do it`, `lets go`, `let's go`, `go ahead`, `start`, `proceed`, `make it so`, `engage`, `hit it`, or `punch it`, treat it as authorization to begin work.
- If the user says `CGR` or `run CGR`, treat it as a request to run the governance workflow defined in `.github/prompts/cgr.prompt.md`.
- For `CGR`: if live MRD, PRD, and ESD artifacts do not exist in `docs/cgr/`, bootstrap draft docs from `seed.md` and `docs/reference/` first, then run CGR and write `docs/cgr/CGR-results.md`.
- For `CGR`: if live MRD, PRD, or ESD artifacts already exist in `docs/cgr/`, use them as the base and improve them using user instructions plus any new materials in `seed.md` or `docs/reference/`.
- If the user says `newproject`, treat it as a request to run the non-interactive atlas_ai installer flow from the repository root using: `pwsh -File ./atlas_ai/atlas_ai.ps1 -IncludeScaffold -ApiFirst -InitGit`.
- Before acting, perform a brief ATLAS readiness check. Review the current state, confirm the next task is clear, and look for obvious blockers or missing planning context.
- Use `docs/agile/status.md` for current state, `docs/agile/devcycle.md` for the active task, and `docs/agile/backlog.md` if the active cycle is empty or unclear.
- If the repository appears to be a scaffold or template, use the next clear maintenance or adoption task rather than expecting an active live-project devcycle.
- If the next task is clear and no blocker prevents progress, start executing it immediately rather than waiting for another confirmation.
- If a blocker exists, call it out briefly and either resolve it or ask the minimum clarifying question needed to proceed.
- For `newproject`, if the target already contains real project files, stop. Do not move, rewrite, or reorganize them. Tell the user to use `.github/prompts/atlas-update.prompt.md` from the kit for a plan-first legacy project update.
- Keep the response short and action-oriented. The purpose of these phrases is to move from readiness review into execution.

## Session Close And Sign-Off Behavior
- If the user closes with a sign-off phrase, such as `good night`, `goodnight`, `goodbye`, `that's all`, or `we are done`, treat it as a request for a quick end-of-session check.
- Review whether the current work appears to follow ATLAS. Check for obvious closeout gaps such as missing CLI or script smoketest confirmation, missing UAT handoff or explicit non-UAT note, missing task-level commit, missing GitHub follow-up, missing `retro.md` updates for completed work, missing `status.md` updates for shipped changes, or completed items still left in `devcycle.md`.
- If the repository appears to be a scaffold or template, do not treat placeholder agile docs as closeout failures unless the user was specifically editing those docs.
- Confirm whether the working state appears ready to pause or close for the session. If there are unfinished closeout steps, call them out clearly and briefly.
- Confirm the current devtask's commit and GitHub follow-up status as part of closeout. If the repo has no remote or the workflow cannot proceed, call that out explicitly.
- Keep this sign-off response brief, operational, and focused on readiness, documentation state, and the next optional closeout action.

## Working Rules
- Follow `ATLAS.md` as the default process unless the repository explicitly defines a different one.
- Work on one dev task at a time.
- Smoke test each task with CLI commands or a script before considering it complete.
- Every devtask and reset devtask must include both a `Smoketest:` section and a `UAT:` section. If a task is not user-facing, the `UAT:` section must explicitly say that it is not UAT-eligible and state the required internal validation.
- In API-first mode, every devtask and reset devtask should include an API result when feasible, and `Smoketest:` should include API endpoint verification plus OpenAPI or Swagger documentation verification when feasible.
- After each completed devtask, create a task-level git commit.
- After each completed devtask, if a GitHub remote exists, push the branch and perform the repo's GitHub follow-up step, typically creating or updating a pull request. If no remote exists, record that blocker clearly.
- Keep completed work out of the active task list. The active list is a burn-down, not a historical log.
- Record implementation details, issues, decisions, and lessons learned in the repo's retrospective log if one exists.
- Prefer feature branches over direct work on `main` when working in a git repository.
- Remove matching `*_TEMPLATE.md` files from `docs/cgr/` once live MRD, PRD, or ESD artifacts exist.
- Do not hardcode project names, tenant values, URLs, credentials, or deployment targets in reusable kits.
- Keep `atlas_ai.ps1` and `NewProject.bat` new-project only. They must not move, rewrite, reorganize, migrate, or delete existing project files.
- For existing or legacy atlas projects, use `.github/prompts/atlas-update.prompt.md` as a plan-first prompt. It may recommend consolidating legacy account-binding files into committed `accounts.md`, but execution requires explicit human approval.

## Recommended Repo Structure
- `docs/agile/` -- active planning and delivery docs such as `devcycle.md`, `retro.md`, `backlog.md`, `status.md`
- `docs/cgr/` -- MRD, PRD, ESD, ADRs, roadmaps, governance records
- `docs/reference/` -- setup notes, integration references, runbooks, external system constraints
- `patterns/` -- stack and UX baseline patterns, active baselines, and template catalogs
- `scripts/` -- reusable operational and verification scripts
- `archive/` -- superseded artifacts and one-off outputs, usually gitignored

## AI Tool Coverage
- Copilot uses `.github/copilot-instructions.md`.
- Claude Code uses `CLAUDE.md`.
- ChatGPT-oriented workflows use `CHATGPT.md` as a thin pointer to this file and `ATLAS.md`.
- Gemini-oriented workflows can use `GEMINI.md` as a thin pointer to this file and `ATLAS.md`.
- Grok-oriented workflows can use `GROK.md` as a thin pointer to this file and `ATLAS.md`.
- DeepSeek-oriented workflows can use `DEEPSEEK.md` as a thin pointer to this file and `ATLAS.md`.
- Codex-style agents commonly use `AGENTS.md`.
- Keep thin pointers minimal and aligned with this file and `ATLAS.md` so process logic stays in one place.

## Common Mistakes To Avoid
- Do not bake one project's names, URLs, roles, or vendors into a reusable kit.
- Do not reference files that do not exist in the copied kit without labeling them as optional or recommended.
- Do not skip the repo-defined commit and GitHub follow-up steps after a completed devtask.
- Do not keep completed tasks in the active burn-down list using checkboxes, strikethroughs, or DONE labels.
- Do not leave live project artifacts mixed with stale `*_TEMPLATE.md` files in `docs/cgr/`.
- Do not store secrets in committed config or instruction files.
