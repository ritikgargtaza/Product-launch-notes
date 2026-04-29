

# Checkout — On Behalf Of (OBO)

**Status: Early Idea | Draft**

---

## The Problem

When a merchant creates a checkout session today, there's no way to say who is the actual receiver of the funds. Everything gets attributed to the merchant account — even when the merchant is processing payments on behalf of someone else (a seller, a partner, a service provider).

This is a gap for platforms and aggregators who operate on behalf of multiple downstream entities.

---

## The Idea

Let merchants pass an optional `on_behalf_of` field when creating a checkout. This field points to an entity already registered in Tazapay — indicating that the funds from this checkout belong to that entity, not the merchant directly.

---

## Who Is This For?

- **Marketplaces** — checkout on behalf of individual sellers
- **Payment Aggregators** — one parent account, multiple downstream merchants
- **Remittance Platforms** — checkout on behalf of money transfer operators or agents
- **Wallet / Topup Services** — accept payments on behalf of telecom or wallet providers
- **Bill Payment Platforms** — collect on behalf of utilities and service providers

---

## What Would Need to Change (High Level)

- **API** — add `on_behalf_of` field to checkout creation; payin inherits it automatically
- **Dashboard** — show entity/receiver details on checkout and payin screens
- **Reports** — include entity fields in exports
- **Config** — toggles to make the field mandatory, or require entity approval before checkout

---

## Open Questions

- Do we need different entity types at this stage, or is one model enough to start?
- What does the approval workflow look like before an entity can receive funds?
- How should the hosted checkout page look when an entity is set?
- How do refunds work when a payin has an `on_behalf_of` entity?
