# Backlog

Future work queue. Keep this separate from the active burn-down.

## Next Candidates

### B1 -- Confirm Claude quota approval and deployment path

- Goal: Check whether Sonnet 5 or Haiku 4.5 quota has been approved, then deploy the least-cost viable Claude model for the demo if capacity is available.
- Why: A live Claude Code through Foundry demo requires an Azure-hosted Claude deployment, not only a project and quota request.
- eMOE: 3 CU
- Dependencies: Anthropic quota approval for the MCAPS subscription.

### B2 -- Create demo-ready Claude Code Foundry verification script

- Goal: Add a repeatable script or runbook commands that set Foundry environment variables, verify Azure auth, start Claude Code, and require `/status` provider confirmation.
- Why: The HCSC workshop needs a crisp operational demo path that proves traffic is routed to Microsoft Foundry.
- eMOE: 2 CU
- Dependencies: Confirm final deployment name and auth method.

### B3 -- Capture HCSC pilot governance decisions

- Goal: Draft the pilot decision checklist for hosting model, data zone posture, RBAC group, quota owner, cost owner, repo scope, telemetry retention, and success metrics.
- Why: The customer workshop agenda emphasizes governance, commercials, risk, operating model, and pilot next steps.
- eMOE: 3 CU
- Dependencies: Workshop stakeholder input.

### B4 -- Add architecture and operations artifacts

- Goal: Create a concise architecture diagram and operations notes for Claude Code routed through Microsoft Foundry and Azure controls.
- Why: HCSC needs to understand identity, RBAC, quota, monitoring, auditability, and FinOps implications.
- eMOE: 3 CU
- Dependencies: Hosting model decision.

### B5 -- Prepare quota-pending fallback demo

- Goal: Prepare a transparent demo path that shows Foundry project setup, quota request evidence, and Claude Code configuration without claiming live Foundry-backed inference.
- Why: The workshop date may arrive before Anthropic quota is approved.
- eMOE: 2 CU
- Dependencies: None.

## Parking Lot

Use for ideas that are real but not ready for scheduling.

### P1 -- US Data Zone Standard evaluation

- Goal: Evaluate whether HCSC requires US Data Zone Standard instead of Global Standard for the pilot.
- Why not now: Current quota requests are Global Standard and the immediate goal is a low-volume demo.

### P2 -- Private networking and enterprise landing zone alignment

- Goal: Evaluate private networking, policy, logging, and landing-zone controls for a production-scale rollout.
- Why not now: The current scope is a workshop and pilot path, not production hardening.
