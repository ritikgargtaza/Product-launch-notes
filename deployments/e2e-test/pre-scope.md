# Pre-Scope Alignment Note

**Idea:** Checkout — On Behalf Of (OBO)
**Date:** April 29, 2026
**Stage:** Pre-scope — based on idea only, not a full PRD
**Teams covered:** Compliance (Onboarding), Compliance (TM), Risk, Legal, Licensing, Finance, Sales, Partnerships

> This note is generated from an early idea, not a scoped PRD. Use it to surface questions and blockers before committing to full scoping. Once a PRD exists, run `/project:launch-notes` for the full 16-team launch note.

---

## Compliance — Onboarding

**What we know so far**
The idea introduces a new entity layer — merchants can attribute checkout sessions to downstream entities (sellers, remittance agents, wallet providers, telcos, utilities). These entities are already registered in Tazapay, but it's unclear what onboarding and verification was applied to them at registration. The idea mentions an optional approval workflow before an entity can receive funds, but the rules governing that approval are not defined yet.

**Questions to answer before scoping**
- What KYC/KYB is currently applied when a merchant creates an entity — is there any verification, or is it self-declared?
- Should different entity types (marketplace seller vs. remittance agent vs. wallet provider) have different CDD/EDD requirements?
- Who is responsible for sanctions screening and PEP checks on entities — Tazapay, the merchant, or both?
- Does the approval workflow (entity must be approved before receiving funds) satisfy our AML obligations, or does it need to be mandatory rather than config-driven?
- Do we need to update the onboarding policy to formally cover sub-entity acceptance under a merchant account?

**Early flags**
- Remittance agents and money transfer operators are high-risk entity types under most AML frameworks — if these can receive funds without enhanced verification, this is a potential compliance blocker
- The approval workflow being optional (config-driven) may not be sufficient from a risk-based approach perspective — Compliance Onboarding needs to sign off on the default-off position before this is scoped

---

## Compliance — Transaction Monitoring

**What we know so far**
Checkout OBO adds a new dimension to every payin — funds can now be attributed to a downstream entity, not just the merchant. This means the transaction monitoring system needs to understand who the "ultimate receiver" is, not just the initiating merchant account. The idea covers remittance platforms and wallet/topup services, which are typologies that typically require specific AML rule coverage.

**Questions to answer before scoping**
- Will the `on_behalf_of` entity data be fed into the transaction monitoring system, or will monitoring only see the merchant-level transaction?
- Do existing AML rules cover the new transaction typologies this enables — specifically remittance agent payments and wallet topups on behalf of telcos?
- Will velocity and threshold rules need to be recalibrated now that a single merchant account could represent hundreds of downstream entities?
- Does attributing a payin to an entity change any SAR/STR filing triggers or the way we identify the subject of a report?
- Are there new data fields from this feature (entity type, entity country, entity approval status) that should feed into alert logic?

**Early flags**
- If monitoring rules don't cover the remittance and wallet topup typologies at launch, there is a genuine SAR/STR gap — this needs to be scoped as a requirement, not a post-launch task
- The idea doesn't mention whether entity-level transaction history will be queryable — TM needs this for typology analysis

---

## Risk

**What we know so far**
The idea introduces a new layer of exposure — merchants can process funds on behalf of entities whose risk profile may not be fully verified. The optional approval config means merchants could, by default, create checkouts for unapproved or unverified entities. The idea also mentions refund handling as an open question, which has direct implications for chargeback and dispute risk.

**Questions to answer before scoping**
- What is the fraud exposure if a merchant processes funds on behalf of an entity that is later found to be fraudulent or non-existent?
- Should entity approval be mandatory by default, or can the default-off position be justified within our risk appetite?
- How will refunds and chargebacks be handled when the payin has an `on_behalf_of` entity — who bears the liability?
- Are there exposure limits we need to define per entity, per merchant, or per entity type?
- What fraud signals exist at the entity level, and do our current fraud models account for marketplace and remittance platform patterns?

**Early flags**
- Default-off for entity approval means funds could flow to unverified entities from day one — Risk needs to formally sign off on this before scoping confirms it as the default
- Refund handling for OBO payins is listed as an open question in the idea — this needs to be resolved before scoping, as it affects chargeback liability

---

## Legal

**What we know so far**
The idea changes the legal structure of a checkout transaction — Tazapay would be facilitating payment acceptance on behalf of a merchant's entities, creating a tripartite relationship (Tazapay, merchant, entity). It's unclear whether existing merchant agreements cover this structure or whether new terms are needed. The inclusion of remittance agents and money transfer operators as entity types raises regulatory perimeter questions.

**Questions to answer before scoping**
- Do current merchant agreements cover the OBO flow, specifically the clause that funds settle to the merchant account even when attributed to an entity?
- Does the "ultimate receiver of funds" framing create any disclosure obligations to end customers (payers) under consumer protection or payment transparency regulations?
- Does Tazapay's facilitation role for remittance agent or MTO entity types create any secondary legal or regulatory obligations?
- Are there data protection implications for storing and transmitting entity data (business name, email, country) on behalf of merchants?
- Does the hosted checkout page displaying entity information require any new legal disclosures to the payer?

**Early flags**
- If the product is launched with MTO and remittance agent entity types, Legal needs to confirm this is within existing contractual and regulatory scope before engineering starts
- The open question on hosted checkout page display (entity only vs. entity + merchant) may have consumer disclosure implications — Legal should be in the room when this is decided

---

## Licensing

**What we know so far**
The idea explicitly enables remittance platforms, wallet/topup services, and bill payment aggregators to use OBO checkout. These use cases involve entity types — Money Transfer Operators, wallet providers, telecom companies — that are directly regulated in most of Tazapay's target markets. The idea does not specify which geographies are in scope, which makes it difficult to assess licence coverage at this stage.

**Questions to answer before scoping**
- Which geographies are in scope for this feature at launch, and does our current licence in each jurisdiction cover facilitating checkout on behalf of MTOs, remittance agents, and wallet providers?
- Does Tazapay's role as infrastructure provider for these flows constitute a regulated activity in any target market that we are not currently licensed for?
- Are there any regulator notification or prior approval obligations triggered by introducing a new product type or entity category?
- Do any licence conditions restrict the entity types or business models we can support under OBO?
- Does enabling cross-border remittance flows via OBO checkout affect our regulatory capital requirements in any jurisdiction?

**Early flags**
- MTO and remittance agent entity types are regulated categories in SG, IN, EU, and most other markets — Licensing must confirm coverage before these use cases are included in the scope
- If any target geography requires a new licence or prior approval, this could set the launch timeline back significantly — this needs to be known before engineering commits to a delivery date

---

## Finance

**What we know so far**
The idea is primarily an attribution change — funds still settle to the merchant account, not the entity. This means the core settlement and revenue model does not change at first glance. However, the idea introduces entity-level reporting fields and mentions configs that could affect transaction flows, and it's unclear whether OBO transactions will carry different pricing.

**Questions to answer before scoping**
- Will OBO checkout transactions be priced differently from standard checkouts, or will they use the same fee structure?
- Does attributing payins to entities create any new revenue recognition complexity — for example, if entity-level reporting is required for accounting purposes?
- Are there float or liquidity implications if the feature drives significant volume increases for remittance or wallet topup use cases?
- Will entity-level transaction data in reports require new GL mappings or cost centre tracking?
- Are there tax implications for cross-border flows where the entity is in a different jurisdiction to the merchant?

**Early flags**
- The idea does not mention pricing for OBO — if this goes to scoping without a pricing decision, Finance cannot model the revenue impact
- If the feature is adopted by large remittance platforms, corridor-level volume increases could have material treasury and float implications — Finance should be flagged early so liquidity planning can begin

---

## Growth — Sales

**What we know so far**
Checkout OBO directly unlocks three high-value segments that Sales has likely encountered as gaps: marketplace platforms (multi-seller checkout), remittance and MTO networks, and wallet/topup platforms. The feature is additive and backward-compatible, which means existing merchants are not disrupted. The open question on entity types and approval workflows will affect how confidently Sales can position this.

**Questions to answer before scoping**
- Which merchant segments and geographies will be available at launch — can Sales start pipeline conversations now, or is the scope still too open?
- Will OBO checkout be priced as a premium feature or included in existing plans?
- Are there known prospects or existing merchants in the pipeline who have specifically asked for this capability?
- What are the known limitations at launch that Sales needs to disclose — entity type restrictions, geography limits, approval requirements?
- How does this compare to what competitors offer for marketplace and platform payment use cases?

**Early flags**
- Sales should not be briefed or allowed to sell this until Licensing confirms which entity types and geographies are in scope — overpromising on remittance or MTO use cases could create commercial and compliance risk
- The approval workflow being optional could be a selling point (flexibility) or a concern (risk of fraud) depending on the customer — Sales needs clear guidance on how to position this

---

## Partnerships

**What we know so far**
The idea enables wallet providers, telecom companies, mobile money operators, and remittance agents to be registered as entities and receive fund attribution via OBO checkout. Some of these entity types may already be Tazapay partners or prospective partners — meaning this feature could have direct commercial implications for existing partnership agreements or open new co-sell opportunities.

**Questions to answer before scoping**
- Are any of the entity types in the idea (wallet providers, telcos, MTOs) currently Tazapay partners, and if so, do their agreements need to be updated to reflect this new capability?
- Does this feature create a distribution or co-sell opportunity with any existing or prospective partners?
- Are there scheme or network rules (Visa, Mastercard, local payment schemes) that apply to processing checkout on behalf of MTO or wallet provider entities?
- Do any existing banking partner agreements restrict the entity types or business models we can support?
- What partner enablement or communication is needed if we launch this with partners as potential entity types?

**Early flags**
- If banking partners have restrictions on funds attributed to MTOs or remittance agents, this is a hard dependency that needs to be confirmed before scoping — it could affect which entity types are viable at launch
- Any partner who could benefit from being an OBO entity should be identified now so Partnerships can manage expectations and timing around the launch

---

*Pre-scope complete. Share this with the 8 teams to gather input before full scoping. Once your PRD is ready, save it as `PRD.md` in this folder and run `/project:launch-notes`.*
