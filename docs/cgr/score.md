# CGR Scorecard

## Metadata

- Review date: YYYY-MM-DD
- Reviewer: TBD
- Source results: docs/cgr/CGR-results.md
- Stage assessed: EVT or DVT or PVT

## Overall Result

- Overall score (0-100): TBD
- Gate recommendation: Hold or Proceed with Conditions or Proceed
- Previous score: TBD
- Score delta: TBD

## Scoring Method

Status points:
- Compliant = 1.0
- Partially = 0.5
- Missing = 0.0
- N/A = excluded from denominator

Default rule weights:
- Critical = 3
- High = 2
- Standard = 1

Default criticality mapping:
- Critical: Rules 2, 7, 8, 9, 10, 11, 12, 13, 16
- High: Rules 3, 4, 5, 6, 14, 15
- Standard: Rule 1

Formula:
- Rule weighted points = status points * rule weight
- Maximum weighted points = sum of applicable rule weights
- Overall score = (sum rule weighted points / maximum weighted points) * 100

## Completeness Validation

- A rule cannot be marked `Compliant` if mandatory fields for that rule remain `TBD` or unresolved.
- If mandatory fields have partial evidence, use `Partially`.
- Conditional fields count in the denominator only when applicable.
- Recommended strict mode for gate decisions:
	- DVT: no unresolved mandatory fields in Rules 2, 6, 7, 8, 9, 10, 11, 12.
	- PVT: no unresolved mandatory fields in any Critical or High rule.

## Gate Threshold Profile (Default)

- DVT target: score >= 70 and no unresolved Critical rule in Missing status
- PVT target: score >= 85 and no unresolved Critical or High rule in Missing status

## Gate Failure Conditions

- `Hold` regardless of score when required ownership is missing for the stage.
- `Hold` regardless of score when rollback plan, security review status, or operational handoff is missing.
- `Proceed with Conditions` only when exceptions have explicit owner, approval, expiry, and revalidation date.

## Rule Score Table

| Rule | Status | Weight | Weighted Points | Evidence In Results | Owner | Target Date |
|---|---|---|---|---|---|---|
| 1 | TBD | 1 | TBD | TBD | TBD | TBD |
| 2 | TBD | 3 | TBD | TBD | TBD | TBD |
| 3 | TBD | 2 | TBD | TBD | TBD | TBD |
| 4 | TBD | 2 | TBD | TBD | TBD | TBD |
| 5 | TBD | 2 | TBD | TBD | TBD | TBD |
| 6 | TBD | 2 | TBD | TBD | TBD | TBD |
| 7 | TBD | 3 | TBD | TBD | TBD | TBD |
| 8 | TBD | 3 | TBD | TBD | TBD | TBD |
| 9 | TBD | 3 | TBD | TBD | TBD | TBD |
| 10 | TBD | 3 | TBD | TBD | TBD | TBD |
| 11 | TBD | 3 | TBD | TBD | TBD | TBD |
| 12 | TBD | 3 | TBD | TBD | TBD | TBD |
| 13 | TBD | 3 | TBD | TBD | TBD | TBD |
| 14 | TBD | 2 | TBD | TBD | TBD | TBD |
| 15 | TBD | 2 | TBD | TBD | TBD | TBD |
| 16 | TBD | 3 | TBD | TBD | TBD | TBD |

## Top Remediation Priorities

1. TBD
2. TBD
3. TBD
4. TBD
5. TBD

## Exception Log

| Rule | Exception Summary | Approval Owner | Expiry Date | Revalidation Date |
|---|---|---|---|---|
| TBD | TBD | TBD | TBD | TBD |

## Scoring Notes

- Record any manual scoring override and rationale.
- Link each rule score to evidence in `docs/cgr/CGR-results.md`.
