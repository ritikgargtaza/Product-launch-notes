# Partnerships — Release Notes: Entity Categorisation

## What's new

Merchant risk categorisation is being added as a product feature. Compliance can categorise merchants as A/B/C for OBO payouts. Service provider type (TSP vs PSP) is now captured and tracked. Merchants don't see this classification on their side, but it gates transaction approval. No API changes; this is purely an internal categorisation and compliance system.

## What's in it for you

**Partner integration impact:** None to your existing integrations. No API versioning, no breaking changes. Partners using our merchant KYB API won't see changes in request/response formats.

**Co-selling opportunity:** If you have fintech partners or payment processor partners who use our APIs, this categorisation capability is a selling point. They can onboard merchants faster because category A merchants don't require manual compliance review per merchant. Mention it in your next partner sync.

**No contract implications:** This is internal compliance classification. Your partner agreements don't change. If a partner's merchant gets hard-stopped (category B/C), that's between us and the merchant — not a partner contract issue.

## Inputs required before go-live

- [ ] Brief your top 3 integration partners: no API changes, no action needed on their side
- [ ] Confirm with Legal and your partner leads: are there any references to "merchant categorisation" in existing partner agreements that need clarification?
- [ ] Update partner portal documentation to note the new internal categorisation (for transparency, though it doesn't affect them)
- [ ] No revenue-share or commercial model changes; confirm this with Finance
- [ ] Identify 1-2 partners who could benefit from faster onboarding — pitch them on the category A benefit

---

**Generated:** 2026-04-28 | **For:** Pre-release synchronisation
