# ChatGPT Instructions

Read `.github/copilot-instructions.md` first. That file is the source of truth.

If the user asks to set up or bootstrap an Atlas project, including a request that references `github/picostar/Atlas_AI` or its `README.md`, read the source-kit `README.md`, `.atlas/install-manifest.json`, and `atlas_newproject.md` before changing target files. Do not report completion until Atlas validation passes.

For local secrets, use `secrets.md` at repo root only. Do not place secrets in any other file by default, and only use an alternate location after explicit user override plus warning.

For non-secret cloud account and deployment destination binding, use committed `accounts.md` at repo root. Check it before cloud, hosting, infrastructure, deployment, or provider CLI work, and do not put credentials or keys in it.

Then read `ATLAS.md` for the default development process.

If `patterns/stack-patterns/active-stack-pattern.md` exists and the task affects architecture, hosting, deployment, infrastructure, or platform selection, treat it as the current stack baseline.

If `patterns/ux-patterns/active-ux-pattern.md` exists and the task affects layout, navigation, page hierarchy, interaction flow, or UI generation, treat it as the current UX baseline.

Read `docs/cgr/PS.md` only when the project uses formal release stages (EVT, DVT, PVT, GA) and document gates (MRD, PRD, ESD).

Read `.github/prompts/cgr.prompt.md` only when governance review or stage-gate compliance review is requested.

If your ChatGPT environment does not auto-load repository instruction files, load this file, `.github/copilot-instructions.md`, and `ATLAS.md` manually at session start.

Response guidelines are defined in `.github/copilot-instructions.md`. Do not duplicate them here.
