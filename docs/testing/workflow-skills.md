# Workflow skills verification

DT10 packages the five existing workflow procedures as skills with stable names. Manifest version 2 installs the two core skills and, when CGR is selected, the three governance skills. It omits legacy prompt files on fresh installs. The source kit retains thin legacy routers. This changes discovery and packaging; it does not grant push, merge, deployment, or account permissions.

## Runtime evidence

The earlier DT9 observations used VS Code 1.145.0 with Copilot Agent Host 1.0.103-unstable.r41379698026 on Windows. Instructions and skills loaded. Prompt files were not discovered, but explicit file reads worked. A reproduction of the bundled migration renamed the commands, set explicit-only invocation, deleted the source prompts, and caused installed validation failures. That reproduction was not a click on the real migration button.

Current official guidance describes [skills](https://code.visualstudio.com/docs/agent-customization/agent-skills) and [migration](https://code.visualstudio.com/docs/agent-customization/migrate-customizations). Reviewed 2026-11-09. These documents explain the packaging choice; they do not establish that this kit revision passed a VS Code trial.

DT10 ran on 2026-11-09 with Microsoft Windows 11 Pro build 26300, Copilot CLI 1.0.106 using its configured Claude Sonnet 5.5 model, Python 3.13.7, and Git 2.47.1.windows.1. The tested source checkout was `21f5e8517acaa9060912a2bcb29e12d73cdbbdd6`. Its tracked file contents were copied byte for byte into an isolated source snapshot; the snapshot's Git identity and source hashes are retained separately. Later delivery edits affect documentation and links only.

| Check | Observed result | Retained evidence |
|---|---|---|
| Fresh standard install, CGR selected | Fourteen required checks passed; all five workflow skills present; no legacy prompt files; application smoke passed; application files unchanged | `case-02/runs/standard/install/` and `standard/commit-install/`; `logs/dt10/artifact-checks.json` |
| Fresh PoC install, CGR off | Fourteen required checks passed; only the two core workflow skills added; effective regression schedule on-demand; application smoke passed; installation committed | `case-02/runs/poc/install/`; `logs/dt10/artifact-checks.json` |
| Complete legacy prompts with old manifest | New validator reported fourteen passes and five W5 workflow warnings, with no edits | `case-02/runs/update/validate/` |
| Approved customized legacy update | Plan made no edits; rollback tag created; five skills added; custom closeout rule preserved in both the old prompt and new skill; source and project records unchanged; commit created; separate full validation reported fourteen passes; application smoke passed | `case-02/runs/update/plan/`, `approve-retry/`, and `validate-after/`; `logs/dt10/artifact-checks.json` |
| Broken router without destination | Validator reported check 6 failed, thirteen passes and one failure; application smoke still passed | `case-02/runs/router-only/validate/` |
| Mechanical compatibility variants | Complete legacy prompts and old-manifest/canonical-skill copies accepted; absent core, absent selected CGR, broken router, and invalid skill name rejected | `case-02/compatibility-results.json` |
| Closeout and realignment | Explicit reads of both canonical skills produced their review formats without edits; Git inspection was permission-limited, so this is bounded workflow invocation evidence | `case-02/runs/standard/review/` |
| CGR bootstrap and review | Explicit read of the canonical CGR skill produced Taskboard-named MRD, PRD and ESD drafts, mapping, traceability and review using supplied application context; application files unchanged and final smoke passed | `case-02/runs/standard/cgr/` |

All `case-02/` paths above are under `D:/doit/Atlas/atlas_test/workflow-skills-dt10/`. The planning workspace retains the command harness and consolidated output in `logs/dt10/trials.py`, `results.json`, `artifact-checks.json`, `mechanical-results.json`, and `first-attempt.md`; DT9 evidence remains in `logs/dt9/part-a.json` and `part-b.json`.

The original standard install needed a separate commit-completion run after staging was denied. The first update attempt was blocked before file edits, and the successful retry reported only partial validation, so the separate full validation is the evidence for fourteen passes. The update preserved the historical stored installation receipt; its current validation receipt is in the session output. The negative router run completed with the expected failure receipt, but harness post-processing failed on an unborn Git HEAD. Its process exit code and duration were not retained and remain unknown. Those harness faults are recorded, not counted as product passes.

CGR retained templates at the test prompt's explicit request and did no external research. This verifies packaging and file routing, not governance quality or stage acceptance. Native VS Code slash-menu invocation, the migration button, and the owner's subjective PoC speed judgment remain untested or pending. The two other new CGR entry points received frontmatter and reference checks, not runtime execution. No independent human acceptance or remote CI pass is claimed.

## Fresh-project acceptance

Use a new project folder outside the source kit and planning workspace. Keep project source material in `seed.md` or `docs/reference/`. Open that folder in VS Code and start a new Copilot session.

1. Ask: `Use github picostar/Atlas_AI as the source kit. Read README.md and atlas_newproject.md, then run newproject in this folder. Do not clone the kit into my project.` If testing a review branch, explicitly name its local checkout and commit instead of the default branch.
2. Answer setup questions. Choose `standard` for the full process or `poc` for a quick prototype. Choose CGR only if governance is needed. Expected: the agent installs in the project root, preserves existing allowed folders, and reports a passing validation receipt.
3. Check that `.github/skills/atlas-closeout/SKILL.md` and `.github/skills/atlas-realign/SKILL.md` exist. The five Atlas legacy `.prompt.md` files should be absent. When CGR is off, its three skill folders should also be absent.
4. In a fresh session, type `/atlas-closeout` and inspect its availability and output. Then type `/atlas-realign`. Expected: the original command names work, the mode line matches the setup answer, and scaffold placeholders alone do not fail the review. If native menu discovery is unavailable, explicitly request the named skill file and record that fallback separately.
5. When CGR is selected, type `CGR`. Expected: the agent reads the governance skill and uses the actual project's source material. Review the draft names and facts. Do not accept claims about the Atlas kit as facts about your application.
6. Run one small feature task and its documented smoke command. For PoC mode, judge whether the workflow feels fast enough. Then request `atlas mode standard` and inspect the list of PoC tasks needing standard smoke checks before release.

Record the tested source commit, VS Code and runtime versions, selected mode, observed command discovery, validation result, and your speed judgment. A successful CLI test does not establish VS Code menu invocation or your subjective acceptance.

## Existing-project acceptance

Ask `atlas update` using the reviewed kit revision. Inspect the plan before approving it. The plan should include the stable skills, matching manifest and validator, preservation of customized instructions, and a rollback branch or tag. Prompt removal and retirement of automatically renamed skill copies require explicit approval. After execution, run `atlas validate`, the application's smoke command, and the closeout workflow. Confirm that project code, records, and customized instructions survived.

Keep older projects unmigrated until the approved update reconciles their workflow files. Do not apply VS Code Migrate to the source kit's compatibility routers. Their bodies route to the authoritative skills.
