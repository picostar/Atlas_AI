# Local skill collision and revision results: 2026-10-30

## Scope and identity

This trial observes one duplicate name in project and personal locations on VS Code Local Copilot. It does not establish a universal precedence rule, personal-only discovery, other runtimes, package updates or managed policy behavior. The [editor loading results](editor-results-2026-10-30.md) retain the other runtime observations and nested permission blocker.

The runnable Taskboard case was D:/doit/Atlas/atlas_test/dc02/cases/dt2-local-01, detached application revision 80348ddc5328f973ff9bfaf3b663c068848c5d9c. Its installed Atlas source was 9c08fda20d22322370dcb5105a08a7edc6c00bd1; documentation was based on 57ab1686927ad99e2700b8c2f756e2d8104f3cfc. No installer or Atlas update ran. Windows, VS Code 1.144.0, GitHub Copilot Chat 0.72.0, Local, Auto resolved to GPT-6 Luna and Default permissions were observed. No settings or policies were changed.

[VS Code documents](https://code.visualstudio.com/docs/agent-customization/agent-skills) project .github/skills and personal ~/.copilot/skills locations. This trial placed a uniquely named disposable skill, atlas-dc02-collision-03a83478, in both locations. Each SKILL.md had matching name/description frontmatter and disable-model-invocation: true. Bodies contained distinct source_scope, procedure_revision and private body_marker values. Expected markers stayed outside the application and invocation prompts. Production skills were not copied.

## Observed results

| Check | Actual result |
|---|---|
| Native explicit slash invocation with both copies present | Project body project-r1 returned; personal body personal-r7 was not selected |
| Native source evidence | Exported request attached the project SKILL.md and its body; zero serialized tool invocations |
| Update only the project body, then start a fresh Local chat | Project body project-r2 and its new marker returned; personal file hash unchanged |
| Explicit project-path fallback after the native invocation | One completed copilot_readFile event, read_file arguments identifying the project path, and matching project-r2 output |
| Application smoke before and after | Both exited 0 with the Taskboard PASS signal |
| Preservation and cleanup | All 55 application baseline files unchanged; only the declared project test skill added/updated, 56 final files. Personal file hash checked before deleting its exact owned file and unique directory; parent directory left alone |

The two native invocations supplied skill bodies as prompt attachments. Their success is not evidence of a file-reading tool call. The fallback has a separate actual read event. The collision result identifies the selected project body when both files existed; it does not prove the personal copy was independently discoverable. No old-session cache, deletion refresh, remote packaging or other-runtime collision test was executed.

Codex performed acceptance as the user's explicitly delegated tester for DT1 and DT2. The bounded collision, fresh-revision and explicit-read observations passed. No independent human observation is claimed. Keep shared Atlas procedures authoritative in their existing project paths, retain explicit fallback, and verify source/revision on the actual target before adopting a distribution scheme.

## Executable reproduction and acceptance

Use a distinct runnable project from [the Taskboard recipe](taskboard-project.md), record its source and installed Atlas identities, and inspect for existing content before adding a uniquely named test skill. Preserve expected markers in a controller-only location.

1. Run the actual application smoke in PowerShell:

   ```powershell
   Set-Location D:/doit/Atlas/atlas_test/dc02/cases/dt2-local-01
   C:/Python313/python.exe scripts/smoke-taskboard.py
   ```

2. Create a new unique name for each repeat. Add matching SKILL.md names in project .github/skills/<name> and personal C:/Users/mondo/.copilot/skills/<name>, only after confirming the personal directory does not exist. Use distinct scope/revision/marker body fields and explicit-only frontmatter as above. Do not overwrite an existing personal skill. Save complete file hashes and the original skill bodies.
3. Open the project in VS Code, explicitly select Local and record model/policy. Start a new chat. Invoke the following, substituting the unique name:

   ```text
   /<name> Remain read-only. Execute this skill using its normal native route. Report source_scope, procedure_revision and body_marker from the body actually supplied or read. Do not infer the winner, edit files, or use shell, terminal or network tools.
   ```

4. Export with Chat: Export Chat. Compare actual output to controller markers and inspect the attached source path/body. Preserve a different winner or failure as observed rather than enforcing this trial's result.
5. Change only the project revision and marker. Check the personal hash is unchanged. Start a fresh chat and reselect Local, since a new chat can default to another runtime. Repeat invocation and native export. Compare the new body values to detect stale reads.
6. Explicitly request a file-tool read of .github/skills/<name>/SKILL.md and the three body values. Export again; verify an actual completed read of that path and its output. Keep any permission blocker blocked rather than changing policy.
7. Repeat the exact application smoke. Compare all project hashes allowing only declared test-skill edits. Verify the personal file still has its prepared hash, remove only the owned file and now-empty unique directory, and retain evidence. Leave its parent and all pre-existing files alone.

Expected application signal: PASS: add/list, completion/filter, persistence, idempotency, legacy migration, invalid-input data preservation. The actual commands used C:/Python313/python.exe. Application smoke establishes preservation of the runnable project, separately from skill selection.

## Evidence register

Local evidence is retained under D:/doit/Atlas/atlas_test/dc02/evidence/dt2-local-01 and is not installed kit content:

- preparation.json: absent-directory check, revisions, exact commands, before-smoke output, body markers and 55/56-file snapshots.
- r1-native.json: project-r1 prompt attachment, resolved model, Default permissions and actual output.
- update.json and project-r1-SKILL.txt/project-r2-SKILL.txt/personal-r7-SKILL.txt: controlled mutation and distinct original bodies.
- r2-and-fallback-native.json: separate fresh invocation and explicit read, source paths and actual output.
- invocation-prompt.txt, fallback-prompt.txt and UI records: submitted prompts, selected Local and observed results.
- summary.json and post-smoke.txt: delegated acceptance, native-event checks, actual post-smoke command/output/exit, final hashes and verified personal cleanup.

Only the portable summary ships with Atlas. Raw account/session context, private marker values and unrelated user data remain outside this document. Parent parity and distribution issues remain open for unexecuted cases.
