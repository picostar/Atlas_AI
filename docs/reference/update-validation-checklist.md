# Atlas Update Validation Checklist

Use this checklist for `atlas_update.md` runs.

A run is complete only when each required check has a clear `Pass` signal or an explicit blocker note.

## 1. Pre-Update Discovery Checks

| ID | Check | Pass Signal |
|---|---|---|
| D1 | Canonical layout detected (`ATLAS.md` or `atlas.md`) | Plan states canonical naming and why |
| D2 | Pattern roots detected | Plan lists stack and UX roots and legacy equivalents |
| D3 | CGR roots detected | Plan lists `docs/cgr/` or legacy `docs/projects/` / `CGR.md` |
| D4 | Compatibility matrix completed | Matrix includes local path, SOT equivalent, and action |
| D5 | Account and secret sources inventoried | Candidate files listed with secret/non-secret classification |
| D6 | Archive policy reviewed | Plan uses tracked `docs/reference/retired-docs/` or documents exception |
| D7 | Git status precheck executed | `git status` succeeded or blocker plus fallback steps recorded |
| D8 | Rollback path prepared | Git rollback ref or filesystem backup plan is defined before edits |

## 2. Approval Gate Checks

| ID | Check | Pass Signal |
|---|---|---|
| A1 | Plan-first output delivered | File-by-file plan shown before edits |
| A2 | Migration actions approval-gated | Every move/rename/delete item marked `needs approval` |
| A3 | Missing pattern families handled gracefully | Plan includes fallback when stack or UX family is absent |
| A4 | Account and secret migration safe | Plan states no secret values in committed files |

## 3. Pre-Update Rollback Checks

| ID | Check | Pass Signal |
|---|---|---|
| R1 | Rollback type selected | Git rollback ref for git repos, filesystem backup for non-git repos |
| R2 | Rollback artifact created | Branch or tag exists, or backup path exists |
| R3 | Restore instructions recorded | Summary includes exact rollback command or restore steps |
| R4 | Proceed gate honored | No update edits started before R1 to R3 pass, unless user explicitly waives |

## 4. Post-Update Presence Checks

| ID | Check | Pass Signal |
|---|---|---|
| P1 | Required instruction files present | Expected root files exist in chosen canonical layout |
| P2 | Stack template catalog available | Catalog exists in local canonical stack root |
| P3 | UX template catalog available | Catalog exists in local canonical UX root |
| P4 | Active pattern guidance present | Active stack and UX baseline guidance exists |
| P5 | Account and secret files placed safely | `accounts.md` committed-safe, `secrets.md` local-only and gitignored |

## 5. Reference Integrity Checks

Run path and reference checks that match the chosen canonical layout.

PowerShell example:

```powershell
rg -n "docs/projects|docs/reference/stack-patterns|docs/reference/ux-patterns|docs/cgr|patterns/stack-patterns|patterns/ux-patterns" .
```

Pass signal:
- No broken references.
- Legacy references remain only where intentionally preserved.

## 6. Secret Leak Checks

PowerShell example:

```powershell
rg -n --glob "!secrets.md" "(?i)(api[_-]?key|token|client[_-]?secret|password|connection string|BEGIN PRIVATE KEY)" .
```

Pass signal:
- No unapproved secret material in tracked files.
- Any flagged lines are reviewed and either removed, redacted, or documented as false positives.

## 7. Windows And Mixed-Filesystem Git Checks

Run:

```powershell
git -C <repo> status
```

If dubious ownership appears, run one of:

```powershell
git config --global --add safe.directory <repo>
```

```powershell
git config --system --add safe.directory <repo>
```

Pass signal:
- `git -C <repo> status` succeeds after fallback or blocker is documented.

## 8. Final Pass Criteria

- All required checks are `Pass`, or blockers are explicit and actionable.
- Rollback path was created and recorded before any update edits, unless explicitly waived by user.
- No hidden archival moves into ignored paths without warning.
- No secret values committed.
- Both stack and UX pattern template families are available or explicitly documented as unavailable with next steps.
