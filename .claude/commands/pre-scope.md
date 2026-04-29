Generate a pre-scope alignment note for 8 key teams from an early product idea.

You are operating inside a deployment folder. Follow these steps exactly:

## Step 1 — Read the Idea

Read the file `IDEA.md` in the current working directory. This is an early one-pager — not a full PRD. It may be rough, incomplete, or high-level. Extract:
- What the product or feature is trying to do
- Who it serves
- Any early thoughts on how it works
- Any known constraints or risks mentioned

## Step 2 — Load Team Context

Read the file at `../../team-context/team_descriptions.md`.

You will only use these 8 teams for pre-scope:
1. Compliance — Onboarding
2. Compliance — Transaction Monitoring
3. Risk
4. Legal
5. Licensing
6. Finance
7. Growth — Sales
8. Partnerships

## Step 3 — Generate Pre-Scope Notes

For each of the 8 teams, write a section using this exact structure:

```
## [Team Name]

**What we know so far**
2–3 sentences. Based only on what's in the idea, describe what this likely means for this team's function. Be honest about what's unclear — don't fill in gaps with assumptions.

**Questions to answer before scoping**
- 3–5 bullet points. Specific questions this team needs to answer or decisions they need to make before the product can be fully scoped. Frame as actual questions, not tasks.

**Early flags**
- 1–2 bullet points. Anything that could be a blocker, regulatory constraint, or dependency this team should flag now — before engineering and product invest in a full PRD.
```

## Step 4 — Write Output File

Save the complete output as `pre-scope.md` in the current working directory.

Use this header:

```markdown
# Pre-Scope Alignment Note

**Idea:** [Title from IDEA.md]
**Date:** [Today's date]
**Stage:** Pre-scope — based on idea only, not a full PRD
**Teams covered:** Compliance (Onboarding), Compliance (TM), Risk, Legal, Licensing, Finance, Sales, Partnerships

> This note is generated from an early idea, not a scoped PRD. Use it to surface questions and blockers before committing to full scoping. Once a PRD exists, run `/project:launch-notes` for the full 16-team launch note.

---
```

Then append all 8 team sections, each separated by `---`.

## Tone Guidelines

- **Not prescriptive** — at this stage we don't know what the product will do exactly, so avoid confident statements about what will or won't change
- **Question-oriented** — the goal is to surface what needs to be decided, not to give instructions
- **Honest about gaps** — if the idea doesn't mention compliance implications, say so rather than inventing them
- **Flag real blockers** — if something in the idea looks like it could be a hard blocker for Legal or Licensing, say so clearly

## Quality Rules

- All 8 teams must have a section
- "Questions to answer" must be actual questions (end with ?)
- Do not copy the same questions across teams — each team's questions must be specific to their function
- Do not write as if the PRD is already written — this is pre-scope
- Keep "What we know so far" honest — if very little is known for a team, say so in 1 sentence

Once `pre-scope.md` is written, confirm: "pre-scope.md has been generated. Share it with the 8 teams to gather input before full scoping. Once your PRD is ready, run `/project:launch-notes`."
