# Launch Notes — SOP

**Owner:** Ritik Garg, Product | **Last updated:** April 2026

One command. 16 teams. No manual writing.

---

## Prerequisites

- [Claude Code](https://claude.ai/code) installed
- Git installed (`git --version` to check)

---

## One-Time Setup

1. Go to `github.com/ritikgargtaza/Product-launch-notes` → `install/` folder
2. Download `pre-scope.md` and `launch-notes.md`
3. Copy both to `~/.claude/commands/`

```bash
cp ~/Downloads/pre-scope.md ~/.claude/commands/
cp ~/Downloads/launch-notes.md ~/.claude/commands/
```

Done. You never need to do this again.

---

## For Every Feature

### Stage 1 — Before PRD

```bash
mkdir your-feature && cd your-feature
```

Write `IDEA.md` — what you're building, who it's for, what you think changes, open questions. Then in Claude Code:

> **run pre-scope**

→ Outputs `pre-scope.md` with questions and flags for 8 key teams (Compliance, Risk, Legal, Licensing, Finance, Sales, Partnerships). Share before writing your PRD.

### Stage 2 — After PRD

Add `PRD.md` to the same folder. In Claude Code:

> **run launch notes**

→ Outputs `launch-notes.md` with What's changing / Actions needed / Risks for all 16 teams.

---

## Tips

- More detail in your input = more specific output. Generic idea → generic notes.
- If a section looks off, your PRD is missing context in that area — add it and re-run.
- Team context auto-updates from GitHub. You don't need to re-download anything when team descriptions change.

---

## Questions

ritikgarg@tazapay.com · `github.com/ritikgargtaza/Product-launch-notes`
