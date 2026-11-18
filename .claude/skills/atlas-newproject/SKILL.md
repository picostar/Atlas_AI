---
name: atlas-newproject
description: Route Atlas new-project setup requests to the authoritative prompt-first workflow before any target files are changed.
---

# Atlas New Project Router

Use this skill when a user asks to set up, bootstrap, initialize, or start an Atlas project, including requests that reference `github/picostar/Atlas_AI` or its `README.md`.

1. Read `README.md` from the Atlas_AI source kit.
2. Read `atlas_newproject.md` completely.
3. Follow that prompt as the source of truth.
4. Ask exactly one unanswered setup question per assistant turn, then stop and wait for the user's reply before continuing the required questionnaire. Do not batch questions or substitute recommended settings. Follow `atlas_newproject.md` for explicit answers or requested defaults, conditional questions, and final placement-plan confirmation before changing target files.
5. Do not report completion until the required Atlas validation gate passes.

Do not duplicate the setup procedure here. If this skill conflicts with `atlas_newproject.md`, the root prompt wins.
