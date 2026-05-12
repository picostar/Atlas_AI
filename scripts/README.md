# Scripts

Use this folder for reusable scripts that support development, validation, deployment, or reporting.

Guidelines:
- prefer repeatable scripts over manual portal steps
- keep scripts parameterized
- read config at runtime instead of hardcoding environments or credentials
- document required inputs and expected outputs

Included script:
- `migrate-layout-v2.ps1` -- optional manual migration from legacy layout (`docs/projects`, `docs/reference/*-patterns`) to v2 layout (`docs/cgr`, `patterns/*-patterns`). Preview with `-WhatIf`, plan with `atlas_update.md`, then run with `-Approved` only after human approval.

Related root prompt:
- `atlas_update.md` -- standalone guided legacy atlas update prompt. Run it from the kit, copy it into the legacy project, or paste it into an agent, use `picostar/Atlas_AI` as source of truth, and produce a human-reviewed plan before any edits.
