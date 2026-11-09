# Documentation impact review

## Changed material

| Category | Result |
|---|---|
| README.md | Add test entry points and supported-environment guidance |
| docs/testing/agent-parity.md | Define cases, evidence states, source identity, and actual-project gate |
| docs/testing/taskboard-project.md | Provide reproducible application and black-box test source as Markdown examples |
| docs/testing/uat.md | Provide exact application commands and Atlas workflow acceptance steps |
| docs/testing/baseline-2026-10-30.md | Record observed baseline, versions, results, and limitations |
| docs/testing/native-cli-results-2026-10-30.md | Record eighteen bounded CLI observations, policies, provenance, commands, and remaining cases |
| .github/TOOL-CAPABILITY-MATRIX.md | Distinguish client/runtime routes and documentation from observations |
| .github/TOOLING-ASSUMPTIONS.md | Clarify explicit reads, per-environment access, and project test prerequisites |
| .github/copilot-instructions.md | Qualify the Codex discovery statement while retaining mandatory reads when discovery is absent |
| CHANGELOG.md | Add this PR's reviewable scope and qualitative usage metadata |

## Unaffected material and reasons

| Category | Reason |
|---|---|
| ATLAS.md | No reusable task lifecycle, CU, Smoketest, UAT, or completion policy change is implemented |
| Root agent pointers | Existing pointers still route to the same authoritative files; no new discovery promise is added |
| Manifest and setup receipt contract | No installation group, required path, questionnaire, or receipt schema changes |
| Setup, update, validate, and governance procedures | Their behavior and invocations remain unchanged; future lifecycle entry-point work has separate scope |
| Existing skills and prompt procedures | Shared procedure ownership and paths remain unchanged; this work adds test/documentation guidance |
| docs/agile templates | They remain reusable scaffold; live maintenance records stay in the external planner |
| Stack, UX, and governance templates | No selected baseline or pattern behavior changes |
| Existing update runbooks | No update algorithm, layout migration, or retired-file rule changes |
| Secrets and account guidance | No credentials, destination binding, or secret-storage behavior changes |

Review the current diff before accepting this table. New behavior or newly affected paths require an updated entry and matching smoke/UAT evidence.

## DC02 editor evidence review

README, the capability matrix, tooling assumptions, parity status and UAT guidance now point to editor-results-2026-10-30.md. The result separates the direct Codex extension from the untested experimental Copilot Chat harness and retains the nested Local permission blocker. The external planner retains native events, policy observations and actual-project smoke receipts. No product behavior, process, manifest, production skill, pointer, lifecycle procedure or agile template changed. Existing unaffected-category reasons above still apply. CHANGELOG identifies DC02 PR 33.

## DC02 Local distribution evidence review

README, this review, UAT, editor-results, capability matrix and tooling assumptions link the new skill-collision-results-2026-10-30.md. CHANGELOG records PR 33 and task CU. The actual Taskboard smoke passed before/after; all baseline hashes were preserved and the personal test directory was safely removed. Native attachments and the distinct fallback read support delegated acceptance. Existing process, pointers, production skills/prompts, lifecycle procedures, manifests/receipts, agile/governance/stack/UX templates and secrets guidance were reviewed and remain unaffected for the reasons above. No installer, package, production distribution rule or runtime policy changed.

## Issue 34 chat progress review

Updated: .github/copilot-instructions.md, the devcycle-management skill, README, and the new progress-reporting.md. ATLAS.md is unaffected because task lifecycle and records do not change, only what agents say in chat. Agent pointers still route to the same instructions. The manifest, setup, update, and validation procedures are unaffected because no installed path changes. The capability matrix update remains follow-up work, because the owner's acceptance covers two clients and the agent results are single runs. CHANGELOG waits for a PR number.

## Regression suite schedule review

Updated: ATLAS.md gains Regression Suite Rules, with the terms, the `regressionSuite` values, the commands, and the mode line, and its smoketest, lifecycle, Definition of Done, and cycle-close text now point there. `.github/copilot-instructions.md` adds the mode line to progress and startup messages, the commands, the setup question, and update handling. The manifest adds the `regressionSuite` questionnaire key with `values`, a default, and `missingMeans`. `atlas_newproject.md` asks the question and sets the status mode line. `atlas_validate.md` checks listed values, treats an absent `missingMeans` key as warning W4, and adds the mode line to the receipt. `atlas_update.md` proposes the missing key and the mode line for approval. The devcycle-management and project-setup skills, the `docs/agile/status.md` template, `docs/agile/testing/README.md`, and README follow. Agent pointers are unaffected because they still route to the same files. Install groups, required paths, and the root allowlist are unchanged. The manifest version stays 1, because the new key is additive and receipts without it remain valid. CHANGELOG waits for a PR number.

The trials at e3d1d58 led to a follow-up in 194c9ae. Agents read `.atlas/setup.json` before the start message so it can carry the mode line, short notes between tool calls do not need it, and the placeholder `docs/agile/testing/README.md` stays unchanged until the user asks for a harness. The same files changed: ATLAS.md, `.github/copilot-instructions.md`, and the testing README.

## PoC mode review

Updated: ATLAS.md gains PoC Mode Rules, with the `projectMode` values, the table of what PoC mode loosens, what it leaves unchanged, the shorter Definition of Done, and the `atlas mode poc` and `atlas mode standard` commands; the mode line now carries the project mode, and the Definition of Done points to the PoC form. The manifest adds the `projectMode` questionnaire key, before `regressionSuite`, with `values`, a `standard` default, and `missingMeans`. `atlas_newproject.md` asks the question, skips the schedule question for `poc`, and writes the mode line from both answers. `atlas_update.md` proposes a missing `projectMode` with the missing schedule. `atlas_validate.md` puts the project mode in the receipt; checks 2 and W4 already cover the new key. `.github/copilot-instructions.md` reads both values for the mode line, captures the setup answer, routes the commands, and points the task rules to the PoC forms. The devcycle-management and project-setup skills and README follow. The `docs/agile/` templates are unchanged, because the PoC task and retro forms are short enough to state in ATLAS.md. Agent pointers are unaffected. Install groups, required paths, and the root allowlist are unchanged, and the manifest version stays 1. CHANGELOG waits for a PR number.

## DT10 workflow skill packaging, 2026-11-09

Reviewed: README and CHANGELOG, shared instructions and all agent pointers, lifecycle procedures, manifest and receipt contract, skill and prompt catalogs, capability and tooling guidance, and templates. The five skills now own the existing workflow procedures, with corrected relative links and stable names. Legacy prompts route to them in the source kit. Manifest version 2 installs canonical skills without prompt files and retains schema version 1. CGR stays optional. Validator compatibility accepts complete older prompts, checks router destinations, and supports the five pairs with older manifests. Setup copies canonical assets. Update migration stays plan-first and preserves custom content with rollback. README, frontmatter guidance, maintenance instructions, and workflow verification describe these changes. The core ATLAS lifecycle, PoC/regression rules, model advisor, application templates, patterns, governance evaluation rules, and secret/account handling are unaffected by DT10. DT7 and DT8 changes remain part of this delivery bundle, as documented above. The test fixture and actual execution evidence live in the planner and atlas_test, outside the reusable kit. Runtime results and CHANGELOG PR linkage are completed after verification and PR preparation; no pending test is reported as passed.
