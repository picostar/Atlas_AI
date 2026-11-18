# One-question-at-a-time installation

Issue 49, DC03 RDT1, addresses an installation conversation that offered recommended settings, then listed eight questions together. The earlier instructions required answers but did not require waiting between questions. The shared instructions, README entry path, standalone prompt, and setup routers now require one unanswered setup question per assistant turn and a wait for the reply. These are agent instructions, not a runtime enforcement mechanism. Other agents and clients need observed acceptance before claiming their behavior passes.

## Acceptance procedure

Prerequisites: a connected coding agent with GitHub read access, Python, Git, and a fresh disposable project. Record the client and runtime versions and the exact GitHub source commit. Fetch the candidate branch under review from GitHub for pre-merge testing; after merge, test `main`. Do not substitute a local kit checkout. Do not run this procedure in the kit or planning workspace.

1. Create a distinct case under `D:/doit/Atlas/atlas_test/`, checking that it does not already exist. Put a small runnable application and its smoke command under `scripts/`, initialize Git, and commit the baseline. Record file hashes and run its smoke command before setup. Use a fresh agent conversation for each independent case below.
2. Request `install atlas from github picostar/Atlas_AI` and name the candidate branch or exact commit when testing before merge. Expected: after source reads and target inventory, the only setup question is "Include the Atlas docs scaffold? Yes or no (default yes)." The agent waits without changing target files or presenting a settings bundle.
3. Reply `yes`. With Git already present, expected: the next single question asks about PS. Reply `no`; the next asks about CGR. Reply `no`; the next asks whether to select a stack pattern. Verify that each response asks only one question and stops for the reply.
4. Reply `yes` to stack selection. Expected: one selection question containing the manifest's stack menu. Choose a catalog ID. Expected: API-first is asked separately. Answer it. Expected: the next question asks whether to select a UX pattern. Reply `yes`, choose from its separate menu, then answer GitHub creation `no`, mode `standard`, and regression `pre-merge`, each in its own turn.
5. Expected: after the final answer, the agent summarizes captured choices and the file placement and relocation plan and asks one confirmation question. Until confirmation, compare the project hashes and Git status with the baseline. No target files should have changed. Do not approve a plan that unexpectedly moves application files.
6. Approve the reviewed plan to test the full installation. Expected: all selected files and answers are installed, existing project files are preserved, every required check in `atlas_validate.md` passes, and the application's smoke command still passes. Retain output and before/after file inventories. A questionnaire-only test must stop before this step and cannot claim an installation pass.

## Additional cases

| Case | Input or preparation | Expected behavior |
|---|---|---|
| No Git | Start a separate runnable project without `.git`; answer scaffold | Git initialization is the next single question. |
| Explicit answers | Initial request includes `scaffold yes, PS no, CGR no` with an existing Git repo | The first question is stack selection. The supplied answers are retained. |
| Several voluntary answers | Supply several remaining choices in one user reply | Those explicit answers are retained; only the next unanswered applicable question is asked. |
| Explicit defaults | Answer scaffold `no`, then say `use defaults` | Scaffold stays false. Manifest defaults fill unanswered choices, then one placement-plan confirmation is asked. |
| PoC | Choose `poc` at the mode question | No regression question is asked. Stored regression is `pre-merge`, effective schedule is `on-demand`; plan confirmation follows. |
| No patterns | Decline stack and UX | No catalog selection or API-first question is asked. |
| Ambiguous reply | Reply `maybe` to a yes/no question | Only that same choice is clarified; the agent does not advance. |
| Interrupted setup | In a disposable copy, use a genuine interrupted receipt with some choices missing | Known explicit answers are retained; missing choices are asked one at a time. No batch recovery questionnaire is presented. |

## Evidence and limits

Keep the full conversation, source commit, commands, exit codes, file inventories, and smoke output with each case. Record the tester and mark acceptance pending until someone executes these steps. Static instruction checks and application smoke do not establish interactive compliance, a full installation pass, or independent human acceptance. No claim covers every agent or unavailable runtime.

The manifest's question keys, defaults, groups, receipt schema, and root cleanup rules are unchanged. Update, validation, session, cleanup, closeout, realignment, ATLAS.md, template records, and stack/UX templates are unaffected by this conversation pacing change. Existing projects obtain the new instructions through the reviewed `atlas update` workflow.
