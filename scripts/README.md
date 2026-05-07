# Scripts

Use this folder for reusable scripts that support development, validation, deployment, or reporting.

Guidelines:
- prefer repeatable scripts over manual portal steps
- keep scripts parameterized
- read config at runtime instead of hardcoding environments or credentials
- document required inputs and expected outputs

Included script:
- `migrate-layout-v2.ps1` -- one-time migration from legacy layout (`docs/projects`, `docs/reference/*-patterns`) to v2 layout (`docs/cgr`, `patterns/*-patterns`)

Related root script:
- `updateatlas.ps1` -- one-step updater for older atlas projects. It runs git safety preflight and creates a rollback tag by default, can push the rollback tag to `origin` with `-PushRollbackTag`, refreshes kit files non-destructively, runs verification, performs legacy layout migration when needed, and removes seed updater artifacts after success unless `-KeepSeedArtifacts` or `-NoSelfDelete` is used.