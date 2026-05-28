# PRD Template

Use this template to translate MRD intent into testable product requirements for a release.

Field criticality markers:
- `[MANDATORY]` required for gate readiness.
- `[CONDITIONAL]` required only when applicable.
- `[OPTIONAL]` useful context that improves quality.

## Document Control

Guidance: keep ownership, version, and related artifacts current.

- `[MANDATORY]` Project: TBD
- `[MANDATORY]` Version: v1
- `[MANDATORY]` Owner: TBD
- `[MANDATORY]` Status: Draft
- `[MANDATORY]` Last Updated: YYYY-MM-DD
- `[MANDATORY]` Related MRD: MRD_<PROJECT>_vX.md

## Scope Summary

Guidance: define what this release includes and excludes.

- `[MANDATORY]` In-scope summary:
- `[MANDATORY]` Out-of-scope summary:

## Goals

Guidance: goals should map directly to MRD outcomes.

- `[MANDATORY]` Goal 1:
- `[MANDATORY]` Goal 2:

## Non-Goals

Guidance: explicit non-goals prevent scope drift.

- `[MANDATORY]` Non-goal 1:
- `[MANDATORY]` Non-goal 2:

## User Stories Or Use Cases

Guidance: each use case needs an actor, trigger, and expected result.

### U1 -- Example Use Case
- `[MANDATORY]` Actor:
- `[MANDATORY]` Trigger:
- `[MANDATORY]` Expected result:
- `[OPTIONAL]` Error or exception path:

## Functional Requirements

Guidance: write clear requirement statements that can be tested. Use explicit requirement levels where appropriate.

- `[MANDATORY]` FR1:
- `[MANDATORY]` FR2:
- `[OPTIONAL]` FR3:

## Acceptance Criteria

Guidance: each criterion should be observable and verifiable in pilot or validation.

- `[MANDATORY]` AC1:
- `[MANDATORY]` AC2:
- `[CONDITIONAL]` Security or compliance acceptance criteria:

## Pilot And UAT Plan

Guidance: define pilot boundary, measurable pass signals, and UAT ownership.

- `[MANDATORY]` Pilot scope:
- `[MANDATORY]` Acceptance measure:
- `[MANDATORY]` UAT owner:
- `[CONDITIONAL]` Not UAT-eligible rationale:

## Capacity Assumptions

Guidance: include expected usage volumes and known limits.

- `[MANDATORY]` User volume:
- `[MANDATORY]` Throughput or request volume:
- `[MANDATORY]` Data volume:
- `[OPTIONAL]` Constraint notes:

## Ownership And Approvals

Guidance: EVT gate ownership must be explicit.

- `[MANDATORY]` Product Owner:
- `[MANDATORY]` Business or Commercial Owner:
- `[MANDATORY]` Executive Sponsor:

## Dependencies

Guidance: list technical, organizational, and vendor dependencies.

- `[MANDATORY]` Dependency 1:
- `[MANDATORY]` Dependency 2:

## Open Questions

Guidance: unresolved questions should have owner and due date.

- `[CONDITIONAL]` Question 1:
- `[CONDITIONAL]` Question 2:

## Pre-Review Checklist -- PRD

- [ ] Scope and non-goals are explicit.
- [ ] Each functional requirement maps to at least one acceptance criterion.
- [ ] Acceptance criteria are testable and pilot-ready.
- [ ] Pilot and UAT ownership are clear.
- [ ] Capacity assumptions are documented with rationale.
- [ ] Ownership and approval roles are complete.
- [ ] Open questions have owners and due dates, or are resolved.
- [ ] PRD is ready for ESD design authoring.