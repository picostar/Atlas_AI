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
