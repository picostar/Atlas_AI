---
name: "Atlas Guided Update"
description: "Use when updating a legacy atlas project to the current Atlas_AI kit with a plan-first human review. Trigger phrase: atlas update."
argument-hint: "Optional legacy project path, scope, or update constraints"
agent: "agent"
---

# Atlas Update

Use this standalone prompt when updating a legacy atlas project to the current Atlas_AI process kit.

Copy this file into the legacy project root, paste it into the agent, or say `atlas update` while the legacy project is open in VS Code.

Do not run a hard updater script. Treat this as a guided repository update: inspect, compare, ask targeted questions, then produce an update plan for human review. Do not modify, move, rename, or delete files until a human approves the plan.

This file must stand alone in the legacy project. Do not assume the legacy project already has any Atlas_AI prompts, skills, scripts, or current instruction files. Use any Atlas_AI kit files you can inspect as source material only, not as required prompt dependencies.

Access model: this prompt does not itself grant repository or network access. The agent must establish access to the current Atlas_AI source kit by using an open local checkout, inspecting `picostar/Atlas_AI`, or asking the user for a local path or permission. Once Atlas_AI source access is available, the agent can compare, plan, and then execute approved changes in the legacy project with user interaction.

## Prompt

You are preparing to update this legacy atlas project to align with the current public Atlas_AI kit.

Planning phase only: do not edit files, run migration scripts, move folders, rename files, delete files, or run destructive commands. Your first deliverable is an update plan for human review.

1. Read the local repository instructions first, especially `.github/copilot-instructions.md`, `ATLAS.md`, and any existing `AGENTS.md`, `CLAUDE.md`, `CHATGPT.md`, `GEMINI.md`, `GROK.md`, or `DEEPSEEK.md` files.
2. Establish source-kit access. Use `picostar/Atlas_AI` on its default branch as the source of truth for the current kit. If the Atlas_AI repository is open locally, inspect that repo. Otherwise fetch or inspect the public repository. If the source kit cannot be reached, stop and ask for a local Atlas_AI path, permission to access GitHub, or permission to proceed with only this copied prompt.
3. Compare the local legacy project against the Atlas_AI source of truth before proposing edits. Focus on:
   - root instruction files
   - prompt files from `.github/prompts/` in the source kit, if present
   - skill files from `.github/skills/` in the source kit, if present
   - `ATLAS.md`, `docs/cgr/PS.md`, and CGR workflow files from the source kit, if present
   - `docs/agile/`, `docs/cgr/`, and `docs/reference/`
   - `patterns/stack-patterns/` and `patterns/ux-patterns/`
   - `scripts/`
   - `accounts.md` and `secrets.md` handling
4. Detect legacy layout paths, including `docs/projects`, `docs/reference/stack-patterns`, and `docs/reference/ux-patterns`.
5. Detect legacy API-first policy files, including `docs/reference/api-first-policy.md`. Recommend moving API-first posture into `patterns/stack-patterns/active-stack-pattern.md` when a stack pattern is selected. Do not create a standalone API-first policy artifact when no stack pattern is active.
6. Detect legacy account-binding files. Recommend consolidating non-secret provider binding into committed `accounts.md` after human review. `secrets.md` remains the local-only file for credentials, keys, tokens, and other secrets.
7. Present a concise update plan that answers:
   - which files will be copied or merged from the public kit
   - which local project files should be preserved
   - whether legacy layout folders should stay in place or be moved
   - whether API-first posture should be recorded in the active stack pattern
   - whether legacy account-binding files should be consolidated into `accounts.md`
   - whether any project-specific values need user confirmation
8. Ask only the questions needed to avoid losing project-specific content.
9. Stop after presenting the plan and questions. Wait for explicit human approval before making changes.
10. After approval, execute the approved changes in the legacy project with user interaction as needed. Apply minimal edits. Prefer merging and preserving local facts over overwriting project-specific files.
11. Do not place secrets in committed files. Do not copy secret values from `secrets.md` into `accounts.md`, docs, prompts, scripts, or governance artifacts.
12. Validate with targeted CLI checks, parser checks, or text searches. Summarize changed files, unresolved questions, and any manual follow-up.

## Default Decisions

- Keep `secrets.md` ignored and local-only.
- Commit `accounts.md` as the non-secret cloud account binding source of truth.
- Keep reusable stack and UX patterns under `patterns/`.
- Keep API-first posture in `patterns/stack-patterns/active-stack-pattern.md` when a stack pattern is selected.
- Keep governance artifacts under `docs/cgr/`.
- Keep user-supplied project source material under `docs/reference/`, such as old MRDs, PRDs, specifications, marketing materials, website notes, setup notes, and context for planning, devcycles, and CGR.
- Use manual review before any legacy layout migration.
- Treat `.github/prompts/` files as optional workflow files to copy or merge from the source kit. This prompt does not require them to exist before the update.
- The first run of this prompt is plan-only. Execution requires explicit human approval.