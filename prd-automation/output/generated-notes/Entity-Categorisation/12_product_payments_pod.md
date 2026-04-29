# Product: Payments Pod — Release Notes: Entity Categorisation

## What's new

Entity categorisation introduces a **compliance gate on OBO payout initiation**. When a payout is initiated, the system checks the merchant's assigned category; if B or C, Sardine hard-stops it. Category A payouts flow through normally. New data: `merchant_category` is queried on payout creation and sent to Sardine. Service provider type (TSP/PSP) is captured during KYB but does not affect the payout API — it's metadata for compliance reporting.

## Relevance to your pod

**API changes:** Payout initiation endpoint now includes logic to check `merchant.category` and forward it to Sardine as part of the transaction payload. No request/response schema changes — this is internal logic. Existing integrations are unaffected.

**Upstream dependencies:** Ledger service must retrieve merchant category on payout creation. If category is not set (null), default to hard-stop (treat as Category C). Merchants service must expose category and service provider type fields. Sardine client must accept category field in transaction payload.

**Downstream dependencies:** None to settlement or reconciliation. Hard-stopped transactions are routed out-of-band by Sardine; they don't touch your ledger state machine.

**Edge cases:** Payout succeeds API-side even if Sardine hard-stops it downstream. Webhook to merchant includes "hard_stop_pending_compliance_review" reason code (new). Merchant sees transaction as pending, not failed.

## Inputs required before go-live

- [ ] Validate payout creation flow in staging: confirm merchant category is correctly retrieved and sent to Sardine
- [ ] Test edge case: merchant with null category defaults to hard-stop (treats as C)
- [ ] Confirm webhook contract: add new pending_reason code for hard-stopped transactions
- [ ] Define bug-watch period: watch for payout initiation failures during first 48 hours post-launch
- [ ] Update internal API documentation: document the new merchant category field and its impact on payout routing

---

**Generated:** 2026-04-28 | **For:** Pre-release synchronisation
