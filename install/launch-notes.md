Generate pre-launch sync notes from a full PRD — only for the most-impacted teams.

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
- Configs being introduced (and default state)
- New API errors / webhook events / fields

**Pick the teams to brief:**
Look for a section titled `## Teams to Brief`. If present, use exactly that list. If absent, pick the 5–9 most-impacted teams based on PRD scope — do NOT default to all 16. Adding teams that have no real impact pads the doc and trains readers to skim past their section.

**Allowed team combinations** — combine adjacent teams when the launch affects them as a single concern:
- "Banking Partnerships / Payments Pod" — when the launch affects rail partner agreements AND technical integration (most common combination)
- "Sales / Account Management" — when the message to prospects and existing merchants is essentially the same
- "Legal / Licensing" — when regulatory and contractual concerns overlap tightly
- "Product / Engineering" — when implementation is the main story and the split is artificial

If no `## Teams to Brief` was found, add this warning at the top of the output:
> ⚠️ "Teams to Brief" not found in PRD — selected the N most-impacted teams. Add a "## Teams to Brief" section to the PRD to lock the list.

---

## Step 2 — Output format

Each team gets a **named-subsection layout**, not a flat bullet list:

```markdown
## [Team Name]

**Actions**
- bullet
- bullet

**Watch-out**
- bullet
```

**Subsection labels available** (pick what's actually relevant for that team — do NOT use them all every time):
- **Actions** — what needs to be done before launch (almost every team has this)
- **Blockers** — things that MUST be resolved or launch can't happen (use sparingly — a real blocker, not a nice-to-have)
- **Watch-out** — risks to monitor, not blockers
- **Scenarios** — concrete examples of risk/usage patterns (Risk team mostly)
- **Context** — short prose paragraph (1-3 sentences) to set up the actions when they need explaining (Partnerships, Compliance occasionally)
- **Ops actions** — variant of Actions for Payment Operations specifically when there are operational-process-focused items
- **Partner onboarding actions** — second category for Payment Ops when there are partner-handoff items

**Bullet rules:**
- 2–4 bullets per subsection. Four is the cap.
- One single sentence per bullet. ~15–25 words.
- **Do NOT expand acronyms.** The audience knows SLA, AML, TM, MTO, SAR/STR, ToS, DPA, PI/EMI, GDPR/PDPA, PII, GL, KPI, RBAC, SOP. Expanding pads bullets and condescends to the reader.
- **Do NOT pad with parenthetical clarifications.** Use only when genuinely needed (e.g. "MTO" as written is fine; "MTO (Money Transfer Operator)" is bloat).
- **No "confirm whether X" framing for everything.** Mix verbs: "Define", "Review", "Confirm", "Flag", "Communicate", "Brief", "Validate", "Map", "Update".
- Use em dashes (—) for compound thoughts in one bullet — but never to introduce a separate idea (split into two bullets instead).
- Pull facts, field names, error codes, configs directly from PRD. Never invent.
- If PRD is silent on something the team cares about, write one bullet flagging it as an open question — do not invent an answer.
- **Naming third-party products**: allowed when they're examples of entity types or use cases being processed for (e.g. "GCash, M-Pesa equivalents", "marketplace sellers"). NOT allowed for rail partners / PSPs / banks (those stay generic — see Partnerships rules below).

---

## Step 3 — Team Context

Each entry below gives function, KPIs, key concerns, scoping rules, and **suggested subsection structure** — what subsection labels typically apply to that team and what each should cover.

---

### 1. Compliance — Onboarding

**Function:** Owns KYC/KYB workflows, identity verification, document collection, and onboarding decisioning.
**KPIs:** Onboarding approval rate, time-to-activate, SLA breach rate.
**Key concerns:** Does this change who can be onboarded or what data is collected? New onboarding flows needing sign-off? Sanctions/PEP checks still applied correctly? If Sardine is involved: is data mapping complete and locked?

**Scoping rules:**
- Use the PRD's own language for entity types
- No CDD/EDD review actions unless the PRD introduces new entity types or segments
- No travel rule, data retention, or geography bullets unless the PRD explicitly raises them

**Suggested subsections:**
- **Actions** (always) — 2-3 bullets on approval-gate sign-off, SLA definition, new field/data coverage
- **Blockers** (if Sardine involved) — 2 bullets: Sardine data mapping confirmation + staging validation for false positives

---

### 2. Compliance — Transaction Monitoring

**Function:** Detects suspicious activity in live transaction flows. Owns rules engine, alert thresholds, SAR/STR filing obligations.
**KPIs:** Fraud loss rate, chargeback rate, alert response time, exposure breaches.
**Key concerns:** New transaction types, corridors, or merchants not covered by existing rules? New data fields feeding into monitoring? SAR/STR mapping changes?

**Scoping rules:**
- No AML typologies or SAR/STR obligations unless PRD introduces transaction types with explicit filing implications
- No invented fraud pattern names — use PRD language only
- No monitoring rule recommendations unless PRD introduces a transaction type with no existing rule coverage

**Suggested subsections:**
- **Actions** (always) — 3-4 bullets on field ingestion, rule recalibration, alert routing, SAR/STR logic
- **Watch-out** — 1-2 bullets on alert volume spikes or blind-spot risks ("merchant with 500 entities looks like one high-volume account" style)

---

### 3. Risk

**Function:** Owns credit risk, fraud risk, and operational risk. Sets exposure limits and loss tolerance thresholds.
**KPIs:** Fraud loss rate, chargeback ratio, credit loss rate, net exposure.
**Key concerns:** Fraud or credit exposure introduced? Existing controls sufficient? Counter-party or settlement risk changed? If Forter involved: data structure correct? PSP redirect URLs? Reserve config at right level?

**Scoping rules:**
- No actions about reviewing entity type taxonomies unless PRD introduces a new risk framework
- Don't pad risk scenarios — match count to actual distinct risk vectors in PRD
- No technical or infrastructure risks (latency, service deps) — those belong in Engineering

**Suggested subsections:**
- **Actions** (always) — 3-4 bullets on entity/sub-account-level controls, escalation paths, SDK ownership, reserve config
- **Scenarios** — 2 concrete risk vectors with brief mitigation (e.g. "Fraudulent entity under legitimate merchant: ...", "Chargeback concentration: ...")

---

### 4. Payment Operations

**Function:** Manages day-to-day payment flows — settlement, reconciliation, exception handling, failed transactions, disputes, SLAs.
**KPIs:** Settlement success rate, reconciliation breaks, manual intervention rate, SLA adherence.
**Key concerns:** New payment rails, schemes, or settlement windows? Failed transaction handling? New runbooks or escalation paths? Manual ops steps?

**Scoping rules:**
- Use only failure codes named in PRD; describe other failure scenarios generically
- When PRD includes liquidity/FX commentary relevant to settlement volumes, put it as a bullet here — do not move to Treasury

**Suggested subsections:**
- **Ops actions** (instead of "Actions") — 3-4 bullets on reconciliation scripts, error code mapping, dashboard validation
- **Partner onboarding actions** (when partner handoff is involved) — 2-3 bullets on partner SOP updates, entity routing, merchant comms
- **Watch-out** (only if a meaningful risk exists) — 1 bullet

---

### 5. Treasury

**Function:** Manages liquidity, float, and settlement accounts. Manages FX exposure across accounts and geographies.
**KPIs:** Float efficiency, FX cost, liquidity utilisation.
**Key concerns:** Settlement timing, float, or liquidity changed? New currencies or FX exposures? New accounts to pre-fund?

**Scoping rules:**
- Don't invent FX figures, prefunding amounts, or settlement volumes — write "volumes TBC" if PRD is silent
- No new currency pairs unless PRD explicitly names them
- Only include Treasury if the PRD has material impact on float, currencies, or settlement

**Suggested subsections:**
- **Actions** — 3-4 bullets on liquidity model updates, prefunding, FX hedging, banking setup

---

### 6. Sales (or Sales / Account Management combined)

**Function:** Acquires new merchants. Account Management owns existing merchant relationships. Combine when the launch message is similar for both.
**KPIs:** Pipeline generated, deal velocity, win rate (Sales); NRR, churn, expansion MRR (AM).
**Key concerns:** What's the new pitch? Collateral ready? Internal teams aligned? Existing merchants who need outreach?

**Scoping rules:**
- No geographies unless PRD names them
- No competitive comparisons, no pricing commentary
- No fabricated account names or segment sizes
- Don't estimate NRR impact unless PRD provides volume/pricing data

**Suggested subsections:**
- **Actions** — 3-4 bullets on positioning, collateral readiness, target segments, proactive outreach
- **Watch-out** — 1-2 bullets on what NOT to promise or known limitations to disclose

---

### 7. Banking Partnerships / Payments Pod (combined — recommended default)

**Function:** Banking Partnerships onboards PSPs, banks, payment networks for money movement; owns commercial agreements (pricing, commissions, T&Cs, contractual scope). Payments Pod owns payment initiation, processing, settlement product surface. Combine when the launch affects both rail-partner agreements AND technical integration.
**KPIs:** New rails/corridors enabled, rail uptime, commercial terms achieved, integration stability.
**Key concerns:** Rail partner readiness? Commercial scope coverage? Partner restrictions on the new flow? Technical integration risk?

**Scoping rules:**
- **NEVER name specific PSPs, banks, or partners** — always generic ("the relevant rail partner", "active partners", "PSPs in the affected corridor")
- No referral/lead-gen, distribution, or technology/API partner tracks — Banking Partnerships is rail/PSP partners + commercial agreements only
- No commercial term invention unless PRD introduces a new rail, corridor, payment method, or scope change
- If launch introduces no rail/corridor/commercial change, state plainly — do not pad

**Suggested subsections:**
- **Context** (when the launch fundamentally changes how partners see Tazapay) — 1-3 sentences explaining why partner agreements may need review (e.g. "Launch X makes Tazapay a payment facilitator for sub-entities. Banking and acquiring partners who approved Tazapay under merchant-level arrangements may not have assessed risk at sub-entity level.")
- **Actions** — 3-4 bullets on partner agreement review, restriction checks, briefings before launch

If splitting (rare):
- Use "Partnerships" alone only if launch is purely commercial with no integration risk
- Use "Payments Pod" alone only if launch is purely integration with no commercial implications

---

### 8. Legal (or Legal / Licensing combined)

**Function:** Legal owns contracts, ToS, privacy policy, regulatory legal advice, IP. Licensing owns payment institution / e-money licences and jurisdiction-specific authorisations. Combine when contractual and regulatory concerns overlap tightly for this launch.
**KPIs:** Legal review SLA, contract amendment volume, regulatory finding rate, licence coverage rate.
**Key concerns:** Existing contracts cover this? ToS/privacy updates needed? Regulatory perimeter question? Licence scope covers each geography/entity type? Material change requiring regulator notification?

**Scoping rules:**
- No specific regulations (GDPR, PSD2, RBI) unless PRD activity in that jurisdiction explicitly triggers them
- No IP considerations unless PRD introduces third-party integration or new software with licensing implications
- No ToS/Privacy updates unless PRD introduces new user-facing flows, new data collection, or new user rights
- Only map geographies explicitly named in PRD — no inference

**Suggested subsections:**
- **Actions** — 3-4 bullets on contract review, data processing assessment, licensing scope, material change notification

---

### 9. Finance

**Function:** Owns revenue recognition, accounting policy, financial reporting, tax compliance.
**KPIs:** Revenue recognition accuracy, close-cycle time, audit finding rate.
**Key concerns:** New revenue stream or fee type? GL mapping changes? Tax implications? Float/balance-sheet impact?

**Scoping rules:**
- Don't invent cost figures — write "cost structure TBC" if PRD is silent
- No tax-jurisdiction implications unless PRD introduces new geography or entity structure
- Only include Finance if the launch introduces a fee, revenue stream, or accounting consideration

**Suggested subsections:**
- **Actions** — 3-4 bullets on rev-rec policy, GL mapping, billing logic, tax treatment
- **Watch-out** (if relevant) — 1 bullet on credit accounting, expiry handling, or volume forecast risk

---

### 10. Product — Operations Pod / Merchant Pod / Data

Include these only when the launch genuinely lives or dies on their work. Merge with Engineering ("Product / Engineering") when implementation is the main story.

**Product — Operations Pod:** Internal tooling, dashboards, ops portals. Subsections: Actions on dashboard updates, case management, failure code documentation.

**Product — Merchant Pod:** Merchant-facing APIs, dashboards, onboarding flows. Subsections: Actions on API contract changes, dashboard UI, webhook changelog, documentation readiness.

**Product — Data:** Instrumentation, pipelines, schema, BI. Subsections: Actions on events to instrument, schema changes, KPI definitions, dashboard owners.

Scoping rules:
- Don't name specific dashboards/tools unless PRD names them
- Distinguish breaking vs additive API changes
- No ML feature impacts unless PRD mentions ML

---

### 11. Engineering

**Function:** System reliability, infrastructure, deployment, cross-cutting technical concerns.
**KPIs:** Reliability, deployment risk, performance baselines.

**Scoping rules:**
- No deployment strategy unless PRD names one — flag as TBC
- No invented performance benchmarks
- No specific services as in-scope unless PRD or spec identifies them

**Suggested subsections:**
- **Actions** — 3-4 bullets on scope, deployment ordering, rollback plan, bug-watch ownership

Include Engineering as its own section only if the launch has notable deployment risk; otherwise fold into "Banking Partnerships / Payments Pod" or "Product / Engineering".

---

## Step 4 — Generate Notes for Selected Teams

For each team in scope:
- Use the team's specific suggested subsections (not a generic "Actions" everywhere)
- Apply the team's scoping rules strictly
- Write from PRD content — if PRD is silent on something the team cares about, write a single bullet flagging it as an open question
- Stay within the bullet caps (2-4 per subsection)
- For combined teams (e.g. "Banking Partnerships / Payments Pod"), merge the suggested subsections from both source teams — typically 1 Context paragraph + 3-4 Actions

**Quality bar — read every bullet and ask:**
- Is this one specific sentence, or am I padding?
- Did I expand an acronym the audience already knows? (delete it)
- Did I add a parenthetical clarifier that adds nothing? (delete it)
- Is this actionable, or am I describing the feature again?
- Could a senior PMM at Tazapay read this and immediately know what to do?

---

## Step 5 — Write Output File

Save as `launch-notes.md` in the current working directory. Use this exact structure:

```markdown
# Pre-Launch Sync Notes

**Feature:** [Feature name from PRD]
**Go-live:** [Target date from PRD, or "TBC" if not stated]
**Date generated:** [Today's date]
**Teams covered:** [comma-separated list of teams]

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
- **Configs being introduced (and defaults):** [list, or "none"]
- **New API errors / webhook events / fields:** [exact names, or "none"]
- **Sardine involved:** [Yes / No]
- **Forter involved:** [Yes / No]

**Open questions (from PRD)**
List any questions explicitly flagged as unresolved. If none, omit this section.

---

## [Team 1]

**Actions**
- bullet
- bullet
- bullet

**Watch-out**
- bullet

---

## [Team 2]

**Context**
1-3 sentences when needed.

**Actions**
- bullet
- bullet
- bullet
```

Close the file with:

```markdown
---

*Each team reads their section. Common Context applies to all. Actions / Blockers / Watch-out items are the pre-launch checklist — escalate before go-live, not after.*
```

---

## Quality Rules

- Common Context: detailed (multi-section, full technical facts) — do not repeat this content in team sections
- Team sections: short, named-subsection layout, 2-4 bullets per subsection, single-sentence bullets
- No acronym expansion. No parenthetical clarifier bloat. No padding.
- Default to 5–9 teams. Combine adjacent teams when scope overlaps.
- Apply every team's scoping rules
- Use exact field names, error codes, configs from PRD — never invent
- Banking Partnerships: never name specific PSPs, banks, or partners
- If PRD is silent on something a team genuinely cares about, write the bullet as an open question

Once done, confirm: "launch-notes.md written for [N] teams. Review before sharing."
