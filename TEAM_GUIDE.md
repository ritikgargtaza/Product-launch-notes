# Team Guide — Launch Notes System

This repo generates pre-launch sync notes for all 16 teams from a single PRD or product idea. One command replaces writing 16 versions of the same update manually.

---

## What You Get

**Two outputs per feature:**

| Stage | Input | Command | Output | Teams |
|-------|-------|---------|--------|-------|
| Before PRD | `IDEA.md` — rough one-pager | `run pre-scope` | `pre-scope.md` | 8 key teams |
| After PRD | `PRD.md` — full requirements | `run launch notes` | `launch-notes.md` | All 16 teams |

**Pre-scope** surfaces questions and blockers before engineering starts.
**Launch notes** gives every team their specific actions, decisions, and risks before go-live.

---

## Setup (One Time)

### 1. Clone the repo
```bash
git clone https://github.com/ritikgargtaza/Product-launch-notes.git
cd Product-launch-notes
```

### 2. Install Claude Code
Download from: **claude.ai/code**

That's it. No other dependencies.

---

## Using It (Every Feature)

### Step 1 — Create a folder for your feature
```bash
./new-launch.sh "your-feature-name"
```
This creates `deployments/your-feature-name/` with an `IDEA.md` template inside.

**Naming convention:** use lowercase with hyphens. Examples:
- `instant-payouts`
- `checkout-obo`
- `kyc-travel-rule-update`

---

### Step 2 — Fill in your idea
Open `deployments/your-feature-name/IDEA.md` and write your one-pager.

**No strict format required.** Write in plain language. Include:
- What you're building and why
- Who it's for
- What you think changes
- Any known risks or open questions

The more detail you give, the better the output.

---

### Step 3 — Generate pre-scope notes
Open Claude Code in the deployment folder and say:

> **"run pre-scope"**

Claude reads your `IDEA.md` and the shared team context, then writes `pre-scope.md` covering 8 teams:
- Compliance — Onboarding
- Compliance — Transaction Monitoring
- Risk
- Legal
- Licensing
- Finance
- Growth — Sales
- Partnerships

**Use this to:** share with stakeholders before writing the PRD. It surfaces the questions each team needs answered before full scoping.

---

### Step 4 — Write your PRD
Once pre-scope feedback is gathered and scope is defined, write your full PRD.

Save it as `PRD.md` in the same deployment folder:
```
deployments/your-feature-name/PRD.md
```

---

### Step 5 — Generate launch notes
In Claude Code, say:

> **"run launch notes"**

Claude reads your `PRD.md` plus the shared team context and writes `launch-notes.md` covering all 16 teams:

1. Compliance — Onboarding
2. Compliance — Transaction Monitoring
3. Risk
4. Payment Operations
5. Treasury
6. Growth — Sales
7. Growth — Account Management
8. Partnerships
9. Legal
10. Finance
11. Licensing
12. Product — Payments Pod
13. Product — Operations Pod
14. Product — Merchant Pod
15. Product — Data
16. Engineering

Each team section has:
- **What's changing** — specific to their function and KPIs
- **Actions / decisions needed** — concrete pre-launch checklist
- **Risks / watch-outs** — escalation flags for their domain

---

### Step 6 — Commit and push
```bash
git add .
git commit -m "Launch notes: your-feature-name"
git push
```

Everyone on the team can now run `git pull` to get the latest notes.

---

## Folder Structure After a Full Launch

```
deployments/your-feature-name/
├── IDEA.md           ← your rough idea (input for pre-scope)
├── pre-scope.md      ← generated: 8 teams, pre-scope questions
├── PRD.md            ← your full PRD (input for launch notes)
└── launch-notes.md   ← generated: 16 teams, full launch sync
```

---

## Tips for Better Output

**Write a better IDEA.md:**
- Mention the customer segment and geography — even roughly
- Flag anything you already know is a compliance or legal concern
- Include open questions — Claude uses these to surface the right flags

**Write a better PRD.md:**
- Include volumes or transaction estimates if you have them
- Name the specific entity types, corridors, or rails involved
- Call out what is explicitly out of scope
- Flag any regulatory or licensing considerations you're aware of

**If the output seems generic:**
Your input is probably too short. Add more detail to `IDEA.md` or `PRD.md` and run the command again.

---

## Updating and Iterating

**If your PRD changes after notes are generated:**
1. Update `PRD.md`
2. Say `"run launch notes"` again — it overwrites the previous file
3. Commit the new version: `git commit -m "Launch notes: feature-name v2"`

**To see history of all launches:**
```bash
git log --oneline deployments/
```

**To compare two versions of notes:**
```bash
git diff HEAD~1 deployments/feature-name/launch-notes.md
```

---

## Shared Files (Do Not Edit Without Team Alignment)

| File | What it is | How to update |
|------|-----------|---------------|
| `team-context/team_descriptions.md` | Who each team is, what they care about, their tone | Update when a team's function or focus changes |
| `Release-note-file/01_*.md` → `16_*.md` | Per-team writing guides | Update when team-specific guidance needs to change |
| `.claude/commands/pre-scope.md` | Instructions Claude follows for pre-scope | Update if you want to change the output format |
| `.claude/commands/launch-notes.md` | Instructions Claude follows for launch notes | Update if you want to change the output format |

Changes to any of these files affect all future launches. Commit and push so the whole team benefits.

---

## Quick Reference

```bash
# Start a new feature
./new-launch.sh "feature-name"

# Generate pre-scope (say this in Claude Code)
"run pre-scope"

# Generate launch notes (say this in Claude Code)
"run launch notes"

# Save and share
git add . && git commit -m "Launch notes: feature-name" && git push

# Get latest from teammates
git pull
```

---

## Questions?
Reach out to **ritikgarg@tazapay.com**
