# Product: Data Pod — Release Notes: Entity Categorisation

## What's new

Entity categorisation introduces three new event types and schema changes. **New events:** `merchant_categorized` (emitted when category is assigned), `service_provider_type_set` (emitted during KYB or when ops updates type), `psp_license_uploaded` (emitted when license file is received). **New schema fields:** `merchants.category` (enum A/B/C), `merchants.service_provider_type` (enum TSP/PSP), `merchants.psp_licenses` (JSON array with file metadata and expiry). All three are queryable and relevant for reporting and ML feature stores.

## Relevance to your pod

**Event instrumentation:** Add three new event types to your event stream. Ensure event schema includes merchant ID, new value, previous value (for category changes), timestamp, and actor (which compliance user made the change). These events flow into your data warehouse for audit trail and analytics.

**Schema updates:** Add three columns to `merchants` table: `category` (nullable string enum), `service_provider_type` (nullable string enum), `psp_licenses` (nullable JSON). Add audit table or use event log to track category changes over time.

**Downstream pipelines:** Update any dashboards or ML features that query merchant attributes. If you have a "merchant risk score" model, add category as a feature (strong signal). If you have customer segmentation, add service provider type (PSPs are different customer profile than TSPs).

**Reporting queries:** Enable Finance/Regulatory teams to query: `merchants WHERE service_provider_type = 'TSP'` (Tazapay customers) vs `PSP` (not our customers). This is critical for regulatory reporting; ensure the field is indexed.

**Data retention:** Category change audit trail should be retained for at least 7 years (compliance requirement). PSP licenses: same retention as merchant KYB documents (typically 7 years post-inactive status).

## Inputs required before go-live

- [ ] Instrument three new event types in your event pipeline; validate schema in staging
- [ ] Add merchant schema migrations: category, service_provider_type, psp_licenses columns
- [ ] Create/update audit log table for category changes (with full history)
- [ ] Index `service_provider_type` for fast regulatory reporting queries
- [ ] Update BI dashboards: add category and SPT as available dimensions for merchant analysis
- [ ] Coordinate with ML team: category is a strong signal for merchant risk models
- [ ] Document data retention: category audit trail (7 years), license files (7 years post-inactive)

---

**Generated:** 2026-04-28 | **For:** Pre-release synchronisation
