# UX Pattern Templates

This folder contains editable UX pattern templates. Each template is a starting point, not a mandatory final design.

## What these templates are for
Use these templates to accelerate UX decisions and keep layout reviews consistent. They help teams evaluate fit, orientation quality, and action clarity before implementation.

## Template catalog
- [uxp-01-modern-app-shell-layout.md](uxp-01-modern-app-shell-layout.md)
  - Modern app shell with persistent left navigation and top utility bar.
  - Uses breadcrumb context plus a clear page header with status and primary action.
  - Best for enterprise portals, SaaS dashboards, and workflow-heavy admin tools.

## Standard workflow
1. Pick the closest template.
2. Copy and adapt it for your project workflows.
3. Keep section structure intact so reviews stay comparable.
4. Capture assumptions, constraints, and tradeoffs in the template.
5. Record review outcomes in the template Review History section.
6. Promote approved outcomes into [../active-ux-pattern.md](../active-ux-pattern.md).

## How to modify a template safely
- Keep orientation goals explicit, avoid vague statements.
- Call out why navigation and action placement choices exist.
- Note fit boundaries, including when the pattern should not be used.
- Keep responsive behavior and accessibility expectations current.
- Do not put project-specific secrets or environment details in templates.

## Minimum review checklist
- Confirm users can identify location and section quickly.
- Confirm current record or workflow context is visible.
- Confirm status visibility and primary action clarity.
- Confirm responsive behavior remains predictable on tablet and mobile.
- Confirm the pattern does not overload sidebar or top bar responsibilities.

## Definition of done for pattern adoption
A pattern is adoption-ready when:
- navigation, context, status, and action hierarchy are explicit
- responsive behavior and accessibility expectations are documented
- known risks and mitigations are documented
- review history includes reviewer, notes, and decision
- approved decisions are reflected in [../active-ux-pattern.md](../active-ux-pattern.md)
