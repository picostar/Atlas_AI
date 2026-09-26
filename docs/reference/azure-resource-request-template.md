# Official Azure Cloud Resource Provisioning Request and Cost Estimation Form (FinOps)

> **Purpose:** Use this formal template to request cloud resource provisioning in Microsoft Azure from the corporate IT / Cloud Infrastructure team for projects built on the Atlas_AI framework. Covers Resource Group destination (new or existing), service breakdown (including enterprise SSO/Entra ID under UXP-05), live price lookup engine via the public Azure Retail Prices API, and active cost optimization guidelines (FinOps).

---

## 1. Request Metadata

| Field | Value / Detail |
| :--- | :--- |
| **Project Name** | [Specify project name, e.g. Atlas-Operations-Portal] |
| **Repository ID** | [Specify repo, e.g. organization/project] |
| **Technical Lead / Requester** | [Name, email, and role of requester] |
| **Business Unit / Cost Center** | [Accounting code or department name] |
| **Target Environment** | `[ ] Development (Dev)` \| `[ ] Staging/QA` \| `[ ] Production (Prod)` |
| **Requested Delivery Date** | [YYYY-MM-DD] |
| **Atlas Architecture Pattern** | `[ ] SP-01` \| `[ ] SP-02` \| `[ ] SP-03` \| `[ ] SP-04` \| `[ ] SP-05` |
| **UX & Identity Pattern** | `[ ] UXP-01` \| `[ ] UXP-02` \| `[ ] UXP-03` \| `[ ] UXP-04` \| `[x] UXP-05 (SSO / OIDC)` |

---

## 2. Destination Definition: Resource Group and Subscription

Indicate the required resource grouping strategy below:

### Option A: Existing Resource Group (Recommended when shared infrastructure exists)
- **Selection:** `[ ] Yes, deploy into existing Resource Group`
- **Existing Resource Group Name:** `[e.g. rg-shared-services-dev-eastus]`
- **Target Subscription (ID and Name):** `[See accounts.md at repo root]`
- **RG Owner / Administrator:** `[Name of responsible IT owner for the existing group]`
- **Coexistence Justification:** `[Explain why sharing this RG is secure and appropriate]`

### Option B: New Resource Group (Recommended for lifecycle or cost isolation)
- **Selection:** `[ ] Yes, create a new Resource Group`
- **Proposed Name:** `rg-<project>-<environment>-<region>` `[e.g. rg-atlasdemo-dev-eastus]`
- **Target Subscription:** `[Corporate subscription ID]`
- **Primary Azure Region:** `[e.g. eastus, eastus2, centralus, westeurope]`
- **Lifecycle / TTL (Time-To-Live):** `[e.g. Permanent / 90 days / Evaluation]`

### Mandatory Tagging Policy (FinOps Tags for Cost Allocation)
All resources deployed in this Resource Group must include the following tags:

| Tag Key | Required Value | Purpose / Description |
| :--- | :--- | :--- |
| `Project` | `<project-name>` | Unique project identifier |
| `Environment` | `dev` \| `staging` \| `prod` | Environment isolation tier |
| `Owner` | `<tech-lead-email>` | Engineering contact for incidents |
| `CostCenter` | `<accounting-code>` | Billing and budget chargeback code |
| `DataClassification` | `Internal` \| `Confidential` | Protection tier per NIST CSF 2.0 PR.DS |
| `AutoShutdown` | `true` \| `false` | Enables scheduled shutdown outside business hours |
| `BusinessHours` | `08:00-18:00-EST-Mon-Fri` | Active window for non-production environments |

---

## 3. Detailed Breakdown of Requested Azure Services

Architectural justification and requested SKUs:

### A. Compute and API Tier
- **Azure Functions (Consumption Plan Y1 or Flex Consumption):**
  - *Justification:* Execution of business logic and serverless, event-driven REST API endpoints.
  - *Cost Optimization:* Scales to zero instances during idle periods ($0.00 USD at rest).
  - *Identity Assignment:* Requires System-Assigned Managed Identity to access Key Vault and SQL without hardcoded credentials.
- **Azure App Service (Optional, when using SP-04 or Docker containers):**
  - *Requested SKU:* `Basic B1` (Linux) for dev; `Standard S1` or `Premium v3` for production high-availability.

### B. Frontend and Web Delivery Tier
- **Azure Static Web Apps (SWA):**
  - *Requested SKU:*
    - `Free Tier` ($0/mo) for development, early validation, and low-volume internal portals.
    - `Standard Tier` ($9/mo) for environments requiring enterprise SLAs, custom domain apex, or private endpoints.
  - *CI/CD Integration:* Automated deployment via GitHub Actions or Azure DevOps Pipelines.

### C. Data and Persistence Tier
- **Azure Table Storage (Storage Account Standard LRS Hot):**
  - *Justification:* High-speed, ultra-low-cost key-value entity persistence (SP-01, SP-02 patterns).
  - *Cost Optimization:* Locally redundant storage (LRS). Do not enable GRS (geo-redundancy) in development.
- **Azure SQL Database Serverless (SP-02 or SP-04 pattern):**
  - *Service Tier:* General Purpose Serverless.
  - *Capacity Configuration:* Minimum: `0.5 vCore` -- Maximum: `1.0 vCore` (or `2.0 vCore` in light production).
  - *Mandatory FinOps Rule:* **Auto-Pause Delay set to 60 minutes**. When no connections occur for 60 minutes, compute pauses automatically, billing only for storage (~$0.115/GB-month).
- **Azure Cosmos DB (Optional, SP-03 pattern):**
  - *Capacity Mode:* Serverless (pay-per-RU) or utilize the *Cosmos DB Free Tier* (1,000 RU/s and 25 GB storage free per subscription).
- **Azure Cache for Redis (Optional, SP-04 pattern):**
  - *Requested SKU:* `Basic C0` (250 MB) or `Basic C1` (1 GB) without replication for non-critical tiers.

### D. Identity and Authentication Tier (UXP-05: Enterprise SSO)
- **Microsoft Entra ID (App Registration):**
  - *Resource Type:* App Registration in the corporate Microsoft Entra ID tenant.
  - *Registration Name:* `app-<project>-<environment>-auth`
  - *Protocol:* OIDC (OpenID Connect) / OAuth 2.0.
  - *Requested Redirect URIs:*
    - `https://<app-name>.azurestaticapps.net/.auth/login/aad/callback`
    - `https://localhost:4200/auth/callback` (for local development only).
  - *Requested Delegated API Permissions (Microsoft Graph):*
    - `User.Read` (Sign in and read basic user profile).
    - `openid`, `profile`, `email`.
  - *Tokens Required:* ID tokens and Access tokens for SPA / API authentication flows.
  - *Role and Group Claims:* Specify if Entra ID security group claims (`securityGroups`) are needed.
  - *Cost Note for IT:* **App Registrations in Microsoft Entra ID do not generate direct consumption charges on the Azure subscription**. They are covered under the corporate Microsoft 365 / Entra ID Free tenant license.

### E. Security and Secrets Tier
- **Azure Key Vault:**
  - *Requested SKU:* `Standard`.
  - *Authorization Model:* Azure role-based access control (Azure RBAC).
  - *Required Roles:* `Key Vault Secrets User` granted to the Function App or App Service Managed Identity.
  - *Cost Optimization:* Operations carry nominal fees ($0.03 per 10,000 operations). Applications implement in-memory secret caching to keep remote lookups to a minimum.

### F. Observability and Telemetry Tier
- **Azure Monitor / Application Insights & Log Analytics Workspace:**
  - *Requested SKU:* Pay-as-you-go.
  - *Mandatory FinOps Rules:*
    - Daily Ingestion Cap (*Daily Cap*): Configured at `1.0 GB/day` to prevent billing runaway from recursive error loops.
    - Retention Period: Set to `30 days` (basic 30-day retention carries no additional archive fees).
    - Free Tier Utilization: First 5 GB of data ingestion per billing account each month is free.

---

## 4. Live Price Lookup Engine

To ensure cost accuracy and allow on-demand price refreshes, utilize the **public Azure Retail Prices API**, which requires no API keys or authentication:

### Direct REST API Query
Official Microsoft Azure endpoint:
```text
GET https://prices.azure.com/api/retail/prices?$filter=<odata-filter>
```

### Automated PowerShell Script (Included in Repository)
The repository includes the parameterized script [`scripts/get-azure-prices.ps1`](file:///c:/Sources/Atlas_AI/scripts/get-azure-prices.ps1). Run it from any PowerShell 5.1 or PowerShell 7 terminal:

```powershell
# Query prices for East US region with Markdown table output
pwsh scripts/get-azure-prices.ps1 -Region eastus -OutputFormat Markdown

# Or query specific services for another region (e.g. westeurope)
pwsh scripts/get-azure-prices.ps1 -Region westeurope -Services Functions,SQL,StaticWebApps,KeyVault -OutputFormat Table
```

### Rate Limiting and Retry Handling
The public Azure Retail Prices API enforces rate limits (HTTP 429). The [`scripts/get-azure-prices.ps1`](file:///c:/Sources/Atlas_AI/scripts/get-azure-prices.ps1) script automatically incorporates pauses and exponential backoff to ensure reliable retrieval.

---

## 5. Monthly Cost Estimation Table

The following monthly cost estimate is based on the public Azure Retail Prices API and reflects an optimized baseline for development and light production:

| Category | Requested Service | SKU / Tier | Billing Metric | Estimated Usage / Month | Estimated Unit Price (USD) | Estimated Subtotal / Month (USD) | Applied FinOps Policy |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Compute** | Azure Functions | Consumption (Y1) | Million executions | 2,000,000 executions | $0.20 per million (1st million free) | **$0.20** | Scales to zero instances when idle. |
| **Compute** | Azure App Service (Optional) | Basic B1 Linux | Execution hours | 220 hours (08:00-18:00 Mon-Fri) | $0.017 per hour | **$3.74** | Scheduled shutdown outside business hours (~70% savings). |
| **Frontend** | Azure Static Web Apps | Standard (or Free) | Fixed monthly fee | 1 web application | $9.00 / mo (or $0 on Free Tier) | **$9.00** | Use Free Tier in Dev/Test ($0/mo). |
| **Database** | Azure SQL Database | Serverless GP (0.5 vCore) | Active vCore-seconds + Storage | 100 active hours + 10 GB storage | $0.52 / vCore-hour + $0.115 / GB-month | **$27.15** | Auto-pause at 60 min. ~75% savings vs provisioned DB ($120+). |
| **Storage** | Azure Storage Account | Standard LRS Hot | GB-month + Operations | 15 GB + 100,000 ops | $0.045 / GB-mo + $0.005 / 10k ops | **$0.73** | Local LRS instead of geo-redundant GRS. |
| **Identity** | Microsoft Entra ID | App Registration | OIDC / SSO Registration | 1 app registration | $0.00 (Included in corporate tenant) | **$0.00** | Zero compute charge on Azure subscription. |
| **Security** | Azure Key Vault | Standard | API Operations | 20,000 operations | $0.03 per 10,000 ops | **$0.06** | In-memory secret caching in application runtime. |
| **Monitoring** | Log Analytics / App Insights | Pay-as-you-go | Data Ingestion (GB) | 6 GB ingested / mo | $2.30 / GB (first 5 GB/mo free) | **$2.30** | 1 GB/day cap and strict 30-day retention. |
| **TOTAL** | **Estimated Monthly Budget** | -- | -- | -- | -- | **~$43.18 USD** | *(With Free Tier SWA: ~$34.18 USD)* |

*Note: This table can be updated at any time by executing the pricing lookup script and adjusting values according to regional variations or transaction volume.*

---

## 6. Active Cost Savings and FinOps Governance

To keep recurring costs minimized over time, engineering and IT teams agree to the following operational commitments:

1. **Database Auto-Pause:**
   - Azure SQL Serverless must have `autoPauseDelay` configured to `60` minutes. If no queries arrive for 1 hour, compute pauses and costs stop 100%.
2. **Serverless-First Compute:**
   - Dedicated virtual machines or Always-On instances must not be used for intermittent workloads. Azure Functions in Consumption plan incur zero cost when idle.
3. **Strict Telemetry Caps:**
   - The Log Analytics Workspace must enforce a Daily Cap of 1.0 GB to protect against runaway billing from unexpected error storms.
4. **Scheduled Auto-Shutdown:**
   - Any hourly billed non-production VMs or App Service instances must subscribe to an automated 18:00 local time shutdown schedule.
5. **Azure Dev/Test Benefit Alignment:**
   - Development workloads should reside in Azure Dev/Test subscriptions under corporate Enterprise Agreements (EA) or Microsoft Customer Agreements (MCA) to benefit from reduced SQL and compute rates.
6. **Azure Cost Management Budget Alerts:**
   - IT will configure a budget alert on the Resource Group at the approved limit (e.g. $50.00 USD/month) with automated email notifications:
     - 50% consumed (Informational).
     - 80% consumed (Warning).
     - 100% consumed (Critical review).

---

## 7. Security and Compliance Verification (NIST CSF 2.0)

In alignment with [`docs/reference/nist-csf-2-guide.md`](file:///c:/Sources/Atlas_AI/docs/reference/nist-csf-2-guide.md):

- **Identity and Access Control (PR.AC):**
  - Resource access via Managed Identities using Least Privilege.
  - User authentication delegated exclusively to Microsoft Entra ID via OIDC/SSO (UXP-05).
- **Data Protection (PR.DS):**
  - Encryption at rest enabled by default on Storage Accounts and SQL Database (Transparent Data Encryption - TDE).
  - Mandatory encryption in transit (HTTPS / TLS 1.2+ on API endpoints and Web Apps).
  - Zero secrets stored in git or unencrypted configuration files. Use `secrets.md` for local notes and Azure Key Vault for deployed environments.

---

## 8. Formal IT Review and Approval Sign-Off

| Role / Department | Reviewer Name | Status | Review Date | Electronic Approval / Ticket ID |
| :--- | :--- | :--- | :--- | :--- |
| **Cloud Infrastructure Lead** | [Filled by IT] | `[ ] Approved` \| `[ ] Changes Required` | [YYYY-MM-DD] | [Ticket ID or Signature] |
| **Security Officer / CISO** | [Filled by IT] | `[ ] Approved` \| `[ ] Changes Required` | [YYYY-MM-DD] | [Ticket ID or Signature] |
| **Budget / FinOps Approver** | [Filled by Finance] | `[ ] Approved` \| `[ ] Changes Required` | [YYYY-MM-DD] | [Ticket ID or Signature] |

### IT-Assigned Provisioning Details (Post-Approval)
*To be filled by IT Administrator following provisioning and recorded in [`accounts.md`](file:///c:/Sources/Atlas_AI/accounts.md):*

- **Assigned Subscription:** `________________________________________`
- **Provisioned Resource Group:** `________________________________________`
- **Final Region:** `________________________________________`
- **Entra ID Client ID (SSO):** `________________________________________`
- **Application Base URL:** `________________________________________`
- **IT Ticket / Request Number:** `________________________________________`
