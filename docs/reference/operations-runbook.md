# Operations and Production Resilience Runbook

> **Purpose:** Standard operational runbook for health monitoring, credential rotation, incident response, data backup, and disaster recovery procedures across applications deployed with the Atlas_AI architecture.

---

## 1. Observability and Health Monitoring (SLIs / SLOs)

### Service Level Indicators (SLIs) and Objectives (SLOs)
| Metric (SLI) | Target (SLO) | Data Source | Alert Trigger |
| :--- | :--- | :--- | :--- |
| **API Availability** | >= 99.9% monthly | Application Insights Availability | Alert if availability < 99.5% over 5 min |
| **p95 Latency (Read APIs)** | < 350 ms | Application Insights Requests | Alert if p95 > 1000 ms over 10 min |
| **HTTP 5xx Error Rate** | < 0.1% of requests | Application Insights Failed Requests | Immediate alert if 5xx > 1% in 5 min window |
| **Daily Ingestion Cap (FinOps)**| < 1.0 GB / day | Log Analytics Workspace Capping | Alert at 80% of Daily Cap threshold |

### Diagnostic KQL Queries for Log Analytics
```kusto
// 1. Identify top exceptions and errors over the last hour
exceptions
| where timestamp > ago(1h)
| summarize Count = count() by type, innermostMessage, operation_Name
| order by Count desc

// 2. Compute 50th, 90th, and 95th percentile latency for API endpoints
requests
| where timestamp > ago(6h) and url startswith "http"
| summarize p50 = percentile(duration, 50), p90 = percentile(duration, 90), p95 = percentile(duration, 95) by name
| order by p95 desc
```

---

## 2. Credential Rotation Procedure (Zero-Downtime)

Rotation of keys and secrets (e.g. Entra ID Client Secrets, Storage Account keys) occurs every 90 days following the **Dual-Secret Overlap** model:

1. **Generation:** In Microsoft Entra ID or Azure Key Vault, generate a new version of the secret (Secret B) with a 180-day lifespan.
2. **Coexistence:** Leave Secret A active. Both credentials remain concurrently valid on the identity provider.
3. **Key Vault Update:** Store Secret B in Azure Key Vault under the existing secret name as the active version.
4. **Graceful Reload:** Azure Functions reload secrets from Key Vault automatically upon container refresh. Force a refresh using:
   ```powershell
   az functionapp restart --name <func-name> --resource-group <rg-name>
   ```
5. **Verification:** Execute [`scripts/smoketest.ps1`](file:///c:/Sources/Atlas_AI/scripts/smoketest.ps1) to verify authenticated endpoints process requests normally.
6. **Decommissioning:** After 24 hours of zero traffic on Secret A, disable and delete Secret A.

---

## 3. Data Backup and Disaster Recovery

### Azure SQL Database Serverless
- **Automated Backups:** Azure SQL performs continuous, automated Point-in-Time Restore (PITR) backups with 7 to 35-day retention at no extra charge.
- **Restore Procedure:**
  ```powershell
  az sql db restore `
    --resource-group <rg-name> `
    --server <server-name> `
    --name <original-db> `
    --dest-name <restored-db> `
    --time "2026-09-25T14:30:00Z"
  ```

### Azure Table Storage
- **Backup Policy:** Execute scheduled table exports to immutable Blob Storage containers (WORM policies).
- **Recovery:** Ingest entities from the backup container via Azure Data Factory or PowerShell migration scripts.

---

## 4. Cold-Start Mitigation

In the serverless Consumption Plan (Y1), functions idle for more than 20 minutes can encounter a 1.5 to 3-second startup penalty:

1. **Keep-Alive Timer Trigger:** Where initial latency is critical without justifying a Premium Plan ($150+/mo), configure a lightweight timer trigger executing every 10 minutes (`0 */10 * * * *`) to keep runtime workers warm.
2. **Minimize Cold Dependencies:** Avoid heavy global module imports outside function entry points.
3. **Connection Pooling:** Reuse HTTP clients (`HttpClient` in .NET, singleton `TableClient` in Node/Python) outside function handlers to maintain TCP connection pools.

---

## 5. Immediate Rollback Procedure (Failed Deployments)

If a production deployment introduces critical regressions or fails smoketests:

### Azure Static Web Apps Rollback
- Static Web Apps tracks deployment history within GitHub Actions / Azure DevOps.
- To roll back to the prior stable release:
  ```powershell
  # 1. Revert faulty commit on main branch
  git revert HEAD --no-edit
  git push origin main
  # 2. CI/CD pipeline redeploys the prior release in < 2 minutes.
  ```

### Azure Functions Rollback
- Using Deployment Slots:
  ```powershell
  az functionapp deployment slot swap `
    --resource-group <rg-name> `
    --name <func-name> `
    --slot staging `
    --action swap
  ```
- Using standard Consumption plan: Redeploy the previous version package archived in GitHub Actions artifacts.
