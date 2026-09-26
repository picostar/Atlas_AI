# NIST Cybersecurity Framework 2.0 (CSF 2.0) -- Atlas AI Integration Guide

## Overview

The NIST Cybersecurity Framework (CSF) 2.0 provides an outcome-driven taxonomy for managing and reducing cybersecurity risk. CSF 2.0 expands on the traditional five functions by establishing **Govern (GV)** as the overarching sixth pillar:

1. **Govern (GV)**: Governance, risk management strategy, roles, policy, and supply chain oversight.
2. **Identify (ID)**: Asset discovery, risk assessment, business environment, and improvement priorities.
3. **Protect (PR)**: Identity management, access control, data protection, credential safety, and infrastructure resilience.
4. **Detect (DE)**: Continuous monitoring, telemetry, anomaly detection, and security event verification.
5. **Respond (RS)**: Incident management, containment, mitigation, operational communication, and analysis.
6. **Recover (RC)**: Restoration of assets, disaster recovery, rollback execution, and post-incident learning.

This guide defines how teams and AI agents applying the Atlas AI process kit incorporate NIST CSF 2.0 principles into daily task execution, architecture patterns, and CGR stage-gate reviews.

---

## 1. Mapping NIST CSF 2.0 to ATLAS Development Lifecycle

| CSF 2.0 Function | Atlas Phase / Artifact | Operating Practice |
|---|---|---|
| **Govern (GV)** | `accounts.md`, `ATLAS.md`, CGR Rule 6 & 8 | Explicit cloud account bindings, named role ownership, formal gate signer sign-offs before production transitions. |
| **Identify (ID)** | `docs/cgr/PRD_*.md`, `project-config.json` | Catalog system dependencies, data classification, APIs, external service integrations, and capacity bounds. |
| **Protect (PR)** | `secrets.md`, `patterns/`, `.gitignore` | Zero credentials in git, local-only secret storage, passwordless/SSO patterns (`UXP-05`), encrypted storage, least-privilege scoping. |
| **Detect (DE)** | `Smoketest:`, CGR Rule 4 | Automated smoketest verification of observability endpoints, centralized structured logging, audit trails for state changes. |
| **Respond (RS)** | `docs/agile/devcycle.md` (RDT), CGR Rule 11 | Reset devtasks (`RDT`) for urgent security mitigations, incident escalation playbooks, operational handoff checklists. |
| **Recover (RC)** | CGR Rule 7, `docs/agile/retro.md` | Documented and tested rollback procedures, go-back criteria, post-incident reviews in the retrospective log within 7 days. |

---

## 2. NIST CSF 2.0 Alignment with CGR Base Rules

When conducting a Compliance and Governance Review (`cgr.prompt.md` or `atlas_cgr.md`), verify the following mappings:

### Govern (GV)
- **CGR Rule 2 (Vendor Selection)**: Enforce supply chain risk management (GV.SC). Evaluate third-party vendor security posture, alternatives, data retention policies, and escalation mechanisms.
- **CGR Rule 6 (Named Ownership)**: Enforce security role assignments (GV.RR). Ensure explicit Product Owner, Technical Lead, and Security/Compliance approvals by stage.
- **CGR Rule 8 (Gate Approvals)**: Enforce organizational risk tolerance decisions (GV.OC) before promoting between EVT, DVT, PVT, and GA.

### Identify (ID)
- **CGR Rule 1 (MRD and PRD Required)**: Define business context and risk tolerance (ID.RA) before engineering begins.
- **CGR Rule 12 (Capacity Planning)**: Identify performance limits, resource constraints, and denial-of-service risks (ID.AM).
- **CGR Rule 16 (Customer-Hosted Infrastructure)**: Establish clear operational boundaries and shared responsibility matrices.

### Protect (PR)
- **CGR Rule 9 (Security Review)**:
  - Identity & Access Management (PR.AA): Multi-factor authentication (MFA), role-based access control (RBAC), and enterprise SSO (see `UXP-05`).
  - Credential Protection: Dedicated local-only `secrets.md` storage, environment variables, or platform secret vaults (Azure Key Vault, AWS Secrets Manager).
  - Platform Security (PR.PS): Secure baseline stack patterns (`patterns/stack-patterns/`), TLS 1.3 encryption in transit, encryption at rest.
- **CGR Rule 5 (No Masking Platform Constraints)**: Avoid buffering, caching, or proxies that conceal systemic architecture flaws or security boundary bypasses.
- **CGR Rule 14 (No Manual One-Offs)**: Replace error-prone manual configurations with infrastructure-as-code and deterministic CI/CD pipelines.

### Detect (DE)
- **CGR Rule 4 (Monitoring and Deployment Standards)**: Implement continuous telemetry, security information and event monitoring (SIEM), and threshold-based alerts (DE.AE).
- Automated health checks and smoketest verification of security headers and audit logs.

### Respond (RS)
- **CGR Rule 11 (Operational Handoff)**: Document incident response playbooks, operational triage procedures, and on-call escalation routes (RS.MA, RS.CO).
- Use Reset Devtasks (`RDT1`, `RDT2`) in `devcycle.md` to triage, contain, and remediate active security vulnerabilities ahead of planned feature work.

### Recover (RC)
- **CGR Rule 7 (Rollback Plan)**: Define explicit rollback mechanisms, database rollback migrations, and tested go-back criteria (RC.RP) before production deployments.
- **CGR Rule 15 (Post Go-Live Review)**: Conduct structured retrospective analysis within 7 days of deployment to identify root causes and preventive improvements (RC.IR).

---

## 3. Practical Agent Guardrails for Daily Coding

When assisting developers in an Atlas repository:
1. **Never generate hardcoded secrets**: If a token or key is needed, check `secrets.md` or instruct the user to configure an environment variable.
2. **Review authentication flows against UXP-05**: For login and session work, enforce uniform error responses to block user enumeration, support enterprise SSO, and require MFA step-up.
3. **Verify audit logging on sensitive mutations**: Ensure data modifications (create, update, delete) emit structured logs capturing timestamp, user/service identity, and action outcome without logging sensitive payload bodies or tokens.
4. **Smoketest security boundaries**: Devtask `Smoketest:` steps should verify access rejection (HTTP 401/403) for unauthorized requests alongside successful responses (HTTP 200) for valid requests.
