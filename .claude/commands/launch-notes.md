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

## Step 2 — Team Context (embedded — no external files needed)

Use the team guidance below for every note you write. Apply the scoping rules strictly — they exist to prevent hallucination.

---

### 1. Compliance — Onboarding
**Function:** Owns KYC/KYB workflows, identity verification, document collection, and onboarding decisioning. Sets risk-based acceptance criteria and ensures AML/sanctions screening is applied before a customer is activated.
**KPIs:** Onboarding approval rate, time-to-activate, SLA breach rate.
**Tone:** Regulatory and procedural. Precise about obligations. Flag anything requiring policy update or sign-off before go-live.
**Key concerns:** Does this change who can be onboarded or what data is collected? New onboarding flows needing sign-off? Sanctions/PEP checks still applied correctly? If Sardine is involved: is data mapping complete and locked?
**Scoping rules:**
- Use the PRD's own language for entity types — do not expand a simple descriptor into a full taxonomy
- Do not add CDD/EDD review actions unless the PRD explicitly introduces new entity types or segments requiring new procedures — a new config or field alone does not warrant this
- Do not add travel rule risk bullets unless the PRD explicitly flags travel rule implications
- Do not add data retention or audit trail risks unless the PRD describes a deletion or archival behaviour that creates a compliance gap
- Do not list geographies unless the PRD explicitly names target markets for the new flow
- Keep to 2–3 actions and 1–2 risks
**Sardine check (include only if PRD states Sardine is involved):** Flag as action: confirm Sardine data mapping is complete and correct data structure is being sent. Confirm in staging the new flow does not generate false positive alerts — if mapping is not locked, block launch.

---

### 2. Compliance — Transaction Monitoring
**Function:** Detects suspicious activity in live transaction flows. Owns rules engine, alert thresholds, SAR/STR filing obligations, and ongoing AML monitoring. Takes immediate action to contain risk — disabling payment methods, holding payouts, restricting accounts.
**KPIs:** Fraud loss rate, chargeback rate, alert response time, exposure breaches.
**Tone:** Operational and direct. Focus on what changes in daily monitoring. Flag gaps in rule coverage and actions needed before launch.
**Key concerns:** New transaction types, corridors, or merchants not covered by existing rules? Will velocity patterns look different and will thresholds catch it? New data fields feeding into monitoring? Escalation path clear for new merchant type?
**Scoping rules:**
- Do not add AML typologies or SAR/STR obligations unless the PRD introduces a new transaction type with explicit filing implications
- Do not invent fraud pattern names — describe patterns only using language the PRD provides
- Do not add monitoring rule recommendations unless the PRD introduces a transaction type with no existing rule coverage

---

### 3. Risk
**Function:** Owns credit risk, fraud risk, and operational risk. Sets exposure limits, counter-party risk policies, and loss tolerance thresholds. Approves or blocks product decisions based on risk posture.
**KPIs:** Fraud loss rate, chargeback ratio, credit loss rate, net exposure.
**Tone:** Analytical and direct. Lead with exposure and mitigation. Risk teams want to see that someone has thought through failure modes.
**Key concerns:** Fraud or credit exposure introduced? Existing controls (velocity limits, exposure caps, fraud models) sufficient? Counter-party or settlement risk profile changed? If Forter is involved: data structure correct? PSP redirect URLs confirmed for all new flow variants? Reserve config exists at entity level?
**Scoping rules:**
- Do not add actions about reviewing entity type taxonomies unless the PRD introduces a new risk framework
- Do not pad risk scenarios — match the count to actual distinct risk vectors in the PRD; do not invent scenarios to reach a target number
- Do not include technical or infrastructure risks (e.g. service dependency failures, latency) — those belong in Engineering; this section covers financial exposure and fraud only
**Risk tool checks (include only if PRD states these tools are involved):**
- Forter: flag whether data structure sent to Forter needs updating; confirm correct before launch
- PSP redirect URLs: confirm PSPs share redirect URLs for all new flow variants; flag if unconfirmed
- Reserves: check whether config exists for ops/risk to set reserve values at entity level; if absent, flag as pre-launch gap

---

### 4. Payment Operations
**Function:** Manages day-to-day payment flows — settlement, reconciliation, exception handling, failed transaction management, dispute resolution, and SLAs.
**KPIs:** Settlement success rate, reconciliation breaks, manual intervention rate, SLA adherence.
**Tone:** Practical and operational. Focus on what changes in daily workflow. Flag manual processes, new exception types, SLA impacts.
**Key concerns:** New payment rails, schemes, or settlement windows? How are failed transactions, reversals, exceptions handled? New runbooks or escalation paths needed? Manual steps ops needs to own?
**Scoping rules:**
- Do not invent specific failure codes or error messages — describe failure scenarios generically if the PRD doesn't name them
- When the PRD includes liquidity/FX commentary relevant to settlement volumes, include a "Liquidity and FX exposure planning" subsection — do not move this content to Treasury

---

### 5. Treasury
**Function:** Manages liquidity, float, and settlement accounts. Ensures sufficient funding to settle transactions, manages FX exposure, and optimises use of company funds across accounts and geographies.
**KPIs:** Float efficiency, FX cost, liquidity utilisation.
**Tone:** Precise and numbers-forward. Flag anything requiring pre-launch account setup or limit increases.
**Key concerns:** Settlement timing, float, or liquidity requirements changed? New currencies or FX exposures? New accounts to pre-fund? Expected settlement volume and peak exposure?
**Scoping rules:**
- Do not invent FX exposure figures, prefunding amounts, or settlement volumes — if the PRD doesn't provide numbers, write "volumes TBC" and flag as a planning input needed
- Do not add new currency pairs unless the PRD explicitly names them
- Do not recommend new banking arrangements unless the PRD introduces a corridor or currency that isn't currently live

---

### 6. Sales
**Function:** Acquires new merchants. Needs to know what the feature does in plain language, who it's for, and whether supporting materials are ready (Figma/demo, API docs). Needs confidence that Compliance, Risk, and Ops are aligned before selling.
**KPIs:** Pipeline generated, deal velocity, win rate.
**Tone:** Clear and commercial. Lead with what Sales can now say to a prospect. No pricing detail.
**Key concerns:** What can Sales now say to a prospect that they couldn't before? Figma/demo/API docs ready? Internal teams aligned? Known limitations to disclose?
**Scoping rules:**
- Do not list specific geographies unless the PRD names them — flag as "confirm with Product" if unclear
- Do not add competitive comparisons
- Do not include pricing commentary

---

### 7. Account Management
**Function:** Manages existing merchant relationships — renewals, upsells, issue escalation, client communication. Needs to know what's changing for their book of business and how to talk to clients.
**KPIs:** NRR, churn rate, expansion MRR, NPS.
**Tone:** Relationship-focused and clear. Help them anticipate client reactions. Flag clients needing white-glove communication.
**Key concerns:** Which existing clients are affected? Action required from clients (integration changes, contract updates)? Proactive or reactive communication? Upsell opportunities?
**Scoping rules:**
- Do not fabricate specific account names or segment sizes — describe impacted profiles, not specific clients
- Do not estimate NRR impact unless the PRD provides volume or pricing data — if absent, note it as a metric to track post-launch
- Replace "top 10 accounts" framing with "the merchant segments most likely to need proactive outreach — AM to map to specific accounts"

---

### 8. Partnerships
**Function:** Operates on two tracks — (1) payment rail partners: PSPs, banks, networks for money movement; (2) referral/lead-gen partners: external parties who bring in merchant clients.
**KPIs:** New corridors enabled, partner-sourced merchant leads, commercial deal closures, rail uptime.
**Tone:** Commercially aware, specific about partner type (rail vs referral).
**Key concerns:** Does this depend on a rail partner being ready? New corridor needing negotiated access? Something referral partners can pitch? Commercial terms or contract amendments triggered?
**Scoping rules:**
- Only name specific partners if the PRD explicitly names them — otherwise reference "the relevant rail partner" generically
- Do not invent commercial term implications unless the PRD explicitly introduces a new commercial relationship
- If the PRD doesn't involve a new rail or corridor, state the rail partner track is not applicable rather than inventing implications

---

### 9. Legal
**Function:** Owns contracts, ToS, privacy policy, regulatory legal advice, IP, and corporate risk. Reviews product terms, merchant agreements, and advises on regulatory perimeter questions.
**KPIs:** Legal review SLA, contract amendment volume, regulatory finding rate.
**Tone:** Precise and cautious. Flag open legal questions clearly.
**Key concerns:** Do existing contracts cover this? New ToS or legal disclosures required? Regulatory perimeter question — new licence needed? IP or data protection considerations?
**Scoping rules:**
- Do not cite specific regulations (GDPR, PSD2, RBI) unless the PRD introduces activity in a jurisdiction that explicitly triggers them — generic regulatory citations are not useful
- Do not add IP considerations unless the PRD introduces a third-party integration, white-label arrangement, or new software component with licensing implications
- Do not recommend ToS/Privacy Policy updates unless the PRD introduces new user-facing flows, new data collection, or new user rights

---

### 10. Finance
**Function:** Owns revenue recognition, accounting policy, financial reporting, and tax compliance.
**KPIs:** Revenue recognition accuracy, close-cycle time, audit finding rate.
**Tone:** Precise, formal, numbers-forward.
**Key concerns:** How is revenue generated and recognised? Direct costs (scheme fees, processing, partner fees)? Float, settlement, or balance sheet implications? Tax implications or inter-company considerations?
**Scoping rules:**
- Do not invent cost figures (scheme fees, processing margins) — if the PRD doesn't name them, write "cost structure TBC — Finance to confirm with Payments"
- Do not add tax jurisdiction implications unless the PRD introduces a new geography or entity structure
- Do not recommend new GL accounts unless the PRD introduces a genuinely new transaction type or revenue category

---

### 11. Licensing
**Function:** Manages payment institution licences, e-money licences, and jurisdiction-specific authorisations. Tracks licence conditions and ensures new products operate within licensed permissions.
**KPIs:** Licence coverage rate, regulatory submission timeliness, finding rate from regulators.
**Tone:** Regulatory and jurisdiction-specific. Precise about geographies and licence types.
**Key concerns:** Does this fall within current licence permissions in each target geography? Regulator notification or approval required? Licence conditions constraining the product? Capital requirements affected?
**Scoping rules:**
- Only map geographies explicitly named in the PRD — do not infer or expand geographic scope
- Do not add regulatory capital commentary unless the PRD introduces material new transaction volumes or a new activity type that changes the licence basis
- Do not recommend external counsel unless the PRD introduces an activity that appears genuinely out of existing licence scope — this is a rare flag, not a default action item

---

### 12. Product — Payments Pod
**Function:** Owns payment initiation, processing, and settlement product surface — payment rails, routing logic, settlement, and scheme connectivity.
**Technical depth:** 4–6 out of 10.
**Tone:** Technical but not jargon-heavy. Direct about system dependencies, data flows, failure modes.
**Key concerns:** Changes to payment infrastructure? New rails, schemes, routing logic? Technical dependencies stable? Rollback plan? Performance, latency, throughput considerations?
**Scoping rules:**
- If the PRD does not specify exact service names, endpoint names, or schema fields, describe the impact functionally — do not invent technical specifics
- If the PRD doesn't confirm a specific system is affected, frame it as a question: "confirm whether [X] needs updating" rather than stating it as fact

---

### 13. Product — Operations Pod
**Function:** Owns internal tooling — dashboards, ops portals, back-office systems, and tools used by Payment Ops, Compliance, and Support.
**Technical depth:** 4–6 out of 10.
**Tone:** Practical, systems-aware, direct.
**Key concerns:** Internal tools need updating? Can ops teams action exceptions, view transaction state, manage disputes? New internal workflows needing tooling support? Reporting or visibility gaps?
**Scoping rules:**
- Do not name specific dashboards or internal tools as affected unless the PRD identifies them — frame as a question if unclear
- Do not invent new operational workflows; describe what the PRD introduces and let the team determine the tooling impact

---

### 14. Product — Merchant Pod
**Function:** Owns merchant-facing product surface — APIs, dashboards, onboarding flows, and documentation. Ensures merchants can integrate, configure, and manage the product.
**Technical depth:** 4–6 out of 10.
**Tone:** Product-focused, integration-aware.
**Key concerns:** Merchant integration experience? API docs ready? Dashboard or portal changes merchants will see? Self-serve vs assisted onboarding path? Breaking vs additive API changes?
**Scoping rules:**
- Do not invent specific endpoint names or webhook events if the PRD doesn't name them — describe the type of change functionally
- Clearly distinguish breaking changes from additive ones — only flag migration guide requirement if a change is breaking or materially additive

---

### 15. Product — Data
**Function:** Owns data infrastructure, analytics instrumentation, pipelines, schema governance, and ML feature stores.
**Technical depth:** 4–6 out of 10.
**Tone:** Data-precise, systems-aware.
**Key concerns:** New events, fields, or entities? Tracking and instrumentation defined? Existing data models or pipelines affected? How will success metrics be measured?
**Scoping rules:**
- Do not list ML feature impacts unless the PRD explicitly mentions ML or model dependencies — not all new data surfaces affect ML
- Do not invent schema field names — describe new data functionally
- Do not add data quality concerns unless the PRD introduces a new data source or integration with uncertain data reliability

---

### 16. Engineering
**Function:** Owns system reliability, infrastructure, deployment, and cross-cutting technical concerns.
**Technical depth:** 4–6 out of 10.
**Tone:** Technical, risk-aware, direct. Engineering wants specifics — not vague references to "the system".
**Key concerns:** Scope fully defined and dependencies resolved? Deployment plan and rollback strategy? Performance, security, scalability concerns? Monitoring and alerting in place?
**Scoping rules:**
- Do not specify a deployment strategy (flag-gated, gradual, hard cutover) unless the PRD names one — flag as "deployment strategy TBC, Engineering to confirm" if absent
- Do not invent performance benchmarks or latency estimates — describe performance risk directionally if the PRD suggests scale changes
- Do not name specific services as in-scope unless the PRD or technical spec identifies them

---

## Step 3 — Generate Notes for Affected Teams Only

Only generate a note for each team listed in the PRD's `## Teams to Brief` section. Skip all others — no placeholders.

For each team, write:

```
## [Team Name]

**What's changing**
2–3 sentences. Translate the PRD's impact into language specific to this team's day-to-day function and KPIs. Do not summarise the PRD generically.

**Actions / decisions needed**
- Concrete, specific pre-launch steps (3–5 max)
- Each bullet must be actionable — not "review the feature"

**Risks / watch-outs**
- 2–3 escalation flags specific to this team's domain
- Things that could go wrong in their area if not addressed
```

Apply each team's scoping rules. If the PRD is silent on something a team cares about, flag it as an open question — do not invent an answer.

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

*Each team reads their section. Actions/decisions = pre-launch checklist. Risks/watch-outs = escalate before go-live, not after.*
```

---

## Quality Rules

- Every section must have all three parts
- Language tailored per team — not copy-pasted across sections
- Actions specific and concrete — not generic
- Use exact geographies, entity types, and figures from the PRD — never invent them
- If the PRD is silent on something a team cares about, flag it as an open question

Once done, confirm: "launch-notes.md written for [N] teams. Review before sharing."
