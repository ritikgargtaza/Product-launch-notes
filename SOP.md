# Launch Notes — SOP

**Owner:** Ritik Garg, Product | **Last updated:** May 2026

One command. Tailored notes. Only for the teams that matter.

| Stage | Input | Command | Output |
|---|---|---|---|
| Before PRD | `IDEA.md` — rough one-pager | `/pre-scope` | Questions + flags for 8 key teams |
| After PRD | `PRD.md` — full requirements | `/launch-notes` | Tailored notes for teams listed in PRD |

---

## Setup (one time, 3 minutes)

### 1. Install Claude Code

Download from [claude.ai/code](https://claude.ai/code) and log in.

Or install via terminal:
```bash
npm install -g @anthropic-ai/claude-code
```

### 2. Install the commands

Download these two files from GitHub and copy them to `~/.claude/commands/`:

- [`launch-notes.md`](https://github.com/ritikgargtaza/Product-launch-notes/blob/main/install/launch-notes.md) — generates per-team launch notes from a PRD
- [`pre-scope.md`](https://github.com/ritikgargtaza/Product-launch-notes/blob/main/install/pre-scope.md) — generates early-stage questions before a PRD exists

```bash
# After downloading both files:
cp ~/Downloads/launch-notes.md ~/.claude/commands/launch-notes.md
cp ~/Downloads/pre-scope.md ~/.claude/commands/pre-scope.md
```

Done. You never need to do this again unless the commands are updated.

---

## For every feature

### Before the PRD — optional but recommended

Create a folder anywhere for your feature. Inside it, create `IDEA.md` — a rough one-pager with what you're building, who it's for, and what you think changes.

Open Claude Code in that folder, then run:
```
/pre-scope
```
→ Generates `pre-scope.md` with questions and early flags for 8 key teams. Share before writing the PRD.

---

### After the PRD

Create `PRD.md` in your feature folder. Use `PRD_TEMPLATE.md` as a starting point (available in the same GitHub repo).

**The most important thing to add:** a `## Teams to Brief` section near the top.

```markdown
## Teams to Brief

- Compliance — Onboarding
- Risk
- Payment Operations
- Sales
- Engineering
```

Only the teams you list will get a note. Without this section, all 16 teams get one.

Open Claude Code in the folder, then run:
```
/launch-notes
```
→ Generates `launch-notes.md` with tailored notes for each listed team.

Your folder will contain:
```
your-feature/
├── IDEA.md           ← your rough idea
├── pre-scope.md      ← 8 teams, pre-scope questions
├── PRD.md            ← your full PRD
└── launch-notes.md   ← tailored notes per team
```

The commands look for files by exact name — `IDEA.md` for pre-scope, `PRD.md` for launch notes.

---

## What to put in the PRD

The system writes from exactly what's in the PRD. Missing fields = vague or hallucinated output.

| Field | Why it matters |
|---|---|
| `## Teams to Brief` | Controls which notes are generated |
| Target geographies | Exact list — "Singapore, India", not "APAC" |
| Entity types affected | Exact names you've defined — don't use broad labels |
| Payment rails / PSPs | Name them explicitly |
| Sardine involved? Yes/No | Triggers Sardine check in Compliance + TM |
| Forter involved? Yes/No | Triggers Forter check in Risk |
| New corridors / currencies | Exact list |
| Rollout strategy | Flag-gated / gradual / hard cutover |
| Expected volumes | Estimates are fine — better than blank |
| Known risks | Even partial — the model will flag what's unresolved |

---

## Which teams to list

| Feature type | Teams to brief |
|---|---|
| New payment method or rail | Compliance (both), Risk, Payment Ops, Treasury, Partnerships, Licensing, Payments Pod, Engineering |
| New merchant-facing flow | Sales, Account Management, Merchant Pod, Compliance Onboarding, Risk |
| New onboarding / KYC change | Compliance Onboarding, Legal, Licensing, Risk |
| New geography or corridor | Compliance (both), Treasury, Licensing, Legal, Partnerships |
| Internal ops tooling change | Payment Ops, Operations Pod, Engineering |
| Checkout or payment UI change | Risk, Compliance Onboarding, Merchant Pod, Payments Pod |
| New data or schema change | Data Pod, Engineering |

Full team list:
1. Compliance — Onboarding
2. Compliance — Transaction Monitoring
3. Risk
4. Payment Operations
5. Treasury
6. Sales
7. Account Management
8. Partnerships
9. Legal
10. Finance
11. Licensing
12. Product — Payments Pod
13. Product — Operations Pod
14. Product — Merchant Pod
15. Product — Data
16. Engineering

---

## Tips

- More specific PRD → more specific notes. If a section looks generic, the PRD is missing detail in that area — add it and re-run.
- Use exact entity type names you've defined. "Sellers and buyers" is fine. "Merchants, individuals, businesses, and enterprises" invites the model to invent a taxonomy.
- Volume estimates are fine. The model will label them as estimates. Leaving them blank produces invented numbers.
- If a team is listed but the PRD has nothing for their domain, the note will say so — treat that as a prompt to add the missing detail or remove that team from the list.

---

## Questions

ritikgarg@tazapay.com
