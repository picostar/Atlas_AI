# User Manual and Operational Guide

> **Purpose:** Practical, non-technical guide for Product Owners, Project Leads, Developers, and Business Operators. Explains how to interact with the Atlas_AI system, understand the daily workflow (devcycles), manage access with Single Sign-On (SSO), coordinate with IT for cloud resources, and resolve common issues.

---

## 1. Introduction and Core Concepts

Atlas_AI is a structured framework for software development and operation assisted by Artificial Intelligence and engineering teams. Unlike traditional methodologies with multi-week iterations, Atlas organizes work into compact, verifiable execution units.

### Essential Operational Glossary
- **Devcycle (`devcycle.md`):** The active queue of immediate tasks to execute (covering a morning, an afternoon, or a specific work block). It contains only live tasks pending delivery.
- **Devtask (DT):** A concrete, small, scoped technical or functional task that always includes a change description, an automated verification (*Smoketest*), and an acceptance criterion (*UAT*).
- **Reset Devtask (RDT):** An unplanned task triggered by an unexpected blocker or critical finding that must be resolved before resuming the planned sequence.
- **Retro (`retro.md`):** The ledger of project history. When a task completes, it is removed from `devcycle.md` and appended to `retro.md` along with its test evidence.
- **Backlog (`backlog.md`):** The prioritized list of future requirements and ideas not yet pulled into an active work cycle.
- **Status (`status.md`):** Executive summary of current product state for stakeholders and leadership.

### Effort Model: Complexity Units (CU)
Atlas_AI does not measure work in "person-hours", but in **Complexity Units (CU)**:
- **eMOE (Estimated Measure of Effort):** Upfront estimate in CU (accounting for uncertainty, integration risk, and testing burden).
- **aMOE (Actual Measure of Effort):** Real effort expended in CU after completing the task.
- **Calibration:** If a task estimated at 2 CU finishes requiring 8 CU, the root cause is analyzed during retrospectives to improve future accuracy.

---

## 2. Step-by-Step Daily Workflow

To advance development or operation of a feature:

```text
[1. Pull Devtask (DT) from devcycle.md]
               |
               v
[2. Implement change or feature]
               |
               v
[3. Run automated Smoketest] -> If failing: fix immediately
               |
               v
[4. Conduct UAT (User Acceptance Testing)]
               |
               v
[5. Move task to retro.md and git commit]
```

### Step 1: Task Selection
Review [`docs/agile/devcycle.md`](file:///c:/Sources/Atlas_AI/docs/agile/devcycle.md) and take the top available task. Verify that objectives and scope are clear.

### Step 2: Implementation
The engineer or AI agent implements the code adhering to API design standards ([`.github/skills/api-design/SKILL.md`](file:///c:/Sources/Atlas_AI/.github/skills/api-design/SKILL.md)) and security guidelines ([`.github/skills/security-patterns/SKILL.md`](file:///c:/Sources/Atlas_AI/.github/skills/security-patterns/SKILL.md)).

### Step 3: Mandatory Technical Validation (Smoketest)
Before declaring a task done, execute the automated verification script:
```powershell
pwsh scripts/smoketest.ps1
```
If the output does not show `[PASS]`, the task remains open and cannot be delivered.

### Step 4: User Acceptance Testing (UAT)
- If the task has visual or functional impact, the Product Owner or business user tests the feature in the browser.
- If the task was purely internal (e.g. database index tuning or CI/CD script improvements), record it explicitly as `Not UAT-eligible` with technical justification.

### Step 5: Recording and Closeout
Record the result in [`docs/agile/retro.md`](file:///c:/Sources/Atlas_AI/docs/agile/retro.md), remove the task from [`docs/agile/devcycle.md`](file:///c:/Sources/Atlas_AI/docs/agile/devcycle.md), and commit the changes in git.

---

## 3. Sign-In and Access Control Guide (SSO)

The system utilizes Microsoft Entra ID enterprise identity (Single Sign-On):

### How to Sign In
1. Navigate to the application URL (e.g. `https://my-portal.azurestaticapps.net` or locally `http://localhost:4280`).
2. Click **"Sign in with Microsoft"** or navigate to `/login`.
3. The browser redirects to the official Microsoft Sign-In screen (or automatically recognizes an active Windows/Office 365 session).
4. Enter corporate email and password, and approve multi-factor authentication (MFA via Microsoft Authenticator app).
5. Once validated, you are redirected back to the portal with active roles and permissions.

### User Roles in the System
| Role | Permission Scope | Assigned By |
| :--- | :--- | :--- |
| **Anonymous** | Access limited to health probes (`/health`) and public landing pages. | Default (unauthenticated). |
| **Authenticated** | Standard user access, data lookup, and personal profile operations. | Any corporate tenant user with valid login. |
| **Administrator** | Access to `/admin/*`, system configurations, and maintenance operations. | IT Administrator via Entra ID security group assignment. |

### Signing Out
To securely end your session, click your user avatar and select **"Sign Out"** (or visit `/logout`). The session cookie is destroyed in the browser.

---

## 4. How to Request IT Resources and Check Pricing

When the project requires provisioning a new database, setting up environments, or adding Azure services:

1. **Open the Official Request Form:** Use the [`docs/reference/azure-resource-request-template.md`](file:///c:/Sources/Atlas_AI/docs/reference/azure-resource-request-template.md) template.
2. **Look Up Live Pricing:** Run the pricing query script to check the latest rates:
   ```powershell
   pwsh scripts/get-azure-prices.ps1 -Region eastus -OutputFormat Markdown
   ```
3. **Fill in Project Metadata:** Specify the Cost Center, whether a New or Existing Resource Group is requested, and architectural justifications.
4. **Submit Ticket to IT:** Attach the completed document in the corporate ticketing system (ServiceNow or Jira).
5. **Secret Handover Ceremony:** If IT delivers a Client Secret or API Key, strictly follow the protocol in [`docs/reference/secret-handover-ceremony.md`](file:///c:/Sources/Atlas_AI/docs/reference/secret-handover-ceremony.md). **Never accept plaintext passwords sent via Teams or unencrypted email**.

---

## 5. Frequently Asked Questions and Troubleshooting

### "Microsoft displays 'Need admin approval' during sign-in"
- **Cause:** The corporate tenant restricts end-user consent for third-party application registrations.
- **Resolution:** Request the IT Entra ID administrator to grant **Admin Consent** to the App Registration matching the Client ID documented in [`accounts.md`](file:///c:/Sources/Atlas_AI/accounts.md).

### "The database takes 10 to 15 seconds to respond on the first query of the morning"
- **Cause:** Azure SQL Database Serverless has an **Auto-Pause Delay set to 60 minutes** to save up to 75% of cloud database costs. During non-business hours it pauses, and the first request wakes it up automatically.
- **Behavior:** This is expected behavior. Subsequent queries respond in milliseconds.

### "Smoketest reports HTTP 401 on `/api/v1/items`"
- **Cause:** The endpoint is secured against anonymous requests. The smoketest probe verifies that unauthenticated access is rejected with HTTP 401. If the test expected 401 and received 401, the security boundary passed.

### "I want to work on my laptop completely offline without VPN or internet"
- **Resolution:** Launch the local emulator:
  ```powershell
  pwsh scripts/dev-local.ps1 -StartAzurite
  ```
  Navigate to `http://localhost:4280/.auth/login/aad` to simulate corporate logins 100% offline.

---

## 6. Support Channels and Escalation Matrix

| Severity Level | Impact Criteria | Target SLA | Contact Channel |
| :--- | :--- | :--- | :--- |
| **P1 - Critical** | Total outage of production service or suspected credential leak. | < 15 minutes | Direct call to Infrastructure Lead / On-call CISO |
| **P2 - High** | SSO authentication failure or severe latency degradation across features. | < 1 hour | Alerts Teams Channel / Priority IT Ticket |
| **P3 - Medium** | Functional error affecting a subset of users with a viable workaround. | < 4 hours | Standard Jira / ServiceNow ticket |
| **P4 - Low** | General question, cosmetic improvement, or new environment request. | Next devcycle | Backlog entry in `docs/agile/backlog.md` |
