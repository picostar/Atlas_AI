---
name: "Atlas Guided New Project Setup"
description: "Use when bootstrapping a new project with the current Atlas_AI kit through a prompt-first workflow. Trigger phrase: newproject."
argument-hint: "Optional project setup scope, stack pattern, UX pattern, or bootstrap constraints"
agent: "agent"
---

# Atlas New Project

Use this standalone prompt when bootstrapping a new project with the current Atlas_AI process kit.

Copy this file into the target project root, paste it into the agent, or say `newproject` while the target project is open in VS Code and the Atlas_AI source kit is available.

Do not require `NewProject.bat` or `atlas_ai.ps1` for the primary workflow. Prefer a prompt-first bootstrap that works across Windows, Linux, and macOS. The scripts remain valid fallback or manual setup paths when the user explicitly wants them.

This file must stand alone in the target project. Do not assume the project already has Atlas_AI prompts, skills, scripts, or root instruction files. Use any Atlas_AI kit files you can inspect as source material only, not as required prompt dependencies.

Access model: this prompt does not itself grant repository or network access. The agent must establish access to the current Atlas_AI source kit by using an open local checkout, inspecting `picostar/Atlas_AI`, or asking the user for a local path or permission. Once Atlas_AI source access is available, the agent can bootstrap the target project with user interaction as needed.

## Prompt

You are preparing to bootstrap this repository with the current public Atlas_AI kit.

Do not start with a platform-specific script. Use a prompt-driven workflow first, ask only the minimum setup questions needed, then execute the approved bootstrap directly in the repository using available file tools.

1. Read local repository instructions first if they already exist, especially `.github/copilot-instructions.md`, `ATLAS.md`, and any root `AGENTS.md`, `CLAUDE.md`, `CHATGPT.md`, `GEMINI.md`, `GROK.md`, or `DEEPSEEK.md` files.
2. Establish source-kit access. Use `picostar/Atlas_AI` on its default branch as the source of truth for the current kit. If the Atlas_AI repository is open locally, inspect that repo. Otherwise fetch or inspect the public repository. If the source kit cannot be reached, stop and ask for a local Atlas_AI path, permission to access GitHub, or permission to proceed with only this copied prompt.
3. Detect whether this target is already Atlas-managed. If the repo root already contains Atlas control files such as `.github/copilot-instructions.md`, `ATLAS.md`, or `docs/agile/devcycle.md`, stop and tell the user to use `atlas_update.md` from the kit for a plan-first legacy Atlas update instead of running a new-project bootstrap.
4. Inventory pre-existing user material in the target root. Preserve that material by moving it into `docs/reference/preexisting-root/`. Preserve `.git`, `.gitignore`, `.gitattributes`, `.gitmodules`, and other root git metadata in place. If `.git` already exists, adopt that repository rather than reinitializing it.
5. Ask only the minimum bootstrap questions that remain unresolved. Use these defaults unless the user overrides them:
   - include scaffold docs: yes
   - initialize git when `.git` is absent: yes
   - include PS: no
   - include CGR: no
   - stack pattern: none
   - UX pattern: none
   - API-first posture when a stack pattern is selected: yes
   - create GitHub repo: no
6. Install the selected Atlas_AI files from the source kit into the target root. Include root instruction files, reusable prompts, skills when needed, and optional scaffold or governance docs according to the selected setup. Prefer merging and preserving project-specific content over overwriting user-authored files.
7. If a stack pattern is selected, create `patterns/stack-patterns/active-stack-pattern.md` from the chosen template and record API-first posture there.
8. If a UX pattern is selected, create `patterns/ux-patterns/active-ux-pattern.md` from the chosen template.
9. Ensure `accounts.md` exists as the committed non-secret cloud account binding file and `secrets.md` exists as the local-only secrets note when scaffold is included.
10. If git is absent and the user keeps the default bootstrap behavior, initialize git, copy `.gitignore`, and create an initial commit containing installed project artifacts only. If git already exists, adopt it and stage only the approved Atlas project artifacts.
11. If the user asks for GitHub repository creation, require the GitHub owner or org value and explain any missing CLI or auth prerequisite instead of inventing one.
12. Validate with targeted file-presence checks, parser checks, or text searches. Summarize:
   - files installed
   - pre-existing user material preserved under `docs/reference/preexisting-root/`
   - whether git was adopted or initialized
   - optional components included
   - unresolved manual follow-up

## Default Decisions

- Keep `secrets.md` ignored and local-only.
- Commit `accounts.md` as the non-secret cloud account binding source of truth.
- Keep reusable stack and UX patterns under `patterns/`.
- Keep API-first posture in `patterns/stack-patterns/active-stack-pattern.md` when a stack pattern is selected.
- Keep governance artifacts under `docs/cgr/`.
- Keep user-supplied project source material under `docs/reference/`, such as old MRDs, PRDs, specifications, marketing materials, website notes, setup notes, and context for planning, devcycles, and CGR.
- Keep `atlas_ai.ps1` and `NewProject.bat` as fallback or manual setup paths, not the primary workflow.
- Stop and route to `atlas_update.md` instead of reinstalling when Atlas control files already exist at the repo root.
