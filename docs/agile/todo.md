# ntelio_ai -- ATLAS Alignment Todo

Gap analysis from reviewing ntelio_ai against the ATLAS (AI Task Lifecycle Automation System) vision.
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
- [ ] **Add "Extending ntelio_ai" section to README.md** -- Explain how to create custom skills, organize by tier, contribute back.

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

## Resolved

- [x] CLAUDE.md and AGENTS.md duplicate response guidelines -- removed, point to source of truth only
- [x] NewProject.bat missing pre-flight check for ntelio_ai.ps1 -- added verification
- [x] No post-install verification -- added -Verify flag to ntelio_ai.ps1
- [x] Scaffold docs example content not marked as placeholder -- added banners
