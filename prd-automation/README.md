# PRD Release Notes Automation Agent

Automate team-specific product release note generation directly from Notion using Claude and MCP integration.

## 🚀 Quick Start

### 1. Load into Claude Code / Antigravity

```bash
# Open this folder in VS Code or Antigravity
code prd-automation/

# Or navigate in Antigravity:
# File → Open Folder → Select prd-automation/
```

### 2. Provide Your PRD

**Option A: Notion Link**
```
Share your Notion PRD link:
https://www.notion.so/PRD-Title-abc123def456
```

**Option B: Paste Content**
```
Paste your PRD content directly in the chat
```

### 3. Claude Does the Rest

The agent automatically:
- ✅ Reads PRD via Notion MCP
- ✅ Analyzes and suggests affected teams
- ✅ Gets your confirmation on team list
- ✅ Loads team prompts from `release-note-file/`
- ✅ Generates team-specific release notes
- ✅ Creates sub-pages in Notion

## 📁 Folder Structure

```
prd-automation/
├── config/
│   └── mcp.config.json          ← MCP & Notion configuration
├── src/
│   └── orchestrator.md          ← Main orchestration guide
├── workflows/
│   └── generate-release-notes.workflow  ← Optional workflow
├── output/
│   └── generated-notes/         ← Generated release notes (temp)
├── docs/
│   ├── mcp-setup.md
│   ├── team-prompts-guide.md
│   └── troubleshooting.md
├── logs/
│   └── [execution logs]
├── README.md                    ← This file
└── main.md                      ← Detailed documentation
```

## 🔗 Configuration

### MCP Connection
Update `config/mcp.config.json` with your MCP server URL:

```json
{
  "mcp_server": {
    "url": "your-mcp-connection-link"
  }
}
```

### Release Note Prompts
Ensure your `release-note-file/` folder contains team prompts:

```
../release-note-file/
├── engineering.md
├── product.md
├── marketing.md
├── operations.md
└── [custom-teams].md
```

## 🎯 How It Works

### Step-by-Step Flow

1. **Input PRD**
   - Notion link OR paste content
   
2. **Read PRD** 
   - MCP tool: `notion_fetch` → Get full content
   
3. **Analyze & Suggest Teams**
   - Claude analyzes PRD
   - Suggests affected teams with reasoning
   
4. **Confirm Teams**
   - You approve, remove, or add teams
   - Final list locked in
   
5. **Load Team Prompts**
   - Reads from `release-note-file/{team}.md`
   
6. **Generate Release Notes**
   - Claude + team prompt + PRD → Team-specific notes
   - Generates for all confirmed teams
   
7. **Review & Approve**
   - See all generated content
   - Option to edit before posting
   
8. **Post to Notion**
   - MCP tool: `notion_create_pages`
   - Creates sub-pages under PRD page
   - Returns links to all new pages

## 💬 Using in Conversation

### Start the Process
```
I have a new PRD that affects multiple teams. Here's the Notion link:
https://www.notion.so/PRD-Page-abc123

Can you help generate team-specific release notes?
```

### Claude Will:
1. Ask if you want to provide the link or paste content
2. Fetch and analyze the PRD
3. Suggest affected teams
4. Ask you to confirm the team list
5. Generate release notes for each team
6. Create Notion sub-pages automatically

### At Each Gate, You Can:
- ✅ **Approve** - Continue with suggestions
- ❌ **Reject** - Go back and revise
- 🔄 **Modify** - Add/remove teams
- 📝 **Edit** - Change generated content before posting

## 🔑 Key Features

- **Interactive Workflow** - Gates at each step for approval
- **MCP Integration** - Native Notion read/write via MCP
- **Custom Prompts** - Team-specific prompt templates
- **Claude API** - Advanced LLM for analysis and generation
- **Reversible** - Review before posting to Notion
- **Audit Trail** - All content saved locally first

## 📊 Example Usage

```
User: I have a new PRD about the payment system migration
      Here's the link: https://www.notion.so/Payment-Migration-abc123

Claude: ✓ Fetched PRD from Notion
        ✓ Analyzed content
        
        Suggested affected teams:
        1. Engineering [HIGH] - Platform and API changes
        2. Product [HIGH] - Feature enablement
        3. Operations [MEDIUM] - Deployment and monitoring
        4. Finance [LOW] - Billing system impact
        
        Proceed? (approve all / remove / add / custom)

User: Approve all

Claude: ✓ Confirmed 4 teams
        ✓ Generating release notes...
        
        Generated:
        ✅ Engineering (2.4 KB)
        ✅ Product (1.9 KB)
        ✅ Operations (1.2 KB)
        ✅ Finance (0.8 KB)
        
        Ready to post to Notion? (yes/no)

User: yes

Claude: ✓ Creating sub-pages in Notion...
        ✅ Engineering Release Notes (https://notion.so/...)
        ✅ Product Release Notes (https://notion.so/...)
        ✅ Operations Release Notes (https://notion.so/...)
        ✅ Finance Release Notes (https://notion.so/...)
        
        All release notes posted successfully!
```

## 🛠️ Customization

### Add New Team
1. Create `../release-note-file/{team-name}.md`
2. Add your team-specific prompt
3. Next time, agent will auto-detect and include

### Modify Team Prompt
1. Edit corresponding file in `release-note-file/`
2. Claude will use updated prompt for next generation
3. No code changes needed

### Change MCP Server
1. Update `config/mcp.config.json`
2. Set new MCP connection link
3. Restart and authenticate if needed

## 🐛 Troubleshooting

### MCP Connection Issues
- Verify MCP connection link is correct
- Check Notion API permissions
- Ensure page is shared with MCP integration

### Missing Team Prompts
- Confirm `release-note-file/` folder path
- Check file naming: `{team-name}.md` (lowercase)
- Verify prompt files are readable

### Generation Issues
- Review PRD content format
- Check Claude API key is set
- Look at generated-notes folder for partial output

See `docs/troubleshooting.md` for more.

## 📚 Documentation

- **`main.md`** - Complete technical documentation
- **`src/orchestrator.md`** - Detailed workflow and MCP tool usage
- **`docs/mcp-setup.md`** - MCP configuration guide
- **`docs/team-prompts-guide.md`** - How to write effective prompts
- **`docs/troubleshooting.md`** - Common issues and solutions

## 🚀 Next Steps

1. ✅ Folder structure created
2. ✅ MCP config file added
3. ⏳ Update MCP connection link in `config/mcp.config.json`
4. ⏳ Open folder in Claude Code / Antigravity
5. ⏳ Share your PRD link
6. ⏳ Claude orchestrates the entire workflow

---

**Ready?** Open this folder and share your PRD!
