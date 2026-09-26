# atlas_ai -- ATLAS Alignment Todo

Gap analysis from reviewing atlas_ai against the ATLAS (AI Task Lifecycle Automation System) vision.
ATLAS requires: development process, skills layer, compliance governance, API-first architecture,
domain-expert-led development, and operational sustainability.

---

## P1 -- Critical: Create Tier 1 Universal Skills

These are required in every ATLAS installation. None exist yet.

- [x] **security-patterns** -- NIST CSF 2.0 (Govern, Identify, Protect, Detect, Respond, Recover) and OWASP for AI systems, credential handling, audit logging, threat modeling. Implemented in .github/skills/security-patterns/SKILL.md.
- [x] **requirements-writing** -- How domain experts write MRD/PRD content. Templates exist in docs/cgr/ and base skill exists in .github/skills/requirements-writing/SKILL.md.
- [x] **api-design** -- Contract-first REST design, versioning, error formats (RFC 7807), rate limiting. Implemented in .github/skills/api-design/SKILL.md and docs/reference/openapi-starter.yaml.
- [x] **testing-patterns** -- Smoketest script templates, unit test structure, CI integration. Implemented in .github/skills/testing-patterns/SKILL.md and devcycle testing guidance.
- [x] **code-style** -- Multi-language standards for TypeScript, JavaScript, Python, C#, and PowerShell. Implemented in .github/skills/code-style/SKILL.md.
- [x] **anti-patterns** -- Design, testing, security, and AI agent failure modes to avoid. Implemented in .github/skills/anti-patterns/SKILL.md.

## P2 -- High: Workflow and Template Integration

- [x] **Add API-first section to ATLAS.md** -- Added API-First Contract Gate to ATLAS.md referencing .github/skills/api-design/SKILL.md and docs/reference/openapi-starter.yaml.
- [x] **Add security review gate to ATLAS.md** -- Added Security and Governance Gate to ATLAS.md referencing .github/skills/security-patterns/SKILL.md and NIST CSF 2.0.
- [x] **Add requirements gate to ATLAS.md** -- Added Requirements Gate to ATLAS.md referencing .github/skills/requirements-writing/SKILL.md.
- [ ] **Expand MRD/PRD/ESD templates with examples** -- Fill in at least one complete fictional example per template. Show mapping to CGR rules.
- [x] **Add "Extending atlas_ai" section to README.md** -- Added section to README.md explaining Tier 1/2/3 skill authoring and pattern extension.

## P3 -- Medium: Create Tier 2 Stack Skills

These accelerate delivery once Tier 1 is solid.

- [ ] **deployment-patterns** -- Generic, cloud-agnostic: blue-green, canary, feature flags, rollback strategies, health checks. Current azure-deploy stays as Azure-specific.
- [ ] **pipeline-patterns** -- CI/CD orchestration, build parallelization, artifact versioning, secret injection, approval gates.
- [ ] **integration-recipes** -- OAuth/SAML flows, webhook vs polling, event-driven architecture, data sync patterns, enterprise system connectors.
- [ ] **framework-guide** -- Evaluation checklist, integration strategy, upgrade paths, fork vs contribute decision tree.

## P4 -- Medium: Tier 3 Domain Skill Templates

These are project-specific but the kit should ship guidance for creating them.

- [ ] **domain-model template** -- Blank skill showing how to encode entity definitions, relationships, business rules, state transitions.
- [ ] **compliance-decisions** -- Proactive design-time guidance when architecture choices conflict with governance rules. Currently CGR is reactive (post-hoc review only).
- [ ] **data-classification template** -- PII identification, sensitivity levels, retention requirements, access control mapping.

## P5 -- Medium: Enhance Existing Skills

- [ ] Add `./references/` folders to existing skills with examples and decision trees.
- [ ] Add CU scoring worked examples to devcycle-management.
- [ ] Add branching decision tree to git-workflow.
- [ ] Standardize "When to Use" section format across all skills.

## P6 -- Medium: Review New UX Patterns

Reference patterns to evaluate for future end-to-end UXP templates.

| Modern pattern | Use it when | Example links |
| --- | --- | --- |
| App shell: top bar + left panel | Best default for enterprise apps, dashboards, admin portals, NOC/COPS tools, and service portals | IBM Carbon UI Shell, which combines header, left panel, and right panel patterns |
| Collapsible sidebar with grouped sections | You still want vertical nav, but with modern behavior: collapse, mobile drawer, workspace switcher, grouped nav, and footer account area | shadcn/ui Sidebar and Tailwind sidebar layouts |
| Sidebar + breadcrumb + page title | Best for deep workflows where the user must know where they are and what record they are viewing | shadcn sidebar block includes sidebar, breadcrumb, trigger, and main content layout |
| Navigation rail | Good for mid-size screens or apps with only 3 to 7 major destinations; cleaner than a full sidebar, but less descriptive | Material Design navigation rail |
| Navigation drawer | Good when the nav is needed but not always visible; more common on tablet, mobile, or responsive apps | Material Design navigation drawer |
| Top navigation with dropdowns or mega menus | Better for marketing sites, product sites, corporate websites, and shallow IA | Radix Navigation Menu for implementation, and NN/G mega-menu guidance for large site navigation |
| Top nav + utility bar | Good when the top bar carries global utilities: search, account, alerts, help, app switcher | Carbon recommends header utilities such as profile, search, notifications, and switcher on the right side of the header |
| Breadcrumbs as secondary navigation | Use for hierarchy, records, workflows, folders, customers, projects, orders, tickets | Fluent says breadcrumbs help people understand complex hierarchy, but should not be used alone |
| Tabs for local page sections | Use inside a page or record: Overview, Activity, Billing, Settings, Logs, Attachments | Fluent tabs define layered sections where one panel is shown at a time |
| Command palette or global search | Good for power users, dense apps, developer tools, admin portals, and jump to customer/order/ticket/action flows | shadcn Command and cmdk command menu examples |
| Recent, starred, or workspace switcher navigation | Good for Jira-style, project-style, multi-tenant, or customer/account-heavy apps | Atlassian's 2024 navigation redesign emphasized customization, frequent items, Starred, and Recent |
| List/detail navigation | Good when users move through many child records: inboxes, tickets, contacts, orders, devices, assets | Microsoft's navigation guidance calls list/details well suited for email inboxes, contact lists, and data entry |

- [ ] Select which patterns should become first-class UXP templates.
- [ ] Map selected patterns to current UXP coverage to avoid overlap.
- [ ] Record rationale in Review History when a new UXP is added.

## Resolved

- [x] **requirements-writing skill** -- Implemented base skill under `.github/skills/requirements-writing/SKILL.md` for MRD/PRD structure, market analysis, and CGR traceability.
- [x] **UXP-05 Enterprise Identity, Authentication, and SSO Journey** -- Created template under `patterns/ux-patterns/ux-pattern-templates/uxp-05-identity-auth-sso-journey.md` and registered in `.atlas/install-manifest.json`.
- [x] **NIST CSF 2.0 Integration** -- Added `docs/reference/nist-csf-2-guide.md` and mapped the 6 functions (Govern, Identify, Protect, Detect, Respond, Recover) to CGR rules and ATLAS development lifecycle.
- [x] **Azure IT Resource Request & Live Cost Estimation (FinOps)** -- Created formal corporate request template under docs/reference/azure-resource-request-template.md and automated pricing query script scripts/get-azure-prices.ps1 connected to the public Azure Retail Prices API.
- [x] **Secret Handover Ceremony Protocol** -- Created protocol under docs/reference/secret-handover-ceremony.md establishing zero-knowledge transmission, OOB verification, SHA-256 integrity checksums, and dual-secret rotation lifecycle.
- [x] **Azure Infrastructure as Code (Bicep)** -- Created modular Bicep templates under infra/main.bicep with dev/prod parameters and automatic 60-min SQL auto-pause delay.
- [x] **Local Development & Offline Emulation** -- Created docs/reference/local-development-guide.md and launcher scripts/dev-local.ps1 for SWA CLI mock Entra ID auth and Azurite.
- [x] **OpenAPI Starter Contract** -- Created docs/reference/openapi-starter.yaml with Entra ID Bearer auth, RFC 7807 problem details, health probes, and pagination.
- [x] **Automated CI/CD Pipeline Template** -- Created .github/workflows/azure-deploy.yml.template for OIDC-based automated Azure validation and deployment.
- [x] **Automated Smoketest Runner** -- Created scripts/smoketest.ps1 for automated health probe, version check, and 401 unauthenticated boundary verification.
- [x] **Enterprise Static Web App Config** -- Created patterns/ux-patterns/staticwebapp.config.json with strict security headers (CSP, HSTS) and Entra ID route guards.
- [x] **Operations & Disaster Recovery Runbook** -- Created docs/reference/operations-runbook.md covering monitoring SLIs/SLOs, zero-downtime secret rotation, and backups.
- [x] **Technical, User, and Integration Manuals** -- Created comprehensive `docs/manuals/technical-manual.md` (architecture, Bicep, OpenAPI, security), `docs/manuals/user-manual.md` (CU effort model, devcycle workflow, SSO usage, IT requests, FAQ), `docs/manuals/integration-manual.md` (M2M authentication, idempotency, rate limiting, code examples), and directory index `docs/manuals/README.md`. All localized in 100% English.
