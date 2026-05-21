# Pre-Launch Sync Notes

**Feature:** Collection Account Automation (Merchant Layer)
**Go-live:** TBC
**Date generated:** 2026-05-21
**Teams covered:** Compliance — Onboarding, Compliance — Transaction Monitoring, Risk, Payment Operations, Treasury, Sales / Account Management, Legal / Licensing, Banking Partnerships / Payments Pod

---

## Common Context

> Read this first. All team sections below assume you've read this.

**What we're launching**
Self-serve creation of Virtual Accounts (fiat) and stablecoin wallets (USDT/USDC across multiple blockchains) via API and merchant dashboard. Today merchants request collection accounts manually through support or sales; this launch lets fintechs and platforms request VAs and wallets on the fly for their customers. Scope includes a new Metadata API to discover capabilities, a `/v3/collection_account` API, a request state machine, fee deduction for setup and maintenance, new webhook events, RBAC, and sandbox simulation. Explicit treasury upside: more collection accounts = more collects = more merchant balances parked with Tazapay.

**Who it affects**
- **Customer segments:** All API-integrated and dashboard merchants with collections enabled — fintechs and platforms needing on-the-fly VAs are the primary target
- **Geographies:** Multiple — wherever the metadata API surfaces VA/wallet capabilities
- **Entity types:** Merchants directly, plus sub-entities via `on_behalf_of` (per-capability restricted industry verticals apply)

**Key technical facts**
- **New endpoints:** `GET /v3/metadata/collection_accounts/virtual_account`, `GET /v3/metadata/collection_accounts/wallet`, `POST /v3/collection_account`, `GET /v3/collection_account`
- **Metadata source:** N8N workflow (business-editable capability matrix); provider rank also resolved via N8N
- **Account types:** Virtual Accounts (fiat) and Wallets (USDT/USDC across multiple blockchains)
- **Request state machine:** `NOT_INITIATED → INITIATED → SUCCEEDED / FAILED / REQUIRES_ACTION / APPROVAL_HOLD / PROCESSING_RETRY / CANCELLED`
- **External states surfaced to merchants:** `processing`, `requires_action`, `approval_hold`, `succeeded`, `failed`, `cancelled`
- **Approval hold:** Full KYB and entity approval mandatory for all collect-purpose entities regardless of any simplified-entity config
- **Requires action:** Triggered by ops when a document is needed; merchants upload via Document API or dashboard against request ID
- **Processing retry:** Auto-retry on provider failures; ops-triggered retry fails the original request and creates a new one (mirrors payouts)
- **Webhooks added:** `creation_failed`, `creation_requires_action`, `creation_under_approval_hold`, `creation_under_processing`, `creation_cancelled`, `disablement_requires_action`, `disablement_under_processing`, `disablement_failed`, `disablement_cancelled` (additive to existing `creation_succeeded` and `disablement_succeeded`)
- **Email templates updated** for every state with Supported Currencies field
- **Fees:** New `balance_transaction.type = collection_account_creation` with `one_time_setup_fee` and `maintenance_fee` (monthly/yearly); configurable per merchant on ops dashboard; defaults per capability
- **RBAC:** New "Global Collection account" permission group with `View` and `Manage account`; existing managers default to View
- **`on_behalf_of` support:** Available on VAs and wallets with per-capability `restricted_industry_verticals`
- **Soft-delete on disablement:** Re-enablement on the same account supported for at least one provider; engineering to verify across all providers
- **Wallets cannot be disabled** — disablement removed from both ops and merchant dashboards for wallets
- **Sandbox parity** required across API, webhooks, and dashboard
- **Sardine involved:** Not mentioned in PRD
- **Forter involved:** Not mentioned in PRD

**Open questions (from PRD)**
- Soft-delete-then-re-enable on the same account — engineering to verify behaviour across all providers, not just the one confirmed
- File size limits for REQUIRES_ACTION document uploads — engineering to confirm
- Provider ranking via N8N — confirm coverage at launch for every active capability
- Account-closure rejection behaviour — confirmed to fall back to active, but confirm end-to-end UX

---

## Compliance — Onboarding

**Actions**
- Collect-purpose entities require full KYB and entity approval before VA creation — confirm SOP for the approval queue once self-serve volumes scale.
- Brief the `APPROVAL_HOLD` state — requests sit here until entity approval lands; define handoff between Compliance and ops.
- Confirm CDD expectations for crypto-enabled merchants — stablecoin wallets are new territory.

**Watch-out**
- Self-serve creation cannot bypass entity approval — confirm both API and dashboard surface the approval-hold state correctly and that no path lets a merchant skip review.

---

## Compliance — Transaction Monitoring

**Actions**
- Stablecoin rails (USDT/USDC across multiple blockchains) introduce new collect surfaces — confirm TM rules cover on-chain attribution and stablecoin typologies.
- Confirm TM coverage when collects are attributed to sub-entities via `on_behalf_of` (per-capability restricted industry verticals).
- Brief alert team on new webhook events — `creation_requires_action`, `approval_hold`, `processing_retry` — so suspicious patterns can be held rather than auto-completed.

**Watch-out**
- Self-serve creation lifts collection account volume materially — confirm rule thresholds scale with the larger collect-merchant base.

---

## Risk

**Actions**
- Crypto wallets are a materially different fraud surface from fiat VAs — confirm risk controls and limits per blockchain before launch.
- Confirm `PROCESSING_RETRY` auto-failover behaviour is acceptable from a risk standpoint — failed-then-retried requests must be logged.
- Sign off on per-capability `restricted_industry_verticals` lists for `on_behalf_of` collects.

**Scenarios**
- Bad-actor merchant uses self-serve API to spin up multiple VAs across corridors at high velocity. Mitigation: confirm rate-limits at the request layer and entity-approval gating.
- Stablecoin wallet used for high-velocity inflows that no current rule captures. Mitigation: new typology rules per blockchain and per stablecoin before launch.

---

## Payment Operations

**Ops actions**
- Define triage owner and SLA for new request states: `APPROVAL_HOLD`, `REQUIRES_ACTION`, `PROCESSING_RETRY`.
- Setup and maintenance fees auto-deduct from merchant balance — confirm reconciliation, fee-dispute path, and merchant-query workflow.
- Validate ops dashboard surfaces every state correctly — confirm `REQUIRES_ACTION` document upload is linked to the right request ID.

**Partner onboarding actions**
- Brief the exceptions team that wallets cannot be disabled — disablement option is removed for wallets on both ops and merchant dashboards.
- VA disablement may be a soft-delete on certain providers — confirm the disablement-failure runbook covers both paths.
- Sandbox parity for the entire request lifecycle — validate sandbox simulates state transitions, retries, and webhooks before merchants integrate.

---

## Treasury

**Context**
PRD explicitly motivates this launch by treasury upside — more collection accounts = more collects = more merchant balances parked with Tazapay. Stablecoin wallets bring on-chain custody into scope, distinct from fiat VAs.

**Actions**
- Confirm liquidity, float, and balance-management planning accounts for the projected post-launch uplift in collect volumes.
- Confirm prefunding requirements (if any) per new corridor and account-providing bank.
- Stablecoin custody (USDT/USDC across multiple blockchains) introduces new treasury operational considerations — confirm float and net-settlement process per supported blockchain.

**Watch-out**
- Volume of self-serve requests is expected to scale — flag any banking or prefunding constraints that would gate rollout pace.

---

## Sales / Account Management

**Actions**
- Pitch self-serve VA/wallet creation as a major differentiator for fintech and platform prospects who need accounts on-the-fly for their customers.
- Coordinate proactive outreach to existing collect merchants — surface the new self-serve flow ahead of launch.
- Setup and maintenance fees are configurable per merchant — clarify commercial expectations upfront so deals close with aligned terms.

**Watch-out**
- Coverage at launch is bounded by the metadata API — pitch only on country/currency/account-type combinations the API actually returns.
- New email and webhook events go to every collection-account merchant — coordinate comms so merchants aren't surprised by the additional notifications.

---

## Legal / Licensing

**Actions**
- New ToS surface — confirm merchant agreements cover self-serve request lifecycle, fee deduction, and disablement behaviour.
- Crypto wallet capability brings on-chain custody and stablecoin handling — confirm legal and licensing framework per launch jurisdiction.
- VAs across multiple new corridors — map each capability to existing PI/EMI licence scope per geography; flag out-of-scope jurisdictions.
- Confirm whether maintenance fees on collection accounts constitute a service fee within existing licensed permissions.

**Watch-out**
- Self-serve VA/wallet creation may constitute a material change requiring regulator notification in some jurisdictions.

---

## Banking Partnerships / Payments Pod

**Context**
This launch adds new rail providers and account-providing banks across multiple countries plus new crypto rails. Existing commercial agreements may not contemplate self-serve creation volumes, `on_behalf_of` sub-entity attribution, or auto-failover between providers via `PROCESSING_RETRY`.

**Actions**
- Confirm rail partner integration is tested and live; check existing commercial agreements (pricing, commissions, T&Cs) cover the new self-serve volumes.
- N8N drives capability metadata and provider ranking — confirm latency, caching, fallback behaviour when N8N is unavailable, and a safe edit path for business stakeholders.
- New webhook events, state machine, retry logic, and sandbox parity — confirm deployment ordering and on-call ownership before launch.
- Confirm whether any rail partner has contractual restrictions on `on_behalf_of` collects or PayFac-style sub-merchant attribution.

**Watch-out**
- Crypto rail relationships involve different commercial structures than fiat — confirm contractual coverage and operational readiness per blockchain.

---

*Each team reads their section. Common Context applies to all. Actions / Blockers / Watch-out items are the pre-launch checklist — escalate before go-live, not after.*
