Generate a pre-scope alignment note for 8 key teams from an early product idea.

## Step 1 — Fetch Latest Team Context from GitHub

Fetch this file using WebFetch:
https://raw.githubusercontent.com/ritikgargtaza/Product-launch-notes/main/team-context/team_descriptions.md

From it, load the Function, Key Concerns, and Tone for these 8 teams only:
1. Compliance — Onboarding
2. Compliance — Transaction Monitoring
3. Risk
4. Legal
5. Licensing
6. Finance
7. Growth — Sales
8. Partnerships

## Step 2 — Read the Idea

Read `IDEA.md` from the current working directory.

This is an early one-pager — not a full PRD. It may be rough or incomplete. Extract:
- What the product or feature is trying to do
- Who it serves
- Any early thoughts on how it works
- Known constraints or risks

## Step 3 — Generate Pre-Scope Notes

For each of the 8 teams, write a section using this structure:

```
## [Team Name]

**What we know so far**
2–3 sentences. Based only on what's in the idea, describe what this likely means for this team. Be honest about gaps — do not invent detail that isn't in the idea.

**Questions to answer before scoping**
- 3–5 specific questions this team needs to answer before the product can be fully scoped
- Frame as actual questions (end with ?)
- Each question must be specific to this team's function — not generic

**Early flags**
- 1–2 potential blockers, regulatory constraints, or dependencies to flag now
- Only include if genuinely flagged by the idea — do not invent risks
```

## Step 4 — Write Output File

Save as `pre-scope.md` in the current working directory.

Header:
```markdown
# Pre-Scope Alignment Note

**Idea:** [Title from IDEA.md]
**Date:** [Today's date]
**Stage:** Pre-scope — based on idea only, not a full PRD
**Teams covered:** Compliance (Onboarding), Compliance (TM), Risk, Legal, Licensing, Finance, Sales, Partnerships

> Use this to surface questions and blockers before committing to a full PRD.
> Once a PRD exists, run /project:launch-notes for the full 16-team note.

---
```

## Tone Rules

- Question-oriented — the goal is surfacing what needs to be decided, not giving instructions
- Honest about gaps — if the idea doesn't mention compliance implications, say so rather than inventing them
- Do not copy the same questions across teams — each must be specific to their function

Once done, confirm: "pre-scope.md has been generated. Share with the 8 teams before writing your PRD. When your PRD is ready, run launch-notes."
