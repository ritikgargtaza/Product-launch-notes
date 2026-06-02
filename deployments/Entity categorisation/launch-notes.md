# Pre-Launch Sync Notes

**Feature:** Entity Categorisation (Merchant Risk Categorisation + Service Provider Type Capture)
**Go-live:** TBC — gated by Compliance sign-off on the vertical-to-service-provider-type mapping and a backfill plan for existing OBO merchants
**Date generated:** 2026-06-01
**Teams covered:** Compliance — Onboarding, Compliance — Transaction Monitoring, Risk, Payment Operations, Sales / Account Management, Legal / Licensing, Product / Engineering

> ⚠️ "Teams to Brief" not found in PRD — selected the 7 most-impacted teams. Add a "## Teams to Brief" section to the PRD to lock the list.

---

## Common Context

> Read this first. All team sections below assume you've read this.

**Why we're doing this**
Compliance categorisation is fragmented today — A/B/C signals live across Jira tickets, configs are applied manually per merchant, and TSP/PSP signal sits in unstructured C2C call notes. This launch builds a single ops-dashboard source of truth, auto-applies the right platform configs per category, sends category to Sardine for transaction-level hard stops, and captures TSP/PSP plus PSP licenses inside KYB. Launch scope is OBO payouts only.

**What's changing**

| Area | What changes | Who this affects |
|---|---|---|
| Categorisation | New A/B/C category dropdown in the KYB risk section on the ops dashboard; per-usecase, audit-logged (`updated_by`, `previous_value`, `new_value`, comment), RBAC-restricted | Compliance Ops + OBO payout merchants |
| Auto config application | Setting or changing a category auto-applies `Simplified entity creation` and `Mandatory entity approval required for OBO payout`; ops can override afterwards, no cron reconciles configs back | Compliance Ops + OBO merchants |
| Sardine rule | One new global rule: hard stops OBO transactions where category is B, C, or Not Set; Category A flows normally. Merchant's category sent to Sardine on every OBO transaction | Compliance — TM + all OBO merchants |
| Service provider type | KYB form captures mandatory `Service Provider Type` (TSP / PSP); default seeded from industry vertical mapping, compliance can override | All merchants going through KYB |
| PSP license upload | Mandatory at KYB submission if PSP selected; PDF/JPG/PNG, 10MB per file, max 10 files; ops-only visibility post-submission (security) | PSP merchants + Ops |
| License expiry tracking | 1-month warning tag (amber) and expired tag (red) on ops dashboard, showing earliest-expiring license; mirrored on merchant dashboard "Actions Required" tab | Ops + merchants |
| Listing filters | New `KYB Refresh Due` and `License Renewal Due` filters on the ops merchant-listing screen | Ops |
| Reporting basis | TSP merchants' entities count as Tazapay's customers for regulatory reporting; PSP merchants' entities don't — reporting sits with the PSP | Legal / Licensing / Finance |

**At a glance**

| | |
|---|---|
| **Geographies** | No restrictions in PRD |
| **Entity types** | OBO merchants for categorisation (launch scope); all merchants for TSP/PSP capture |
| **Customer segments** | OBO payout merchants (categorisation); all KYB merchants (service provider type, license upload) |
| **Rollout strategy** | TBC — gated by vertical-to-SPT mapping and backfill plan |
| **Sardine involved** | Yes — one new global rule + new payload field (merchant category per OBO transaction) |
| **Forter involved** | No |

**Open questions (from PRD)**
- Full industry-vertical → service-provider-type mapping needs to be finalised with Compliance before launch
- File size limit (10MB per file, max 10 files) — Engineering to confirm storage and access controls
- Backfill plan for existing un-categorised OBO merchants — without it, every OBO transaction hard-stops on day one
- Proactive emailer to merchants for license renewal reminders acknowledged but out of scope for this launch

---

## Compliance — Onboarding

**Actions**
- Finalise the vertical-to-service-provider-type mapping before launch — auto-defaults depend on it
- Sign off on the RBAC list for category edits and the extension path post-launch
- Brief team that setting or changing a category auto-applies `Simplified entity creation` and `Mandatory entity approval required for OBO payout` — manual override still available

**Blockers**
- Backfill plan for existing un-categorised OBO merchants — without it, every OBO transaction hard-stops on day one

---

## Compliance — Transaction Monitoring

**Actions**
- Validate in staging that `usecase` and `category` payload reach Sardine correctly on every OBO transaction
- Brief the alert team on the upgrade path — review hard-stopped transactions, upgrade to A, next transaction flows through

**Watch-out**
- Hard stops will spike on launch day — "Not Set" behaves like Category C, so every un-categorised OBO merchant blocks until categorised; concentrate alert-review capacity in week one

---

## Risk

**Actions**
- Sign off on the criteria — what makes a merchant A vs B vs C, and the threshold for B/C → A upgrade
- Confirm audit trail (`updated_by`, `previous_value`, `new_value`, comment) meets internal risk-audit standards

**Scenarios**
- Merchant wrongly categorised A: hard stops bypassed, exposure builds before correction is noticed — mitigated by RBAC restricting who can set A plus the audit log
- B/C → A upgrade without sufficient diligence: legitimate volume passes but bad-actor volume also passes — mitigated by a documented minimum-review threshold before upgrade

---

## Payment Operations

**Ops actions**
- Define SLA for the new hard-stop triage workflow — compliance review then category upgrade
- Validate the `License Renewal Due` filter against test data with multiple license expiries
- Brief support that uploaded licenses are ops-only — merchants cannot see them post-submission

**Watch-out**
- Day-one hard-stop volume on un-categorised OBO merchants may swamp the queue if backfill isn't done

---

## Sales / Account Management

**Actions**
- Outreach to existing OBO merchants before launch — backfill categories or set expectations on day-one hard stops
- Pre-empt PSP license upload requirement with prospects so KYB doesn't stall on a missing document

**Watch-out**
- Service provider type may be re-classified for some existing accounts (TSP ↔ PSP) — coordinate communication so the change doesn't surprise the merchant

---

## Legal / Licensing

**Actions**
- PSP licenses are now stored in Tazapay infrastructure — confirm DPA, retention, and access-control terms
- Confirm merchant ToS permits hard-stopping transactions based on internal categorisation and defines a dispute path
- TSP vs PSP classification now drives Tazapay's regulatory reporting position — confirm each active regulator's expectations match
- License upload is capture-only with no verification step — confirm whether reliance on these documents needs an attestation

**Watch-out**
- Automated hard stops based on internal categorisation may constitute a material change requiring regulator notification in some jurisdictions

---

## Product / Engineering

**Actions**
- Confirm deployment ordering — the new Sardine rule and the new payload field must roll out together to avoid silently passing transactions or wrongly blocking them
- File storage for license uploads must meet the merchant-cannot-read requirement — confirm storage backend and access control
- Validate ops dashboard surfaces: KYB risk section, license upload + expiry tag rendering, new listing filters

**Watch-out**
- Rollback path for the new Sardine rule must be ready in case launch-day hard-stops misfire at scale

---

*Each team reads their section. Common Context applies to all. Actions / Blockers / Watch-out items are the pre-launch checklist — escalate before go-live, not after.*
