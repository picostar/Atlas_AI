# Prompt: Compliance And Governance Review

## Contents

- [How to Use](#how-to-use)
- [Product Release Stages](#product-release-stages)
- [Instructions](#instructions)
- [Base Rules (Evaluation Criteria)](#base-rules-evaluation-criteria)
- [MRD Evaluation](#mrd-evaluation-applies-to-mrd_md-files)
- [PRD Evaluation](#prd-evaluation-applies-to-prd_md-files)
- [ESD Evaluation](#esd-evaluation-applies-to-esd_md-files)
- [Required Output Format](#required-output-format)

---

## How to Use

Point an LLM at this file and say: "Read this prompt, then review the live project documents in docs/cgr/ and save the governance review to docs/cgr/CGR-results.md."

The LLM will scan live MRD, PRD, and ESD artifacts in `docs/cgr/`, ignore starter templates and housekeeping files during evaluation, perform post-review template cleanup, and produce a single results file.

Treat the directory containing this file as the repository control root. If the runnable application lives in a child directory one level down, keep the governance review anchored to the existing `docs/cgr/` directory at the control root.

---

## Product Release Stages

If the project uses `PS.md`, see that file for full stage definitions, gate criteria, exit criteria, and ownership model. CGR does not require PS -- it can run standalone against any set of MRD, PRD, and ESD documents.

When used with PS, the CGR is designed to run at two points in the product lifecycle:

| Stage | When CGR Runs | Purpose |
|---|---|---|
| **EVT -> DVT gate** | After core build, before pilot | Identify governance gaps. ESD should exist by now. |
| **DVT -> PVT gate** | After pilot, before go-live | Confirm all gaps are closed. Final gate to production. |

For quick reference:
- **EVT** -- Build and prove the concept. MRD + PRD required to enter. ESD drafted during EVT.
- **DVT** -- Pilot with real users, security review, close governance gaps. ESD + CGR required to enter.
- **PVT** -- Operational handoff, rollback test, go-live approval. Clean CGR required to enter.

When used without PS, the CGR simply evaluates whatever live MRD, PRD, and ESD artifacts exist in `docs/cgr/` against the governance rules below.

---

## Instructions

You are reviewing the live solution documents for this repository for governance completeness.

1. Treat the directory containing `CGR.md` as the repository control root.
2. Use `docs/cgr/` under that control root as the authoritative location for MRD, PRD, ESD, and CGR artifacts.
3. If the repo root does not contain `docs/cgr/`, look one level down for a child directory that does. If exactly one child directory qualifies, use that child as the effective project root for this review. If multiple child directories qualify, stop and ask the user which one to use.
4. If the runnable application lives in a child directory one level down, keep the review output in the selected `docs/cgr/` directory instead of placing it inside the nested application folder.
5. Read every live project `.md` file in the selected `docs/cgr/` directory, except `README.md`, any results file, and any `*_TEMPLATE.md` file unless the user explicitly asks to review templates.
6. Ignore `README.md` and any `*_TEMPLATE.md` file unless the user explicitly asks to review the template itself.
7. Classify each live artifact by type based on its filename prefix: MRD, PRD, or ESD.
8. Determine the current stage based on which live documents exist:
   - MRD + PRD only (no ESD) = project is in EVT
   - MRD + PRD + ESD = project is at DVT gate or beyond
9. Evaluate each live document against the applicable rules for its type (see sections below).
10. In the Executive Summary, state which stage the project appears to be in and what's needed to advance.
11. Before writing results, detect whether this is the first CGR run by checking whether `docs/cgr/CGR-results.md` already exists under the selected project root.
12. Produce a single results file: `docs/cgr/CGR-results.md` under the selected project root.
13. After the review:
   - If this is the first CGR run, remove `docs/cgr/MRD_TEMPLATE.md` and `docs/cgr/PRD_TEMPLATE.md` if they are still present
   - If a live ESD artifact exists and `docs/cgr/ESD_TEMPLATE.md` is still present, remove it as post-review cleanup
   - If operating read-only, call out each stale template explicitly instead of deleting it

---

## Base Rules (Evaluation Criteria)

### Rule 1 -- MRD and PRD Required
Every solution must have an MRD and a PRD. The MRD and PRD may include or reference the artifacts produced by this process.

### Rule 2 -- Vendor Selection
Any new vendor must have a written selection process that includes rationale, comparable alternatives, impact on existing products, and approval by the required business and finance owners. Executive approval and escalation expectations must be defined.

### Rule 3 -- Supportability
The organization must be able to support the solution without tribal knowledge. Every solution must have an SOP, with monitoring and deployment standards that the delivery and operations teams can execute.

### Rule 4 -- Monitoring and Deployment Standards
Use the organization's standard monitoring and deployment tooling. If standard tooling is not used, document the exception and the approved alternate approach.

### Rule 5 -- No Masking Platform Constraints
Do not deploy solutions that hide platform constraints. If buffering, tunneling, caching, or stabilizers are used, confirm they are not masking overload, capacity gaps, or weak infrastructure.

### Rule 6 -- Named Ownership (Progressive)
Ownership grows with the project stage. At minimum: Product Owner before EVT. Product Owner plus Business or Commercial Owner for EVT. IT or Platform Owner added at DVT. All required roles filled by PVT. If ownership for the current stage is unclear, the project does not advance to the next gate.

### Rule 7 -- Rollback Plan
Any solution that touches production must have a rollback plan and a defined go-back condition. If rollback is not possible, document why and get explicit approval.

### Rule 8 -- Gate Approvals and Escalation
Each stage gate requires approval from designated signers. EVT start: Executive Sponsor, Product Owner, Business or Commercial Owner. DVT gate: EVT signers plus IT or Platform Owner and Security or Compliance. PVT gate: all required delivery and control functions. If the organization cannot block a risky go-live or enforce remediation, document the gap before proceeding.

### Rule 9 -- Security Review
Every solution must be reviewed by the appropriate security or compliance function before production. The review must confirm basic security controls are in place, including admin access, MFA where applicable, credential handling, logging and retention, and vendor security posture. If no security review has occurred, the solution does not proceed.

### Rule 10 -- Pilot Before Rollout
Any solution must be tested in a small pilot with objective acceptance criteria before broad rollout. If a pilot is skipped, document why and obtain approval.

### Rule 11 -- Operational Handoff
Any solution must have an operational handoff to the responsible operations or support team before go-live, including a support playbook. If the designated support function cannot support it, it cannot be put into production.

### Rule 12 -- Capacity Planning
Any solution must have a simple capacity assumption written down and verified against reality. If the expected load is unknown, the solution is not ready for production.

### Rule 13 -- Vendor Support Agreement
Any vendor-dependent solution must have a support and escalation agreement defined, including response expectations and how the organization reaches engineering when needed.

### Rule 14 -- No Manual One-Offs
Any solution must avoid one-off manual configuration in production. If manual steps are required, document them in the SOP and convert them to automation as soon as possible.

### Rule 15 -- Post Go-Live Review
Any solution must have a post go-live review within 7 days to confirm stability, ticket volume, and monitoring effectiveness, and to identify platform remediation if needed.

### Rule 16 -- Customer-Hosted Infrastructure
Any solution that requires customer-hosted infrastructure must have a written responsibility matrix accepted by the customer. If the customer will not accept operational responsibility, the provider must offer an approved alternative or the solution does not proceed.

---

## MRD Evaluation (applies to MRD_*.md files)

An MRD defines the market problem, users, and business justification. It is not an implementation document, so operational rules are evaluated for awareness, not full compliance.

**Primary rules (must be addressed in the MRD):**

| Rule | What to look for in an MRD |
|---|---|
| 1 -- MRD and PRD Required | Does this MRD exist? Does it reference or link to a PRD? |
| 2 -- Vendor Selection | If a vendor/platform is identified, is the selection rationale documented? Alternatives considered? |
| 6 -- Named Ownership | Is a Product Owner identified? (MRD stage only requires Product Owner) |
| 8 -- Gate Approvals | Are EVT gate signers identified? (Executive Sponsor, Product Owner, Business or Commercial Owner) |

**Awareness rules (should be acknowledged, detailed in PRD/ESD):**

| Rule | What to look for in an MRD |
|---|---|
| 5 -- No Masking Constraints | Does the MRD acknowledge platform constraints or risks? |
| 12 -- Capacity Planning | Are high-level capacity assumptions stated (user count, volume)? |
| 13 -- Vendor Support | If vendor-dependent, is vendor relationship mentioned? |
| 16 -- Customer Infrastructure | If customer-hosted, is it flagged as a dependency? |

**Not applicable to MRD (addressed in PRD or ESD):**
Rules 3, 4, 7, 9, 10, 11, 14, 15

---

## PRD Evaluation (applies to PRD_*.md files)

A PRD defines what the product does, acceptance criteria, personas, and dependencies. It bridges market requirements to engineering. Operational rules should at minimum be acknowledged with a plan to address them in the ESD.

**Primary rules (must be addressed in the PRD):**

| Rule | What to look for in a PRD |
|---|---|
| 1 -- MRD and PRD Required | Does the PRD exist? Does it reference the MRD? |
| 2 -- Vendor Selection | Is the platform/vendor choice documented with rationale? |
| 6 -- Named Ownership | Product Owner and Business or Commercial Owner identified? (PRD stage requires both for EVT gate) |
| 8 -- Gate Approvals | EVT gate signers identified and approval table present? (Executive Sponsor, Product Owner, Business or Commercial Owner) |
| 10 -- Pilot Before Rollout | Is a pilot plan defined with acceptance criteria? |
| 12 -- Capacity Planning | Are capacity assumptions stated (users, volume, limits)? |

**Should be referenced (detailed plan in ESD):**

| Rule | What to look for in a PRD |
|---|---|
| 3 -- Supportability | Is SOP mentioned as a deliverable? |
| 7 -- Rollback Plan | Is rollback acknowledged as a requirement? |
| 9 -- Security Review | Is a security review listed as a dependency or gate? |
| 11 -- Operational Handoff | Is an operations or support handoff mentioned as a milestone? |
| 13 -- Vendor Support | Is vendor support agreement referenced? |
| 15 -- Post Go-Live Review | Is a post go-live review on the timeline? |

**Not typically in PRD (addressed in ESD or SOP):**
Rules 4, 5, 14

---

## ESD Evaluation (applies to ESD_*.md files)

An ESD defines how the product is built -- architecture, APIs, data models, deployment, and operational governance. The ESD is drafted during EVT and must be complete before entering DVT (pilot). **All operational rules must be fully addressed here. The ESD is the last gate before pilot and go-live, not before development.**

**All 16 rules apply to the ESD.** Evaluate each rule for full compliance.

### Expected ESD Sections

An ESD that passes governance should contain at minimum these sections. If a section is missing, flag it in the compliance table.

| Section | Maps to Rule | What it must contain |
|---|---|---|
| **Architecture Overview** | -- | System diagram, components, data flow, integration points |
| **Data Model** | -- | Entities, relationships, storage locations (database, object store, CRM, knowledge base) |
| **API Contracts** | -- | External APIs consumed, auth flows, rate limits, error handling |
| **Infrastructure and Environment** | 4 | Hosting platform, deployment targets (dev/test/prod), environment URLs |
| **Vendor Selection Rationale** | 2 | Why this platform, alternatives considered, exec approval status |
| **Monitoring and Alerting** | 4 | Standard monitoring approach or documented exception with approved alternate approach |
| **Deployment and Configuration** | 4, 14 | Automated deployment or documented exception; CI/CD pipeline; no manual one-offs in production |
| **Security and Credential Handling** | 9 | Security review status, admin access controls, MFA, service principal management, secret rotation, logging and retention |
| **Capacity Planning** | 12 | Expected users, query volume, platform limits, load assumptions verified against reality |
| **Rollback Plan** | 7 | Go-back condition, rollback steps, data impact, who authorizes rollback |
| **Pilot Plan** | 10 | Pilot users, duration, scope, measurable acceptance criteria |
| **Operational Handoff** | 11 | Operations or support playbook, escalation contacts, monitoring dashboards, support hours |
| **Vendor Support Agreement** | 13 | Vendor support tier, escalation path, response SLA, how to reach engineering |
| **Ownership and Gate Approvals** | 6, 8 | All stage owners identified (Product Owner, Business or Commercial Owner, IT or Platform Owner). DVT and PVT gate signers listed. IT or Platform role for infrastructure readiness and security compliance is defined. Escalation paths defined. |
| **Post Go-Live Review** | 15 | 7-day review plan -- stability, ticket volume, monitoring effectiveness, remediation items |
| **Customer Responsibility Matrix** | 16 | If customer-hosted: written responsibility matrix. If not applicable: state "internal tool, not applicable" |
| **Supportability / SOP** | 3 | Standard operating procedures for ongoing operation, maintenance, and support |
| **Platform Constraints** | 5 | Known limitations of the platform; confirm no buffering/tunneling/caching is masking capacity gaps |

---

## Required Output Format

Save the output as `docs/cgr/CGR-results.md` under the selected project root using this structure:

```
# Governance Review Results

**Review date:** YYYY-MM-DD
**Documents reviewed:** [list filenames]
**Reviewer:** [LLM model name]

---

## Executive Summary

[10 lines max. Overall governance posture. Biggest risks across all documents.]

---

## Document: [filename]

### Classification: MRD / PRD / ESD

### Compliance Table

| Rule | Status | Gap | Suggested Location |
|---|---|---|---|
| ... | Compliant / Partially / Missing / N/A | ... | ... |

### Top Required Additions (ordered by priority)

1. ...
2. ...

### Proposed Insert Text

[Copy-ready text blocks for each gap]

---

## Document: [next filename]

[Repeat structure]

---

## Cross-Document Gaps

[Issues that span multiple documents -- e.g., ownership missing from both MRD and PRD,
vendor selection not covered anywhere, no document addresses rollback]

## Assumptions and Open Questions

[Only if documents truly lack needed info]
```

---

## Optional Scoring Extension

This extension is optional and does not replace the baseline output.

Keep the required output exactly as defined above in `docs/cgr/CGR-results.md`.
If a numeric governance score is desired, derive it from the compliance table and save it as `docs/cgr/score.md`.

### Scoring Inputs

- Use rule status from the compliance table in `CGR-results.md`.
- Exclude rules marked `N/A` from scoring denominator.
- Use rule criticality weighting for risk-sensitive gates.

### Status Points

| Status | Points |
|---|---|
| Compliant | 1.0 |
| Partially | 0.5 |
| Missing | 0.0 |

### Recommended Rule Criticality Weights

| Criticality | Weight |
|---|---|
| Critical | 3 |
| High | 2 |
| Standard | 1 |

Recommended default mapping:
- Critical: Rules 2, 7, 8, 9, 10, 11, 12, 13, 16
- High: Rules 3, 4, 5, 6, 14, 15
- Standard: Rule 1

### Score Formula

- Rule weighted points = status points * rule weight
- Maximum weighted points = sum of applicable rule weights
- Overall score (0 to 100) = (sum rule weighted points / maximum weighted points) * 100

### Gate Interpretation Example

- DVT recommendation target: score >= 70 and no unresolved Critical rule in Missing status.
- PVT recommendation target: score >= 85 and no unresolved Critical or High rule in Missing status.

Treat these thresholds as defaults. The organization may set stricter thresholds by policy.

### Optional Score Artifact

Save the derived score output as `docs/cgr/score.md` using a concise scorecard format with:
- Review date, reviewer, source results file
- Overall score and gate recommendation
- Rule-level weighted scoring table
- Top remediation priorities with owner and target date
- Exception log with expiry dates

---

## Optional Seed And Reference Bootstrap Extension

This extension is optional and does not replace baseline CGR requirements.

Use this when live MRD, PRD, and ESD artifacts are missing and draft governance docs must be created first.

Bootstrap flow:
1. Read `seed.md` if present.
2. Read relevant source material in `docs/reference/`.
3. Generate drafts in `docs/cgr/` using template structure:
   - `MRD_<PROJECT>_v0-draft.md`
   - `PRD_<PROJECT>_v0-draft.md`
   - `ESD_<PROJECT>_v0-draft.md`
4. Record source traceability in `docs/cgr/seed-to-docs-mapping.md`.
5. Run baseline CGR review and produce `docs/cgr/CGR-results.md`.
6. If scoring is enabled, derive `docs/cgr/score.md` from the latest results.

When source evidence is missing, mark it explicitly as `TBD` and list open questions. Do not invent approvals or operational claims.

---

## Optional Iteration Loop Using Results And Score

This extension is optional and does not replace baseline CGR requirements.

Use this for repeated governance improvement cycles after initial outputs exist.

Iteration loop:
1. Read current MRD, PRD, ESD artifacts plus `docs/cgr/CGR-results.md`.
2. If present, read `docs/cgr/score.md` and identify score-impacting gaps.
3. Prioritize unresolved Critical and High gaps first.
4. Apply targeted document improvements.
5. Re-run baseline CGR review and refresh `docs/cgr/CGR-results.md`.
6. Refresh `docs/cgr/score.md` and compare score delta.
7. Update `docs/cgr/remediation-tracking.md` with owner, status, and target dates.
8. Repeat until target stage gate conditions are satisfied.

Recommended rerun triggers:
- Before DVT gate decision.
- Before PVT gate decision.
- After significant architecture, ownership, security, or rollout-plan changes.
- After exception expiry dates.

---

## Constraints

- Be direct and practical.
- Do not invent approvals or processes that are not present in the documents. If missing, mark as missing.
- Use each document's terminology where possible.
- Plain language, no filler.
- Mark rules as N/A when they genuinely do not apply to the document type.
- The cross-document gaps section is the most important output -- it shows what falls through the cracks between documents.
