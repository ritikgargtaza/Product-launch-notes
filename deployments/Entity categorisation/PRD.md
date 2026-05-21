# Entity Categorisation

# Overview

**Problem Statement 1 -**
Today when the compliance team wants to figure out the category of an entity (A, B, or C), they need to look at multiple Jira tickets to piece together the information. There is no single source of truth on the ops dashboard that tells you what category a merchant falls under. This slows down decision-making and creates room for human error in applying the right compliance rules.

**Problem Statement 2 -**
Once the category is known, the configs that should flow from it (Sardine hard stops, entity approval requirements, soft onboarding settings) are applied manually. We need to add automated controls in product to set all these configurations.

**Problem Statement 3 -**
During KYB, the merchant's service provider type (TSP vs PSP) is not captured in a structured way. The compliance team uses this signal to help determine categorisation, but today it only surfaces during C2C calls and lives in unstructured notes. Licenses upload is also manual — handled offline during C2C calls rather than as part of the KYB flow. The idea is to bring the service provider type and licenses on product.
Today there is no license lifecycle management in place, there is only KYB re-review in place during which we also check if the license is expired and ask for a renewed one. But the license could very well expire before KYB re-review, so license lifecycle needs to be maintained separately. 

**Proposed Solution -**
We will add a **categorisation section** to the KYB risk section on the ops dashboard where compliance can categorise any OBO merchant into **Category** (A / B / C) for payout usecase. When a category is set or changed , we auto-apply the corresponding Sardine rules and platform configs for payouts.

We will also store the `service_provider_type` and PSP licenses (along with expiry dates) for a merchant on the ops dashboard.

---

# User Stories

## Part 1 : Ops Dashboard — Entity Categorisation

### MUS1 → Ops user wants to assign a risk category to a merchant for on behalf of payouts.

### User and Objectives

- The user is an **ops/compliance team member**
- Their objective is to set the entity category (A, B, or C) from the ops dashboard so that downstream configs and rules are applied for the correct transaction type

### Functional Requirements and Validations

1. Add a **OBO Payout** **Compliance** **categorisation** section in the KYB risk section on the ops dashboard
- **Category** dropdown: `Category A - Whitelisted`, `Category B - Monitoring`, `Category C - Enhanced Monitoring`
1. Categorisation is **not mandatory** — a KYB can be approved without any category being set. 
2. The fields can be updated at any time post-KYB as well (not locked after approval). If the config is not set then apply the rules and configs on basis of category C for any OBO transactions.
3. When a categorisation is added, edited, log the change with `updated_by`, `updated_at`, `previous_value`, `new_value, Comments (free text field)` for audit trail
- Key Decisions -
    1. Category is intentionally decoupled from KYB approval — onboarding may not have enough signal to categorise at the time of KYB approval, and thats fine. This might only be available after C2C call
    2. This field will be behind RBAC, and can only be updated by compliance team members, lets give permissions to @Toh Hwee Min @Arnaud Wenger  to start and then we can extend
    3. Today this categorisation is only done for OBO payouts.

---

### MUS2 → When category is set , auto-apply platform configs for payouts.

### User and Objectives

- The user is the **system** (automated config application)
- The objective is to ensure the right platform configs are applied based on categorisation.

### Functional Requirements and Validations

When a category is set or changed , we apply system configs .

**Existing Configs (already available)**

- `Simplified entity creation` (a.k.a. soft onboarding / enable entity creation)
- `Mandatory entity approval required for creating OBO payout`
- `Mandatory entity approval required for collection account creation`

**When Payout category is set:**

| Config | Category A | Category B | Category C |
| --- | --- | --- | --- |
| `Simplified entity creation` | Yes | No | No |
| `Mandatory entity approval required for creating OBO payout` | No | Yes | Yes |
1. **Simplified entity** -  The simplified entity creation config only applies to entity created for payouts, If the entity is created for collects or for both payouts and collects , we need to perform full KYB, this decision can be made on per entity basis depending on the purpose of creation. 
    1. If purpose of entity creation is collect or collect and payout , then do full KYB irrespective of the simplified entity config from both dashboard and API. 
    
    **Note - For a entity created for collect, there needs to be full kyb done and entity approval is required before collection account creation for all merchants** 
    
2. After these configs are applied , ops team can still go and change any configs manually according to requirement.
3. The configs will be set by system only at the time when the category is set or updated. Post that any one can go and change the configs manually, there should be **no check or cron job** running to reset the configs based on category.

---

### MUS5 → Add Sardine rule for category-based transaction monitoring per usecase

### User and Objectives

- The user is the **system** (Sardine rule evaluation)
- The objective is to have Sardine evaluate OBO transactions against the merchant's category for the relevant usecase and apply hard stops accordingly

### Functional Requirements and Validations

1. We need to **start sending the merchant’s payout compliance category to Sardine** as part of the transaction payload. Sardine needs to know both the transaction type and the category assigned to the merchant.
2. Add **one rule** in Sardine:

**Rule — Category B or C for the transaction's usecase: Hard stop**

- When a transaction hits Sardine, determine if it is an OBO payout.
- Look up the merchant's category.
- If the category is `category_b` or `category_c`, move the transaction to **hard stop**
- If the category is `category_a` , the rule does not fire — transaction flows normally
1. There is **no transaction count threshold**. Compliance monitors hard-stopped transactions as they come in. When they are comfortable, they upgrade the category for that usecase from the ops dashboard

**How it works end-to-end:**

- Ops sets category on dashboard (MUS1) → categories are stored for a merchant
- When an OBO payout is created, we send the merchant's category to Sardine
- Sardine evaluates the transaction against the rule and applies hard stop if B or C
- Compliance reviews hard-stopped transactions, and when satisfied, upgrades the category for that usecase on the dashboard
- Upgraded usecase's next transaction flows through without hard stop

**Example:**

A merchant has Payout = Category A, another has Payout = Category C

- OBO payout transaction → Sardine sees `category_a` for payout → no hard stop, flows normally
- OBO collect transaction → Sardine sees `category_c` for payouts → hard stop

**Summary Table**

| Category for Usecase | Sardine Behaviour |
| --- | --- |
| A | No hard stop — transactions flow normally |
| B | All OBO txns for that usecase → hard stop (until compliance upgrades to A) |
| C | All OBO txns for that usecase → hard stop (until compliance upgrades to A) |
| Not Set | All OBO txns for that usecase → hard stop (until compliance upgrades to B or A) |
- Key Decisions -
    1. Single rule on Sardine — it checks the category for the payout transaction and fires if B or C. 
    2. The difference between B and C is not in system behaviour (both get hard stops) but in compliance's internal assessment of risk. Category C merchants will typically be monitored longer before upgrade compared to B
    3. When a category is **changed** for a usecase, the new category value flows to Sardine on the next transaction for that usecase — no rule cleanup needed
    4. We are **not** creating per-merchant rules in Sardine. One global rule, category value per transaction determines if it fires
    5. OBO Transactions for a usecase with no category set ("Not Set") flow through  — **same as Category C behaviour**

---

## Part 2 : KYB Flow — Service Provider Type & Licenses

### MUS3 → Service provider type is auto-set based on industry vertical, with compliance override and license management

### User and Objectives

- The user is an **ops/compliance team member**
- Their objective is to see the merchant's service provider type (TSP / PSP), override it if needed, and ensure PSP merchants have licenses on file

### Functional Requirements and Validations

**Default Value from Industry Vertical**

1. When a merchant completes KYB, the system sets a **default service provider type** based on the merchant's industry vertical:
    - Verticals like "Money Services Business", "Payment Facilitator", "Financial Services", "Remittance" → default to **PSP**
    - Verticals like "SaaS", "Marketplace", "E-commerce Platform", "Travel", "EdTech" → default to **TSP**
    - Ambiguous verticals like "Fintech", "Lending", "Insurance" → default to **TSP** (compliance can override)
2. The full vertical-to-service-provider-type mapping will need to be defined with compliance before launch - https://docs.google.com/spreadsheets/d/1jz-KXtHViSgiMXCDSV9qPiKGN67Bc8d0xinmQxW-pCM/edit?gid=327524578#gid=327524578
3. Once industry vertical is selected , this field will be auto populated but will be editable.(lets show this field below the industry vertical 
    1. If PSP is auto populated, then we need to validate if PSP license exists, otherwise we cannot allow to move to the next state, either they need to change to TSP or upload document for PSP if not already present.

**Ops Dashboard — Service Provider Type**

1. Display the **Service Provider Type** field on the ops dashboard in the KYB detail view, showing the current value (TSP or PSP) and whether it was auto-set or manually overridden
2. Compliance can **change** the service provider type from TSP → PSP or PSP → TSP at any time
3. **When compliance changes the value from TSP → PSP:**
    - Check if the merchant already has at least one license uploaded
    - If **no license exists** → compliance must upload at least one license along with expiry date before the change can be saved. Show a license upload prompt as part of the change flow
    - If **license already exists** (merchant uploaded during KYB or compliance uploaded earlier) → change is saved directly, no additional upload required
4. **When compliance changes the value from PSP → TSP:**
    - No license check needed — change saves directly
    - Existing uploaded licenses remain on file (we dont delete them)

**Merchant KYB Form — PSP License Upload**

1. During KYB, show an **optional** field labeled **"PSP License"** where the merchant can upload license documents along with a date field [expiry date]. Add description - Required if you are a payment service provider.
    - Support multiple file uploads (PDF, JPG, PNG)
    - Each upload should allow a label/description field (e.g., "MAS License", "FCA Authorization")
    - This field is **optional** — KYB can be submitted without uploading any licenses
    - If this document is uploaded we can simply mark the merchant as PSP.
2. Uploaded license files should be stored and viewable **only on the ops dashboard** in the KYB detail view
3. **Licenses will NOT be shown on the merchant dashboard KYB details section** — this is intentional for security reasons. Merchants upload, ops reviews. The merchant does not get a read-back view of uploaded licenses
4. Ops should be able to download and review uploaded licenses from the dashboard

**License Expiry Tracking & Dashboard Tags**

1. Track expiry date for each uploaded license
2. **1 month before any license expires**, show a warning tag on the ops dashboard profile:
    - Tag text: `PSP License Expiring on [DD MMM YYYY]` (e.g., "PSP License Expiring on 15 May 2026")
    - Tag style: warning/amber — similar to the "KYB Refresh Due" tag
3. **Once a license has expired**, change the tag to:
    - Tag text: `PSP License Expired on [DD MMM YYYY]`
    - Tag style: error/red
4. If a merchant has **multiple licenses**, the tag should reflect the **earliest expiring or already expired** license. We track expiry per license but only show one tag on the dashboard — whichever is most urgent
5. When a new/renewed license is uploaded that covers the expired one, the tag should update accordingly (either show the next upcoming expiry, or disappear if all licenses are valid)
6. The same should reflect on the actions required tab on the merchant dashboard as well

**Merchant Listing Screen on ops dashboard — Filters**

1. Add filters on the **merchant listing screen** to help ops identify merchants needing attention:
    - **KYB Refresh Due** filter — shows merchants where KYB refresh is pending
    - **License Renewal Due** filter — shows merchants where at least one PSP license is expiring within 1 month or has already expired
2. These filters help compliance proactively manage renewals instead of reactively finding out

**Reporting Implications**

1. The service provider type determines **reporting obligations** for Tazapay:
    - **TSP (Technical Service Provider)** — the entities under this merchant are considered **Tazapay's customers**. They need to be reflected in Tazapay's regulatory reporting accordingly
    - **PSP (Payment Service Provider)** — the entities under this merchant are **not** Tazapay's customers for reporting purposes. The reporting obligation sits with the PSP, not with Tazapay
2. This distinction should be stored and queryable on ops dashboard merchant listing screen so that reporting systems can filter entities based on the merchant's service provider type
3. Display this reporting implication clearly on the ops dashboard next to the service provider type field — e.g., when TSP is selected, show a note: `Entities are Tazapay's customers — reporting applies`. When PSP: `Entities are not Tazapay's customers — reporting does not apply`
- Key Decisions -
    1. Service provider type is an **internal field** — the merchant does not select TSP or PSP. The system sets a default based on industry vertical and compliance confirms or overrides
    2. The default mapping from industry vertical is a best-effort heuristic. Ambiguous verticals default to TSP (lower risk default). Compliance is expected to review and override during or after C2C call
    3. License upload during KYB is optional and labeled "PSP License" — this nudges PSP merchants to upload upfront, but doesn’t block TSP merchants or merchants who don’t have licenses ready yet
    4. The enforcement point for PSP licenses is on the **compliance side** — when compliance marks a merchant as PSP and no license exists, they must upload one. This keeps KYB friction low for merchants while ensuring compliance has what they need
    5. License expiry is tracked per license, but the dashboard shows one tag based on the most urgent (earliest expiring or already expired). This keeps the UI clean while still tracking everything
    6. The 1-month warning window gives compliance enough time to follow up with the merchant for renewal. In the future we will add emailers to merchants for proactive renewal reminders
    7. Today licenses are handled manually during C2C calls — bringing it into the product removes a friction point and creates a paper trail
    8. We are **not** doing license verification/validation in this phase — this is purely capture and display. Compliance will review manually
    9. File size limit: 10MB per file, max 10 files
    10. No merchant-side visibility of uploaded licenses post-submission — security requirement
    11. The TSP/PSP reporting distinction is critical for regulatory compliance. This needs to be queryable so downstream reporting systems can pull the right set of entities

---

# Acceptance Criteria

1. Ops user can add usecase-category pairs from the KYB risk section on the ops dashboard via "Add Compliance Categorisation" flow
2. Each usecase can only have one category at a time — no duplicates
3. Category entries can be edited or removed
4. Category fields are not mandatory for KYB approval
5. Category fields are RBAC-protected — only compliance team members can update
6. Setting Payout Category B or C auto-applies: entity approval required for OBO payout
7. Setting Collects Category B or C auto-applies: entity approval required for collection account creation 
8. If only Payout usecase if selected then only simplified entity will be turned on, in case collect usecase is enabled , simplified entity will be turned off.
9. After these configs are applied , ops team can still go and change any configs manually according to requirement
10. Changing category for one usecase does not affect configs for the other usecase
11. Changing category overwrites old configs for that usecase (idempotent)
12. Merchant category per usecase is sent to Sardine with each OBO transaction
13. Sardine hard stops all OBO txns where the usecase category is B or C or not set (single rule)
14. OBO Transactions where the usecase category is A flow through without hard stops
15. Upgrading a usecase category from B/C → A stops hard stops for that usecase on the next transaction
16. Service provider type is a mandatory field during KYB — options: Technical Service Provider, Payment Service Provider
17. License upload section appears only when PSP is selected, and is mandatory in that case
18. Uploaded licenses are viewable on ops dashboard only, not on merchant dashboard
19. Ops can view service provider type and download uploaded licenses from the dashboard
20. All category changes are audit-logged with usecase context

---

# Business Metrics

**Compliance controls** 

- Increase in the number of merchants for whom all the compliance controls are set in the system.

**Operational Efficiency**

- Check with compliance on reduction of manual effort to set Sardine rules on each merchant and setting configs for each merchant — this should go down significantly with automation

**Adoption**

- For how many merchants doing OBO transactions is the entity category stored — lets track this as a coverage metric per usecase. Ideally 100% of active OBO merchants should have a category assigned for each usecase they are active on

---

# Scratchpad (not for review)

## Entity Category Reference (per usecase)

| Category | Risk Level | Sardine Rule (for that usecase) | Payout Config (if payout usecase) | Soft Onboarding |
| --- | --- | --- | --- | --- |
| A | Low (Whitelisted) | None | Submission required | Enabled |
| B | Medium (Monitored) | All OBO txns → hard stop | Approval required | Enabled |
| C | High | All OBO txns → hard stop | Approval required | Enabled |

## Example: Merchant with split categories

| Usecase | Category | Sardine Behaviour | Entity Requirement |
| --- | --- | --- | --- |
| Payout | A | No hard stop | Submission required for OBO payout |
| Collects | C | All OBO collect txns → hard stop | Approval required for collection account |

This merchant's payout transactions flow normally while all collect transactions go to hard stop for compliance review.

### MUS3 → Merchant wants to upload licenses during KYB

### User and Objectives

- The user is a **merchant** going through KYB
- Their objective is to declare whether they are a TSP or PSP as part of KYB onboarding, and if PSP, upload their relevant licenses

### Functional Requirements and Validations

1. Add a **Service Provider Type** dropdown to the KYB form
    - Options: `Technical Service Provider`, `Payment Service Provider`
    - This field is **mandatory** — KYB cannot be submitted without selecting a service provider type
2. When the merchant selects **Payment Service Provider**, show a **license upload** section
    - Support multiple file uploads (PDF, JPG, PNG)
    - Each upload should allow a label/description field (e.g., "MAS License", "FCA Authorization")
    - **License upload is mandatory for PSP** — the merchant cannot submit KYB without uploading at least one license
3. When the merchant selects **Technical Service Provider**, the license upload section is **hidden** — no license required
4. Display service provider type on the ops dashboard in the KYB detail view so compliance can use it as a signal for categorisation
5. The service provider type value should be editable by ops from the dashboard as well (in case the merchant gets it wrong or it changes)
6. Uploaded license files should be stored and viewable **only on the ops dashboard** in the KYB detail view
7. **Licenses will NOT be shown on the merchant dashboard KYB details section** — this is intentional for security reasons. Merchants upload, ops reviews. The merchant does not get a read-back view of uploaded licenses
8. Ops should be able to download and review uploaded licenses from the dashboard
- Key Decisions -
    1. TSP vs PSP is a key signal for compliance to determine categorization — TSPs are generally lower risk. We surface this prominently next to the categorisation section on the ops dashboard
    2. License upload is conditionally mandatory — only when PSP is selected. TSPs dont need to upload licenses
    3. Today licenses are handled manually during C2C calls — bringing it into the product removes a friction point and creates a paper trail
    4. We are **not** doing license verification/validation in this phase — this is purely capture and display. Compliance will review manually
    5. File size limit: 10MB per file, max 10 files **(Engineering can confirm)**
    6. No merchant-side visibility of uploaded licenses post-submission — security requirement

[Compliance: Onboarding — Entity Categorisation](https://www.notion.so/Compliance-Onboarding-Entity-Categorisation-350c765b7248812ba9a1c984d729d4e0?pvs=21)

[Engineering — Entity Categorisation](https://www.notion.so/Engineering-Entity-Categorisation-350c765b724881b8a875d84d7fa773c3?pvs=21)

[Risk — Entity Categorisation](https://www.notion.so/Risk-Entity-Categorisation-350c765b7248816aa346f17753484a3d?pvs=21)

[Compliance: Transaction Monitoring — Entity Categorisation](https://www.notion.so/Compliance-Transaction-Monitoring-Entity-Categorisation-350c765b72488199810cd889b2089f9c?pvs=21)

[Payment Operations — Entity Categorisation](https://www.notion.so/Payment-Operations-Entity-Categorisation-350c765b724881cf86e7d329fcc274cd?pvs=21)

[Treasury — Entity Categorisation](https://www.notion.so/Treasury-Entity-Categorisation-350c765b724881878093cebc5b1e3ba7?pvs=21)

[Sales — Entity Categorisation](https://www.notion.so/Sales-Entity-Categorisation-350c765b7248817cb137f2900c053b58?pvs=21)

[Account Management — Entity Categorisation](https://www.notion.so/Account-Management-Entity-Categorisation-350c765b724881b0a7e2c47aab396113?pvs=21)

[Partnerships — Entity Categorisation](https://www.notion.so/Partnerships-Entity-Categorisation-350c765b724881999ebafa015d468936?pvs=21)

[Legal — Entity Categorisation](https://www.notion.so/Legal-Entity-Categorisation-350c765b7248816491f7ca41bd2dc537?pvs=21)

[Finance — Entity Categorisation](https://www.notion.so/Finance-Entity-Categorisation-350c765b72488134a8a1c7be51994b2e?pvs=21)

[Licensing — Entity Categorisation](https://www.notion.so/Licensing-Entity-Categorisation-350c765b724881f59230dbf0b35fbf6f?pvs=21)

[Product: Payments Pod — Entity Categorisation](https://www.notion.so/Product-Payments-Pod-Entity-Categorisation-350c765b72488120a4e3c321d1ccde35?pvs=21)

[Product: Operations Pod — Entity Categorisation](https://www.notion.so/Product-Operations-Pod-Entity-Categorisation-350c765b72488196b7b7e327fe0d3445?pvs=21)

[Product: Merchant Pod — Entity Categorisation](https://www.notion.so/Product-Merchant-Pod-Entity-Categorisation-350c765b72488104a3ebdaec974a15f1?pvs=21)

[Product: Data Pod — Entity Categorisation](https://www.notion.so/Product-Data-Pod-Entity-Categorisation-350c765b72488122836ec5f787e8724b?pvs=21)