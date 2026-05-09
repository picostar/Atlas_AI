# Scripts

Use this folder for reusable scripts that support development, validation, deployment, or reporting.

Guidelines:
- prefer repeatable scripts over manual portal steps
- keep scripts parameterized
- read config at runtime instead of hardcoding environments or credentials
- document required inputs and expected outputs

Included script:
- `migrate-layout-v2.ps1` -- optional manual migration from legacy layout (`docs/projects`, `docs/reference/*-patterns`) to v2 layout (`docs/cgr`, `patterns/*-patterns`). Preview and plan with `.github/prompts/atlas-update.prompt.md` before running it on a legacy project, and run only after human approval.

Related root prompt:
- `.github/prompts/atlas-update.prompt.md` -- guided legacy atlas update prompt. Run it from the kit, copy it into the legacy project, or paste it into an agent, use `picostar/Atlas_AI` as source of truth, and produce a human-reviewed plan before any edits.
