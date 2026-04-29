# Quick Start Guide

Get your release notes generated in 3 steps.

## 1️⃣ Open This Folder in Claude Code

```bash
# In VS Code or Antigravity:
File → Open Folder → Select prd-automation/
```

Or paste the folder path directly.

---

## 2️⃣ Share Your PRD

In the Claude conversation, provide one of:

**Option A: Notion Link**
```
Here's my PRD: https://www.notion.so/My-PRD-Title-abc123def456
```

**Option B: Paste Content**
```
[Paste your PRD content here]
```

---

## 3️⃣ Confirm & Generate

Claude will:
1. ✅ Read your PRD
2. ✅ Suggest affected teams
3. ✅ Ask you to confirm teams
4. ✅ Generate team-specific release notes
5. ✅ Create Notion sub-pages

**Total time:** ~10 minutes

---

## Configuration (One-Time Setup)

### Update MCP Connection

Edit `config/mcp.config.json`:

```json
{
  "mcp_server": {
    "url": "YOUR_MCP_CONNECTION_LINK_HERE"
  }
}
```

### Check Release Note Prompts

Ensure folder exists: `../release-note-file/`

Files should include:
- `engineering.md`
- `product.md`
- `marketing.md`
- `operations.md`
- (any custom teams)

---

## What Happens at Each Step

| Step | What Claude Does | Your Input |
|------|-----------------|-----------|
| **Read** | Fetches PRD from Notion via MCP | Provide Notion link |
| **Analyze** | Identifies affected teams | Confirm/modify team list |
| **Generate** | Creates team-specific notes | Review generated content |
| **Post** | Creates Notion sub-pages | Approve posting |

---

## Key Files

```
prd-automation/
├── README.md                      ← Full overview
├── main.md                        ← Complete documentation
├── QUICKSTART.md                  ← This file
├── config/
│   └── mcp.config.json           ← Update with your MCP link
├── src/
│   └── orchestrator.md           ← Detailed workflow
├── docs/
│   ├── mcp-setup.md              ← MCP configuration
│   ├── team-prompts-guide.md     ← How to write prompts
│   └── troubleshooting.md        ← Common issues
└── workflows/
    └── example-workflow.md       ← Example execution
```

---

## Common Commands

### Generate Release Notes
```
Share PRD link → Confirm teams → Done!
(Claude handles everything)
```

### Edit Generated Content
```
When prompted, choose "Edit" → Make changes → Approve posting
```

### Add New Team
```
1. Create ../release-note-file/{team-name}.md
2. Add your team's prompt
3. Next generation auto-includes new team
```

### Change Team Prompt
```
1. Edit file in ../release-note-file/
2. Generate again with updated prompt
```

---

## Troubleshooting

### MCP not connecting?
→ Check `config/mcp.config.json` has correct URL  
→ Verify Notion page is shared with MCP integration

### Can't find release-note-file?
→ Folder should be at same level as prd-automation/  
→ Files should be lowercase: `engineering.md` not `Engineering.md`

### Generated content too short?
→ Edit team prompt in release-note-file/  
→ Add more specific guidance or examples

### Need more help?
→ See `docs/troubleshooting.md`  
→ Review `workflows/example-workflow.md` for full flow

---

## File Structure Overview

```
Your working folder/
├── prd-automation/          ← Agent & configuration
│   ├── config/              ← MCP config (update once)
│   ├── src/                 ← Orchestration guide
│   ├── docs/                ← Full documentation
│   ├── output/              ← Generated content (temp)
│   └── workflows/           ← Example workflows
│
└── release-note-file/       ← Your team prompts
    ├── engineering.md
    ├── product.md
    ├── marketing.md
    ├── operations.md
    └── [custom teams].md
```

---

## Next Actions

### First Time
- [ ] Update MCP link in `config/mcp.config.json`
- [ ] Verify `../release-note-file/` exists with your prompts
- [ ] Open prd-automation/ in Claude Code
- [ ] Share first PRD link

### For Each Release
- [ ] Provide PRD link or content
- [ ] Confirm affected teams
- [ ] Review generated content
- [ ] Approve posting to Notion

---

## Example Command

```
In Claude Code conversation:

User: I have a new PRD that affects multiple teams.
      Here's the Notion link: https://www.notion.so/Release-Title-abc123
      
      Can you generate team-specific release notes?

Claude: ✓ I'll help with that. Let me read the PRD and analyze it...
        [Reads from Notion via MCP]
        
        I found 4 affected teams:
        1. Engineering [HIGH]
        2. Product [HIGH]
        3. Marketing [MEDIUM]
        4. Operations [LOW]
        
        Should I proceed with all 4? (approve/remove/add)

User: Approve all

Claude: [Generates release notes for all 4 teams]
        [Creates sub-pages in Notion]
        
        ✓ All complete! Here are your release notes:
        - Engineering: https://...
        - Product: https://...
        - Marketing: https://...
        - Operations: https://...
```

---

## Features

✅ Read PRD directly from Notion  
✅ Automatically identify affected teams  
✅ Interactive confirmation gates  
✅ Team-specific prompt customization  
✅ Generate all notes at once  
✅ Create Notion sub-pages automatically  
✅ Review before posting  
✅ Local backup of all content  

---

## Time Savings

| Task | Without Agent | With Agent |
|------|--------------|-----------|
| Read PRD | 15 min | 1 min |
| Analyze impacts | 30 min | 2 min |
| Write 4 release notes | 120 min | 5 min |
| Create Notion pages | 15 min | 1 min |
| **TOTAL** | **180 min** | **9 min** |
| **SAVED** | — | **171 min** |

---

## Support

**Documentation:**
- Full Guide: `main.md`
- MCP Setup: `docs/mcp-setup.md`
- Team Prompts: `docs/team-prompts-guide.md`
- Troubleshooting: `docs/troubleshooting.md`

**Examples:**
- Workflow: `workflows/example-workflow.md`
- Orchestration: `src/orchestrator.md`

---

## Ready?

✅ Configuration updated  
✅ Folder structure ready  
✅ Release note prompts in place  

**Next:** Open prd-automation/ in Claude Code and share your PRD!
