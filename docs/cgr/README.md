# CGR Docs

Use this folder for governance-facing project planning and design documents.

## What CGR Means

CGR means Compliance and Governance Review.

A CGR is a structured review of live project artifacts such as MRD, PRD, and ESD documents to verify governance readiness, delivery controls, and release decision quality.

## Why CGR Matters

- It creates a repeatable quality gate before major release movement.
- It exposes gaps in scope, ownership, security, operations, and rollback readiness early.
- It reduces avoidable rework by forcing document and decision alignment before execution risk grows.
- It provides an auditable review output (`CGR-results.md`) that records findings and remediation.

Recommended files:
- `MRD_<PROJECT>_v1.md`
- `PRD_<PROJECT>_v1.md`
- `ESD_<PROJECT>_v1.md`
- `CGR-results.md`
- `score.md` (optional, derived from `CGR-results.md` scoring extension)
- ADRs, roadmaps, decision logs, or governance records as needed

Starter docs are included in this folder to help bootstrap a new project. On the first CGR run, remove `MRD_TEMPLATE.md` and `PRD_TEMPLATE.md` if they are still present. In all cases, once a live MRD, PRD, or ESD artifact exists, remove the matching `*_TEMPLATE.md` file so this folder contains live project artifacts only.

Keep `CGR-results.md` in this folder alongside the live MRD, PRD, and ESD artifacts for the project being reviewed.

If your team uses numeric governance scoring, keep `score.md` in this folder as a derived artifact that references the latest `CGR-results.md`.