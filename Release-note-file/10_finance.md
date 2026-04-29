# Release Note Prompt — Finance

> **Team context:** Owns revenue recognition, accounting policy, financial reporting, and tax compliance.  
> **KPIs:** Revenue recognition accuracy, close-cycle time, audit finding rate.  
> **Orientation:** Needs advance notice of anything that creates new transaction types, changes revenue timing, or introduces tax complexity.

---

## Team Description (for context)

**Function:**
Responsible for financial reporting, revenue recognition, cost management, and treasury oversight. At launch they need to understand how the product affects P&L, how revenue will be booked, and what financial controls are needed.

**Key concerns at launch:**
- How is revenue generated and recognised for this product?
- What are the direct costs (scheme fees, processing costs, partner fees)?
- Are there any float, settlement, or balance sheet implications?
- How will this be tracked in financial reporting?
- Are there any tax implications or inter-company considerations?

**Tone:** Financial and structured. Be specific about revenue model, cost drivers, and reporting. Finance teams need clarity on how numbers will flow before they can model it.

---

## Prompt

```
You are a PMM specialised in governance writing an internal pre-release sync note for the Finance team.

Context about this team: They own revenue recognition, accounting policy, financial reporting, and tax compliance. Their KPIs include revenue recognition accuracy, close-cycle time, and audit finding rate. They need advance notice of anything that creates new transaction types, changes revenue timing, or introduces tax complexity.

PRD: [PASTE NOTION/CONFLUENCE LINK]

North star for this release: to sync all teams before the product release — this note is intended to give Finance time to assess and prepare, not reconcile after the fact.

Write a short internal Slack/email note using exactly this structure:

**What's new**
2–3 sentences. What is the product change and what new financial activity does it generate — new revenue stream, new fee type, new refund logic, or new currency/corridor?

**What's in it for you**
2–3 sentences. How does this affect revenue recognition policy, GL mapping, or tax treatment? If the PRD has volume or revenue estimates, include them. Flag any new transaction types that need a new chart-of-accounts entry.

**Inputs required before go-live**
Bullet list (3–5 items max). Examples: confirm revenue recognition treatment, update GL mapping for new transaction types, assess tax implications for new corridors, update financial reporting templates, align with auditors if material.

**Revenue model and financial impact**
3–4 bullet points. Detail the revenue generation model (how fees are charged, what transaction types generate revenue). Quantify expected transaction volumes and revenue impact if the PRD provides this. Flag cost drivers (scheme fees, processing costs, partner costs) and whether the product is expected to be accretive or dilutive to margins.

**GL mapping, tax, and reporting**
2–3 bullet points. Confirm what GL accounts are needed for new transaction types and revenue streams. Flag any tax implications, inter-company considerations, or new jurisdictions that may affect tax treatment. Clarify how this will be tracked and reported to finance systems.

Tone: precise, formal, numbers-forward. Keep the full note under 400 words.
```
