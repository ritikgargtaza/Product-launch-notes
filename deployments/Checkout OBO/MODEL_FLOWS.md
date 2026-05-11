# Checkout OBO — Model Flows

---

## Legend

| Arrow | Meaning |
|---|---|
| `━━━━►` | Funds flow |
| `◄━━━►` | Contract / commercial agreement |
| `- - -►` | Onboarding relationship |

**Parties**

| Label | Full name | Role |
|---|---|---|
| **Payer** | Buyer / Sender | End user making the payment |
| **Acq / LPM** | Acquirer / Local Payment Method | Underlying payment processor or rail |
| **TZP** | Tazapay | Processes checkout; records payin; attributes funds to entity |
| **M** | Merchant | Tazapay's direct client — marketplace, MTO, fintech platform, etc. |
| **E** | Entity | Sub-merchant registered under the merchant — seller, MTO, wallet provider, remittance agent, etc. |

---

## What's the same in all scenarios

- Funds always flow: **Payer → Acq/LPM → TZP → Merchant account**
- TZP contracts directly with the Merchant (not the Entity)
- Entity is **attributed** in the payin ledger — it does not receive funds directly from TZP
- The Merchant is responsible for any downstream settlement or payout to the Entity (separate flow, outside Checkout OBO scope)
- Entity must be approved by Compliance before checkout creation is allowed (when default config is ON)

---

## Scenario 1 — Commerce / Marketplace

**Situation:** Tazapay has onboarded a marketplace platform as a Merchant. The platform creates checkout sessions on behalf of its seller entities (individual stores or vendors). Funds are collected by the Merchant; sellers are attributed in the payin record and reconciled separately by the Merchant.

```mermaid
flowchart LR
    classDef payerStyle fill:#F5DEB3,stroke:#8B4513,color:#000
    classDef acqStyle fill:#E8E8E8,stroke:#888,color:#000
    classDef tzpStyle fill:#2D6A1F,stroke:#2D6A1F,color:#fff
    classDef merchantStyle fill:#1a1a1a,stroke:#333,color:#fff
    classDef entityStyle fill:#003399,stroke:#003399,color:#fff

    Payer(["🙂 Payer\nBuyer"]):::payerStyle
    Acq["Acq / AcqP\nLPM"]:::acqStyle
    TZP["TZP"]:::tzpStyle
    M["M\nMarketplace"]:::merchantStyle
    E["E\nSeller Entity"]:::entityStyle

    Payer -- "Funds ━►" --> Acq
    Acq -- "Funds ━►" --> TZP
    TZP -- "Funds ━►\n(attributed to E)" --> M

    TZP <-- "Contract" --> M
    M <-- "T&Cs / Agreement" --> E

    E -. "Onboarded under M\nKYB via TZP Compliance" .-> M
```

**Key points for this scenario**
- The buyer sees the seller entity name on the hosted checkout page (configurable)
- The payin record in TZP ledger includes `on_behalf_of = entity_id` and `entity_details`
- M receives settlement; M is responsible for paying out to each seller (separate payout flow)
- Compliance approves each seller entity before M can create OBO checkouts for them
- Risk: chargeback and fraud monitoring must operate at entity level, not just merchant level

---

## Scenario 2 — Remittance / Money Transfer

**Situation:** Tazapay has onboarded a remittance platform as a Merchant. The platform creates checkout sessions on behalf of its network of licensed remittance agent entities. The payer is a sender; the entity is the remittance agent who receives the attribution (the ultimate beneficiary is outside Tazapay's scope).

```mermaid
flowchart LR
    classDef payerStyle fill:#F5DEB3,stroke:#8B4513,color:#000
    classDef acqStyle fill:#E8E8E8,stroke:#888,color:#000
    classDef tzpStyle fill:#2D6A1F,stroke:#2D6A1F,color:#fff
    classDef merchantStyle fill:#1a1a1a,stroke:#333,color:#fff
    classDef entityStyle fill:#003399,stroke:#003399,color:#fff

    Payer(["🙂 Payer\nSender"]):::payerStyle
    Acq["Acq / AcqP\nLPM"]:::acqStyle
    TZP["TZP"]:::tzpStyle
    M["M\nMTO Platform"]:::merchantStyle
    E["E\nRemittance Agent\nor Subagent"]:::entityStyle

    Payer -- "Funds ━►" --> Acq
    Acq -- "Funds ━►" --> TZP
    TZP -- "Funds ━►\n(attributed to E)" --> M

    TZP <-- "Contract" --> M
    M <-- "Agent Agreement" --> E

    E -. "Licensed agent\nOnboarded under M\nKYB via TZP Compliance" .-> M
```

**Key points for this scenario**
- Remittance agent entities (MTOs, subagents) are in a regulated activity category — Licensing must confirm TZP's licence covers processing attributed to these entity types in each jurisdiction
- SAR/STR filing logic must map correctly when entity and merchant are different legal entities
- TM rules must segment activity by entity, not just merchant — MTO entity types represent higher-risk corridors
- The ultimate beneficiary (recipient of the remittance) is outside TZP's flow — TZP's attribution ends at the entity level

---

## Scenario 3 — Financial Services / Wallet Topup

**Situation:** Tazapay has onboarded a fintech platform as a Merchant. The platform enables users to topup third-party wallet accounts — e.g., GCash, M-Pesa — where each wallet provider is registered as an entity under the Merchant account.

```mermaid
flowchart LR
    classDef payerStyle fill:#F5DEB3,stroke:#8B4513,color:#000
    classDef acqStyle fill:#E8E8E8,stroke:#888,color:#000
    classDef tzpStyle fill:#2D6A1F,stroke:#2D6A1F,color:#fff
    classDef merchantStyle fill:#1a1a1a,stroke:#333,color:#fff
    classDef entityStyle fill:#003399,stroke:#003399,color:#fff

    Payer(["🙂 Payer\nWallet User"]):::payerStyle
    Acq["Acq / AcqP\nLPM"]:::acqStyle
    TZP["TZP"]:::tzpStyle
    M["M\nFintech Platform"]:::merchantStyle
    E["E\nWallet Provider\ne.g. GCash / M-Pesa"]:::entityStyle

    Payer -- "Funds ━►" --> Acq
    Acq -- "Funds ━►" --> TZP
    TZP -- "Funds ━►\n(attributed to E)" --> M

    TZP <-- "Contract" --> M
    M <-- "Distribution\nAgreement" --> E

    E -. "Regulated entity\nOnboarded under M\nKYB + Licensing check" .-> M
```

**Key points for this scenario**
- Wallet providers (GCash, M-Pesa, etc.) are themselves regulated entities — Licensing must confirm no regulatory conflict in processing checkout sessions attributed to them
- This is the highest-risk scenario from a licensing perspective: the entity is a regulated financial institution in its own jurisdiction
- Compliance sign-off required per entity type before enabling for live merchants

---

## Checkout OBO vs Collections OBO (COBO) — structural comparison

| | Collections OBO (COBO) | Checkout OBO |
|---|---|---|
| **TZP contracts with** | Financial intermediary (Fin) | Merchant directly |
| **Merchant relationship** | Merchant contracts with Fin, not TZP | Merchant contracts with TZP directly |
| **Entity layer** | Merchant is the entity (sub-merchant of Fin) | Entity is registered under the Merchant |
| **Settlement chain** | Payer → Acq → TZP → Fin → Merchant | Payer → Acq → TZP → Merchant (entity attributed) |
| **Who onboards entities** | Fin onboards Merchants | Merchant onboards Entities (KYB via TZP Compliance) |
| **Number of contract layers** | TZP ↔ Fin, Fin ↔ Merchant | TZP ↔ Merchant, Merchant ↔ Entity |

```mermaid
flowchart LR
    subgraph COBO ["Collections OBO (COBO)"]
        direction LR
        P1(["Payer"]):::payerStyle --> A1["Acq"]:::acqStyle --> T1["TZP"]:::tzpStyle --> F1["Fin"]:::finStyle --> M1["Merchant"]:::merchantStyle
    end

    subgraph CheckoutOBO ["Checkout OBO"]
        direction LR
        P2(["Payer"]):::payerStyle --> A2["Acq"]:::acqStyle --> T2["TZP"]:::tzpStyle --> M2["Merchant\n(+ Entity attribution)"]:::merchantStyle
    end

    classDef payerStyle fill:#F5DEB3,stroke:#8B4513,color:#000
    classDef acqStyle fill:#E8E8E8,stroke:#888,color:#000
    classDef tzpStyle fill:#2D6A1F,stroke:#2D6A1F,color:#fff
    classDef finStyle fill:#444,stroke:#333,color:#fff
    classDef merchantStyle fill:#1a1a1a,stroke:#333,color:#fff
```

**The key structural difference:** In COBO, there is a financial intermediary between TZP and the Merchant. In Checkout OBO, TZP contracts directly with the Merchant — the Entity layer is internal to the Merchant's account structure, not a separate contracting party with TZP.

---

## What Checkout OBO does NOT cover

| Out of scope | Notes |
|---|---|
| Settlement / payout to Entity | Separate payout flow — the Merchant is responsible for distributing funds to entities downstream |
| Beneficiary receipt (remittance) | The end beneficiary receiving the remittance is outside TZP's flow |
| Entity-level FX | FX operates at the Merchant account level |
| New payment rails | OBO is attribution only — no new PSPs, acquirers, or rails introduced |
