# Prompt And Skill Frontmatter Schema

This file documents expected frontmatter fields for prompt and skill files.

## Prompt Files (`.github/prompts/*.prompt.md`)

Recommended fields:
- `name`: human-friendly prompt name
- `description`: short usage description
- `argument-hint`: optional guidance for user-supplied arguments
- `agent`: optional target agent hint, default is current agent

Example:

```yaml
---
name: "ATLAS Realignment Check"
description: "Run an ATLAS health check and realignment review"
argument-hint: "Optional focus scope"
agent: "agent"
---
```

## Skill Files (`.github/skills/<skill>/SKILL.md`)

Required fields:
- `name`: skill identifier matching folder name style
- `description`: keyword-rich skill discovery text

Optional fields:
- `argument-hint`: optional usage hint

Example:

```yaml
---
name: project-setup
description: "Set up a project with atlas_ai"
argument-hint: "Optional setup scope"
---
```

The five Atlas workflow skills use stable lowercase command names as their `name`. Do not copy the legacy human-friendly prompt title into a skill name, or add `disable-model-invocation: true`; ordinary phrases such as `CGR` must remain eligible to select the skill.

## Conventions
- Use lowercase-hyphen names for skills.
- Keep descriptions specific and keyword-rich.
- Keep schema stable across prompts and skills.
