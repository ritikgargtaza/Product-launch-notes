# Team Descriptions — Pre-Launch Notes Reference

> **Usage instruction for Claude:**
> When generating pre-launch notes from a PRD, read this file first.
> For each team below, use their Function, Key Concerns, and Tone to write a tailored note.
> Do not summarise the PRD generically — translate the PRD's impact into language that is specific and meaningful for each team's day-to-day responsibilities.

---

## 1. Compliance — Onboarding

**Function:**
Responsible for customer acceptance policies, KYC/KYB program design, and regulatory obligations at the point of onboarding. They define what documentation is required, set risk-based acceptance criteria, and ensure the company meets AML and sanctions screening requirements before a customer is activated.

**Key concerns at launch:**
- Does this change who we can onboard, or what data we collect at onboarding?
- Are there new customer segments, geographies, or entity types that require updated CDD/EDD procedures?
- Does the product introduce new onboarding flows that need compliance sign-off?
- Are sanctions screening and PEP checks still applied correctly in any new flow?
- Do we need to update the onboarding policy or risk appetite statement?

**Tone:** Regulatory and procedural. Be precise about obligations. Flag anything that requires a policy update or sign-off before go-live.

---

## 2. Compliance — Transaction Monitoring

**Function:**
Investigates suspicious activity and takes immediate action to contain risk — disabling payment methods, holding payouts, and restricting merchant accounts. Enforces velocity limits, exposure caps, and reserves. Tracks fraud losses, chargebacks, and merchant balances daily. Identifies unusual spikes or patterns and escalates quickly. Manages merchant risk by reviewing performance and adjusting limits or controls. Supports chargeback handling and recovery. Provides feedback to Product to close risk gaps. Maintains escalation paths to prevent loss from spreading.

**Key concerns at launch:**
- Does this introduce new transaction types, corridors, or merchants not covered by existing monitoring rules?
- Will velocity patterns, volumes, or exposure build-up look different — and will current thresholds catch it?
- Are there new fraud vectors or abuse patterns this feature could enable?
- Do velocity limits, exposure caps, or reserves need reconfiguring before go-live?
- Are new data fields captured and feeding into the monitoring system correctly?
- If something goes wrong post-launch, is the escalation path clear and fast enough to contain it?

**Tone:** Operational and direct. Focus on what changes in their daily monitoring and control enforcement. Flag rule coverage gaps, new risk patterns, and actions needed before launch.

---

## 3. Risk

**Function:**
Owns the company's risk framework across credit risk, fraud risk, and operational risk. Sets exposure limits, counter-party risk policies, and loss tolerance thresholds. Works closely with Compliance, Finance, and Product to ensure new products don't introduce unacceptable risk concentrations.

**Key concerns at launch:**
- What is the fraud or credit exposure introduced by this product?
- Are existing risk controls (velocity limits, exposure caps, fraud models) sufficient?
- Does this change our counter-party or settlement risk profile?
- Are there scenarios where the company could face unexpected financial loss?
- What are the top 3 risk scenarios and have they been mitigated?

**Tone:** Analytical and direct. Lead with exposure and mitigation. Risk teams want to see that someone has thought through failure modes.

---

## 4. Payment Operations

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

## 5. Growth — Sales

**Function:**
Acquires new merchants and enterprise clients. Before a launch, they need to know what the feature does in plain language, who it's for, and whether supporting material is ready — product one-pager, Figma/demo video if available, API docs published. They also need confidence that Compliance, Risk, Ops, and other relevant teams are aligned and ready to deliver. Complex prospect questions are escalated to Product.

**Key concerns at launch:**
- What does this feature do and who is the target customer — in plain, pitchable language?
- Is there a Figma, demo video, or visual available to use in prospect conversations?
- Are API docs published and accessible to share?
- Are Compliance, Risk, and Ops aligned — can we actually deliver what we're selling?
- What limitations or constraints need to be disclosed so Sales doesn't overpromise?
- Which geographies and segments are in scope at launch?

**Tone:** Clear and commercial. Lead with what Sales can now say to a prospect. Flag any readiness gaps that would block them from selling confidently. No pricing detail needed.

---

## 6. Growth — Account Management

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

## 7. Partnerships

**Function:**
Operates on two tracks: (1) **Payment rail partners** — works with PSPs, banks, and payment networks to enable money movement across corridors and rails, including sourcing new partners, negotiating commercial terms, and managing ongoing relationships to keep rails live and commercially viable. (2) **Referral and lead-gen partners** — manages relationships with partners who bring in merchant leads, including onboarding referral partners and ensuring they have what they need to position Tazapay effectively.

**Key concerns at launch:**
- Does this feature depend on a payment rail partner being ready — has the integration been confirmed and tested?
- Does it open a new corridor or rail that Partnerships needs to have negotiated access to?
- Are existing commercial terms with rail partners sufficient to cover this use case, or do agreements need amending?
- Is this something referral partners can pitch to their merchant networks — and do they need a briefing or updated collateral?
- Which partners need to be looped in before go-live, not after?

**Tone:** Commercially aware, relationship-focused. Be specific about which type of partner is affected — rail partner or referral partner — and what action is needed from each.

---

## 8. Legal

**Function:**
Responsible for contracts, regulatory legal advice, intellectual property, and corporate risk. They review product terms, merchant agreements, and ensure the company is operating within its legal obligations. They also advise on regulatory perimeter questions.

**Key concerns at launch:**
- Do existing contracts (merchant agreements, partner agreements) cover this product?
- Are there new terms of service or legal disclosures required?
- Are there any regulatory perimeter questions — does this require a new licence or permission?
- Are there IP or data protection considerations?
- Is there anything in the product design that creates legal liability?

**Tone:** Precise and cautious. Flag open legal questions clearly. Legal teams want to know what they need to review and sign off before launch, not after.

---

## 9. Finance

**Function:**
Responsible for financial reporting, revenue recognition, cost management, and treasury oversight. At launch they need to understand how the product affects P&L, how revenue will be booked, and what financial controls are needed.

**Key concerns at launch:**
- How is revenue generated and recognised for this product?
- What are the direct costs (scheme fees, processing costs, partner fees)?
- Are there any float, settlement, or balance sheet implications?
- How will this be tracked in financial reporting?
- Are there any tax implications or inter-company considerations?

**Tone:** Financial and structured. Be specific about revenue model, cost drivers, and reporting. Finance teams need clarity on how numbers will flow before they can model it.

---

## 10. Product — Payments Pod

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

## 11. Product — Operations Pod

**Function:**
Owns internal tooling — dashboards, ops portals, back-office systems, and the tools that support Payment Operations, Compliance, and Support teams. They ensure internal users have what they need to operate the product.

**Key concerns at launch:**
- Do internal tools need to be updated to support this product?
- Can ops teams action exceptions, view transaction state, and manage disputes?
- Are there new internal workflows that need tooling support?
- What does the support runbook look like?
- Are there any reporting or visibility gaps in current tooling?

**Tone:** Operational and user-focused (internal users). Focus on what ops teams will need on day one to run this without friction.

---

## 12. Product — Merchant Pod

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

## 13. Product — Data

**Function:**
Owns data infrastructure, analytics instrumentation, and reporting pipelines. They ensure that new products are properly instrumented, that data is captured correctly, and that business teams can measure performance.

**Key concerns at launch:**
- What new events, fields, or entities does this product introduce?
- Are tracking and instrumentation defined and implemented?
- Are there new dashboards or reports needed at launch?
- Will existing data models or pipelines be affected?
- How will success metrics be measured and by whom?

**Tone:** Technical and metric-focused. Be specific about what data needs to be captured and how success will be measured.

---

## 14. Engineering

**Function:**
Responsible for building, testing, and deploying the product. They own code quality, system reliability, deployment processes, and technical debt. At launch they need clear scope, dependencies, and rollback plans.

**Key concerns at launch:**
- Is the scope fully defined and are all dependencies resolved?
- What is the deployment plan and rollback strategy?
- Are there performance, security, or scalability concerns?
- What monitoring and alerting will be in place at launch?
- Are there technical risks that haven't been fully mitigated?

**Tone:** Technical and concrete. Engineering teams want specifics — not vague references to "the system". Be clear about what's in scope, what's out, and what the failure plan is.

---

## 15. Licensing

**Function:**
Manages the company's regulatory licences and permissions — payment institution licences, e-money licences, and any jurisdiction-specific authorisations. They track licence conditions, manage regulator relationships, and ensure new products operate within licensed permissions.

**Key concerns at launch:**
- Does this product fall within our current licence permissions in each target geography?
- Do we need to notify or seek approval from any regulator before launching?
- Are there licence conditions that constrain how this product can be structured?
- Does this affect our regulatory capital requirements?
- Are there any upcoming licence renewals or audits this could affect?

**Tone:** Regulatory and jurisdiction-specific. Be precise about geographies and licence types. Flag any out-of-scope activity that requires a new permission or notification.

---

## 16. Treasury

**Function:**
Manages the company's liquidity, float, and settlement accounts. They ensure sufficient funding is in place to settle transactions, manage FX exposure, and optimise the use of company funds across accounts and geographies.

**Key concerns at launch:**
- Does this product change our settlement timing, float requirements, or liquidity needs?
- Are there new currencies or FX exposures introduced?
- Do we need to pre-fund new accounts or increase existing limits?
- What is the expected settlement volume and peak exposure?
- Are there any changes to our banking arrangements needed to support this?

**Tone:** Financial and liquidity-focused. Be specific about settlement mechanics, FX, and funding requirements. Treasury needs to plan ahead — flag anything that requires pre-launch account setup or limit increases.
