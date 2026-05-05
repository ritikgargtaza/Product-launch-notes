# Release Note Prompt — Risk

> **Team context:** Owns credit risk, fraud risk, chargeback policy, exposure limits, and risk appetite frameworks.  
> **KPIs:** Fraud loss rate, chargeback ratio, credit loss rate, net exposure.  
> **Orientation:** Approves or blocks product decisions based on risk posture.

---

## Team Description (for context)

**Function:**
Owns the company's risk framework across credit risk, fraud risk, and operational risk. Sets exposure limits, counter-party risk policies, and loss tolerance thresholds. Works closely with Compliance, Finance, and Product to ensure new products don't introduce unacceptable risk concentrations.

**Key concerns at launch:**
- What is the fraud or credit exposure introduced by this product?
- Are existing risk controls (velocity limits, exposure caps, fraud models) sufficient?
- Does this change our counter-party or settlement risk profile?
- Are there scenarios where the company could face unexpected financial loss?
- What are the top 3 risk scenarios and have they been mitigated?
- If this feature changes the checkout or payment flow: does the PSP share redirect URLs for all new flow variants? Confirm whether URL mismatches surface in the Risk section of the ops dashboard
- Does this feature require updates to the Forter risk flow? Confirm the data structure sent to Forter is correct for the new flow
- Is the risk SDK (Forter) integration for any new entity types or flows merchant-managed or Tazapay-managed? Confirm ownership and flag any SDK update requirements before launch
- Is there a config for ops and risk teams to set reserve values at the entity level? If this doesn't exist for the new flow, flag as a gap

**Tone:** Analytical and direct. Lead with exposure and mitigation. Risk teams want to see that someone has thought through failure modes.

---

## Prompt

```
You are a Senior PMM writing an internal pre-release sync note for the Risk team.

Context about this team: They own credit risk, fraud risk, chargeback policy, exposure limits, and risk appetite frameworks. Their KPIs include fraud loss rate, chargeback ratio, credit loss rate, and net exposure. They approve or block product decisions based on risk posture.

PRD: [PASTE NOTION/CONFLUENCE LINK]

North star for this release: to sync all teams before the product release — so this note exists to give the team full visibility before go-live, not after.

Write a short internal Slack/email note using exactly this structure:

**What's new**
2–3 sentences. What is changing that affects risk exposure? Cover new product features, new merchant types, new payment corridors, or changes to velocity/limit logic.

**What's in it for you**
2–3 sentences. How does this shift the risk profile — fraud surface area, expected chargeback volume, or credit exposure? If risk is reduced, say how. If a new risk vector is introduced, flag it clearly.

**Inputs required before go-live**
Bullet list (3–5 items max). Examples: approve updated exposure limits, sign off on fraud rule changes, review stress-test outputs, confirm fallback handling for edge cases, update risk appetite documentation.

**Risk scenarios and mitigations**
3–4 bullet points. Outline the top 3 risk scenarios for this product (e.g., fraud losses, unexpectedly high chargebacks, liquidity strain on counter-parties) and the controls in place to mitigate each. Include velocity limits, fraud models, exposure caps, and monitoring thresholds.

**Counter-party and operational risk**
2–3 bullet points. Flag any changes to counter-party concentration, settlement timing, or operational resilience. Clarify whether existing monitoring and controls cover the new product scope.

Tone: direct, risk-first, quantify wherever the PRD allows. Keep the full note under 400 words.

**Risk tool checks (include whenever the feature touches checkout, payment, or entity flows):**
- Forter risk flow: if checkout or payment flow changes, flag whether the data structure sent to Forter needs updating and confirm it is correct before launch
- PSP redirect URLs: confirm PSPs share redirect URLs for all new flow variants; check whether URL mismatches (PSP URL differs from configured URLs) are visible in the Risk section of the ops dashboard — flag as open question if unconfirmed
- Risk SDK ownership: confirm whether merchants manage the Forter SDK integration for new entity types or flows, or whether Tazapay owns it; if merchant-managed, define the briefing and support process pre-launch
- Entity-level reserves: check whether there is a config for ops and risk teams to set reserve values at the entity level; if absent, flag as a pre-launch gap

**Scoping guidance (what NOT to add unless the PRD explicitly states it):**
- Do not add actions about reviewing entity type taxonomies or risk appetite per entity category unless the PRD introduces a new risk framework or distinct entity risk categories
- Do not pad risk scenarios — match the count to the actual distinct risk vectors in the PRD; 2 scenarios is correct if the PRD only introduces 2 material vectors; do not invent additional scenarios
- Do not include technical or infrastructure risks (e.g. service dependency failures, entity lookup latency) — those belong in Engineering; this section covers financial exposure and fraud only
```
