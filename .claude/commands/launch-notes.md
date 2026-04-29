Generate pre-launch sync notes for all 16 teams from a PRD.

You are operating inside a deployment folder. Follow these steps exactly:

## Step 1 — Read the PRD

Read the file `PRD.md` in the current working directory. Read it in full. Understand:
- What the feature or product is
- Who it affects (customer segments, geographies)
- What changes technically or operationally
- Timeline, volumes, risks

## Step 2 — Load Team Context

Read the file at this path relative to the current deployment folder:
`../../team-context/team_descriptions.md`

This file contains 16 teams. For each team, note their:
- **Function** — what they own
- **Key concerns at launch** — what they care about
- **Tone** — how to communicate with them

## Step 3 — Generate Notes for All 16 Teams

For each of the 16 teams, write a section using this exact structure:

```
## For [Team Name]

**What's changing**
2–3 sentences. Translate the PRD's impact into language specific and meaningful to this team's day-to-day responsibilities. Do NOT summarise the PRD generically — speak to their KPIs and function.

**Actions / decisions needed**
- Bullet list of 3–5 concrete pre-launch steps this team must take
- Be specific (e.g. "Update KYC SOP for new merchant segment" not "Review compliance requirements")

**Risks / watch-outs**
- Bullet list of 2–3 escalation flags specific to this team's domain
- Things that could go wrong in their area
```

## Step 4 — Write Output File

Save the complete output as `launch-notes.md` in the current working directory.

Use this header:

```markdown
# Pre-Launch Sync Notes

**Feature:** [Feature name from PRD]
**Date:** [Today's date]
**Teams covered:** 16

> These notes are tailored per team. Each team should read their section only.

---
```

Then append all 16 team sections, each separated by `---`.

## Teams to Cover (in this order)

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

## Quality Rules

- Every section must have all three parts: What's changing, Actions/decisions, Risks/watch-outs
- Language must be tailored to each team — not copy-pasted across teams
- Actions must be concrete and specific, not generic
- Use numbers/volumes/geographies from the PRD wherever possible
- Each "What's changing" should be 2–3 sentences max
- Total output should be comprehensive but scannable

Once `launch-notes.md` is written, confirm to the user: "launch-notes.md has been generated. Review it and run `git add . && git commit -m 'Launch notes: [feature name]'` to save."
