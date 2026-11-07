# Atlas_AI vs Paseo.sh

## Complete-capability comparison: development operating system versus agent execution platform

**Prepared:** 7 November 2026  
**Atlas source:** [picostar/Atlas_AI](https://github.com/picostar/Atlas_AI)  
**Paseo source:** [paseo.sh](https://paseo.sh/) and [official documentation](https://paseo.sh/docs)  
**Scope:** Capabilities, orchestration, governance, integrations, operational behavior, and strategic fit. The mobile/desktop app interface is not the basis of this comparison.

> **Scope convention:** All Atlas development-cycle (DC), backlog (BL), and GitHub-issue deliverables are treated as **Done** in this comparison, as requested. “Done” in the issue ledger is a **complete-capability modeling assumption**, not a certification that every change has been merged into the live GitHub repository. Paseo capabilities are compared against its published documentation as inspected on 7 November 2026. Neither product was independently subjected to a full end-to-end parity benchmark for this report.

## Executive summary

**Atlas_AI is the AI software development operating system. Paseo is the AI agent execution platform.**

This report compares the complete Atlas_AI engineering scope with Paseo.sh's documented agent-runtime capabilities. In the Atlas comparison baseline, every development cycle (DC), backlog item (BL), and all 34 GitHub issue deliverables are marked **Done**, including the seven orchestration work units under Issue #41. This is an analytical scope convention, not a statement that all live GitHub issues have been closed.

### Capability comparison at a glance

| Area | Advantage | Why |
|---|---|---|
| Requirements and planning | **Atlas** | MRD, PRD, ESD, backlog, DC/DT lifecycle and acceptance criteria. |
| Discovery and architecture | **Atlas** | Research, ADR approval, traceable decisions, reusable stack and UX patterns. |
| Multi-agent orchestration | **Comparable** | Both coordinate parallel AI workers and isolated Git worktrees. |
| Development quality | **Atlas** | Repeatable smoke tests, UAT, regression evidence and release gates. |
| Engineering governance | **Atlas** | Accountable owners, approval boundaries, audit evidence, retrospectives and closeout. |
| Model and cost optimization | **Atlas for engineering accounting** | Complexity Units, model-fit guidance, task-level usage evidence and cost tracking. |
| Continuous autonomous operation | **Paseo** | Scheduling, heartbeats and event-triggered execution. |
| Remote agents | **Paseo** | Persistent sessions and operation across machines. |
| Runtime extensibility | **Paseo** | CLI, SDK, MCP, plugins and agent execution interfaces. |

### The architectural opportunity

Atlas defines how software development work progresses from requirements through verified delivery. Paseo supplies much of the infrastructure for running that work autonomously.

```text
Atlas_AI
Requirements · Discovery · DC/BL · Governance · Verification
                          |
                          v
                Paseo execution layer
        Dispatch · Parallel workers · Sessions
             Recovery · Scheduling · Events
                          |
             +------------+------------+
             |            |            |
           Copilot       Claude       Codex
             +------------+------------+
                          |
                          v
             Git · GitHub · CI/CD
```

Atlas remains the authority for task identity, priority, requirements, decisions, acceptance and persistent evidence. Paseo can be an interchangeable backend for agent execution rather than a replacement for the Atlas development contract.

### Three conclusions

1. **Atlas has greater engineering-process depth.** It defines what correct, complete and verifiable software delivery means, not merely how coding agents run.
2. **Paseo has greater autonomous runtime capability.** It offers persistent execution, recurring work, remote operation and event-triggered automation beyond the specified Atlas issue scope.
3. **Their orchestration capabilities overlap substantially.** Building every runtime feature inside Atlas risks duplicating infrastructure that Paseo already provides.

### Recommendation

Keep Atlas independent of a particular agent execution platform. Make its orchestration backend pluggable, evaluate Paseo as one backend, and retain Atlas as the source of truth for requirements, DC/BL records, approvals, testing and delivery evidence.

**Bottom line:** Atlas determines *what to build, how to build it, and whether it is done correctly*. Paseo provides infrastructure for *getting agents to execute that work continuously and autonomously*. Together they can offer a more complete AI software development system than either alone.

---

## 1. Executive assessment

**Atlas_AI** is a portable AI-assisted software engineering operating system: an explicit contract for requirements, discovery, architecture decisions, implementation, human accountability, evidence-backed verification, release governance, and organizational learning. With the entire DC/BL/issue scope incorporated, Atlas also supplies team and multi-agent orchestration, worktree-based execution, supervised integration, recovery, and cross-agent portability.

**Paseo** is a local-first execution, session, and orchestration platform for coding agents. Its principal capabilities are launching and controlling provider CLIs, running concurrent agents and worktrees, maintaining sessions, delegating to other agents, scheduling recurrent work, triggering agents from external events through Hub, managing remote machines, and exposing programmatic APIs. It does not ship the underlying models or coding agents; the relevant CLIs and credentials must be installed/configured on the target host. [Paseo providers](https://paseo.sh/docs/providers), [orchestration](https://paseo.sh/docs/orchestration).

**Core result:** Atlas has the stronger **engineering management and assurance contract**. Paseo has the stronger **general-purpose runtime and unattended/event-driven operations platform**. Their overlap is substantive in orchestration and Git worktrees, but their differentiated capabilities are complementary, not mutually exclusive.

**Recommended architecture:** Preserve Atlas as the authority for project state, task claims, approvals, acceptance, and evidence. Use a pluggable execution adapter, with Paseo as a serious backend candidate for agent/session orchestration. Avoid reproducing Paseo's general daemon, scheduling, relay, Hub, and SDK solely to deliver Atlas DC/BL outcomes unless a measured capability gap requires it.

### Interpretation of capability labels

- **Native**: explicitly documented as part of the product/platform itself.
- **Process-enforced**: delivered by Atlas's instructions, skills, schemas, validation contract, and orchestrator, contingent on supported agents following/verifying the contract.
- **Composable**: feasible using existing tools or user-authored instructions but not an equivalent product-level obligation.
- **Not specified**: not established in the reviewed public sources; this is **not** proof that the feature is impossible.
- **Done (Atlas)**: included in the requested complete-capability model, irrespective of live GitHub issue state.

## 2. Full comparison matrix

| Capability | Atlas_AI (all DC/BL/issues Done) | Paseo documented capability | Assessment |
|---|---|---|---|
| Purpose | Engineering process, governance, and reproducible delivery | Coding-agent runtime, workspace, and coordination | Different primary layer |
| Underlying LLM / coding agent | Uses connected Copilot, Codex, Claude and supported agents | Runs configured provider CLIs; native and ACP adapters | Neither creates a foundation model |
| Provider selection | Capability matrix, CU-based advisory, automatic/multi-model routing evidence | Provider and model choice; saved profiles, specialties | Paseo stronger launch surface; Atlas stronger rationale |
| Task creation | BL intake, DC selection, DT/RDT, stable IDs and acceptance | Launch an agent with a prompt/task; programmable workflows | Atlas stronger semantics |
| Dependencies and claims | Owner/executor, dependencies, task claim, conflict serialization | Agent/workspace orchestration; can implement task rules | Atlas stronger contract |
| Multi-agent delegation | Orchestrator, native CLI workers, supervised fan-out | Agents can launch, message, and supervise agents | Both capable |
| Concurrent isolation | Git branch/worktree per worker, controlled integration | Automatic separate worktrees/workspaces | Both; isolation is not sandboxing |
| Failure recovery | Bounded retry/resume, interrupted worker/orchestrator recovery | Session continuation, agent controls, schedule/heartbeat operation | Different guarantees; benchmark needed |
| Multi-person coordination | Explicit owners, integrator, shared-document authority | Multiple machines/Hub workflows and agent sessions | Atlas stronger accountability; Paseo stronger infrastructure |
| Requirements | MRD, PRD, ESD, requirements gate, CGR | Can create documents via agents | Atlas |
| Discovery | Resumable conversational research, evidence, alternatives | Agent-driven research available | Atlas |
| Architecture decisions | Proposed/Accepted/Rejected/Superseded ADR lifecycle and approval | User instructions can implement ADRs | Atlas |
| Reusable patterns | Stack, UX, API, security and domain patterns; approval gate | Reusable skills, profiles, plugins | Different kind of reuse |
| Verification | Repeatable CLI, API, browser/tool evidence; explicit results | Agent terminal, browser, diff and review tools | Atlas assurance layer atop tools |
| UAT | Human acceptance distinct from agent verification | User can inspect/test agents' work | Atlas explicitly separates authority |
| Preview | Safe staged non-production preview with recorded deferred gates | Workspace testing, running local app/browser | Complementary |
| Release governance | DoD, receipts, integration checks, PR and review gates | Git/PR/worktree flows; provider-controlled actions | Atlas explicit policy |
| GitHub | Optional linked issues/PRs; Markdown remains source of truth | PR-aware worktrees and GitHub tooling/Hub events | Different authority model |
| Session persistence | Portable task records and restart identity | Daemon-backed ongoing agent sessions | Paseo richer runtime session abstraction |
| Recurring jobs | No equivalent general-purpose scheduler specified in Atlas issues | Cron schedules starting fresh agents | Paseo |
| Same-agent periodic continuation | No equivalent generic heartbeat service specified | Cron-backed heartbeats to an existing agent | Paseo |
| Event-driven execution | Integrations and CI patterns, not a generic GitHub/Slack/Discord trigger engine | Hub supports GitHub, Slack, Discord events and workflows | Paseo |
| Remote execution | Adapters/worker portability, environment dependent | Remote host control and multi-machine daemon model | Paseo |
| General programming API | Process schemas and tool interfaces; no Paseo-class session API mandated | CLI, MCP, TypeScript SDK, plugin hooks | Paseo |
| Cost management | Per-task CU/eMOE/aMOE, optional Credits, weekly comparative rollups | Provider/model settings and visible usage where exposed | Atlas stronger allocation/accounting framework |
| Audit/evidence | DT receipts, decision provenance, test records, retros, source revision | Session logs, workspace/git evidence, Hub activity | Complementary |
| Security model | Approval boundaries, secrets, data classification, governed releases | Daemon and transport security, provider permissions, Hub controls | Different layers; both required |
| Portability | Markdown-first, agent/tool-independent, GitHub optional | Host-based system with SDK/CLI/MCP, provider CLIs required | Atlas stronger process portability |
| Extensibility | Skills, patterns, lifecycle prompts, and adapter contracts | TypeScript plugins, RPC hooks, SDK and ACP | Paseo stronger runtime extension points |

**Overall:** Atlas wins the definition and verifiability of *what constitutes correct engineering progress*. Paseo wins the breadth of *how and when agents execute*.

## 3. Atlas's complete engineering contract

### 3.1 Project initiation and adoption

Atlas includes an installer with minimal and full profiles, a questionnaire driven by the install manifest, tool-specific entry files, a generated setup receipt, validation, legacy update planning, zero-install session mode, and a deliberate clean/uninstall workflow. Project content is preserved rather than indiscriminately relocated. A reference-graph validator identifies broken paths across optional installed components. Supported runtime configurations have explicit evidence, not merely a declared compatibility label.

Atlas remains **prompt-first** rather than requiring a particular daemon or standalone app. The consistent contract can be used by appropriate Copilot, Codex, Claude and other repo-aware agents, using documented loading routes and explicit-read fallbacks when necessary.

### 3.2 Requirements and product/engineering governance

Atlas connects business intent to engineering execution through:

1. **MRD:** market problem, customer and business motivation.
2. **PRD:** product scope, functional/nonfunctional requirements, acceptance criteria.
3. **ESD:** architecture, interfaces, reliability, security, operations, constraints.
4. **CGR:** compliance and governance review, gaps and remediation evidence.
5. **Requirements gate:** a clear decision on which requirement artifacts are mandatory before implementation.
6. **Project-stage gates:** optional EVT, DVT, PVT and GA rules for appropriate products.

Paseo agents may generate these artifacts, but Paseo does not itself define an equivalent mandatory MRD → PRD → ESD → CGR engineering lifecycle. This is a **product-level difference in assurance**, not a claim that Paseo agents lack the intelligence to perform requirements work.

### 3.3 Discovery, ADR and pattern promotion

Atlas defines separate transitions:

```text
Question / business need
       |
       v
Conversational discovery
(evidence, alternatives, tradeoffs, unresolved questions)
       |
       v
Proposed ADR ---------> Deferred / Rejected
       |
  explicit approval
       v
Accepted ADR
       |
  separate approval for a reusable baseline
       v
Stack / UX / domain pattern
       |
  explicit implementation authorization
       v
Backlog -> Devcycle -> Devtasks
```

A discovery is not an engineering decision. A proposed ADR is not an accepted ADR. An accepted ADR is not a shipped implementation. A project-specific decision is not automatically a reusable organizational pattern. Superseded records remain traceable. The workflow is designed to make current best-practice research useful to domain experts without silently authorizing code changes.

### 3.4 Devcycles, backlog and task execution

**Portable authoritative records:**

| Artifact | Function | Authority |
|---|---|---|
| `docs/agile/backlog.md` | Intake, prioritization, deferred scope | Atlas planning authority |
| `docs/agile/devcycle.md` | Active DC and unfinished DT/RDT commitments | Atlas execution-plan authority |
| `docs/agile/status.md` | Current project state and handoff | Derived synchronized project view |
| `docs/agile/retro.md` | Completed DT records, lessons, measured effort | Durable completed-work evidence |
| `docs/agile/cost.md` | Credits/CU and model/provider trends | Cost analysis, sourced from observed usage |
| `docs/cgr/` and `docs/adr/` | Requirements, design, decisions, governance | Durable decision and review provenance |
| Optional GitHub issues/PRs | Discussion, code review, external evidence | Linked coordination, not a replacement for Markdown |

A DT has a stable identity, description, eMOE in Complexity Units, dependencies, owner/executor, acceptance criteria, and explicit verification. RDTs capture interruptions without losing the active DC. Claims prevent duplicate agents taking the same work, and an integrator serializes updates to shared records. Completed items move from `devcycle.md` into the retro, preserving an accurate burn-down.

**Complexity Units (CU)** represent uncertainty, decision load, dependencies, and validation burden rather than elapsed human hours. Atlas tracks `eMOE` at selection and `aMOE` at completion and can compare model fit and observed credits where actually available. Agent runtimes cannot be assumed to expose a precise token or cost count.

### 3.5 Verification, closeout, and delivery

An Atlas DT is **not complete** merely because the worker says it is. The complete contract includes:

- A reproducible verification plan with target environment, steps/commands, expected signal, observed result, and evidence location.
- CLI/script verification, plus API/connector/browser or desktop evidence when a verified tool path is appropriate.
- Task-level smoke tests, optional broader regression harness, and explicitly marked blocked or deferred checks.
- An independent UAT distinction: user acceptance is not fabricated from an agent-run browser test.
- A structured closeout receipt including DT/RDT ID, implementation evidence, tests, UAT status, available Git SHA/PR, and optional measured credits.
- Branch/PR review, CODEOWNERS/protection, integration checks, and authorization before sensitive merges or deployment.
- Retro and current-state record maintenance, plus documentation impact review.

`atlas preview` provides an early safe demo path without equating preview with a successful Definition of Done. Test/synthetic data, authorization, isolated destination and risk-based focused checks are required. Authentication, privacy/PHI, money, infrastructure policy, control systems and destructive migrations require stronger checks. Full project-required gates remain mandatory for release.

### 3.6 Skills and cross-project reuse

The complete Atlas catalog includes reusable guidance for testing, code style, requirements, API contracts, security and threat modeling, anti-patterns, Git branching, model-tier advice, deployment, CI/CD pipelines, integrations, framework selection, domain models, compliance decisions, data classification, Azure deployment, and cloud-neutral Node/Python stacks. The UX catalog includes navigation and application-shell approaches, with explicit promotion from project decision to reusable baseline.

These are **semantic and engineering skills**: they make agents and project teams follow common practices. They are not equivalent to Paseo's runtime plugins, which can add actual client panels, daemon RPC handlers, provider integrations and automation hooks.

## 4. Paseo's execution and automation capabilities

### 4.1 Provider abstraction and agent sessions

Paseo wraps existing installed coding agents as external processes. The [providers documentation](https://paseo.sh/docs/providers) distinguishes bundled native provider adapters from an Agent Client Protocol (ACP) catalog. Claude Code and Codex are in the native group; GitHub Copilot appears in the ACP catalog. This is **not** a claim that every provider supports identical permissions, subagents, tools, token accounting, or session semantics.

Saved profiles capture provider/model, thinking settings, mode and specialization notes. Agents can launch other agents, communicate with them, check status, collect results and supervise parallel work. [Orchestration](https://paseo.sh/docs/orchestration).

### 4.2 Workspaces and isolated concurrent changes

Paseo has a first-class project/workspace/session model. Git worktrees give independent branches and directories for concurrent work, with setup/teardown hooks and post-run archive behavior. Agents can inspect and review changes, run app processes, and test from their environments. [Worktrees](https://paseo.sh/docs/worktrees).

A **Git worktree is a change-isolation mechanism, not a security sandbox**. Workers sharing a user's host credentials or file access require independent permission boundaries. Atlas's explicit file scopes and merge authority remain useful even when Paseo provisions the worktrees.

### 4.3 Delegation, distributed machines and recovery

Paseo tools and CLI support agent launch, follow-up prompts, worker messaging, status inspection, stopping, waiting and collecting outputs. The CLI can address remote Paseo hosts with appropriate repository/provider configuration on that host. [Orchestration workflows](https://paseo.sh/docs/orchestration-workflows), [connectivity](https://paseo.sh/docs/connectivity).

Paseo's exposed session and control mechanics help sustain execution and recovery; Atlas supplies a stricter **business-process restart contract**: restore task claim identity, source revision, expected evidence, acceptance state, merge authorization, and shared-document ownership. They should not be assumed equivalent without testing interrupted-worker and orchestrator-restart cases.

### 4.4 Scheduled and event-driven execution

**Schedules** launch a fresh agent at a cron cadence. **Heartbeats** periodically prompt an existing agent so it can continue the same session. Schedules can be inspected, paused, resumed and run once; their default archive-on-finish setting affects run worktrees. These are distinct primitives. [Schedules](https://paseo.sh/docs/schedules).

**Hub** receives permitted GitHub, Slack and Discord events and starts configured agent workflows on registered daemons. Configuration and workflow files can be stored with the repository, with event filtering, workflow step logic, output and activity records. Hosted and self-hosted options exist. [Hub](https://paseo.sh/docs/hub), [Hub concepts](https://paseo.sh/docs/hub/concepts).

This is Paseo's clearest lead over the Atlas issue set: it provides general-purpose **triggers and unattended runtime operation**, not just a human-initiated software engineering session.

### 4.5 Programmatic and plugin extensibility

Paseo offers CLI, MCP tools, a TypeScript client SDK and a plugin system. The SDK can create agent sessions and keep them alive independently of the caller; plugins can add UI elements, agent-provider extensions, daemon-side RPCs and hooks. [SDK](https://paseo.sh/docs/sdk), [MCP](https://paseo.sh/docs/mcp), [plugins](https://paseo.sh/docs/plugins).

Plugins are documented as **trusted, unsandboxed code**, so installation should be subject to code review and explicit permission. The fact that Paseo exposes powerful hooks makes it an attractive Atlas execution adapter, but increases the importance of credential and least-privilege reviews.

### 4.6 Runtime security

Paseo's daemon is local-first; clients connect to the daemon. It supports direct access, VPN/Tailscale, SSH routes for appropriate clients, and an opt-in end-to-end encrypted relay for remote/mobile access. The documented threat model covers handshake, protected traffic and local binding. These protect **connectivity and agent-host control**; they do not automatically certify an Atlas deliverable against HIPAA, SOC 2, OWASP, release policy, or human UAT. [Paseo security](https://paseo.sh/docs/security).

## 5. Detailed side-by-side workflow

| Stage | Atlas responsibility | Paseo responsibility if integrated | Durable success signal |
|---|---|---|---|
| Intake | Capture need in BL, classify, clarify authority | No required role | Backlog record |
| Discovery | Research, preserve options and cited evidence | Launch researcher if asked | Discovery note |
| Decision | ADR proposal, explicit owner decision, reusable pattern gate | No independent decision authority | Accepted/rejected/deferred record |
| Plan | Break requirements into bounded DTs, CU and dependencies | Make agents available to execute | DC and task graph |
| Claim | Assign accountable owner/executor and prevent conflicts | Attach agent ID to worker | One active valid claim |
| Fan-out | Determine safe parallelism, write scopes, model guidance | Launch agents/worktrees/providers | Worker identities and baselines |
| Implement | Constrain scope and validate against acceptance | Execute coding/testing prompts | Commits/diffs and outputs |
| Observe | Assess meaningful progress, blockers and attempts | Stream agent state/logs | Accurate status and evidence |
| Correct | Reassign/retry within policy, preserve history | Follow up, stop, retry/resume sessions | Bounded, auditable retry |
| Integrate | Enforce integrator, branch, PR and file ownership | Supply branches/worktrees/diffs | Verified combined revision |
| Verify | Test specification, smoke/regression/UI evidence | Execute CLI/browser/API checks | Reproducible test receipt |
| Accept | Human UAT or explicit non-UAT rule | Present work and artifacts | Recorded acceptance status |
| Close | Retro, aMOE, credits, state, receipt, issue/PR links | Archive/stop worker as appropriate | Consistent Atlas records |
| Release | Approval, safety/security checks, merge/deploy authorization | Execute permitted operations | Release record |
| Recur | Define intended recurrent engineering work | Schedule or Hub event trigger | Recorded authorized run |

### Example: one requested feature

**Request:** “Add a news and sign-up section, track visitor journeys, and prepare a safe preview.”

**Atlas:** examines the PRD, opens discovery as needed, records privacy/data retention decisions, chooses stack/UX patterns, creates bounded DTs, and sets acceptance criteria. A privacy-impacting tracking decision remains subject to explicit approval. The DC identifies parallel frontend/API work, smoke tests, integration checks, UAT and preview boundaries.

**Paseo:** starts a frontend coding worker and an API worker in separate worktrees, optionally adds an independent review worker, streams progress, and captures diffs/logs. Atlas’s orchestrator assigns claims and owns the integration decision. Paseo workers do not decide to merge or release on their own.

**Outcome:** an Atlas closeout receipt identifies the actual revision, verification, UAT handoff, retro entry and outstanding work. The execution environment can be replaced later without rewriting the business and engineering contract.

## 6. Reference integration architecture

```text
             Human product owner / developer
                         |
                         v
       +-------------------------------------+
       | ATLAS_AI: Engineering control plane |
       |-------------------------------------|
       | MRD / PRD / ESD / CGR / ADR         |
       | Stack + UX + security patterns      |
       | Backlog / DC / DT / RDT             |
       | Claims, ownership, acceptance       |
       | CU, model guidance, budgets         |
       | Test/UAT/closeout receipts          |
       | GitHub links, retros, evidence      |
       +------------------+------------------+
                          |
              Execution adapter contract
                          |
         +----------------+----------------+
         |                                 |
         v                                 v
 +---------------------+          +---------------------+
 | Paseo backend       |          | Native CLI / other  |
 |---------------------|          | execution backend   |
 | Daemon / sessions   |          +---------------------+
 | MCP / CLI / SDK     |
 | Workspaces/worktree |
 | Agent delegation    |
 | Schedules/heartbeats|
 | Hub events          |
 +----------+----------+
            |
       +----+---------------------+
       |              |           |
       v              v           v
  Copilot / ACP   Claude Code    Codex
       |              |           |
       +--------------+-----------+
                      |
              Project Git / CI
                      |
            Verified receipts to Atlas
```

### Clear ownership boundaries

- **Atlas owns:** task state and claims, authoritative Markdown, owner approvals, required tests/UAT, source revision, budget/policy, release authority, and closing evidence.
- **Paseo owns:** concrete execution sessions, daemon/host communication, runtime workspaces, worktrees, provider launches, logs, scheduling and event delivery.
- **Provider agents own:** code changes and produced evidence within their assigned scope.
- **GitHub/CI owns:** actual repository commits, PR status, protected-branch enforcement and build results. Atlas records and checks these rather than fabricating success.
- **Human stakeholders own:** acceptance and any explicitly reserved decisions, such as ADR acceptance, production deployment and privileged authorization.

### Minimal proposed adapter contract

This is **conceptual**, not a claim that Paseo implements the following exact methods out of the box:

```text
launch(task_id, repository, baseline_sha, scope, provider_profile, limits)
  -> agent_run_id, workspace_id, branch, host, started_at

inspect(agent_run_id)
  -> running | blocked | failed | completed, log/evidence pointers

send(agent_run_id, bounded_instruction)
  -> acknowledgment / rejection

stop(agent_run_id, reason)
  -> terminal status

collect(agent_run_id)
  -> commits, diff, tests, artifacts, logs, observed_usage

recover(task_id, previous_run_id, recovery_policy)
  -> preserved state, resumed/new run ID, evidence

release_workspace(agent_run_id, retention_policy)
  -> retention/cleanup receipt
```

**Idempotency:** `task_id + attempt + approved baseline` is an external correlation key; a duplicate trigger must not create an untracked second owner/worker. **Durability:** agent host session IDs are not substitutes for Atlas DT identities. **Evidence:** output claims are checked against Git, tests and user approvals before Atlas closeout. **Rate/spend bounds:** retries and concurrency are capped; escalation requests approval. **Security:** secret values never go into committed records or raw status messages.

## 7. Reliability and failure analysis

| Failure mode | Atlas control required | Paseo feature to use | Pass criterion |
|---|---|---|---|
| Two agents claim same DT | Atomic claim/serialization; detect collision | Launch only claimed work | One accountable executor |
| Overlapping files | Scope reservation and merge planning | Separate worktrees | Conflicts are blocked/resolved, not overwritten |
| Worker exits nonzero | Retry policy, preserve original logs | Session/log/stop controls | No false “Done”; bounded retry |
| Worker falsely reports success | Independent diff/test review | Capture logs, inspect worktree | Evidence contradicts claim and task remains open |
| Lost orchestrator session | Recover claims, attempts, source revision | Reconnect or new agent session | No duplicate dispatch; no lost history |
| Worktree setup fails | Explicit blocked state | Worktree setup result | No worker starts on wrong branch |
| GitHub unavailable | Markdown operation continues; remote follow-up pending | Local Git and CLI where possible | No fabricated PR or issue sync |
| Integration smoke fails | Block merge/closeout | Run combined-revision tests | Failure retained and corrected |
| Unauthorized production push | Separate release approval, protected branches | Host/provider permission settings | No action without authority |
| Scheduled job repeats work | Run ID/claim dedupe, limits, retention | Schedule/Hub metadata | No unbounded duplicate work |
| Sensitive data in tool logs | Redaction, classification and retention policy | Host logging configuration | No secret/PHI leakage in Atlas artifacts |
| Plugin compromises host | Trusted plugin review and least privilege | Paseo plugin/daemon model | Explicit permission and constrained deployment |

## 8. Security, compliance and non-goals

1. **Worktrees are not sandboxes.** A worker with the same filesystem and account credentials can act outside its Git worktree unless permissions enforce otherwise.
2. **Neither platform makes a project compliant by declaration.** Atlas can define data classification and security review; actual HIPAA/BAA or regulatory compliance depends on provider agreements, implementation, tenancy, permissions, audit, and deployment configuration.
3. **No provider-execution parity should be presumed.** Copilot through ACP may behave differently from native Claude Code/Codex adapters; tool discovery, authentication, policy and model routing must be verified.
4. **Provider telemetry is not Atlas cost accounting.** Usage may be absent or expressed in different units. The correct Atlas result is `unavailable`, not an invented amount.
5. **Agent review is not human approval.** Automated review may be an input to a protected-branch gate but not a substitute for required signatures or UAT.
6. **Schedules are autonomous execution authority.** Starting code-capable agents from a cron or external event increases the need for allowlists, access boundaries, spending caps, trigger validation, safe branches and audit retention.
7. **Public specifications versus demonstrations:** Atlas’s requested full-completion baseline is an evaluation scenario; Paseo’s published descriptions establish documented features, not independently measured availability/reliability on a particular host.

## 9. Build-versus-integrate decision

| Option | Benefits | Costs / risks | Assessment |
|---|---|---|---|
| A. Atlas-only orchestration | Single conceptual system, full control over policy | Must maintain worker launch, session persistence, distributed execution, recovery, schedules and trigger integration if desired | Viable if Paseo adapter fails critical tests |
| B. Paseo-only with informal prompts | Excellent runtime surface and low orchestration build cost | No assured portable Atlas DC/BL, ADR, evidence and UAT contract | Insufficient for Atlas engineering goals |
| C. Atlas control plane + Paseo adapter | Preserves Atlas differentiation; reuses runtime/daemon/Hub; interchangeable providers | Must implement adapter, state mapping, permission audit and nontrivial fault recovery | **Preferred** subject to measured acceptance |
| D. Atlas core + multiple execution adapters | Avoids vendor/runtime lock-in; best enterprise fit | Additional connector maintenance and parity matrix | Strategic design target; start with one validated adapter |

### Acceptance test for the Paseo adapter

Treat the following as a **test protocol**, not as results already demonstrated:

1. From a Markdown BL, promote a bounded task into a DC without discarding GitHub links.
2. Automatically claim two nonconflicting DTs, reject a third conflicting claim, and establish task-to-agent correlations.
3. Launch Codex and Claude workers, plus Copilot where supported, in independent worktrees from an exact commit.
4. Capture provider/run/worktree identity, timestamps, actual commands, diff, logs, test evidence and any exposed usage.
5. Stop and correct a worker with a faulty implementation; confirm no accidental merge.
6. Kill a worker and resume/reassign with bounded retries and preserved evidence.
7. Restart orchestrator coordination; confirm task identity, outstanding checks and no duplicate dispatch.
8. Introduce a merge conflict and failing integration test; confirm Atlas refuses closeout.
9. Lose GitHub access; confirm local Markdown/Git progress and truthful pending remote state.
10. Complete a reviewed PR and reproducible smoke, preserve UAT separately, then close Atlas records coherently.
11. Repeat on a second machine with explicit host/repo/credential boundaries.
12. Launch a scheduled or event-triggered workflow with allowlisted origin, caps, branch restrictions and deduplication.
13. Measure time-to-first-preview, time-to-validated-DT, retries, operator interventions and total attributable provider cost.
14. Confirm unsupported agent configurations and missing tools produce an honest BLOCKED/UNTESTED result.

### Decision metrics

Use empirical metrics, not anecdotal claims:

- **Successful autonomous completion rate:** verified DTs / attempted DTs, with identical task difficulty mix.
- **Operator interventions per DT:** approvals, relayed prompts, manual worktree setup, recovery actions.
- **Time to verified result:** dispatch to complete verification and correct Atlas records; report median and tail.
- **Quality:** regression and independent review defects per accepted change.
- **Recovery quality:** reproducible restart success without duplicate edits or lost evidence.
- **Cost:** source-measured spend, comparable to CU only after normalizing provider units.
- **Portability:** number of tested hosts/agents/policy combinations, not merely number listed in a catalog.

## 10. Conclusion

Atlas and Paseo overlap substantially at the **multi-agent orchestration** layer. The complete Atlas scope, however, supplies broader engineering governance: requirements, discovery, ADRs, reusable patterns, backlog and development cycles, accountable assignment, evidence-backed testing, UAT, controlled preview, retrospectives and effort/cost analysis. Paseo adds a sophisticated execution environment with provider adapters, workspaces, remote session control, schedules, heartbeats, event-triggered Hub workflows and programmable APIs.

The strongest combined system is **Atlas specifying and auditing the work, Paseo executing the agents, and Git/CI recording the actual changes**. Atlas should not surrender Markdown project authority or explicit human decisions to a runtime platform. Paseo should not be made responsible for interpreting vague prompts as proof that Atlas acceptance and release gates have passed.

The remaining architectural question is not which app is better. It is whether Paseo can meet Atlas's precise work claiming, bounded recovery, evidence and release-control contracts through its existing MCP/CLI/SDK. A targeted adapter benchmark answers that question more efficiently than building a second complete agent runtime.

---

## Appendix A. Atlas GitHub issue completion ledger

**Interpretation:** The following is the requested **all-Done scope register**. Each issue is marked **Done** as part of the complete Atlas capability baseline. Its entry describes the engineering capability included in that baseline. The link points to the actual source issue, whose live GitHub workflow state may differ; the register does not change GitHub issue status or claim that a linked PR has been merged.

### A1. Engineering lifecycle, task state and quality gates

| Issue | Status in this comparison | Included capability and acceptance contract | Relation to Paseo |
|---|---|---|---|
| [#5 — Credits in retrospective entries](https://github.com/picostar/Atlas_AI/issues/5) | **Done** | Optional source-measured `Credits` alongside `Usage` and model fit; unavailable values remain explicitly unavailable and do not block DoD. | Paseo may expose provider data; Atlas owns cost interpretation. |
| [#6 — Task closeout receipt](https://github.com/picostar/Atlas_AI/issues/6) | **Done** | Structured closeout with ID, verification, UAT or non-UAT state, commit/PR evidence and optional credits; no assertion of completion from summary prose alone. | Beyond basic session completion. |
| [#14 — Requirements gate](https://github.com/picostar/Atlas_AI/issues/14) | **Done** | Formal applicability and completion gate for MRD/PRD before starting specified devtasks; requirements-writing skill linked to process. | Atlas-specific governance. |
| [#22 — Weekly cost roll-up](https://github.com/picostar/Atlas_AI/issues/22) | **Done** | `docs/agile/cost.md` rollup of observed credits per CU, person and model; tracked source/units and worked comparison. | Paseo execution usage can be an input. |
| [#29 — Model routing, effort and cost](https://github.com/picostar/Atlas_AI/issues/29) | **Done** | Separate runtime, model, automatic routing mode, requested/applied effort and observed provider participants; CU advice stays advisory; no fictitious token totals. | Complements Paseo profiles. |
| [#30 — Browser/API/tool verification evidence](https://github.com/picostar/Atlas_AI/issues/30) | **Done** | Repeatable observed verification for CLI, API, browser, desktop and documentation changes, with actual target, steps, expected/observed results and evidence location. | Uses Paseo browser/terminal capabilities where suitable. |
| [#31 — Optional GitHub issue linking](https://github.com/picostar/Atlas_AI/issues/31) | **Done** | Stable DT/RDT ↔ issue/branch/PR traceability while portable BL/DC/retro Markdown stays authoritative, including GitHub-offline mode. | GitHub-aware Paseo workspaces are complementary. |
| [#34 — DC progress visibility](https://github.com/picostar/Atlas_AI/issues/34) | **Done** | Meaningful `brief`/`normal`/`detailed` updates explaining current DC/DT, verified progress, blocker and next action, reconciled with persistent records. | Paseo gives session logs; Atlas gives process-aware explanations. |
| [#38 — Safe fast preview](https://github.com/picostar/Atlas_AI/issues/38) | **Done** | Early isolated demo after focused/risk-based checks; explicit incomplete status, no bypass of UAT, smoke, full regression, security or release authorization. | Paseo can host/run the demo; Atlas specifies safe promotion. |

### A2. Installation, portability and compatibility

| Issue | Status in this comparison | Included capability and acceptance contract | Relation to Paseo |
|---|---|---|---|
| [#7 — Agent parity fixture](https://github.com/picostar/Atlas_AI/issues/7) | **Done** | Runtime/version-identified execution evidence for discovery, skill use, recovery, permissions, source loss, worktrees and representative DT delivery; supports BLOCKED/UNTESTED states. | Required to certify a Paseo adapter for Atlas. |
| [#23 — Clean/uninstall](https://github.com/picostar/Atlas_AI/issues/23) | **Done** | Receipt- and manifest-driven, plan-first artifact removal; protect edited files, secrets, accounts, project records and pre-existing content. | Keeps Atlas adoption independent of Paseo. |
| [#24 — Zero-install Atlas session](https://github.com/picostar/Atlas_AI/issues/24) | **Done** | Run Atlas from a pinned kit source without installed kit artifacts, with session evidence, honest source-loading results and portable task records. | Can operate in a Paseo-controlled provider session. |
| [#25 — Minimal install and lifecycle naming](https://github.com/picostar/Atlas_AI/issues/25) | **Done** | Minimal/full install profiles, tool-specific pointers, manifest-driven selection, `atlas install` lifecycle with compatibility aliases and validated defaults. | Process kit needs no Paseo dependency. |
| [#26 — Reference graph integrity](https://github.com/picostar/Atlas_AI/issues/26) | **Done** | Verify installed files never reference a missing optional dependency without an explicit condition; validate chosen profile and authoritative skill routes. | Atlas-specific dependency assurance. |
| [#27 — Runtime capability and loading matrix](https://github.com/picostar/Atlas_AI/issues/27) | **Done** | Correct distinction between host client, CLI, agent, model, skill discoverability, invocation, permissions and supported tests. | Prevents overclaiming provider parity in Paseo. |
| [#28 — Lifecycle entry-point skills](https://github.com/picostar/Atlas_AI/issues/28) | **Done** | Usable routes for install, update, validate, session, closeout, CGR and realignment across supported agents, with explicit fallback and one source of truth. | Runtime-neutral workflow surface. |
| [#39 — Portable writing style standard](https://github.com/picostar/Atlas_AI/issues/39) | **Done** | `.github/style.md` replaces prior style reference with optional checks, preservation during upgrades and consistent installation guidance. | Shared agent output quality independent of Paseo. |
| [#43 — Preserve existing root docs/scripts](https://github.com/picostar/Atlas_AI/issues/43) | **Done** | New-project install leaves manifest-allowed application `docs/` and `scripts/` intact, merges safely and verifies application smoke after installation. | Protects target application when Atlas is installed inside a Paseo workspace. |

### A3. Discovery, architecture and product design

| Issue | Status in this comparison | Included capability and acceptance contract | Relation to Paseo |
|---|---|---|---|
| [#9 — Cloud-neutral Node/Python stacks](https://github.com/picostar/Atlas_AI/issues/9) | **Done** | Documented generic Node and Python deployment-independent patterns, repo structure, run/test/smoke guidance and catalog integration. | Useful to agents launched from any provider/host. |
| [#15 — Complete MRD/PRD/ESD examples](https://github.com/picostar/Atlas_AI/issues/15) | **Done** | Full worked templates showing mapping from market requirements through product requirements, engineering design and CGR rules. | Atlas-specific onboarding/assurance. |
| [#20 — Modern UX navigation patterns](https://github.com/picostar/Atlas_AI/issues/20) | **Done** | Reviewed application shell, sidebar, breadcrumb, rail/drawer, list-detail, navigation, global search and workspace-switching UX baselines, with adoption guidance. | Agent coding can use them; Paseo does not prescribe product UX. |
| [#35 — Guided discovery](https://github.com/picostar/Atlas_AI/issues/35) | **Done** | `atlas discover`, `discover stack`, `discover ux`: credible alternatives, tradeoffs, cited research, resumable notes, explicit no-decision outcome. | Stronger project research contract than free-form task prompts. |
| [#36 — ADR lifecycle](https://github.com/picostar/Atlas_AI/issues/36) | **Done** | Proposed/Accepted/Rejected/Superseded architecture and UX decisions; decider, rationale, options, consequences, evidence, history, approval and implementation state. | Makes decisions durable independent of agent sessions. |
| [#37 — Pattern promotion](https://github.com/picostar/Atlas_AI/issues/37) | **Done** | Approval-gated promotion of accepted ADRs to project stack/UX baseline or reusable Atlas catalog; explicit history and rollback. | Avoids treating generated code or skill output as approved standards. |

### A4. Technical and domain skills

| Issue | Status in this comparison | Included capability and acceptance contract | Relation to Paseo |
|---|---|---|---|
| [#8 — Testing and code-style skills](https://github.com/picostar/Atlas_AI/issues/8) | **Done** | Test patterns, smoke/unit/CI shape, JS/TS/Python/Lua/general style, plus accurate installed-skill inventory. | Reusable by any Paseo-launched provider. |
| [#10 — Slim process core](https://github.com/picostar/Atlas_AI/issues/10) | **Done** | Concise root process with specialist CU, retro and model-tier material in authoritative skills, avoiding redundant per-session context. | Reduces token/context overhead. |
| [#11 — Security patterns](https://github.com/picostar/Atlas_AI/issues/11) | **Done** | Threat modeling, AI/security risks, OWASP practices, credential protection, audit and CGR security gate integration. | Adds application assurance beyond daemon transport security. |
| [#12 — API design and API-first gate](https://github.com/picostar/Atlas_AI/issues/12) | **Done** | Contract-first REST, versioning, errors, rate limits, endpoint/OpenAPI verification where appropriate, and API review gate. | Engineering method, not provider feature. |
| [#13 — Anti-patterns skill](https://github.com/picostar/Atlas_AI/issues/13) | **Done** | Prevent common AI coding, coupling, testing, deployment and process failures using explicit examples and checks. | Improves agent task reliability. |
| [#16 — Extending Atlas guide](https://github.com/picostar/Atlas_AI/issues/16) | **Done** | Contributor instructions for custom skills, tiers, safe extension and return of reusable improvements. | Complements rather than replaces Paseo plugin API. |
| [#17 — Deployment/pipeline/integration/framework skills](https://github.com/picostar/Atlas_AI/issues/17) | **Done** | Cloud-neutral rollout, canary/rollback, CI/CD patterns, secret injection, OAuth/SAML/webhooks, and framework evaluation. | Paseo executes workflows; Atlas describes robust engineering patterns. |
| [#18 — Domain skills](https://github.com/picostar/Atlas_AI/issues/18) | **Done** | Templates for domain entities/rules/state transitions, compliance decisions and data classification/retention/access. | Strong fit for regulated enterprise products. |
| [#19 — Skill references and decision trees](https://github.com/picostar/Atlas_AI/issues/19) | **Done** | Consistent when-to-use sections, worked CU examples, Git branching decision trees and reference folders. | Makes Atlas instruction invocation more reliable. |

### A5. Team and agent execution

| Issue | Status in this comparison | Included capability and acceptance contract | Relation to Paseo |
|---|---|---|---|
| [#41 — Team and multi-agent orchestration](https://github.com/picostar/Atlas_AI/issues/41) | **Done** | Independent opt-in solo/team/orchestration/combined modes; human owners; stable work claims; automatic worktrees; Copilot/Codex/Claude adapter support as tested; multiple workers; supervised corrections and recovery; integrator authority; GitHub checks and PR flow; local Git fallback; limits, audit, and no false success. | Direct functional overlap with Paseo. Its integration strategy deserves explicit benchmarking. |

### A6. Issue #41 execution breakdown included as Done

Issue [#41](https://github.com/picostar/Atlas_AI/issues/41) defines a staged implementation sequence. In the complete Atlas comparison, each deliverable is included:

| Work unit | Status | Function included |
|---|---|---|
| DT1.1 | **Done** | Collaboration contract, task-claim protocol, shared-record authority, Git/GitHub boundaries, runtime adapters, supervision schema, reuse decision. |
| DT1.3 | **Done** | Prompt-first orchestrator using supported Copilot session and native Codex/Claude worker paths, automatic worktrees, local Git integration, operator guide. |
| DT1.4 | **Done** | Failed-worker correction, retry, interrupted worker recovery, orchestrator restart, merge conflicts and rejection of false success. |
| DT1.5 | **Done** | Team ownership, PR/CODEOWNERS guidance, shared-document serialization, integration/review authority, combined-mode documentation. |
| DT1.2 | **Done** | Independent setup opt-ins, receipt/update behavior and user installation guide. |
| DT1.6 | **Done** | GitHub issue/branch/PR/check/review integration with authorized disposable-repository trials and offline fallback. |
| DT1.7 | **Done** | Separate orchestrator runtime trials and a documented matrix distinguishing orchestrator support from worker support. |

**Boundary retained:** Completion of the specified orchestration work does **not** automatically imply Atlas contains a universal persistent daemon, general cron scheduler, cross-machine relay, hosted event Hub, or public TypeScript session SDK. Those are distinct capabilities delivered by Paseo.

### A7. Ledger coverage check

- **34 distinct GitHub issues** are included above.
- **34 / 34** are marked **Done** in this requested comparison baseline.
- Issue numbers: **#5, #6, #7, #8, #9, #10, #11, #12, #13, #14, #15, #16, #17, #18, #19, #20, #22, #23, #24, #25, #26, #27, #28, #29, #30, #31, #34, #35, #36, #37, #38, #39, #41, #43**.
- The ledger's Done marker is **not** a live GitHub modification, a source-code deployment receipt, or an independently audited closure claim.

## Appendix B. Source and evidence index

### Atlas primary sources

- [Atlas_AI README](https://github.com/picostar/Atlas_AI/blob/main/README.md): the process kit, entry points, project bootstrap and rationale.
- [ATLAS.md](https://github.com/picostar/Atlas_AI/blob/main/ATLAS.md): DC/DT workflow, smoke, UAT, CU, and definition of done.
- [Tool capability matrix](https://github.com/picostar/Atlas_AI/blob/main/.github/TOOL-CAPABILITY-MATRIX.md): observed runtime/tool loading evidence and limitations.
- [Devcycle-management skill](https://github.com/picostar/Atlas_AI/blob/main/.github/skills/devcycle-management/SKILL.md): execution and retro maintenance rules.
- [Agent parity fixture](https://github.com/picostar/Atlas_AI/blob/main/docs/testing/agent-parity.md): bounded verification and acceptance cases.
- [Progress reporting trials](https://github.com/picostar/Atlas_AI/blob/main/docs/testing/progress-reporting.md): actual measured progress visibility across tools and runtime variants.
- [Atlas GitHub issues](https://github.com/picostar/Atlas_AI/issues): complete capability source list; links for all 34 issues appear in Appendix A.

### Paseo primary sources

- [Project and main documentation](https://paseo.sh/docs)
- [Providers and ACP](https://paseo.sh/docs/providers)
- [Multi-agent orchestration](https://paseo.sh/docs/orchestration)
- [Orchestration workflows](https://paseo.sh/docs/orchestration-workflows)
- [Git worktrees](https://paseo.sh/docs/worktrees)
- [Schedules and heartbeats](https://paseo.sh/docs/schedules)
- [Hub](https://paseo.sh/docs/hub) and [Hub concepts](https://paseo.sh/docs/hub/concepts)
- [Paseo CLI](https://paseo.sh/docs/cli) and [MCP](https://paseo.sh/docs/mcp)
- [TypeScript SDK](https://paseo.sh/docs/sdk)
- [Plugin system](https://paseo.sh/docs/plugins)
- [Security architecture](https://paseo.sh/docs/security)
- [Connectivity and remote hosts](https://paseo.sh/docs/connectivity)
- [Paseo source repository](https://github.com/getpaseo/paseo)

### Method and limits

The Atlas feature inventory was derived from the linked repository documentation and issues retrieved through the connected GitHub account. The complete-state baseline is intentionally normalized to **Done** per the requested comparison, not inferred from source code or live issue state. Paseo feature statements were checked against its official site and documentation. No quantitative benchmark or end-to-end integration test was performed, so performance, recovery reliability, price/per-CU and cross-provider parity remain unscored rather than invented.

---

**Final finding:** **Atlas_AI is the development process and engineering assurance authority. Paseo is a compelling execution and automation substrate.** A well-designed integration can achieve both while keeping Atlas's distinctive DC/BL/ADR/UAT contracts independent of the agent runtime.