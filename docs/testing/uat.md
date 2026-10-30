# Actual-project user acceptance

Use a dedicated test project created from [the Taskboard recipe](taskboard-project.md). These instructions are a UAT handoff. Routine automated checks do not establish a user's acceptance. If the user explicitly delegates acceptance testing to an agent, name the agent as tester and record the authorization and tested scope. Do not describe that run as an independent human observation.

## Application check

From the test project in PowerShell:

~~~powershell
$uatStore = "archive/uat-" + [guid]::NewGuid().ToString("N") + ".json"
python scripts/taskboard.py --store $uatStore add "Review Atlas"
python scripts/taskboard.py --store $uatStore add "Keep this open"
python scripts/taskboard.py --store $uatStore complete 1
python scripts/taskboard.py --store $uatStore list --open
python scripts/taskboard.py --store $uatStore list
python scripts/smoke-taskboard.py
~~~

The completed task has completed true. The open-only list shows the second task. The full list preserves both tasks, and the smoke command prints PASS with exit zero. A unique store avoids changing previous manual data.

## Atlas workflow check

1. Read the kit README and select the intended workflow. Choose installed bootstrap only after answering its questionnaire; choose explicit reads for a manual process trial.
2. In the chosen runtime, provide the source revision and target project path. Confirm which instructions and skills it actually reads. Do not confuse a listed skill with an invoked one.
3. Have the agent select a documented DT, state its CU advice without changing the user's model, implement a bounded behavior change, and run its recorded smoketest.
4. Confirm that UAT instructions identify commands, expected output, and project paths. Check that active work, backlog, and retrospective records remain understandable without GitHub.
5. When installed mode is tested, review the validation receipt and verify preservation of application files. A successful app command without that receipt does not establish installation success.
6. Report the actual outcome. Keep failures open and preserve their evidence.

## Acceptance record

~~~text
Tester:
Date:
Client/runtime:
Kit revision:
Project revision:
Case and exact steps:
Expected:
Observed:
Evidence:
Result: pending | passed | failed
~~~

The baseline's Taskboard acceptance sequence passed when the user explicitly delegated UAT to Codex. All six documented commands exited zero, and all eleven recorded checks passed. The completed task was removed from the sample project's active cycle and retained in its retrospective. See [the baseline record](baseline-2026-10-30.md) for scope and evidence. Unavailable configurations remain untested.

## Loading acceptance checklist

Use a disposable linked worktree of the validated application. Follow the README's capability-matrix selection and explicit-read fallback. Keep application acceptance separate from these read-only checks:

1. In a fresh selected CLI, identify automatic instructions and available skills without reading files. Repeat from scripts/nested. Test-only markers must be withheld from the prompt.
2. Invoke the native test skill, then read the actual shared advisor and ATLAS.md. Check that the reported 3 CU advice matches the installed table and no model switch occurs.
3. Ask for a read-only Atlas documentation plan. Confirm the runtime follows its pointer or already loaded common instructions and reads the process, advisor, and project task/status records.
4. Resume the saved discovery session and request its earlier conversation token, purpose, directory, and restriction without tools. This tests recall only.
5. Require an absent mandatory source and forbid substitutes. Confirm an attempted read and explicit BLOCKED result.
6. Compare the full before/after fixture file set and hashes. Record the actual reads and results, not just the final assertions.

At the user's request, Codex orchestrated these six checks against Codex, Claude, and Copilot CLIs. All eighteen passed with an unchanged fixture. [The native result](native-cli-results-2026-10-30.md) records the observed loading scope. These were agent-executed checks; no independent human observation, editor acceptance, compaction pass, or full per-runtime application-delivery acceptance is claimed.

## Bounded editor acceptance

The [editor results and reproduction procedure](editor-results-2026-10-30.md) record separate prepared projects, actual runtime identities, exact loading routes and negative-source outcomes. Copilot/Claude checks were agent-executed at the user's request; Codex extension prompts were user-operated and native logs were audited by the controller. The accepted scope is bounded to recorded results. No repeat human run is required for that delegated scope; unexecuted policy and runtime combinations remain untested.
