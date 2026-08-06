# Token Usage and Atlas: Why Shorter Chat Sessions Work Better

## Executive Summary

Atlas is designed for short, repeatable **chat sessions**. You can reset your AI agent's chat window (Claude Code, Copilot, ChatGPT, etc.) frequently and still maintain momentum because the repository itself carries the state via **devtasks**, **retro.md**, and **devcycle.md** — not the chat history. This design makes token budgeting predictable and allows deeper, more focused work per chat session.

**Validation framework:** This document is based on 2026 research on token efficiency best practices. Atlas's actual efficiency can be validated on real projects using the measurement framework in the "Validating Token Efficiency" section below.

## Terminology: Atlas Terms vs. Tool Terms

This document uses specific Atlas vocabulary. Here's what each term means:

| Term | Definition | Scope | Example |
|---|---|---|---|
| **Devtask (DT)** | A discrete unit of planned work in the current devcycle. Tracked in `devcycle.md`, recorded in `retro.md` with eMOE/aMOE. | Atlas process | DT1 = "Add customer dashboard" (3 CU) |
| **Reset Devtask (RDT)** | An unplanned task that interrupts the current devcycle. Inserted ahead of remaining DTs. | Atlas process | RDT1 = "Fix urgent auth bug" (2 CU, unplanned) |
| **Chat session** | An open Claude Code window, Copilot chat, ChatGPT conversation, or similar AI agent interface. State lives in chat history. | Tool (Claude Code, Copilot, etc.) | "Claude Code window open 9 AM–12 PM" |
| **Skill** | A reusable workflow guide (`.github/skills/SKILL.md`) invoked during devtask execution. Reads like a prompt but is invoked on-demand, not loaded by default. | Atlas process | `model-tier-advisor/SKILL.md` = guide for suggesting model tier per task complexity |
| **Prompt file** | A complete, self-contained workflow for a complex operation (e.g., `cgr.prompt.md`). Invoked explicitly by user or agent. | Atlas process | `.github/prompts/cgr.prompt.md` = governance review workflow |
| **Instruction file** | Core process rules and agent behaviors (e.g., `ATLAS.md`, `copilot-instructions.md`). Loaded at chat session start. | Atlas process | `ATLAS.md` = the dev cycle loop, task lifecycle, rules |
| **Devcycle** | The active burn-down list of current planned work (DTs + RDTs). Lives in `docs/agile/devcycle.md`. | Atlas process | "Active devcycle for Week 1: DT1, DT2, RDT1, DT3" |
| **Retro** | The completed work log. Each devtask moved to `docs/agile/retro.md` after UAT with eMOE, aMOE, notes. | Atlas process | Retro entry for DT1 = what was done, issues, decisions, lessons |
| **CGR** | Compliance and Governance Review. A structured workflow (`.github/prompts/cgr.prompt.md`) that reviews live project documents (MRD, PRD, ESD) for completeness, quality, and readiness. Produces `docs/cgr/CGR-results.md`. | Atlas process | Run after MRD/PRD/ESD are drafted to validate governance |
| **MRD** | Market Requirements Document. Captures market/business drivers, customer needs, competitive context. Lives in `docs/cgr/MRD.md`. | Governance artifact | "Customer needs real-time dashboards; competitors have them" |
| **PRD** | Product Requirements Document. Captures product vision, features, acceptance criteria, success metrics. Lives in `docs/cgr/PRD.md`. | Governance artifact | "Dashboard must show real-time sales, load in <2s, work offline" |
| **ESD** | Engineering Specification or Engineering Design. Captures technical architecture, API contracts, data models, implementation risks. Lives in `docs/cgr/ESD.md`. | Governance artifact | "Dashboard uses WebSocket for real-time, IndexedDB for offline" |

**Key insight:** Devtasks and skills live in the **repository** (git-tracked, persistent). Chat sessions are **ephemeral** (tool-specific, history lives in chat window). Governance docs (MRD/PRD/ESD) are long-lived project artifacts, reviewed via CGR workflow. Separating these concerns is what makes frequent chat-session resets efficient while preserving project state.

## The Token Cost Model

### The Quadratic Accumulation Problem (Why Long Sessions Cost More)

In continuous chat sessions without prompt caching, **input token cost grows quadratically**, not linearly:
- Step 1: Send prompt + task context (1k tokens)
- Step 2: Rebill entire history + new turn (2k tokens rebilled + new context)
- Step 3: Rebill entire history + new turn (3k tokens rebilled + new context)
- …
- Step 20: Rebill 20 accumulated turns worth of context + new turn

A 20-step agent loop can consume over **10x** the tokens that a per-step estimate suggests, because every API call rebills all prior context. This is the hidden cost of naive "long looper" sessions.

**Source:** [TokenPilot: Cache-Efficient Context Management for LLM Agents](https://arxiv.org/pdf/2606.17016), [Beyond the Context Window: A Cost-Performance Analysis](https://arxiv.org/pdf/2603.04814)

### How Prompt Caching Mitigates This (And Why Atlas Works Well With It)

Prompt caching (available on Anthropic Claude at 90% discount, OpenAI at 50% discount) allows repeated token prefixes to be reused at the KV cache level, eliminating the rebilling of static context on every call.

**With prompt caching enabled:**
- First session load: Pay full price for ATLAS.md, copilot-instructions.md, devcycle.md (~2–4k tokens)
- Subsequent turns in same session: Cached tokens cost 10% of original (or free if within cache window)
- New session: Cache miss on devcycle.md (it may have changed), but system prompts (ATLAS.md, instructions) remain cached

**Atlas's design aligns perfectly with caching:**
- Repository state (ATLAS.md, devcycle.md, skill files) is **immutable-ish** between turns → cacheable
- Each session pays one cold start, then adds new turns in a "cache breakpoint" zone
- Session resets after UAT avoid the quadratic accumulation curve by resetting the conversation history
- The repo ensures no context re-derivation (unlike naive session trimming, which breaks cache but loses state)

**Source:** [Prompt Caching 201](https://developers.openai.com/cookbook/examples/prompt_caching_201), [Anthropic Claude API Prompt Caching Guide](https://hidekazu-konishi.com/entry/anthropic_claude_api_prompt_caching_and_token_efficiency.html)

### One-Time Chat-Session Load (2–4k tokens, cached after first session)

Each session, the AI agent loads:
- `ATLAS.md` (~500 lines) — process rules, task lifecycle, definitions
- `.github/copilot-instructions.md` or `CLAUDE.md` (~170–400 lines) — tool-specific instructions
- `docs/agile/devcycle.md` — active task list (typically 50–200 lines of actual tasks, not the full template)

**Cost without caching:** ~2–4k tokens per session start.
**Cost with caching (2nd+ session):** ~0.2–0.4k tokens (90% discount on cached input).

### On-Demand Loads (minimal, additive)

- A single skill file when invoked: ~200–800 tokens (or ~20–80 if cached)
  - Example: `model-tier-advisor/SKILL.md` (~126 lines) when you start a devtask and ask for a model tier recommendation
- `docs/agile/retro.md` when recording completed work: ~50–500 tokens (depends on file size; grows over time)
- Prompt files only when explicitly requested: ~1–2k tokens
  - Example: `.github/prompts/cgr.prompt.md` (~500 lines) when you run CGR (Compliance and Governance Review)
  - This loads MRD/PRD/ESD templates and governance workflow, but only when you ask for CGR

**Key insight:** You only pay for what you use. Starting a governance review (CGR) costs extra tokens, but you can skip it entirely if not needed. **With caching, repeated skill/prompt loads (e.g., invoking model-tier-advisor in session 2) cost 90% less.**

### Per-Devtask Token Budget

A typical devtask with Atlas:

| Phase | Tokens | Notes |
|---|---|---|
| Devtask start (read devcycle.md, scope) | 500–2k | Reading the devtask entry and smoketest instructions |
| Implementation (explore, code, test) | 5k–50k | Depends on devtask complexity (eMOE/aMOE), not on Atlas overhead |
| Smoketest validation | 500–5k | CLI command output, script results, verification |
| Invoke model-tier-advisor skill (optional) | 500–800 | Getting a model tier suggestion; cost is part of devtask work |
| Retro recording (eMOE, aMOE, tokens, notes) | 500–2k | Writing structured log entry to `docs/agile/retro.md` |
| **Devtask total** | **7k–60k** | Typical range; Atlas overhead is <10% |

The one-time chat-session load (2–4k) is fixed; the devtask complexity drives the rest. Over multiple devtasks in one chat session, this fixed cost gets amortized.

## Why Shorter Sessions Work Well With Atlas

### 1. Avoid Quadratic Accumulation in Long Sessions

The research is clear: **a 20-turn continuous session can cost 10x more than it should**, because every turn rebills prior context.

**Quadratic accumulation scenario (no caching):**
```
Turn 1:  2k tokens → total 2k
Turn 2:  4k tokens (rebill turn 1) → total 6k
Turn 3:  6k tokens (rebill turns 1-2) → total 12k
Turn 10: 20k tokens (rebill turns 1-9) → total ~100k
```

**Resetting after 3–5 tasks prevents this:** Each session starts fresh context (2–4k), avoids rebilling prior work, and keeps cost linear instead of quadratic.

**With prompt caching**, this is less severe (cached tokens cost 10%), but quadratic behavior still happens if you keep generating new output past the cache limit.

**Source:** [TokenPilot](https://arxiv.org/pdf/2606.17016), [Beyond the Context Window](https://arxiv.org/pdf/2603.04814)

### 2. State Lives in the Repository, Not the Chat

Traditional workflows store state in chat history:
- "What did I do yesterday?" → Scroll back through 100+ messages
- Session limit hits → Lose context, have to re-summarize
- Token budget expires → Restart chat, paste old context back in

**Atlas approach:**
- Current state: `docs/agile/devcycle.md` (what's active right now)
- Completed work: `docs/agile/retro.md` (what shipped, with eMOE/aMOE)
- Progress: `docs/agile/status.md` (where we stand)

→ All of this is already committed to git. A new session reads it fresh; **no re-summarization, no re-derivation needed.**

### 3. Efficient Session Resets (With Caching)

You can close a session after:
- Completing UAT (the natural Definition of Done checkpoint)
- Finishing a focused build phase
- Running out of token budget
- End of workday

Then start a fresh session:

```
1. Open the repo in a new Claude Code session.
2. Say "atlas" or "hello" — copilot-instructions.md triggers the startup check-in.
3. Load ATLAS.md, devcycle.md from repo (2–4k tokens, or ~0.2–0.4k with caching).
4. Pick the next task and continue.
```

**With prompt caching:** The second+ session pays only ~200–400 tokens for cached system state (ATLAS.md, instructions), while maintaining full context consistency.

**Without caching:** You still win by avoiding quadratic accumulation, but each session pays the full 2–4k load cost.

### 4. Deeper, Clearer Work Per Session

Shorter, focused sessions mean:
- Fewer tasks per session → less task-switching overhead
- Clearer scope per session → easier to reason about
- Each session produces a clean commit + UAT sign-off → easier to review
- Token budget is predictable → you know how deep you can go
- Cognitive load is lower → fewer mistakes, less re-thinking

**Example:** Instead of one 8-hour session that juggles 10 tasks and accumulates 2M tokens of chat history, use three 2–3 hour focused sessions:
- Session 1: Implement feature A, test, commit, UAT sign-off (~30–40k tokens, one focused task)
- Break, review, plan
- Session 2: Implement feature B, test, commit, UAT sign-off (~30–40k tokens, one focused task)
- Break, review, plan
- Session 3: Implement feature C, test, commit, UAT sign-off (~30–40k tokens, one focused task)

Each session avoids quadratic accumulation, costs less total tokens, and produces a clear git commit with validated UAT.

## Practical Chat-Session Budget Strategy

### Conservative Budget (Claude Code free tier or API limit)

- Per-chat-session budget: 100k tokens
- One-time load (ATLAS.md, instructions, devcycle.md): 2–4k
- Available for devtask work: ~96–98k
- Typical devtask: 20–40k tokens
- Can do: 2–3 focused devtasks per chat session, then reset

### Comfortable Budget (Claude Code subscription or larger API quota)

- Per-chat-session budget: 500k tokens
- One-time load: 2–4k (or ~0.2–0.4k with prompt caching, session 2+)
- Available for devtask work: ~496–498k
- Can do: 10–15 focused devtasks, or deeper R&D on 2–3 complex devtasks

### Research/Exploration Budget

- Run `atlas` startup check-in: 2–4k
- Load one skill or prompt file: ~200–800 tokens
- Do deep exploration: remaining budget
- Reset chat session, commit findings to `docs/reference/`, close window

## When to Reset Your Chat Session

**The ideal reset point: After UAT on a devtask**

The natural checkpoint is **after UAT sign-off**, when a devtask is truly complete:
- Implementation done → commit
- Smoketest passed → confident it works
- UAT handed off or marked non-UAT-eligible → work is validated (Definition of Done)
- Devtask moved to `retro.md` with eMOE, aMOE, notes
- Next chat session: close this Claude Code window, open a fresh one, read `devcycle.md`, pick next devtask

This aligns with Atlas's Definition of Done and avoids starting a fresh chat session mid-devtask.

**Other good times to reset your chat session:**
- After 2–3 related devtasks (natural grouping point, avoids quadratic accumulation)
- When token usage is >70% of your budget (quadratic accumulation warning)
- End of workday (review state in retro.md, plan next day's devcycle)
- Before a major context shift (e.g., switching from backend to frontend work; saves re-loading context you won't use)
- When chat history gets long and noisy (150+ messages; increases quadratic cost)

**Optimal pattern (for one chat session):**
1. Read `docs/agile/devcycle.md` → pick DT1
2. Implement DT1, invoke skills as needed (e.g., `model-tier-advisor` for model suggestion)
3. Smoketest, complete UAT, commit, push
4. Move DT1 from devcycle.md to retro.md (record eMOE, aMOE, tokens)
5. **Reset: Close Claude Code window**
6. Open fresh Claude Code window, repeat with DT2

Each chat session produces 1–3 clean commits (one per devtask).

**Don't reset a chat session:**
- Mid-devtask (finish what you started, even if it takes 2 chat sessions within one devtask)
- Just because chat history is visible (visibility ≠ cost; quadratic accumulation is the cost driver)

## How the Model-Tier-Advisor Skill Fits In

The `model-tier-advisor` **skill** (`.github/skills/model-tier-advisor/SKILL.md`) helps you budget tokens per devtask:

A skill is a reusable workflow guide invoked during devtask execution. Unlike prompt files (which run complete workflows like CGR), skills guide tactical decisions within a devtask (like picking a model tier).

### Using model-tier-advisor in your workflow

1. **At devtask start:** Ask the agent to invoke `model-tier-advisor` to suggest a model tier based on eMOE CU
   - CU 1–2 → Haiku 4.5 (cheap, fast, good for mechanical work)
   - CU 3–5 → Sonnet 5 (balanced, best for most dev work)
   - CU 8+ → Opus 5 (strongest reasoning, best for complex decisions)
   - Cost: ~500–800 tokens to load the skill (or ~50–80 with caching)

2. **At devtask completion:** Log actual usage (Light/Moderate/Heavy) and aMOE in retro.md
   - Compare eMOE to aMOE to calibrate future estimates
   - Track which model tier actually fit the work
   - Add optional `Tokens: ~XXk` field to build your calibration curve

3. **Over time:** Refine your chat-session budget based on real aMOE data
   - "CU 3 devtasks in my project usually run 20–30k tokens with Sonnet 5"
   - "CU 8 devtasks need Opus 5 and typically use 50–80k tokens"
   - Plan chat sessions accordingly

## Reference: Atlas Files and Their Token Cost

| File | Type | Lines | Est. Tokens | When Loaded | Purpose |
|---|---|---|---|---|---|
| `ATLAS.md` | Instruction | ~500 | ~1.5k | Chat session start | Core process, definitions, rules |
| `.github/copilot-instructions.md` | Instruction | ~170 | ~0.8k | Chat session start (Copilot) | Tool-specific agent behaviors |
| `CLAUDE.md` | Instruction | ~30 | ~0.2k | Chat session start (Claude Code) | Thin pointer to copilot-instructions.md + ATLAS.md |
| `docs/agile/devcycle.md` | Process | ~50–100 | ~0.3–0.6k | When you pick a devtask | Active devtask burn-down (minimal; templates large but skipped) |
| `docs/agile/retro.md` | Process | Variable | ~1–3k | When you record devtask | Completed work log (grows over time, tracks eMOE/aMOE/tokens) |
| `docs/agile/status.md` | Process | ~30–50 | ~0.2–0.3k | Startup check-in | Current state summary |
| `.github/skills/model-tier-advisor/SKILL.md` | Skill | ~126 | ~0.5–0.8k | When invoked during devtask | Workflow guide for model tier suggestion per CU |
| `.github/prompts/cgr.prompt.md` | Prompt file | ~500 | ~2k | Only on explicit `CGR` request | Governance review workflow for MRD/PRD/ESD validation |

**Total for a fresh chat session (no extras):** 2–4k tokens.
**Total for a chat session with caching (2nd+ session):** ~0.2–0.4k tokens.

## Anti-Patterns: What Costs Too Many Tokens

- **Loading the entire retro.md history every session:** Read only the last 20–50 lines (today's and yesterday's work) unless you're doing analysis
- **Pasting chat history into a new session:** Don't. Read the repo state instead
- **Keeping the full devcycle.md template in memory:** The agent should skim active tasks, skip the template text
- **Running exploratory R&D in the chat without committing:** Do the R&D, commit findings to docs/reference/, then reference the doc instead of re-explaining in the chat

## Token Budgeting Example: A Full Day of Work

Assume: Three 2–3 hour **chat sessions**, Sonnet 5 model, ~500k token daily quota.

**Chat Session 1 (Morning, 9 AM – 12 PM)**
- Load ATLAS.md, instructions, devcycle.md: 2k
- Devtask DT1 (CU 3, add API route): 25k
- Devtask DT2 (CU 2, fix validation bug): 15k
- Record retro for DT1 + DT2: 3k
- Subtotal: ~45k
- Remaining: 455k
- **Reset chat session after DT2 UAT**

**Break / Review (read retro.md to confirm state)**

**Chat Session 2 (Afternoon, 1 PM – 4 PM)**
- Load ATLAS.md, instructions, devcycle.md: 2k (0.2k with caching)
- Devtask DT3 (CU 5, refactor auth middleware): 40k
- Smoketest + security review: 10k
- Record retro for DT3: 3k
- Subtotal: ~55k
- Remaining: 400k
- **Reset chat session after DT3 UAT**

**Break / Review (read retro.md to confirm state)**

**Chat Session 3 (Late afternoon, 4 PM – 6 PM)**
- Load ATLAS.md, instructions, devcycle.md: 2k (0.2k with caching)
- Devtask RDT1 (CU 2, urgent config fix): 12k
- Devtask DT4 (CU 1, update docs): 8k
- Run `atlas` startup check-in (end-of-day review): 2k
- Record retro for RDT1 + DT4: 2k
- Subtotal: ~26k
- Remaining: 374k
- **Close chat session; end of day**

**Total day:** 126k tokens used, 374k remaining. Could run 2–3 more chat sessions at this pace, or run a governance review (CGR: 20–30k, invokes `.github/prompts/cgr.prompt.md` and reviews MRD/PRD/ESD) and still have room.

**Key observations:**
- Each chat session loads 2k (fixed cost), but with prompt caching, sessions 2+ cost only ~0.2k
- Three devtasks fit comfortably in one chat session
- Resetting after UAT prevents quadratic accumulation over the day
- Retro entries build your calibration data (track actual tokens per CU)

## Validating Token Efficiency: How to Gather Real Data

This document synthesizes 2026 research on token efficiency, prompt caching, and context management. The following framework lets you measure whether these principles actually reduce tokens in your project's workflow.

**How to gather evidence in your project:**

### 1. Track Tokens + eMOE/aMOE in retro.md

Add an optional `Tokens: ~XXk` field to each completed task's retro entry:

```markdown
### DT1 -- Add customer dashboard | eMOE: 3 CU | aMOE: 3 CU
What was done: ...
Tokens: ~18k (6 tool calls, 4 files, 8 turns on Sonnet 5)
Model Fit: Sonnet 5 matched; could downgrade future CU 2 to Haiku 4.5
Issues hit: ...
Decisions made: ...
Lessons learned: ...
```

### 2. Build a CU-to-Token Calibration Curve

After 20+ completed tasks, plot your data:
- X-axis: eMOE in CU (1, 2, 3, 5, 8)
- Y-axis: Actual tokens used per task
- Group by model tier (Haiku, Sonnet, Opus)

You'll discover your project's real token budget per CU.

### 3. Compare Two Approaches (The Gold Standard)

**Week 1: Use Atlas (repo state, session resets after UAT)**
- Track tokens per task via retro.md
- Note: session start costs, load times, cache hit rates (if your tool supports it)
- Track task count, average tokens per CU

**Week 2: Use same tasks with continuous long sessions (no resets)**
- Keep session open across multiple tasks (5–10 tasks)
- Log token usage at each task boundary (tool-dependent; Claude Code shows usage, Copilot may not)
- Same analysis: tokens per task, tokens per CU

**Then compare:**
- Week 1 total tokens vs. Week 2 total tokens (for same work)
- Per-task token variance (more consistent in Atlas?)
- Quality metrics (same? better? worse?)
- Cognitive load (how hard was it to keep context?)

### 4. Measure Cache Hit Rates (If Using Prompt Caching)

If your tool (Claude Code, Anthropic API) supports prompt caching:
- Log cache hit/miss on each session start
- Track cached tokens vs. rebilled tokens
- Measure time savings (cached tokens are prefilled faster; TTFT should drop)

**Example log entry:**
```
Session 2, Task start:
- Cached tokens: 2,400 (ATLAS.md, copilot-instructions.md, prior devcycle.md)
- Cost: ~240 tokens (90% discount applied)
- New tokens: 300 (updated devcycle.md, task-specific context)
- Total input: 540 tokens (vs. 2,700 without caching)
```

### 5. Track Quadratic Accumulation (Long Session Baseline)

If you run a long session (10+ tasks, 1000+ messages):
- Export token usage data (if available from your tool)
- Plot tokens per turn over time
- Does it flatten (caching working) or climb (quadratic accumulation)?

This is the key validation: does quadratic accumulation actually happen in your real workflow, or is it academic?

### Research Sources

These are the empirical foundations for the claims in this document:

- **Quadratic accumulation in agent loops:** [TokenPilot: Cache-Efficient Context Management for LLM Agents](https://arxiv.org/pdf/2606.17016), [Beyond the Context Window: Cost-Performance Analysis](https://arxiv.org/pdf/2603.04814)
- **Prompt caching ROI:** [Prompt Caching 201](https://developers.openai.com/cookbook/examples/prompt_caching_201), [Anthropic Claude API Prompt Caching Guide](https://hidekazu-konishi.com/entry/anthropic_claude_api_prompt_caching_and_token_efficiency.html) (90% discount on cached input tokens)
- **Context management best practices:** [Context Window Management Strategies](https://www.getmaxim.ai/articles/context-window-management-strategies-for-long-context-ai-agents-and-chatbots/)
- **General token optimization:** [LLM Token Optimization Guide 2026](https://www.tokenoptimize.dev/guides/llm-token-optimization-strategies)

**Takeaway:** Atlas's design aligns with current token-efficiency best practices. Use the measurement framework above to validate these benefits in your project.

## Key Takeaway

Atlas isn't token-cheap because it's small; it's designed to be token-efficient because it:
- **Avoids quadratic accumulation** by resetting sessions after UAT (natural checkpoint)
- **Enables prompt caching** by keeping repo state immutable and re-loadable
- **Prevents re-derivation** by storing state in git instead of chat history
- **Tracks effort calibration** by linking tokens to eMOE/aMOE in retro.md

The 2–4k per-session load is a fixed cost. The real savings come from resetting often, using prompt caching with immutable repo state, and avoiding the hidden cost of managing state in chat history instead of git.

**Validation:** Use the CU-to-token calibration framework above to prove (or refute) these benefits in your project.

## See Also

- `ATLAS.md` — core process and definitions
- `.github/skills/model-tier-advisor/SKILL.md` — per-task model selection and CU-based usage tracking
- `docs/agile/devcycle.md` — active task list (read this to pick your next work)
- `docs/agile/retro.md` — completed work log with eMOE/aMOE (add `Tokens:` field to build calibration data)
