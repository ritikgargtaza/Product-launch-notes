# Launch Notes System

Generate pre-launch sync notes for all 16 internal teams from a single PRD or product idea.

---

## What It Does

| Stage | Input | Command | Output |
|-------|-------|---------|--------|
| Before PRD | `IDEA.md` | `run pre-scope` | Heads-up note for 8 key teams — early flags, open questions, blockers to resolve before scoping |
| After PRD | `PRD.md` | `run launch notes` | Tailored release note for all 16 teams — what's changing, actions needed, risks |

---

## Setup

1. Download `pre-scope.md` and `launch-notes.md` from the `install/` folder
2. Copy both to `~/.claude/commands/`

```bash
cp ~/Downloads/pre-scope.md ~/.claude/commands/
cp ~/Downloads/launch-notes.md ~/.claude/commands/
```

Full setup and usage guide: [SOP.md](./SOP.md)

---

## Repo Structure

```
install/              ← Command files to copy to ~/.claude/commands/
team-context/         ← Team descriptions (fetched at runtime)
Release-note-file/    ← Per-team writing guidance (fetched at runtime)
deployments/          ← Example outputs
SOP.md                ← Setup and usage guide
TEAM_GUIDE.md         ← Quick reference
```

---

**Owner:** ritikgarg@tazapay.com
