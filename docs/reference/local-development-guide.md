# Local Development and Offline Emulation Guide

> **Purpose:** Enable software engineers to build, test, and debug complete Atlas_AI applications locally, 100% offline at zero cloud cost ($0 USD), without waiting for IT resource approvals or Azure provisioning.

---

## 1. Local Development Environment Architecture

The local development stack replicates the Azure cloud environment using official Microsoft emulators:

```text
+-------------------------------------------------------------------------+
|                  Azure Static Web Apps CLI (Port 4280)                  |
|                                                                         |
|   +--------------------------+         +----------------------------+   |
|   |   Frontend SPA Dev Server|         |   Mock Auth Emulator       |   |
|   |   (React, Vue, Vite, etc)|         |   (http://localhost:4280   |   |
|   |   Port 3000 / 5173       |         |    /.auth/login/aad)       |   |
|   +--------------------------+         +----------------------------+   |
|                 |                                    |                  |
|                 v                                    v                  |
|   +-------------------------------------------------------------+       |
|   |         Azure Functions Core Tools (Port 7071)              |       |
|   |         Backend APIs, REST Endpoints, HTTP Triggers         |       |
|   +-------------------------------------------------------------+       |
|                                 |                                       |
+---------------------------------|---------------------------------------+
                                  v
+-------------------------------------------------------------------------+
|                       Azurite Storage Emulator                          |
|                       Port 10000 (Blob) / 10002 (Table)                 |
+-------------------------------------------------------------------------+
```

---

## 2. Required Tools (Prerequisites)

Install standard Azure local development tools (all free and open-source):

1. **Node.js (LTS v18 or v20+):** `https://nodejs.org`
2. **Azure Static Web Apps CLI:**
   ```bash
   npm install -g @azure/static-web-apps-cli
   ```
3. **Azure Functions Core Tools (v4):**
   ```bash
   npm install -g azure-functions-core-tools@4 --unsafe-perm true
   ```
4. **Azurite (Local Storage Emulator):**
   ```bash
   npm install -g azurite
   ```

---

## 3. Microsoft Entra ID Authentication Emulation (SSO / UXP-05)

The key benefit of the SWA CLI is that it **fully emulates the Entra ID login lifecycle without internet access or live credentials**:

### Mock Sign-In Workflow
1. In your application, navigate the user to:
   ```text
   http://localhost:4280/.auth/login/aad
   ```
2. SWA CLI displays a local mock login interface where developers can:
   - Provide a mock email (e.g. `dev.user@company.com`).
   - Provide a display name (e.g. `Alice Developer`).
   - Assign test roles (e.g. `admin`, `authenticated`, `finance-reviewer`).
3. Click "Submit" to generate a local session cookie and redirect back to the application.

### Resolving User Identity
Both frontend and backend code inspect authenticated claims without extra token libraries:
- **From Frontend:**
  ```javascript
  const res = await fetch('/.auth/me');
  const { clientPrincipal } = await res.json();
  console.log('User Details:', clientPrincipal.userDetails);
  console.log('Assigned Roles:', clientPrincipal.userRoles);
  ```
- **From Backend (Azure Functions):**
  The `x-ms-client-principal` header is automatically injected into incoming requests by the SWA proxy, containing the Base64-encoded client principal object.

---

## 4. Persistence Emulation with Azurite (Table Storage & Blobs)

For local data persistence (SP-01, SP-02, SP-05 patterns):

1. Start Azurite in a background terminal:
   ```bash
   azurite --silent --location .azurite
   ```
2. Configure the local connection string in `local.settings.json` (ignored by git):
   ```json
   {
     "IsEncrypted": false,
     "Values": {
       "AzureWebJobsStorage": "UseDevelopmentStorage=true",
       "FUNCTIONS_WORKER_RUNTIME": "node",
       "TABLES_CONNECTION_STRING": "UseDevelopmentStorage=true"
     }
   }
   ```
3. Calls using `@azure/data-tables` or `@azure/storage-blob` execute against the local emulator instantly without incurring Azure billing.

---

## 5. Unified Startup with SWA CLI

Orchestrate frontend and backend execution in a single command:

```bash
# Example: React/Vite on port 5173 with Azure Functions on port 7071
swa start http://localhost:5173 --api-location ./api --run "npm run dev"
```

The unified reverse proxy is hosted at `http://localhost:4280`:
- `http://localhost:4280/` -> Frontend with Hot Module Replacement (HMR).
- `http://localhost:4280/api/*` -> Azure Functions backend.
- `http://localhost:4280/.auth/*` -> Entra ID mock authentication engine.

You can also run the automated launcher script [`scripts/dev-local.ps1`](file:///c:/Sources/Atlas_AI/scripts/dev-local.ps1) provided in this kit.
