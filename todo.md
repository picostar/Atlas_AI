# atlas_ai -- ATLAS Alignment Todo

Gap analysis from reviewing atlas_ai against the ATLAS (AI Task Lifecycle Automation System) vision.
ATLAS requires: development process, skills layer, compliance governance, API-first architecture,
domain-expert-led development, and operational sustainability.

---

## P1 -- Critical: Create Tier 1 Universal Skills

These are required in every ATLAS installation. None exist yet.

- [ ] **security-patterns** -- OWASP for AI systems, credential handling, audit logging, threat modeling. CGR Rule 9 requires security review but no skill guides implementation.
- [ ] **requirements-writing** -- How domain experts write MRD/PRD content. Templates exist but are stubs. This is the bridge for domain-expert-led development.
- [ ] **api-design** -- Contract-first REST design, versioning, error formats, rate limiting. ATLAS mandates API-first architecture but nothing in the kit teaches it.
- [ ] **testing-patterns** -- Smoketest script templates, unit test structure, CI integration. Workflow defines smoketest rules but not HOW to implement them.
- [ ] **code-style** -- Generic multi-language conventions. Only powershell-style exists today. Need TypeScript/JavaScript, Python, and general guidance.
- [ ] **anti-patterns** -- Design, testing, and delivery mistakes to avoid. Common AI agent missteps, coupling issues, deployment failures.

## P2 -- High: Workflow and Template Integration

- [ ] **Add API-first section to ATLAS.md** -- Reference api-design skill, add API contract review as a gate.
- [ ] **Add security review gate to ATLAS.md** -- Reference security-patterns skill, integrate with CGR Rule 9 timing.
- [ ] **Add requirements gate to ATLAS.md** -- Reference requirements-writing skill, clarify when MRD/PRD must be complete.
- [ ] **Expand MRD/PRD/ESD templates with examples** -- Fill in at least one complete fictional example per template. Show mapping to CGR rules.
- [ ] **Add "Extending atlas_ai" section to README.md** -- Explain how to create custom skills, organize by tier, contribute back.

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


