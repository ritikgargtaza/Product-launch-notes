# Pre-Launch Sync Notes

**Feature:** Checkout on Behalf Of (Checkout OBO)
**Go-live:** TBC — pending Compliance and Licensing sign-off per entity type and merchant segment
**Date generated:** 2026-05-21
**Teams covered:** Compliance — Onboarding, Compliance — Transaction Monitoring, Risk, Legal, Licensing, Payment Operations, Banking Partnerships / Payments Pod

---

## Common Context

> Read this first. All team sections below assume you've read this.

**What we're launching**
Merchants can register third-party entities (sellers, individuals) and create checkout sessions on their behalf via one optional API field (`on_behalf_of`). Payins inherit the entity attribution automatically on checkout completion. This introduces a PayFac-style sub-merchant layer on top of existing checkout and payin infrastructure — no extra API calls, no new rails.

**Who it affects**
- **Geographies:** No geography restrictions in PRD — gated by Compliance and Licensing sign-off per entity type and merchant segment
- **Entity types:** Sellers, individuals, MTOs, remittance agents, subagents, wallet providers, mobile money operators, telecoms, utility companies, service providers, billers
- **Customer segments:** Licensed institutions reselling Tazapay payment methods; remittance providers; financial services companies; marketplace and aggregator platforms

**Key technical facts**
- **Payment rails / PSPs involved:** No new rails or PSP integrations — OBO is an attribution layer on existing checkout and payin infrastructure
- **New corridors or currencies:** None
- **Rollout strategy:** TBC — gated by Compliance and Licensing per entity type
- **Configs being introduced (defaults both ON):**
  - `Mandatory entity approval required for checkout creation` — entity must be approved before checkout creation
  - `Mandatory OBO information for checkout` — `on_behalf_of` required on all checkouts
- **New API errors:** `entity_not_approved`, "on_behalf_of field is required for this merchant account"
- **New webhook payload fields:** `on_behalf_of`, `entity_details` (entity_id, business_name, email, reference_id) on all checkout and payin events
- **New hosted-page config:** `on_behalf_of_configuration.hosted_page_display` = `entity` | `entity_plus_account`
- **Sardine involved:** Yes — entity fields must be added to the data mapping
- **Forter involved:** Yes — SDK ownership for entity flows unconfirmed

**Open questions (from PRD)**
- Is Sardine data mapping complete and locked for the OBO flow?
- Is the Forter SDK for entities merchant-managed or Tazapay-managed?
- Do PSPs share redirect URLs for all OBO checkout variants? Do mismatches surface in the Risk dashboard?
- Does the OBO structure trigger regulatory notification obligations in any jurisdiction?
- Is there an entity-level reserve config, or is this intentionally account-level only?
- If a payments partner is the "merchant" and their clients are the "entities", does the partner agreement cover this structure?

---

## Compliance — Onboarding

**Actions**
- Confirm the default-ON approval gate is acceptable at launch, or flag merchant categories needing it OFF.
- Define entity approval SLA — queue delays directly block merchant checkout creation.

**Blockers**
- Sardine data mapping for OBO flow must be confirmed (entity ID, business name, type) before launch.
- Validate no false positive Sardine alerts on OBO sessions.

---

## Compliance — Transaction Monitoring

**Actions**
- Confirm `on_behalf_of` and `entity_details` webhook fields are ingested into TM before launch.
- Review AML rule-sets — merchant-level velocity/volume rules won't catch entity-level structuring.
- Recalibrate typology rules for remittance and MTO account types (higher-risk corridors).
- Confirm SAR/STR filing logic works when entity and merchant are different legal entities.

**Watch-out**
- A merchant with 500 entities looks like one high-volume account without entity-level segmentation. Biggest gap to close before launch.

---

## Risk

**Actions**
- Confirm fraud and chargeback controls operate at entity level, not just merchant level.
- Define escalation path when an entity's approval status changes while live checkouts are in flight.
- Clarify whether risk SDK is merchant-managed or entity-managed; define support path.
- Confirm entity-level reserve config exists, or flag gap (reserves should sit at aggregate account level).

**Scenarios**
- Fraudulent entity under legitimate merchant: if approval gate is OFF, bad actors create checkouts immediately. Flag high-risk merchant types for mandatory gate ON.
- Chargeback concentration: one bad seller masked by good merchant-level metrics. Entity-level thresholds must trigger blocks independently.

---

## Legal

**Actions**
- Review merchant agreements — acting as a payment aggregator for third-party entities is a material scope extension; likely needs a ToS addendum.
- Assess whether new entity data fields (name, email, country) constitute a new processing activity under GDPR/PDPA.
- Confirm whether operating a payment facilitation layer for sub-entities triggers licensing obligations in active jurisdictions.
- Review hosted page display config (entity alone vs. entity + merchant) for consumer disclosure implications.

---

## Licensing

**Actions**
- Assess whether OBO constitutes a material change requiring regulatory notification in any jurisdiction before launch.
- Confirm licence scope covers each supported entity type per active geography — especially financial services types (GCash, M-Pesa equivalents) which are regulated entities themselves.
- Confirm whether reporting thresholds (cross-border, large value) trigger differently when the payin is attributed to an entity rather than the merchant.
- Review whether capital adequacy or safeguarding calculations change if OBO drives material volume growth.

---

## Payment Operations

**Ops actions**
- Update reconciliation scripts to read `on_behalf_of` and `entity_details` — surface entity-level breaks, not just merchant-level.
- Map new API errors (`entity_not_approved`, 'on_behalf_of required') to SOPs and define ops vs. Compliance routing.
- Validate in staging: Receiver Name, Entity ID, Country, Email, Reference ID, and Entity Status columns on checkout/payin reports.

**Partner onboarding actions**
- Update partner onboarding SOPs to cover MID configuration at entity level (previously merchant level only).
- Confirm Entity Listing Review Required / Not Required split is working and routing to Compliance correctly.
- Communicate to merchants: `entity_not_approved` requires Compliance Onboarding action, not ops retry; set SLA expectation.

---

## Banking Partnerships / Payments Pod

**Context**
OBO makes Tazapay a payment facilitator for sub-entities. Banking and acquiring partners who approved Tazapay under merchant-level arrangements may not have assessed risk at sub-entity or aggregator level.

**Actions**
- Review partner agreements — confirm PayFac-style sub-entity attribution is within approved activity scope, or identify which partners need notification.
- Check active partners for restrictions on marketplace, MTO, remittance, or wallet provider flows — these are supported under OBO.
- Brief relevant partners before launch where supported entity types overlap with segments they've flagged as elevated risk.

---

*Each team reads their section. Common Context applies to all. Actions / Blockers / Watch-out items are the pre-launch checklist — escalate before go-live, not after.*
