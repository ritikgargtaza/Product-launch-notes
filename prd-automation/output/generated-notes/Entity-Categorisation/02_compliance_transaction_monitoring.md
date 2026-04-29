# Compliance: Transaction Monitoring — Release Notes: Entity Categorisation

## What's new

Merchant categorisation for OBO payouts is being added. Compliance will assign merchants a risk category (A, B, or C) on the ops dashboard. These categories directly feed into Sardine: category B or C triggers an automatic hard stop for all OBO transactions for that merchant. Category A transactions flow through without hard stops. Service provider type (TSP vs PSP) is also being captured during KYB to provide additional context for categorisation decisions.

## What's in it for you

**Impact on alert volume and SAR filing:** Hard-stopped transactions (category B/C) will land in your manual review queue for triage and SAR determination. This replaces the current ad-hoc per-merchant rule creation. You'll see a larger initial batch of hard-stopped transactions if most merchants default to category C, but as compliance upgrades merchants to A or B based on your monitoring, alert volume will normalise.

**Impact on false positive rate:** The category-based approach is more deterministic than individual rule thresholds — merchants in C stay hard-stopped until manually moved. You control the pace of upgrades based on your comfort level, reducing FP noise from rules firing unexpectedly.

**Alert routing:** Hard-stopped category B/C transactions arrive as a single alert type; you triage to determine SAR vs decline. No rule recalibration needed between launches — compliance simply manages the category assignment.

## Inputs required before go-live

- [ ] Review the hard-stop logic: understand that *all* category B/C OBO transactions arrive for your review, not just anomalies
- [ ] Prepare your team for the initial batch — if most merchants are unassigned (defaulting to C), you'll see elevated alert volume post-launch
- [ ] Document your upgrade criteria — at what point does a category C merchant move to B? When does B move to A?
- [ ] Brief your triage team on the new alert context — every hard stop will include the merchant's assigned category
- [ ] Confirm you're comfortable with the SAR implications of hard-stopping all B/C OBO transactions vs. threshold-based rules

---

**Generated:** 2026-04-28 | **For:** Pre-release synchronisation
