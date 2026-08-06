# Token Usage and Atlas: Why Shorter Sessions Work Better

## Executive Summary

Atlas is designed for short, repeatable sessions. You can reset your AI chat session frequently and still maintain momentum because the repository itself carries the state, not the chat history. This design makes token budgeting predictable and allows deeper, more focused work per session.

## The Token Cost Model

### One-Time Session Load (2–4k tokens)

Each session, the AI agent loads:
- `ATLAS.md` (~500 lines) — process rules, task lifecycle, definitions
- `.github/copilot-instructions.md` or `CLAUDE.md` (~170–400 lines) — tool-specific instructions
- `docs/agile/devcycle.md` — active task list (typically 50–200 lines of actual tasks, not the full template)

**Cost:** ~2–4k tokens per session start. This is a one-time cost; it doesn't repeat within the session.

### On-Demand Loads (minimal, additive)

- A single skill file when invoked: ~200–800 tokens
- `docs/agile/retro.md` when recording completed work: ~50–500 tokens (depends on how much history is in the file)
- Prompt files (CGR, realign, etc.) only when explicitly requested

**Key insight:** You only pay for what you use. Starting CGR or running a governance review costs extra tokens, but skipping those steps saves them.

### Per-Task Token Budget

A typical dev task with Atlas:

| Phase | Tokens | Notes |
|---|---|---|
| Task start (pick DT, read scope) | 500–2k | Usually just reading devcycle.md entry and smoketest instructions |
| Implementation (explore, code, test) | 5k–50k | Depends on task complexity (eMOE/aMOE), not on Atlas overhead |
| Smoketest validation | 500–5k | CLI command output, script results, verification |
| Retro recording (eMOE, aMOE, notes) | 500–2k | Writing structured log entry to retro.md |
| **Task total** | **7k–60k** | Typical range; Atlas overhead is <10% |

The overhead is fixed (~2–4k per session); the task complexity drives the rest.

## Why Shorter Sessions Work Well With Atlas

### 1. State Lives in the Repository, Not the Chat

Traditional workflows store state in chat history:
- "What did I do yesterday?" → Scroll back through 100+ messages
- Session limit hits → Lose context, have to re-summarize
- Token budget expires → Restart chat, paste old context back in

**Atlas approach:**
- Current state: `docs/agile/devcycle.md` (what's active right now)
- Completed work: `docs/agile/retro.md` (what shipped, with eMOE/aMOE)
- Progress: `docs/agile/status.md` (where we stand)

→ All of this is already committed to git. A new session reads it fresh; no re-summarization needed.

### 2. Resetting Sessions is Efficient

You can close a session after:
- Completing one task (commit + push)
- Finishing a focused build phase
- Running out of token budget
- End of workday

Then start a fresh session:

```
1. Open the repo in a new Claude Code session.
2. Say "atlas" or "hello" — copilot-instructions.md triggers the startup check-in.
3. Read current state from devcycle.md and status.md (fresh load, ~2–4k tokens).
4. Pick the next task and continue.
```

**No context recovery needed.** You don't copy-paste old work; you read what's already in the repo.

### 3. Deeper, Clearer Work Per Session

Shorter, focused sessions mean:
- Fewer tasks per session → less task-switching overhead
- Clearer scope per session → easier to reason about
- Each session produces a clean commit → easier to review
- Token budget is predictable → you know how deep you can go

**Example:** Instead of one 8-hour session that juggles 10 tasks and tries to navigate 2M tokens of chat history, use three 2–3 hour focused sessions:
- Session 1: Implement feature A, test, commit (30–40k tokens, one focused task)
- Break, review, plan
- Session 2: Implement feature B, test, commit (30–40k tokens, one focused task)
- Break, review, plan
- Session 3: Implement feature C, test, commit (30–40k tokens, one focused task)

Each session is cheaper on total tokens (less chat noise, less re-reading), and each produces a clear git commit.

## Practical Session Budget Strategy

### Conservative Budget (Claude Code free tier or API limit)

- Per-session budget: 100k tokens
- One-time load: 2–4k
- Available for work: ~96–98k
- Typical task: 30–40k
- Can do: 2–3 focused tasks per session, then reset

### Comfortable Budget (Claude Code subscription or larger API quota)

- Per-session budget: 500k tokens
- One-time load: 2–4k
- Available for work: ~496–498k
- Can do: 10–15 focused tasks, or deeper R&D on 2–3 complex tasks

### Research/Exploration Budget

- Run `atlas` startup check-in: 2–4k
- Load one skill or prompt file: 200–800k
- Do deep exploration: remaining budget
- Reset session, commit findings

## When to Reset a Session

**Good times to reset:**
- After completing and committing a task (natural checkpoint)
- When token usage is >70% of your budget
- End of workday (plan next day from fresh context)
- Before a major context shift (e.g., switching from backend to frontend work)
- When chat history gets long and noisy (150+ messages)

**Don't reset just because:**
- A task failed — re-try, learn, commit the fix
- You ran into a blocker — pivot to an RDT instead
- Multiple related tasks remain — finish the phase, then reset

## How the Model-Tier-Advisor Fits In

The new `model-tier-advisor` skill helps you budget tokens per task:

1. **At task start:** Get a suggested model tier based on eMOE CU
   - CU 1–2 → Haiku 4.5 (cheap, fast, good for mechanical work)
   - CU 3–5 → Sonnet 5 (balanced, best for most dev work)
   - CU 8+ → Opus 5 (strongest reasoning, best for complex decisions)

2. **At task completion:** Log actual usage (Light/Moderate/Heavy) and aMOE
   - Compare eMOE to aMOE to calibrate future estimates
   - Track which model tier actually fit the work

3. **Over time:** Refine your session budget based on real aMOE data
   - "CU 3 tasks in my project usually run 20–30k tokens with Sonnet 5"
   - "CU 8 tasks need Opus 5 and typically use 50–80k tokens"
   - Plan sessions accordingly

## Reference: Atlas Files and Their Token Cost

| File | Lines | Est. Tokens | When Loaded | Purpose |
|---|---|---|---|---|
| `ATLAS.md` | ~500 | ~1.5k | Session start | Core process, definitions, rules |
| `.github/copilot-instructions.md` | ~170 | ~0.8k | Session start (Copilot) | Tool-specific instructions |
| `CLAUDE.md` | ~30 | ~0.2k | Session start (Claude Code) | Thin pointer to copilot-instructions.md + ATLAS.md |
| `docs/agile/devcycle.md` | ~50–100 | ~0.3–0.6k | When you pick a task | Active task list (minimal; templates are large but skipped) |
| `docs/agile/retro.md` | Variable | ~1–3k | When you record work | Completed work log (grows over time) |
| `docs/agile/status.md` | ~30–50 | ~0.2–0.3k | Startup check-in | Current state summary |
| Single skill (e.g., `model-tier-advisor`) | ~120 | ~0.5–0.8k | When invoked | Process guidance for specific work |
| `.github/prompts/cgr.prompt.md` | ~500 | ~2k | Only on explicit `CGR` request | Governance review workflow |

**Total for a fresh session with no extras:** 2–4k tokens.

## Anti-Patterns: What Costs Too Many Tokens

- **Loading the entire retro.md history every session:** Read only the last 20–50 lines (today's and yesterday's work) unless you're doing analysis
- **Pasting chat history into a new session:** Don't. Read the repo state instead
- **Keeping the full devcycle.md template in memory:** The agent should skim active tasks, skip the template text
- **Running exploratory R&D in the chat without committing:** Do the R&D, commit findings to docs/reference/, then reference the doc instead of re-explaining in the chat

## Token Budgeting Example: A Full Day of Work

Assume: Three 2–3 hour sessions, Sonnet 5 model, ~500k token daily quota.

**Session 1 (Morning, 9 AM – 12 PM)**
- Load Atlas: 2k
- Task DT1 (CU 3, add API route): 25k
- Task DT2 (CU 2, fix validation bug): 15k
- Commit, push, record retro: 3k
- Subtotal: ~45k
- Remaining: 455k

**Break / Review**

**Session 2 (Afternoon, 1 PM – 4 PM)**
- Load Atlas: 2k
- Task DT3 (CU 5, refactor auth middleware): 40k
- Smoketest + security review: 10k
- Commit, push, record retro: 3k
- Subtotal: ~55k
- Remaining: 400k

**Break / Review**

**Session 3 (Late afternoon, 4 PM – 6 PM)**
- Load Atlas: 2k
- Task RDT1 (CU 2, urgent config fix): 12k
- Task DT4 (CU 1, update docs): 8k
- Run `atlas` closeout check: 2k
- Commit, push to main: 2k
- Subtotal: ~26k
- Remaining: 374k

**Total day:** 126k tokens used, 374k remaining. Could do 2–3 more sessions at this pace, or run a governance review (CGR: 20–30k) and still have room.

## Key Takeaway

Atlas isn't token-cheap because it's small; it's token-efficient because it keeps you from wasting tokens on:
- Re-explaining what you did in the last session
- Searching through old chat history for context
- Managing state in the chat instead of the repo
- Repeating the same setup steps in every session

The 2–4k per-session load is a fixed cost. The real savings come from resetting often and letting the repository be your state machine.

## See Also

- `ATLAS.md` — core process and definitions
- `.github/skills/model-tier-advisor/SKILL.md` — per-task model selection and usage tracking
- `docs/agile/devcycle.md` — active task list (read this to pick your next work)
- `docs/agile/retro.md` — completed work log (read to understand what shipped and calibrate effort)
