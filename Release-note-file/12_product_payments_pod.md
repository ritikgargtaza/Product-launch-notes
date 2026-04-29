# Release Note Prompt — Product: Payments Pod

> **Team context:** Owns the payment initiation, processing, and settlement product surface.  
> **Technical depth:** 4–6 out of 10.  
> **Orientation:** API contracts, upstream/downstream dependencies, edge-case coverage, and data consistency.

---

## Team Description (for context)

**Function:**
Owns the core payments infrastructure — payment rails, routing logic, settlement, and scheme connectivity. They build and maintain the technical backbone that all payment products run on.

**Key concerns at launch:**
- What changes to the payments infrastructure does this require?
- Are there new rails, schemes, or routing logic being introduced?
- What are the technical dependencies and are they stable?
- What is the rollback plan if something breaks in the payments layer?
- Are there performance, latency, or throughput considerations?

**Tone:** Technical and infrastructure-focused. Be specific about system dependencies, data flows, and failure modes.

---

## Prompt

```
You are a Technical PMM writing an internal pre-release sync note for the Payments Pod.

Context about this team: They own the payment initiation, processing, and settlement product surface. They care about API contracts, upstream/downstream dependencies, edge-case coverage, and data consistency. Technical depth: 4–6 out of 10 — give enough context to understand the why, but be direct about the how.

PRD: [PASTE NOTION/CONFLUENCE LINK]

North star for this release: to sync all teams before the product release — this note ensures the Payments Pod is aligned on scope and ready before go-live.

Write a short internal Slack/email note using exactly this structure:

**What's new**
2–3 sentences on the feature. Then 1–2 sentences as a technical summary: what changes at the service or API level — new endpoint, changed request/response schema, updated payment rail, or new state in the payment lifecycle.

**Relevance to your pod**
2–3 sentences. Which services does this touch? Are there upstream or downstream dependencies affected (e.g., ledger, notification service, reconciliation)? Does this change any retry or fallback behaviour?

**Inputs required before go-live**
Bullet list (3–5 items max). Examples: review API contract changes, validate edge cases in staging, update internal documentation, confirm monitoring alerts are in place, define the bug-watch period and owner.

**Infrastructure and dependency mapping**
3–4 bullet points. Detail all infrastructure changes (new rails, schemes, or routing logic). Map upstream dependencies (ledger, notification, reconciliation services) and confirm readiness. Outline fallback and retry logic for new states. Specify any performance, latency, or throughput concerns with baseline expectations.

**Rollback strategy and monitoring**
2–3 bullet points. Clearly define the rollback plan if critical issues arise at launch. Specify monitoring alerts, metrics to watch, and the "watch period" ownership. Flag any known edge cases or data consistency concerns.

Tone: technical but not jargon-heavy, direct. Keep the full note under 400 words.
```
