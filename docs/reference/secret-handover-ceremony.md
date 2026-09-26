# Protocol and Secure Secret Handover Ceremony

> **Purpose:** Establish the standard corporate protocol for generating, exchanging, receiving, storing, and rotating critical credentials (API keys, Entra ID Client Secrets, connection strings, certificates, and service tokens) between corporate IT / CISO teams and development engineering teams on Atlas_AI projects.

---

## 1. Fundamental Security Principles (Zero-Trust and NIST CSF 2.0)

This protocol is grounded in the access and data integrity principles of NIST CSF 2.0 ([`docs/reference/nist-csf-2-guide.md`](file:///c:/Sources/Atlas_AI/docs/reference/nist-csf-2-guide.md)):

1. **Zero Open-Channel Exposure:**
   - Transmitting plaintext passwords, keys, or secrets via email, enterprise chat (Teams, Slack), ticketing systems (Jira, ServiceNow), or unencrypted messaging is strictly prohibited.
2. **No Human Access in Production:**
   - Wherever technically viable, no human should view or manipulate production secrets. Secrets must be generated and provisioned directly into **Azure Key Vault** via automation or privileged IT administrators.
3. **Out-of-Band (OOB) Verification:**
   - If a decryption passphrase or integrity confirmation is required, it must travel over an entirely independent communications channel from the encrypted secret payload (e.g. encrypted ephemeral link via ticket, password via voice call or SMS).
4. **Strict Isolation from Source Code:**
   - No secret may ever be committed to git. For local developer notes, use [`secrets.md`](file:///c:/Sources/Atlas_AI/secrets.md) at the repository root exclusively (ignored by git by design). Non-confidential identifiers are recorded in [`accounts.md`](file:///c:/Sources/Atlas_AI/accounts.md).

---

## 2. Three Standard Exchange Methods

Depending on the credential classification and target environment, select one of the following methods:

### Method 1: Direct Injection into Azure Key Vault (Recommended Cloud Standard)
*Applicable to: Staging and Production environments, Entra ID Client Secrets, Storage Account keys, and SQL connection strings.*

1. The IT administrator creates the secret directly within the project Azure Key Vault instance (`kv-<project>-<environment>`).
2. A **System-Assigned Managed Identity** is enabled on the compute service (Azure Functions or App Service).
3. IT grants the RBAC role `Key Vault Secrets User` to that Managed Identity.
4. **Outcome:** Engineers never handle the secret. The application resolves it directly at runtime in-memory without human exposure.

### Method 2: Zero-Knowledge One-Time Ephemeral Secret Link
*Applicable to: Third-party API keys (e.g. Stripe, SendGrid, OpenAI), local development mock secrets, and external partner credentials.*

1. The sender (IT) uses an enterprise zero-knowledge ephemeral transmission tool with client-side browser encryption (e.g. Bitwarden Send, 1Password, or an internal One-Time Secret instance).
2. The following mandatory policies are configured:
   - **Time expiration:** Maximum 1 hour (or 24 hours depending on time zones).
   - **View limit:** Exactly 1 view (*Destroy immediately after access*).
   - **Passphrase protection:** Mandatory password protection enabled.
3. The secret link is shared in the formal IT ticket.
4. The decryption passphrase is communicated via an out-of-band (OOB) channel, such as an authenticated voice call, Signal message, or in-person confirmation.

### Method 3: Asymmetric PGP/GPG or Age File Encryption
*Applicable to: SSL/TLS private certificates (.pfx), private SSH keys, and sensitive infrastructure configuration bundles.*

1. The recipient (Project Tech Lead) provides their verified public PGP key or public `age` key.
2. The sender encrypts the artifact using the recipient public key.
3. The resulting ciphertext file (`.gpg` or `.age`) can be safely transmitted through standard project communication channels.
4. Only the recipient private key, protected by a passphrase and physical token (e.g. YubiKey), can decrypt the contents.

---

## 3. Handover Ceremony Protocol (Step-by-Step)

Formal credential handovers between IT and project teams follow these 6 phases:

```text
+-------------------+      +-------------------+      +-------------------+
|  Phase 1: Request | ---> |  Phase 2: Deposit | ---> |  Phase 3: Secure  |
|  Formal (Ticket)  |      |  or Encryption    |      |  Transfer / OOB   |
+-------------------+      +-------------------+      +-------------------+
                                                            |
+-------------------+      +-------------------+            v
|  Phase 6: Closeout| <--- |  Phase 5: Secure  | <--- +-------------------+
|  and Log Audit    |      |  Record / Vault   |      |  Phase 4: Checksum|
+-------------------+      +-------------------+      |  Verification     |
                                                      +-------------------+
```

### Phase 1: Formal Request and Context
- The project lead opens a formal ticket in the IT service portal (ServiceNow, Jira Service Desk), referencing the [`docs/reference/azure-resource-request-template.md`](file:///c:/Sources/Atlas_AI/docs/reference/azure-resource-request-template.md).
- The secret identifier name (e.g. `EntraID--ClientSecret`), target environment, and required validity period are specified.

### Phase 2: Generation and Custody by IT
- IT generates the secret with complexity and entropy conforming to security standards (minimum 32 alphanumeric characters or 256-bit cryptographic keys).
- IT computes the **SHA-256 hash** of the secret for integrity verification:
  ```powershell
  # Calculate SHA-256 hash in PowerShell without echoing plaintext to console
  $secretText = "secret-value-here"
  $bytes = [System.Text.Encoding]::UTF8.GetBytes($secretText)
  $hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes)
  [System.BitConverter]::ToString($hash).Replace('-', '').ToLower()
  ```

### Phase 3: Secure Transfer and Out-of-Band Channel
- If Method 1: IT confirms the secret URI in Azure Key Vault (`KeyVault://kv-atlas-prod/EntraID--ClientSecret`).
- If Method 2 or 3: IT sends the encrypted artifact via the official ticket and provides the key/passphrase via the secondary OOB channel.

### Phase 4: Integrity Checksum Verification
- The recipient decrypts or receives the secret and independently calculates its SHA-256 hash.
- Both parties compare the first 4 and last 4 characters of the hash over the secondary channel. Matching checksums confirm the payload was not altered or truncated in transit.

### Phase 5: Secure Storage and Non-Disclosure
- For local development: The developer saves the secret exclusively into [`secrets.md`](file:///c:/Sources/Atlas_AI/secrets.md) or a local `.env.local` file (both ignored by git).
- For project architecture: Update [`accounts.md`](file:///c:/Sources/Atlas_AI/accounts.md) with the secret reference name and Key Vault path, never writing plaintext values.

### Phase 6: Purge Temporary Copies and Audit Log Closeout
- Clear clipboard histories and ensure ephemeral links are destroyed.
- Complete the Secret Handover Log entry within the IT ticket.

---

## 4. Secret Handover Record Template (Handover Log)

Record this verification table in the official IT ticket upon completing the ceremony:

| Log Field | Recorded Detail |
| :--- | :--- |
| **UTC Timestamp** | [YYYY-MM-DD HH:MM:SS UTC] |
| **Secret / Key Identifier** | `[e.g. EntraID--ClientSecret / Stripe--WebhookKey]` |
| **Target Environment** | `[ ] Development (Dev)` \| `[ ] Staging` \| `[ ] Production` |
| **Sender (IT / CISO)** | [Name and title of IT administrator] |
| **Recipient (Project Lead)** | [Name and title of recipient] |
| **Exchange Method Used** | `[ ] Direct Key Vault Injection` \| `[ ] Ephemeral OOB Link` \| `[ ] PGP Encryption` |
| **Out-of-Band Channel Used** | `[ ] Voice Call` \| `[ ] Authenticated Signal/SMS` \| `[ ] In-Person` |
| **Verification SHA-256 Hash** | `[First 4 and last 4 characters, e.g.: a3f1...89c2]` |
| **Permanent Storage Location** | `[e.g. Azure Key Vault: kv-atlas-prod]` |
| **Next Scheduled Rotation** | [YYYY-MM-DD] (Max 90 or 180 days) |
| **IT Ticket / Request ID** | [CR-10492 / INC-99482] |

---

## 5. Secret Rotation Lifecycle (Zero-Downtime)

To prevent service downtime during credential updates, apply the **Dual-Secret Overlap** technique:

```text
Step 1: Secret A is active in production.
Step 2: IT creates Secret B in Key Vault as a secondary valid version.
Step 3: Applications are updated to accept Secret A or Secret B.
Step 4: External clients or consumers migrate traffic to Secret B.
Step 5: After confirming zero traffic on Secret A, IT revokes and deactivates Secret A.
```

### Emergency Revocation Procedure (NIST CSF 2.0 RS.AN)
1. **Immediate Notification:** Alert the Chief Information Security Officer (CISO) and Technical Lead within 15 minutes of any suspected leak.
2. **Forced Revocation:** IT immediately disables the compromised credential in Entra ID or Azure Key Vault.
3. **Regeneration:** A new secret is generated following Method 1 or Method 2 of this ceremony.
4. **Forensic Analysis:** Review Log Analytics and Key Vault audit logs to determine if the compromised credential was accessed by unauthorized IP addresses.
