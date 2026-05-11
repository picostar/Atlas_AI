# Prompt Catalog

This folder stores reusable prompt files for common atlas_ai workflows.

## Included Prompts
- `atlas-realign.prompt.md` -- ATLAS alignment and readiness review
- `atlas-closeout.prompt.md` -- end-of-session closeout readiness review
- `cgr.prompt.md` -- compliance and governance review workflow
- `cgr-seed-to-cgr.prompt.md` -- bootstrap MRD PRD ESD from seed and reference inputs, then run CGR and score outputs
- `cgr-iterate.prompt.md` -- iterate MRD PRD ESD using CGR-results and score deltas

Standalone root prompts live at the repo root so they are easy to copy into another project and invoke without installing the full prompt catalog:
- `atlas_newproject.md` -- guided new-project bootstrap prompt for cross-platform prompt-first setup
- `atlas_update.md` -- guided legacy Atlas update prompt for plan-first project updates

## Usage
- Use prompts when you want a structured review with fixed output format.
- Prefer prompts for repeatable quality checks and governance checks.
- To run the governance workflow, type `CGR` or say `run CGR` in AI chat. The agent should use `cgr.prompt.md`.

## Frontmatter
Use the schema in `.github/FRONTMATTER-SCHEMA.md`.
