# CGR Docs

Use this folder for governance-facing project planning and design documents.

## What CGR Means

CGR means Compliance and Governance Review.

A CGR is a structured review of live project artifacts such as MRD, PRD, and ESD documents to verify governance readiness, delivery controls, and release decision quality.

To run CGR, type `CGR` in AI chat. You can also say `run CGR`. The agent should use `.github/prompts/cgr.prompt.md` and write the review to `docs/cgr/CGR-results.md`.

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
- `seed-to-docs-mapping.md` (optional, maps seed, reference, and project source files to MRD PRD ESD sections)
- `remediation-tracking.md` (optional, tracks rule-level remediation across iterations)
- ADRs, roadmaps, decision logs, or governance records as needed

Starter docs are included in this folder to help bootstrap a new project. On the first CGR run, remove `MRD_TEMPLATE.md` and `PRD_TEMPLATE.md` if they are still present. In all cases, once a live MRD, PRD, or ESD artifact exists, remove the matching `*_TEMPLATE.md` file so this folder contains live project artifacts only.

Keep `CGR-results.md` in this folder alongside the live MRD, PRD, and ESD artifacts for the project being reviewed.

If your team uses numeric governance scoring, keep `score.md` in this folder as a derived artifact that references the latest `CGR-results.md`.

## Bootstrap Workflow From Seed, Reference, And Source Inputs

Use this when live MRD, PRD, and ESD docs do not exist yet.

1. Use prompt `.github/prompts/cgr-seed-to-cgr.prompt.md`.
2. Read `seed.md`, relevant files under `docs/reference/`, and relevant project source files such as marketing copy, website text, product notes, sales material, specifications, discovery notes, or other text-readable context.
3. Generate draft docs in `docs/cgr/`.
4. Update `seed-to-docs-mapping.md` to show evidence sources and missing inputs.
5. Run CGR and produce `CGR-results.md`.
6. If scoring is enabled, refresh `score.md`.

## Iteration Workflow Using CGR Results And Score

Use this after the first CGR output exists.

1. Use prompt `.github/prompts/cgr-iterate.prompt.md`.
2. Read current MRD, PRD, ESD plus `CGR-results.md` and `score.md`.
3. Prioritize unresolved Critical and High gaps.
4. Update docs and rerun CGR.
5. Refresh `score.md` and `remediation-tracking.md`.
6. Repeat until gate targets are met for the intended stage.