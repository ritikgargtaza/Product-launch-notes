# Licensing — Release Notes: Entity Categorisation

## What's new

We're introducing merchant risk categorisation (A/B/C for OBO payouts) and capturing service provider type (TSP vs PSP) with license uploads. OBO transactions from category B/C merchants are hard-stopped by Sardine pending compliance review. Service provider type affects our regulatory reporting obligations: PSP merchants' entities are out of our customer-facing reporting scope; TSP merchants' entities are in it. We're now capturing PSP licenses and tracking expiry to ensure we have current documentation on file.

## What's in it for you

**Licensing scope impact:** TSP merchants' entities (when Tazapay is the payment service provider) require us to maintain licenses. PSP merchants' entities do not — the PSP holds the license, and we only need to verify they have a valid one. This distinction clarifies which merchants require license documentation on file and which are the PSP's responsibility.

**License documentation:** PSP licenses are now uploaded during KYB (optional for merchants, mandatory for PSPs post-compliance override). We track expiry dates. Before license expiry, we alert Compliance. This removes the offline C2C call dependency and creates an audit trail.

**Regulatory exposure:** Capturing TSP vs PSP upfront reduces regulatory risk — we now have a structured record of who is responsible for each merchant's payment service license. If we're ever questioned on license coverage, we can query the service provider type field and generate a compliance report.

**No new license categories:** This is not expanding the scope of licenses we manage. It's just centralising the classification (TSP vs PSP) and documenting PSP license ownership.

## Inputs required before go-live

- [ ] Review the TSP/PSP definition with Compliance — confirm it aligns with how you currently interpret regulatory obligations
- [ ] Assess your jurisdiction-specific implications: does TSP vs PSP matter for FCA, RBI, MAS, etc.? Update your licensing register if so
- [ ] Confirm license document retention: same as merchant KYB documents (typically 7 years)?
- [ ] For PSP merchants, validate that we don't need to *register* or *licence* their payment service activity — we're just documenting theirs
- [ ] Update your quarterly regulatory reporting to tag entities by service provider type — this will help auditors understand the license allocation

---

**Generated:** 2026-04-28 | **For:** Pre-release synchronisation
