# Pre-Launch Sync Notes

**Feature:** Entity Categorisation (Merchant Risk Categorisation + Service Provider Type Capture)
**Go-live:** TBC — gated by Compliance sign-off on the vertical-to-service-provider-type mapping and backfill of categories for existing OBO merchants
**Date generated:** 2026-05-21
**Teams covered:** Compliance — Onboarding, Compliance — Transaction Monitoring, Risk, Payment Operations, Sales / Account Management, Legal / Licensing, Product / Engineering

---

## Common Context

> Read this first. All team sections below assume you've read this.

**What we're launching**
A merchant risk categorisation framework (A / B / C) inside the KYB risk section of the ops dashboard for OBO payouts, with auto-applied platform configs and one new Sardine rule that hard-stops OBO transactions for non-whitelisted merchants. Also adds structured capture of service provider type (TSP / PSP) during KYB, license uploads for PSP merchants, and license expiry tracking on the ops dashboard. Launch scope is OBO payouts only.

**Who it affects**
- **Customer segments:** All OBO payout merchants going through or past KYB
- **Internal users:** Ops / Compliance team members (category assignment, license review, audit trail)
- **Geographies:** No geography restrictions in the PRD
- **Entity types:** OBO merchants only — non-OBO merchants unaffected in launch scope

**Key technical facts**
- **Categories:** A = Whitelisted (no hard stop), B = Monitoring (hard stop), C = Enhanced Monitoring (hard stop)
- **"Not Set" behaves like Category C** — all OBO transactions for a usecase with no category set are hard-stopped
- **One new global Sardine rule** — fires hard stop when category for the transaction's usecase is B, C, or not set; Category A flows normally
- **New transaction payload to Sardine:** merchant's payout compliance category sent with every OBO transaction
- **Configs auto-applied on category set/change:** `Simplified entity creation`, `Mandatory entity approval required for OBO payout`; ops can manually override afterwards; no cron reconciles configs back to category state
- **Service provider type defaulted from industry vertical** — PSP for "Money Services Business", "Payment Facilitator", "Financial Services", "Remittance"; TSP for SaaS, marketplace, e-commerce; ambiguous → TSP; compliance can override
- **PSP license upload** — mandatory at KYB submission if merchant selects PSP (or compliance switches them later); PDF/JPG/PNG, 10MB per file, max 10 files; expiry date required; optional label
- **License visibility** — ops dashboard only; merchants cannot see uploaded licenses post-submission (security)
- **Expiry tracking** — 1-month warning tag (amber), expired tag (red) on ops dashboard; reflects earliest-expiring license per merchant; mirrored on merchant dashboard "Actions Required" tab
- **New filters on merchant listing screen:** `KYB Refresh Due`, `License Renewal Due`
- **Audit trail** — every category change logged with `updated_by`, `updated_at`, `previous_value`, `new_value`, free-text comment
- **RBAC** — only specific named compliance members can edit at launch; permissions extendable later
- **Reporting impact:** TSP merchants' entities are Tazapay's customers (Tazapay reporting applies); PSP merchants' entities are not (reporting sits with the PSP)
- **Sardine involved:** Yes — one new global rule + new payload field
- **Forter involved:** No
- **New payment rails / PSPs / corridors / currencies:** None

**Open questions (from PRD)**
- Full industry-vertical → service-provider-type mapping needs to be finalised with Compliance before launch
- File size limit (10MB per file, max 10 files) — Engineering to confirm storage and access controls
- Proactive emailer to merchants for license renewal reminders acknowledged but out of scope for this launch

---

## Compliance — Onboarding

**Actions**
- Confirm the vertical-to-service-provider-type mapping is finalised before launch.
- Sign off on RBAC list for category edits and the extension path post-launch.
- Brief the team that setting or changing a category auto-applies `Simplified entity creation` and `Mandatory entity approval required for OBO payout` — manual override still possible afterwards.

**Blockers**
- Backfill plan for existing un-categorised OBO merchants — without it, every OBO transaction hard-stops on day one.

---

## Compliance — Transaction Monitoring

**Actions**
- Confirm `usecase` and `category` payload mapping to Sardine is locked and validated in staging.
- Brief the alert/review team on the upgrade path — review hard-stopped transactions → upgrade category to A → next transaction flows through.
- Confirm SAR/STR filing logic accommodates the new hard-stop volume on launch day.

**Watch-out**
- Hard stops will spike on launch day — plan for a calibration window and surge alert-review capacity.
- "Not Set" defaulting to hard-stop means every OBO merchant without a category will block until categorised; volume risk is concentrated in week one.

---

## Risk

**Actions**
- Sign off on the criteria document — what makes a merchant A vs B vs C, and the threshold for upgrade.
- Confirm TSP vs PSP classification flows correctly into risk monitoring — TSP entities are Tazapay's customers, PSP entities are not.
- Confirm audit trail (`updated_by`, `previous_value`, `new_value`, comment) meets internal risk-audit standards.

**Scenarios**
- Merchant wrongly categorised A by mistake: hard stops bypassed, exposure builds before correction is noticed. Mitigation: RBAC restricts who can set A, audit trail logs every change.
- Existing merchant flips from C → A without sufficient diligence: legitimate volume passes but bad-actor volume also passes. Mitigation: define minimum review threshold for B/C → A upgrade.

---

## Payment Operations

**Ops actions**
- Define SLA for the new hard-stop triage workflow — compliance review → category upgrade.
- Validate the `License Renewal Due` filter on the merchant listing screen against test data with multiple license expiries.
- Brief support that uploaded licenses are ops-only — not visible to merchants post-submission.

**Watch-out**
- Day-one hard-stop volume on un-categorised OBO merchants may swamp the queue if backfill isn't done — confirm capacity.

---

## Sales / Account Management

**Actions**
- Outreach to existing OBO merchants before launch — backfill categories or set expectations on day-one hard stops.
- Pre-empt PSP license upload requirement with prospects so KYB doesn't stall on a missing document.
- Frame the TSP vs PSP reporting distinction in sales conversations — TSP entities = Tazapay's customers; PSP entities = not.

**Watch-out**
- Service provider type may be re-classified for some existing accounts (TSP → PSP or vice versa) — coordinate communication so the change doesn't surprise the merchant.

---

## Legal / Licensing

**Actions**
- PSP licenses are now stored in Tazapay infrastructure — confirm DPA, retention, and access-control terms.
- Hard stops block transactions based on an internal categorisation — confirm merchant ToS permits this and define the merchant's right to dispute.
- TSP vs PSP classification now drives Tazapay's regulatory reporting position — confirm each active regulator's expectations match.
- License upload is capture-only with no verification step — confirm whether reliance on these documents needs an attestation.

**Watch-out**
- Automated hard stops based on internal categorisation may constitute a material change requiring regulator notification in some jurisdictions.

---

## Product / Engineering

**Actions**
- Confirm deployment ordering — the new Sardine rule and the new payload fields must roll out together to avoid silently passing transactions or wrongly blocking them.
- File storage for license uploads (PDF/JPG/PNG, 10MB per file, max 10 files) — confirm storage backend and access control meet the merchant-cannot-read requirement.
- Validate the ops dashboard surfaces: KYB risk section, license upload + expiry tag rendering, new filters (`KYB Refresh Due`, `License Renewal Due`).

**Watch-out**
- Rollback path for the new Sardine rule must be ready in case launch-day hard-stops misfire at scale.

---

*Each team reads their section. Common Context applies to all. Actions / Blockers / Watch-out items are the pre-launch checklist — escalate before go-live, not after.*
