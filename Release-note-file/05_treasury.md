# Release Note Prompt — Treasury

> **Team context:** Manages float, liquidity, prefunding, FX exposure, and interbank settlement.  
> **KPIs:** Float efficiency, FX cost, liquidity utilisation, days-payable.  
> **Orientation:** Needs advance notice of anything that changes cash flow timing or volume.

---

## Team Description (for context)

**Function:**
Manages the company's liquidity, float, and settlement accounts. They ensure sufficient funding is in place to settle transactions, manage FX exposure, and optimise the use of company funds across accounts and geographies.

**Key concerns at launch:**
- Does this product change our settlement timing, float requirements, or liquidity needs?
- Are there new currencies or FX exposures introduced?
- Do we need to pre-fund new accounts or increase existing limits?
- What is the expected settlement volume and peak exposure?
- Are there any changes to our banking arrangements needed to support this?

**Tone:** Financial and liquidity-focused. Be specific about settlement mechanics, FX, and funding requirements. Treasury needs to plan ahead — flag anything that requires pre-launch account setup or limit increases.

---

## Prompt

```
You are a Senior PMM writing an internal pre-release sync note for the Treasury team.

Context about this team: They manage float, liquidity, prefunding, FX exposure, and interbank settlement. Their KPIs include float efficiency, FX cost, liquidity utilisation, and days-payable. They need advance notice of anything that changes cash flow timing or volume.

PRD: [PASTE NOTION/CONFLUENCE LINK]

North star for this release: to sync all teams before the product release — so this note exists to give the team full visibility before go-live, not after.

Write a short internal Slack/email note using exactly this structure:

**What's new**
2–3 sentences. What is changing that affects money movement — new corridors, new currencies, new settlement timing, or changes to prefunding requirements?

**What's in it for you**
2–3 sentences. How does this change float requirements, FX exposure, or liquidity planning? Quantify if the PRD gives volume or timing estimates.

**Inputs required before go-live**
Bullet list (3–5 items max). Examples: update liquidity models for new corridor, confirm prefunding arrangements with banking partners, validate FX hedging approach, review settlement timing with Payment Ops, update cash flow forecast.

**Settlement mechanics and prefunding**
3–4 bullet points. Specify settlement timelines for new corridors/currencies, required prefunding amounts by geography, any changes to net settlement windows, and whether new settlement accounts or FX hedging arrangements are needed.

**Liquidity and FX exposure planning**
2–3 bullet points. Quantify expected transaction volumes and peak float exposure, clarify FX exposure limits by currency pair, and flag any changes to banking arrangements (new accounts, increased limits) needed before launch.

Tone: precise, numbers-forward, formal. Keep the full note under 400 words.
```
