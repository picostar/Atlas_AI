# API-First Policy

This file records API-first setup intent for this repository.

- API-first mode: Enabled
- Default mode in atlas_ai setup: Enabled

## Policy

- Each DT or RDT should include an API result when feasible.
- When API output is in scope, Smoketest should verify endpoints and OpenAPI or Swagger documentation when feasible.
- If a project chooses to disable API-first mode during setup, API work is still allowed when the task requires it.

## Notes

- This file must not contain secrets.
- Store local secrets only in secrets.md at repository root, and keep that file gitignored.
- Store non-secret cloud account and deployment destination binding in accounts.md at repository root.
