---
name: example-skill
description: 'Example skill template. Use when creating a new skill to see the expected structure, frontmatter format, and body layout.'
argument-hint: 'Describe the skill you want to create'
---

# Example Skill

## When to Use

- As a reference when creating new skills
- To verify the skill discovery mechanism is working

## Procedure

1. Copy this folder and rename it to match your new skill name
2. Update the `name` field in frontmatter to match the folder name
3. Write a keyword-rich `description` so the agent can discover it
4. Replace this body with your skill's step-by-step instructions
5. Add supporting files in subfolders as needed:
   - `./scripts/` -- executable code the skill invokes
   - `./references/` -- supplemental docs loaded on demand
   - `./assets/` -- templates or boilerplate files

## Structure

```
.github/skills/<skill-name>/
  SKILL.md           # Required -- must match folder name
  scripts/           # Optional -- runnable scripts
  references/        # Optional -- extra docs
  assets/            # Optional -- templates, config samples
```

## Rules

- Folder name must match the `name:` frontmatter field (lowercase, hyphens, no spaces)
- Keep SKILL.md under 500 lines; offload detail to `./references/`
- Use relative paths (`./scripts/run.ps1`) for all skill resources
- Make the description keyword-rich so the agent finds it automatically
- Before asking the user for credentials, tokens, keys, or other secret values, check `secrets.md` at the repository root first if it exists
- Do not place secrets in any other file by default; if the user requests an override, warn first and proceed only after confirmation
