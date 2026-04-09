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

## Procedure

Refer to [ATLAS.md](../../../ATLAS.md) for the full process rules. Key steps:

### Starting a Task
1. Pick the next DT from `docs/agile/devcycle.md`
2. Implement the task
3. Smoke test the change with CLI commands or a script
4. Ensure the task entry includes both `Smoketest:` and `UAT:` sections
5. Complete the `UAT:` section with either handoff instructions or an explicit non-UAT note

### Completing a Task
1. Record the outcome in `docs/agile/retro.md` with both eMOE and aMOE
2. Create a task-level git commit
3. If a GitHub remote exists, push the branch and perform the GitHub follow-up step
4. Remove the task from `docs/agile/devcycle.md`
5. Update `docs/agile/status.md` if the repo tracks live state
6. If aMOE exceeds eMOE by 2 or more CU, capture why

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
- For non-user-facing work, the `UAT:` section should explicitly say `Not UAT-eligible` and describe the internal validation
- Every completed task needs a task-level git commit
- If a GitHub remote exists, every completed task needs a GitHub follow-up step
- Break down 8-CU tasks when practical
