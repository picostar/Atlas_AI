# Atlas Update Path Compatibility Map

This document is the source map for compatibility-first updates in legacy Atlas repositories.

Use this with [atlas_update.md](../../atlas_update.md). The update default is preserve local canonical paths unless migration is explicitly approved.

## Matrix

| Concern | SOT Path (v2) | Legacy Variant(s) | Default Action | Migration Rule |
|---|---|---|---|---|
| ATLAS process file | `ATLAS.md` | `atlas.md` | Keep whichever is canonical locally | Rename only with explicit approval |
| Stack pattern root | `patterns/stack-patterns/` | `docs/reference/stack-patterns/` | Keep local canonical root | Move only with explicit approval |
| Stack template catalog | `patterns/stack-patterns/stack-pattern-templates/` | `docs/reference/stack-patterns/stack-pattern-templates/` | Ensure catalog exists under local canonical root | Do not force path migration |
| Active stack baseline | `patterns/stack-patterns/active-stack-pattern.md` | `docs/reference/stack-patterns/active-stack-pattern.md` | Keep local canonical location | Move only with explicit approval |
| UX pattern root | `patterns/ux-patterns/` | `docs/reference/ux-patterns/` | Keep local canonical root | Move only with explicit approval |
| UX template catalog | `patterns/ux-patterns/ux-pattern-templates/` | `docs/reference/ux-patterns/ux-pattern-templates/` | Ensure catalog exists under local canonical root | Do not force path migration |
| Active UX baseline | `patterns/ux-patterns/active-ux-pattern.md` | `docs/reference/ux-patterns/active-ux-pattern.md` | Keep local canonical location | Move only with explicit approval |
| CGR docs root | `docs/cgr/` | `docs/projects/` | Keep local canonical root | Move only with explicit approval |
| Project stages file | `docs/cgr/PS.md` | `docs/projects/PS.md` or `CGR.md` | Keep local canonical path and map equivalent | Move only with explicit approval |
| CGR output | `docs/cgr/CGR-results.md` | `docs/projects/CGR-results.md` or section in `CGR.md` | Keep local canonical output path | Split or rename only with explicit approval |

## Read-Order Example: v2 Canonical Layout

1. `.github/copilot-instructions.md`
2. `ATLAS.md`
3. `docs/cgr/PS.md` (when formal stages are used)
4. `.github/prompts/cgr.prompt.md` (when governance review is in scope)
5. `patterns/stack-patterns/active-stack-pattern.md` (if present)
6. `patterns/ux-patterns/active-ux-pattern.md` (if present)

## Read-Order Example: Legacy Canonical Layout

1. `.github/copilot-instructions.md`
2. `atlas.md` (or `ATLAS.md` if that is what exists)
3. `docs/projects/PS.md` or `CGR.md` (when formal stages are used)
4. `.github/prompts/cgr.prompt.md` (if available)
5. `docs/reference/stack-patterns/active-stack-pattern.md` (if present)
6. `docs/reference/ux-patterns/active-ux-pattern.md` (if present)

## Compatibility Rules

- Detect local canonical layout first.
- Preserve local canonical paths by default.
- Import missing stack and UX template catalogs into the local canonical roots.
- Treat migration to v2 paths as optional and approval-gated.
- For mixed layouts, mark each path as `keep`, `copy alongside`, or `migrate later` in the plan.

## Known Limits

- Automatic path migration can still conflict with live local changes in large repos.
- Legacy `CGR.md` monolith files often need manual split decisions before migrating to `docs/cgr/` files.
- Secret classification from freeform notes can produce false positives and false negatives; human review is required before commit.
