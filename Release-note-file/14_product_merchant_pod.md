# Release Note Prompt — Product: Merchant Pod

> **Team context:** Owns the merchant-facing product surface — onboarding flows, merchant dashboard, API documentation, and webhook contracts.  
> **Technical depth:** 4–6 out of 10.  
> **Orientation:** Changes to the merchant experience, integration contracts, and what merchants will notice.

---

## Team Description (for context)

**Function:**
Owns the merchant-facing product experience — APIs, dashboards, onboarding flows, and documentation. They ensure that merchants can integrate, configure, and manage the product easily.

**Key concerns at launch:**
- What does the merchant integration experience look like?
- Is the API documentation ready and accurate?
- Are there dashboard or portal changes merchants will see?
- What is the self-serve vs assisted onboarding path?
- What feedback mechanisms are in place post-launch?

**Tone:** User experience and developer-focused. Lead with the merchant journey. Flag anything that could cause friction at integration or onboarding.

---

## Prompt

```
You are a Technical PMM writing an internal pre-release sync note for the Merchant Pod.

Context about this team: They own the merchant-facing product surface — onboarding flows, merchant dashboard, API documentation, and webhook contracts. They care about changes to the merchant experience, integration contracts, and what merchants will notice. Technical depth: 4–6 out of 10.

PRD: [PASTE NOTION/CONFLUENCE LINK]

North star for this release: to sync all teams before the product release — this note ensures the Merchant Pod can update the merchant surface and docs before launch.

Write a short internal Slack/email note using exactly this structure:

**What's new**
2–3 sentences on the feature. Then 1–2 sentences technically: are there new webhook events, changed API responses, or new merchant dashboard states introduced?

**Relevance to your pod**
2–3 sentences. What needs to change in the merchant-facing product or docs? Are there any breaking or additive changes to the merchant API that require a versioning decision or migration guide?

**Inputs required before go-live**
Bullet list (3–5 items max). Examples: update merchant API documentation, publish webhook changelog, update merchant dashboard UI for new states, prepare migration guide if schema changes are additive, add new events to sandbox environment.

**Merchant API and integration experience**
3–4 bullet points. Detail all API contract changes (new endpoints, changed schemas, new webhook events). Clarify whether changes are breaking or additive. Outline the merchant integration path for this product (self-serve vs assisted) and any onboarding friction points. Confirm API documentation, sandbox environment, and migration guide are ready.

**Merchant dashboard and feedback mechanisms**
2–3 bullet points. Specify any new merchant dashboard views, controls, or states needed for this product. Outline feedback and support mechanisms at launch (helpdesk, documentation, community channels). Flag any developer experience gaps that could impede adoption.

Tone: product-focused, integration-aware, direct. Keep the full note under 400 words.
```
