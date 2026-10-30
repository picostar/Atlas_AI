# Native CLI results: 2026-10-30

## Tested scope

Eighteen bounded read-only checks passed in fresh local CLI sessions. These results cover instruction discovery, skill use, planning guidance, a nested working directory, saved-session recall, and an absent mandatory file. They do not establish full task-delivery parity, editor integration, compaction, or network-outage recovery.

The runnable project was the installed Taskboard example described in [the baseline](baseline-2026-10-30.md). Its installed Atlas source was 9c08fda20d22322370dcb5105a08a7edc6c00bd1. The project revision was 80348ddc5328f973ff9bfaf3b663c068848c5d9c. The kit documentation worktree was at 907f9b75d196ea74e24737abc7280b075c94b005 before this results update.

The checks used a separate detached linked worktree under the test root, dc01/native-probes. The original application project and source kit received no probe markers or native skill copies. Test-only changes added unique random markers to instruction files and three uniquely named skills:

| Test skill | Location |
|---|---|
| atlas-probe-codex-native | .agents/skills/atlas-probe-codex-native/SKILL.md |
| atlas-probe-claude-native | .claude/skills/atlas-probe-claude-native/SKILL.md |
| atlas-probe-shared | .github/skills/atlas-probe-shared/SKILL.md |

Each skill's body contained a token absent from its catalog description and invocation prompt. Startup prompts withheld instruction tokens and forbade file reads. This separates automatic loading from later reads and skill-body invocation. These canaries are test fixtures, not shipped Atlas skills. Existing shared Atlas procedures were read at their installed paths.

## Runtime and policy

| Runtime | Version | Observed model | Execution policy |
|---|---|---|---|
| Codex CLI | 0.164.0-alpha.11.1 | Default selection retained | read-only sandbox; approval never |
| Claude Code CLI | 2.1.295 | Opus 5.5 | plan mode; only Read, Glob, Grep, Skill tools enabled; no permission prompts |
| GitHub Copilot CLI | 1.0.105 | Claude Sonnet 5.5 | only view, glob, grep, skill enabled; write and shell denied; built-in MCPs disabled |

All ran on Windows through local subprocesses with a 150-second limit per check. Claude had a USD 2 budget limit per run; Copilot had a 100 AI-credit limit per run. These are configured bounds, not measured spending. No model-switch flag was supplied. No test launched additional agents.

Copilot was installed at a pinned version under the external test-tools directory. Its first launch rejected --trust-folder combined with --session-id before a model run began. The runner was corrected to let a new session generate its ID, read sessionId from JSON output, and omit --trust-folder on resume. This was a runner defect, not an Atlas loading failure; policies were not broadened.

## Observations

| Case | Codex | Claude | Copilot | Pass signal and limit |
|---|---|---|---|---|
| Root startup | PASS | PASS | PASS | Returned the withheld instruction token with zero tool calls |
| Nested startup | PASS | PASS | PASS | Returned the same root token and native catalog from scripts/nested, with zero tool calls |
| Explicit skill invocation | PASS | PASS | PASS | Returned the skill-body token, read the actual shared model advisor and ATLAS.md, and reported 3 CU advice and closeout rules |
| Atlas planning workflow | PASS | PASS | PASS | Identified common instructions, read ATLAS.md, advisor, and live planning records; advice remained advisory |
| Saved-session resume | PASS | PASS | PASS | Recalled the earlier continuity token, purpose, directory, and read-only restriction with zero tool calls |
| Missing mandatory source | PASS | PASS | PASS | Attempted the absent path, reported BLOCKED, and did not substitute installed ATLAS.md |

The last row is a passing negative test: adoption was blocked as expected. It is not a successful adoption result. The absent path was docs/reference/unavailable-sources/missing-kit/ATLAS.md; no network outage was simulated.

Discovery differed by runtime:

- Codex returned the AGENTS.md marker and listed only the .agents test skill. It did not list the .github or .claude canaries.
- Claude returned the CLAUDE.md marker and listed only the .claude test skill. It did not list the .github or .agents canaries.
- Copilot returned the .github/copilot-instructions.md marker, also reported the root AGENTS.md and CLAUDE.md markers, and listed all three test skills. Its skill tool successfully invoked the .github canary.

Codex and Claude followed their root pointers to common instructions in the separate natural-workflow check. Copilot already had common instructions in startup context and began file reads with ATLAS.md. The explicit-invocation prompt constrained reads; Claude read the named skill, advisor, and ATLAS.md without reopening common instructions. That case alone is not evidence of pointer forwarding.

The workflow responses used the installed advisory table: GPT-6.1 Sol for Codex, Sonnet 5.5 for Claude, and the base/default tier for Copilot. The selected models stayed unchanged. The checks establish use of the table, not independent validation of its pricing or model-quality claims.

All checks reported the fixture files unchanged. A final full file-set and SHA256 comparison found 58 of 58 expected files, no added or missing files, and no changed hashes. Codex/Claude used the original snapshot. A second snapshot added only the Copilot instruction marker before Copilot ran; both epochs are retained locally.

## Reproduction and evidence

Create a separate worktree from an installed, validated runnable project. Add the three test skills and random instruction markers there, retain their expected hashes, and keep skill-body tokens out of prompts. Run root and nested discovery before any explicit invocation. Resume the root session by its recorded ID. Preserve raw JSON events and inspect actual read/skill calls as well as final answers.

The local runner uses these command forms; PROMPT, PROJECT, and SESSION_ID are placeholders:

~~~text
codex --ask-for-approval never exec --sandbox read-only --cd PROJECT --json PROMPT
codex --ask-for-approval never exec --sandbox read-only --cd PROJECT --json resume SESSION_ID PROMPT
claude -p --output-format stream-json --verbose --permission-mode plan --permission-prompts none --tools Read,Glob,Grep,Skill --allowedTools Read,Glob,Grep,Skill --max-budget-usd 2 PROMPT
claude -p --resume SESSION_ID --output-format stream-json --verbose --permission-mode plan --permission-prompts none --tools Read,Glob,Grep,Skill --allowedTools Read,Glob,Grep,Skill --max-budget-usd 2 PROMPT
copilot -C PROJECT --trust-folder --output-format json --no-auto-update --no-ask-user --available-tools view,glob,grep,skill --deny-tool write --deny-tool shell --disable-builtin-mcps --max-ai-credits 100 -p PROMPT
copilot -C PROJECT --resume SESSION_ID --output-format json --no-auto-update --no-ask-user --available-tools view,glob,grep,skill --deny-tool write --deny-tool shell --disable-builtin-mcps --max-ai-credits 100 -p PROMPT
~~~

Run Claude from PROJECT or its scripts/nested child. The local Windows runner used the installed PowerShell launcher for Claude and the pinned npm-loader.js through Node for Copilot. Those are launch details, not required kit dependencies.

Prompts asked for:

1. Root/nested: report the automatic discovery token and visible atlas-probe skill names, without tools or file reads; remember a separate conversation token.
2. Invocation: use the named runtime canary, report its body token, read .github/skills/model-tier-advisor/SKILL.md and ATLAS.md, and state 3 CU advice and two closeout rules without switching models.
3. Workflow: follow project read order to plan a 3 CU documentation task and identify files actually read; do not change files.
4. Missing source: attempt the exact mandatory missing path, prohibit substitution, and report BLOCKED when absent.
5. Resume: recall the earlier conversation token, purpose, directory, and restriction without tools; do not repeat the token in this prompt.

Raw commands, stdout/stderr, exit codes, session IDs, marker checks, and hashes remain in the local test root at dc01/evidence/native/<runtime>-<case>.json, expected-codex-claude.json, expected.json, and summary.json. Local planning scripts run and summarize the probes. Raw provider events are not published with this kit; this checked-in result is the portable evidence summary.

The user requested execution of these checks and previously delegated application UAT to Codex. Application acceptance remains the separate six-command, eleven-check result in [the baseline](baseline-2026-10-30.md). These read-only probes do not repeat application implementation or establish independent human acceptance. [The UAT guide](uat.md) includes a separate loading acceptance checklist.

## Remaining coverage

VS Code Local Copilot, Copilot Agent Host, the experimental Codex editor integration, and the Claude editor integration remain untested. Saved-session recall does not test compaction, source-revision recall, pending-check recovery, or authorization recovery after a policy change. Permission-denial behavior, unavailable network, cloud targets, duplicate skill names, and proposed session/external-guidance lifecycle features also remain untested. Issues 7 and 27 remain open for their remaining acceptance criteria.

The loading decision for this documentation baseline is to retain .github/skills as the authoritative shared source and use explicit reads in the tested standalone Codex and Claude routes. No product copies, symlinks, adapters, installation changes, or supported-editor claims follow from these canaries.

Command behavior was checked against the installed help and official [Codex non-interactive documentation](https://learn.chatgpt.com/docs/non-interactive-mode), [Claude programmatic documentation](https://code.claude.com/docs/en/headless), and [Copilot programmatic reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-programmatic-reference), accessed 2026-10-30. Installed-version observations above control the scope of the result.
