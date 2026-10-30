# Tool capability matrix

Choose the client, agent runtime, execution target, and policy before choosing a loading route. Model selection does not select instruction discovery. Check actual tool access and, when docs/testing is present in the source kit, record observations using [the parity fixture](../docs/testing/agent-parity.md).

## Loading routes

The source of shared Atlas procedures remains .github/skills/<name>/SKILL.md. This change adds no duplicate native copies, adapters, or plugin package.

| Environment | Instruction entry | Skill route | Evidence state |
|---|---|---|---|
| VS Code Local Copilot | Supported workspace instructions, including .github/copilot-instructions.md | .github/skills; Local prompt files where supported | Documented route; fresh-session behavior untested in this baseline |
| VS Code Copilot Agent Host | Instructions supported by the selected runtime and policy | Native Copilot skill locations; use skills for reusable workflows | Documented route; untested here |
| VS Code experimental Codex integration | AGENTS.md plus explicit reads required by Atlas | Integration can discover workspace .github/skills; native .agents/skills also exists | Documented exception; not proven by the installed CLI version |
| Standalone Codex CLI | AGENTS.md, subject to precedence and discovery configuration | Native .agents/skills; explicitly read Atlas's .github/skills when not discovered | Six bounded CLI checks passed at 0.164.0-alpha.11.1; .github test skill absent from startup catalog |
| Claude Code CLI | CLAUDE.md plus explicit reads required by Atlas | Native .claude/skills; explicitly read shared Atlas skills not discovered there | Six bounded CLI checks passed at 2.1.295; .github test skill absent from startup catalog |
| Claude Code VS Code integration | Runtime-specific editor loading | Test native discovery and explicit-read fallback in the selected editor configuration | Untested here; CLI results do not establish editor behavior |
| GitHub Copilot CLI | .github/copilot-instructions.md; root AGENTS.md and CLAUDE.md also observed | .github/skills observed; all three test locations appeared in the startup catalog | Six bounded CLI checks passed at 1.0.105, including .github skill invocation |
| Connected Codex/ChatGPT tool session | Environment-dependent; this trial explicitly read the source instructions and ATLAS.md | Explicit shared-skill reads in the current session | File read/write, CLI, Git, and actual-project smoke observed; no automatic discovery claim |
| Chat-only or other hosted model | User-provided context or explicitly available file tools | Paste or read the named procedure when supported | No filesystem, terminal, or GitHub access guarantee |

Routes above distinguish documented mechanisms from bounded CLI observations, not a full cross-runtime parity pass. See [the versioned CLI results](../docs/testing/native-cli-results-2026-10-30.md) for cases and limits. Official sources checked during this review: [VS Code skills](https://code.visualstudio.com/docs/agent-customization/agent-skills), [VS Code customizations](https://code.visualstudio.com/docs/agent-customization/overview), [Codex skills](https://learn.chatgpt.com/docs/build-skills), [Codex instructions](https://learn.chatgpt.com/docs/agent-configuration/agents-md), [Claude skills](https://code.claude.com/docs/en/skills), and [Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/overview).

VS Code documents an experimental Codex reuse route for .github/skills. Test the selected configuration before adding copies. Managed policy, disabled features, or unsupported targets can make a documented route unavailable.

## Capabilities to check

| Capability | Required observation or fallback |
|---|---|
| Read/write project files | Identify the authorized target and use a disposable file or the actual task; without write access, report analysis-only |
| Run project commands | Check the project runtime and execute the documented smoketest; a terminal tool's presence alone is insufficient |
| Git | Confirm repository, branch, working changes, and permissions before committing |
| GitHub follow-up | Use an available authenticated connector or CLI; gh is not mandatory when a connector can perform the action |
| Cloud or remote execution | Check files and tool access on the execution machine; local versions, credentials, and ignored files do not automatically follow |
| Skills and instructions | Separate discovery, explicit invocation, and correct behavior; record the source revision |
| Permissions | Record the active policy; worktree isolation is not a permission boundary |
| UAT | Record user steps and actual feedback separately from agent-driven checks |

## Distribution decision for this baseline

Retain an authoritative shared procedure per skill and preserve existing paths. Explicit shared-skill reads worked in the connected trial and the standalone Codex/Claude CLI checks. Copilot CLI invoked a .github test skill. Native canaries verify discovery mechanics; they do not mean Atlas ships native copies or prove a full task-delivery workflow on each runtime. Editor routes remain untested. Do not publish a supported configuration merely because its documentation or directory exists.

Developer-level or plugin distribution requires its own tested version/update process and duplicate-name handling. Do not assume symbolic links work on Windows, remote hosts, or cloud packaging. Prefer a clear unsupported/untested result to competing authoritative copies.

When docs/testing is present in the source kit, see [the baseline record](../docs/testing/baseline-2026-10-30.md) for installed versions, observed commands, and pending cases. Test docs are not installed by the current manifest. Revalidate after changes to client/runtime versions, loading routes, or policy.
