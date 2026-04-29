# Risk — Release Notes: Entity Categorisation

## What's new

We're adding automated risk categorisation for on-behalf-of merchants. Compliance assigns each merchant a category (A = whitelisted, B = monitored, C = enhanced monitoring) for OBO payouts. This categorisation is sent to Sardine on each transaction; Sardine enforces a single rule: category B or C triggers a hard stop, category A flows through. Service provider type (TSP vs PSP) is now captured and acts as an additional risk signal.

## What's in it for you

**Risk profile impact:** This significantly reduces manual per-merchant rule creation in Sardine. Instead of per-merchant hard-coded rules, you have one global rule based on category. Category B and C transactions are hard-stopped uniformly; compliance reviews and manually upgrades to A when satisfied. This is a cleaner risk model — fewer edge cases, single point of failure if misconfigured.

**Merchants without a category are treated as Category C** (hard stop). This is your conservative default; migrations can happen post-launch without risk spikes.

**Opportunity:** As coverage grows (more merchants assigned a category), you can measure fraud loss reduction and leverage this for regulatory reporting — "X% of OBO volume now flows through categorised merchants."

## Inputs required before go-live

- [ ] Review and approve the one-rule Sardine logic: B or C → hard stop, A → allow
- [ ] Confirm default service provider type mapping (e.g., Money Services → PSP, SaaS → TSP)
- [ ] Define the KPIs you'll track: % of active OBO merchants with a category assigned, fraud loss rate by category, upgrade cadence from C to B to A
- [ ] Align with Compliance on what triggers a category upgrade (e.g., X days of clean transactions)
- [ ] Stress-test the hard-stop volume in staging — model what happens if all merchants default to C

---

**Generated:** 2026-04-28 | **For:** Pre-release synchronisation
