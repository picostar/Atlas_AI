---
name: "Atlas Guided CGR"
description: "Use when running a Compliance and Governance Review on a target project, including bootstrapping MRD, PRD, and ESD from source files. Trigger phrases: CGR, run CGR, atlas cgr."
argument-hint: "Optional project scope, stage gate target, or specific source file"
agent: "agent"
---

# Atlas CGR

Use this standalone prompt to run a Compliance and Governance Review on a target project.

Copy this file into the target project root, paste it into the agent, or say `CGR`, `run CGR`, `atlas cgr`, or `do CGR from github picostar/Atlas_AI on folder "<localpath>"` while VS Code is open.

This file must stand alone in the target project. Do not assume the target project already has Atlas_AI prompts, skills, or kit files installed.

Access model: this prompt does not itself grant repository or network access. The agent must establish access to the current Atlas_AI source kit by using an open local checkout, fetching the relevant files from `github.com/picostar/Atlas_AI`, or asking the user for a local path. Treat the source kit as read-only template input.

Remote-source phrasing: if the user says `do CGR from github picostar/Atlas_AI on folder "<localpath>"` or similar, treat the named GitHub repo as the source kit and the quoted path as the CGR target root. Write all output under `<localpath>/docs/cgr/` and never modify the source kit folder during the run.

## Prompt

You are running a Compliance and Governance Review on this repository.

1. Read local repository instructions first if present, especially `.github/copilot-instructions.md`, `ATLAS.md`, and any root pointer files.

2. Establish access to the current Atlas_AI source kit. Use the full CGR workflow defined in `.github/prompts/cgr.prompt.md` from the source kit as the operational source of truth for this run. If you cannot reach the source kit, ask the user for a local path or proceed with this standalone prompt only.

3. Select the target project root.
   - If the current folder has `docs/cgr/` or contains source artifacts to evaluate, treat it as the project root.
   - If runnable code lives in a child directory but governance docs live at the parent root, keep CGR output at the parent root.

4. Discover source materials in this target project:
   - `seed.md` if present
   - `docs/reference/` if present
   - any MRD-like, PRD-like, ESD-like artifacts (.md, .docx, .pdf, .txt) already in the project root or subfolders
   - marketing copy, product notes, sales material, specifications, discovery notes, customer notes
   - `accounts.md` if present, for non-secret cloud or vendor binding only
   - Skip secrets, credentials, dependency folders, build output, and `.git`.

5. Determine workflow mode:
   - Bootstrap mode: no live MRD, PRD, or ESD exists in `docs/cgr/`.
   - Improve mode: one or more live MRD, PRD, or ESD artifacts already exist in `docs/cgr/`.

6. In Bootstrap mode, actively author substantive draft MRD, PRD, and ESD artifacts in `docs/cgr/`:
   - Answer every section using source evidence, domain reasoning, and approved external references.
   - Mark inferred content with `[DRAFT INFERENCE]` and a one-line basis note.
   - Reserve `TBD` only for facts that can only come from the project owner, such as named owners, signed approvals, contract terms, or confirmed scope decisions.
   - The goal is a usable v0 draft a reviewer can correct, not a placeholder skeleton.
   - Default filenames when project naming is unknown:
     - `MRD_<PROJECT>_v0-draft.md`
     - `PRD_<PROJECT>_v0-draft.md`
     - `ESD_<PROJECT>_v0-draft.md`

7. In Improve mode, treat existing artifacts as the base and upgrade them with new source material, current user instructions, and approved external references.

8. Approved external references for this prompt:
   - IETF RFC 2119 and RFC 8174 for requirement language clarity.
   - NIST SP 800-160 concepts for engineering rigor and trustworthiness.
   - Cloud well-architected frameworks (Azure, AWS, Google Cloud) for non-functional architecture, operations, reliability, security, and cost tradeoffs.
   - Product management references for MRD and PRD structure when project sources are thin.
   - Record source names or URLs in the External Source Notes section of the results file.

9. Evaluate each live document against the CGR base rules:
   - Rule 1 MRD and PRD required, Rule 2 vendor selection, Rule 3 supportability, Rule 4 monitoring and deployment standards, Rule 5 no masking platform constraints, Rule 6 named ownership, Rule 7 rollback plan, Rule 8 gate approvals, Rule 9 security review, Rule 10 pilot before rollout, Rule 11 operational handoff, Rule 12 capacity planning, Rule 13 vendor support agreement, Rule 14 no manual one-offs, Rule 15 post go-live review, Rule 16 customer-hosted infrastructure, Rule 17 cross-document consistency.
   - Do not mark a rule `Compliant` if mandatory fields for that rule remain unresolved.
   - Run cross-document consistency checks across MRD, PRD, and ESD.

10. Produce a single results file at `docs/cgr/CGR-results.md` with this structure:
    - Executive Summary
    - one Document section per artifact with classification, compliance table (Rule, Status, Field Completeness, Gap, Suggested Location), top required additions, and proposed insert text
    - Cross-Document Gaps
    - Completeness Findings
    - Traceability Findings
    - Assumptions and Open Questions
    - External Source Notes

11. If scoring is enabled by the team, also write `docs/cgr/score.md` per the scoring extension in the full CGR prompt.

12. Post-review template cleanup:
    - On the first CGR run, remove `MRD_TEMPLATE.md` and `PRD_TEMPLATE.md` from `docs/cgr/` if still present.
    - When a live ESD exists, remove `ESD_TEMPLATE.md` from `docs/cgr/`.

## Default Decisions

- Bootstrap drafts must answer every section substantively. Do not leave answerable sections as TBD.
- Keep governance artifacts under `docs/cgr/`.
- Keep user-supplied project source material under `docs/reference/`.
- Keep `secrets.md` ignored and local-only.
- Commit `accounts.md` for non-secret vendor or cloud binding.
- Do not invent confirmed facts. Use `[DRAFT INFERENCE]` for reasoned proposals and `TBD` only for owner-supplied facts.
