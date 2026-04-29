# Legal — Release Notes: Entity Categorisation

## What's new

We're adding **merchant risk categorisation** (A/B/C) to the platform and capturing **service provider type** (TSP vs PSP) and **PSP licenses** during onboarding. Compliance assigns categories to gate OBO payout approvals. Service provider type affects regulatory reporting obligations: PSP merchants' entities are not Tazapay customers (reporting sits with them); TSP merchants' entities are Tazapay customers (we report them). Licenses are captured but not verified — compliance manually reviews.

## What's in it for you

**Data processing impact:** We're now capturing and storing PSP license documents (PDF, JPG, PNG) and expiry dates. These are internal compliance records, not shared with merchants or partners. Document retention policy: align with your current merchant document retention (suggest 7 years for regulatory compliance).

**Reporting obligation changes:** The TSP/PSP distinction has direct regulatory reporting implications. PSP merchants' entities are out of our reporting scope; TSP merchants' entities are in. This distinction is queryable and will be used by downstream reporting systems. Ensure Finance and Regulatory teams understand this for 10-K/quarterly reporting.

**No user rights or privacy impacts:** Merchants don't see their category or service provider type. We're not changing ToS or Privacy Policy — this is internal classification. No new data processing activity requires GDPR/PSD2 notice.

**License handling:** We're capturing licenses but not doing automated verification. Compliance reviews manually. If we move to automated verification in the future, that would require a separate legal review.

## Inputs required before go-live

- [ ] Confirm document retention policy for uploaded PSP licenses — align with merchant KYB document retention
- [ ] Review merchant contract language: does it address what happens if a TSP is reclassified as PSP during their tenure? (Unlikely but worth checking)
- [ ] Brief your external counsel: TSP/PSP distinction now flows into regulatory reporting, make sure they align on interpretation
- [ ] Confirm no ToS/Privacy Policy updates needed — we're not exposing categorisation to merchants or changing data handling
- [ ] Assess if any financial services agreements need updates (e.g., if we have service provider agreements, verify they're silent on merchant-level categorisation)

---

**Generated:** 2026-04-28 | **For:** Pre-release synchronisation
