# Product: Operations Pod — Release Notes: Entity Categorisation

## What's new

Ops dashboard adds a **merchant categorisation section** in the KYB risk view. Compliance can assign categories (A/B/C) for OBO payouts. When a category is set, platform configs auto-apply (e.g., entity approval required for B/C). Dashboard also displays service provider type (TSP/PSP) auto-set from industry vertical during KYB. New data: merchant risk category, service provider type, audit trail of category changes (updated_by, updated_at, previous_value, new_value).

## Relevance to your pod

**Dashboard updates:** Add new "OBO Payout Compliance Categorisation" section to KYB risk panel. Dropdown for Category A/B/C. Compliance-only edit permission (RBAC). Display service provider type (read-only on dash, editable by compliance with license validation). Show audit log of category changes below.

**New events:** When category is set or changed, emit event for downstream systems (audit logging, notification service). Log structure: `{merchant_id, old_category, new_category, updated_by, updated_at}`.

**New queries/filtering:** Merchant listing screen needs new filter: "License Renewal Due" (PSP merchants with license expiring within 30 days). Add merchant list export to include category and service provider type for reporting teams.

**Failure modes:** Handle gracefully if category lookup fails (treat as C). If compliance bulk-updates categories, ensure audit trail captures all. If service provider type is changed TSP → PSP without license, prompt compliance to upload.

## Inputs required before go-live

- [ ] Design and implement KYB risk section UI: category dropdown, service provider type display, audit trail log
- [ ] Implement RBAC: only compliance-role users can edit category field
- [ ] Create database migrations: new merchant fields (`category`, `service_provider_type`, `psp_licenses` JSON array)
- [ ] Add new events for category changes; ensure audit logging pipeline subscribed
- [ ] Test bulk operations in staging: ensure audit trail accuracy when categories are batch-updated
- [ ] Update merchant list filters and exports to include new classification fields

---

**Generated:** 2026-04-28 | **For:** Pre-release synchronisation
