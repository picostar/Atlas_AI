---
name: "CGR Bootstrap From Seed"
description: "Use when MRD, PRD, and ESD drafts are needed from seed and reference inputs, then run CGR and optional scoring outputs."
argument-hint: "Optional project name, scope, stage target, or constraints"
agent: "agent"
---

Create or refresh governance drafts from startup inputs, then run CGR review outputs.

Before asking the user for credentials, tokens, keys, or other secret values, check `secrets.md` at the repository root first if it exists. Do not place secrets in any other file by default. If the user explicitly requests an override, warn about commit and leakage risk first, then proceed only after confirmation.

Use committed `accounts.md` only for non-secret cloud account and destination context. Do not copy credentials, keys, tokens, or other secrets into governance artifacts.

Use these files as the baseline:
- [Source of truth](../copilot-instructions.md)
- [ATLAS process](../../ATLAS.md)
- [Project stages](../../docs/cgr/PS.md), only if formal stages are in use
- [Governance prompt baseline](./cgr.prompt.md)
- [CGR docs guidance](../../docs/cgr/README.md)
- [Seed input](../../seed.md), if it exists
- [Project accounts](../../accounts.md), if it exists
- [Reference docs folder](../../docs/reference/README.md)
- [CGR scorecard template](../../docs/cgr/score.md), if it exists

Perform this workflow in order:

1. Collect source material.
- Read `seed.md` if present. Treat it as freeform input, not a required template. It may be as short as a single plain-language sentence.
- Read all relevant materials under `docs/reference/`.
- Read existing live docs in `docs/cgr/` if they exist.
- Identify missing information explicitly instead of inventing it.

2. Build draft governance docs.
- Create or refresh draft artifacts in `docs/cgr/`:
  - `MRD_<PROJECT>_v0-draft.md`
  - `PRD_<PROJECT>_v0-draft.md`
  - `ESD_<PROJECT>_v0-draft.md`
- Use template structure from `MRD_TEMPLATE.md`, `PRD_TEMPLATE.md`, and `ESD_TEMPLATE.md` when available.
- Infer what you can from a minimal seed and keep unresolved details as `TBD`.
- Mark unknowns as `TBD` and list clear open questions.

3. Produce source mapping.
- Update `docs/cgr/seed-to-docs-mapping.md` to show which seed and reference inputs mapped into each MRD, PRD, and ESD section.
- Call out missing source evidence and unresolved assumptions.

4. Run CGR review.
- Apply the governance evaluation process from `cgr.prompt.md` against the generated drafts.
- Write or refresh `docs/cgr/CGR-results.md` using the required baseline output format.

5. Produce score output.
- If scoring is in scope, derive and write `docs/cgr/score.md` from `CGR-results.md`.
- Use the scoring extension in `cgr.prompt.md` and capture gate recommendation.

6. Initialize remediation tracking.
- Create or refresh `docs/cgr/remediation-tracking.md` with rule-level gaps, owner placeholders, target dates, and status.
- Prioritize unresolved Critical and High gaps first.

Respond with this structure:

Bootstrap Status: Complete or Partial

Created or Updated Files:
- List generated or changed files in `docs/cgr/`.

Top Gaps:
- List the highest-priority unresolved governance gaps.

Iteration Plan:
- State the next concrete iteration step using `CGR-results.md` and `score.md`.

Open Questions:
- List only information gaps that require user input.

If the user supplied extra scope below, prioritize it while still completing this workflow:

$ARGUMENTS