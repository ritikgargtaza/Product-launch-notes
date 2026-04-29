# Pre-Launch Sync Notes

**Feature:** Checkout — On Behalf Of (Checkout OBO)
**Date:** April 29, 2026
**Teams covered:** 16

> These notes are tailored per team. Each team should read their section only. The pre-scope note for this feature is also in this folder — this launch note supersedes it.

---

## For Compliance — Onboarding

**What's changing**
Checkout OBO introduces four new entity type categories — Commerce (sellers, vendors), Remittance (MTOs, remittance agents, subagents), Financial Services (wallet providers, mobile money operators, telcos), and Utilities (billers, service providers) — each of which can now receive fund attribution via checkout sessions created by a parent merchant. An optional config (`Mandatory entity approval required for checkout creation`, default OFF) controls whether entities must reach `approval_status = approved` before a checkout can be created on their behalf. This means entities can receive funds without formal approval unless the merchant explicitly enables the config.

**Actions / decisions needed**
- Confirm whether the default-OFF approval config is acceptable under your risk-based approach — if not, this needs to be mandatory before launch
- Define CDD/EDD requirements per entity type category: a marketplace seller has a different risk profile to a Money Transfer Operator or remittance agent
- Confirm that sanctions screening and PEP checks are applied at entity creation and not only at checkout time — document where in the flow this happens
- Review and update the onboarding policy to formally cover sub-entity acceptance under a merchant account
- Sign off on the entity approval workflow before go-live — Compliance Onboarding sign-off is a launch gate, not a post-launch task

**Risks / watch-outs**
- MTO and remittance agent entity types are high-risk under AML frameworks — if these can receive funds with no mandatory EDD, this is a compliance exposure from day one
- The "deleted entity" state (entity shows as "(Deleted)" in dashboards) has record-keeping implications — confirm that entity KYC/KYB data is retained per your data retention policy even after deletion

---

## For Compliance — Transaction Monitoring

**What's changing**
Every checkout and payin transaction can now carry an `on_behalf_of` entity ID, meaning the "ultimate receiver of funds" is no longer always the merchant account — it can be a downstream entity of any of the four categories. All payin webhooks are updated to include `on_behalf_of` and an `entity_details` block (entity_id, business_name, email, reference_id). New data fields are also surfacing in checkout and payin reports: Receiver Name, Entity ID, Receiver Country, Receiver Email, Receiver Approval Status, Receiver Industry Vertical.

**Actions / decisions needed**
- Audit existing AML monitoring rules to confirm they cover the new typologies this enables — specifically remittance agent payments, wallet topups, and MTO fund flows
- Confirm that `on_behalf_of` entity data and the `entity_details` block will be ingested into the monitoring system — if not, raise this as a data integration requirement before launch
- Assess whether velocity and threshold rules need recalibration: a single merchant account could now represent hundreds of downstream entities, each generating their own transaction volume
- Confirm whether any existing SAR/STR triggers are affected when the fund recipient is an entity rather than the merchant directly
- Validate that the new report fields (entity approval status, entity country, industry vertical) are routed into your monitoring data feed

**Risks / watch-outs**
- If monitoring rules don't cover MTO and remittance agent typologies at launch, there is a live SAR/STR gap — this must be closed before go-live, not after
- Entity approval status can change post-transaction (approval revoked after a payin completes) — confirm your monitoring handles this state correctly and doesn't miss retrospective alerts

---

## For Risk

**What's changing**
Checkout OBO adds a new layer of counterparty exposure: merchants can now process checkout sessions on behalf of entities whose risk profile may vary from a marketplace seller to a licensed MTO or remittance agent. The entity approval config is OFF by default, meaning funds can flow to unapproved entities unless the merchant explicitly enables the gate. Two edge cases flagged in the PRD's testing checklist — concurrent checkout creation and high-volume entity transactions — represent direct fraud and operational risk vectors that need to be covered before launch.

**Actions / decisions needed**
- Formally sign off on the default-OFF approval config — document that the residual risk of unapproved entities receiving funds is within appetite, or escalate to change the default
- Define per-entity and per-merchant exposure limits for OBO transactions, particularly for remittance agent and MTO entity types
- Review refund handling: refunds maintain the `on_behalf_of` linkage — confirm this does not create settlement or chargeback attribution issues when the entity is deleted or approval is revoked
- Confirm that the concurrent checkout creation edge case is covered in load and fraud testing — mis-attributed payins could be difficult to remediate post-launch
- Assess whether existing fraud models account for marketplace seller and remittance platform transaction patterns

**Risks / watch-outs**
- Default-OFF approval is the single biggest risk flag in this PRD — if a merchant onboards a large MTO or remittance agent network without enabling approval enforcement, exposure to unverified entities could be material
- The manual checkout creation flow (entity dropdown) creates a spoofing or entity substitution risk if the dropdown is not properly scoped to the merchant's own entities — confirm server-side validation is in place

---

## For Payment Operations

**What's changing**
Checkout OBO does not introduce new payment rails or settlement windows — funds still settle to the merchant account as today. However, it adds a significant new data layer to the ops dashboard: a "Receiver Details" column on checkout and payin listing screens, OBO filters (All/Yes/No) on checkout, payin, and entity screens, enhanced entity search (entity_id, business_name, reference_id, email with partial match), and a "Receiver Details" section on checkout and payin summary screens. The entity listing screen now splits into "Review Required" and "Review Not Required" categories, creating a new approval queue that ops will need to manage.

**Actions / decisions needed**
- Update ops runbooks to cover the new entity approval queue — what is the SLA for reviewing entities, who owns it, and what is the escalation path if the queue backs up?
- Train the ops team on the new dashboard columns, OBO filters, and entity search before go-live — not after
- Confirm the process for handling `entity_not_approved` errors raised by merchants — what does ops do when a merchant calls in about a blocked checkout?
- Validate that the "Receiver Details" column and all new report fields appear correctly in CSV exports before launch
- Document how ops handles a refund or dispute when the `on_behalf_of` entity has been deleted or approval revoked since the original transaction

**Risks / watch-outs**
- If the entity approval queue is not staffed from day one with a clear SLA, merchants will face blocked OBO checkouts with no resolution path — this is an operational readiness gate
- The updated config verbiage (Collection Account Config renamed to include "(Collect OBO)") must not break any existing ops workflows that reference the old config name

---

## For Treasury

**What's changing**
Checkout OBO is an attribution change, not a settlement routing change — funds continue to settle to the merchant account, not to the entity. Settlement mechanics, float requirements, and FX exposure are unchanged at launch for existing corridors. However, if the feature is adopted by large remittance platforms or wallet topup services, corridor-level transaction volumes could increase materially, which would have downstream implications for liquidity planning and peak float exposure.

**Actions / decisions needed**
- Confirm with Product that OBO does not alter the settlement beneficiary — funds settle to the merchant account in all cases, including when `on_behalf_of` is set
- Establish a volume monitoring trigger: if OBO adoption drives significant remittance or wallet topup volumes in specific corridors, Treasury should be alerted early enough to adjust liquidity planning
- Confirm that refund handling for OBO payins does not affect net settlement positions or require any new interbank arrangements
- Assess whether any entity types (MTOs, wallet providers) operating under OBO introduce safeguarding or regulatory capital obligations in target jurisdictions

**Risks / watch-outs**
- If large remittance platform merchants adopt OBO at scale post-launch, peak float exposure in certain corridors could spike quickly — Treasury should have a monitoring threshold in place before launch, not after adoption happens
- No pricing decision is mentioned in the PRD — if OBO transactions are priced differently, this affects revenue recognition and float modelling

---

## For Growth — Sales

**What's changing**
Checkout OBO directly unlocks three merchant segments that have historically been a gap: **marketplace platforms** needing per-seller checkout attribution, **remittance and MTO networks** needing agent-level fund attribution, and **wallet and topup platforms** needing to accept payments on behalf of telcos and mobile money operators. The feature is additive and backward-compatible — existing merchants see no change unless they pass the new `on_behalf_of` field. The entity selection is optional by default, giving merchants full control over adoption pace.

**Actions / decisions needed**
- Get confirmation from Licensing on which entity types and geographies are cleared for launch before briefing Sales or building pipeline — do not sell remittance or MTO use cases until Licensing has signed off
- Prepare a one-pager and battle card covering the three core use cases: marketplace, remittance agent network, wallet/topup platform
- Confirm the commercial model — is OBO checkout priced at standard checkout rates or as a premium feature? Sales cannot pitch without a pricing answer
- Identify existing merchants in the book who are marketplaces, remittance platforms, or fintech aggregators — flag to Account Management for proactive outreach
- Prepare objection responses for: "Do funds go directly to my sub-entities?" (No — they settle to merchant account), "Do my entities need to be KYB'd?" (Depends on config), "Which markets is this available in?"

**Risks / watch-outs**
- Selling remittance agent or MTO use cases before Licensing clears those entity types creates commercial and compliance risk — this is a hard sequencing dependency
- The approval config being default-OFF is a nuance that Sales must understand: merchants can technically process OBO without approving entities, but that may not be acceptable from a compliance standpoint for certain use cases

---

## For Growth — Account Management

**What's changing**
Checkout OBO is an opt-in, additive feature — no existing merchant's checkout flow changes unless they pass the new `on_behalf_of` field. However, merchants who already use entity management (those with `Create_entity` config enabled) can activate OBO with minimal API changes — just one new optional field. For marketplace, fintech, and remittance platform clients in your book, this is a meaningful capability expansion that warrants proactive outreach before or at launch.

**Actions / decisions needed**
- Pull the list of all existing accounts with `Create_entity` config enabled — these are the highest-priority OBO upsell candidates and should receive proactive outreach at launch
- Prepare a plain-language client brief for OBO: avoid "on_behalf_of" jargon — frame it as "checkout for your sub-entities" or "branded checkout on behalf of your sellers or agents"
- Draft FAQ responses for the three most likely client questions: "Will my existing API calls break?" (No), "Do my entities need approval?" (Depends on config), "How do I see entity transactions in my dashboard?" (New Receiver Details section and search)
- Flag any existing clients who have previously raised sub-entity checkout as a missing capability — prioritise them for a direct call, not just an email
- Confirm with Product whether there is a self-serve activation path for OBO or whether AM needs to enable configs on behalf of clients

**Risks / watch-outs**
- Clients with large entity networks may ask about bulk migration or historical transaction attribution — confirm whether there is a migration path before these conversations happen
- If a client's approval config is ON and they try to create OBO checkouts for unapproved entities, they will get API errors — AM needs to be briefed on this error code and the resolution process before launch

---

## For Partnerships

**What's changing**
Checkout OBO introduces four entity type categories — Commerce, Remittance, Financial Services, and Utilities — several of which (wallet providers, mobile money operators, telecom companies, MTOs) may already be Tazapay partners or are prime targets for new partnerships. The feature creates a co-sell opportunity: partners who operate as platforms or aggregators can now offer their downstream merchants or agents proper fund attribution through Tazapay checkout.

**Actions / decisions needed**
- Identify existing partners who fall into the new entity type categories (wallet providers, telcos, MTOs) — assess whether their current agreements cover or benefit from the OBO capability
- Review whether any existing banking partner agreements restrict transactions attributed to MTO or remittance agent entities — this is a hard dependency before those use cases can go live
- Confirm that no scheme or network rules (Visa, Mastercard, local schemes) restrict the use of OBO attribution for the remittance and financial services use cases
- Assess whether any existing distribution partners (platforms, aggregators) should be briefed on OBO as a new capability they can pass to their merchants
- Confirm whether co-sell or GTM partnerships are needed to launch the remittance agent network use case in specific corridors

**Risks / watch-outs**
- If banking partners restrict funds attributed to MTOs or remittance agents, this blocks the most commercially valuable use cases — needs to be confirmed before those segments are sold or marketed
- Any partner who could benefit from being an OBO entity type (e.g. a wallet provider wanting to receive topup attribution) should be identified and managed carefully — their expectations need to be set before launch, not after

---

## For Legal

**What's changing**
Checkout OBO changes the legal structure of a checkout transaction from a bilateral relationship (merchant + Tazapay) to a tripartite one (merchant + entity + Tazapay), where Tazapay is facilitating payment acceptance on behalf of the merchant's entity. The PRD introduces entity types including Money Transfer Operators and remittance agents, which are directly regulated in most jurisdictions. Merchant-facing data changes include entity information surfacing on the hosted checkout page (`hosted_page_display: entity | entity_plus_account`), which raises consumer disclosure questions.

**Actions / decisions needed**
- Review existing merchant agreements to confirm they cover the OBO flow — specifically that funds settle to the merchant even when attributed to an entity, and that Tazapay's liability does not extend to entity-level disputes
- Assess whether displaying entity information on the hosted checkout page (`entity` or `entity_plus_account`) creates any disclosure obligations to end customers under consumer protection or payment transparency regulations
- Confirm whether facilitating checkout on behalf of MTO or remittance agent entities creates any secondary regulatory obligation for Tazapay beyond its current licences
- Assess data protection obligations for entity data (business name, email, country) flowing through the API and stored in the platform — confirm GDPR, PDPA, and other applicable data protection law compliance
- Review the `entity_not_approved` error message and associated user-facing content for any legal liability exposure

**Risks / watch-outs**
- If MTO and remittance agent entity types are in scope at launch and Legal has not confirmed these are within existing contractual and regulatory scope, this is a go-live blocker
- The "deleted entity" display handling has data retention implications — confirm that deletion in the dashboard does not constitute erasure under applicable data protection law, given the need to retain financial records

---

## For Finance

**What's changing**
Checkout OBO is an attribution feature — funds settle to the merchant account as today, so the core revenue recognition model is unchanged at first pass. However, the PRD does not specify whether OBO checkout transactions carry a different fee from standard checkouts, which is an open revenue modelling gap. New entity fields are added to checkout and payin reports and CSV exports (Receiver Name, Entity ID, Receiver Country, Receiver Email, Receiver Reference ID, Entity Status), which may require GL mapping updates if entity-level financial reporting becomes a requirement.

**Actions / decisions needed**
- Confirm with Product whether OBO checkout transactions are priced at standard rates or carry a premium — this is a prerequisite for revenue modelling and must be resolved before launch
- Confirm that revenue recognition continues to happen at the merchant account level, not the entity level — no new revenue line should be required unless pricing changes
- Assess whether entity-level transaction data in reports creates any new financial reporting, inter-company accounting, or cost centre tracking requirements
- Flag any tax implications for cross-border OBO flows where the entity is in a different jurisdiction to the merchant — particularly for MTO and remittance use cases
- Confirm that new CSV export fields are correctly mapped in the financial data pipeline before go-live

**Risks / watch-outs**
- Launching without a pricing decision means Finance cannot model the revenue impact of OBO adoption — if the feature drives significant volume, the P&L effect is unknown
- If large remittance platform merchants adopt OBO at scale, corridor-level volume increases should be tracked from launch — confirm reporting pipelines capture this granularity

---

## For Licensing

**What's changing**
Checkout OBO explicitly enables use cases for Money Transfer Operators, remittance agents, subagents, mobile money operators, and wallet providers as entity types. These are regulated categories in virtually every jurisdiction Tazapay operates in. The PRD confirms cross-border remittance as a supported use case. The `on_behalf_of_configuration` field added on 16.03.2025 introduces a hosted page display option that surfaces entity branding to end customers, which may have regulatory implications in some markets around payment transparency and consumer disclosure.

**Actions / decisions needed**
- Map each entity type category (Commerce, Remittance, Financial Services, Utilities) to your current licence permissions in every target geography — confirm which are in scope and which require new permissions or notifications
- Assess whether Tazapay's role as infrastructure provider for MTO or remittance agent checkouts constitutes a regulated activity in any jurisdiction where we do not currently hold the relevant permission
- Confirm whether any target geographies require a material change notification or prior regulatory approval before this product type is launched
- Review whether enabling cross-border remittance flows via OBO checkout triggers new reporting thresholds or licence conditions
- Confirm that the entity approval workflow (approval_status = approved) satisfies any licensing obligation to verify the counterparty before processing payments on their behalf

**Risks / watch-outs**
- Launching MTO and remittance agent entity types in jurisdictions where the licence does not explicitly cover facilitation for these categories is a material compliance risk — Licensing sign-off is a hard launch gate
- If any jurisdiction requires a new licence or prior approval, the timeline impact could be significant — this determination needs to be made before engineering completes, not after

---

## For Product — Payments Pod

**What's changing**
Two API objects are modified: `POST /v3/checkout` gains optional fields `on_behalf_of` (string, entity ID) and `on_behalf_of_configuration` (object with `hosted_page_display` enum: `entity` | `entity_plus_account`). The payin object inherits `on_behalf_of` automatically when a checkout with that field completes. All existing checkout and payin webhook events are updated to include the `on_behalf_of` field and an `entity_details` block (entity_id, business_name, email, reference_id) when applicable. No new payment rails, settlement logic, or routing changes are introduced.

**Actions / decisions needed**
- Confirm that `on_behalf_of` validation is enforced server-side: entity must exist, belong to the merchant, be active, and (if config is ON) have `approval_status = approved`
- Validate the inheritance chain end-to-end: checkout with `on_behalf_of` → completed payin automatically carries the same value → webhook includes `entity_details`
- Confirm backward compatibility of webhook changes — additive fields should not break existing consumers, but strict schema validators will fail — plan merchant communication accordingly
- Define and test the rollback plan: if `on_behalf_of` data is found to be mis-attributed post-launch, what is the remediation path and who owns it?
- Confirm the `on_behalf_of_configuration` field (scoped in March) is fully implemented and tested — it appears as a later addition and should not be a partial implementation at launch

**Risks / watch-outs**
- The concurrent checkout creation edge case (listed in the PRD testing checklist) could produce duplicate or mis-attributed `on_behalf_of` values — confirm this is covered in load testing before go-live
- `entity_details` in webhooks includes PII (business email, business name) — confirm data minimisation and PII handling compliance before these payloads go live to merchants

---

## For Product — Operations Pod

**What's changing**
This release requires the largest ops dashboard changes of any recent feature. On the checkout and payin listing screens: new "Receiver Details" column (entity ID, business name, email), OBO filter (All/Yes/No), and entity search optimisation (entity_id, business_name, reference_id, email with partial match). On checkout and payin summary screens: new "Receiver Details" section with entity ID (clickable, links to KYB review), business name, email, country, approval status, and industry. On the entity listing screen: split into "Review Required" and "Review Not Required" categories. Two new OBO configs added to the Merchant account config tab. Updated verbiage on the existing Collection Account Config.

**Actions / decisions needed**
- Confirm all new dashboard screens are built, tested in staging, and signed off before go-live — the ops team cannot action OBO exceptions without these tools
- Validate the "Review Required / Review Not Required" categorisation logic: entities where approval is mandatory for collects, payins, or payouts → Review Required; all others → Review Not Required
- Build the ops runbook for the entity approval queue: what does an ops agent see, what decisions do they make, what is the SLA, and who escalates unresolved reviews?
- Confirm the new OBO configs on the Merchant account config tab are permission-gated — only operators with the correct role should be able to toggle them
- Test the Collection Account Config rename ("Collect OBO" suffix) to confirm it does not break any existing ops workflows that reference the old label

**Risks / watch-outs**
- If the entity approval queue launches without a staffed ops process and defined SLA, merchants will face blocked checkouts with no resolution path on day one
- The new report fields must appear in CSV exports, not just the UI — confirm CSV export testing is part of the launch checklist

---

## For Product — Merchant Pod

**What's changing**
Merchant-facing changes include: a new optional `on_behalf_of` field and `on_behalf_of_configuration` object in the checkout and payin API; updated webhook payloads with `on_behalf_of` and `entity_details` block across all checkout and payin events; a new "Receiver Details" section on checkout and payin summary screens in the merchant dashboard; entity search optimisation in transaction listings; a new "On Behalf Of" entity selection section in the manual checkout creation flow (only visible if entity capability is enabled); and new entity fields in checkout and payin CSV report exports.

**Actions / decisions needed**
- Confirm that API documentation is updated and accurate before launch: `on_behalf_of` field definition, validation rules, both error codes (`entity_not_approved`, `on_behalf_of field is required`), and the `on_behalf_of_configuration` schema with enum values
- Publish a webhook changelog marking the new `on_behalf_of` and `entity_details` fields as additive — proactively notify merchants who use strict webhook schema validation
- Confirm the sandbox environment supports entity creation and OBO checkout end-to-end so merchants can self-test before going live in production
- Validate the manual checkout creation UI: entity dropdown search, approval-gated filtering (only approved entities shown when config is ON), and error state when a non-approved entity is selected
- Prepare a developer guide or use-case guide for marketplace and remittance integrations — the `on_behalf_of` field is simple, but the end-to-end entity setup and approval flow is not obvious from the API reference alone

**Risks / watch-outs**
- If sandbox does not support entity management and OBO checkout at launch, merchants cannot self-test — this is a high-friction adoption risk that will increase support load
- The `hosted_page_display` enum (`entity` vs `entity_plus_account`) needs clear documentation and ideally visual examples — merchants will not know how to use it without seeing the difference

---

## For Product — Data

**What's changing**
This release introduces significant new data across two core objects. New fields on checkout: `on_behalf_of` (entity ID string), `on_behalf_of_configuration.hosted_page_display` (enum). New fields on payin: inherited `on_behalf_of`, entity details block (entity_id, business_name, email, country, approval_status, industry_vertical). New webhook fields: `on_behalf_of` and `entity_details` on all checkout and payin events. New report and CSV export fields: Receiver Name, Entity ID, Receiver Country, Receiver Email, Receiver Reference ID, Entity Status, Receiver Industry Vertical, Merchant Name (ops reports only).

**Actions / decisions needed**
- Confirm that all new `on_behalf_of` and entity fields are instrumented in the data pipeline from day one — post-launch instrumentation cannot backfill historical OBO transactions
- Define tracking events for key OBO actions: OBO checkout created, OBO checkout completed, entity approval submitted, entity approved, entity rejected — confirm ownership and implementation timeline
- Confirm that the new report fields are available in the data warehouse and queryable for business analytics from launch
- Define success metrics for the feature (OBO adoption rate, entities created per merchant, OBO checkout completion rate vs standard) and confirm dashboard ownership
- Assess whether existing checkout and payin analytics dashboards need new OBO dimensions or filters — identify and build before launch, not after

**Risks / watch-outs**
- The `entity_details` block in webhooks includes PII (business email, business name) — confirm data retention periods, access controls, and anonymisation policies meet internal data governance standards
- Entity approval events will generate a new event stream (submitted → approved/rejected) that is likely needed for Compliance reporting — confirm this is tracked and routable from day one

---

## For Engineering

**What's changing**
In scope: (1) `POST /v3/checkout` — new optional fields `on_behalf_of` and `on_behalf_of_configuration`; (2) payin object — inherits `on_behalf_of` from checkout, includes `entity_details` in response and webhooks; (3) all checkout and payin webhook events — updated payload schema with new fields; (4) ops dashboard — new columns, filters, entity search, entity listing categorisation, and two new merchant configs; (5) merchant dashboard — new Receiver Details sections, manual checkout entity selector, report export fields. Out of scope: no new payment rails, no changes to settlement routing, no changes to any other API objects.

**Actions / decisions needed**
- Confirm deployment strategy: is this a feature-flag gated rollout, a gradual merchant rollout, or a hard cutover for all accounts? Define the rollback trigger and owner before deployment
- Confirm that `on_behalf_of` validation is enforced server-side (entity exists, belongs to merchant, is active, approval status check) — front-end validation alone is not sufficient
- Define monitoring and alerting for: `entity_not_approved` error rate spike, OBO checkout creation failure rate, webhook delivery failure rate for updated payload schema
- Validate that the concurrent checkout creation edge case (listed in the testing checklist) is covered — mis-attributed payins are hard to remediate post-launch
- Confirm the `on_behalf_of_configuration` field (added in the March update) is fully tested and not a partial implementation — it appears as a later scope addition

**Risks / watch-outs**
- Webhook schema changes are additive but will break any merchant using strict JSON schema validation — confirm backward compatibility testing is complete and the merchant communication plan is ready before deployment
- The entity listing screen categorisation change affects the ops approval workflow at launch — if this screen is not performant under high entity volumes, the ops queue becomes unusable

---

## How to Use These Notes

1. Each team reads their section — tailored to their function
2. Actions/decisions — treat as a pre-launch checklist; flag any blockers to the PM
3. Risks/watch-outs — escalate before go-live, not after
4. Run a sync — share this document, let each team confirm their actions, assign owners

*Generated by Launch Notes System. Commit to git for version history and team visibility.*
