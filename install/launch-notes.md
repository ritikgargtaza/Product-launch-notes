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

## Step 2 — Output format (applies to every team)

Each team section is a short, scannable bullet list — nothing else. **No "What's new" / "Actions / decisions needed" / "Risks / watch-outs" subsections. No paragraphs. No nested headers.**

**Bullet rules:**
- 3–6 bullets per team. Six is the cap.
- Each bullet = one clear fact, action, decision, or risk that the team needs to know before go-live.
- One idea per bullet — don't pack three points into a line.
- Lead with the substance; add a short parenthetical only when the term or context isn't obvious.
- Expand acronyms on first use within the bullet — e.g. "PII (Personally Identifiable Information)", "MTO (Money Transfer Operator)".
- Be specific. "Map `entity_not_approved` and `on_behalf_of required` errors to internal SOP" beats "Review the feature".
- Pull facts, field names, configs, error codes, and edge cases directly from the PRD — never invent.
- If the PRD is silent on something this team genuinely cares about, write a bullet flagging it as an open question — do not invent an answer.
- Each bullet is 1–2 lines on screen. If a bullet runs longer, split it or trim it.

Format every team section as:
```markdown
## [Team Name]

- bullet 1
- bullet 2
- bullet 3
- bullet 4
- bullet 5
```

No headings, sub-headings, bold labels, or callouts inside a team section. Bullets only.

---

## Step 3 — Team Context

Each entry below gives the team's function, KPIs, key concerns, scoping rules, and **focus areas** — guidance for what bullets should cover. Apply the scoping rules strictly (they prevent hallucination).

---

### 1. Compliance — Onboarding

**Function:** Owns KYC/KYB workflows, identity verification, document collection, and onboarding decisioning. Sets risk-based acceptance criteria and ensures AML/sanctions screening is applied before a customer is activated.
**KPIs:** Onboarding approval rate, time-to-activate, SLA breach rate.
**Key concerns:** Does this change who can be onboarded or what data is collected? New onboarding flows needing sign-off? Sanctions/PEP checks still applied correctly? If Sardine is involved: is data mapping complete and locked?

**Scoping rules:**
- Use the PRD's own language for entity types — do not expand a simple descriptor into a full taxonomy
- Do not add CDD/EDD review actions unless the PRD explicitly introduces new entity types or segments requiring new procedures
- Do not add travel rule, data retention, or geography bullets unless the PRD explicitly raises them
- 3–5 bullets

**Focus areas for bullets:**
- New entity types or data fields introduced and what they mean for KYC/KYB coverage
- New approval gates, rejection codes, or onboarding workflows that need SOP and SLA sign-off
- Sardine data mapping status (only if Sardine is involved) — flag as launch blocker if mapping isn't confirmed and validated in staging
- Operational impact on the approval queue (e.g. approval becoming a production control)

---

### 2. Compliance — Transaction Monitoring

**Function:** Detects suspicious activity in live transaction flows. Owns rules engine, alert thresholds, SAR/STR filing obligations, and ongoing AML monitoring.
**KPIs:** Fraud loss rate, chargeback rate, alert response time, exposure breaches.
**Key concerns:** New transaction types, corridors, or merchants not covered by existing rules? Will velocity patterns look different? New data fields feeding into monitoring?

**Scoping rules:**
- Do not add AML typologies or SAR/STR obligations unless the PRD introduces a transaction type with explicit filing implications
- Do not invent fraud pattern names — describe patterns only using PRD language
- Do not add monitoring rule recommendations unless the PRD introduces a transaction type with no existing rule coverage
- 3–6 bullets

**Focus areas for bullets:**
- New fields or events flowing into the TM system (and confirmation they're ingested before launch)
- Rule recalibration needed for new transaction types, entity types, or merchant categories
- Alert volume / triage impact expected post-launch
- SAR/STR or escalation path changes — only if PRD raises them

---

### 3. Risk

**Function:** Owns credit risk, fraud risk, and operational risk. Sets exposure limits, counter-party risk policies, and loss tolerance thresholds.
**KPIs:** Fraud loss rate, chargeback ratio, credit loss rate, net exposure.
**Key concerns:** Fraud or credit exposure introduced? Existing controls sufficient? Counter-party or settlement risk changed? If Forter is involved: data structure correct? PSP redirect URLs confirmed? Reserve config exists at entity level?

**Scoping rules:**
- Do not add actions about reviewing entity type taxonomies unless the PRD introduces a new risk framework
- Do not pad risk scenarios — match bullet count to actual distinct risk vectors in the PRD
- Do not include technical or infrastructure risks (latency, service dependencies) — those belong in Engineering
- 3–6 bullets

**Focus areas for bullets:**
- Distinct fraud/chargeback/credit risk vectors the PRD introduces and whether existing controls cover them
- Refund and reconciliation linkage where it affects loss attribution
- Forter SDK ownership and data-structure correctness (only if Forter is involved)
- PSP redirect URL coverage for new flow variants (only if relevant)
- Entity-level reserves or limits — flag as gap if absent

---

### 4. Payment Operations

**Function:** Manages day-to-day payment flows — settlement, reconciliation, exception handling, failed transaction management, dispute resolution, and SLAs.
**KPIs:** Settlement success rate, reconciliation breaks, manual intervention rate, SLA adherence.
**Key concerns:** New payment rails, schemes, or settlement windows? How are failed transactions and exceptions handled? New runbooks or escalation paths needed? Manual steps ops needs to own?

**Scoping rules:**
- Do not invent specific failure codes — use only codes the PRD names; describe other failure scenarios generically
- When the PRD includes liquidity/FX commentary relevant to settlement volumes, put it in a bullet here — do not move it to Treasury
- State plainly if there are no new rails / no SLA change rather than padding
- 3–6 bullets

**Focus areas for bullets:**
- Rails / settlement windows / SLA changes — or explicit confirmation there are none
- New error codes or failure scenarios to map to SOP and the triage/handoff path
- Reconciliation, refund, and report changes (new fields, CSV exports, dashboard columns) ops must validate in staging
- Edge cases the PRD calls out (deleted entity, revoked approval, high-volume scenarios, etc.)

---

### 5. Treasury

**Function:** Manages liquidity, float, and settlement accounts. Ensures sufficient funding to settle transactions, manages FX exposure, and optimises use of company funds across accounts and geographies.
**KPIs:** Float efficiency, FX cost, liquidity utilisation.
**Key concerns:** Settlement timing, float, or liquidity requirements changed? New currencies or FX exposures? New accounts to pre-fund?

**Scoping rules:**
- Do not invent FX exposure figures, prefunding amounts, or settlement volumes — write "volumes TBC" if PRD is silent
- Do not add new currency pairs unless the PRD explicitly names them
- Do not recommend new banking arrangements unless a new corridor or currency is introduced
- 3–5 bullets

**Focus areas for bullets:**
- New corridors, currencies, or settlement timing changes
- Prefunding or float requirement changes (with figures only if PRD provides them)
- FX exposure or hedging implications
- Banking arrangements (new accounts, increased limits) needed before launch

---

### 6. Sales

**Function:** Acquires new merchants. Needs the feature in plain language, target segments, and confirmation supporting materials are ready.
**KPIs:** Pipeline generated, deal velocity, win rate.
**Key concerns:** What can Sales now say to a prospect? Figma/demo/API docs ready? Internal teams aligned? Known limitations to disclose?

**Scoping rules:**
- Do not list geographies unless the PRD names them — flag "confirm with Product" if unclear
- No competitive comparisons, no pricing commentary
- 3–5 bullets

**Focus areas for bullets:**
- Plain-language one-liner of what Sales can now pitch and to whom
- Collateral readiness (Figma, demo, API docs) — explicit go/no-go items
- Target merchant segments to prioritise
- Known limitations or excluded geographies/segments to disclose upfront

---

### 7. Account Management

**Function:** Manages existing merchant relationships — renewals, upsells, escalations, client communication.
**KPIs:** NRR (Net Revenue Retention), churn rate, expansion MRR (Monthly Recurring Revenue), NPS.
**Key concerns:** Which existing clients are affected? Action required from clients? Proactive or reactive communication? Upsell/expansion opportunities?

**Scoping rules:**
- Do not fabricate account names or segment sizes — describe profiles, not specific clients
- Do not estimate NRR impact unless the PRD provides volume/pricing data
- Do not use "top 10 accounts" framing — use "segments most likely to need proactive outreach"
- 3–5 bullets

**Focus areas for bullets:**
- Which existing customer segments are affected and whether action is required from them
- Proactive vs reactive communication recommendation, and whom to white-glove
- Upsell or cross-sell opportunities the launch unlocks
- Accounts/segment types that may be negatively affected and need special handling

---

### 8. Partnerships

**Function:** Onboards payment service providers (PSPs), banks, and payment networks to enable money movement for Tazapay across rails and corridors. Owns the commercial agreements — pricing, commissions, T&Cs, and contractual scope — that govern how rail partners move money on Tazapay's behalf. Manages ongoing rail partner relationships.
**KPIs:** New rails and corridors enabled, rail uptime and reliability, commercial terms achieved, partner agreement turnaround time.
**Key concerns:** Does this depend on a rail partner being ready? New corridor or rail needing negotiated access? Do existing commercial agreements cover the new use case?

**Scoping rules:**
- **Never name specific PSPs, banks, or partners** (e.g. do not name JP Morgan, SCB, PayNow, or any other partner) — always reference them generically as "the relevant rail partner", "PSPs in the affected corridor", or "the rail partner enabling [corridor/method]"
- Do not invent referral/lead-gen, distribution, or technology/API partner tracks — Partnerships at Tazapay is rail/PSP partners and commercial agreements only
- Do not invent commercial term implications unless the PRD introduces a new rail, corridor, payment method, or scope change
- If the PRD introduces no rail/corridor/commercial change, state that plainly — do not pad
- 3–5 bullets

**Focus areas for bullets:**
- Rail integration dependency and readiness (or explicit confirmation there is none)
- Commercial agreement coverage — pricing, commissions, T&Cs, scope of services — and any amendments triggered
- Contractual restrictions on rail partners that could block the new flow
- Corridor/access negotiation status — only if a new corridor or method is introduced

---

### 9. Legal

**Function:** Owns contracts, ToS, privacy policy, regulatory legal advice, IP, and corporate risk.
**KPIs:** Legal review SLA, contract amendment volume, regulatory finding rate.
**Key concerns:** Do existing contracts cover this? New ToS or legal disclosures required? Regulatory perimeter question? IP or data protection considerations?

**Scoping rules:**
- Do not cite specific regulations (GDPR, PSD2, RBI) unless the PRD introduces activity in a jurisdiction that explicitly triggers them
- Do not add IP considerations unless the PRD introduces a third-party integration or new software component with licensing implications
- Do not recommend ToS/Privacy Policy updates unless the PRD introduces new user-facing flows, new data collection, or new user rights
- 3–6 bullets

**Focus areas for bullets:**
- Contractual scope: do existing merchant/partner agreements cover the new structure, or is an amendment/addendum required
- New data fields or processing activities that may need DPA coverage or trigger cross-border data transfer obligations
- User-facing changes (display configs, deletion behaviour) with disclosure or consumer-protection implications
- Liability allocation between Tazapay, merchant, and any third-party entity introduced
- Regulatory perimeter question(s) to refer to Licensing — only if the PRD raises them

---

### 10. Finance

**Function:** Owns revenue recognition, accounting policy, financial reporting, and tax compliance.
**KPIs:** Revenue recognition accuracy, close-cycle time, audit finding rate.
**Key concerns:** How is revenue generated and recognised? Direct costs? Float, settlement, or balance sheet implications? Tax or inter-company considerations?

**Scoping rules:**
- Do not invent cost figures — write "cost structure TBC — Finance to confirm with Payments" if PRD is silent
- Do not add tax jurisdiction implications unless the PRD introduces a new geography or entity structure
- Do not recommend new GL (General Ledger) accounts unless the PRD introduces a genuinely new transaction type or revenue category
- 3–5 bullets

**Focus areas for bullets:**
- New revenue stream, fee type, or transaction type and the rev-rec treatment needed
- GL mapping or chart-of-accounts updates for new transaction types
- Billing mechanics (deduction order, free vs paid balance, failed-vs-successful charging) — only if PRD specifies them
- Tax / inter-company / new-jurisdiction implications — only if PRD introduces them

---

### 11. Licensing

**Function:** Manages payment institution licences, e-money licences, and jurisdiction-specific authorisations.
**KPIs:** Licence coverage rate, regulatory submission timeliness, finding rate from regulators.
**Key concerns:** Does this fall within current licence permissions in each target geography? Regulator notification required? Licence conditions constraining the product? Capital requirements affected?

**Scoping rules:**
- Only map geographies explicitly named in the PRD — do not infer or expand geographic scope
- Do not add regulatory capital commentary unless the PRD introduces material new volumes or a new activity type changing the licence basis
- Do not recommend external counsel unless the PRD introduces an activity that appears genuinely out of existing licence scope
- 3–6 bullets

**Focus areas for bullets:**
- New customer segments, entity types, or payment activities and whether they fall under existing licence coverage
- Per-jurisdiction licence assessment (only for geographies named in PRD)
- Regulatory notifications / material change filings potentially required before launch
- Reporting threshold changes triggered by new transaction attribution
- Capital / safeguarding implications if volumes shift materially

---

### 12. Product — Payments Pod

**Function:** Owns payment initiation, processing, and settlement product surface — payment rails, routing logic, settlement, and scheme connectivity.
**Technical depth:** 4–6 out of 10.
**Key concerns:** Changes to payment infrastructure? New rails, schemes, routing logic? Technical dependencies stable? Rollback plan? Performance considerations?

**Scoping rules:**
- If the PRD does not specify exact service names, endpoint names, or schema fields, describe the impact functionally
- If the PRD doesn't confirm a system is affected, frame it as "confirm whether [X] needs updating"
- 3–6 bullets

**Focus areas for bullets:**
- Service / API / schema changes (new endpoints, fields, lifecycle states)
- Upstream and downstream dependencies (ledger, notification, reconciliation, etc.) and their readiness
- Retry, fallback, and edge-case behaviour for new states
- Rollback plan and monitoring/alerting ownership

---

### 13. Product — Operations Pod

**Function:** Owns internal tooling — dashboards, ops portals, back-office systems used by Payment Ops, Compliance, and Support.
**Technical depth:** 4–6 out of 10.
**Key concerns:** Internal tools need updating? Can ops teams action exceptions, view transaction state, manage disputes? New internal workflows needing tooling support?

**Scoping rules:**
- Do not name specific internal tools as affected unless the PRD identifies them — frame as a question if unclear
- Do not invent new operational workflows; describe what the PRD introduces
- 3–6 bullets

**Focus areas for bullets:**
- New data, events, or states the tooling must surface
- Dashboard / case management / queue routing updates required
- New exception types and how ops will action them
- New failure codes or escalation paths to document in the ops runbook

---

### 14. Product — Merchant Pod

**Function:** Owns merchant-facing product surface — APIs, dashboards, onboarding flows, and documentation.
**Technical depth:** 4–6 out of 10.
**Key concerns:** Merchant integration experience? API docs ready? Dashboard changes merchants will see? Self-serve vs assisted onboarding? Breaking vs additive API changes?

**Scoping rules:**
- Do not invent endpoint names or webhook events if the PRD doesn't name them — describe functionally
- Clearly distinguish breaking from additive changes — only flag migration guide requirement if a change is breaking or materially additive
- 3–6 bullets

**Focus areas for bullets:**
- API contract changes (new endpoints, fields, webhooks) and whether they're breaking or additive
- Merchant dashboard views, controls, or states to add
- API documentation, sandbox, and migration guide readiness
- Self-serve vs assisted integration path and likely friction points

---

### 15. Product — Data

**Function:** Owns data infrastructure, analytics instrumentation, pipelines, schema governance, and ML feature stores.
**Technical depth:** 4–6 out of 10.
**Key concerns:** New events, fields, or entities? Tracking and instrumentation defined? Existing data models or pipelines affected? How will success metrics be measured?

**Scoping rules:**
- Do not list ML feature impacts unless the PRD explicitly mentions ML or model dependencies
- Do not invent schema field names — describe new data functionally
- Do not add data quality concerns unless the PRD introduces a new data source with uncertain reliability
- 3–6 bullets

**Focus areas for bullets:**
- New events, properties, or entities to instrument
- Schema or pipeline changes required
- BI dashboard / KPI updates needed at launch
- Success metric definition and ownership — flag as open question if PRD is silent

---

### 16. Engineering

**Function:** Owns system reliability, infrastructure, deployment, and cross-cutting technical concerns.
**Technical depth:** 4–6 out of 10.
**Key concerns:** Scope defined and dependencies resolved? Deployment plan and rollback strategy? Performance, security, scalability concerns? Monitoring and alerting in place?

**Scoping rules:**
- Do not specify a deployment strategy (flag-gated, gradual, hard cutover) unless the PRD names one — flag as "deployment strategy TBC, Engineering to confirm" if absent
- Do not invent performance benchmarks or latency estimates — describe risk directionally if PRD suggests scale changes
- Do not name specific services as in-scope unless the PRD or spec identifies them
- 3–6 bullets

**Focus areas for bullets:**
- Services / infra in scope (or "TBC, Engineering to confirm") and out of scope
- Upstream/downstream dependencies and their readiness
- Performance, security, or scalability concerns the PRD raises
- Deployment, rollback, observability, and bug-watch ownership

---

## Step 4 — Generate Notes for Affected Teams Only

Only generate a section for each team listed in the PRD's `## Teams to Brief`. Skip all others — no placeholders, no "not applicable" entries.

Common Context covers the feature summary, who it affects, key technical facts, and open questions — once, for everyone. **Do not repeat any of that content inside team sections.** Team sections are bullets that take the Common Context as read and add only what is specific to that team.

For each team in scope:
- Apply the team's scoping rules strictly
- Use the team's focus areas as guidance for what the bullets should cover — not a rigid checklist
- Write from PRD content — if the PRD is silent on something the team genuinely cares about, write a bullet flagging it as an open question
- Stay within the bullet count cap

---

## Step 5 — Write Output File

Save as `launch-notes.md` in the current working directory. Use this exact structure:

```markdown
# Pre-Launch Sync Notes

**Feature:** [Feature name from PRD]
**Go-live:** [Target date from PRD, or "TBC" if not stated]
**Date generated:** [Today's date]
**Teams covered:** [comma-separated list of teams from "Teams to Brief"]

---

## Common Context

> Read this first. All team sections below assume you've read this.

**What we're launching**
2–3 sentences. Plain-language summary of the feature and the problem it solves. No jargon.

**Who it affects**
- **Geographies:** [exact list from PRD only — do not infer]
- **Entity types:** [exact names from PRD — do not expand]
- **Customer segments:** [exact from PRD]

**Key technical facts**
- **Payment rails / PSPs involved:** [exact list, or "none"]
- **New corridors or currencies:** [exact list, or "none"]
- **Rollout strategy:** [flag-gated / gradual / hard cutover — or "TBC"]
- **Sardine involved:** [Yes / No]
- **Forter involved:** [Yes / No]
- Any other facts material to multiple teams (default configs, new fields, new error codes)

**Open questions (from PRD)**
List any questions explicitly flagged as unresolved in the PRD. If none, omit this section.

---

## [Team 1]

- bullet
- bullet
- bullet
- bullet

---

## [Team 2]

- bullet
- bullet
- bullet
- bullet
```

Close the file with:

```markdown
---

*Each team reads their section. Common Context applies to all. Bullets are the pre-launch checklist — escalate before go-live, not after.*
```

---

## Quality Rules

- Common Context is written first and carries the shared facts — do not repeat any of it inside team sections
- Team sections are bullets only — no subsections, no headers, no paragraphs, no bold labels inside bullets
- 3–6 bullets per team, one idea per bullet, 1–2 lines per bullet
- Language tailored per team — not copy-pasted across sections
- Bullets are specific and actionable — not "review the feature"
- Use exact geographies, entity types, field names, error codes, and figures from the PRD — never invent them
- Apply every team's scoping rules
- If the PRD is silent on something a team genuinely cares about, write the bullet as an open question

Once done, confirm: "launch-notes.md written for [N] teams. Review before sharing."
