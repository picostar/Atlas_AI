---
name: "CGR Iterate And Improve"
description: "Use when CGR-results and score artifacts exist and you want to iteratively improve MRD, PRD, and ESD quality."
argument-hint: "Optional focus rules, target score, or stage gate"
agent: "agent"
---

Iterate governance documents using the latest CGR and score outputs.

Before asking the user for credentials, tokens, keys, or other secret values, check `accounts.txt` at the repository root first if it exists.

Use these files as the baseline:
- [Source of truth](../copilot-instructions.md)
- [ATLAS process](../../ATLAS.md)
- [Project stages](../../PS.md), only if formal stages are in use
- [Governance prompt baseline](../../CGR.md)
- [CGR docs guidance](../../docs/cgr/README.md)
- [Current CGR review output](../../docs/cgr/CGR-results.md), if it exists
- [Current score output](../../docs/cgr/score.md), if it exists
- [Remediation tracker](../../docs/cgr/remediation-tracking.md), if it exists
- [Seed and reference sources](../../seed.md), [Reference docs folder](../../docs/reference/README.md)

Perform this workflow in order:

1. Assess current state.
- Read live MRD, PRD, and ESD artifacts in `docs/cgr/`.
- Read `CGR-results.md` and `score.md` if present.
- Identify unresolved gaps and prioritize Critical and High items.

2. Apply targeted improvements.
- Update MRD, PRD, and ESD content to close the highest-priority gaps first.
- Keep edits specific and traceable to rule-level findings.
- Do not invent missing approvals or decisions. Mark unknowns clearly.

3. Refresh governance outputs.
- Re-run CGR evaluation logic from `CGR.md`.
- Update `docs/cgr/CGR-results.md` with new compliance status.
- Update `docs/cgr/score.md` with score delta and updated gate recommendation.

4. Update remediation tracker.
- Refresh `docs/cgr/remediation-tracking.md` with status changes, owners, and target dates.
- Record exceptions only when justified and include expiry dates.

5. Prepare next iteration.
- State remaining blockers to the target stage gate.
- Recommend the next focused iteration scope.

Respond with this structure:

Iteration Status: Improved or No Significant Change

Score Delta:
- Previous score, current score, and delta.

Closed Gaps:
- List the most important gaps closed in this iteration.

Remaining Priority Gaps:
- List unresolved Critical and High gaps.

Next Iteration Scope:
- State the next concrete remediation focus.

If the user supplied extra scope below, prioritize it while still completing this workflow:

$ARGUMENTS