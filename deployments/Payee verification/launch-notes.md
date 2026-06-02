# Pre-Launch Sync Notes

**Feature:** Payee Verification (Confirmation of Payee)
**Go-live:** TBC — pending corridor coverage matrix, provider licensing coverage per corridor, and Compliance sign-off
**Date generated:** 2026-06-01
**Teams covered:** Legal, Licensing, Compliance, Payment Operations, Finance, Sales / Account Management, Product — Data

> ⚠️ "Teams to Brief" not found in PRD (PRD.md is a Notion link index) — selected the 7 most-impacted teams based on existing scope notes. Add a "## Teams to Brief" section to lock the list.

---

## Common Context

> Read this first. All team sections below assume you've read this.

**Why we're doing this**
Payouts today have no pre-send sanity check on whether the name on the beneficiary matches what the receiving bank holds — bad detail leads to failed payouts, manual ops, and merchant friction. Payee Verification adds a non-binding name-match check that runs upstream of payout, exposed via dashboard and API, billed only on successful verifications. Phase 2 (Atlas) opens this as a standalone product to non-Tazapay merchants — out of launch scope.

**What's changing**

| Area | What changes | Who this affects |
|---|---|---|
| Pre-payout check | Non-binding name-match against bank records — indicative result, not a guarantee of fund delivery; runs standalone, not gated to payout | All payout-doing merchants |
| Surfaces | Available via Merchant Dashboard (manual lookup) and API (bulk / at-scale) | Merchants on dashboard + API |
| Verification flows | Three: (a) verify on beneficiary creation, (b) verify an existing beneficiary, (c) direct one-off check | Merchants integrating any of the three flows |
| Provider routing | Single verification provider at launch; additional providers to follow | Ops + Partnerships |
| Pricing and billing | Corridor-based pricing configured via Ops Dashboard; only successful verifications billed; USD-first deduction then primary holding currency; free / promo credits consumed before paid balance | Finance + merchants |
| Data flow | Beneficiary name and account number sent to the verification provider for matching — data residency rules apply per corridor | Compliance + Legal |
| Failure handling | Provider downtime is non-blocking — payouts continue regardless of verification result | Payment Ops |
| Tracking | Flow type, corridor, result, provider, latency captured on every verification | Product — Data |

**At a glance**

| | |
|---|---|
| **Geographies / corridors** | TBC — coverage matrix to be confirmed and documented before go-live |
| **Customer segments** | Existing Tazapay merchants doing payouts (Phase 2 / Atlas standalone for non-Tazapay merchants is roadmap, not launch) |
| **Data subjects** | Beneficiaries — the payees being verified |
| **Rollout strategy** | TBC |
| **Sardine involved** | No |
| **Forter involved** | No |

**Open questions (from PRD)**
- Corridor coverage matrix at launch — confirm and document before go-live
- Verification provider's licensing coverage per corridor — confirm and document
- Provider downtime alerting and fallback handling — confirm configuration before launch
- Reporting requirements (merchant-facing and internal) — confirm before launch

---

## Legal

**Actions**
- Clarify in merchant-facing docs that PV results are indicative, not a guarantee of fund delivery
- Define liability scope for name-mismatch outcomes in T&Cs
- Beneficiary name and account number flow to the verification provider — confirm DPA coverage and data-handling policy

**Watch-out**
- Cross-border data transfer obligations triggered per launch corridor when beneficiary PII flows to the verification provider

---

## Licensing

**Actions**
- Map per-corridor licensing requirements before launch — name matching against bank records may be regulated activity in some jurisdictions
- Confirm and document the verification provider's licensing coverage per corridor before that corridor goes live
- Assess whether offering PV as a paid service constitutes a regulated activity in any launch jurisdiction

**Watch-out**
- Phase 2 (Atlas) standalone offering to non-Tazapay merchants may shift the licensing basis — flag for early review

---

## Compliance

**Actions**
- Map data residency requirements per corridor — beneficiary PII transmitted to the verification provider must comply per jurisdiction
- Review name-matching rules per country (script, transliteration, fuzzy-match tolerance) before each corridor goes live
- Define how PV results (match outcome, provider, corridor, timestamp) are recorded and retained for audit

---

## Payment Operations

**Ops actions**
- Configure provider downtime alerting before launch — failed verifications should surface, not silently pass
- Document corridor coverage gaps and share with support so merchant queries are answered consistently
- Define change-management process for per-corridor pricing edits on the Ops Dashboard (who edits, approval, audit trail)

**Watch-out**
- Failed verifications are non-blocking — brief exceptions team that a failed PV does not require holding the payout

---

## Finance

**Actions**
- Confirm GL mapping for both billing paths — USD-first deduction and primary holding currency fallback
- Align rev-rec so failed verifications are not recognised as revenue — only successful checks are billable
- Validate the corridor-based price book on Ops Dashboard before launch — must match the agreed pricing schedule

**Watch-out**
- Free / promotional credits consumed before paid balance — confirm credit accounting and expiry handling

---

## Sales / Account Management

**Actions**
- Confirm dashboard demo, API docs, and sandbox parity are ready for enablement
- Pitch the three flows (verify on beneficiary creation, verify an existing beneficiary, direct one-off check) and the pre-payout integrity-check positioning — not gated to payout
- Share the corridor coverage matrix internally before any outbound — pitch only on supported corridors

**Watch-out**
- Phase 2 (Atlas) standalone product is roadmap, not launch — do not position to non-Tazapay merchants

---

## Product — Data

**Actions**
- Instrument all verification events: flow type, corridor, result, provider, latency — across dashboard and API surfaces
- Define launch KPIs: total checks, exact match %, partial match %, no match %, provider failure %
- Confirm cohort and attribution model for payout success rate comparison (PV users vs non-users) — primary impact metric

**Watch-out**
- Reporting requirements (merchant-facing and internal) not yet confirmed — block-list before launch

---

*Each team reads their section. Common Context applies to all. Actions / Blockers / Watch-out items are the pre-launch checklist — escalate before go-live, not after.*
