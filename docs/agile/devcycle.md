# Dev Cycle

Active tasks only. This is a burn-down list, not a history log.

## Current Phase

Name: Atlas setup and HCSC Claude Code Foundry pilot planning
Goal: Prepare this repository as the working project harness for the HCSC workshop demo and pilot plan.

## Active Tasks

### DT1 -- Bind Azure MCAPS account and seed Atlas planning docs

- Goal: Record the active Azure MCAPS subscription in `accounts.md` and replace placeholder backlog/devcycle content with HCSC Claude Code on Foundry project work.
- eMOE: 2 CU
- API Result: No API change.
- Smoketest: Run Markdown diagnostics on `accounts.md`, `docs/agile/backlog.md`, `docs/agile/devcycle.md`, and `docs/agile/status.md`; expected result is no new diagnostics related to these edits.
- UAT: User reviews the account binding and active dev cycle for correctness.

### DT2 -- Consolidate existing demo script into project reference docs

- Goal: Copy or summarize the existing Claude Code Foundry setup notes into `docs/reference/` so the Atlas project has the demo runbook in-repo.
- eMOE: 2 CU
- API Result: No API change.
- Smoketest: Verify the reference file exists and includes Foundry resource, project, quota status, and quota-pending fallback path.
- UAT: User confirms the demo script matches the HCSC workshop narrative.

### DT3 -- Create 5-minute operational demo artifact

- Goal: Produce a concise presenter-ready runbook for operationalizing Claude Code on Microsoft Foundry and Azure.
- eMOE: 3 CU
- API Result: No API change.
- Smoketest: Review the artifact against the workshop agenda sections and confirm it covers objectives, overview, commercials and risk, architecture and governance, use cases, and pilot next steps.
- UAT: User can rehearse the demo in under 5 minutes.

## Reset

Use this section only for unplanned blocker work that interrupts the active phase.

Reset devtasks use the `RDT` prefix and are inserted ahead of the remaining unfinished planned devtasks.

## Notes

- Remove completed tasks from this file.
- Do not add DONE labels, checkboxes, or strikethroughs.
- Record completed work in `retro.md`.
- Use `DT` for planned devtasks in the active cycle.
- Use `RDT` for reset devtasks that interrupt the current cycle.
- Create one git commit per completed `DT` or `RDT` when the repo uses git.
- If the repo has a GitHub remote, push the branch and update or create the related pull request after each completed `DT` or `RDT`.
