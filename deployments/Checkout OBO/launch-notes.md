# Pre-Launch Sync Notes

**Feature:** Checkout OBO (Checkout on Behalf Of)
**Date:** 2026-04-30
**Teams covered:** 16

---

## Common Context

> What every team needs to know before reading their section.

- **What it is**: Merchants can now register entities — sellers and individuals — within their account and create checkout sessions on those entities' behalf using a single optional field (`on_behalf_of`) on the checkout API; the payin automatically inherits the entity attribution on checkout completion, no extra API calls required
- **Primary use cases**: Marketplace platforms (seller payments), payment aggregators, cross-border remittance services, wallet topup platforms, and bill payment aggregators
- **Entity categories supported**: Commerce (sellers, merchants, vendors), Remittance (MTOs, remittance agents, subagents), Financial Services (wallet providers, mobile money operators, telcos), Utilities (utility companies, billers)
- **No new rails or settlement changes**: Checkout OBO is a metadata attribution layer on existing checkout and payin infrastructure — no new payment rails, PSP integrations, or settlement windows are introduced
- **Two new merchant-level configs, both default OFF**: (1) `Mandatory entity approval required for checkout creation` — entities must be approved before OBO checkout is allowed; (2) `Mandatory OBO information for checkout` — makes `on_behalf_of` required for all checkouts on that account
- **Entity data in payloads and reports**: Payin webhooks now include an `entity_details` block (entity ID, business name, email, reference ID) when `on_behalf_of` is set; new entity fields also appear in merchant and ops CSV exports
- **Availability**: No geography restrictions specified in the PRD — availability is gated by Compliance and Licensing sign-off per entity type and merchant segment; MTO and remittance entity types require additional review before enablement

---

## For Compliance — Onboarding

**What's changing for you**
Merchants can now register entities — sellers and individuals — within their account, and create checkout sessions on those entities' behalf. This introduces a new sub-merchant-style layer: entities are onboarded under a parent merchant, but they are the ultimate receivers of funds. The entity approval workflow (KYB review and approval_status gating) is now directly wired into whether checkout sessions can be created on an entity's behalf — making your approval gate a real-time production control.

**Actions / decisions needed**
- Confirm whether the default-OFF config (`Mandatory entity approval required for checkout creation`) is acceptable from a compliance standpoint at launch, or whether specific merchant categories should have this toggled ON pre-launch
- Sign off on the entity approval workflow and SLA — since an unapproved entity blocks checkout creation when the config is enabled, delays in your approval queue directly block merchant operations

**Risks / watch-outs**
- The entity approval config defaults to OFF at the account level, meaning entities can have checkout sessions created on their behalf without compliance sign-off unless this is explicitly enabled per merchant — confirm this is acceptable, or flag which merchant segments should have it enforced at launch

**Sardine**
- Open question: is the Sardine data mapping complete for the Checkout OBO flow? The new flow passes entity fields (entity ID, business name, entity type) alongside the standard checkout data — confirm the correct data structure is locked and flowing to Sardine before launch
- Validate in staging that OBO checkout sessions do not generate false positive rule alerts in Sardine — if the mapping is not confirmed, this is a launch blocker for this team

---

## For Compliance — Transaction Monitoring

**What's changing for you**
Checkout and payin transactions can now carry an `on_behalf_of` field — the entity ID of the ultimate funds receiver — in addition to the merchant identifier. This means a single merchant account may now generate payin transactions attributable to dozens or hundreds of distinct entities (sellers, MTOs, wallet providers, billers). All payin webhooks now include `entity_details` (entity ID, business name, email, reference ID), which must be ingested into your monitoring system for accurate typology coverage.

**Actions / decisions needed**
- Review existing AML rule-sets to confirm they can segment transaction activity by entity, not just by merchant — velocity, volume, and corridor rules that only operate at the merchant level will miss entity-level structuring or aggregation patterns
- Confirm that the `on_behalf_of` and `entity_details` fields from payin webhooks are being ingested into the TM system before launch; this data is the primary identifier for entity-level monitoring
- Assess whether any existing typology rules need recalibration for remittance and MTO entity types, which are explicitly supported and represent higher-risk corridors
- Brief the alert triage team on the new pattern: a single merchant may generate large transaction volumes across many entities — triage teams need context to distinguish legitimate marketplace/aggregator activity from structuring
- Confirm SAR/STR filing logic still maps correctly when the entity and merchant are different legal entities receiving or attributed to the same payin

**Risks / watch-outs**
- Without entity-level segmentation in monitoring rules, a marketplace merchant with 500 seller entities could appear as one high-volume merchant — masking entity-level suspicious patterns entirely; this is the single biggest monitoring gap to close before launch
- The new entity types (MTOs, remittance agents, mobile money operators) sit in transaction categories with established typologies; confirm existing rules cover correspondent-style flows where the merchant is an intermediary and the entity is the beneficiary institution
- Alert volume may spike post-launch as the system encounters the new `on_behalf_of` field in previously unseen merchant flows; plan for a calibration period and brief the triage team accordingly

---

## For Risk

**What's changing for you**
Checkout OBO enables merchants to act as aggregators or marketplace operators — creating checkout sessions on behalf of entities that are the ultimate receivers of funds. This structurally resembles payment facilitation (PayFac) patterns: Tazapay processes payments for merchants, who in turn process payments for their own sub-entities. The entity approval gate (configurable per merchant account) is the primary control over which entities can receive funds via this flow. By default, the approval gate is OFF, meaning entities can receive funds before compliance review unless explicitly enforced.

**Actions / decisions needed**
- Assess whether the default-OFF approval gate creates an acceptable risk posture for launch, or whether it should be ON by default for high-risk merchant categories (remittance aggregators, marketplace platforms)
- Confirm that fraud and chargeback controls operate at the entity level where relevant — if a single bad entity under a good merchant account drives chargebacks, confirm the detection and blocking logic addresses this
- Review the refund linkage design: refunds on OBO payins maintain the `on_behalf_of` reference — confirm this doesn't create reconciliation or exposure blind spots in your chargeback tracking
- Sign off on the escalation path when an entity's approval_status changes (e.g., approved → rejected) while live checkouts are in flight

**Risk scenarios and mitigations**
- **Scenario 1 — Entity fraud under a legitimate merchant**: A compliant marketplace merchant onboards a fraudulent seller entity. If the approval gate is OFF, the entity immediately creates checkout sessions before any review. Mitigation: flag high-risk merchant types for mandatory approval gate ON at account configuration; alert on anomalous entity-level velocity
- **Scenario 2 — Chargeback concentration in a single entity**: A marketplace has one seller generating disproportionate chargebacks while aggregate merchant-level metrics look healthy. Mitigation: confirm chargeback monitoring operates at entity level (using `on_behalf_of` field) and that thresholds trigger entity-level blocks independent of merchant-level status
**Counter-party and operational risk**
- No new payment rails or PSP counter-parties are introduced by this feature — Checkout OBO is a metadata layer on existing checkout and payin infrastructure, so counter-party settlement risk profile is unchanged
- The `Mandatory OBO information for checkout` config (default OFF) allows merchants to require OBO on all checkouts; if this is enabled for a merchant and the entity service is unavailable, 100% of that merchant's checkouts will fail — flag this as a dependency risk for any merchant with this config toggled ON

**Risk tooling — open questions to resolve before launch**
- **Forter**: confirm the data structure sent to Forter for OBO checkout sessions is correct — the new `on_behalf_of` and `entity_details` fields may need to be included in the Forter risk event payload; confirm this is mapped before launch
- **PSP redirect URLs**: open question — do PSPs share redirect URLs for all OBO checkout cases? Confirm this is in place, and verify whether a URL mismatch (PSP redirect URL differing from configured URLs) surfaces in the Risk section of the ops dashboard
- **Risk SDK ownership**: open question — is the Forter SDK integration for entities merchant-managed or Tazapay-managed? If merchants are responsible, define the briefing and support path before go-live
- **Entity-level reserves**: open question — is there a config for ops and risk teams to set reserve values at the entity level? Given the PayFac-style structure OBO introduces, entity-level reserve controls may be needed; if this config does not exist, flag as a gap to resolve pre-launch

---

## For Payment Operations

**What's changing for you**
Checkout and payin transactions now carry an optional `on_behalf_of` entity reference. When a checkout with OBO is completed, the resulting payin automatically inherits the entity ID and entity details — no manual steps required. Payin webhooks now include a new `entity_details` block (entity ID, business name, email, reference ID). Refunds on OBO payins retain the `on_behalf_of` linkage. No new payment rails, schemes, or settlement windows are introduced — this is an additive metadata layer on existing flows.

**Actions / decisions needed**
- Update reconciliation scripts and reports to handle the new entity fields in the payin object — specifically the `on_behalf_of` entity ID and `entity_details` block; these are now present in API responses and webhook payloads
- Confirm that exception handling and manual intervention queues can display entity information — if a payin fails or is flagged for review, ops agents need to see which entity is the intended receiver
- Map the new error code `entity_not_approved` (returned when the entity approval config is ON but the entity hasn't been approved) to your internal SOP and ensure the triage path is documented
- Validate in staging that CSV exports from both the Merchant and Ops dashboards include the new entity fields (Receiver Name, Entity ID, Receiver Country, Receiver Email, Receiver Reference ID, Entity Status) and that your reconciliation tooling can ingest them
- Confirm the ops dashboard Checkout and Payin listing screens have been updated with the new "Receiver Details" column and OBO filter before go-live — these are the primary visibility tools for identifying OBO transactions in the queue

**Operational runbooks and exception handling**
- **Deleted entity mid-checkout**: If an entity is deleted while a checkout session is active, the session continues and completes normally; the entity shows as "(Deleted)" in dashboards. Ops agents should not block or cancel sessions solely because of entity deletion status — document this expected state in the runbook
- **Entity approval revocation**: If an entity's approval_status changes from approved to rejected while live sessions are in flight, existing sessions are not cancelled — but new checkouts for that entity will be blocked if the approval config is ON. Ops needs a clear escalation path for merchants who report this scenario
- **Refund handling**: Refunds on OBO payins maintain the `on_behalf_of` linkage — confirm that your refund processing tools display the entity reference and that reconciliation treats OBO refunds consistently with OBO payins in reporting
- **OBO filter in ops dashboard**: The new filter (All / Yes / No) on checkout and payin listings is the primary tool for isolating OBO transactions in the queue; confirm this filter is functioning in staging before launch

**Monitoring, dashboards, and SLA impact**
- The new "Receiver Details" column on ops checkout and payin listing screens, plus the OBO filter, are the main visibility additions; confirm these are live and tested before launch rather than relying on report exports
- Entity listing screen now splits submitted entities into "Review Required" and "Review Not Required" — this change affects how Compliance ops triages the entity approval queue; confirm ops and compliance teams are briefed on the new layout
- Settlement SLAs are not impacted — OBO is a metadata attribution layer; settlement timing and reconciliation windows remain unchanged

**Liquidity and FX exposure planning**
- No new FX exposure is introduced at launch — all pricing and settlement remain in the merchant's existing invoice currency (USD in the PRD example, but the feature is currency-agnostic)
- The PRD does not provide volume estimates for OBO adoption — Treasury should establish a monitoring threshold (e.g., if OBO-attributed payins exceed a defined volume per merchant) to trigger a proactive liquidity review
- Open question for Treasury: if remittance platform merchants grow materially through OBO (MTO and remittance agent entities), assess whether banking arrangements with settlement banks need to be updated to accommodate higher throughput or new geographic entity attributions

---

## For Treasury

**What's changing for you**
Checkout OBO does not introduce new currencies, payment corridors, or changes to settlement timing. The feature is a metadata attribution layer — checkout sessions and payins are processed through existing rails, and the `on_behalf_of` field identifies which entity within a merchant account is the intended receiver. Settlement flows, prefunding arrangements, and banking structures are unchanged. However, if marketplace, aggregator, or remittance platform merchants begin using this feature at volume, aggregate payin throughput under those merchant accounts could grow materially.

**Actions / decisions needed**
- Review existing settlement account and prefunding limits for marketplace, aggregator, and remittance-type merchants — if OBO enables them to scale their checkout volumes significantly, current limits may need to be revisited
- Confirm that settlement reporting and reconciliation tooling correctly attributes OBO payins at the entity level (using the `on_behalf_of` field) — this is important for any treasury reporting that tracks fund flows by ultimate beneficiary
- Validate that the new entity fields in payin reports (Receiver Name, Entity ID, Receiver Country, Receiver Email) don't conflict with any existing treasury-side data models or reconciliation templates
- Review the refund linkage design — refunds on OBO payins retain the entity reference; confirm treasury reconciliation treats these correctly and that they don't create float discrepancies
- No new FX hedging arrangements are required at launch; flag this for reassessment once OBO volume materialises and entity geographies are known

**Settlement mechanics and prefunding**
- Settlement timing is unchanged — OBO transactions settle on the same windows as standard checkout/payin flows through existing rails
- Prefunding requirements are unchanged at launch — no new corridors, currencies, or settlement accounts are introduced by this feature
- Entity country is captured as a metadata field (not a settlement routing field) — settlement continues to route through the merchant's existing banking arrangements, not to the entity directly
- Monitor aggregate payin volume by merchant accounts that enable OBO — if marketplace or aggregator accounts scale rapidly, flag for prefunding limit review before exposure increases

**Liquidity and FX exposure planning**
- No new FX exposure is introduced at launch — all pricing and settlement remain in the merchant's existing invoice currency (USD in the PRD example, but the feature is currency-agnostic)
- The PRD does not provide volume estimates for OBO adoption — Treasury should establish a monitoring threshold (e.g., if OBO-attributed payins exceed a defined volume per merchant) to trigger a proactive liquidity review
- Open question for Treasury: if remittance platform merchants grow materially through OBO (MTO and remittance agent entities), assess whether banking arrangements with settlement banks need to be updated to accommodate higher throughput or new geographic entity attributions

---

## For Growth — Sales

**What's changing for you**
We can now tell marketplace operators, payment aggregators, and remittance platforms: "Your sellers, sub-merchants, and partner entities can receive payments directly through Tazapay checkout — without you needing to build a separate payments stack for each of them." A single API field (`on_behalf_of`) lets a merchant platform create checkout sessions attributed to any entity in their network — sellers, MTOs, wallet providers, billers — with full visibility and control on both sides.

**Actions / decisions needed**
- Update the sales one-pager and battle card to include Checkout OBO as a capability for marketplace and aggregator prospects; differentiate it from Collect OBO (which covers passive virtual account collections — a different use case)
- Prepare segment-specific pitches for at least three verticals: (1) marketplace/e-commerce platforms, (2) remittance and wallet topup services, (3) bill payment aggregators — the value prop is meaningfully different for each
- Brief the team on the two configurable controls prospects will ask about: entity approval gating and mandatory OBO enforcement — know when to position these as compliance guardrails vs. merchant flexibility
- Update demo environments to show the OBO flow end-to-end: checkout creation with entity, payin with entity attribution, and the "Receiver Details" section in the merchant dashboard
- Confirm which geographies and merchant segments are in-scope at launch and which are excluded — the PRD does not specify geography restrictions, but Licensing and Compliance sign-off may constrain initial availability for MTO and remittance entity types

**Positioning and competitive angle**
- **Target ICP**: Marketplace platforms (any geography), payment aggregators processing for multiple merchants, remittance and wallet topup services, bill payment aggregators — these are segments we previously couldn't fully serve if they needed sub-entity attribution on checkout
- **Core value prop**: One Tazapay account. One integration. Checkout sessions for an unlimited number of seller or partner entities — each with full attribution, dashboard visibility, and compliance controls
- **Competitive differentiation**: Full entity lifecycle management (create, approve, transact, track) in one platform; competitor comparison should be prepared by the team with current market intel
- **Known constraints to disclose**: Entity approval is configurable but not automatic — merchants need to integrate entity creation and manage approval workflows; this is not a zero-touch sub-merchant onboarding; geographies and entity types subject to compliance sign-off

**Pricing, terms, and special cases**
- The PRD does not specify new pricing tiers for Checkout OBO — confirm with Finance whether OBO transactions are priced identically to standard checkout sessions or whether a different rate applies
- No introductory offers or pilot pricing are referenced in the PRD — confirm with leadership whether any launch incentives exist before Sales includes them in conversations
- Remittance and MTO entity types may be subject to additional compliance review before a merchant can enable them — flag this to prospects in regulated markets so they can plan their timeline accordingly

---

## For Growth — Account Management

**What's changing for you**
Existing merchants who operate marketplaces, manage multiple seller accounts, run remittance aggregation services, or act as bill payment platforms now have a native Tazapay capability to match their business model. They can create checkout sessions attributed to specific entities (sellers, MTOs, wallet providers, billers) within their account — and get full visibility into who received each payment via updated dashboards and reports. Merchants who already use entity management for Collect OBO can now extend that to active checkout flows without a new integration.

**Actions / decisions needed**
- Identify existing accounts with marketplace, aggregator, or remittance platform business models — these are the highest-priority accounts for proactive outreach and enablement
- Prepare a short FAQ for inbound questions covering: how to create entities, what the approval workflow looks like, how to pass the `on_behalf_of` field, and what changes in their dashboard
- Confirm whether any existing accounts' contracts need updating to cover the new OBO checkout use case — flag for Legal review if the merchant agreement scope was previously limited to standard checkout only
- For strategic accounts likely to enable Checkout OBO at volume, consider scheduling an account review call before go-live to walk them through the feature and the integration steps
- Flag any accounts where this feature could surface tension — e.g., merchants who built their own entity attribution workarounds and may need to migrate to the native solution

**Customer impact and outreach strategy**
- **Affected segments**: Marketplace operators, payment aggregators, remittance platforms, bill payment aggregators with existing Tazapay accounts — any merchant who already uses entity management (Collect OBO) is a natural first target
- **Action required from clients**: Optional integration change — merchants who want to use Checkout OBO must pass the `on_behalf_of` field in their checkout API calls; merchants who don't want to use OBO are not impacted at all; no forced migration or breaking changes
- **Communication approach**: Proactive white-glove outreach for strategic accounts in the target segments; reactive email/in-app notification for the broader base; timing aligned with launch date
- **Accounts needing special handling**: Any merchant who may interpret this as a contractual scope change (e.g., payment aggregators who negotiated bespoke terms) — flag these for Legal and Account Management review before outreach

**Expansion and upsell opportunities**
- Checkout OBO is a strong expansion trigger for any marketplace merchant currently using Tazapay only for direct checkout — enabling OBO unlocks seller-level payment attribution, which is typically a key unlocker for platform growth
- For remittance and wallet topup accounts, OBO positions Tazapay as the infrastructure for their entire partner network — not just their own payments; explore whether account limits or volume commitments need to be revisited for accounts likely to scale
- NRR impact: if marketplace merchants onboard large seller networks through OBO, aggregate checkout volumes per account could grow materially — this is an upsell opportunity framed around enabling their network growth, not a feature upgrade

---

## For Partnerships

**What's changing for you**
Checkout OBO does not introduce new scheme network dependencies or new banking partner integrations — the feature operates on top of existing Tazapay checkout infrastructure. Distribution and technology partners who create checkout sessions programmatically on behalf of their merchant clients should be briefed on the new `on_behalf_of` field, as passing it will improve their clients' reporting and reconciliation. Referral partners serving marketplace, aggregator, or remittance platform merchants now have a materially stronger product story to bring to those segments.

**Actions / decisions needed**
- Review partner agreements for any distribution or technology partners who create checkout sessions programmatically — confirm whether the new `on_behalf_of` field is relevant to their integration and whether they need to be briefed
- Identify any partners who provide white-label or embedded checkout — the new `on_behalf_of_configuration.hosted_page_display` field (`entity | entity_plus_account`) controls what appears on the hosted checkout page; partners may want to configure this for their branded experience
- Brief referral partners serving marketplace, aggregator, or remittance platform merchants on the new capability before launch — this is a material addition to the product pitch for those segments
- Check whether any existing partnership agreements reference checkout session creation scope in a way that might need updating to accommodate the OBO structure
- No new partner enablement documentation is required unless a partner actively uses the checkout API — prioritise partners with high checkout API usage volume

**Risks / watch-outs**
- Distribution or technology partners who build on the Tazapay checkout API should receive an API changelog notification — the `on_behalf_of` field is additive and non-breaking, but partners who miss the update may not pass entity context and their clients will lose attribution visibility
- Open question: if a distribution partner is the "merchant" and their clients are the "entities" in an OBO flow, confirm whether the partner agreement covers this structure — flag for Legal and Partnerships review before any such partner goes live with OBO

---

## For Legal

**What's new**
Checkout OBO introduces a three-party payment structure: Tazapay processes payments for a merchant, who is acting on behalf of an entity that is the ultimate receiver of the funds. Entity types include sellers, money transfer operators, wallet providers, telecom companies, and utility billers. Entity data collected includes business name, email address, country, entity type, and a merchant-assigned reference ID — this data is stored, displayed in dashboards, and included in CSV transaction reports.

**What's in it for you**
Existing merchant agreements may not contemplate the merchant acting as a payment aggregator or facilitator for third-party entities; this is a material scope extension that likely requires a ToS review and potentially a new merchant agreement clause. The new entity data fields (business name, email, country) may constitute a new processing activity under applicable data protection frameworks (GDPR, PDPA, etc.), and the entity deletion design — where historical data is retained but the entity shows as "(Deleted)" — raises a potential tension with data erasure rights that needs legal sign-off before launch.

**Inputs required before go-live**
- Review whether existing merchant agreements cover the OBO structure — specifically whether merchants are authorised under the ToS to create checkout sessions that attribute funds to third-party entities; if not, an amendment or addendum is required
- Assess whether the new entity data fields constitute a new processing activity under applicable data protection frameworks and whether existing DPAs cover this
- Confirm whether operating as a payment facilitator for sub-entities (via OBO) triggers any additional regulatory obligations, particularly in jurisdictions with explicit payment facilitation licensing requirements
- Review the entity deletion design: historical data is retained, entity shows as "(Deleted)" — confirm this meets data retention obligations and doesn't conflict with GDPR right to erasure
- Confirm that liability allocation is clearly defined in merchant-facing documentation in the event of an entity-level dispute or fraud

**Contract and liability review**
- Existing merchant agreements may not contemplate the merchant acting as a payment aggregator or facilitator for third-party entities through Tazapay's checkout; this is a material scope extension that warrants a ToS review and potentially a new merchant agreement clause
- The hosted page can be configured to display either the entity alone or both the entity and the merchant account (`entity | entity_plus_account`) — confirm whether this display configuration has any consumer disclosure implications under applicable consumer protection rules
- Refunds on OBO payins retain the `on_behalf_of` entity reference — confirm that the refund policy and merchant agreement clearly allocate responsibility between Tazapay, the merchant, and the entity for refund obligations

**Regulatory perimeter and compliance obligations**
- The MTO, remittance agent, and mobile money operator entity types are in regulated activity categories in most jurisdictions — confirm that Tazapay's processing of payments attributed to these entity types is within existing licence permissions, or flag for Licensing review
- Cross-border OBO flows may trigger travel rule obligations or correspondent banking reporting requirements — confirm with Compliance whether current entity metadata (business name, email, country) is sufficient for these obligations
- Confirm that `entity_details` in webhook payloads do not introduce new cross-border data transfer obligations (e.g., GDPR or local data localisation requirements) when entity data is sent to merchant webhook endpoints

---

## For Finance

**What's changing for you**
Checkout OBO adds an entity attribution layer to checkout and payin transactions — the `on_behalf_of` field identifies which entity within a merchant account is the ultimate receiver of funds. This is additive to existing checkout revenue flows; no new fee types or pricing structures are introduced in the PRD. Transaction reports for both merchants and ops now include new entity fields (Receiver Name, Entity ID, Receiver Country, Receiver Email, Receiver Reference ID, Entity Status), and CSV exports will carry this data. Refunds on OBO payins retain the entity reference for proper accounting attribution.

**Actions / decisions needed**
- Confirm revenue recognition treatment for OBO transactions — if the merchant is the principal and the entity is the beneficiary within the merchant's account, confirm whether this changes how revenue is recognised (merchant-level vs. entity-level attribution)
- Review GL mapping requirements for the new entity fields in payin and checkout reports — confirm whether entity-level transaction data needs to map to a new cost centre, sub-ledger, or reporting dimension
- Assess whether the refund linkage design (OBO payins retain entity reference in refunds) introduces any new accounting entries or timing differences compared to standard refunds
- Update financial reporting templates to accommodate the new entity fields in checkout and payin CSV exports — these fields will appear in all report exports as of launch
- Confirm with Tax whether the OBO structure (merchant acting as aggregator/facilitator for entity-level payins) creates any new tax obligations — particularly for MTO and remittance entity types in cross-border contexts

**Revenue model and financial impact**
- Revenue model is unchanged — Checkout OBO does not introduce a new fee tier; transactions processed via OBO flow generate revenue under the same checkout/payin pricing as standard transactions (confirm pricing with Sales and Product if a new tier is planned)
- The PRD does not specify volume or revenue estimates for OBO adoption — Finance should request volume assumptions from Product/Sales to model the accretion impact and update forecasts accordingly
- Cost drivers are unchanged — no new scheme fees, processing costs, or partner fees are introduced by OBO; all existing cost structures apply
- Margin impact is expected to be neutral at launch — this is a capability extension, not a cost-intensive infrastructure change; however, if OBO drives significant volume growth in remittance or MTO entity types, assess whether scheme cost structures for those corridors differ

**GL mapping, tax, and reporting**
- Open question: does entity-level attribution in payin reports require a new GL dimension or sub-account structure, particularly if entities are in different geographies or entity categories from the merchant? Confirm with the accounting team before launch
- Tax implication to assess: if the merchant is acting as a payment aggregator for entities in multiple jurisdictions, and Tazapay's fee is charged to the merchant (not the entity), confirm that the VAT/GST treatment of Tazapay's service fee is unchanged across all target geographies
- New entity fields in CSV exports will require reporting template updates — flag this to the financial reporting team to ensure close-cycle tooling is updated before OBO transactions appear in production data

---

## For Licensing

**What's new**
Checkout OBO enables merchants to process checkout sessions and payins on behalf of third-party entities — sellers, money transfer operators, remittance agents, wallet providers, mobile money operators, telecom companies, and utility billers. Tazapay's checkout infrastructure is now being used to receive funds on behalf of entities that are themselves regulated or quasi-regulated in many jurisdictions (MTOs, mobile money operators, telcos).

**What's in it for you**
The entity type taxonomy in the PRD includes activity categories (MTOs, mobile money operators, telcos) that carry their own licensing obligations in most markets — Tazapay's processing of payments attributed to these entity types requires confirmation that it falls within existing PI/EMI licence permissions as a payment facilitator. Depending on jurisdiction, this may also trigger material change notification obligations or require pre-launch regulatory approval before MTO and remittance entity types can be enabled for live merchants.

**Inputs required before go-live**
- Map each entity type (MTO, remittance agent, wallet provider, mobile money operator, telecom, utility biller) to your licence coverage across all active geographies — confirm that processing payments attributed to these entity types falls within existing permissions as a payment facilitator
- Assess whether any jurisdiction treats OBO-style payment facilitation for MTOs or remittance agents as a separate licensed activity requiring additional authorisation
- Confirm whether regulatory notification obligations are triggered by the new product activity — particularly in jurisdictions where material change filings or product approvals are required before launching new payment services
- Review whether the entity approval gating config (`Mandatory entity approval required for checkout creation`) is sufficient as an internal control, or whether regulator expectations require a more formal approval process for specific entity types

**Licence scope and coverage assessment**
- **Commerce entity types** (sellers, merchants, vendors): standard marketplace payment facilitation — likely within existing PI/EMI licence scope in most jurisdictions; confirm for each active geography
- **Remittance entity types** (MTOs, remittance agents, subagents): higher risk from a licensing perspective — processing payments attributed to a money transfer operator on behalf of a merchant could require money transmission authorisation in some US states, additional FCA permissions in the UK, or MAS approval in Singapore; map this carefully before enabling this entity type for live merchants
- **Financial services entity types** (wallet providers, mobile money operators, telcos): jurisdiction-specific — GCash (Philippines), M-Pesa (Kenya), and equivalents are regulated entities themselves; Tazapay processing checkout sessions attributed to them requires confirmation of no regulatory conflict
- **Utilities entity types** (utility companies, service providers, billers): generally lower risk from a licensing standpoint — bill payment facilitation is typically within payment institution scope; confirm for any jurisdiction with bespoke bill payment rules

**Regulatory notifications and reporting obligations**
- Open question: does the introduction of OBO checkout for MTO and remittance agent entity types constitute a material change to Tazapay's payment services in any jurisdiction that requires advance regulatory notification? This should be assessed before enabling these entity types for live merchants
- Confirm whether any transaction reporting thresholds (e.g., cross-border payment reporting, large value transfer reporting) are triggered differently when the payin is attributed to an entity rather than the merchant — the `on_behalf_of` field changes the funds attribution, which may affect how regulators classify the transaction
- Capital and safeguarding: if payin volumes increase materially due to OBO adoption by large marketplace or aggregator merchants, assess whether safeguarding calculations or capital adequacy thresholds change under applicable PI/EMI regulations

---

## For Product — Payments Pod

**What's changing for you**
Two new optional fields are added to the checkout and payin API objects. The first — `on_behalf_of` — accepts an entity ID and makes that entity the attributed receiver of the funds. The second — `on_behalf_of_configuration` (object with `hosted_page_display: entity | entity_plus_account`) — controls how the hosted checkout page presents the receiver context. When a checkout with `on_behalf_of` is completed, the payin inherits the entity ID automatically — no additional call required. Payin webhooks now include an `entity_details` block (entity_id, business_name, email, reference_id). Entity validation runs synchronously at checkout creation time.

**Relevance to your pod**
The checkout creation service now performs an entity lookup and validation step: confirm the entity exists, belongs to the merchant, and (if the approval config is ON) has `approval_status = approved`. This lookup is in the critical path for checkout creation — any latency or availability issue in the entity service will directly impact checkout creation SLA. Downstream, the payin service must reliably propagate the `on_behalf_of` value from the completed checkout to the payin object and all associated webhooks.

**Actions / decisions needed**
- Validate entity lookup latency and error handling in staging — specifically: what happens if the entity service times out or returns an error during checkout creation? Confirm the failure mode is a clean rejection, not a hung request
- Test all validation error paths: invalid entity ID, entity not belonging to merchant, entity not approved (config ON), `on_behalf_of` missing when mandatory config is ON — confirm error responses match the PRD spec exactly
- Confirm that payin inheritance of `on_behalf_of` is reliable across all checkout completion states — including edge cases like checkout timeout, payment retries, and partial completions
- Validate webhook payloads in staging for both `checkout.session_completed` and all payin events — confirm `entity_details` block is present and correct when `on_behalf_of` is set, and absent (not null, absent) when it's not
- Define the bug-watch period owner for the entity validation path and payin inheritance logic post-launch

**Infrastructure and dependency mapping**
- **Checkout service**: Modified to accept and validate `on_behalf_of` and `on_behalf_of_configuration`; synchronous entity lookup added to the checkout creation critical path
- **Payin service**: Modified to inherit `on_behalf_of` from completed checkout; entity details must be resolved and stored at payin creation time
- **Webhook service**: Updated to include `entity_details` block in all checkout and payin webhook payloads when `on_behalf_of` is populated
- **Entity service dependency**: Checkout creation now has a hard dependency on the entity service at request time — confirm entity service SLA, availability, and circuit-breaker behaviour are defined before launch

**Rollback strategy and monitoring**
- Rollback plan: `on_behalf_of` is an optional field — if issues arise, the safest rollback is to block the field at the API gateway level; existing OBO checkout sessions would continue to process but no new OBO sessions could be created; no data loss risk
- Monitor: checkout creation error rate segmented by OBO vs. non-OBO requests; entity validation failure rate; payin `on_behalf_of` inheritance success rate; webhook delivery rate for payloads containing `entity_details`
- Flag any checkout creation latency increase post-launch — the entity lookup adds a round-trip that didn't exist before; establish a baseline and set alerting thresholds before go-live

---

## For Product — Operations Pod

**What's changing for you**
The Ops Dashboard receives significant surface-area updates. Checkout and Payin listing screens get a new "Receiver Details" column (Entity ID, Business Name, Email) and an OBO filter (All / Yes / No). Checkout and Payin summary screens get a new "Receiver Details" section including entity country, approval status, and a link to the entity review screen. The entity listing screen under the submitted tab is split into "Review Required" and "Review Not Required" sub-categories. Two new merchant account configs are added under the OBO section. Reports for checkout and payin gain nine new entity fields each. These are the primary surfaces your team owns.

**Relevance to your pod**
Your team needs to ship all of the above dashboard and reporting changes before launch — these are not nice-to-haves; they are the primary tooling that Compliance ops, Payment Ops, and Support will use to manage OBO transactions from day one. The entity listing split (Review Required / Not Required) directly affects how Compliance ops triages entity approval queues. The new OBO filter on checkout and payin listings is how Payment Ops will isolate and action OBO exceptions.

**Actions / decisions needed**
- Validate the entity listing "Review Required / Review Not Required" split in staging — confirm the categorisation logic correctly flags entities where approval is mandatory (for collect, payins, or payouts) as Review Required, and all others as Review Not Required
- Confirm the OBO filter on checkout and payin listings works correctly with the new `on_behalf_of` database field — test both Yes and No filter states, including edge cases where on_behalf_of is populated but entity is deleted
- Test the "Receiver Details" column in listing screens for deleted entities — confirm the entity shows as "(Deleted)" and that the clickable Entity ID link gracefully handles the deleted state
- Validate that the two new OBO configs on the merchant account config tab (`Mandatory entity approval required for checkout creation` and `Mandatory OBO information for checkout`) save and propagate correctly to API behaviour in staging
- Confirm all nine new entity fields appear correctly in ops-side checkout and payin CSV exports, and brief the Payment Ops team on the updated report format before launch

**Dashboard and visibility updates**
- **Checkout listing**: New "Receiver Details" column (Entity ID, Business Name, Email) + OBO filter — primary visibility tool for ops handling OBO checkout exceptions
- **Payin listing**: Same new column and filter — ensure the entity data is joined correctly from the payin's inherited `on_behalf_of` reference
- **Summary screens (checkout + payin)**: New "Receiver Details" section including approval status badge and link to entity KYB review — confirm the link correctly routes to the entity review screen, not the entity listing
- **Entity listing**: The Review Required / Not Required split is a significant workflow change for Compliance ops — ensure the logic is clearly documented and the UI distinction is unambiguous

**Case management and tooling changes**
- The new error code `entity_not_approved` (returned when approval gate is ON and entity isn't approved) should be documented in the ops runbook — Compliance ops and Support teams will receive merchant escalations about this error; they need to know what it means and how to resolve it (approve the entity first)
- Deleted entity display: ops agents may query historical OBO transactions where the entity has since been deleted — confirm the tooling handles this state gracefully and agents are briefed on expected behaviour
- The config tab changes (new OBO section) should be walked through with Compliance ops and Payment Ops before launch — these configs have real-time production impact (blocking checkout creation) and should not be toggled without understanding the consequences

---

## For Product — Merchant Pod

**What's changing for you**
The Merchant Dashboard gains entity-level visibility on checkout and payin transactions. Checkout and Payin summary screens now include a "Receiver Details" section (Entity ID, Business Name, Email, Country, Approval Status). Transaction listing search is optimised to search by entity_id, business_name, reference_id, and email with partial match support. Checkout and Payin CSV reports gain six new entity columns each. The manual "Create Checkout" flow gets a new optional "On Behalf Of" entity selector (visible only when entity capability is enabled). Webhook payloads now include `entity_details` for OBO checkouts and payins — merchants integrating via webhooks need to be aware of the new payload structure.

**Relevance to your pod**
API documentation needs to be updated for three changes: (1) the new optional `on_behalf_of` field on the checkout creation endpoint, (2) the new optional `on_behalf_of_configuration` object with `hosted_page_display` enum, (3) the updated payin and webhook response schemas including `entity_details`. These are additive changes — no breaking changes to existing merchants — but the sandbox environment must reflect the new fields and the documentation must accurately describe the validation rules and error codes.

**Actions / decisions needed**
- Update the checkout API documentation to include `on_behalf_of` and `on_behalf_of_configuration` fields with full schema, validation rules, and error codes (`entity_not_approved`, `on_behalf_of field is required for this merchant account`)
- Update the payin API documentation to reflect `on_behalf_of` inheritance from checkout and the new `entity_details` block in the response
- Update webhook documentation for both checkout and payin events to show the updated payload schema including `entity_details` — provide a clear before/after example for merchants who consume webhooks
- Confirm the merchant dashboard entity selector in the manual "Create Checkout" flow only appears when entity capability is enabled for the account — test the conditional display logic in staging
- Add the new "Receiver Details" section to the merchant-facing checkout and payin summary screens and validate in staging that entity data displays correctly for approved, pending, rejected, and deleted entity states

**Merchant API and integration experience**
- **All changes are additive**: `on_behalf_of` and `on_behalf_of_configuration` are optional fields; merchants who don't use them see no change in API behaviour or response structure; no migration guide required
- **New webhook payload structure**: Merchants consuming checkout or payin webhooks will now receive an `entity_details` block when `on_behalf_of` is set — this is additive but merchants with strict payload parsing (e.g., schema validation on webhook receipt) should be warned to handle new fields gracefully
- **Error codes to document**: `entity_not_approved` (HTTP 4xx) when entity approval config is ON and entity is not approved; `on_behalf_of field is required` (HTTP 4xx) when mandatory OBO config is ON and field is missing; both need to appear in the API reference with remediation guidance
- **Sandbox environment**: Confirm the sandbox reflects the new `on_behalf_of` field, validation logic, and error responses before launch — merchants will test against sandbox before going live

**Merchant dashboard and feedback mechanisms**
- The "Receiver Details" section on summary screens and the entity search optimisation on transaction listings are the primary UX changes merchants will notice — confirm these are live and tested in staging before launch
- The manual "Create Checkout" entity selector is a new UI element — validate the search (by entity_id, business_name, reference_id) and the approval filter logic (only showing approved entities when the config is ON) work correctly in staging
- Post-launch feedback: monitor merchant support tickets for API integration issues (particularly webhook parsing errors on the new `entity_details` block) and for dashboard questions about the new Receiver Details section — set up a brief check-in with the top 10 OBO-likely merchants post-launch

---

## For Product — Data

**What's changing for you**
Checkout OBO introduces a new entity dimension to the checkout and payin data model. The `on_behalf_of` field (entity ID) is now a first-class attribute of checkout and payin objects, stored and returned in API responses, webhook payloads, and CSV reports. Webhook payloads gain a new `entity_details` nested object (entity_id, business_name, email, reference_id). Checkout and Payin CSV exports gain six new columns each (Receiver Name, Entity ID, Receiver Country, Receiver Email, Receiver Reference ID, Entity Status). The entity listing now categorises submitted entities into "Review Required" and "Review Not Required" — a new status dimension for the entity data model.

**Relevance to your pod**
The `on_behalf_of` entity ID becomes a new join key in the transaction data model — any pipeline that processes payin or checkout events needs to be updated to carry this field through. The `entity_details` block in webhooks introduces a new nested object structure that may require schema changes in your event ingestion layer. The new report columns (entity fields in checkout/payin exports) affect data exports that downstream BI tools or analytics pipelines may consume. Success metrics for Checkout OBO adoption need to be defined and instrumented before launch.

**Actions / decisions needed**
- Update the checkout and payin event schemas in the data pipeline to include `on_behalf_of` (string, nullable) and `entity_details` (object, nullable) — confirm these fields are correctly captured from webhook events and API polling
- Instrument the OBO adoption funnel: track what % of checkout sessions are created with `on_behalf_of`, what % of those complete successfully, and what % result in a payin with entity attribution — these are the core adoption metrics
- Confirm that the new entity fields in CSV exports (six columns per report type) don't break any existing ETL pipelines that process merchant or ops report exports — test with the updated export format in staging
- Update any existing checkout or payin dashboards to surface the `on_behalf_of` dimension — at minimum, enable filtering by OBO vs. non-OBO transaction type
- Define and confirm the success metrics for Checkout OBO at launch: adoption rate (% of eligible merchants who pass `on_behalf_of`), entity approval rate, OBO checkout completion rate — confirm ownership and reporting cadence

**Events, schema, and instrumentation**
- **New field**: `on_behalf_of` (entity ID, string, nullable) on checkout and payin objects — add to checkout and payin tables/entities in the data warehouse
- **New nested object**: `entity_details` (entity_id, business_name, email, reference_id) in checkout and payin webhook payloads — this is a nested object; confirm the ingestion layer handles nested structures correctly and doesn't flatten in a way that loses data
- **New entity dimension**: entity approval status, entity type, entity country, entity email — these are now available as attributes on OBO transactions; add as dimensions in the transaction data model
- **Report schema change**: Six new columns in checkout and payin CSV exports — update any downstream pipeline that consumes these exports to handle the expanded schema without breaking

**Analytics, BI dashboards, and success metrics**
- **Launch-day dashboard**: At minimum, a view showing OBO vs. non-OBO checkout volume split, entity-level transaction counts, and entity approval rate by merchant — this is the primary metric for assessing OBO adoption post-launch
- **Success metric ownership**: OBO checkout creation rate (Product), entity approval rate (Compliance Onboarding), OBO payin completion rate (Payment Operations), entity-level transaction volume (Finance/Treasury) — confirm each team has visibility into their metric before go-live
- **Downstream impact**: Any ML feature that uses checkout or payin data (e.g., fraud models, chargeback prediction) should be reviewed to confirm the new `on_behalf_of` dimension doesn't introduce data leakage or model drift — flag for assessment if any model trains on checkout-level features without entity-level segmentation

---

## For Engineering

**What's changing for you**
Checkout OBO extends the checkout and payin API with two new optional fields: `on_behalf_of` (entity ID string) and `on_behalf_of_configuration` (object controlling hosted page display). The checkout creation flow gains a synchronous entity validation step. Payin objects inherit `on_behalf_of` from completed checkout sessions. Webhook payloads for checkout and payin events are extended with an `entity_details` nested object. The Ops Dashboard gains new columns, filters, and a config section. The Merchant Dashboard gains new summary sections, a search optimisation, and an OBO entity selector in the manual checkout flow. These are all additive changes — no existing fields are removed or renamed.

**Relevance to your team**
The entity lookup added to the checkout creation critical path is the highest-risk change from a reliability standpoint. It introduces a new synchronous dependency (entity service) on a latency-sensitive flow. If the entity service degrades, OBO checkout creation fails; non-OBO checkout creation must not be affected. The deployment covers at minimum: the checkout service, payin service, webhook service, ops dashboard backend, ops dashboard frontend, merchant dashboard frontend. Confirm all six surfaces are deployed and validated together, or define a safe partial rollout order.

**Actions / decisions needed**
- Confirm the feature flag or rollout strategy — is OBO enabled globally at launch, or is it merchant-by-merchant? The entity validation config (approval gate) is per merchant account, but the API field itself needs a clear availability decision
- Validate the entity service circuit-breaker and timeout behaviour: if the entity lookup times out, does checkout creation return a clean error or a hung response? Confirm the SLA for entity service availability and the fallback behaviour before launch
- Ensure observability is in place for the new entity validation path: track entity lookup latency, entity validation failure rate, and `entity_not_approved` error rate as distinct metrics from general checkout creation errors
- Define the bug-watch period (recommended: 48–72 hours post-deploy), assign an on-call owner for OBO-specific issues, and confirm the escalation path to the entity service team if validation failures spike
- Confirm rollback plan: since `on_behalf_of` is optional and additive, the cleanest rollback is blocking the field at API gateway level — validate this mechanism before launch and confirm it can be executed without a full redeploy

**Scope, dependencies, and risk surface**
- **In scope**: Checkout service (new field validation + entity lookup), Payin service (entity inheritance), Webhook service (entity_details payload), Ops Dashboard (listing columns, filters, summary sections, entity listing split, config tab, reports), Merchant Dashboard (summary sections, search optimisation, manual checkout entity selector, reports)
- **Out of scope**: No changes to payment rails, settlement logic, scheme connectivity, or PSP integrations — all infra-level risk is limited to the entity service dependency
- **Entity service dependency**: New hard dependency in the checkout creation critical path — confirm entity service is production-ready, has been load tested, and has defined SLA commitments; this is the single highest engineering risk at launch
- **Security consideration**: Validate that entity ownership check (entity must belong to the requesting merchant) is enforced server-side, not client-side — a bypass here would allow merchants to create checkouts attributed to entities they don't own

**Deployment, monitoring, and rollback plan**
- **Deployment strategy**: All changes are additive — recommend deploying behind a feature flag that can be toggled per merchant account, with internal test accounts enabled first; this allows validation at production scale before broad availability
- **Rollback**: Block `on_behalf_of` field at API gateway if entity validation issues arise; dashboard changes can be rolled back independently via frontend deployment; webhook payload changes are additive and don't break existing consumers
- **Monitoring at launch**: (1) checkout creation success rate segmented by OBO vs. non-OBO, (2) entity validation latency P50/P95, (3) `entity_not_approved` error rate, (4) payin `on_behalf_of` inheritance success rate, (5) webhook delivery rate for payloads with `entity_details`; set alerts on all five before go-live
- **Bug-watch period**: 48–72 hours post-deploy; on-call owner to be defined; escalation path to entity service team and Payments Pod to be confirmed in the incident runbook before launch

---

## How to Use These Notes

1. Each team reads their section only
2. Actions/decisions — pre-launch checklist, flag any blockers
3. Risks/watch-outs — escalate before go-live, not after
4. Run a sync — let teams confirm actions and assign owners

*Generated by Launch Notes System — github.com/ritikgargtaza/Product-launch-notes*
