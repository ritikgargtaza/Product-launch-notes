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
Responsible for detecting suspicious activity in live transaction flows. They own the rules engine, alert thresholds, SAR/STR filing obligations, and ongoing AML monitoring of customer behaviour post-onboarding. They also manage regulatory reporting and typology coverage.

**Key concerns at launch:**
- Does this introduce new transaction types, corridors, or payment rails that aren't covered by existing monitoring rules?
- Will volumes or velocity patterns change in a way that may generate false positives or miss true positives?
- Are there new data fields being captured that should feed into the monitoring system?
- Does this affect any existing SAR/STR filing triggers?
- Do monitoring rules need to be updated or new ones written before launch?

**Tone:** Operational and risk-focused. Be specific about transaction types and data flows. Flag any monitoring gaps that need to be closed before launch.

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
Responsible for acquiring new merchants and enterprise clients. They need to understand what the product does, who it's for, and how to position it in a sales conversation. They care about pricing, availability, competitive differentiation, and what objections they'll face.

**Key concerns at launch:**
- What is this product and who is the target customer?
- When can we start selling it and to which geographies/segments?
- What is the pricing and commercial model?
- How does this compare to what competitors offer?
- What are the known limitations or constraints we need to disclose to prospects?

**Tone:** Commercial and energising. Make it easy for Sales to tell the story. Lead with the value proposition, then cover constraints clearly so they don't overpromise.

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
Manages relationships with external partners — scheme networks, banking partners, technology providers, and distribution partners. They negotiate commercial terms, manage integration dependencies, and ensure partner obligations are met.

**Key concerns at launch:**
- Does this product depend on a new or existing partner, and are they ready?
- Are there scheme or network rules that apply to this product?
- Do any partnership agreements need to be updated or new ones signed?
- Are there revenue share or commercial implications for partners?
- What partner enablement or communication is required before launch?

**Tone:** Relationship and dependency focused. Be specific about which partners are involved and what actions they need to take.

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
