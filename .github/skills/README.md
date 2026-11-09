# Skill Catalog

This folder stores reusable agent skills for atlas_ai workflows.

## Included Skills
- `atlas-closeout`
- `atlas-realign`
- `cgr` (optional CGR group)
- `cgr-seed-to-cgr` (optional CGR group)
- `cgr-iterate` (optional CGR group)
- `azure-deploy`
- `devcycle-management`
- `model-tier-advisor`
- `project-setup`
- `git-workflow`
- `requirements-writing`
- `example-skill`

## Skill Authoring
- Follow `.github/FRONTMATTER-SCHEMA.md`.
- Keep `name` aligned with folder naming conventions.
- Keep `description` keyword-rich for better discovery.
- Keep detailed references in subfolders when SKILL.md grows large.

## Invocation Guidance
- Use skills for repeatable, domain-specific procedures.
- Use direct edits for one-off changes where no specialized workflow is needed.
