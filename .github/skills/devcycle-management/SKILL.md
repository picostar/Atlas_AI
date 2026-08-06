---
name: devcycle-management
description: 'Manage dev tasks, devcycles, and retro logging. Use when creating DTs, closing tasks, inserting RDTs, updating status.md, moving completed work to retro.md, or managing the burn-down list in devcycle.md.'
---

# Devcycle Management

## When to Use

- Creating or updating devtasks (DT) in devcycle.md
- Inserting reset devtasks (RDT) for unplanned work
- Moving completed tasks from devcycle.md to retro.md
- Updating status.md after shipping
- Estimating effort in CU (Complexity Units)
- Getting a model-tier suggestion when assigning eMOE, or logging a usage/model-fit note when recording aMOE (see the model-tier-advisor skill)

## Procedure

Refer to [ATLAS.md](../../../ATLAS.md) for the full process rules. Key steps:

### Starting a Task
1. Pick the next DT from `docs/agile/devcycle.md`
2. Use the model-tier-advisor skill to state a suggested model tier based on eMOE, using the table for whichever AI tool is active
3. Implement the task
4. Smoke test the change with CLI commands or a script
5. Ensure the task entry includes both `Smoketest:` and `UAT:` sections
6. Complete the `UAT:` section with either handoff instructions or an explicit non-UAT note

### Completing a Task
1. Record the outcome in `docs/agile/retro.md` with both eMOE and aMOE
2. If using model-tier-advisor, add its optional Usage/Model Fit notes to the retro entry
3. Create a task-level git commit
4. If a GitHub remote exists, push the branch and perform the GitHub follow-up step
5. Remove the task from `docs/agile/devcycle.md`
6. Update `docs/agile/status.md` if the repo tracks live state
7. If aMOE exceeds eMOE by 2 or more CU, capture why

### Inserting a Reset Task
1. Add under a `Reset` section in devcycle.md
2. Prefix as RDT (RDT1, RDT2, etc.)
3. Insert AHEAD of remaining unfinished planned DTs
4. Complete it first, then resume the interrupted cycle

### When the Cycle Burns Down
- Pull next priority from `docs/agile/backlog.md` into a new cycle

## CU Scale

| CU | Meaning |
|---|---|
| 1 | Single known step, little decision risk |
| 2 | Multi-step, known path |
| 3 | Multi-step, minor unknowns or dependencies |
| 5 | Research plus implementation, real decision risk |
| 8 | High uncertainty, multiple dependencies, likely reshaping |

## Rules

- devcycle.md is a burn-down -- completed items do NOT stay
- Completed work goes to retro.md only
- Use DT for planned tasks, RDT for unplanned interrupts
- Every task needs both a `Smoketest:` section and a `UAT:` section before it can be closed
- In API-first mode, every task should include an API result when feasible, and smoketest should verify endpoints plus OpenAPI or Swagger docs when feasible
- For non-user-facing work, the `UAT:` section should explicitly say `Not UAT-eligible` and describe the internal validation
- Every completed task needs a task-level git commit
- If a GitHub remote exists, every completed task needs a GitHub follow-up step
- Break down 8-CU tasks when practical
- Usage and Model Fit notes in retro.md are optional additions from the model-tier-advisor skill; do not block task completion on them
- Before asking the user for credentials, tokens, keys, or other secret values, check `secrets.md` at the repository root first if it exists
- Do not place secrets in any other file by default; if the user requests an override, warn first and proceed only after confirmation
