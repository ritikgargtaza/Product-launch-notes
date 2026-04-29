# Payment Operations — Release Notes: Entity Categorisation

## What's new

Entity categorisation adds a compliance gate to OBO payouts. When a merchant's category is set (A/B/C), category B and C transactions trigger a hard stop in Sardine before they reach your settlement queue. Service provider type (TSP vs PSP) is now captured during KYB. No changes to settlement flow, reconciliation, or failure codes — this is purely a pre-settlement compliance gate.

## What's in it for you

**Impact on manual intervention rate:** OBO transactions that would have previously flowed through now hard-stop at Sardine if the merchant is category B or C. These transactions do NOT enter your queue for settlement — compliance reviews and upgrades the category before settlement happens. This reduces manual exceptions and SLA pressure on your team.

**Settlement queue clarity:** Your queue will only see OBO transactions from category A merchants (or those without a category assigned, which default to hard stop). No new retry logic or failure codes; hard-stopped transactions are handled out-of-band by compliance.

**No operational burden:** Settlement success rate should improve because only pre-vetted (or category A) merchants settle. You don't need to add new failure codes or map new transaction states — this is a pre-settlement filter.

## Inputs required before go-live

- [ ] Confirm you're aligned: category B/C OBO transactions hard-stop *before* hitting your settlement queue
- [ ] Update any settlement SLA dashboards to account for the new hard-stop gate — your actual queue throughput will be lower post-launch (by design)
- [ ] No new failure codes to map; confirm your monitoring dashboards don't trigger alerts for transactions that hard-stop upstream
- [ ] Brief the escalation team: if a category A merchant has issues, it's a payment ops issue; if category B/C, it's a compliance gate issue (not your queue)
- [ ] Validate settlement reports in staging with mixed categories to ensure reconciliation clarity

---

**Generated:** 2026-04-28 | **For:** Pre-release synchronisation
