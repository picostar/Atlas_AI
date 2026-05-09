---
name: "Atlas Guided Update"
description: "Use when updating a legacy atlas project to the current Atlas_AI kit with a plan-first human review."
argument-hint: "Optional legacy project path, scope, or update constraints"
agent: "agent"
---

# Atlas Guided Update Prompt

Use this prompt when updating a legacy atlas project to the current Atlas_AI process kit.

Run this prompt from `.github/prompts/`, copy it into the legacy project, or paste its prompt into the agent while the legacy project is open in VS Code.

Do not run a hard updater script. Treat this as a guided repository update: inspect, compare, ask targeted questions, then produce an update plan for human review. Do not modify, move, rename, or delete files until a human approves the plan.

## Prompt

You are preparing to update this legacy atlas project to align with the current public Atlas_AI kit.

Planning phase only: do not edit files, run migration scripts, move folders, rename files, delete files, or run destructive commands. Your first deliverable is an update plan for human review.

1. Read the local repository instructions first, especially `.github/copilot-instructions.md`, `ATLAS.md`, and any existing `AGENTS.md`, `CLAUDE.md`, `CHATGPT.md`, `GEMINI.md`, `GROK.md`, or `DEEPSEEK.md` files.
2. Use `picostar/Atlas_AI` on its default branch as the source of truth for the current kit. If the Atlas_AI repository is open locally, inspect that repo. Otherwise fetch or inspect the public repository.
3. Compare the local legacy project against the Atlas_AI source of truth before proposing edits. Focus on:
   - root instruction files
   - `.github/prompts/`
   - `.github/skills/`
   - `ATLAS.md`, `docs/cgr/PS.md`, and `.github/prompts/cgr.prompt.md`
   - `docs/agile/`, `docs/cgr/`, and `docs/reference/`
   - `patterns/stack-patterns/` and `patterns/ux-patterns/`
   - `scripts/`
   - `accounts.md` and `secrets.md` handling
4. Detect legacy layout paths, including `docs/projects`, `docs/reference/stack-patterns`, and `docs/reference/ux-patterns`.
5. Detect legacy account-binding files. Recommend consolidating non-secret provider binding into committed `accounts.md` after human review. `secrets.md` remains the local-only file for credentials, keys, tokens, and other secrets.
6. Present a concise update plan that answers:
   - which files will be copied or merged from the public kit
   - which local project files should be preserved
   - whether legacy layout folders should stay in place or be moved
   - whether legacy account-binding files should be consolidated into `accounts.md`
   - whether any project-specific values need user confirmation
7. Ask only the questions needed to avoid losing project-specific content.
8. Stop after presenting the plan and questions. Wait for explicit human approval before making changes.
9. After approval, apply minimal edits. Prefer merging and preserving local facts over overwriting project-specific files.
10. Do not place secrets in committed files. Do not copy secret values from `secrets.md` into `accounts.md`, docs, prompts, scripts, or governance artifacts.
11. Validate with targeted CLI checks, parser checks, or text searches. Summarize changed files, unresolved questions, and any manual follow-up.

## Default Decisions

- Keep `secrets.md` ignored and local-only.
- Commit `accounts.md` as the non-secret cloud account binding source of truth.
- Keep reusable stack and UX patterns under `patterns/`.
- Keep governance artifacts under `docs/cgr/`.
- Keep setup notes, runbooks, and provider references under `docs/reference/`.
- Use manual review before any legacy layout migration.
- The first run of this prompt is plan-only. Execution requires explicit human approval.
