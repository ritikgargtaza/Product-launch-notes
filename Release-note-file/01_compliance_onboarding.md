# Release Note Prompt — Compliance: Onboarding

> **Team context:** Owns KYC/KYB workflows, identity verification, document collection, and onboarding decisioning.  
> **KPIs:** Onboarding approval rate, time-to-activate, SLA breach rate.  
> **Orientation:** Risk-averse and compliance-first.

---

## Team Description (for context)

**Function:**
Responsible for customer acceptance policies, KYC/KYB program design, and regulatory obligations at the point of onboarding. They define what documentation is required, set risk-based acceptance criteria, and ensure the company meets AML and sanctions screening requirements before a customer is activated.

**Key concerns at launch:**
- Does this change who we can onboard, or what data we collect at onboarding?
- Are there new customer segments, geographies, or entity types that require updated CDD/EDD procedures?
- Does the product introduce new onboarding flows that need compliance sign-off?
- Are sanctions screening and PEP checks still applied correctly in any new flow?
- Do we need to update the onboarding policy or risk appetite statement?
- If this feature changes checkout or transaction data flows: is the Sardine data mapping complete and locked? Confirm the correct data structure is flowing to Sardine — an incorrect or incomplete mapping will generate false positive rule alerts in production

**Tone:** Regulatory and procedural. Be precise about obligations. Flag anything that requires a policy update or sign-off before go-live.

**Scoping guidance (what NOT to add unless the PRD explicitly states it):**
- Use the PRD's own language for entity types — do not expand a simple descriptor (e.g. "sellers and individuals") into a full taxonomy of your own
- Do not add CDD/EDD review actions unless the PRD explicitly introduces new entity types or segments requiring new procedures — a new config or field alone does not warrant this
- Do not add travel rule risk bullets unless the PRD explicitly flags travel rule implications
- Do not add data retention or audit trail risks unless the PRD describes a deletion or archival behaviour that creates a compliance gap
- Keep to 2–3 actions and 1–2 risks — only include what the PRD's specific scope genuinely demands
```

---

## Prompt

```
You are a Senior PMM writing an internal pre-release sync note for the Compliance — Onboarding team.

Context about this team: They own KYC/KYB workflows, identity verification, document collection, and onboarding decisioning. Their KPIs include onboarding approval rate, time-to-activate, and SLA breach rate. They are risk-averse and compliance-first.

PRD: [PASTE NOTION/CONFLUENCE LINK]

North star for this release: to sync all teams before the product release — so this note exists to give the team full visibility before go-live, not after.

Write a short internal Slack/email note using exactly this structure:

**What's new**
2–3 sentences. Describe what is changing in plain language — no jargon. Focus on what is new in the onboarding flow or identity-check logic.

**What's in it for you**
2–3 sentences. Map the change to their KPIs: approval rate, time-to-activate, false positive/negative rate on KYC checks, or SLA risk. Be specific — if a step is removed or automated, say so.

**Inputs required before go-live**
Bullet list (3–5 items max). What do they need to do? Examples: update SOPs, review new rejection reason codes, test edge cases in staging, confirm limits with Risk, update the customer-facing decline messaging.

**Additional context or dependencies**
2–3 bullet points. Any other information that affects onboarding — e.g., changes to partner integrations, regulatory notifications required, or new entity types being supported. Include any escalation paths or out-of-scope items.

Tone: precise, risk-aware, no fluff. Keep the full note under 400 words.

**Sardine check (include whenever the feature touches checkout, payin, or onboarding data flows):**
- Flag as an action item: confirm Sardine data mapping is complete and the correct data structure is being sent for any new flow or entity type introduced by the feature
- Confirm in staging that the new flow does not generate false positive rule alerts in Sardine before go-live — if mapping is not locked, block launch for this team until it is

