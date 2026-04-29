# Engineering — Release Notes: Entity Categorisation

## What's new

Entity categorisation feature adds risk-based controls to OBO merchant payouts. Ops can assign merchants a category (A/B/C) on the dashboard; the system auto-applies Sardine rules and platform configs based on category. Technically: new `merchant_category` field on merchant entity, new Sardine payload field, new ops dashboard UI, KYB form changes to capture service provider type and license uploads.

## Relevance to your team

**Service scope:** Affects ledger/merchant service, KYB service, ops dashboard backend, Sardine API client, and database schema. KYB form changes are frontend-bound.

**Deployment risk:** This is a gated rollout (new field is optional, category defaults to "not set"). New Sardine rule enforcement is contained to OBO payouts. Database migration for new fields is non-breaking (nullable columns). No hard cutover — ops can migrate merchants to categories post-go-live.

**Upstream/downstream dependencies:** Payment ledger needs to forward merchant category to Sardine on OBO transactions. Compliance dashboard (Ops Pod) must expose the category field with RBAC validation. No changes to settlement or reconciliation logic.

## Inputs required before go-live

- [ ] Confirm database migration script for new merchant schema fields (`category`, `service_provider_type`, `psp_licenses` JSON)
- [ ] Validate Sardine API payload changes — merchant category field must be sent on OBO payout initiation
- [ ] Test category-to-config mapping logic in staging (e.g., category B → auto-set entity approval required)
- [ ] Ensure ops dashboard backend correctly gates category field updates to compliance RBAC group
- [ ] Define feature flag for gradual Sardine rule rollout (do not send category to Sardine before flagged as ready)

---

**Generated:** 2026-04-28 | **For:** Pre-release synchronisation
