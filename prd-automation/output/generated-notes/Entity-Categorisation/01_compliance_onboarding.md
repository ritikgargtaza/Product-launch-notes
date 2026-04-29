# Compliance: Onboarding — Release Notes: Entity Categorisation

## What's new

We're adding entity categorisation to the KYB risk section on the ops dashboard. Compliance can now assign merchants a risk category (A, B, or C) for on-behalf-of (OBO) payouts during or after KYB. We're also capturing service provider type (TSP vs PSP) and PSP licenses as part of KYB to create a structured record of merchant risk signals that used to only live in notes.

## What's in it for you

**Impact on onboarding approval rate:** Categorisation is not mandatory — KYBs can still be approved without a category assigned. This keeps approval velocity intact while giving you the option to categorise immediately or defer to after C2C calls.

**Impact on decision-making:** You now have a single source of truth for merchant risk categorisation instead of hunting through Jira tickets. Service provider type (auto-set from industry vertical, overrideable by compliance) gives you an immediate signal on whether a merchant is a lower-risk TSP or requires closer scrutiny as a PSP.

**Impact on operational efficiency:** When you assign a category for payout OBO transactions, platform configs (entity approval requirements, soft onboarding) apply automatically. You can still override manually if needed, but automation removes the manual mapping step.

## Inputs required before go-live

- [ ] Review the service provider type default mapping for your highest-volume verticals — confirm TSP/PSP defaults align with your risk assessment
- [ ] Test categorisation flow in staging: assign categories A/B/C and confirm that the right downstream configs apply
- [ ] Brief your team on the new KYB form PSP license section — it's optional for merchants but mandatory for PSPs; clarify when/how to follow up on missing licenses
- [ ] Update your internal SOP for post-KYB categorisation — document the criteria you'll use to assign A vs B vs C
- [ ] Confirm which compliance team members should have edit access to the categorisation field (RBAC gates this)

---

**Generated:** 2026-04-28 | **For:** Pre-release synchronisation
