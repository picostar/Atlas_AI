---
name: "Atlas Guided New Project Setup"
description: "Use when bootstrapping a new project with the current Atlas_AI kit through a prompt-first workflow. Trigger phrases: newproject, atlas project."
argument-hint: "Optional project setup scope, stack pattern, UX pattern, or bootstrap constraints"
agent: "agent"
---

# Atlas New Project

Use this standalone prompt when bootstrapping a new project with the current Atlas_AI process kit.

Copy this file into the target project root, paste it into the agent, or say `newproject` or `atlas project` while the target project is open in VS Code and the Atlas_AI source kit is available.

Do not use legacy bootstrap scripts for this workflow. Newproject is prompt-only and should bootstrap directly through agent file operations across Windows, Linux, and macOS.

This file must stand alone in the target project. Do not assume the project already has Atlas_AI prompts, skills, scripts, or root instruction files. Use any Atlas_AI kit files you can inspect as source material only, not as required prompt dependencies.

Access model: this prompt does not itself grant repository or network access. The agent must establish access to the current Atlas_AI source kit by using an open local checkout, inspecting `picostar/Atlas_AI`, or asking the user for a local path or permission. Treat that source as read-only template input. Do not clone `picostar/Atlas_AI` into the target folder or a subfolder unless the user explicitly asks to clone the kit repository. Once Atlas_AI source access is available, bootstrap the current target project in place.

## Prompt

You are preparing to bootstrap this repository with the current public Atlas_AI kit.

Do not run platform-specific bootstrap scripts. Use a prompt-driven workflow, ask only the minimum setup questions needed, then execute the approved bootstrap directly in the repository using available file tools.

1. Read local repository instructions first if they already exist, especially `.github/copilot-instructions.md`, `ATLAS.md`, and any root `AGENTS.md`, `CLAUDE.md`, `CHATGPT.md`, `GEMINI.md`, `GROK.md`, or `DEEPSEEK.md` files.
2. Establish source-kit access. Use `picostar/Atlas_AI` on its default branch as the source of truth for the current kit. If the Atlas_AI repository is open locally, inspect that repo. Otherwise fetch or inspect the public repository. If the source kit cannot be reached, stop and ask for a local Atlas_AI path, permission to access GitHub, or permission to proceed with only this copied prompt. Treat `picostar/Atlas_AI` as source-only input for file comparison and copy decisions, not as a clone target.
3. Detect whether this target is already Atlas-managed. If the repo root already contains Atlas control files such as `.github/copilot-instructions.md`, `ATLAS.md`, or `docs/agile/devcycle.md`, stop and tell the user to use `atlas_update.md` from the kit for a plan-first legacy Atlas update instead of running a new-project bootstrap.
4. Inventory pre-existing user material in the target root. Preserve that material by moving it into `docs/reference/preexisting-root/`. Preserve `.git`, `.gitignore`, `.gitattributes`, `.gitmodules`, and other root git metadata in place. If `.git` already exists, adopt that repository rather than reinitializing it. Treat the source-kit folder used for bootstrap, such as `atlas_ai` or `Atlas_AI` when it sits in the target root, as temporary bootstrap input, not user reference material.
5. Run a required setup questionnaire before changing files. Do not silently apply defaults when answers are missing. Only skip questions already answered in the current conversation. Ask in this order:
    - include scaffold docs? yes or no (default yes)
    - initialize git when `.git` is absent? yes or no (default yes)
    - include PS governance artifacts? yes or no (default no)
    - include CGR governance workflow? yes or no (default no)
    - select an active stack pattern baseline now? yes or no (default no)
    - if stack pattern is yes, present a numbered template menu and accept either number or label. Do not ask for a freeform filename or path:
       - 1: SP-01 Functions + Tables + SWA + Key Vault
       - 2: SP-02 Functions + Tables + SQL Serverless + SWA + Key Vault
       - 3: SP-03 Functions + Service Bus + Cosmos DB + SWA + Key Vault
       - 4: SP-04 App Service + Azure SQL + Redis + Front Door + Key Vault
    - if stack pattern is selected, ask: enable API-first posture? yes or no (default yes). Explain meaning: API-first expects API results when feasible, and smoketests should verify API endpoints plus OpenAPI or Swagger docs when feasible.
    - select an active UX pattern baseline now? yes or no (default no)
    - if UX pattern is yes, present a numbered template menu and accept either number or label. Do not ask for a freeform filename or path:
       - 1: UXP-01 Modern app shell layout
    - create GitHub repo now? yes or no (default no)
6. If the user replies with "use defaults" or equivalent, apply defaults and continue. Otherwise summarize captured answers and ask for a quick confirmation before execution.
   - Completion gate: do not output a final validation summary or next-step options until setup questionnaire answers are captured and applied, unless blocked.
   - Recovery mode: if a prior run already copied some files, for example only prompt files, without collecting setup answers, ask only the missing questions and continue execution to completion in this same run.
7. Install the selected Atlas_AI files from the source kit into the target root. Distinguish two skill categories:
   - Base-process skills (`devcycle-management`, `git-workflow`, `requirements-writing`, `model-tier-advisor`, `project-setup`, `powershell-style`) are installed unconditionally on every bootstrap, regardless of questionnaire answers.
   - Stack/technology-specific skills (`azure-deploy`) are installed only when the corresponding stack pattern or setup answer calls for them.
   Include root instruction files, reusable prompts, and optional scaffold or governance docs according to the selected setup. Prefer merging and preserving project-specific content over overwriting user-authored files. Execute this in the current target folder, not in a newly cloned subfolder.
7a. After base-process skills are installed, if web-fetch tools are available, attempt an on-demand refresh of `model-tier-advisor`'s benchmark tables per its External Benchmark Sources trigger (a fresh bootstrap install is one of the listed triggers); if unavailable or if the refresh fails, note in the setup summary that a future `atlas refresh models` run is recommended once network access exists.
8. If a stack pattern is selected, create `patterns/stack-patterns/active-stack-pattern.md` from the chosen template and record API-first posture there.
9. If a UX pattern is selected, create `patterns/ux-patterns/active-ux-pattern.md` from the chosen template.
10. Remove the temporary source-kit folder from the target root after installation when it is local to the target project, for example `atlas_ai` or `Atlas_AI`. Do not stage or commit that source-kit folder.
11. Ensure `accounts.md` exists as the committed non-secret cloud account binding file and `secrets.md` exists as the local-only secrets note when scaffold is included.
12. If git is absent and the user keeps the default bootstrap behavior, initialize git, copy `.gitignore`, and create an initial commit containing installed project artifacts only. If git already exists, adopt it and stage only the approved Atlas project artifacts.
13. If the user asks for GitHub repository creation, require the GitHub owner or org value and explain any missing CLI or auth prerequisite instead of inventing one.
15. Validate with targeted file-presence checks, parser checks, or text searches. Summarize:
   - setup questionnaire answers captured, and whether defaults were explicitly used
   - files installed, including all base-process skills
   - pre-existing user material preserved under `docs/reference/preexisting-root/`
   - whether temporary source-kit folder cleanup was completed
   - whether git was adopted or initialized
   - optional components included
   - whether `model-tier-advisor` benchmark tables were refreshed, or if deferred, a note that `atlas refresh models` is recommended when network access is available
   - unresolved manual follow-up

## Default Decisions

- Keep `secrets.md` ignored and local-only.
- Commit `accounts.md` as the non-secret cloud account binding source of truth.
- Keep reusable stack and UX patterns under `patterns/`.
- Keep API-first posture in `patterns/stack-patterns/active-stack-pattern.md` when a stack pattern is selected.
- Keep governance artifacts under `docs/cgr/`.
- Keep user-supplied project source material under `docs/reference/`, such as old MRDs, PRDs, specifications, marketing materials, website notes, setup notes, and context for planning, devcycles, and CGR.
- Treat legacy bootstrap scripts as deprecated paths for newproject. Do not invoke them during prompt-driven bootstrap.
- Remove temporary source-kit folders from the target root after installation when they were used as local bootstrap inputs.
- Treat GitHub source references for Atlas_AI as read-only source-kit input, not as clone destinations, unless the user explicitly requests a clone operation.
- Stop and route to `atlas_update.md` instead of reinstalling when Atlas control files already exist at the repo root.
