# Launch Notes — SOP

**Owner:** Ritik Garg, Product | **Last updated:** May 2026

One command. Tailored notes. Only for the teams that matter.

---

## What this system does

| Command | Input | Output |
|---|---|---|
| `/pre-scope` | `IDEA.md` — early idea, pre-PRD | Questions and flags for 8 key teams (Compliance, Risk, Legal, Licensing, Finance, Sales, Partnerships) |
| `/launch-notes` | `PRD.md` — full PRD | Tailored sync notes for every team listed in the PRD's "Teams to Brief" section |

Run pre-scope before writing the PRD. Run launch-notes before go-live.

---

## Prerequisites

- [Claude Code](https://claude.ai/code) — desktop app or CLI (`npm install -g @anthropic-ai/claude-code`)
- Git — `git --version` to verify

---

## One-Time Setup

### 1. Install Claude Code

Download from [claude.ai/code](https://claude.ai/code) or install via terminal:

```bash
npm install -g @anthropic-ai/claude-code
```

Log in with your Anthropic account when prompted.

### 2. Clone the repo

```bash
git clone https://github.com/ritikgargtaza/Product-launch-notes.git
```

### 3. Install the commands

```bash
cp /path/to/Product-launch-notes/install/launch-notes.md ~/.claude/commands/launch-notes.md
cp /path/to/Product-launch-notes/install/pre-scope.md ~/.claude/commands/pre-scope.md
```

Replace `/path/to/` with wherever you cloned the repo. You only need to do this once.

To verify:

```bash
ls ~/.claude/commands/
# Should show: launch-notes.md  pre-scope.md
```

---

## For Every Feature

### Stage 1 — Early idea (before PRD)

```bash
# Create a folder for your feature inside the deployments/ directory
mkdir "deployments/your-feature-name"
cd "deployments/your-feature-name"
```

Create `IDEA.md` — a rough one-pager with:
- What you're building and why
- Who it's for (segment, geography)
- How you think it will work
- Known constraints or open questions

Open Claude Code in this folder, then run:

```
/pre-scope
```

→ Generates `pre-scope.md` with questions and early flags for 8 key teams.

Share with team leads before writing the PRD. Use their input to sharpen scope.

---

### Stage 2 — After PRD

Add `PRD.md` to the same deployment folder.

**Your PRD must include the required fields listed below** — especially "Teams to Brief". Missing fields produce vague or hallucinated output.

Open Claude Code in the deployment folder, then run:

```
/launch-notes
```

→ Generates `launch-notes.md` with tailored notes for **only the teams listed in your PRD**.

Commit the output:

```bash
git add .
git commit -m "Launch notes: [feature name]"
```

---

## What to Include in the PRD

The system writes from exactly what's in the PRD. Missing field = vague output or hallucinated detail.

### Required fields

| Field | Why it matters | What to write |
|---|---|---|
| Feature name | Header for all notes | Short, unambiguous name |
| Target go-live date | Urgency framing | Specific date or "TBC — targeting [month]" |
| **Teams to Brief** | Controls which notes are generated | See section below — required |
| Target geographies | Prevents Licensing/Legal from listing all jurisdictions | Exact list only — "Singapore, India" not "APAC" |
| Entity types affected | Prevents the model from expanding your descriptor into a full taxonomy | Use exact names you've defined — "sellers and buyers", not "all entity types" |
| Payment rails / PSPs involved | Needed by Payments Pod, Payment Ops, Partnerships | Name them explicitly — "Stripe, BVNK" |
| New transaction types? | Needed by TM, Finance, Data | Yes/no — if yes, describe briefly |
| Sardine involved? | Triggers Sardine mapping check in Compliance + TM | Yes/no |
| Forter involved? | Triggers Forter data structure check in Risk | Yes/no |
| New corridors or currencies | Needed by Treasury, Licensing, Partnerships | List explicitly |
| Rollout strategy | Needed by Engineering | Flag-gated / gradual rollout / hard cutover |
| Expected volumes | Helps Treasury, Finance, Risk avoid invented numbers | Estimates are fine — better than nothing |
| Known risks and mitigations | Needed by Risk, Compliance | What you know now — even if incomplete |

### What NOT to include (it will be repeated back to you)

- Generic entity type lists you haven't defined ("merchants, individuals, businesses, enterprises")
- Vague geographies ("global", "APAC", "emerging markets")
- Speculative compliance or legal implications you haven't confirmed
- Competitor comparisons not relevant to team briefings

---

## Specifying Affected Teams (required for launch-notes)

Add this section near the top of your `PRD.md`:

```markdown
## Teams to Brief

- Compliance — Onboarding
- Risk
- Payment Operations
- Sales
- Engineering
```

The system generates notes **only for teams listed here**. If this section is missing, all 16 teams get a note.

### Full team list (pick the ones relevant to your feature)

| # | Team | Brief when... |
|---|---|---|
| 1 | Compliance — Onboarding | Feature changes onboarding flow, KYC/KYB, entity types, or Sardine data |
| 2 | Compliance — Transaction Monitoring | Feature introduces new transaction types, corridors, or changes monitoring data |
| 3 | Risk | Feature changes checkout/payment flow, involves Forter, or introduces new fraud surface |
| 4 | Payment Operations | Feature changes payment rails, settlement windows, exception handling, or reconciliation |
| 5 | Treasury | Feature introduces new corridors, currencies, or changes prefunding/float requirements |
| 6 | Sales | Any externally launchable feature — Sales needs to pitch it |
| 7 | Account Management | Feature affects existing merchants' experience or creates upsell opportunity |
| 8 | Partnerships | Feature depends on a rail partner, opens a new corridor, or referral partners can pitch it |
| 9 | Legal | Feature changes ToS, data handling, user rights, or introduces a new regulatory jurisdiction |
| 10 | Finance | Feature introduces a new revenue stream, fee type, or changes accounting treatment |
| 11 | Licensing | Feature introduces a new payment activity or geography that could require a new licence |
| 12 | Product — Payments Pod | Feature changes payment initiation, routing logic, or settlement infrastructure |
| 13 | Product — Operations Pod | Feature requires internal dashboard or ops tooling updates |
| 14 | Product — Merchant Pod | Feature changes merchant-facing API, dashboard, docs, or webhook contracts |
| 15 | Product — Data | Feature introduces new events, schema changes, or BI/ML pipeline impact |
| 16 | Engineering | Any feature touching system reliability, deployment, or cross-cutting infrastructure |

### Quick selection guide by feature type

| Feature type | Teams to brief |
|---|---|
| New payment method or rail | 1, 2, 3, 4, 5, 8, 11, 12, 16 |
| New merchant-facing flow | 6, 7, 14, 1, 3 |
| New onboarding or KYC change | 1, 9, 11, 3 |
| New geography or corridor | 1, 2, 5, 8, 9, 11 |
| Internal ops tooling change | 4, 13, 16 |
| Checkout or payment UI change | 3, 1, 14, 12 |
| New data capture or schema change | 15, 2, 16 |

---

## Output

`launch-notes.md` is saved to the deployment folder, alongside your PRD.

Each team section contains:
- **What's changing** — tailored to their function and KPIs
- **Actions / decisions needed** — concrete pre-launch checklist
- **Risks / watch-outs** — escalation flags for their domain

Commit and share the file. Teams read only their section.

---

## Tips

- More specific PRD → more specific notes. If a section looks generic, the PRD is missing detail in that area — add it and re-run.
- Don't use broad entity labels you haven't defined — the model will expand them into a full taxonomy you didn't intend.
- Volume and date estimates are fine — the model will flag them as estimates. Better than leaving them blank and getting invented numbers.
- If a team is listed in "Teams to Brief" but the PRD has nothing for their domain, the note will flag it: *"PRD is silent on X — add detail or confirm this team is not in scope."*
- The output is a starting point, not a final draft. Review each section before sending.

---

## Questions

ritikgarg@tazapay.com · [github.com/ritikgargtaza/Product-launch-notes](https://github.com/ritikgargtaza/Product-launch-notes)
