# Writing-standard adoption

## Scope

[Issue 39](https://github.com/picostar/Atlas_AI/issues/39) replaces the former writing-pattern reference with [.github/style.md](../../.github/style.md). Shared instructions, the core manifest, README, and legacy update guidance name the new standard. General prose rules and analytical-report requirements have separate scopes. The embedded Python checker is optional; Atlas installation gains no Python dependency.

The old filename appears only when explaining migration. Existing projects keep their customized content until a reviewed update plan explicitly approves retirement. Historical reports and retained evidence are not rewritten.

## Observed results

On 2026-10-31, Codex ran the bounded check on Windows 11 with Python 3.13.7 against kit base `1da3eeba8d7be53c0f2253573bdbe1af95e548ac` plus the retained patch and new style file. Application baseline: `80348ddc5328f973ff9bfaf3b663c068848c5d9c`. All four before/after Taskboard smoke runs exited zero. The replacement case preserved 50 baseline files, modified only the four declared existing files, added the style file, and removed the old reference file. The manifest-driven copy preserved both application scripts. All manifest group paths existed, and the optional checker reported zero mechanical errors for the source and both copied style files.

Evidence: `D:/doit/Atlas/atlas_test/style-39/case-01/results.json`, `kit.patch`, and `style-under-test.md`. Style SHA-256: `20fc9683285bebee23cf6a4a828ad1424f0442596edf71ef530e11cf3de226c0`. These results cover file adoption and application preservation only.

## Reproduction and acceptance

In the evolution workspace, run `python scripts/check-style-adoption.py --case case-02` from `D:/doit/Atlas/atlas_refactor`, choosing an unused case number. The harness refuses to overwrite an existing case. It copies only tracked Taskboard source, runs application smoke before and after the declared replacements, and separately copies core/scaffold manifest files onto a runnable app. It retains commands, stdout, exit codes, revisions, and content identity under `atlas_test/style-39/<case>/results.json`. This is a bounded file-adoption integration check, not execution of the complete newproject or atlas update prompts.

For editorial UAT, inspect `.github/style.md`, the shared prose instruction, README, manifest entry, and update migration note. Confirm that routine documentation uses the general rules, analytical reports use the additional citation requirements, inferences are distinguished from recommendations, and exact technical terms are permitted. Verify that the optional checker instructions do not require PowerShell. If Python 3 is available, save its fenced block as a temporary script and run `python /actual/path/check_style.py .github/style.md` from either isolated fixture; expect zero mechanical errors.

The user subsequently delegated commit, merge, and testing to Codex on 2026-10-31. Codex reviewed the scoped editorial acceptance items and ran six checker cases: valid citations, undefined citations, unused sources, duplicate sources, non-ASCII prose, and excluded literal regions. All six returned the expected results. Evidence is retained in the evolution workspace at `logs/style-39/delegated-review.json`. This is delegated agent acceptance for the writing standard and reference replacement. It does not establish independent human acceptance, automatic style-file loading, or macOS/Linux execution. No complete installation-validation receipt is claimed.

## Documentation impact

README, shared prose instructions, install manifest, and atlas_update.md change together. Newproject and atlas_validate.md already derive required files from the manifest, so their procedures need no filename-specific change. ATLAS.md, agent pointers, production skills, capability guidance, governance templates, and agile templates have no direct old-file reference and remain unchanged. The writing standard addresses their prose without changing their lifecycle or discovery contracts. CHANGELOG records the replacement in this review bundle.
