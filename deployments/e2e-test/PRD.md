# Checkout on Behalf Of (Checkout OBO)

# Overview

- For Tazapay facilitating checkout and payment acceptance on behalf of its user’s partners/businesses, Tazapay needs to know who the ultimate receiver of the funds is.
- Merchants can create entities and request to create checkout sessions and process payins in their entity’s name to receive funds.

# Use Cases

## Commerce & Marketplace

1. **Marketplace Platform**: A marketplace creates checkout sessions on behalf of individual sellers, with funds flowing directly to the seller’s entity
2. **Payment Aggregator**: A payment aggregator processes payments on behalf of multiple merchants using a single parent account
3. **Multi-Vendor E-commerce**: An e-commerce platform manages checkout for multiple vendors, each receiving payments under their own entity

## Remittance & Money Transfer

1. **Wallet Topup Service**: A remittance platform allows users to topup digital wallets on behalf of beneficiaries (e.g., family members abroad), with funds credited to the beneficiary’s entity/wallet
2. **Cross-Border Remittance**: A money transfer service processes payments on behalf of licensed remittance agents or partner entities in different countries
3. **Bill Payment Platform**: A bill payment aggregator collects payments on behalf of utility companies, telecom providers, or other service entities
4. **Mobile Money Topup**: A platform enables international topups for mobile money accounts, processing payments on behalf of mobile network operators or wallet providers

## Financial Services

1. **Digital Wallet Recharge**: Fintech platforms allowing users to recharge prepaid wallets, gift cards, or accounts belonging to third-party entities
2. **Remittance Agent Network**: A parent company managing checkout sessions on behalf of a network of authorized remittance agents or subagents

# Entity Types & Categories

To support diverse use cases from commerce to remittance, entities can be categorized by type:

## Entity Type Classification

| Category | Entity Types | Examples | Primary Use Case |
| --- | --- | --- | --- |
| **Commerce** | Seller, Merchant, Vendor | Marketplace sellers, individual stores | E-commerce, marketplace payments |
| **Remittance** | Money Transfer Operator, Remittance Agent, Subagent | First party topups | First Party Topups |
| **Financial Services** | Wallet Provider, Mobile Money Operator, Telecom | GCash, M-Pesa, Telecom companies | Wallet topups, mobile money |
| **Utilities & Services** | Utility Company, Service Provider, Biller | Electric company, water utility, ISP | Bill payments |

# Changes to the Checkout API

## API Endpoint

`POST /v3/checkout`

## New Field Addition

Add an optional field to the checkout creation API:

| Field | Type | Mandatory (Y/N) | Description |
| --- | --- | --- | --- |
| on_behalf_of | string | N | ID of the entity who is the ultimate receiver of the funds |

## Validation Rules

- If `on_behalf_of` is provided, the entity must exist and belong to the merchant account
- If `Mandatory entity approval required for checkout creation` config is enabled, the entity must have `approval_status = approved`
- The entity ID must be valid and active
- If entity approval config is enabled but entity is not approved, API returns error:
    
    ```json
    {
      "code": "entity_not_approved",
      "message": "The entity must be approved before creating checkout on their behalf",
      "entity_id": "ent_xxxx"
    }
    ```
    

## Request Example

```json
{
  "invoice_currency": "USD",
  "amount": 10000,
  "customer_details": {
    "name": "John Doe",
    "email": "john@example.com",
    "country": "US"
  },
  "success_url": "https://example.com/success",
  "cancel_url": "https://example.com/cancel",
  "transaction_description": "Product Purchase",
  "on_behalf_of": "ent_abc123xyz",
  "reference_id": "order_12345"
}
```

## Response Enhancement

The checkout response object will include the `on_behalf_of` field:

```json
{
  "id": "chk_xxxx",
  "url": "https://checkout.tazapay.com/session/chk_xxxx",
  "on_behalf_of": "ent_abc123xyz",
  "status": "created",
  ...
}
```

# Changes to the Payin API

## New Field Addition

Add an optional field to the payin object:

| Field | Type | Mandatory (Y/N) | Description |
| --- | --- | --- | --- |
| on_behalf_of | string | N | ID of the entity who is the ultimate receiver of the funds |

## Behavior

- When a checkout session with `on_behalf_of` is completed, the resulting payin automatically inherits the `on_behalf_of` value
- The payin object will include entity information in the response
- All payin webhooks will include the `on_behalf_of` field when applicable

## Response Enhancement

```json
{
  "id": "payin_xxxx",
  "amount": 10000,
  "currency": "USD",
  "on_behalf_of": "ent_abc123xyz",
  "status": "success",
  "customer": "cust_xxxx",
  ...
}
```

# Webhook Updates

## New Webhook Events

Trigger the following webhooks with `on_behalf_of` field included:

### Checkout Events

- All current events

### Payin Events

- All current events

## Webhook Payload Example

```json
{
  "event": "checkout.session_completed",
  "data": {
    "id": "chk_xxxx",
    "amount": 10000,
    "currency": "USD",
    "on_behalf_of": "ent_abc123xyz",
    "entity_details": {
      "entity_id": "ent_abc123xyz",
      "business_name": "Acme Corp",
      "email": "business@acme.com",
      "reference_id": "acme_001"
    },
    "customer_details": { ... },
    "status": "completed",
    "created_at": "2026-02-09T10:30:00Z"
  }
}
```

# Addition of New Configs on the Operations Dashboard

Add new configurations under the **“OBO (On Behalf Of)”** section on the Merchant account config tab:

## Config 1: Mandatory Entity Approval for Checkout/Payin Creation

- **Name of config**: `Mandatory entity approval required for checkout creation`
- **Description**: `Approval mandatory for checkout session creation on behalf of entities`
- **Default toggle**: `OFF` - This means entities can have checkout / payin sessions created on their behalf without approval
- **Behavior when ON**:
    - Entities can only have checkout / payin sessions created when `approval_status = approved`
    - API throws error if checkout / payin is attempted with non-approved entity
    - Error message: “The entity requires approval to create checkout on their behalf”

## Config 2: Mandatory OBO Information for Checkout/Payin

- **Name of config**: `Mandatory OBO information for checkout`
- **Description**: `Passing On Behalf Of information mandatory for creating checkout sessions`
- **Default toggle**: `OFF`
- **Behavior when ON**:
    - The `on_behalf_of` field becomes mandatory in checkout/payin API
    - API throws error if `on_behalf_of` is not provided
    - Error message: “on_behalf_of field is required for this merchant account”
    ## Update Existing Config Verbiage

For clarity and consistency, update existing OBO configs:

1. **Collection Account Config**:
    - Current: `Mandatory entity approval required for collection account creation`
    - Update to: `Mandatory entity approval required for collection account creation (Collect OBO)`
2. **Payout Config**:
    - Current: `Mandatory entity approval required for payout processing`
    - Keep as is (already clear)

# Changes to Merchant Dashboard

## Transaction Listing Screen

### Search Optimization

- Optimize search to work with:
    - `entity_id`
    - `entity.business_name`
    - `entity.reference_id`
    - `entity.email`
- Partial search should be supported for all entity fields

### Filter Enhancements (already present - lets retain the same)

~~Add `on_behalf_of` to the filters and name it `Related Entity`:~~

- **Visibility**: Only visible if `Create_entity` config is toggled ON
- **Filter Options**:
    - **All**: Shows all transactions (OBO and non-OBO)
    - **Yes**: Shows only OBO transactions
    - **No**: Shows only non-OBO transactions

## Checkout Summary Screen

Add entity information to the checkout details section:

### New Section: “Receiver Details”

- **Entity ID**: Clickable, redirects to entity details screen
- **Business Name**: Display entity business name
- **Entity Email**: Contact email for the entity
- **Entity Country**: Country of the entity
- **Entity Status**: Approval status badge (Approved, Pending, Rejected)

### Layout

## Payin Summary Screen

Add entity information to the payin details section:

### New Section: “Receiver Details”

Similar to checkout summary, include:
- Entity ID (clickable)
- Business Name
- Entity Email
- Entity Country
- Entity Status

## Transaction Reports

### Checkout Report

Add the following fields to the checkout transaction report:

| New Field | Description |
| --- | --- |
| Receiver Name | Entity business name |
| Entity ID | Unique entity identifier |
| Receiver Country | Entity country |
| Receiver Email | Entity contact email |
| Receiver Reference ID | Merchant’s reference ID for entity |
| Entity Status | Approval status |

### Payin Report

Add the following fields to the payin report:

| New Field | Description |
| --- | --- |
| Receiver Name | Entity business name |
| Entity ID | Unique entity identifier |
| Receiver Country | Entity country |
| Receiver Email | Entity contact email |
| Receiver Reference ID | Merchant’s reference ID for entity |
| Entity Status | Approval status |

### Export Format

CSV export should include all entity fields with proper headers:

```
Checkout ID,Amount,Currency,Status,Created At,Receiver Name,Entity ID,Receiver Country,Receiver Email,Receiver Reference ID,Entity Status
chk_xxxx,100.00,USD,completed,2026-02-09T10:30:00Z,Acme Corp,ent_abc123xyz,US,business@acme.com,acme_001,approved
```

# Changes to Operations Dashboard

## Checkout Listing Screen

### New Column: “Receiver Details”

Add a new column containing:
- **Entity ID**: Clickable, redirects to entity review screen
- **Entity Business Name**
- **Entity Email**
### Search Enhancement

- Optimize search to work with entity fields:
    - `entity_id`
    - `entity.business_name`
    - `entity.reference_id`
    - `entity.email`
- Support partial search

### Filter Addition

Add `on_behalf_of` filter with options:
- **All**: Shows all checkout sessions
- **Yes**: Shows only OBO checkout sessions
- **No**: Shows only non-OBO checkout sessions

## Checkout Summary Screen

### Entity Information Section

Add “Receiver Details” section in the checkout summary:

```
┌─────────────────────────────────────────┐
│ Checkout Summary                        │
├─────────────────────────────────────────┤
│ Checkout ID: chk_xxxx                   │
│ Merchant: merchant_name                 │
│ Amount: $100.00 USD                     │
│                                         │
│ Receiver Details                        │
│ Entity ID: ent_abc123xyz [link to KYB] │
│ Business Name: Acme Corp                │
│ Email: business@acme.com                │
│ Country: United States                  │
│ Approval Status: [Approved]             │
│ Industry: Technology                    │
│                                         │
│ Customer Details                        │
│ ...                                     │
└─────────────────────────────────────────┘
```

**Note**: Some entity fields may not be mandatory and will be displayed conditionally based on available information.

## Payin Listing Screen

### New Column: “Receiver Details”

Add receiver details column similar to checkout listing:
- Entity ID (clickable)
- Entity Business Name
- Entity Email

### Search & Filter

- Same search optimization as checkout listing
- Same OBO filter options

## Payin Summary Screen

Add “Receiver Details” section with entity information similar to checkout summary screen.

### Entity Listing Screen

Under submitted, have two categories
- Review Required
- Review Not Required
All entities where approval is mandatory (collects, payins, payouts) should move to Review Required; all other entities to Review Not Required

## Operations Reports

### Checkout Report

Add the following entity fields:

- Receiver Name
- Entity ID
- Receiver Country
- Receiver Email
- Receiver Approval Status
- Receiver Industry Vertical
- Receiver Reference ID
- Merchant Name (for ops visibility)
- Entity Approval Status

### Payin Report

Add the following entity fields:

- Receiver Name
- Entity ID
- Receiver Country
- Receiver Email
- Receiver Approval Status
- Receiver Industry Vertical
- Receiver Reference ID
- Merchant Name (for ops visibility)
- Entity Approval Status

# Manual Checkout Creation on Merchant Dashboard

## Enhancement to “Create Checkout” Flow

When user manually create checkout session

### Step 1: Select Account (in case of multiple accounts)

- Existing flow: Select merchant account
- No changes to this step

### Step 2: Enter Checkout Details (Enhanced)

Add new optional section: **“On Behalf Of”**. This is only visible if entity capability is enabled for the account.

### New Fields:

- **Entity Selection** (dropdown with search)
    - Search by: entity_id, business_name, reference_id, entity ID
    - Display format: `{business_name} ({entity_id})`
    - Placeholder: “Search entity by name, ID, or reference”
    - Optional field (unless config requires it)

### Validation:

- If entity is selected and `Mandatory entity approval required for checkout creation` is ON:
    - Only show approved entities in dropdown
    - If non-approved entity is somehow selected, show error: “The entity requires approval to create checkout on their behalf”
    - Grey out the “Create Checkout” button with tooltip explaining approval requirement

### Layout Enhancement for the hosted page

```
┌─────────────────────────────────────────┐
│ Create Checkout Session                 │
├─────────────────────────────────────────┤
│ Merchant Account *                      │
│ [Select Merchant ▼]                     │
│                                         │
│ Amount *                                │
│ [100.00] Currency: [USD ▼]             │
│                                         │
│ Customer Details *                      │
│ Name: [____________]                    │
│ Email: [____________]                   │                   │
│                                         │
│ Business Name: Entity Name             │
│                                         │
│ Transaction Description *               │
│ [____________]                          │
│                                         │
│ [Cancel]  [Create Checkout]            │
└─────────────────────────────────────────┘
```

# Testing Checklist

## API Testing

- [ ]  Create checkout with valid `on_behalf_of`
- [ ]  Create checkout without `on_behalf_of`
- [ ]  Create checkout with invalid entity ID
- [ ]  Create checkout with non-approved entity (config ON)
- [ ]  Verify payin inherits `on_behalf_of` from checkout
- [ ]  Verify webhook payloads include entity data

## Dashboard Testing

- [ ]  OBO flag displays correctly
- [ ]  Entity search works with partial matches
- [ ]  Filters show correct transactions
- [ ]  Summary screens display entity information
- [ ]  Reports include all entity fields
- [ ]  CSV exports contain entity data

## Config Testing

- [ ]  Toggle configs on/off
- [ ]  Verify API behavior with different config states
- [ ]  Test error messages for blocked operations
- [ ]  Verify grandfathering of existing data

## Edge Case Testing

- [ ]  Deleted entity display
- [ ]  Revoked approval handling
- [ ]  Disabled merchant impact
- [ ]  Concurrent checkout creation
- [ ]  High volume entity transactions

# FAQ

**Q: What’s the difference between Collect OBO and Checkout OBO?**

A: Collect OBO handles virtual account-based collections where funds are received passively. Checkout OBO handles active checkout sessions where customers initiate payments through a hosted checkout page or payment links.

**Q: Can a single entity have both collection accounts and checkout sessions?**

A: Yes, entities can have both. They’re independent configurations that can coexist.

**Q: What happens if an entity is deleted mid-checkout?**

A: The checkout session continues processing. Historical data is preserved. The entity shows as “(Deleted)” in dashboards and reports.

**Q: Can merchants create checkouts on behalf of entities they don’t own?**

A: No, merchants can only create OBO checkouts for entities that belong to their account.

**Q: How does refund handling work for OBO payins?**

A: Refunds maintain the `on_behalf_of` linkage. When a payin is refunded, the refund record includes the entity information for proper accounting.

**Q: Can operators override entity approval requirements?**

A: No, approval requirements are strict. Operators must approve entities first before creating OBO checkouts if the config is enabled.

**Q: How does Checkout OBO support remittance and wallet topup use cases?**

A: Merchants can create checkout sessions on behalf of telecom operators, wallet providers, or remittance agents (represented as entities). When a customer completes a topup transaction, the funds are attributed to the entity representing the service provider. Optional metadata fields can capture beneficiary details, wallet numbers, and purpose of payment.

**Q: Can I use OBO for cross-border remittances?**

A: Yes. The entity represents the receiver/beneficiary organization (e.g., a money transfer operator in the destination country). The checkout captures the sender’s payment, and the payin is attributed to the entity. Additional compliance fields can track corridor information, purpose, and beneficiary details.

**Q: What types of entities are supported?**

A: Entities can represent various business types:
- **Commerce**: Marketplace sellers, merchants, vendors
- **Remittance**: Money transfer operators, remittance agents, subagents
- **Financial Services**: Wallet providers, mobile money operators, telecom companies
- **Utilities**: Bill payment service providers

Each entity type may have different compliance and approval requirements based on the merchant’s configuration.

---

## 16.03.2025

## Overview

Introduce a new field `on_behalf_of_configuration` in the **Checkout** and **Payin** objects. This field allows callers to pass configuration controlling how hosted pages are displayed in the context of on-behalf-of flows.

---

## Field Definition

| Property | Details |
| --- | --- |
| Field name | `on_behalf_of_configuration` |
| Type | JSON object |
| Objects affected | `checkout`, `payin` |
| Required | No (optional) |

### Schema

```json
{
  "on_behalf_of_configuration": {
    "hosted_page_display": "entity" | "entity_plus_account"
  }
}
```

---

## Sub-fields

### `hosted_page_display`

| Property | Details |
| --- | --- |
| Type | Enum (string) |
| Required | Yes (if `on_behalf_of_configuration` is passed) |

| Value | Description |
| --- | --- |
| `entity` | Hosted page displays the entity only |
| `entity_plus_account` | Hosted page displays both the entity and the account |

---

## Affected Objects

### Checkout

- Field added to the checkout creation request payload
- Stored and returned as part of the checkout object response

### Payin

- Field added to the payin creation request payload
- Stored and returned as part of the payin object response

---

## Out of Scope

- No changes to existing fields
- No changes to other objects beyond `checkout` and `payin`
- No UI changes outside of hosted page display behavior driven by this config

# Release Plan (teams impacted)

[Compliance - Onboarding](Checkout%20on%20Behalf%20Of%20(Checkout%20OBO)/Compliance%20-%20Onboarding%2034fc765b724880d1888bec2006ab8c63.md)

[Compliance - TM](Checkout%20on%20Behalf%20Of%20(Checkout%20OBO)/Compliance%20-%20TM%2034fc765b724880ed94d7d46cf4507deb.md)

[Risk](Checkout%20on%20Behalf%20Of%20(Checkout%20OBO)/Risk%2034fc765b724880359d39d8331eac0ff8.md)

[Partnerships](Checkout%20on%20Behalf%20Of%20(Checkout%20OBO)/Partnerships%2034fc765b724880a09364c121ef8d9970.md)

[Legal](Checkout%20on%20Behalf%20Of%20(Checkout%20OBO)/Legal%2034fc765b7248808893abcd215f774b22.md)

[Product_Payments_POD](Checkout%20on%20Behalf%20Of%20(Checkout%20OBO)/Product_Payments_POD%2034fc765b72488072bef1e1c4d27249f3.md)

[Licensing](Checkout%20on%20Behalf%20Of%20(Checkout%20OBO)/Licensing%2034fc765b72488069b1fde8cf53a2db46.md)