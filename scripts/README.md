# Scripts

Use this folder for reusable scripts that support development, validation, deployment, or reporting.

Guidelines:
- prefer repeatable scripts over manual portal steps
- keep scripts parameterized
- read config at runtime instead of hardcoding environments or credentials
- document required inputs and expected outputs

The kit ships no scripts. This folder exists so installed projects have a home for their own smoketests, deploy helpers and reporting. Write them in the project's own language; do not add a shell or platform dependency the project does not already have.

Related root prompt:
- `atlas_update.md` -- standalone guided legacy atlas update prompt. Run it from the kit, copy it into the legacy project, or paste it into an agent, use `picostar/Atlas_AI` as source of truth, and produce a human-reviewed plan before any edits.
- `atlas_validate.md` -- the validation workflow behind `atlas validate`, run with repository file tools.
