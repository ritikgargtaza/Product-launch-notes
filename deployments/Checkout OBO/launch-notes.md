# Pre-Launch Sync Notes

**Feature:** Checkout on Behalf Of (Checkout OBO)
**Go-live:** TBC — pending Compliance and Licensing sign-off per entity type and merchant segment
**Date generated:** 2026-05-11
**Teams covered:** Compliance — Onboarding, Compliance — Transaction Monitoring, Risk, Partnerships, Legal, Licensing

---

## Common Context

> Read this first. All team sections below assume you've read this.

**What we're launching**
Merchants can now register entities — sellers and individuals — within their account, and create checkout sessions on those entities' behalf using a single optional field (`on_behalf_of`) on the checkout API. The payin automatically inherits the entity attribution on checkout completion; no extra API calls are required. This introduces a PayFac-style sub-merchant layer on top of existing checkout and payin infrastructure.

**Who it affects**
- **Geographies:** No geography restrictions in the PRD — availability is gated by Compliance and Licensing sign-off per entity type and merchant segment
- **Entity types:** Sellers, individuals, money transfer operators, remittance agents, subagents, wallet providers, mobile money operators, telecoms, utility companies, service providers, billers
- **Primary merchant segments:** Licensed institutions reselling Tazapay payment methods; remittance providers; financial services companies; marketplace and aggregator platforms

**Key technical facts**
- **Payment rails / PSPs:** No new rails or PSP integrations — OBO is an attribution layer on existing checkout and payin infrastructure
- **New corridors or currencies:** None
- **Rollout strategy:** TBC — gated by Compliance and Licensing per entity type
- **Two new merchant-level configs (both default ON):**
  - Mandatory entity approval required for checkout creation — entities must be approved before OBO checkout is allowed
  - Mandatory OBO information for checkout — makes `on_behalf_of` required for all checkouts on that account
- **Sardine involved:** Yes — entity fields (entity ID, business name, entity type) are passed alongside standard checkout data; mapping must be confirmed before launch
- **Forter involved:** Yes — SDK ownership (merchant-managed vs Tazapay-managed) for entity flows is unconfirmed

**Open questions**
- Is Sardine data mapping complete and locked for the Checkout OBO flow?
- Is the Forter SDK integration for entities merchant-managed or Tazapay-managed?
- Do PSPs share redirect URLs for all OBO checkout variants? Do URL mismatches surface in the Risk dashboard?
- Does the OBO structure trigger regulatory notification obligations in any jurisdiction?
- Is there an entity-level reserve config for ops and risk teams, or is this intentionally account-level only?
- If a payments partner is the "merchant" and their clients are the "entities" in an OBO flow, does the partner agreement cover this structure?

---

## Compliance — Onboarding

**What's changing for you**
This introduces a new sub-merchant-style approval gate directly wired into production: an unapproved entity blocks checkout creation when the default config is ON. Your approval queue is now a real-time production control, not just a compliance step.

**Actions / decisions needed**
- Confirm whether the default-ON config (Mandatory entity approval required for checkout creation) is acceptable from a compliance standpoint at launch, or whether specific merchant categories should have this toggled OFF pre-launch
- Create and sign off on the entity approval workflow and SLA — delays in your approval queue directly block merchant operations when the config is enabled
- Confirm the entity data fields being collected (business name, email, country, entity type, merchant-assigned reference ID) meet CDD requirements for each supported entity type

**Sardine check — confirm before launch**
- Confirm Sardine data mapping is complete and the correct data structure is being sent for the OBO flow — entity fields (entity ID, business name, entity type) must be mapped alongside standard checkout data
- Validate in staging that OBO checkout sessions do not generate false positive rule alerts in Sardine — if mapping is not confirmed, this is a launch blocker for this team

**Risks / watch-outs**
- If the approval gate is ON but the approval SLA is undefined, merchant operations will stall on entity onboarding — agree the SLA before go-live
- Sardine data mapping unconfirmed — flag as launch blocker until resolved

---

## Compliance — Transaction Monitoring

**What's changing for you**
Payin transactions can now carry an `on_behalf_of` field — the entity ID of the ultimate funds receiver — alongside the merchant identifier. A single merchant account may now generate payin transactions attributable to dozens or hundreds of distinct entities. All payin events now include `entity_details` (entity ID, business name, email, reference ID), which must be ingested into your monitoring system for accurate coverage.

**Actions / decisions needed**
- Review existing AML rule-sets to confirm they can segment transaction activity by entity, not just by merchant — velocity, volume, and corridor rules that only operate at merchant level will miss entity-level structuring or aggregation patterns
- Confirm that `on_behalf_of` and `entity_details` fields from payin webhooks are being ingested into the TM system before launch — this data is the primary identifier for entity-level monitoring
- Assess whether typology rules need recalibration for MTO and remittance agent entity types, which are explicitly supported and represent higher-risk corridors
- Brief the alert team: a single merchant may generate large transaction volumes across many entities — teams need context to distinguish legitimate marketplace/aggregator activity from structuring
- Confirm SAR/STR filing logic still maps correctly when the entity and merchant are different legal entities attributed to the same payin

**Risks / watch-outs**
- Without entity-level segmentation in monitoring rules, a marketplace merchant with 500 seller entities could appear as one high-volume merchant, masking entity-level suspicious patterns entirely — this is the single biggest monitoring gap to close before launch
- Alert volume may spike post-launch as the system encounters the new `on_behalf_of` field in previously unseen merchant flows — plan for a calibration period and brief the triage team

---

## Risk

**What's changing for you**
Checkout OBO enables merchants to act as aggregators — creating checkout sessions on behalf of entities that are the ultimate receivers of funds. The entity approval gate (default ON) is the primary control over which entities can receive funds. If toggled OFF for any merchant, entities can transact before any compliance review.

**Actions / decisions needed**
- Confirm that fraud and chargeback controls operate at the entity level — if a single bad entity under a compliant merchant drives chargebacks, confirm detection and blocking logic addresses this
- Review the refund linkage design: refunds on OBO payins retain the `on_behalf_of` reference — confirm this doesn't create reconciliation gaps in chargeback tracking
- Sign off on the escalation path when an entity's `approval_status` changes (e.g., approved → rejected) while live checkouts are in flight

**Risk scenarios and mitigations**
- **Entity fraud under a legitimate merchant:** A compliant marketplace merchant onboards a fraudulent seller entity. If the approval gate is OFF, the entity immediately creates checkout sessions before any review. Mitigation: flag high-risk merchant types for mandatory approval gate ON at account configuration; alert on anomalous entity-level velocity
- **Chargeback concentration in a single entity:** A marketplace has one seller generating disproportionate chargebacks while aggregate merchant-level metrics look normal. Mitigation: confirm chargeback monitoring operates at entity level using the `on_behalf_of` field, and that thresholds trigger entity-level blocks independent of merchant-level status

**Counter-party and operational risk**
- **PSP redirect URLs:** Confirm PSPs share redirect URLs for all OBO checkout variants; verify whether URL mismatches surface in the Risk section of the ops dashboard — flag as open question if unconfirmed
- **Risk SDK ownership:** Confirm whether the Forter SDK integration for entity flows is merchant-managed or Tazapay-managed; if merchant-managed, define the briefing and support path before go-live
- **Entity-level reserves:** Reserves should remain at account level based on aggregate account risk. Confirm whether an entity-level reserve config exists; if not, flag whether this is a gap or an intentional design decision to resolve pre-launch

---

## Partnerships

**What's changing for you**
Technology partners who create checkout sessions programmatically on behalf of their merchant clients should be briefed on the new `on_behalf_of` field — passing it improves their clients' reporting and reconciliation. Referral partners serving marketplace, aggregator, or remittance platform merchants now have a materially stronger product story for those segments.

**Actions / decisions needed**
- Review partner agreements for any distribution or technology partners who create checkout sessions programmatically — confirm whether `on_behalf_of` is relevant to their integration and whether they need to be briefed
- Brief referral partners serving marketplace, aggregator, or remittance platform merchants on the new capability before launch — this is a material addition to the product pitch for those segments
- Check whether existing partnership agreements reference checkout session creation scope in a way that might need updating to accommodate the OBO structure
- No new partner enablement documentation required unless a partner actively uses the checkout API — prioritise partners with high checkout API usage volume

**Risks / watch-outs**
- Technology partners who build on the Tazapay checkout API should receive an API changelog notification — `on_behalf_of` is additive and non-breaking, but partners who miss the update may not pass entity context and their clients' transactions will be unattributed
- Open question: if a payments partner is the "merchant" and their clients are the "entities" in an OBO flow, confirm whether the partner agreement covers this structure — flag for Legal and Partnerships review before any such partner goes live with OBO

---

## Legal

**What's new for you**
This introduces a three-party payment structure — Tazapay processes payments for a merchant acting on behalf of an entity that is the ultimate receiver of funds. This is a material scope extension from a contractual standpoint.

**What's in it for you**
Existing merchant agreements likely don't contemplate the merchant acting as a payment aggregator or facilitator for third-party entities. The new entity data fields (business name, email, country) may constitute a new processing activity under applicable data protection frameworks. The entity deletion design — historical data retained, entity shown as "(Deleted)" — raises a potential tension with data erasure rights that needs sign-off before launch.

**Inputs required before go-live**
- Review whether existing merchant agreements cover the OBO structure — specifically whether merchants are authorised under the ToS to create checkout sessions attributing funds to third-party entities; if not, an amendment or addendum is required
- Assess whether new entity data fields constitute a new processing activity under applicable data protection frameworks and whether existing DPAs cover this
- Confirm whether operating as a payment facilitator for sub-entities via OBO triggers additional regulatory obligations, particularly in jurisdictions with explicit payment facilitation licensing requirements
- Review the entity deletion design: historical data retained, entity shows as "(Deleted)" — confirm this meets data retention obligations and doesn't conflict with GDPR right to erasure
- Confirm liability allocation is clearly defined in merchant-facing documentation in the event of an entity-level dispute or fraud

**Contract and liability review**
- Existing merchant agreements may not contemplate the merchant acting as a payment aggregator for third-party entities through Tazapay's checkout — this is a material scope extension warranting a ToS review and potentially a new merchant agreement clause
- The hosted page can be configured to display either the entity alone or both entity and merchant account (`entity` | `entity_plus_account`) — confirm whether this display configuration has consumer disclosure implications under applicable consumer protection rules
- Refunds on OBO payins retain the `on_behalf_of` entity reference — confirm the refund policy and merchant agreement clearly allocate responsibility between Tazapay, the merchant, and the entity for refund obligations

**Regulatory perimeter and compliance obligations**
- MTO, remittance agent, and mobile money operator entity types are in regulated activity categories in most jurisdictions — confirm Tazapay's processing of payments attributed to these entity types is within existing licence permissions, or flag for Licensing review
- Confirm that `entity_details` in webhook payloads do not introduce new cross-border data transfer obligations (e.g., GDPR or local data localisation requirements) when entity data is sent to merchant webhook endpoints

---

## Licensing

**What's new for you**
Checkout OBO enables merchants to process checkout sessions and payins on behalf of third-party entities — sellers, MTOs, remittance agents, wallet providers, mobile money operators, telecom companies, and utility billers. This introduces a PayFac-style structure where Tazapay's processing is attributed to sub-merchant entities rather than just the top-level merchant account.

**What's in it for you**
Several explicitly supported entity types are themselves regulated (MTOs, wallet providers, mobile money operators) — processing payments attributed to these entities requires confirmation that Tazapay's existing licences cover this activity, or that no regulatory notification is triggered. The geographic scope is currently unrestricted in the PRD but is gated by your sign-off per entity type and merchant segment.

**Inputs required before go-live**
- Confirm whether regulatory notification obligations are triggered by the new product activity — particularly in jurisdictions where material change filings or product approvals are required before launching new payment services
- Review whether the entity approval gating config is sufficient as an internal control, or whether regulator expectations require a more formal approval process for specific entity types
- Assess whether the introduction of OBO checkout constitutes a material change to Tazapay's payment services in any jurisdiction requiring advance regulatory notification

**Licence scope and coverage assessment**
- **Commerce entity types** (sellers, merchants, vendors): standard marketplace payment facilitation — likely within existing PI/EMI licence scope in most jurisdictions; confirm for each active geography
- **Remittance entity types** (MTOs, remittance agents, subagents): higher-risk category — confirm processing payments attributed to these entity types is within existing licence permissions in each jurisdiction; these entities are often themselves licensed
- **Financial services entity types** (wallet providers, mobile money operators, telecoms): jurisdiction-specific — GCash (Philippines), M-Pesa (Kenya), and equivalents are regulated entities themselves; Tazapay processing checkout sessions attributed to them requires confirmation of no regulatory conflict
- **Utilities and services** (utility billers, service providers): generally lower regulatory risk — confirm for active geographies

**Regulatory notifications and reporting obligations**
- Open question: does the introduction of OBO checkout constitute a material change to Tazapay's payment services in any jurisdiction requiring advance regulatory notification? Assess before enabling these entity types for live merchants
- Confirm whether any transaction reporting thresholds are triggered differently when the payin is attributed to an entity rather than the merchant — the `on_behalf_of` field changes funds attribution, which may affect how regulators classify the transaction
- If payin volumes increase materially due to OBO adoption by large marketplace or aggregator merchants, assess whether safeguarding calculations or capital adequacy thresholds change under applicable PI/EMI regulations

---

*Each team reads their section. Common Context applies to all. Inputs/decisions = pre-launch checklist. Risks/watch-outs = escalate before go-live, not after.*
