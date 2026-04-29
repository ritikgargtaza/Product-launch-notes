# Release Note Prompt — Partnerships

> **Team context:** Manages strategic integrations, reseller agreements, and technology or distribution partners.  
> **KPIs:** Partner-sourced revenue, integration adoption, partner NPS.  
> **Orientation:** Needs to know if any API, data, or commercial model changes affect partner agreements.

---

## Team Description (for context)

**Function:**
Manages relationships with external partners — scheme networks, banking partners, technology providers, and distribution partners. They negotiate commercial terms, manage integration dependencies, and ensure partner obligations are met.

**Key concerns at launch:**
- Does this product depend on a new or existing partner, and are they ready?
- Are there scheme or network rules that apply to this product?
- Do any partnership agreements need to be updated or new ones signed?
- Are there revenue share or commercial implications for partners?
- What partner enablement or communication is required before launch?

**Tone:** Relationship and dependency focused. Be specific about which partners are involved and what actions they need to take.

---

## Prompt

```
You are a Senior PMM writing an internal pre-release sync note for the Partnerships team.

Context about this team: They manage strategic integrations, reseller agreements, and technology or distribution partners. Their KPIs include partner-sourced revenue, integration adoption, and partner NPS. They need to know if any API, data, or commercial model changes affect partner agreements.

PRD: [PASTE NOTION/CONFLUENCE LINK]

North star for this release: to sync all teams before the product release — so this note gives them time to loop in partners before go-live, not after.

Write a short internal Slack/email note using exactly this structure:

**What's new**
2–3 sentences. What is changing that is relevant to partners — new integration surface, new data flows, new commercial terms, or new co-sell opportunities?

**What's in it for you**
2–3 sentences. Which partners should be briefed proactively? Does this create a new partnership opportunity? Does it affect any existing integration contract?

**Inputs required before go-live**
Bullet list (3–5 items max). Examples: notify affected integration partners, review partnership agreement for scope changes, update partner portal documentation, co-develop launch announcement with key partners, check revenue-share implications.

**Partner dependencies and readiness**
3–4 bullet points. List all partners affected by this launch (scheme networks, banking partners, technology providers, distribution partners). Clarify readiness status for each, including whether integration testing is complete and whether new SLAs or data flows are needed. Flag any partners that haven't confirmed readiness.

**Commercial and agreement implications**
2–3 bullet points. Flag any revenue share, commercial term, or licence agreement changes needed. Highlight new co-sell or enablement opportunities with strategic partners. Confirm whether scheme or network rules apply and whether any regulatory notifications are required.

Tone: collaborative, commercially aware, professional. Keep the full note under 400 words.
```
