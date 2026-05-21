# Pre-Launch Sync Notes

**Feature:** Payee Verification (Confirmation of Payee)
**Go-live:** TBC — pending corridor coverage matrix, provider licensing coverage, and Compliance sign-off per corridor
**Date generated:** 2026-05-21
**Teams covered:** Legal, Licensing, Compliance, Payment Operations, Finance, Growth, Product — Data

---

## Common Context

> Read this first. All team sections below assume you've read this.

**What we're launching**
Payee Verification (PV) — also called Confirmation of Payee — is a pre-payout check that verifies a beneficiary's name against bank records. Non-binding: returns an indicative match, not a guarantee of fund delivery. Available via the Merchant Dashboard (manual) and API (bulk/at-scale), and runs standalone — not tied to a payout.

**Who it affects**
- **Merchant segments at launch:** Existing Tazapay merchants doing payouts
- **Phase 2 (Atlas):** PV offered as a standalone product to non-Tazapay merchants
- **Geographies / corridors:** Corridor coverage matrix TBC — iPiD-only at launch
- **Data subjects:** Beneficiaries (the payees being verified) — name and account number flow through PV

**Key technical facts**
- **Verification provider at launch:** iPiD; additional providers to follow
- **Three verification flows:** (1) verify on beneficiary creation, (2) verify an existing beneficiary, (3) direct one-off check
- **Surfaces:** Merchant Dashboard (manual) and API (scale / bulk)
- **Verification ≠ Payout:** Can run upstream of payout (including at onboarding); not gated to payout
- **Billing logic:** Corridor-based pricing configured via Ops Dashboard; USD-first deduction then primary holding currency; only successful verifications billed; free/promo credits consumed before paid balance
- **PII in transit:** Beneficiary name and account number flow to the verification provider — data residency rules apply per corridor
- **Provider downtime:** Failed verifications are non-blocking — payouts not interrupted
- **Tracked events:** Flow type, corridor, verification result, provider, latency
- **Sardine involved:** No
- **Forter involved:** No

**Open questions (from PRD)**
- Corridor coverage matrix at launch — confirm and document before go-live
- Verification provider's licensing coverage per corridor — confirm and document
- Provider downtime alerting and fallback handling — confirm configuration before launch
- Reporting requirements (merchant-facing and internal) — confirm before launch

---

## Legal

**Actions**
- PV is non-binding — clarify in merchant-facing docs that results are indicative, not a guarantee of fund delivery.
- Define liability scope for name-mismatch outcomes in T&Cs.
- Verification data (beneficiary name, account number) is PII — confirm DPA coverage and data handling policy.

**Watch-out**
- Cross-border data transfer obligations triggered per launch corridor when beneficiary PII flows to the verification provider.

---

## Licensing

**Actions**
- PV involves name matching against bank records across multiple countries — licensing requirements may vary by jurisdiction; map per-corridor before launch.
- iPiD's licensing coverage per corridor must be confirmed and documented before that corridor goes live.
- Assess whether offering PV as a paid service constitutes a regulated activity in any launch jurisdiction.

**Watch-out**
- Phase 2 (Atlas) standalone offering to non-Tazapay merchants may shift the licensing basis — flag for early review.

---

## Compliance

**Actions**
- Beneficiary PII is transmitted to iPiD for name matching — data residency requirements apply per corridor and must be mapped before launch.
- Name matching rules differ by country (script, transliteration, fuzzy-match tolerance) — regulatory review required per corridor before go-live.
- Define how PV results (match outcome, provider, corridor, timestamp) are recorded and retained for audit.

---

## Payment Operations

**Ops actions**
- Configure provider downtime alerting before launch — failed verifications should surface, not silently pass.
- Document corridor coverage gaps and share with support so merchant queries are answered consistently.
- Ops Dashboard will be used to configure per-corridor pricing — define change management process (who edits, approval, audit trail).

**Watch-out**
- Failed verifications are non-blocking — payouts continue; brief exceptions team that a failed PV does not require holding a payout.

---

## Finance

**Actions**
- Billing deduction is USD-first, then primary holding currency — confirm GL mapping for both paths.
- Only successful verifications are billable — align rev-rec so failed checks are not recognised as revenue.
- Validate corridor-based price book on Ops Dashboard before launch — must match the agreed pricing schedule.

**Watch-out**
- Free/promotional credits consumed before paid balance — confirm credit accounting and expiry handling.

---

## Growth

**Actions**
- Confirm dashboard demo, API docs, and sandbox parity are ready for sales enablement.
- Pitch the three flows: verify on beneficiary creation, verify an existing beneficiary, direct one-off check.
- Position PV as a pre-payout integrity check — not gated to payout, can run upstream at onboarding or any point.

**Watch-out**
- Coverage at launch is iPiD-only — corridor coverage matrix must be shared so prospects are pitched only on supported corridors.
- Phase 2 (Atlas) standalone product is roadmap, not launch.

---

## Product — Data

**Actions**
- Instrument all verification events: flow type, corridor, result, provider, latency — across both dashboard and API surfaces.
- Define KPIs at launch: total checks, exact match %, partial match %, no match %, provider failure %.
- Confirm cohort and attribution for payout success rate comparison (PV users vs non-users) — primary impact metric.

**Watch-out**
- Reporting requirements (merchant-facing and internal) not yet confirmed — block-list before launch.

---

*Each team reads their section. Common Context applies to all. Actions / Blockers / Watch-out items are the pre-launch checklist — escalate before go-live, not after.*
