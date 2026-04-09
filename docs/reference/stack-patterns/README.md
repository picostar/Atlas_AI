# Stack Patterns

Use this folder for reusable stack baseline notes for the current repository.

Recommended file:
- `active-stack-pattern.md` -- the current approved stack baseline for architecture, hosting, deployment, infrastructure, and platform choices

Guidance:
- Create `active-stack-pattern.md` only when the repo has an agreed stack baseline worth enforcing
- Keep it current as the stack changes
- Keep secrets, credentials, tenant values, and environment-specific tokens out of it
- Prefer approved patterns, constraints, and decision rationale over one-off setup steps

When `active-stack-pattern.md` exists, the instruction stack can treat it as the current baseline for stack-sensitive tasks.