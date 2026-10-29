---
name: "Atlas Setup Validation"
description: "Validate an Atlas new-project installation against its manifest and setup receipt using repository file tools only. Trigger phrase: atlas validate."
argument-hint: "Optional target project path"
agent: "agent"
---

# Atlas Validate

Use this standalone prompt after new-project setup or when the user says `atlas validate`. The agent runs every check below with repository file tools. There is no script and no runtime dependency; Git CLI is the only tool assumed, and only for check 12.

## Validation Procedure

1. Resolve the target project root. Use the current project when no path is supplied.
2. Read `.atlas/install-manifest.json` and `.atlas/setup.json` from the target.
3. Run every check in the Required Checks table. Record each as PASS or FAIL with the exact path or receipt field that decided it.
4. Run the Warning Checks. Record each as OK or WARN. Warnings never fail validation.
5. Write the Validation Receipt (below) into the response and, for `newproject` runs, into `.atlas/setup.json` under `validation`.
6. Report `Atlas validation passed` only when every required check is PASS. Any FAIL means the report reads `Atlas validation failed` followed by the FAIL rows.

Do not skip a check because it is tedious. Do not mark a check PASS without reading the file or directory it names.

## Required Checks

| # | Check | Evidence to cite on FAIL |
|---|---|---|
| 1 | `.atlas/install-manifest.json` and `.atlas/setup.json` both parse as JSON and `schemaVersion` matches the manifest's supported version | file path and parse error, or the mismatched version |
| 2 | Every `questionnaire[].key` in the manifest has an entry in receipt `answers`, and each value matches the declared `type` | missing or mistyped key |
| 3 | `outcomes.git` matches the questionnaire and the repository: `initializeGit` true requires a `.git` directory; false requires none unless adopted and recorded | receipt field and actual state |
| 4 | `outcomes.github` matches `createGitHubRepository` and, when true, a remote named `origin` exists | receipt field and `git remote -v` result |
| 5 | `answers.stackPattern` and `answers.uxPattern` are null or a catalog `id`; `answers.apiFirst` is null when `stackPattern` is null | offending value |
| 6 | Every path in the manifest `core.requiredPaths` exists | each missing path |
| 7 | Every path in `core.generatedPaths` exists | each missing path |
| 8 | For each selected optional group (`scaffold`, `cgr`, `ps`, and the group named by the selected stack pattern), every `requiredPaths` entry exists | group name and each missing path |
| 9 | Each active pattern file (`patterns/stack-patterns/active-stack-pattern.md`, `patterns/ux-patterns/active-ux-pattern.md`) exists when selected and records the selected Atlas pattern ID | file path and missing or mismatched ID |
| 10 | The active stack pattern records `API-First: Enabled` or `API-First: Disabled` and it agrees with `answers.apiFirst` | file line and receipt value |
| 11 | Every direct child of the target root is listed in `allowedRootEntries.always`, `gitMetadata`, or a selected group's allowlist; report each extra as `Unexpected root entry: <name>` | each unexpected entry |
| 12 | `secrets.md` appears as an exact line in `.gitignore` and `git ls-files secrets.md` returns nothing | `.gitignore` content or the tracked path |
| 13 | Every item in receipt `relocatedRootEntries` exists under `docs/reference/preexisting-root/`, and every direct child of that folder is listed in the receipt | each unmatched entry in either direction |
| 14 | No directory named in manifest `temporarySourceKitNames` remains in the target root | the directory name |

## Warning Checks

| # | Check |
|---|---|
| W1 | `docs/agile/devcycle.md`, `retro.md`, `status.md`, `backlog.md` still contain placeholder scaffold content (expected on a fresh install; warn so the user knows the project is not yet activated) |
| W2 | `.github/skills/model-tier-advisor/SKILL.md` `Verified` dates are older than 60 days; recommend `atlas refresh models` |
| W3 | `accounts.md` exists but has no non-secret account binding filled in |

## Source-Kit Mode

When validating the Atlas_AI source kit itself rather than an installed project, run checks 1, 6, 8, 11, 12 and 14 against the kit root using the manifest alone (there is no `setup.json`), and add:

| # | Check |
|---|---|
| S1 | Every path in every manifest group exists in the kit |
| S2 | Every `catalogs.*[].sourcePath` exists in the kit |
| S3 | No path listed in the manifest is absent from the kit, and no `.ps1`, `.sh` or other executable script is listed as a required path |

## Validation Receipt

Write this block at the end of every validation run. For `newproject` runs, store the same fields in `.atlas/setup.json` under a `validation` object.

```
Atlas validation: PASSED | FAILED
Validated: <ISO date>
Validator: <agent and model name>
Mode: installed-project | source-kit
Required: <n> PASS, <n> FAIL
Warnings: <n>
Failures:
- <check #> <evidence>
```

A setup summary that does not include this receipt has not been validated. `atlas_newproject.md` step 18 and `.github/copilot-instructions.md` treat a missing receipt as a failed gate.

This validator is a completion gate for `atlas_newproject.md`. It does not gate Atlas update, CGR, or ordinary ATLAS closeout.
