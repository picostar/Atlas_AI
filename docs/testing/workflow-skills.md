# Workflow skills verification

DT10 packages the five existing workflow procedures as skills with stable names. Manifest version 2 installs the two core skills and, when CGR is selected, the three governance skills. It omits legacy prompt files on fresh installs. The source kit retains thin legacy routers. This changes discovery and packaging; it does not grant push, merge, deployment, or account permissions.

## Runtime evidence

The earlier DT9 observations used VS Code 1.145.0 with Copilot Agent Host 1.0.103-unstable.r41379698026 on Windows. Instructions and skills loaded. Prompt files were not discovered, but explicit file reads worked. A reproduction of the bundled migration renamed the commands, set explicit-only invocation, deleted the source prompts, and caused installed validation failures. That reproduction was not a click on the real migration button.

Current official guidance describes [skills](https://code.visualstudio.com/docs/agent-customization/agent-skills) and [migration](https://code.visualstudio.com/docs/agent-customization/migrate-customizations). Reviewed 2026-11-09. These documents explain the packaging choice; they do not establish that this kit revision passed a VS Code trial.

DT10 execution results are pending. The planning workspace retains the DT9 evidence at `logs/dt9/part-a.json` and `logs/dt9/part-b.json`. DT10 records exact source revision, commands, runtime versions, application smoke output, and preservation checks under `logs/dt10/` and `D:/doit/Atlas/atlas_test/workflow-skills-dt10/`. No independent human acceptance or remote CI pass is claimed.

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
