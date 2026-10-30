# Tooling assumptions

## Core access

Atlas procedures are agent-executed Markdown. The kit requires no particular shell and ships no required executable validator. Read the source manifest before installation and apply atlas_validate.md with file tools for its required receipt.

Full task delivery needs authorized file access and the project's own CLI/runtime or pipeline for the current smoketest rules. Git operations require Git or an available equivalent integration. If a prerequisite is absent, identify the blocked action rather than claim completion.

## Per-environment setup

Select the client, agent runtime, target, and policy using [the capability matrix](TOOL-CAPABILITY-MATRIX.md). Record versions on the machine executing the work. A local command version does not identify the agent service running the conversation.

When automatic loading is absent or unverified, explicitly read the relevant pointer, .github/copilot-instructions.md, ATLAS.md, and the skill named by the task. Resolve those paths against the actual installed project or identified source kit. Do not infer that loading a model loads Atlas.

Codex has native .agents/skills discovery, while the experimental VS Code integration documents additional workspace .github/skills discovery. Claude Code uses native .claude/skills. Keep existing shared procedures authoritative and test the selected route before adding adapters or copies. [Official route references and observations](TOOL-CAPABILITY-MATRIX.md)

## Optional capabilities

- An authenticated GitHub connector or gh can provide remote follow-up. Detect the available route; gh installation alone does not establish authentication.
- Provider CLIs are needed only for tasks that use those providers. Read accounts.md before destination-sensitive work.
- Editor diagnostics can show discovered customizations, but a listed skill still needs an invocation/behavior check.
- Preview features, connectors, automatic model routing, and cloud targets depend on availability and organization policy. They are not prerequisites for the core portable workflow.
- Chat-first environments without file or command tools can review supplied material but cannot claim local task or test execution.

## Real-project validation

When docs/testing is present in the source kit, use [the parity fixture](../docs/testing/agent-parity.md) with an actual runnable project outside the source kit. The [Taskboard recipe](../docs/testing/taskboard-project.md), when present, is a Python standard-library example, not a mandatory Atlas dependency. Its scripts are created in the test project rather than installed from the kit manifest. These test documents are not installed by the current manifest.

Keep Markdown active tasks, backlog, and history usable without GitHub. Record the kit revision, exact commands, expected result, actual output, and UAT handoff. The source-kit [baseline record](../docs/testing/baseline-2026-10-30.md), when present, reports application smoke, installed-project validation, and Taskboard UAT explicitly delegated by the user to Codex. It does not establish fresh-session discovery or independent human observation.

The installed-project validator remains a separate gate. Do not replace it with a passing application command, and do not apply its manifest completeness test to a manual explicit-read trial. The proposed session lifecycle is separate future work.

## Failure and recovery

Report missing tools, unavailable sources, permission denials, and untested configurations explicitly. Do not change authorization policy to turn a failed test into a pass. Retain evidence and resume only after the target, task, source revision, and pending checks are identified.
