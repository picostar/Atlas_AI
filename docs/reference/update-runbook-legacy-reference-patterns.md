# Legacy Update Runbook: docs/reference Pattern Layout

Use this runbook when a legacy repository stores stack and UX patterns under `docs/reference/*-patterns` and you need a low-risk Atlas update.

## Scope

- Keep legacy canonical paths by default.
- Do not run in-place migration unless explicitly approved.
- Keep process plan-first and approval-gated.

## Step 1. Discovery

1. Confirm canonical process file: `atlas.md` or `ATLAS.md`.
2. Confirm pattern roots:
   - `docs/reference/stack-patterns/`
   - `docs/reference/ux-patterns/`
3. Confirm governance root:
   - `docs/projects/` or `CGR.md`, and whether `docs/cgr/` exists.
4. Inventory account and secret source files.

Output:
- A compatibility matrix using [update-path-compatibility-map.md](update-path-compatibility-map.md).

## Step 2. Plan Package

Prepare a plan-only package that includes:

- file-by-file copy/merge list from SOT
- preserve and no-touch list
- approval-gated migration candidates
- account and secret classification plan
- archive safety plan using tracked `docs/reference/retired-docs/`
- validation checklist from [update-validation-checklist.md](update-validation-checklist.md)

## Step 3. Approval Gate

Require explicit approval before any move, rename, delete, or migration action.

If approval is limited to non-migration updates:
- copy or merge SOT files while preserving legacy path layout
- import stack and UX template catalogs into legacy canonical paths
- keep migration candidates deferred

Before any edits, create rollback path:
- if git exists, create pre-update rollback branch or tag and record its name
- if git does not exist, create timestamped filesystem backup and record restore steps
- if rollback path cannot be confirmed, stop and ask before continuing

## Step 4. Execute Approved Changes

1. Apply minimal edits.
2. Preserve project-specific values.
3. Build committed-safe `accounts.md` from non-secret bindings only.
4. Keep secrets in local-only `secrets.md`.
5. Never copy secret values into committed docs or instruction files.

## Step 5. Validate

Run the checklist in [update-validation-checklist.md](update-validation-checklist.md).

Minimum required outcomes:
- post-update file presence checks pass
- reference integrity checks pass
- secret leak checks pass
- stack and UX pattern availability checks pass
- git status works, including safe.directory fallback when needed

## Step 6. Optional Migration Preview

Only when user explicitly requests migration, preview first:

```powershell
pwsh -File scripts/migrate-layout-v2.ps1 -RepoRoot . -WhatIf
```

After review and explicit approval:

```powershell
pwsh -File scripts/migrate-layout-v2.ps1 -RepoRoot . -Approved
```

Record any unresolved conflicts and post-migration reference updates.

## Backward Compatibility Notes

- Legacy path support is retained and remains first-class.
- Mixed-layout repositories are supported through compatibility mapping and selective copy/merge.
- In-place migration remains opt-in and approval-gated.

## Known Limits

- Monolithic `CGR.md` files require manual split decisions.
- Legacy freeform notes can hide secret material that needs manual review.
- Large repos may require staged updates to reduce conflict risk.
