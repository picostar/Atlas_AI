<!-- PLACEHOLDER: Replace the example content below with your project's actual dev tasks. -->

# Dev Cycle

Active tasks only. This is a burn-down list, not a history log.

## Current Phase

Name: TBD
Goal: TBD

## Active Tasks

### DT1 -- Example Devtask | eMOE: 2 CU | Suggested Model: Claude Sonnet 5 (optional)
- Goal: Replace this with the real task goal.
- API Result: If feasible, describe API endpoints or contract changes. If not feasible, say No API change.
- Smoketest: Exact CLI command or script path, plus the expected pass result. When API Result is in scope, include endpoint verification and OpenAPI or Swagger documentation verification.
- UAT: Either state what the user should test, or say `Not UAT-eligible` and name the required internal validation.

## Reset

Use this section only for unplanned blocker work that interrupts the active phase.

Reset devtasks use the `RDT` prefix and are inserted ahead of the remaining unfinished planned devtasks.

### RDT1 -- Example Reset Devtask | eMOE: 1 CU | Suggested Model: Claude Haiku 4.5 (optional)
- Goal: Replace or remove.
- API Result: If feasible, describe API endpoints or contract changes. If not feasible, say No API change.
- Smoketest: Exact CLI command or script path, plus the expected pass result. When API Result is in scope, include endpoint verification and OpenAPI or Swagger documentation verification.
- UAT: Either state what the user should test, or say `Not UAT-eligible` and name the required internal validation.

## Notes

- Remove completed tasks from this file.
- Do not add DONE labels, checkboxes, or strikethroughs.
- Record completed work in `retro.md`.
- Use `DT` for planned devtasks in the active cycle.
- Use `RDT` for reset devtasks that interrupt the current cycle.
- Create one git commit per completed `DT` or `RDT` when the repo uses git.
- If the repo has a GitHub remote, push the branch and update or create the related pull request after each completed `DT` or `RDT`.
- Heading format: `### TASK_ID -- Task Name | eMOE: X CU | Suggested Model: TIER (optional)`. Place eMOE and Suggested Model in the heading so they are visible at a glance without reading the task body.
- Suggested Model is optional and advisory. Populate it from eMOE using the model-tier-advisor skill when the active agent is a Claude, Codex/ChatGPT, or Copilot model; leave it out otherwise.