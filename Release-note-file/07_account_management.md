# Release Note Prompt — Account Management

> **Team context:** Owns existing customer relationships — expansion revenue, renewal, and churn prevention.  
> **KPIs:** NRR, churn rate, expansion MRR, NPS.  
> **Orientation:** Needs to know what to proactively tell customers and what questions to expect.

---

## Team Description (for context)

**Function:**
Manages relationships with existing merchants and clients. They handle renewals, upsells, issue escalation, and client communication. At launch, they need to know what's changing for their book of business and how to talk to clients about it.

**Key concerns at launch:**
- Which existing clients are affected by this change and how?
- Is any action required from clients (e.g. integration changes, contract updates)?
- How should we communicate this to clients — proactively or reactively?
- Are there upsell or expansion opportunities this creates?
- What are the most likely client questions or concerns?

**Tone:** Relationship-focused and clear. Help them anticipate client reactions. Flag any clients who may need white-glove communication.

---

## Prompt

```
You are a Senior PMM writing an internal pre-release sync note for the Account Management team.

Context about this team: They own existing customer relationships — expansion revenue, renewal, and churn prevention. Their KPIs include NRR, churn rate, expansion MRR, and NPS. They need to know what to proactively tell customers and what questions to expect.

PRD: [PASTE NOTION/CONFLUENCE LINK]

North star for this release: to sync all teams before the product release — so this note equips them to brief customers before or right at launch, not reactively.

Write a short internal Slack/email note using exactly this structure:

**What's new**
2–3 sentences. What is changing for existing customers? Frame it from the customer's point of view — what will they notice or gain?

**What's in it for you**
2–3 sentences. Which accounts should be prioritised for proactive outreach? Does this reduce a known churn risk? Does it open an upsell conversation?

**Inputs required before go-live**
Bullet list (3–5 items max). Examples: draft customer-facing communication, identify top 10 accounts to brief personally, update QBR template with new capability, prepare FAQ for inbound questions, flag any accounts that may be negatively affected.

**Customer impact and outreach strategy**
3–4 bullet points. Identify which existing customer segments are affected and whether action is required from them (integration changes, contract updates, etc.). Recommend whether to use proactive outreach (white-glove for strategic accounts) or reactive communication (in-app or email). Flag any accounts that may be negatively affected and need special handling.

**Expansion and upsell opportunities**
2–3 bullet points. Highlight upsell or cross-sell opportunities this unlocks. Suggest messaging for NPS/churn risk mitigation. Include NRR impact expectations if the PRD provides volume or pricing data.

Tone: relationship-first, practical, customer-empathetic. Keep the full note under 400 words.
```
