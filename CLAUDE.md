# Project Instructions

Read `.github/copilot-instructions.md` first. That file is the source of truth.

If `docs/agile/` files still contain placeholder scaffold content, treat the repository as a template or kit unless there is clear evidence it has been activated as a live project. In that case, assess template integrity and adoption readiness instead of treating placeholder agile docs as workflow failures.

If the user opens with a greeting or start-of-session phrase, such as `hi`, `hello`, `good morning`, or `ready to start`, treat it as a request for a quick project check-in. Review project state using `ATLAS.md`, then prioritize `docs/agile/status.md`, `docs/agile/devcycle.md`, and `docs/agile/backlog.md` as needed. Confirm whether the project appears ready to start and suggest the next ATLAS-based step.

If the user uses a short launch phrase, such as `do it`, `lets go`, `let's go`, `go ahead`, `start`, `proceed`, `make it so`, `engage`, `hit it`, or `punch it`, treat it as authorization to begin work. Perform a brief ATLAS readiness check, confirm the next task is clear, then execute immediately unless a blocker requires a minimal clarification.

If the user closes with a sign-off phrase, such as `good night`, `goodnight`, `goodbye`, `that's all`, or `we are done`, treat it as a request for a quick end-of-session check. Confirm whether the current state appears to follow ATLAS, call out obvious closeout gaps such as missing smoketest confirmation, missing UAT handoff or explicit non-UAT note, missing task-level commit, missing GitHub follow-up, or missing doc updates, and confirm whether any required git or GitHub follow-up step is still pending.

Then read `ATLAS.md` for the default development process.

If `docs/reference/stack-patterns/active-stack-pattern.md` exists and the task affects architecture, hosting, deployment, infrastructure, or platform selection, read it after `ATLAS.md` and treat it as the current stack baseline.

Read `PS.md` only when the project uses formal release stages (EVT, DVT, PVT, GA) and document gates (MRD, PRD, ESD). It is optional.

Read `CGR.md` only when the user asks for a governance review, stage-gate review, or document-compliance review.

This kit is intended to live at the repository root. If it is copied into a nested folder, automatic loading may not work.

Use `ntelio_ai` as the recommended session phrase when you want an agent to adopt this process in an existing repository.

Response guidelines are defined in `.github/copilot-instructions.md`. Do not duplicate them here.
