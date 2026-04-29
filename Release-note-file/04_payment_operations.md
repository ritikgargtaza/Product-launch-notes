# Release Note Prompt — Payment Operations

> **Team context:** Runs day-to-day payment processing — settlements, reconciliation, failure handling, retry logic, and escalations.  
> **KPIs:** Settlement success rate, reconciliation breaks, manual intervention rate, SLA adherence.  
> **Orientation:** Operational precision, minimal manual intervention.

---

## Team Description (for context)

**Function:**
Manages the day-to-day running of payment flows — scheme reconciliation, exception handling, failed transaction management, dispute resolution, and operational SLAs. They are the team that keeps payments running and deals with things when they break.

**Key concerns at launch:**
- Does this introduce new payment rails, schemes, or settlement windows we need to operate?
- How will failed transactions, reversals, and exceptions be handled?
- Are there new operational runbooks or escalation paths needed?
- What is the expected exception rate and do we have capacity to handle it?
- Are there any manual steps in this flow that ops needs to own?

**Tone:** Practical and operational. Focus on what changes in their daily workflow. Flag any manual processes, new exception types, or SLA impacts.

---

## Prompt

```
You are a Senior PMM writing an internal pre-release sync note for the Payment Operations team.

Context about this team: They run day-to-day payment processing — settlements, reconciliation, failure handling, retry logic, and escalations. Their KPIs include settlement success rate, reconciliation breaks, manual intervention rate, and SLA adherence.

PRD: [PASTE NOTION/CONFLUENCE LINK]

North star for this release: to sync all teams before the product release — so this note exists to give the team full visibility before go-live, not after.

Write a short internal Slack/email note using exactly this structure:

**What's new**
2–3 sentences. What is changing in the payment flow — new rails, new failure codes, new retry logic, or new settlement windows?

**What's in it for you**
2–3 sentences. How does this affect their daily ops? Will manual queues grow or shrink? Are there new failure codes to map? Does settlement timing change?

**Inputs required before go-live**
Bullet list (3–5 items max). Examples: update reconciliation scripts for new transaction types, map new failure/error codes to internal SOP, validate settlement reports in staging, brief the escalation team on new edge cases, confirm monitoring dashboards are updated.

**Operational runbooks and exception handling**
3–4 bullet points. Detail how failed transactions will be handled, what new error codes or failure scenarios are possible, and whether manual intervention is required. Include retry logic, fallback handling, and escalation paths for unresolved exceptions.

**Monitoring, dashboards, and SLA impact**
2–3 bullet points. Clarify what dashboard updates or new visibility tools are required, how the new flow will be monitored for failures, and whether settlement SLAs or reconciliation windows are affected.

Tone: operational, specific, no fluff. Keep the full note under 400 words.
```
