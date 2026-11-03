# Chat progress reporting trial

Issue 34 asks that a person who is not a software developer can follow a dev task in chat without asking repeatedly. The `Chat Progress Reporting` section of `.github/copilot-instructions.md` defines the messages. This page records what they did on 2026-11-02 and how to test them. These results are agent trials. They are not user acceptance, and the cause of the original user report has not been established.

## Results

Each run used a disposable Taskboard copy and the same one-point task, on Windows 11. The first draft of the instructions barely changed behavior, so the rule was rewritten as required messages and moved above the read order.

| Run | Runtime and model | Messages | Named the cycle and task first | Result |
|---|---|---|---|---|
| Before the change | Copilot CLI 1.0.105, claude-sonnet-5.5 | 2 | No | Baseline. |
| First draft | Same | 3 | No | No real improvement. |
| Current, `normal` | Same | 3 | Yes | Start and final messages appeared. No message when implementing ended. |
| Current, `brief` | Same | 4 | Yes | The progress messages were short, but the final message was as long as the `normal` one. |
| Current, `detailed` | Same | 2 | No | The final message had more detail. No start message. |
| Current, failed check | Same | 3 | Yes | Reported the failing check before continuing and repeated it at the end. It also fixed the planted test without being asked. |
| Current, `normal` | Claude Code 2.1.295, claude-sonnet-5-5 | 3 | No | Reported phases and an accurate final message. It removed the task from `devcycle.md` while UAT was pending, against the process. |
| Current, `normal` | Codex CLI 0.166.0-alpha.5.1 | 6 | No, in its second message | The clearest phase-by-phase reporting. |
| Current, `normal` | VS Code 1.144.0 Agent Host, claude-fable-5 | 9 | No | Used the phase format, handed off UAT, and said it was waiting. Its commit matched its report. Its `status.md` said no active tasks while the task was still open, and some messages narrated small steps. |

## What this shows

Reporting improved but is not consistent. No runtime sent every required message. Model and runtime differences are confounded, because each runtime ran once. Each case ran once, so these counts are not rates.

## Not tested

- VS Code Copilot Local in the agent trials. The owner's acceptance run below covers it without a retained transcript.
- A failed check or blocked read in Agent Host.

## Reproducing

Trial scripts and raw results are in the Atlas test root at `progress-34/`. Run a case from that directory with `python run_trials.py <case>`. A case's `chat.md` holds what the runtime showed.

## User acceptance

Use a disposable Taskboard copy that has these instructions and an active task. In VS Code, open that folder and start Copilot Chat in the mode under test. Send:

~~~text
Work the next active task in docs/agile/devcycle.md through this project's process, up to the UAT handoff. This project has no GitHub remote. Do not push. You may not perform the UAT yourself. Run every Git command as git -c safe.directory=<this folder> followed by its subcommand. Never run git config and never change anything global.
~~~

Without asking any follow-up question, check whether you can tell:

1. Which cycle and task is active.
2. What has really been done.
3. What is happening now.
4. What is left.
5. Whether any check failed.
6. What happens next, and what it needs from you.

Record the tester, date, client, mode, model, kit revision, and each answer, using the record in [the UAT guide](uat.md).

## User acceptance result

Tester: picostar, the project owner, in two human runs on 2026-11-02. Kit revision: da195a7 plus the issue 34 instruction diff, applied to each fixture. Result: passed for the two tested clients.

1. Case `progress-34/v2-agent-host` in the Atlas test root, VS Code 1.144.0 Copilot Chat in the shared agent host, claude-fable-5. The owner sent the launch prompt, followed the run to the UAT handoff, executed the documented acceptance commands with the expected counts and a PASS smoke exit, and accepted the reporting. Evidence: the case's `chat.md`, `record.json`, `archive/uat-*.json`, and its commits d342c59 and 72a1378.
2. Prepared case `progress-34/uat-owner` in VS Code Copilot Local. The owner reports this run passed. The case folder retains no transcript, so this run is owner-attested only.

A non-developer's judgment beyond the owner, and the other clients' acceptance, remain untested.
