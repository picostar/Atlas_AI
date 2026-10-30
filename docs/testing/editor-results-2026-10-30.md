# Bounded editor loading results: 2026-10-30

## Scope and provenance

The observed clients were VS Code Local Copilot, Copilot Agent Host, the Claude Code extension, and the separate Codex extension. The Codex extension result does not establish the experimental Codex harness inside Copilot Chat. The checks cover startup instructions, a shared test skill, explicit fallback, selected nested starts, and an absent mandatory file. They do not establish full application delivery in every runtime. [A1] [A2]

The runnable application was the installed Taskboard example, application revision 80348ddc5328f973ff9bfaf3b663c068848c5d9c, with installed Atlas source 9c08fda20d22322370dcb5105a08a7edc6c00bd1. Documentation baseline was merged main 484171a7fa2d9fafe3069d0367ff1b3fb204f568. Separate linked worktrees held each root probe; no installation or update ran during these editor checks. The original setup receipt is installation provenance, not a fresh validation of the derived worktrees. [A3]

Each probe had a unique instruction marker and a skill-body marker excluded from its description and discovery prompt. The shared probe existed only at .github/skills/atlas-editor-probe/SKILL.md. No native production skill copies were added. Native tool events, exact prompts and results were retained outside the source kit. Raw markers and account/session material are omitted from this portable summary. [A1] [A2] [A3]

## Client, runtime and policy identity

| Observed route | Identity | Selection and policy |
|---|---|---|
| Local Copilot | VS Code 1.144.0; local transcript producer 0.72.0 | Auto resolved to GPT-6 Luna in the recorded root runs; Default permissions |
| Copilot Agent Host | VS Code 1.144.0; backend 1.0.103-unstable.r40031404408.gba6c003 | claude-fable-5, high effort; Interactive, Manual permissions; recorded reads approved by host_policy |
| Claude Code extension | Extension and native backend 2.1.314 | Opus 5.5, high effort; Auto permission mode |
| Codex extension | Extension inventory 26.1021.22027; native VS Code backend 0.164.0-alpha.11.1 | gpt-6.1-sol, medium effort; approval never, danger-full-access sandbox |

These are observed identities, not model recommendations or requirements. The tester did not change model selectors or authorization policy. A model name does not identify the execution runtime. [A1] [A2]

The local Windows HKLM and HKCU Software/Policies/Microsoft/VSCode keys were absent when inspected. That observation does not establish the absence of remote organization policy. Managed deployments and alternate policy configurations remain untested. Nested Local permission prompts were not approved to obtain a pass. [A4]

## Results

| Case | Local Copilot | Copilot Agent Host | Claude Code extension | Codex extension |
|---|---|---|---|---|
| Root startup instructions | Matching withheld marker; zero serialized tool invocations | Matching withheld marker; no tool execution before invocation | Matching withheld marker; zero tool calls | Matching withheld marker; zero tool calls |
| Shared probe in startup catalog | Present | Present | Absent | Absent |
| Shared skill execution | Native skill read, matching body marker, process/advisor reads | Native user-invoked skill event; matching body marker and retrieved guidance after a reporting follow-up | Explicit path fallback; matching body marker and process/advisor reads | Explicit path fallback; matching body marker and common/process/advisor reads |
| Fresh normal pointer forwarding | Untested separately from probe invocation | Untested separately from probe invocation | Common instructions, process, live planning records and advisor read in a new session | Common instructions before process, then live planning records and advisor in a new session |
| Missing mandatory source | Exact read request and actual nonexistent-file error; adoption stopped | One view call failed with Path does not exist; adoption stopped | One Read failed with File does not exist; adoption stopped | One Get-Content exited 1 with actual missing-path error; adoption stopped |
| Actual nested start | Nested folder retained; ancestor marker and shared skill absent | Untested | Ancestor marker present; shared skill absent | Ancestor marker present; shared skill absent |
| Explicit ancestor fallback from nested folder | BLOCKED at external-file permission request | Untested | Matching ancestor body marker and guidance | Matching ancestor body marker and guidance |

Root results and the Claude/Codex nested results are supported by native source/cwd identities, tool events and observed output. The Local nested discovery has a saved native response; its pending external-read request is retained as UI evidence. A blocked ancestor read is not a permission-denial pass. [A1] [A2] [A4]

Agent Host initially said findings had been reported without providing the requested values. A no-tools follow-up returned them. Whole-file views of the process and advisor hit size limits; subsequent searches retrieved the relevant sections. This records recovery from an initial reporting failure, not a clean first-response result. [A1]

The Codex nested parallel result was truncated. Codex reread ATLAS.md separately; the complete advisor result retained the installed advice row. Fresh Claude and Codex planning checks also encountered ordinary Git ownership failures. Codex recovered with an exact-path command-local override; no persistent trust change or fresh installation-validation pass is claimed. [A1] [A2]

## Application checks and acceptance

The final audit ran the actual project's python scripts/smoke-taskboard.py in every prepared root. All four commands exited zero with the Taskboard PASS signal. Each fixture retained its expected 56 files with no additions, missing files or changed hashes. Application smoke and file preservation remain separate from editor loading and installation validation. [A5]

Codex executed the eligible Copilot/Claude interactions under user-delegated acceptance. The user submitted prompts in the Codex extension; the controller audited its native session logs. The bounded observed behaviors are accepted for these identified builds and policies. No independent human review, broader managed-policy acceptance or full cross-runtime parity is claimed. [A1] [A2]

## Reproduction procedure

Use a disposable runnable project following [the Taskboard recipe](taskboard-project.md). Preserve its source and installed Atlas identities. Keep operator-only expected markers outside the tested workspace and prompt context. A fixture directory alone is not an executed workflow. [A3] [A6]

1. Open the intended project folder and select the runtime explicitly. Selecting a model or naming a folder does not select Local versus Agent Host. Record the client/backend versions and active policy.
2. In a new chat, request the disposable startup marker and skill catalog without tools or file reads. Compare the withheld marker and inspect the native trace for zero tool calls.
3. Invoke the shared probe if discovered. Otherwise explicitly read .github/skills/atlas-editor-probe/SKILL.md and follow it. Confirm actual process/advisor reads, matching body marker, installed advice and unchanged model selection.
4. In a separate new chat, ask for a hypothetical read-only Atlas documentation plan. Distinguish automatically supplied instructions from files read. Do not create a real task or claim planned commands were executed.
5. In another new chat, require docs/reference/unavailable-sources/missing-kit/ATLAS.md, attempt that read and forbid substitutions. Expected negative result: actual missing-file error and blocked adoption.
6. Open scripts/nested in another window and repeat discovery before any explicit ancestor reads. Retain actual editor folder and runtime cwd. Preserve a permission blocker rather than broadening access.
7. Run the application's documented smoke command before and after, compare complete fixture hashes, and record the actual tester and accepted scope. Keep unavailable combinations untested.

These steps describe the executed checks and their expected signals. Human-operated editor steps are required where the controller's automation route excludes that client. They do not require another human run for already delegated acceptance. [A1] [A2] [A6]

## Distribution implications and remaining coverage

Keep shared Atlas procedures authoritative at their existing paths. The tested Copilot routes invoked the shared probe; the tested Claude/Codex extensions needed explicit reads. Starting in a nested folder can expose a different instruction and permission boundary. Do not assume a parent-root result applies to a child workspace, or create competing production copies to repair a catalog absence. [A1] [A2] [A4]

The experimental Codex harness inside Copilot Chat, nested Agent Host behavior, managed organization policies, cloud targets, permission-denial recovery, network outages, compaction and full per-runtime application delivery remain untested here. Parent parity/distribution issues remain open. Duplicate-name and procedure-update observations require the separate DT2 trial; this document makes no precedence rule. [A6]

## Evidence register

The paths below identify retained local receipts under atlas_test/dc02/evidence. They are not installed kit files. A test result for an identified build establishes only the behavior recorded in that result; documented expectations alone do not establish execution. [A3] [A6]

- [A1] desktop-connected-01/REPORT.md, evidence-audit.json, copilot-local-native.json, copilot-host-events.json, and Claude event extracts; observed 2026-10-30; runtime identity, root discovery/invocation, planning, missing-source and delegated-acceptance evidence.
- [A2] codex-direct-01/summary.json and its six native event records; observed 2026-10-30; user-operated Codex root, fresh-session, failure and nested results with source hashes.
- [A3] preflight.json and per-case expected-file snapshots; recorded 2026-10-30; application/Atlas revisions, marker preparation and baseline hashes.
- [A4] closeout-01/local-policy-inventory.json, copilot-nested-native.json, copilot-nested-local-selected.json and copilot-nested-local-fallback.json; observed 2026-10-30; local registry state, confirmed nested Local selection, absent ancestor discovery and unanswered external-read request.
- [A5] codex-direct-01/fixture-audit-final.json and fixture-audit-final.txt; observed 2026-10-30; actual application commands, exit codes, output and complete fixture comparisons.
- [A6] [Agent parity fixture](agent-parity.md), [UAT guide](uat.md), and the external planner's DC02 runbook; checked 2026-10-30; selected task boundaries, reproducible prompts and remaining parity criteria.
