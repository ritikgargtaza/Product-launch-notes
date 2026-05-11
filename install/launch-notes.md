Generate pre-launch sync notes from a full PRD — only for the teams listed in the PRD.

## Step 1 — Read the PRD

Read the file `PRD.md` in the current working directory. Extract:
- What the feature is and what problem it solves
- Who it affects (customer segments, geographies, entity types — use exact language from the PRD, do not expand)
- What changes technically and operationally
- Timeline, volumes, rollout plan
- Known risks, constraints, open questions
- Whether Sardine is involved (yes/no)
- Whether Forter is involved (yes/no)
- New corridors, currencies, payment rails — exact list

**Extract the affected teams list:**
Look for a section titled `## Teams to Brief`. Extract the bullet list — only generate notes for teams listed there.

If `## Teams to Brief` is missing, generate notes for all 16 teams and add this warning at the top of the output:
> ⚠️ "Teams to Brief" not found in PRD — notes generated for all 16 teams. Add a "## Teams to Brief" section to your PRD to limit output to relevant teams only.

---

## Step 2 — Team Context (fully embedded — no external files needed)

Use the team guidance below for every note you write. Each team entry contains:
- Function, KPIs, and tone
- Key concerns and scoping rules (apply strictly — they prevent hallucination)
- Exact output structure to use for that team's note

---

### 1. Compliance — Onboarding

**Function:** Owns KYC/KYB workflows, identity verification, document collection, and onboarding decisioning. Sets risk-based acceptance criteria and ensures AML/sanctions screening is applied before a customer is activated.
**KPIs:** Onboarding approval rate, time-to-activate, SLA breach rate.
**Tone:** Regulatory and procedural. Precise about obligations. Flag anything requiring policy update or sign-off before go-live. Keep under 400 words.
**Key concerns:** Does this change who can be onboarded or what data is collected? New onboarding flows needing sign-off? Sanctions/PEP checks still applied correctly? If Sardine is involved: is data mapping complete and locked?

**Scoping rules:**
- Use the PRD's own language for entity types — do not expand a simple descriptor into a full taxonomy
- Do not add CDD/EDD review actions unless the PRD explicitly introduces new entity types or segments requiring new procedures — a new config or field alone does not warrant this
- Do not add travel rule risk bullets unless the PRD explicitly flags travel rule implications
- Do not add data retention or audit trail risks unless the PRD describes a deletion or archival behaviour that creates a compliance gap
- Do not list geographies unless the PRD explicitly names target markets for the new flow
- Keep to 2–3 actions and 1–2 risks

**Output structure:**

**What's new**
2–3 sentences. What is changing in plain language. Focus on what is new in the onboarding flow or identity-check logic.

**What's in it for you**
2–3 sentences. Map to their KPIs: approval rate, time-to-activate, false positive/negative rate on KYC checks, or SLA risk. If a step is removed or automated, say so specifically.

**Inputs required before go-live**
Bullet list (3–5 items max). Examples: update SOPs, review new rejection reason codes, test edge cases in staging, confirm limits with Risk, update customer-facing decline messaging.

**Additional context or dependencies**
2–3 bullets. Changes to partner integrations, regulatory notifications required, new entity types being supported, escalation paths, or out-of-scope items.

**Sardine check** — include only if PRD states Sardine is involved:
- Flag as action: confirm Sardine data mapping is complete and the correct data structure is being sent for any new flow or entity type
- Confirm in staging the new flow does not generate false positive rule alerts in Sardine — if mapping is not locked, block launch

---

### 2. Compliance — Transaction Monitoring

**Function:** Detects suspicious activity in live transaction flows. Owns rules engine, alert thresholds, SAR/STR filing obligations, and ongoing AML monitoring. Takes immediate action — disabling payment methods, holding payouts, restricting accounts.
**KPIs:** Fraud loss rate, chargeback rate, alert response time, exposure breaches.
**Tone:** Operational and direct. Focus on what changes in daily monitoring. Flag gaps in rule coverage and actions needed before launch. Keep under 400 words.
**Key concerns:** New transaction types, corridors, or merchants not covered by existing rules? Will velocity patterns look different? New data fields feeding into monitoring? Escalation path clear for new merchant type?

**Scoping rules:**
- Do not add AML typologies or SAR/STR obligations unless the PRD introduces a new transaction type with explicit filing implications
- Do not invent fraud pattern names — describe patterns only using language the PRD provides
- Do not add monitoring rule recommendations unless the PRD introduces a transaction type with no existing rule coverage

**Output structure:**

**What's changing**
2–3 sentences. What new transaction types, corridors, merchant categories, or volumes does this introduce? What monitoring gaps or new risk patterns should TM expect? Be specific — not generic.

**Actions / decisions needed**
Bullet list (3–5 items). Examples: review rule coverage for new transaction types, recalibrate velocity limits or exposure caps, confirm alert routing for new merchant categories, validate threshold logic in staging, brief the team on new fraud patterns or abuse vectors to watch.

**Risks / watch-outs**
2–3 bullets. What could go wrong if not addressed before launch? Examples: exposure build-up current caps won't catch, chargeback spikes in a new corridor, fraud patterns existing rules won't flag, escalation paths not set up for a new merchant type.

---

### 3. Risk

**Function:** Owns credit risk, fraud risk, and operational risk. Sets exposure limits, counter-party risk policies, and loss tolerance thresholds. Approves or blocks product decisions based on risk posture.
**KPIs:** Fraud loss rate, chargeback ratio, credit loss rate, net exposure.
**Tone:** Analytical and direct. Lead with exposure and mitigation. Quantify wherever the PRD allows. Keep under 400 words.
**Key concerns:** Fraud or credit exposure introduced? Existing controls sufficient? Counter-party or settlement risk changed? If Forter is involved: data structure correct? PSP redirect URLs confirmed? Reserve config exists at entity level?

**Scoping rules:**
- Do not add actions about reviewing entity type taxonomies unless the PRD introduces a new risk framework
- Do not pad risk scenarios — match the count to actual distinct risk vectors in the PRD; do not invent scenarios to reach a target number
- Do not include technical or infrastructure risks (e.g. service dependency failures, latency) — those belong in Engineering; this section covers financial exposure and fraud only

**Output structure:**

**What's new**
2–3 sentences. What is changing that affects risk exposure — new product features, new merchant types, new corridors, or changes to velocity/limit logic.

**What's in it for you**
2–3 sentences. How does this shift the risk profile — fraud surface area, expected chargeback volume, or credit exposure? If risk is reduced, say how. If a new vector is introduced, flag it clearly.

**Inputs required before go-live**
Bullet list (3–5 items max). Examples: approve updated exposure limits, sign off on fraud rule changes, review stress-test outputs, confirm fallback handling, update risk appetite documentation.

**Risk scenarios and mitigations**
List only the distinct risk vectors the PRD introduces. Do not add scenarios to reach a target count. For each: name the exposure, the control in place, and whether it is sufficient. Include velocity limits, fraud models, exposure caps, and monitoring thresholds only where the PRD indicates they are relevant.

**Counter-party and operational risk**
2–3 bullets. Flag changes to counter-party concentration, settlement timing, or operational resilience. Clarify whether existing monitoring and controls cover the new scope.

**Risk tool checks** — include only if PRD states these tools are involved:
- Forter: flag whether data structure sent to Forter needs updating; confirm correct before launch
- PSP redirect URLs: confirm PSPs share redirect URLs for all new flow variants; check whether URL mismatches are visible in the Risk section of the ops dashboard — flag as open question if unconfirmed
- Risk SDK ownership: confirm whether merchants or Tazapay manage the Forter SDK integration; if merchant-managed, define briefing and support process pre-launch
- Entity-level reserves: check whether config exists for ops/risk to set reserve values at entity level; if absent, flag as pre-launch gap

---

### 4. Payment Operations

**Function:** Manages day-to-day payment flows — settlement, reconciliation, exception handling, failed transaction management, dispute resolution, and SLAs.
**KPIs:** Settlement success rate, reconciliation breaks, manual intervention rate, SLA adherence.
**Tone:** Practical and operational. Focus on what changes in daily workflow. Flag manual processes, new exception types, SLA impacts. Keep under 400 words.
**Key concerns:** New payment rails, schemes, or settlement windows? How are failed transactions and exceptions handled? New runbooks or escalation paths needed? Manual steps ops needs to own?

**Scoping rules:**
- Do not invent specific failure codes or error messages — describe failure scenarios generically if the PRD doesn't name them
- When the PRD includes liquidity/FX commentary relevant to settlement volumes, include a "Liquidity and FX exposure planning" subsection after "Monitoring, dashboards, and SLA impact" — do not move this content to Treasury

**Output structure:**

**What's new**
2–3 sentences. What is changing in the payment flow — new rails, new failure codes, new retry logic, or new settlement windows?

**What's in it for you**
2–3 sentences. How does this affect daily ops? Will manual queues grow or shrink? Are there new failure codes to map? Does settlement timing change?

**Inputs required before go-live**
Bullet list (3–5 items max). Examples: update reconciliation scripts for new transaction types, map new failure/error codes to internal SOP, validate settlement reports in staging, brief escalation team on new edge cases, confirm monitoring dashboards are updated.

**Operational runbooks and exception handling**
3–4 bullets. How failed transactions will be handled, what new error codes or failure scenarios are possible, whether manual intervention is required. Include retry logic, fallback handling, and escalation paths for unresolved exceptions.

**Monitoring, dashboards, and SLA impact**
2–3 bullets. Dashboard updates or new visibility tools required, how the new flow will be monitored, whether settlement SLAs or reconciliation windows are affected.

*(If PRD includes liquidity/FX commentary relevant to settlement volumes, add:)*
**Liquidity and FX exposure planning**
2–3 bullets covering the relevant liquidity or FX implications for settlement operations.

---

### 5. Treasury

**Function:** Manages liquidity, float, and settlement accounts. Ensures sufficient funding to settle transactions, manages FX exposure, and optimises use of company funds across accounts and geographies.
**KPIs:** Float efficiency, FX cost, liquidity utilisation.
**Tone:** Precise and numbers-forward. Flag anything requiring pre-launch account setup or limit increases. Keep under 400 words.
**Key concerns:** Settlement timing, float, or liquidity requirements changed? New currencies or FX exposures? New accounts to pre-fund? Expected settlement volume and peak exposure?

**Scoping rules:**
- Do not invent FX exposure figures, prefunding amounts, or settlement volumes — if the PRD doesn't provide numbers, write "volumes TBC" and flag as a planning input needed
- Do not add new currency pairs unless the PRD explicitly names them
- Do not recommend new banking arrangements unless the PRD introduces a corridor or currency that isn't currently live

**Output structure:**

**What's new**
2–3 sentences. What is changing that affects money movement — new corridors, new currencies, new settlement timing, or changes to prefunding requirements?

**What's in it for you**
2–3 sentences. How does this change float requirements, FX exposure, or liquidity planning? Quantify if the PRD gives volume or timing estimates.

**Inputs required before go-live**
Bullet list (3–5 items max). Examples: update liquidity models for new corridor, confirm prefunding arrangements with banking partners, validate FX hedging approach, review settlement timing with Payment Ops, update cash flow forecast.

**Settlement mechanics and prefunding**
3–4 bullets. Settlement timelines for new corridors/currencies, required prefunding amounts by geography, changes to net settlement windows, whether new settlement accounts or FX hedging arrangements are needed.

**Liquidity and FX exposure planning**
2–3 bullets. Expected transaction volumes and peak float exposure, FX exposure limits by currency pair, changes to banking arrangements (new accounts, increased limits) needed before launch.

---

### 6. Sales

**Function:** Acquires new merchants. Needs to know what the feature does in plain language, who it's for, and whether supporting materials are ready. Needs confidence internal teams are aligned before selling.
**KPIs:** Pipeline generated, deal velocity, win rate.
**Tone:** Clear, commercial, confident. No pricing detail. Keep under 400 words.
**Key concerns:** What can Sales now say to a prospect? Figma/demo/API docs ready? Internal teams aligned? Known limitations to disclose upfront?

**Scoping rules:**
- Do not list specific geographies unless the PRD names them — flag as "confirm with Product" if unclear
- Do not add competitive comparisons
- Do not include pricing commentary

**Output structure:**

**What's changing**
2–3 sentences. What can Sales now say to a prospect that they couldn't before? Who is this for and what problem does it solve — in plain, jargon-free language?

**Actions / decisions needed**
Bullet list (3–5 items). Examples: confirm Figma or demo video is available and shareable, check API docs are published and live, verify Compliance/Risk/Ops are aligned and ready to support, identify target merchant segments to prioritise outreach, flag any geographies or segments excluded at launch.

**Risks / watch-outs**
2–3 bullets. What should Sales not promise? What known limitations need to be disclosed upfront? Any internal readiness gaps that could embarrass them mid-deal?

---

### 7. Account Management

**Function:** Manages existing merchant relationships — renewals, upsells, issue escalation, client communication. Needs to know what's changing for their book of business.
**KPIs:** NRR, churn rate, expansion MRR, NPS.
**Tone:** Relationship-focused and clear. Help them anticipate client reactions. Flag clients needing white-glove communication. Keep under 400 words.
**Key concerns:** Which existing clients are affected? Action required from clients? Proactive or reactive communication? Upsell or expansion opportunities?

**Scoping rules:**
- Do not fabricate specific account names or segment sizes — describe impacted profiles, not specific clients
- Do not estimate NRR impact unless the PRD provides volume or pricing data — if absent, note as a metric to track post-launch
- Do not use "top 10 accounts" framing — use "merchant segments most likely to need proactive outreach — AM to map to specific accounts"

**Output structure:**

**What's new**
2–3 sentences. What is changing for existing customers, framed from the customer's point of view — what will they notice or gain?

**What's in it for you**
2–3 sentences. Which account segments should be prioritised for proactive outreach? Does this reduce a known churn risk? Does it open an upsell conversation?

**Inputs required before go-live**
Bullet list (3–5 items max). Examples: draft customer-facing communication, identify segments to brief proactively, update QBR template with new capability, prepare FAQ for inbound questions, flag any accounts that may be negatively affected.

**Customer impact and outreach strategy**
3–4 bullets. Which existing customer segments are affected and whether action is required from them. Whether to use proactive outreach (white-glove for strategic accounts) or reactive communication. Accounts or segment types that may be negatively affected and need special handling.

**Expansion and upsell opportunities**
2–3 bullets. Upsell or cross-sell opportunities this unlocks. Messaging for NPS/churn risk mitigation. NRR impact if the PRD provides volume or pricing data — otherwise flag as post-launch metric.

---

### 8. Partnerships

**Function:** Two tracks — (1) payment rail partners: PSPs, banks, networks for money movement; (2) referral/lead-gen partners: external parties who bring in merchant clients.
**KPIs:** New corridors enabled, partner-sourced merchant leads, commercial deal closures, rail uptime.
**Tone:** Commercially aware, specific about partner type (rail vs referral). Keep under 400 words.
**Key concerns:** Does this depend on a rail partner being ready? New corridor needing negotiated access? Something referral partners can pitch? Commercial terms or contract amendments triggered?

**Scoping rules:**
- Only name specific partners if the PRD explicitly names them — otherwise reference "the relevant rail partner" generically
- Do not invent commercial term implications unless the PRD explicitly introduces a new commercial relationship
- If the PRD doesn't involve a new rail or corridor, state the rail partner track is not applicable rather than inventing implications

**Output structure:**

**What's changing**
2–3 sentences. Is this launch dependent on a payment rail partner being ready? Does it open a new corridor? Is it a feature referral partners can use to bring in merchants? Be specific about which type of partner is affected.

**Actions / decisions needed**
Bullet list (3–5 items). Examples: confirm rail partner integration is tested and live, check whether commercial terms cover this use case, brief referral partners with updated positioning, review contract or revenue-share implications, flag partners who haven't confirmed readiness.

**Risks / watch-outs**
2–3 bullets. What breaks if a rail partner isn't ready at launch? Corridors or rails where access hasn't been confirmed? Are referral partners positioned correctly or will there be confusion?

---

### 9. Legal

**Function:** Owns contracts, ToS, privacy policy, regulatory legal advice, IP, and corporate risk. Reviews product terms and merchant agreements. Advises on regulatory perimeter questions.
**KPIs:** Legal review SLA, contract amendment volume, regulatory finding rate.
**Tone:** Precise, formal, liability-conscious. Flag open legal questions clearly. Keep under 400 words.
**Key concerns:** Do existing contracts cover this? New ToS or legal disclosures required? Regulatory perimeter question? IP or data protection considerations?

**Scoping rules:**
- Do not cite specific regulations (GDPR, PSD2, RBI) unless the PRD introduces activity in a jurisdiction that explicitly triggers them
- Do not add IP considerations unless the PRD introduces a third-party integration, white-label arrangement, or new software component with licensing implications
- Do not recommend ToS/Privacy Policy updates unless the PRD introduces new user-facing flows, new data collection, or new user rights

**Output structure:**

**What's new**
2–3 sentences. A high-level description of the product change from a user-rights or data-handling perspective.

**What's in it for you**
2–3 sentences. Does this require ToS or Privacy Policy updates? Does it introduce a new data category, processing activity, or cross-border data transfer? Flag regulatory jurisdiction implications only if the PRD mentions them.

**Inputs required before go-live**
Bullet list (3–5 items max). Examples: review and approve ToS amendment, confirm data processing agreement coverage, assess regulatory notification obligations, sign off on new consent flows, review partner contracts for scope alignment.

**Contract and liability review**
3–4 bullets. Which existing contracts need review and amendment. New user rights or restrictions introduced. Data protection, IP, or liability considerations specific to this product or new customer segments.

**Regulatory perimeter and compliance obligations**
2–3 bullets. Whether this activity falls within existing regulatory authorisations or requires new notices/consents. Jurisdiction-specific compliance implications — only if PRD names the jurisdiction. Whether existing DPAs cover the new data flows.

---

### 10. Finance

**Function:** Owns revenue recognition, accounting policy, financial reporting, and tax compliance.
**KPIs:** Revenue recognition accuracy, close-cycle time, audit finding rate.
**Tone:** Precise, formal, numbers-forward. Keep under 400 words.
**Key concerns:** How is revenue generated and recognised? Direct costs? Float, settlement, or balance sheet implications? Tax or inter-company considerations?

**Scoping rules:**
- Do not invent cost figures (scheme fees, processing margins) — if the PRD doesn't name them, write "cost structure TBC — Finance to confirm with Payments"
- Do not add tax jurisdiction implications unless the PRD introduces a new geography or entity structure
- Do not recommend new GL accounts unless the PRD introduces a genuinely new transaction type or revenue category

**Output structure:**

**What's new**
2–3 sentences. What is the product change and what new financial activity does it generate — new revenue stream, new fee type, new refund logic, or new currency/corridor?

**What's in it for you**
2–3 sentences. How does this affect revenue recognition policy, GL mapping, or tax treatment? If the PRD has volume or revenue estimates, include them. Flag new transaction types that need a new chart-of-accounts entry.

**Inputs required before go-live**
Bullet list (3–5 items max). Examples: confirm revenue recognition treatment, update GL mapping for new transaction types, assess tax implications for new corridors, update financial reporting templates, align with auditors if material.

**Revenue model and financial impact**
3–4 bullets. Revenue generation model (how fees are charged, what transaction types generate revenue). Expected volumes and revenue impact if the PRD provides them. Cost drivers and whether the product is expected to be accretive or dilutive to margins.

**GL mapping, tax, and reporting**
2–3 bullets. GL accounts needed for new transaction types. Tax implications, inter-company considerations, or new jurisdictions — only if PRD introduces them. How this will be tracked in finance systems.

---

### 11. Licensing

**Function:** Manages payment institution licences, e-money licences, and jurisdiction-specific authorisations. Tracks licence conditions and ensures new products operate within licensed permissions.
**KPIs:** Licence coverage rate, regulatory submission timeliness, finding rate from regulators.
**Tone:** Regulatory and jurisdiction-specific. Precise about geographies and licence types. Keep under 400 words.
**Key concerns:** Does this fall within current licence permissions in each target geography? Regulator notification required? Licence conditions constraining the product? Capital requirements affected?

**Scoping rules:**
- Only map geographies explicitly named in the PRD — do not infer or expand geographic scope
- Do not add regulatory capital commentary unless the PRD introduces material new transaction volumes or a new activity type that changes the licence basis
- Do not recommend external counsel unless the PRD introduces an activity that appears genuinely out of existing licence scope

**Output structure:**

**What's new**
2–3 sentences. What is the product change and which new geographies, customer segments, or payment activities are introduced?

**What's in it for you**
2–3 sentences. Does this activity fall under existing licence coverage, or does it potentially require new or extended authorisation? Are there reporting thresholds or regulatory notifications triggered?

**Inputs required before go-live**
Bullet list (3–5 items max). Examples: confirm licence coverage for new corridor or product type, assess need for regulatory notification, review reporting obligations for new transaction category, update licence register, brief external counsel if required.

**Licence scope and coverage assessment**
3–4 bullets. Map new product activity to each target geography (named in PRD only) and specify which licence type covers it. Flag jurisdictions where the activity is out-of-scope. Highlight licence conditions that constrain the product design or pricing.

**Regulatory notifications and reporting obligations**
2–3 bullets. Regulatory notifications, approvals, or material change filings required before launch. New transaction categories that trigger reporting thresholds. Whether capital requirements change based on the new activity.

---

### 12. Product — Payments Pod

**Function:** Owns payment initiation, processing, and settlement product surface — payment rails, routing logic, settlement, and scheme connectivity.
**Technical depth:** 4–6 out of 10 — give enough context to understand the why, be direct about the how.
**Tone:** Technical but not jargon-heavy. Direct about system dependencies, data flows, failure modes. Keep under 400 words.
**Key concerns:** Changes to payment infrastructure? New rails, schemes, routing logic? Technical dependencies stable? Rollback plan? Performance, latency, throughput considerations?

**Scoping rules:**
- If the PRD does not specify exact service names, endpoint names, or schema fields, describe the impact functionally — do not invent technical specifics
- If the PRD doesn't confirm a specific system is affected, frame it as a question: "confirm whether [X] needs updating" rather than stating it as fact

**Output structure:**

**What's new**
2–3 sentences on the feature. Then 1–2 sentences as a technical summary: what changes at the service or API level — new endpoint, changed request/response schema, updated payment rail, or new state in the payment lifecycle.

**Relevance to your pod**
2–3 sentences. Which services does this touch? Upstream or downstream dependencies affected (e.g., ledger, notification service, reconciliation)? Does this change any retry or fallback behaviour?

**Inputs required before go-live**
Bullet list (3–5 items max). Examples: review API contract changes, validate edge cases in staging, update internal documentation, confirm monitoring alerts are in place, define the bug-watch period and owner.

**Infrastructure and dependency mapping**
3–4 bullets. Infrastructure changes (new rails, schemes, or routing logic). Upstream dependencies and their readiness. Fallback and retry logic for new states. Performance, latency, or throughput concerns with baseline expectations.

**Rollback strategy and monitoring**
2–3 bullets. Rollback plan if critical issues arise. Monitoring alerts, metrics to watch, and watch-period ownership. Known edge cases or data consistency concerns.

---

### 13. Product — Operations Pod

**Function:** Owns internal tooling — dashboards, ops portals, back-office systems, and tools used by Payment Ops, Compliance, and Support.
**Technical depth:** 4–6 out of 10.
**Tone:** Practical, systems-aware, direct. Keep under 400 words.
**Key concerns:** Internal tools need updating? Can ops teams action exceptions, view transaction state, manage disputes? New internal workflows needing tooling support?

**Scoping rules:**
- Do not name specific dashboards or internal tools as affected unless the PRD identifies them — frame as a question if unclear
- Do not invent new operational workflows; describe what the PRD introduces and let the team determine the tooling impact

**Output structure:**

**What's new**
2–3 sentences on the feature. Then 1–2 sentences on technical impact: what new data, event, or state is produced that their tooling needs to handle?

**Relevance to your pod**
2–3 sentences. Does this require updates to ops dashboards, case management queues, or alert logic? New operational states or failure modes that need tooling support?

**Inputs required before go-live**
Bullet list (3–5 items max). Examples: update internal dashboard for new transaction states, add new event type to case management routing, validate ops tooling in staging, document new failure codes, confirm monitoring coverage.

**Dashboard and visibility updates**
3–4 bullets. Which ops dashboards need new data surfaces or views. New transaction states, failure modes, or events that need to be visible to Payment Ops, Compliance, and Support teams. New metrics or KPIs needing real-time tracking.

**Case management and tooling changes**
2–3 bullets. New exception types or operational workflows requiring case management support. Whether internal tools can action transactions, view state, and manage disputes for this new product. New failure codes or escalation paths to document in the ops runbook.

---

### 14. Product — Merchant Pod

**Function:** Owns merchant-facing product surface — APIs, dashboards, onboarding flows, and documentation.
**Technical depth:** 4–6 out of 10.
**Tone:** Product-focused, integration-aware, direct. Keep under 400 words.
**Key concerns:** Merchant integration experience? API docs ready? Dashboard or portal changes merchants will see? Self-serve vs assisted onboarding? Breaking vs additive API changes?

**Scoping rules:**
- Do not invent specific endpoint names or webhook events if the PRD doesn't name them — describe the type of change functionally
- Clearly distinguish breaking changes from additive ones — only flag migration guide requirement if a change is breaking or materially additive

**Output structure:**

**What's new**
2–3 sentences on the feature. Then 1–2 sentences technically: are there new webhook events, changed API responses, or new merchant dashboard states introduced?

**Relevance to your pod**
2–3 sentences. What needs to change in the merchant-facing product or docs? Are there breaking or additive changes to the merchant API that require a versioning decision or migration guide?

**Inputs required before go-live**
Bullet list (3–5 items max). Examples: update merchant API documentation, publish webhook changelog, update merchant dashboard UI for new states, prepare migration guide if schema changes are additive, add new events to sandbox environment.

**Merchant API and integration experience**
3–4 bullets. All API contract changes (new endpoints, changed schemas, new webhook events). Whether changes are breaking or additive. Merchant integration path (self-serve vs assisted) and onboarding friction points. Whether API documentation, sandbox, and migration guide are ready.

**Merchant dashboard and feedback mechanisms**
2–3 bullets. New merchant dashboard views, controls, or states needed. Feedback and support mechanisms at launch. Developer experience gaps that could impede adoption.

---

### 15. Product — Data

**Function:** Owns data infrastructure, analytics instrumentation, pipelines, schema governance, and ML feature stores.
**Technical depth:** 4–6 out of 10.
**Tone:** Data-precise, systems-aware, direct. Keep under 400 words.
**Key concerns:** New events, fields, or entities? Tracking and instrumentation defined? Existing data models or pipelines affected? How will success metrics be measured?

**Scoping rules:**
- Do not list ML feature impacts unless the PRD explicitly mentions ML or model dependencies
- Do not invent schema field names — describe new data functionally
- Do not add data quality concerns unless the PRD introduces a new data source or integration with uncertain data reliability

**Output structure:**

**What's new**
2–3 sentences on the feature. Then 1–2 sentences technically: are there new events, new entities, or schema changes that affect the data layer?

**Relevance to your pod**
2–3 sentences. Which pipelines, tables, or ML features are affected? New tracking requirements — new events to instrument, new properties to capture? Does this affect existing dashboards or reports?

**Inputs required before go-live**
Bullet list (3–5 items max). Examples: instrument new events per tracking plan, update data schema and run migration, validate downstream pipeline in staging, update BI dashboards for new dimensions, confirm data retention policy for new data type.

**Events, schema, and instrumentation**
3–4 bullets. New events and properties to instrument. Schema changes required (new tables, fields, entities). Tracking plan status. Data quality concerns or special handling needed.

**Analytics, BI dashboards, and success metrics**
2–3 bullets. New dashboards or reports needed at launch. How success metrics will be measured and by whom. ML features, pipelines, or segments affected by the new data — only if PRD indicates ML dependency.

---

### 16. Engineering

**Function:** Owns system reliability, infrastructure, deployment, and cross-cutting technical concerns.
**Technical depth:** 4–6 out of 10 — give enough context to understand the risk surface, then be direct.
**Tone:** Technical, risk-aware, direct. Specifics only — not vague references to "the system". Keep under 400 words.
**Key concerns:** Scope defined and dependencies resolved? Deployment plan and rollback strategy? Performance, security, scalability concerns? Monitoring and alerting in place?

**Scoping rules:**
- Do not specify a deployment strategy (flag-gated, gradual, hard cutover) unless the PRD names one — flag as "deployment strategy TBC, Engineering to confirm" if absent
- Do not invent performance benchmarks or latency estimates — describe performance risk directionally if the PRD suggests scale changes
- Do not name specific services as in-scope unless the PRD or technical spec identifies them

**Output structure:**

**What's new**
2–3 sentences on the feature. Then 1–2 sentences as a technical summary: what services are being modified, added, or deprecated? Any infrastructure or dependency changes?

**Relevance to your team**
2–3 sentences. What is the deployment risk profile — flag-gated, hard cutover, or gradual rollout? Which services have upstream or downstream dependencies needing coordination? Known performance implications?

**Inputs required before go-live**
Bullet list (3–5 items max). Examples: confirm feature flag configuration, validate rollback plan, ensure observability/alerting is in place, schedule deployment window with stakeholders, define post-deploy bug-watch period and on-call owner.

**Scope, dependencies, and risk surface**
3–4 bullets. What is in scope (services modified, infrastructure changes) and what is explicitly out of scope. Upstream and downstream service dependencies and their readiness. Known performance, security, or scalability concerns and mitigations.

**Deployment, monitoring, and rollback plan**
2–3 bullets. Deployment strategy and rollback plan if critical issues occur — only if PRD specifies them; otherwise flag as TBC. Observability and alerting in place at launch. Bug-watch period, on-call owner, and escalation path.

---

## Step 3 — Generate Notes for Affected Teams Only

Only generate a note for each team listed in the PRD's `## Teams to Brief` section. Skip all others — no placeholders or "not applicable" entries.

For each team in scope:
- Use the team's specific output structure defined above (not a generic format)
- Apply the team's scoping rules strictly
- Write from the PRD content — if the PRD is silent on something a team cares about, flag it as an open question rather than inventing an answer

---

## Step 4 — Write Output File

Save as `launch-notes.md` in the current working directory.

Header:

```markdown
# Pre-Launch Sync Notes

**Feature:** [Feature name from PRD]
**Date:** [Today's date]
**Teams covered:** [comma-separated list of teams from "Teams to Brief"]

> These notes are tailored per team. Each team reads their section only.

---
```

Append all team sections separated by `---`.

Close with:

```markdown
---

*Each team reads their section. Inputs/decisions = pre-launch checklist. Risks/watch-outs = escalate before go-live, not after.*
```

---

## Quality Rules

- Use each team's specific output structure — do not use a generic format across all teams
- Language tailored per team — not copy-pasted across sections
- Actions specific and concrete — not "review the feature"
- Use exact geographies, entity types, and figures from the PRD — never invent them
- Apply every team's scoping rules — they exist to prevent hallucination
- If the PRD is silent on something a team cares about, flag it as an open question

Once done, confirm: "launch-notes.md written for [N] teams. Review before sharing."
