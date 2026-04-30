# SOP — Launch Notes Generation System

**Owner:** Ritik Garg, Product Marketing
**Last updated:** April 2026
**Applies to:** Anyone writing pre-launch communications at Tazapay

---

## What Is This?

This is a guide for using an AI-assisted system that generates pre-launch sync notes for all 16 internal teams — from a single product idea or PRD.

Instead of writing 16 different versions of the same launch update manually, you write your idea or PRD once, run a command, and get tailored notes for every team in one go.

**This document covers:**
- What you need before you start
- How to set it up on your machine (one time)
- How to use it for every new feature
- What good input looks like
- How to share the output
- How to keep everything up to date

---

## Before You Start

You need two things installed on your laptop:

**1. Claude Code**
Download from **claude.ai/code**. This is the AI tool that runs the commands. If you already have it, you're good.

**2. Git (for saving and sharing your work)**
Most Macs have this already. To check, open Terminal and type:
```bash
git --version
```
If you see a version number, you're set. If not, download from **git-scm.com**.

That's it. No other tools, no coding knowledge required.

---

## One-Time Setup

You only do this once. It takes about 5 minutes.

### Step 1 — Get the two command files

Go to:
**github.com/ritikgargtaza/Product-launch-notes**

Navigate to the `install/` folder. You'll see two files:
- `pre-scope.md`
- `launch-notes.md`

Download both. To download each file:
- Open the file on GitHub
- Click the download icon (top right of the file view)
- Save it anywhere on your machine temporarily (e.g. Downloads folder)

### Step 2 — Copy them to Claude Code

Open your Terminal and run:

```bash
# Create the folder if it doesn't exist
mkdir -p ~/.claude/commands

# Copy the files
cp ~/Downloads/pre-scope.md ~/.claude/commands/
cp ~/Downloads/launch-notes.md ~/.claude/commands/
```

### Step 3 — Verify it worked

Open Claude Code in any folder and type:
```
/user:
```
You should see `pre-scope` and `launch-notes` appear as options.

**You're set up. You never need to do this again unless there's a major update.**

---

## How It Works — The Two Stages

Every feature goes through two stages. You don't have to do both if you don't need to, but the full flow looks like this:

```
Stage 1: Early Idea
Write IDEA.md → Run pre-scope → Get pre-scope.md (8 teams)
        ↓
Share with stakeholders → Gather input → Define scope
        ↓
Stage 2: Full PRD
Write PRD.md → Run launch notes → Get launch-notes.md (16 teams)
        ↓
Share with all teams before launch
```

---

## Stage 1 — Pre-Scope (Before the PRD)

Use this when you have a rough idea but haven't written a full PRD yet. The goal is to surface questions and blockers from 8 key teams before you commit to a full scope.

### Step 1 — Create a folder for your feature

Create a folder anywhere on your machine. Name it something clear.

```bash
mkdir instant-payouts
cd instant-payouts
```

You can also create this inside an existing project folder if that's how your team works.

### Step 2 — Write your idea

Create a file called `IDEA.md` inside that folder. Write your product idea in plain language.

There is no strict format. Just cover these points in however many sentences you need:

- **What is this?** What are you building?
- **Why are we building it?** What problem does it solve? Who asked for it?
- **Who is it for?** Which merchants, customer segments, or geographies?
- **How does it roughly work?** No technical spec needed — just the concept.
- **What do we think changes?** Any early thoughts on compliance, payments, legal, licensing?
- **What don't we know yet?** Open questions or uncertainties.

> **Tip:** Don't overthink this. Even a few rough paragraphs will produce useful output. The more detail you include, the more specific the questions will be.

### Step 3 — Open Claude Code in your feature folder

Open Terminal, navigate to your folder, and open Claude Code:

```bash
cd instant-payouts
claude code
```

Or open the folder in VS Code / Cursor and open Claude Code from there.

### Step 4 — Run the command

In Claude Code, say:

> **run pre-scope**

Claude will:
1. Fetch the latest team context from GitHub (takes a few seconds)
2. Read your `IDEA.md`
3. Generate notes for 8 teams
4. Write `pre-scope.md` in your folder

The 8 teams covered at this stage are the key decision-makers and gatekeepers:
- Compliance — Onboarding
- Compliance — Transaction Monitoring
- Risk
- Legal
- Licensing
- Finance
- Growth — Sales
- Partnerships

### Step 5 — Review and share

Open `pre-scope.md`. Each team section contains:

- **What we know so far** — what the idea implies for their function
- **Questions to answer before scoping** — specific questions they need to resolve
- **Early flags** — potential blockers or hard dependencies to raise now

Share this with the relevant stakeholders. Use it to run a pre-scope alignment meeting or send it async and ask for feedback.

> **What to do with the feedback:** Use it to fill in gaps in your PRD. If Legal or Licensing flags a hard blocker, resolve it before engineering starts.

---

## Stage 2 — Launch Notes (After the PRD)

Use this once your PRD is written and scope is defined. The goal is to give every team the context they need before go-live.

### Step 1 — Add your PRD to the same folder

Save your full PRD as `PRD.md` in the same folder as your `IDEA.md`.

```
instant-payouts/
├── IDEA.md        ← already there from Stage 1
└── PRD.md         ← add this now
```

If you're starting fresh without a pre-scope, just create the folder and add `PRD.md` directly.

> **Format:** Copy your PRD from Notion or Confluence and paste it as plain text or markdown. The tool reads it in full. The richer your PRD, the more specific the output.

### Step 2 — Run the command

In Claude Code (in the same folder), say:

> **run launch notes**

Claude will:
1. Fetch the latest team context and per-team guidance from GitHub
2. Read your `PRD.md` in full
3. Generate notes for all 16 teams
4. Write `launch-notes.md` in your folder

### Step 3 — Review the output

Open `launch-notes.md`. Each of the 16 team sections contains:

- **What's changing** — what this launch means for their specific function and KPIs
- **Actions / decisions needed** — a concrete checklist of what they need to do before launch
- **Risks / watch-outs** — escalation flags specific to their domain

Read through it before sharing. Check that:
- The "What's changing" sections reflect the actual scope accurately
- The actions are specific enough to be actionable
- Any known blockers are flagged in the right team's section

If something looks off or too generic, your PRD probably doesn't have enough detail on that area. Add more context to `PRD.md` and run the command again.

### Step 4 — Share with teams

You have a few options:

**Option A — Share the file directly**
Copy the relevant team section and paste it into a Slack message or email.

**Option B — Share the whole document**
Share `launch-notes.md` as a document and ask each team to read their section.

**Option C — Commit to git and share a link**
If your team uses git, commit the folder and push it:

```bash
git init         # only if not already a git repo
git add .
git commit -m "Launch notes: instant-payouts"
git push
```

Then share the link to `launch-notes.md` on GitHub.

---

## Keeping Your Work Organised

There's no single required way to store your feature folders. Use whatever works for your team. A few approaches that work well:

**Option 1 — Standalone folders per feature**
Each feature gets its own folder on your machine. Simple, no dependencies.

**Option 2 — Inside your existing project repo**
If you already have a product or docs repo, add a `launch-notes/` folder inside it and create feature subfolders there.

**Option 3 — Clone the main repo and use `deployments/`**
If you want full version history across all features in one place, clone **github.com/ritikgargtaza/Product-launch-notes** and use the `deployments/` folder structure built into it.

All three approaches work. Choose based on how your team already works.

---

## What Good Input Looks Like

The quality of the output depends on the quality of your input. Here's the difference:

**Weak IDEA.md (produces generic output):**
> We want to let merchants pay out to their sub-entities.

**Strong IDEA.md (produces specific, useful output):**
> We want to let marketplace merchants create checkout sessions on behalf of individual sellers registered as entities in Tazapay. Today everything attributes to the merchant account. The gap is that for platforms with hundreds of sellers, there's no way to track which seller received which payment. We think this affects how we handle AML monitoring, entity approval workflows, and possibly our licensing in remittance markets. We don't know yet whether entity approval should be mandatory or optional.

The second version gives Claude enough to ask the right questions for each team.

**Same principle applies to PRD.md:**
- Include volumes or estimates where you have them
- Name the specific entity types, corridors, or payment rails involved
- Call out what is explicitly out of scope
- Flag any compliance or legal considerations you're already aware of

---

## When the Team Context Changes

The system fetches team descriptions and per-team writing guidance from GitHub every time you run a command. This means:

- If a team's function or focus changes, the owner updates the GitHub repo
- Your next run automatically picks up the latest version
- You don't need to re-download or update anything on your machine

The only time you'd need to re-download the command files (`pre-scope.md` and `launch-notes.md` from the `install/` folder) is if the command logic itself changes — which is rare. The repo README will note this when it happens.

---

## Troubleshooting

**"I ran the command but nothing happened"**
Make sure you're in the folder that contains `IDEA.md` or `PRD.md` when you run the command. The command reads from the current folder.

**"The output is too generic"**
Your input file needs more detail. Add context around geographies, customer segments, known risks, and open questions. Run the command again.

**"The command isn't showing up"**
Check that the files are in the right place:
```bash
ls ~/.claude/commands/
# Should show: pre-scope.md  launch-notes.md
```
If they're not there, repeat the setup step.

**"It fetched the wrong team context"**
This shouldn't happen — it always fetches from the main branch of the repo. If something looks off, let the repo owner know.

**"I want to regenerate the notes after updating my PRD"**
Just update `PRD.md` and run `"run launch notes"` again. It overwrites the previous `launch-notes.md`.

---

## Quick Reference

```
Setup (once):
  Download install/pre-scope.md and install/launch-notes.md from GitHub
  Copy to ~/.claude/commands/

New feature:
  mkdir feature-name && cd feature-name
  Write IDEA.md → say "run pre-scope" → get pre-scope.md
  Write PRD.md  → say "run launch notes" → get launch-notes.md

Update:
  Nothing to do — team context auto-fetches latest from GitHub on every run
```

---

## Questions or Feedback

If something isn't working or you want to suggest improvements to the team descriptions or output format, reach out to **ritikgarg@tazapay.com** or open an issue on the repo.

**Repo:** github.com/ritikgargtaza/Product-launch-notes

---

*This is a living document. As the system evolves, this SOP will be updated.*
