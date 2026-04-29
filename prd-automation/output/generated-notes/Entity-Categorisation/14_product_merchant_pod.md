# Product: Merchant Pod — Release Notes: Entity Categorisation

## What's new

KYB form adds a **mandatory "Service Provider Type"** field (Technical Service Provider vs Payment Service Provider) and optional **"PSP Licenses"** file upload section. When merchant selects PSP, license upload becomes mandatory. Licenses (PDF, JPG, PNG, up to 10MB each, max 10 files) include expiry date field. Merchant does NOT see uploaded licenses on their dashboard post-submission — this is internal compliance only. No API changes; this is merchant-facing form and KYB data capture.

## Relevance to your pod

**KYB form updates:** Add Service Provider Type as mandatory field before KYB can be submitted. Conditionally show PSP license section based on selection. License upload: support drag-drop, file validation (type, size), expiry date picker per license. Form validation: KYB cannot be submitted unless type is selected; if PSP is selected, at least one license must be uploaded.

**Merchant dashboard:** Service Provider Type is displayed on merchant's KYB status page (informational only). PSP licenses are **NOT** shown on merchant dashboard — they're internal compliance review only. Merchants cannot download or view uploaded licenses.

**API contract:** New KYB request body fields: `service_provider_type` (enum: TSP, PSP) and `psp_licenses` (array of {file_id, label, expiry_date}). Response includes these fields so merchant can see what they submitted (except file contents).

**Edge case:** If merchant changes their service provider type later (on ops dashboard by compliance), existing uploaded licenses remain on file. If PSP → TSP, licenses stay. If TSP → PSP and no license exists, ops team must upload one.

## Inputs required before go-live

- [ ] Design KYB form flow: add Service Provider Type dropdown early in flow; conditionally show license section based on selection
- [ ] Implement file upload: validate type (PDF, JPG, PNG), size (10MB), count (max 10). Store files in secure bucket, generate signed download URLs for ops dashboard only
- [ ] Implement expiry date picker per license; display to ops dashboard with 1-month warning tags
- [ ] Validate KYB submission: block if Service Provider Type not selected or if PSP selected with no licenses
- [ ] Update API documentation: document new KYB request/response fields
- [ ] Merchant dashboard: display service provider type; explicitly hide license list (security requirement)

---

**Generated:** 2026-04-28 | **For:** Pre-release synchronisation
