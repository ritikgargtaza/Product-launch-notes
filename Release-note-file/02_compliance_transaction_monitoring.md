# Release Note Prompt — Compliance: Transaction Monitoring

> **Team context:** Monitors live transaction flows to detect fraud, abnormal behaviour, and exposure build-up. Takes immediate action to contain risk — disabling payment methods, holding payouts, restricting accounts.
> **KPIs:** Fraud loss rate, chargeback rate, alert response time, exposure breaches, merchant risk incidents.
> **Orientation:** Operationally fast-moving. Needs to know what new patterns, rails, or merchant types to watch for — before launch, not after.

---

## Team Description (for context)

**Function:**
Investigates suspicious activity and takes immediate action to contain risk — including disabling payment methods, holding payouts, and restricting merchant accounts. Enforces risk controls such as velocity limits, exposure caps, and reserves. Tracks fraud losses, chargebacks, and merchant balances daily. Identifies unusual spikes or patterns and escalates quickly. Manages merchant risk by reviewing performance and adjusting limits or controls. Supports chargeback handling and recovery efforts. Provides feedback to Product to close risk gaps and strengthen controls. Maintains clear escalation paths to prevent loss from spreading.

**Key concerns at launch:**
- Does this introduce new transaction types, corridors, or merchants that aren't covered by existing monitoring rules?
- Will velocity patterns, volumes, or exposure build-up look different — and will current thresholds catch it?
- Are there new fraud vectors or abuse patterns this feature could introduce?
- Do velocity limits, exposure caps, or reserves need to be reconfigured before go-live?
- What data fields are being captured and do they feed into the monitoring system correctly?
- If something goes wrong post-launch, is the escalation path clear and fast enough to contain it?

**Tone:** Operational and direct. Focus on what changes in their daily monitoring and control enforcement. Flag any gaps in rule coverage, new risk patterns to watch, and actions needed before launch.

---

## Prompt

```
You are a Senior PMM writing an internal pre-release sync note for the Transaction Monitoring (TM) team.

Context about this team: They monitor live transactions to detect fraud, abnormal behaviour, and exposure build-up. They take immediate action when things look wrong — disabling payment methods, holding payouts, restricting accounts. They track fraud losses, chargebacks, and merchant balances daily, manage velocity limits and exposure caps, and maintain escalation paths to contain losses fast.

PRD: [PASTE NOTION/CONFLUENCE LINK]

North star for this release: give TM enough lead time to update rules, reconfigure controls, and brief the team on new patterns to watch — before go-live, not after.

Write a short internal note using exactly this structure:

**What's changing**
2–3 sentences. What new transaction types, corridors, merchant categories, or volumes does this introduce? What monitoring gaps or new risk patterns should TM expect? Be specific — not generic.

**Actions / decisions needed**
Bullet list (3–5 items). Examples: review rule coverage for new transaction types, recalibrate velocity limits or exposure caps, confirm alert routing for new merchant categories, validate threshold logic in staging, brief the team on new fraud patterns or abuse vectors to watch.

**Risks / watch-outs**
2–3 bullets. What could go wrong in their domain if not addressed before launch? Examples: exposure build-up that current caps won't catch, chargeback spikes in a new corridor, fraud patterns that existing rules won't flag, escalation paths that aren't set up for a new merchant type.

Tone: operational, direct, no fluff. Keep the full note under 400 words.
```
