# Pre-Launch Sync Notes

**Feature:** Checkout on Behalf Of (Checkout OBO)
**Go-live:** TBC — gated by Compliance and Licensing sign-off per entity type and merchant segment
**Date generated:** 2026-05-20
**Teams covered:** Compliance — Onboarding, Compliance — Transaction Monitoring, Risk, Payment Operations, Partnerships, Legal, Licensing

---

## Common Context

> Read this first. All team sections below assume you've read this.

**What we're launching**
Merchants can register entities — sellers, individuals, and other receivers — inside their Tazapay account and create checkout sessions on those entities' behalf using a single optional field (`on_behalf_of`) on the checkout API. The payin auto-inherits the entity attribution on checkout completion. This introduces a PayFac-style sub-merchant layer on top of existing checkout and payin infrastructure — no new rails, no new corridors.

**Who it affects**
- **Geographies:** No geography restrictions in the PRD — availability is gated by Compliance and Licensing sign-off per entity type and merchant segment
- **Entity types:** Sellers, individuals, Money Transfer Operators (MTOs), remittance agents, subagents, wallet providers, mobile money operators, telecoms, utility companies, service providers, billers
- **Primary merchant segments:** Licensed institutions reselling Tazapay payment methods; remittance providers; financial services companies; marketplace and aggregator platforms

**Key technical facts**
- **Payment rails / PSPs involved:** None new — OBO is an attribution layer on existing checkout and payin infrastructure
- **New corridors or currencies:** None
- **Rollout strategy:** TBC — gated by Compliance and Licensing per entity type
- **Two new merchant-level configs (both default ON):**
  - `Mandatory entity approval required for checkout creation` — entities must be approved before OBO checkout is allowed
  - `Mandatory OBO information for checkout` — makes `on_behalf_of` required for all checkouts on that account
- **New API error codes:** `entity_not_approved`, "on_behalf_of field is required for this merchant account"
- **New webhook payload fields:** `on_behalf_of`, `entity_details` (entity_id, business_name, email, reference_id) on all checkout and payin events
- **New hosted-page config:** `on_behalf_of_configuration.hosted_page_display` = `entity` | `entity_plus_account`
- **Sardine involved:** Yes — entity fields must be added to the Sardine data mapping
- **Forter involved:** Yes — SDK ownership (merchant-managed vs Tazapay-managed) for entity flows is unconfirmed

**Open questions (from PRD)**
- Is Sardine data mapping complete and locked for the Checkout OBO flow?
- Is the Forter SDK integration for entities merchant-managed or Tazapay-managed?
- Do PSPs share redirect URLs for all OBO checkout variants? Do URL mismatches surface in the Risk dashboard?
- Does the OBO structure trigger regulatory notification obligations in any jurisdiction?
- Is there an entity-level reserve config for ops and risk teams, or is this intentionally account-level only?
- If a payments partner is the "merchant" and their clients are the "entities" in an OBO flow, does the partner agreement cover this structure?

---

## Compliance — Onboarding

- Default-ON `Mandatory entity approval required for checkout creation` config turns the entity approval queue into a real-time production control — an unapproved entity blocks the merchant's checkout creation
- Confirm Customer Due Diligence (CDD) coverage for the entity fields collected (business name, email, country, entity type, merchant-assigned reference ID) across every supported entity type
- Sign off on the entity approval workflow and Service Level Agreement (SLA) before launch — undefined SLA = stalled merchant operations once the gate is live
- Sardine data mapping for the OBO flow (entity_id, business_name, entity_type alongside standard checkout data) must be confirmed and locked — launch blocker for this team if unresolved
- Validate in staging that OBO checkout sessions do not generate false-positive rule alerts in Sardine before go-live

---

## Compliance — Transaction Monitoring

- Payins now carry `on_behalf_of` and `entity_details` (entity_id, business_name, email, reference_id) — confirm these fields are ingested into the Transaction Monitoring (TM) system before launch
- Review existing Anti-Money Laundering (AML) rules to operate at the entity level, not just merchant level — velocity, volume, and corridor rules at merchant-level will miss entity-level structuring (e.g. a marketplace with 500 sellers reading as one high-volume merchant)
- Recalibrate typology rules for MTO and remittance agent entity types — explicitly supported and represent higher-risk corridors
- Confirm Suspicious Activity Report (SAR) / Suspicious Transaction Report (STR) filing logic still maps correctly when the entity and the merchant are different legal entities attributed to the same payin
- Brief the alert team — alert volume may spike post-launch as `on_behalf_of` appears in previously unseen merchant flows; plan for a calibration period

---

## Risk

- Entity approval gate (default ON) is the primary control over which entities can receive funds — if a merchant has it toggled OFF, entities can transact before any compliance review
- Confirm fraud and chargeback controls operate at the entity level so a single bad entity under a compliant marketplace merchant is detectable and blockable independent of merchant-level metrics
- Refunds and chargebacks on OBO payins retain the `on_behalf_of` reference — confirm reconciliation and dispute tracking preserve entity attribution, and sign off on the escalation path when an entity's `approval_status` flips (approved → rejected) while sessions are in flight
- Forter SDK ownership for entity flows (merchant-managed vs Tazapay-managed) is unconfirmed — resolve and define the briefing/support path before go-live
- Open question — confirm Payment Service Providers (PSPs) share redirect URLs for all OBO checkout variants and whether URL mismatches surface in the Risk section of the ops dashboard
- Open question — entity-level reserve config: confirm whether it exists, or flag as intentional account-level-only design vs a pre-launch gap

---

## Payment Operations

- No new payment rails, schemes, or settlement windows — Checkout OBO is an attribution layer on existing infrastructure; no Service Level Agreement (SLA) or reconciliation window change
- Map the two new API error codes — `entity_not_approved` and the "on_behalf_of field is required for this merchant account" error — to internal Standard Operating Procedure (SOP) and define the triage handoff to Compliance Onboarding
- Update reconciliation scripts to read `on_behalf_of` and `entity_details` on payins and refunds so breaks surface at entity level, not just merchant level; validate the new CSV export columns (Receiver Name, Entity ID, Country, Email, Reference ID, Status) in staging
- Brief the exceptions team on PRD-named edge cases: deleted entity mid-checkout (displays as "(Deleted)"), revoked entity approval while sessions are live, high-volume entity transactions under one merchant
- Refunds retain the `on_behalf_of` reference — confirm refund, dispute, and chargeback workflows preserve entity attribution end-to-end
- Validate the new "Receiver Details" columns and entity search/filter (entity_id, business_name, reference_id, email with partial-match support) on the Operations Dashboard before launch

---

## Partnerships

- No new rails, corridors, or payment methods introduced — no rail integration dependency and no new commercial access to negotiate for this launch
- Confirm existing rail partner commercial agreements (pricing, commissions, Terms & Conditions) cover payins attributed to sub-entities under the merchant account — a contractual sanity-check before regulated entity types are enabled at scale
- Validate that no in-scope rail partner has contractual restrictions on processing for sub-merchant or PayFac-style structures — surface as a launch blocker for those rails if any do
- Coordinate with Legal on whether a rail partner's contract needs an addendum when the partner's clients become "entities" in an OBO flow
- No commercial repricing expected; if volumes shift materially toward higher-risk entity categories (remittance, mobile money), confirm they remain within existing commercial bands

---

## Legal

- Three-party payment structure introduced — Tazapay processes for a merchant acting on behalf of an entity that is the ultimate receiver of funds; material scope extension from existing Terms of Service (ToS)
- Review whether existing merchant agreements authorise the merchant to act as a payment aggregator/facilitator for third-party entities — if not, an addendum or new clause is required before any merchant goes live with OBO
- New entity data fields (business_name, email, country) may constitute a new processing activity — confirm Data Processing Agreement (DPA) coverage and assess cross-border data transfer obligations when `entity_details` flows to merchant webhook endpoints
- Entity deletion design retains historical data and labels the entity "(Deleted)" — confirm this meets data retention obligations and doesn't conflict with data-erasure rights
- Hosted page display options (`entity` vs `entity_plus_account`) and refunds retaining `on_behalf_of` — confirm consumer disclosure implications and that liability for refunds is clearly allocated between Tazapay, the merchant, and the entity in merchant-facing documentation
- MTO, remittance agent, and mobile money operator entity types are regulated categories — confirm processing attributed to them is within existing licence permissions or refer to Licensing

---

## Licensing

- Geographic scope is unrestricted in the PRD — go-live is gated by Licensing sign-off per entity type and merchant segment
- Commerce entity types (sellers, merchants, vendors): standard marketplace facilitation — likely within existing Payment Institution (PI) / E-Money Institution (EMI) licence scope; confirm per active geography
- Remittance entity types (MTOs, remittance agents, subagents): higher-risk category — confirm processing payments attributed to these entity types is within existing licence permissions in each jurisdiction
- Financial services entity types (wallet providers, mobile money operators, telecoms): jurisdiction-specific — these entities are often themselves regulated; confirm no regulatory conflict before enabling
- Open question — does OBO checkout constitute a material change to Tazapay's payment services in any jurisdiction requiring advance regulatory notification before launch
- Confirm whether transaction reporting thresholds are triggered differently when payins are attributed to an entity rather than the merchant; if OBO drives material volume growth, reassess safeguarding and capital adequacy thresholds

---

*Each team reads their section. Common Context applies to all. Bullets are the pre-launch checklist — escalate before go-live, not after.*
