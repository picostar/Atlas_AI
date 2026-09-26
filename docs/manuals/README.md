# System Manuals and Documentation

> **Purpose:** This directory contains official documentation, technical architecture manuals, and user/operational guides for projects built with the Atlas_AI framework.

---

## Document Index

1. **[Technical Architecture and Engineering Manual (technical-manual.md)](file:///c:/Sources/Atlas_AI/docs/manuals/technical-manual.md):**
   - Target Audience: Software Architects, Developers, DevOps Engineers, and IT Security Auditors.
   - Contents: Global component architecture (Mermaid), breakdown of technology tiers (SWA, Functions, SQL Serverless, Key Vault, Entra ID SSO), API-First specifications under OpenAPI 3.1 and RFC 7807, Infrastructure as Code templates (Bicep), CI/CD pipelines, and automated smoketest verification.

2. **[User Manual and Operational Guide (user-manual.md)](file:///c:/Sources/Atlas_AI/docs/manuals/user-manual.md):**
   - Target Audience: Product Owners, Project Leads, Business Operators, and Engineers in daily workflows.
   - Contents: Glossary and effort estimation model using Complexity Units (CU), day-to-day devcycle workflow, corporate Single Sign-On (SSO via Microsoft Entra ID) user guide, IT cloud resource request procedure with live pricing lookup, troubleshooting FAQ, and incident escalation matrix.

3. **[Systems and API Integration Manual (integration-manual.md)](file:///c:/Sources/Atlas_AI/docs/manuals/integration-manual.md):**
   - Target Audience: External Developers, Consuming Backend Teams, Integration Partners, and Solution Architects.
   - Contents: M2M OAuth 2.0 Client Credentials flow with Microsoft Entra ID, mutation idempotency policy (`Idempotency-Key` header), rate limiting and exponential backoff retry algorithms, RFC 7807 error standard, and client code samples in Python and Node.js / TypeScript.

---

## Related Repository Guides

- [`docs/reference/azure-resource-request-template.md`](file:///c:/Sources/Atlas_AI/docs/reference/azure-resource-request-template.md) -- Official corporate IT cloud resource provisioning request and live cost estimation form (FinOps).
- [`docs/reference/secret-handover-ceremony.md`](file:///c:/Sources/Atlas_AI/docs/reference/secret-handover-ceremony.md) -- Secret handover protocol, verification checksums, and credential rotation lifecycle.
- [`docs/reference/local-development-guide.md`](file:///c:/Sources/Atlas_AI/docs/reference/local-development-guide.md) -- Zero-cost offline local development guide ($0) with SWA CLI and Azurite.
- [`docs/reference/operations-runbook.md`](file:///c:/Sources/Atlas_AI/docs/reference/operations-runbook.md) -- Production resilience, monitoring SLIs/SLOs, KQL diagnostics, and disaster recovery runbook.
