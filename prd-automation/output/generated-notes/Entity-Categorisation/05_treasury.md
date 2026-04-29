# Treasury — Release Notes: Entity Categorisation

## What's new

Entity categorisation introduces a compliance gate that delays some OBO merchant payouts. Merchants assigned category B or C will have their transactions hard-stopped by Sardine pending compliance review. This may temporarily reduce OBO payout volume as merchants move through the categorisation process. Service provider type is now captured to help identify potential PSPs (higher regulatory burden).

## What's in it for you

**Cash flow impact:** In the short term, expect reduced OBO payout flow as category B/C merchants accumulate hard-stopped transactions awaiting compliance review. As compliance upgrades merchants to category A, flow resumes. The medium-term impact depends on the compliance team's upgrade velocity and the distribution of merchants across categories.

**Float requirement timing:** Hard-stopped transactions remain merchant-facing but don't settle immediately. You'll need to model prefunding for merchants post-categorisation rather than pre-settlement. Request compliance to provide their forecast of category A coverage (% of active OBO merchants with category A) to model float impact.

**Exposure by merchant type:** Service provider type is now tracked. PSP merchants may have tighter categorisation requirements than TSP merchants, affecting their settlement timeline. Incorporate SPT into your liquidity planning model.

## Inputs required before go-live

- [ ] Request compliance's forecast: what % of active OBO merchants will be category A at launch, 30 days, 60 days?
- [ ] Model float impact: assume X% of OBO volume is temporarily held in hard-stop pending categorisation
- [ ] Review prefunding arrangements with banking partners — confirm they support delayed settlement for hard-stopped OBO transactions
- [ ] Update cash flow forecast to account for per-merchant category timing, not just per-corridor volume
- [ ] Coordinate with Payment Ops on settlement queue clarity — understand how hard-stopped transactions are reversed or re-triggered post-upgrade

---

**Generated:** 2026-04-28 | **For:** Pre-release synchronisation
