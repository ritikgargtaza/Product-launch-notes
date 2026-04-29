# Team Guide — Launch Notes System

Generate pre-launch sync notes for all 16 teams from a single PRD or product idea. One command replaces writing 16 versions of the same update manually.

---

## What You Get

| Stage | Input | Command | Output | Teams |
|-------|-------|---------|--------|-------|
| Before PRD | `IDEA.md` — rough one-pager | `run pre-scope` | `pre-scope.md` | 8 key teams |
| After PRD | `PRD.md` — full requirements | `run launch notes` | `launch-notes.md` | All 16 teams |

---

## Setup (One Time — 3 Steps)

### Step 1 — Install Claude Code
Download from **claude.ai/code** if you don't have it already.

### Step 2 — Download the two command files

Go to the repo and download both files from the `install/` folder:

```
github.com/ritikgargtaza/Product-launch-notes
└── install/
    ├── pre-scope.md       ← download this
    └── launch-notes.md    ← download this
```

### Step 3 — Copy them to your Claude Code global commands folder

```bash
# On Mac
cp pre-scope.md ~/.claude/commands/
cp launch-notes.md ~/.claude/commands/
```

That's it. You never need to touch these files again unless there's an update.

> **How updates work:** When team descriptions or instructions change, the repo is updated on GitHub. The commands fetch the latest version automatically every time you run them — you don't need to re-download anything.

---

## Using It (Every Feature)

### Step 1 — Create a folder for your feature anywhere on your machine

```bash
mkdir instant-payouts
cd instant-payouts
```

No specific location required. Works inside any existing project folder too.

### Step 2 — Write your idea

Create a file called exactly `IDEA.md` and write your one-pager inside it.

```bash
# Create and open the file
touch IDEA.md
```

No strict format required. Include in plain language:
- What you're building and why
- Who it's for
- What you think changes
- Known risks or open questions

The more detail you give, the better the output.

### Step 3 — Open Claude Code in that folder

```bash
claude code
```

Or open the folder in your IDE and open Claude Code there.

### Step 4 — Run pre-scope

In Claude Code say:

> **"run pre-scope"**

Claude fetches the latest team context from GitHub, reads your `IDEA.md`, and writes `pre-scope.md` covering 8 key teams:

- Compliance — Onboarding
- Compliance — Transaction Monitoring
- Risk
- Legal
- Licensing
- Finance
- Growth — Sales
- Partnerships

Each section has: what we know so far, questions to answer before scoping, early flags.

**Share `pre-scope.md` with stakeholders. Gather feedback. Define scope.**

### Step 5 — Write your PRD

Once scope is defined, create `PRD.md` in the same folder and write your full product requirements.

### Step 6 — Run launch notes

In Claude Code say:

> **"run launch notes"**

Claude fetches the latest team context and per-team guidance from GitHub, reads your `PRD.md`, and writes `launch-notes.md` covering all 16 teams.

Each team section has:
- **What's changing** — specific to their function and KPIs
- **Actions / decisions needed** — concrete pre-launch checklist
- **Risks / watch-outs** — escalation flags for their domain

### Step 7 — Share with teams

Your folder now contains:
```
your-feature/
├── IDEA.md          ← your rough idea
├── pre-scope.md     ← 8 teams, pre-scope questions
├── PRD.md           ← your full PRD
└── launch-notes.md  ← 16 teams, full launch sync
```

Share `launch-notes.md` directly, or commit to git and share the link.

---

## File Naming Rules

The commands look for files by exact name:

| File | Used by |
|------|---------|
| `IDEA.md` | `run pre-scope` |
| `PRD.md` | `run launch notes` |

Name them anything else and the command won't find them.

---

## Tips for Better Output

**Better `IDEA.md`:**
- Mention the customer segment and geography — even roughly
- Flag anything you already know is a compliance or legal concern
- Include open questions — Claude uses these to surface the right flags per team

**Better `PRD.md`:**
- Include volumes or transaction estimates if you have them
- Name specific entity types, corridors, or payment rails
- Call out what is explicitly out of scope
- Flag any regulatory or licensing considerations you're aware of

**If output seems generic:** your input is too short — add more detail and run again.

---

## When There's an Update

When team descriptions or per-team instructions are updated on GitHub, **you don't need to do anything** — the commands fetch the latest version from GitHub every time they run.

The only time you need to re-download command files is if the command logic itself changes (rare). The repo README will note this when it happens.

---

## Questions?

Reach out to **ritikgarg@tazapay.com** or raise an issue on the repo.
