# Finance — Release Notes: Entity Categorisation

## What's new

We're adding merchant risk categorisation (A/B/C for OBO payouts) and service provider type capture (TSP vs PSP). Category B/C transactions hard-stop at Sardine pending compliance review; category A transactions settle normally. Service provider type affects reporting classification: PSP merchants' entities are **not** Tazapay customers (no revenue recognition impact for us), TSP merchants' entities **are** Tazapay customers (included in our regulatory reporting and customer metrics).

## What's in it for you

**Revenue recognition impact:** No change to how we recognize fees. Categorisation and hard stops do not affect transaction count or fee timing — hard-stopped transactions don't settle but still generate fees (confirm with Compliance if they waive fees on hard-stopped txns pending review). If Compliance confirms no fees on hard-stops, you'll need to adjust revenue forecast for the hard-stop volume.

**Chart of accounts impact:** No new GL entries needed. Categorisation is a metadata field, not a new transaction type.

**Reporting implications:** TSP vs PSP classification is critical for regulatory reporting. TSP merchants' entities are Tazapay customers; PSP merchants' entities are not. Downstream reporting systems will query the `service_provider_type` field. Coordinate with your regulatory/tax reporting tools to ensure they capture this distinction correctly.

**Volume impact:** Expect reduced OBO settlement volume initially (category B/C hard-stops). As Compliance upgrades merchants, volume normalises. Model conservative category A coverage (assume 50-70% at launch, ramping to 85%+ at 60 days) for financial forecasting.

## Inputs required before go-live

- [ ] Confirm: are fees assessed on hard-stopped OBO transactions, or does Compliance waive pending review?
- [ ] If fees are waived, model the revenue impact (X% of OBO volume hard-stopped at launch, Y% at 30 days, Z% at 60 days)
- [ ] Ensure your reporting tool has a mapping for TSP (Tazapay customer) vs PSP (not our customer) for regulatory reporting
- [ ] Coordinate with Tax: confirm there are no COGS, sales tax, or 1099 implications for the TSP/PSP distinction
- [ ] Update FP&A models: include a sensitivity table for category A coverage % and its impact on OBO fee revenue

---

**Generated:** 2026-04-28 | **For:** Pre-release synchronisation
