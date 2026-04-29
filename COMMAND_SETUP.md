# Setting Up the /project:launch-notes Command

## Overview

The `/project:launch-notes` command is a **manual workflow** that generates launch notes for all 16 teams from a PRD.

### How it works:
1. Navigate to a deployment folder (with a PRD.md file)
2. Type `/project:launch-notes` in Claude Code
3. Claude reads PRD.md and team_descriptions.md
4. Claude generates launch-notes.md automatically
5. Review, commit, and share

See README.md for quick start and CLAUDE.md for full documentation.

---

## Quick Setup

```bash
# 1. Verify folder structure
ls team-context/team_descriptions.md   # Should exist
ls deployments/                        # Should exist

# 2. Create a deployment folder
mkdir deployments/my-feature
cd deployments/my-feature

# 3. Add your PRD
nano PRD.md    # Paste your product requirements

# 4. Open Claude Code
claude code

# 5. Generate notes
# Type: /project:launch-notes

# 6. Review and commit
git add .
git commit -m "Launch notes: my-feature"
git push
```

## How the Command Works

When you type `/project:launch-notes` in a deployment folder:

1. Claude reads `PRD.md` (in current directory)
2. Claude loads `team_descriptions.md` (from ../../team-context/)
3. Claude generates a section for each of 16 teams
4. Output saved to `launch-notes.md` (in current directory)

## Execution Details

See `.claude-tools/launch-notes-prompt.md` for the full prompt that Claude executes.

Each team section includes:
- **What's changing** — 2-3 sentences specific to their function
- **Actions/decisions needed** — Concrete pre-launch steps
- **Risks/watch-outs** — Escalation flags for their domain

## Version Control

```bash
# Each launch is committed to git
git log deployments/my-feature/
git diff deployments/v1/ deployments/v2/  # Compare launches
```

---

See full documentation in CLAUDE.md and README.md.
