# Pre-Launch Sync Notes

**Feature:** Checkout on Behalf Of (Checkout OBO)
**Date:** April 29, 2026
**Teams covered:** 16

> These notes are tailored per team. Each team should read their section only.

---

## For Compliance — Onboarding

**What's changing**
Checkout OBO introduces a new entity layer into the payment flow — merchants can now create checkout sessions on behalf of distinct sub-entities (sellers, remittance agents, wallet providers, telecom operators). This expands the range of entity types we onboard, including Money Transfer Operators, Remittance Agents, Mobile Money Operators, and Utility Companies — each of which may carry different risk profiles and require different CDD/EDD procedures. A new optional config (`Mandatory entity approval required for checkout creation`) controls whether entities must be KYB-approved before a checkout can be created on their behalf.

**Actions / decisions needed**
- Review and update CDD/EDD procedures for each new entity type category (Commerce, Remittance, Financial Services, Utilities & Services)
- Determine whether sanctions screening and PEP checks are applied at entity creation and/or at checkout creation time — confirm no gap exists
- Confirm whether the approval workflow (entity approval_status = approved) is compliant with your risk appetite for cross-border remittance and wallet topup use cases
- Update the onboarding policy or risk appetite statement to formally cover sub-entity onboarding on behalf of merchants
- Sign off on the entity approval configuration being OFF by default — confirm this is acceptable for go-live

**Risks / watch-outs**
- Remittance agent and subagent entity types may trigger enhanced due diligence requirements under AML regulations — confirm this is in scope before launch
- If merchants onboard entities without approval requirements enabled, there is a risk that unverified entities receive funds — policy sign-off required
- Cross-border remittance use cases (wallet topups, MTO networks) likely have corridor-specific compliance obligations that are not addressed in this PRD

---

## For Compliance — Transaction Monitoring

**What's changing**
Checkout OBO adds a new `on_behalf_of` field to checkout and payin transactions, meaning all existing and future payin flows can now be attributed to a sub-entity rather than just the merchant account. This introduces a new transaction typology — payments made on behalf of remittance agents, mobile money operators, and wallet providers — which may not be covered by current monitoring rules. New data fields (`entity_id`, `entity.business_name`, `entity.reference_id`, entity approval status) are now captured on every OBO payin and will be available for monitoring.

**Actions / decisions needed**
- Audit existing AML monitoring rules to confirm they cover the new entity-level transaction typology (remittance agent topups, MTO payments, wallet recharges)
- Confirm whether `on_behalf_of` entity data will be fed into the monitoring system and alert engine — if not, raise as a data integration requirement before launch
- Assess whether velocity rules need to be updated to account for high-frequency wallet topup or mobile money use cases
- Determine if new SAR/STR filing triggers are needed for transactions attributed to remittance entities
- Validate whether the new `entity_id` field will appear in the monitoring data feed and transaction reports

**Risks / watch-outs**
- Remittance and MTO entity types are high-risk typologies — if monitoring rules don't cover them, there is a genuine SAR/STR filing gap at launch
- The volume of OBO payins could spike quickly if large marketplace or remittance platform merchants adopt the feature — false positive rate on existing rules may increase
- Entity approval status is not immutable: an entity can be approved, then revoked. Confirm that monitoring handles mid-flow approval changes correctly

---

## For Risk

**What's changing**
Checkout OBO introduces a new layer of counterparty risk: merchants can now attribute payments to sub-entities, including licensed remittance agents, wallet providers, and telecom operators. The primary risk surface is that funds may flow to entities that are unapproved, inactive, or high-risk if the mandatory approval config is left OFF (the default). The PRD introduces a "deleted entity" state where historical data is preserved but the entity is inactive — confirm that this state does not create operational risk in refund or dispute scenarios.

**Actions / decisions needed**
- Sign off on entity approval being optional by default — confirm the residual risk of an unapproved entity receiving funds is within appetite
- Define exposure limits for OBO transaction volume per merchant, particularly for remittance agent and MTO entity types
- Review the fraud surface created by the manual checkout creation flow (entity dropdown) — assess spoofing or entity substitution risk
- Confirm that the "deleted entity" display handling in dashboards and reports does not affect the integrity of financial records or chargeback processing
- Assess whether existing fraud models account for marketplace seller and remittance agent payment patterns

**Risks / watch-outs**
- If a merchant enables OBO for a large remittance agent network without approval enforcement, exposure to unverified entities could be significant
- Refund handling for OBO payins retains the `on_behalf_of` linkage — confirm this does not create settlement or chargeback attribution issues
- Concurrent checkout creation edge case (mentioned in testing checklist) could create duplicate or mis-attributed payments — confirm this is tested and has a rollback path

---

## For Payment Operations

**What's changing**
Checkout OBO does not introduce new payment rails or settlement windows — it operates within the existing checkout and payin infrastructure. However, it adds a new data dimension (`on_behalf_of`) to every payin, which will surface in transaction listings, summary screens, and reports. The ops dashboard now has new search fields (entity_id, business_name, reference_id, email), OBO filters, and a "Receiver Details" column on checkout and payin listing screens. The entity listing screen now splits submitted entities into "Review Required" and "Review Not Required" categories.

**Actions / decisions needed**
- Update ops team runbooks to include the new "Receiver Details" column and OBO filter in the checkout and payin listing screens
- Train the ops team on the new entity listing screen categories (Review Required / Review Not Required) and the approval workflow
- Confirm that the exception handling process for `entity_not_approved` errors is documented — what does ops do when a merchant raises an error about a blocked checkout?
- Validate that the new report fields (Receiver Name, Entity ID, Receiver Country, etc.) appear correctly in CSV exports
- Confirm that "deleted entity" display ("(Deleted)") is handled consistently across all ops screens and does not cause confusion during disputes

**Risks / watch-outs**
- If the entity approval queue grows rapidly post-launch (especially for remittance agent onboarding), ops capacity to review and approve entities may become a bottleneck
- New dashboard columns and search fields add cognitive load — confirm ops team is trained before go-live, not after
- Refund flows for OBO payins maintain entity linkage — confirm ops understand how to process refunds when the entity is deleted or approval is revoked

---

## For Treasury

**What's changing**
Checkout OBO does not change settlement mechanics, float requirements, or currency exposure — funds still settle to the merchant account as today. The `on_behalf_of` field is an attribution layer, not a routing change. However, if merchants use OBO for cross-border remittance use cases (wallet topups, MTO payments), transaction volumes in existing corridors may increase, which could affect peak float exposure. No new currencies, accounts, or prefunding arrangements appear to be required at launch.

**Actions / decisions needed**
- Confirm with Product that OBO does not change the settlement account or beneficiary — funds still settle to the merchant, not the entity
- Monitor for volume increases in remittance corridors if large MTO or wallet provider merchants onboard post-launch
- Confirm that refund handling for OBO payins does not affect net settlement positions or require new interbank arrangements
- Review whether the new entity types (MTOs, wallet providers) introduce any additional regulatory capital or safeguarding requirements in relevant jurisdictions

**Risks / watch-outs**
- If the feature is adopted by large remittance platforms at scale, peak corridor volumes could increase materially — treasury should have a monitoring trigger in place
- Cross-border remittance use cases may have jurisdiction-specific safeguarding or float requirements (e.g., PI licence conditions) — confirm these are covered before launch

---

## For Growth — Sales

**What's changing**
Checkout OBO enables merchants to create checkout sessions on behalf of sub-entities — sellers in a marketplace, remittance agents, wallet providers, or service providers. This is a major unlock for three high-value segments: **marketplace platforms** (multi-seller checkout), **remittance and money transfer businesses** (agent network payments, wallet topups), and **financial services platforms** (mobile money, telecom topups). The `on_behalf_of` field is optional and additive — existing merchants are unaffected unless they opt in.

**Actions / decisions needed**
- Update the sales deck and one-pager to include the three primary use cases: marketplace, remittance agent networks, and wallet topups
- Prepare a pricing/commercial brief — confirm whether OBO transactions are priced differently or use the same fee structure
- Confirm which geographies are in scope at launch (the PRD mentions cross-border remittance but does not specify corridors)
- Identify 3–5 existing merchant accounts that are best positioned for an OBO upsell conversation — flag to Account Management
- Prepare objection handling for: "Do you support MTOs?" / "Can my sub-merchants receive directly?" / "Is this available in [market]?"

**Risks / watch-outs**
- The approval config is OFF by default — Sales should not promise that all entity types are "pre-approved" without checking with Compliance
- Cross-border remittance positioning requires Licensing sign-off on which corridors are in scope — do not sell into corridors that aren't confirmed
- Avoid promising full sub-merchant payout capability — this is checkout attribution only, settlement still goes to the merchant account

---

## For Growth — Account Management

**What's changing**
Checkout OBO is an opt-in feature — existing merchants are not affected unless they add `on_behalf_of` to their checkout API calls. However, for marketplace, fintech, and remittance platform clients in your book, this is a meaningful expansion that warrants proactive outreach. Merchants who already use the entity management feature (Create_entity config enabled) can activate OBO with minimal integration effort — just one new optional API field.

**Actions / decisions needed**
- Identify all existing accounts with `Create_entity` config enabled — these are the highest-priority OBO upsell candidates
- Prepare client-facing messaging explaining the new capability in plain language (avoid "on_behalf_of" jargon — frame as "checkout for sub-entities" or "branded checkout for your sellers/agents")
- Draft FAQ responses for likely client questions: "Do my sub-entities need to be approved?", "Will my existing API calls break?", "How do I see sub-entity transactions in my dashboard?"
- Flag any existing marketplace or remittance clients who may have raised this capability as a gap — prioritise them for outreach
- Confirm with Product whether there is a self-serve activation path or if AM needs to enable OBO configs on behalf of clients

**Risks / watch-outs**
- Clients with large entity networks may want to bulk-migrate to OBO — confirm whether there is a migration path or if they need to re-attribute transactions manually
- If a client has the approval config ON and tries to create OBO checkouts for unapproved entities, they will receive API errors — AM should be prepared to handle escalations
- Some clients may ask whether this replaces the Collect OBO feature — have a clear answer ready distinguishing checkout vs. collection OBO

---

## For Partnerships

**What's changing**
Checkout OBO does not introduce new payment scheme or banking partner dependencies — it operates within existing checkout infrastructure. However, it enables new use cases (remittance agent networks, mobile money topups, MTO payments) that may have implications for existing or prospective distribution partnerships with fintech platforms, wallet providers, and telecom operators. The entity type taxonomy (Money Transfer Operator, Remittance Agent, Wallet Provider, Mobile Money Operator) signals a clear strategic direction toward B2B2C remittance and financial services infrastructure.

**Actions / decisions needed**
- Review whether any existing partnership agreements with wallet providers or telecom operators need to be updated to reflect the new OBO capability
- Assess whether any distribution or technology partners are positioned to leverage OBO as part of their own product offering — identify 2–3 potential co-sell opportunities
- Confirm that no scheme or network rules (Visa, Mastercard, local payment schemes) restrict the use of OBO attribution for remittance or MTO transactions
- Check whether cross-border remittance corridors are covered by existing banking partner arrangements or if new agreements are needed

**Risks / watch-outs**
- If banking partners have restrictions on funds attributed to MTOs or remittance agents, this needs to be confirmed before remittance use cases are sold
- Some wallet provider or telecom partnerships may require formal data sharing or API integration agreements before entity data can be passed — confirm this is not required at launch

---

## For Legal

**What's changing**
Checkout OBO introduces a sub-entity layer that changes the legal structure of payment attribution — Tazapay is facilitating checkout on behalf of a merchant's entities, not just the merchant. This raises questions about: (1) whether existing merchant agreements cover this tripartite structure (merchant + Tazapay + entity), (2) whether the "ultimate receiver of funds" construct creates any new liability or disclosure obligations, and (3) whether the remittance and MTO entity types trigger specific regulatory obligations (e.g., money service business regulations, cross-border payment disclosures).

**Actions / decisions needed**
- Review merchant agreements to confirm they cover the OBO flow — particularly the clause that funds settle to the merchant account, not the entity
- Assess whether the "ultimate receiver of funds" framing creates any disclosure obligations to end customers (payers) under consumer protection or payment transparency rules
- Confirm whether the entity type taxonomy (MTO, Remittance Agent, Wallet Provider) requires any additional contractual representations or warranties from merchants
- Assess data protection obligations for entity data (business_name, email, country) passed through the API and stored in the platform — confirm GDPR/PDPA compliance
- Confirm whether the PRD's "out of scope" position on UI changes and other objects is sufficient to limit legal exposure at launch

**Risks / watch-outs**
- The MTO and Remittance Agent entity types likely trigger specific regulatory obligations in multiple jurisdictions — Legal needs to confirm these are within the current licence perimeter before launch
- If merchants use OBO to attribute payments to entities in jurisdictions where Tazapay does not hold the relevant licence, there is a regulatory perimeter risk
- The deleted entity display handling ("(Deleted)") may have record-keeping implications under financial regulation — confirm data retention for deleted entity records

---

## For Finance

**What's changing**
Checkout OBO is an additive feature to the existing checkout product — it does not change the revenue model or fee structure for checkout transactions (this is not confirmed in the PRD and should be verified). Revenue continues to be recognised at the merchant level. The `on_behalf_of` field is an attribution field and does not change the settlement flow — funds settle to the merchant account as today. New entity fields are added to checkout and payin reports, which may require GL mapping updates if entity-level financial reporting is required.

**Actions / decisions needed**
- Confirm with Product whether OBO transactions carry a different fee (e.g., premium for sub-entity attribution) or use the same checkout pricing — update revenue model if needed
- Confirm that revenue recognition is at the merchant level and not at the entity level — no new revenue line required unless pricing changes
- Assess whether entity-level transaction data in reports creates any new financial reporting or inter-company accounting requirements
- Confirm that the new report fields (Receiver Name, Entity ID, Receiver Country, etc.) do not require new GL mappings or cost centre tracking
- Assess tax implications for cross-border remittance and MTO use cases — particularly if the entity is in a different jurisdiction to the merchant

**Risks / watch-outs**
- If the feature drives significant adoption by remittance platforms, corridor-level volume and revenue should be tracked — confirm reporting pipelines capture this from launch
- The PRD does not specify pricing for OBO — if it is being launched without a pricing decision, Finance should flag this as a revenue recognition risk

---

## For Product — Payments Pod

**What's changing**
This release adds an optional `on_behalf_of` field to the `POST /v3/checkout` and payin endpoints. When set, the payin automatically inherits the `on_behalf_of` value from the checkout session. A new `on_behalf_of_configuration` object is also added (with `hosted_page_display: entity | entity_plus_account`) to control hosted page rendering. Webhooks for checkout and payin events are updated to include the `on_behalf_of` field and entity details. No new payment rails, schemes, or routing logic are introduced.

**Actions / decisions needed**
- Confirm that the `on_behalf_of` field inheritance from checkout to payin is tested end-to-end, including edge cases (entity deleted mid-session, approval revoked between checkout creation and completion)
- Validate webhook payload changes — confirm all existing checkout and payin webhook subscribers receive the updated payload schema without breaking changes
- Confirm that the `on_behalf_of_configuration.hosted_page_display` enum is validated server-side and returns a clear error for invalid values
- Define the rollback plan: if `on_behalf_of` data is found to be corrupted or mis-attributed post-launch, what is the remediation path?
- Confirm API versioning strategy — is this a non-breaking additive change to v3, or does it require a new API version?

**Risks / watch-outs**
- The concurrent checkout creation edge case could result in duplicate `on_behalf_of` attributions — confirm this is covered in load testing
- Webhook consumers who parse the checkout/payin payload may break if they do strict schema validation — confirm backward compatibility
- The `entity_details` block in webhooks includes business_name and email — confirm PII handling and data minimisation compliance before launch

---

## For Product — Operations Pod

**What's changing**
This release requires significant updates to the ops dashboard. New additions include: "Receiver Details" column on checkout and payin listing screens; OBO filter (All/Yes/No) on checkout, payin, and entity screens; entity search optimization (entity_id, business_name, reference_id, email with partial match); entity information section on checkout and payin summary screens; entity listing screen split into "Review Required" / "Review Not Required"; and new report fields (Receiver Name, Entity ID, Receiver Country, Receiver Email, Receiver Approval Status, Receiver Industry Vertical, Receiver Reference ID). Two new OBO configs are also added to the Merchant account config tab.

**Actions / decisions needed**
- Confirm that all new ops dashboard screens (listing, summary, entity listing) are built and tested in staging before go-live
- Validate that the entity search with partial match works correctly across all four entity fields (entity_id, business_name, reference_id, email)
- Confirm the "Review Required / Review Not Required" categorisation logic is correct — entities requiring approval for any of: collects, payins, payouts should go to Review Required
- Build and validate the ops runbook for the entity approval workflow — what does an ops agent do when an entity is in the queue? What are SLAs?
- Confirm that the two new OBO configs on the Merchant account config tab are only visible to operators with the correct permission level

**Risks / watch-outs**
- If the entity approval queue is not staffed and SLA-managed from day one, merchants may experience blocked OBO checkouts with no resolution path
- The new report fields must appear in CSV exports — confirm this is tested, not just the UI
- The updated verbiage for existing OBO configs (Collection Account Config rename) must not break any existing ops workflows that reference the old config name

---

## For Product — Merchant Pod

**What's changing**
Merchants interact with this feature through: (1) a new optional `on_behalf_of` field in the checkout and payin API; (2) a new `on_behalf_of_configuration` object for hosted page display control; (3) an enhanced merchant dashboard with a "Receiver Details" section on checkout and payin summary screens; (4) new entity search fields in transaction listings; and (5) a new "On Behalf Of" entity selection section in the manual checkout creation flow (only visible if entity capability is enabled). Webhooks include the `on_behalf_of` field and entity_details block. New report fields are added to checkout and payin CSV exports.

**Actions / decisions needed**
- Confirm that API documentation is updated before launch — specifically: `on_behalf_of` field definition, validation rules, error codes (`entity_not_approved`, `on_behalf_of required`), and `on_behalf_of_configuration` schema
- Update the webhook changelog to document the new `on_behalf_of` and `entity_details` fields — tag as additive (non-breaking) to reassure existing webhook consumers
- Confirm the sandbox environment includes entity management capabilities so merchants can test OBO end-to-end before going live
- Validate the manual checkout creation UI — entity dropdown search, approval-gated filtering, and error state display when a non-approved entity is selected
- Prepare a developer guide or use-case guide for marketplace and remittance use cases — these are non-trivial integrations that will need documentation beyond the API reference

**Risks / watch-outs**
- If sandbox does not support entity creation and OBO checkout, merchants cannot self-test before production — this is a high-friction onboarding risk
- The `on_behalf_of_configuration.hosted_page_display` field is underdocumented in the PRD — confirm the exact UI behaviour for `entity` vs `entity_plus_account` is specified and documented
- Merchants using strict webhook schema validation may break when the new `entity_details` block appears — proactive communication needed

---

## For Product — Data

**What's changing**
This release introduces significant new data across the checkout and payin objects. New fields on checkout: `on_behalf_of` (entity ID), `on_behalf_of_configuration` (hosted page display enum). New fields on payin: inherited `on_behalf_of`, entity details block (entity_id, business_name, email, country, approval_status). New fields in all checkout/payin webhooks: `on_behalf_of` and `entity_details`. New fields in checkout and payin reports/exports: Receiver Name, Entity ID, Receiver Country, Receiver Email, Receiver Reference ID, Entity Status (Approval Status), Receiver Industry Vertical, Merchant Name.

**Actions / decisions needed**
- Confirm that all new `on_behalf_of` fields and entity fields are instrumented in the data pipeline from day one — not a post-launch instrumentation task
- Define and implement tracking events for key OBO actions: OBO checkout created, OBO checkout completed, entity approval triggered, entity approval granted/rejected
- Confirm that the new report fields are available in the data warehouse and can be queried for business analytics
- Confirm whether existing checkout/payin dashboards need new dimensions or filters for OBO vs non-OBO transactions
- Define success metrics for the feature: OBO adoption rate, entities created per merchant, OBO checkout completion rate — confirm ownership and baseline

**Risks / watch-outs**
- If `on_behalf_of` data is not captured in the data pipeline at launch, it cannot be backfilled — confirm instrumentation is part of the launch criteria, not a follow-up
- The entity approval workflow will generate approval event data (submitted, approved, rejected) — confirm these events are tracked and routable to Compliance reporting
- The `entity_details` block in webhooks includes PII (email, business_name) — confirm data retention and access controls meet policy requirements

---

## For Engineering

**What's changing**
In scope: (1) `POST /v3/checkout` — new optional fields: `on_behalf_of` (string), `on_behalf_of_configuration` (object with `hosted_page_display` enum); (2) payin object — inherits `on_behalf_of` from checkout session, includes entity details in response; (3) webhook payloads for all checkout and payin events — new `on_behalf_of` and `entity_details` fields; (4) ops dashboard — new columns, filters, search fields, entity listing categorisation, and two new merchant configs; (5) merchant dashboard — new Receiver Details sections, manual checkout entity selector, enhanced transaction search and report exports. Out of scope: no new payment rails, no changes to settlement logic, no changes to other objects.

**Actions / decisions needed**
- Confirm that the `on_behalf_of` field validation (entity must exist, belong to merchant, be active) is implemented server-side and not just front-end
- Define and test the deployment plan — confirm whether this is a feature-flag gated rollout or a hard cutover for all merchants
- Confirm the rollback strategy: if `on_behalf_of` data causes downstream issues (webhook schema breaks, report field errors), what is the rollback path and who owns it?
- Validate that the concurrent checkout creation edge case is covered in load testing — mis-attributed payins could be hard to remediate post-launch
- Confirm monitoring and alerting is in place for: `entity_not_approved` error rate, OBO checkout creation failures, webhook delivery failures for the updated payload schema

**Risks / watch-outs**
- The `on_behalf_of_configuration` field (added 16.03.2025) appears to be a later addition to the scope — confirm it is fully tested and not a partial implementation at launch
- Webhook schema changes are additive but could break strict consumers — confirm backward compatibility testing is complete and communication to merchant developers is planned
- The entity listing screen categorisation change (Review Required / Review Not Required) affects the ops approval workflow — confirm this does not degrade performance if entity volumes grow rapidly post-launch

---

## For Licensing

**What's changing**
Checkout OBO enables merchants to attribute payments to sub-entities categorised as Money Transfer Operators, Remittance Agents, Subagents, Mobile Money Operators, and Wallet Providers. These entity types are directly regulated in most jurisdictions where Tazapay operates — they require specific licences (money service business, payment institution, e-money) and are subject to AML and counter-terrorism financing obligations. The PRD enables cross-border remittance use cases explicitly, which raises material questions about whether existing licence permissions cover Tazapay's role as infrastructure provider for these flows.

**Actions / decisions needed**
- Map the new entity types (MTO, Remittance Agent, Subagent, Mobile Money Operator, Wallet Provider) to the licence permissions in each target geography — confirm which are in scope and which require new permissions
- Assess whether Tazapay's role as "facilitator of checkout on behalf of" a licensed MTO or remittance agent creates any secondary licence obligation or notification requirement
- Confirm whether any target jurisdictions require regulators to be notified of new product types (e.g., material change notifications for PI licences) before launch
- Review whether enabling cross-border remittance corridors via OBO triggers any new licence conditions or reporting thresholds
- Confirm that the entity approval workflow (approval_status = approved) satisfies any licensing obligation to verify the counterparty before processing payments on their behalf

**Risks / watch-outs**
- Launching with MTO/remittance agent entity types in jurisdictions where the licence does not explicitly cover facilitation for these entity types is a material compliance risk
- If a regulator classifies Tazapay's OBO role as "acting as a payment agent" for the entity, additional permissions or notifications may be required immediately
- Upcoming licence renewals or audits could be negatively affected if OBO remittance flows are not clearly within scope before the audit window

---

## How to Use These Notes

1. **Each team reads their section** — tailored to their function and concerns
2. **Actions/decisions** — treat as a pre-launch checklist; flag any blockers
3. **Risks/watch-outs** — escalate these before go-live, not after
4. **Run a sync** — share this document, let teams ask questions, then each team owns their section

---

*Generated by Launch Notes System — commit to git for version history and team visibility.*
