# Agent parity fixture

## Scope

Use a runnable project outside the source kit. Keep its baseline, task changes, exact commands, and observed output. Follow [the project recipe](taskboard-project.md), [the UAT procedure](uat.md), and the [baseline record](baseline-2026-10-30.md). A file listing or workspace-readiness check is not a behavior pass.

Record these states separately: documented expectation, discovered customization, explicitly invoked procedure, observed behavior, and user acceptance. An installed CLI version does not prove that CLI executed a task.

## Identify each run

Record the kit commit and any dirty patch, application/client version, agent runtime and version, operating system, local/cloud/worktree target, delivery mode, permission policy, application revision, exact project root, and evidence location. Use unavailable or untested when identity or behavior cannot be observed.

A manual read of external kit files is an explicit-read trial. It is not the proposed atlas session feature and does not validate an installation. See [tooling assumptions](../../.github/TOOLING-ASSUMPTIONS.md).

## Cases

| Case | Actions and pass signal |
|---|---|
| Application baseline | Run the project's documented smoke command before Atlas work. Preserve the source and output. |
| Installed bootstrap | Read the source README, manifest, and atlas_newproject.md. Collect explicit questionnaire answers. Install only into a disposable project, run every atlas_validate.md check, and retain its receipt. Do not infer answers or treat a missing receipt as a pass. |
| Discovery | Start a fresh session in each target runtime. Inspect its customization diagnostics and identify the loaded paths. Keep this separate from explicit file reads. |
| Explicit invocation | Name the appropriate Atlas procedure or skill. Confirm the agent read the intended revision and followed its task, validation, and record rules. |
| Representative DT | Change observable application behavior, run a CLI/script smoketest, provide UAT steps, and preserve project records. Keep actual user acceptance pending until reported. |
| Nested directory and worktree | Repeat the relevant loading case from a child directory and a linked worktree. Record which root's instructions and skills are used. |
| Recovery | Resume or compact the session. Confirm task identity, source revision, pending checks, and authorization boundaries before continuing. |
| Unavailable source/tool | Make the required input unavailable in a disposable case. Pass requires an explicit blocker and no successful-adoption claim. |
| Portable planning | Exercise a Markdown-only task and, when implemented, an optional issue-linked task. Preserve devcycle.md and backlog.md without GitHub access. |

Do not claim future lifecycle features have passed before implementation. Use the capability matrix to select documented routes, then record the specific runtime's actual result. Do not add duplicate skill directories solely to make a selector list them.

## Results and closeout

Use one record per runtime and case:

~~~text
Case:
Kit revision and dirty patch:
Project baseline/revision:
Client and agent runtime:
Operating system and target:
Loading route:
Commands or exact interaction:
Expected:
Observed:
Exit code:
Evidence:
State: PASS | FAIL | BLOCKED | UNTESTED
User acceptance: pending | passed | failed | not eligible with reason
~~~

A command failure is FAIL, a prerequisite that prevents execution is BLOCKED, and an unattempted case is UNTESTED. Record the application's smoke result separately from Atlas discovery/adoption and UAT.

Review README.md, process and pointer files, lifecycle procedures, manifest/receipt contracts, skills/prompts, reference docs, templates, and testing guidance for each changed workflow. Update affected documents and record the unaffected rationale. Do not place kit-maintenance task state into the kit's placeholder docs/agile templates.

## Baseline status

The linked baseline records a successful application trial using explicit reads in a connected tool session, followed by an installed-project trial with all required validation checks passed and pre-existing files preserved. Fresh Codex/Claude/Copilot discovery, recovery, and user UAT remain untested or pending. Keep the parity issue open until the claimed supported configurations have their required evidence.
