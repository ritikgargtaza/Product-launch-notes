# PRD — [Feature Name]

**Author:**
**Last updated:**
**Target go-live:**
**Status:** Draft / In Review / Final

---

## Teams to Brief

> List only the teams that need a launch note. Delete the rest.
> Reference: SOP.md → "Quick selection guide by feature type"

- Compliance — Onboarding
- Compliance — Transaction Monitoring
- Risk
- Payment Operations
- Treasury
- Sales
- Account Management
- Partnerships
- Legal
- Finance
- Licensing
- Product — Payments Pod
- Product — Operations Pod
- Product — Merchant Pod
- Product — Data
- Engineering

---

## What we're building

2–3 sentences. What is the feature and what problem does it solve?

---

## Who it's for

- **Customer segments:** [exact names — e.g. "sellers and buyers", not "all entity types"]
- **Geographies:** [exact list — e.g. "Singapore, India, Indonesia", not "APAC"]
- **Entity types affected:** [exact names you've defined — no expansion]

---

## What's changing

Describe what is new or different. Cover:
- User-facing changes (merchant dashboard, onboarding flow, checkout)
- API or integration changes (new endpoints, webhook events, schema changes)
- Internal operational changes (settlement logic, reconciliation, ops tooling)
- Data changes (new events, new fields, schema migrations)

---

## Technical details

- **Payment rails / PSPs involved:** [name them — e.g. "Stripe, BVNK" or "none"]
- **New transaction types introduced:** Yes / No — [if yes, describe briefly]
- **Sardine involved?** Yes / No — [if yes, describe what flow/data is affected]
- **Forter involved?** Yes / No — [if yes, describe what flow/data is affected]
- **New corridors or currencies:** [list, or "none"]
- **Rollout strategy:** Flag-gated / Gradual rollout / Hard cutover
- **Services affected:** [list service names if known]

---

## Commercial and financial

- **Revenue model:** [how does this generate or affect revenue — fees, take rate, etc.]
- **Expected transaction volumes:** [estimates are fine — e.g. "$X/month by end of Q3"]
- **Cost drivers:** [scheme fees, processing costs, partner fees — if known]

---

## Compliance and regulatory

- **Target jurisdictions:** [exact list]
- **Licence implications:** [does this require new licence coverage or regulator notification?]
- **KYC/KYB impact:** [does this change onboarding requirements or entity acceptance criteria?]
- **AML/monitoring impact:** [does this introduce new transaction types or corridors for TM?]
- **Data protection:** [does this introduce new data categories or cross-border data transfers?]

---

## Risk

- **Key risk vectors:** [describe 1–3 specific risks — fraud surface, credit exposure, etc.]
- **Mitigations in place:** [what controls exist or are being added]
- **Open risk questions:** [what hasn't been resolved yet]

---

## Timeline and rollout

- **Go-live date:**
- **Rollout stages:** [if gradual — e.g. "5% traffic from Day 1, full rollout by Day 14"]
- **Rollback plan:** [brief description]
- **Bug-watch period:** [e.g. "72 hours post-deploy, owner: [name]"]

---

## Open questions

List anything that is still unresolved at the time of writing. The launch-notes output will flag these per team.

- [ ] Question 1
- [ ] Question 2

---

## Out of scope

Explicitly list what this feature does NOT include, to prevent teams from assuming it does.

-
-
