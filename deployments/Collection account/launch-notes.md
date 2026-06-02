# Pre-Launch Sync Notes

**Feature:** Collection Account Automation (Merchant Layer)
**Go-live:** TBC
**Date generated:** 2026-05-28
**Teams covered:** Compliance — Onboarding, Compliance — Transaction Monitoring, Risk, Payment Operations, Treasury, Sales / Account Management, Legal / Licensing, Banking Partnerships / Payments Pod

> ⚠️ "Teams to Brief" not found in PRD — selected the 8 most-impacted teams. Add a "## Teams to Brief" section to the PRD to lock the list.

---

## Common Context

> Read this first. All team sections below assume you've read this.

**Why we're doing this**
Treasury upside — more collection accounts at Tazapay means more collects and more merchant balances parked with us. Today fintechs and platforms can't request VAs and wallets on the fly for their customers; they go through support or sales each time. This launch makes the request flow self-serve via API and dashboard for Virtual Accounts (fiat) and stablecoin wallets (USDT/USDC).

**What's changing**

| Area | What changes | Who this affects |
|---|---|---|
| Account creation | Self-serve `POST /v3/collection_account` for Virtual Accounts and stablecoin wallets (USDT/USDC across multiple blockchains) | All API + dashboard merchants with collections enabled |
| Capability discovery | New `GET /v3/metadata/collection_accounts/virtual_account` and `/wallet` endpoints; capabilities and provider ranking driven by N8N (business-editable) | Merchants + Sales pitching coverage |
| Request lifecycle | New state machine: `NOT_INITIATED → INITIATED → SUCCEEDED / FAILED / REQUIRES_ACTION / APPROVAL_HOLD / PROCESSING_RETRY / CANCELLED` | Ops + merchants |
| Approval gate | Collect-purpose entities must clear full KYB and entity approval before VA/wallet creation; requests sit in `APPROVAL_HOLD` until cleared | Compliance Onboarding + merchants |
| Webhooks and emails | 9 new events (`creation_failed`, `creation_requires_action`, `creation_under_approval_hold`, `creation_under_processing`, `creation_cancelled`, plus four `disablement_*` variants); all email templates updated with Supported Currencies | All collection-account merchants |
| Fees | New `balance_transaction.type = collection_account_creation` with `one_time_setup_fee` and `maintenance_fee` (monthly/yearly), configurable per merchant with capability-level defaults | Merchants + Finance + Sales |
| RBAC | New `Global Collection account` permission group with `View` (default for existing managers) and `Manage account` | Merchant dashboard users |
| Wallet vs VA behaviour | Wallets cannot be disabled — disablement removed from ops and merchant dashboards; VA disablement soft-deletes on at least one provider, supporting re-enablement on the same account | Ops + merchants |

**At a glance**

| | |
|---|---|
| **Geographies** | Multiple — surfaced dynamically via N8N capability workflow |
| **Entity types** | Merchants directly, plus sub-entities via `on_behalf_of` (per-capability `restricted_industry_verticals`) |
| **Customer segments** | All API-integrated and dashboard merchants with collections enabled; fintechs and platforms primary target |
| **Payment rails / PSPs** | Multiple fiat VA providers and stablecoin rails — capability and ranking driven by N8N |
| **New corridors / currencies** | TBC — surfaced via N8N capability workflow |
| **Rollout strategy** | TBC |
| **Sardine involved** | No |
| **Forter involved** | No |

**Open questions (from PRD)**
- Soft-delete-then-re-enable on the same account — engineering to verify across all providers, not just the one confirmed
- File size limits for `REQUIRES_ACTION` document uploads — engineering to confirm
- N8N provider-ranking coverage at launch for every active capability
- Account-closure rejection — confirmed to fall back to active, but end-to-end UX to verify

---

## Compliance — Onboarding

**Actions**
- Sign off on `APPROVAL_HOLD` — every collect-purpose entity needs full KYB and entity approval before VA/wallet creation
- Define SLA for the approval queue — delays here block self-serve creation on both API and dashboard

---

## Compliance — Transaction Monitoring

**Actions**
- Confirm rule coverage for stablecoin USDT/USDC collects across the supported blockchains
- Validate alert routing when collects are attributed to a sub-entity via `on_behalf_of`

---

## Risk

**Actions**
- Sign off on per-capability `restricted_industry_verticals` for `on_behalf_of` collects
- Define risk posture for stablecoin wallet collects — USDT/USDC across multiple blockchains is a new surface
- Confirm `PROCESSING_RETRY` audit trail — ops-triggered retry fails the original request and creates a new one

---

## Payment Operations

**Ops actions**
- Define triage owner and SLA for `APPROVAL_HOLD`, `REQUIRES_ACTION`, and `PROCESSING_RETRY`
- Confirm reconciliation for `one_time_setup_fee` and `maintenance_fee` balance transactions
- Remove disablement from ops and merchant dashboards for wallets — wallets cannot be disabled

**Partner onboarding actions**
- Verify sandbox simulates state transitions, retries, and webhooks across all capabilities

---

## Treasury

**Context**
PRD motivates this launch by treasury upside — more collection accounts = more collects = more merchant balances parked with Tazapay.

**Actions**
- Model expected uplift in collect volumes and balances held — volumes TBC, confirm with Product
- Define liquidity approach for stablecoin wallet custody — USDT/USDC across multiple blockchains is new scope

---

## Sales / Account Management

**Actions**
- Pitch self-serve VA/wallet creation to fintech and platform prospects — primary target per PRD
- Align commercial terms on `one_time_setup_fee` and `maintenance_fee` — both configurable per merchant

**Watch-out**
- Launch coverage is bounded by what the metadata API returns — do not promise unsupported country, currency, or account-type combinations

---

## Legal / Licensing

**Actions**
- Map every capability returned by the metadata API to existing licence scope — flag out-of-scope jurisdictions
- Confirm stablecoin custody (USDT/USDC across multiple blockchains) sits within existing legal and licensing framework
- Confirm `maintenance_fee` deduction is covered by existing merchant ToS and licensed permissions

---

## Banking Partnerships / Payments Pod

**Context**
N8N drives capability metadata and provider ranking — runtime dependency for every creation request.

**Actions**
- Confirm N8N latency, caching, and fallback behaviour when unavailable
- Verify soft-delete-then-re-enable on the same account across all providers — only one confirmed per PRD
- Review existing commercial agreements for self-serve volumes and `on_behalf_of` attribution

---

*Each team reads their section. Common Context applies to all. Actions / Blockers / Watch-out items are the pre-launch checklist — escalate before go-live, not after.*
