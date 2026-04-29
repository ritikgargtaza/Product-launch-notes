# MCP Setup Guide

## Overview
This agent uses Notion MCP (Model Context Protocol) to read and write Notion pages. Your MCP connection is pre-configured; this guide explains how it works.

## ✅ What You Need

1. **MCP Connection Link** (you already have this)
   - HTTP endpoint that connects to your Notion API
   - Format: `https://mcp-your-domain.com/mcp/v1` (example)

2. **Notion API Access**
   - Pages must be accessible to your MCP integration
   - Your Notion pages shared with the MCP app

3. **Claude Access** (via Claude Code / Antigravity)
   - Uses Claude's built-in MCP Notion tools
   - Automatically handles authentication

## 🔧 Configuration

### Update MCP Connection

Edit `config/mcp.config.json`:

```json
{
  "mcp_server": {
    "name": "notion-mcp-server",
    "type": "http",
    "url": "YOUR_MCP_CONNECTION_LINK_HERE",
    "description": "Your Notion MCP connection"
  }
}
```

Replace `YOUR_MCP_CONNECTION_LINK_HERE` with your actual MCP endpoint.

## 🔑 MCP Tools Used

### 1. Read PRD: `notion_fetch`

**Purpose:** Read the PRD page content from Notion

**Input:**
```json
{
  "id": "page-uuid-or-url",
  "include_discussions": false,
  "include_transcript": false
}
```

**Output:**
```markdown
# PRD Title

## Overview
[Full PRD content as markdown]

## Features
...
```

**When used:** Step 2 - Fetch full PRD from Notion

---

### 2. Create Sub-Pages: `notion_create_pages`

**Purpose:** Create team-specific release note pages under the PRD

**Input:**
```json
{
  "pages": [
    {
      "properties": {
        "title": "Engineering Release Notes"
      },
      "content": "[Generated markdown content]",
      "parent": {
        "page_id": "parent-prd-page-id"
      }
    }
  ]
}
```

**Output:**
```json
{
  "success": true,
  "created_pages": [
    {
      "id": "page-id",
      "url": "https://www.notion.so/..."
    }
  ]
}
```

**When used:** Step 8 - Create sub-pages for each team (called once per team)

---

### 3. Optional: Update Page: `notion_update_page`

**Purpose:** Update PRD page with links to generated sub-pages

**Input:**
```json
{
  "page_id": "prd-page-id",
  "content": "[Updated content with links]",
  "command": "update_content"
}
```

**When used:** Optional - To link back from PRD to generated notes

---

## 🌐 How MCP Works in This Agent

### Flow with MCP

```
Claude Code / Antigravity
        ↓
    [You provide PRD link]
        ↓
    Claude reads your message
        ↓
    Calls MCP Notion Tool: notion_fetch
        ↓
    MCP Server (your connection)
        ↓
    Notion API
        ↓
    Returns: PRD content as markdown
        ↓
    Claude analyzes content
        ↓
    [Shows team suggestions]
        ↓
    [You confirm teams]
        ↓
    Claude loads team prompts from release-note-file
        ↓
    Claude generates team-specific notes (no MCP needed)
        ↓
    Calls MCP Notion Tool: notion_create_pages
        ↓
    MCP Server creates sub-pages
        ↓
    [Complete - all pages created in Notion]
```

## 🔐 Authentication

### MCP Authentication Flow

1. **First Time Use:**
   - When you provide a Notion link
   - Claude detects MCP is needed
   - MCP connection authenticates with Notion
   - No manual login required (pre-configured)

2. **Permissions Needed:**
   - Read access to PRD page (for fetching)
   - Write access to parent page (for creating sub-pages)
   - Child page creation access

3. **Verify Access:**
   - Ensure the MCP app has access to your Notion workspace
   - Share the PRD page with the MCP integration if needed
   - Check Notion Settings → Integrations → Apps for MCP

## 🔗 Page ID Extraction

If you need to manually extract a page ID:

**From URL:**
```
https://www.notion.so/My-PRD-Title-abc123def456?v=789

Page ID = abc123def456 (the part after the last hyphen before ?)
```

**Or use the full URL:**
```
The MCP tool can accept full Notion URLs directly
https://www.notion.so/My-PRD-Title-abc123def456
```

## 🧪 Testing Your MCP Connection

### Quick Test

1. In Claude Code / Antigravity, ask:
   ```
   Can you check if my MCP Notion connection is working?
   Here's a test page: [paste your Notion URL]
   ```

2. Claude will:
   - Try to fetch the page via MCP
   - Report success/failure
   - Show content preview
   - Identify any permission issues

### If Connection Fails

1. **Check MCP URL** in `config/mcp.config.json`
2. **Verify Notion permissions:**
   - Go to Notion Settings
   - Check Integrations
   - Ensure MCP app is allowed
3. **Test with a public page** (easier permissions)
4. **Check logs** in `logs/` folder (if any errors recorded)

## 📝 Content Handling

### What MCP Can Read
- ✅ Headings, paragraphs, lists
- ✅ Tables, code blocks
- ✅ Callouts, quotes
- ✅ Nested pages and databases
- ✅ Images (as references)

### What MCP Can Create
- ✅ New sub-pages
- ✅ Formatted content (markdown → Notion blocks)
- ✅ Page properties (title, etc.)
- ✅ Parent/child hierarchy

### Content Conversion
- **Read:** Notion blocks → Markdown
- **Write:** Markdown → Notion blocks

The conversion is automatic - Claude handles it.

## 🚀 Advanced: Custom MCP Configuration

### For Different Notion Workspaces

Create separate config files:

**config/mcp-prod.config.json**
```json
{
  "mcp_server": {
    "url": "https://prod-mcp.example.com"
  },
  "notion": {
    "workspace": "production"
  }
}
```

**config/mcp-staging.config.json**
```json
{
  "mcp_server": {
    "url": "https://staging-mcp.example.com"
  },
  "notion": {
    "workspace": "staging"
  }
}
```

Then load the appropriate config when starting.

## 🔍 Troubleshooting MCP Issues

| Issue | Solution |
|-------|----------|
| "MCP connection failed" | Check URL in config, verify it's accessible |
| "Permission denied" | Ensure page is shared with MCP app in Notion |
| "Page not found" | Verify page ID is correct, use full URL instead |
| "Can't create sub-pages" | Check if MCP has write access to parent page |
| "Content looks garbled" | Notion formatting issue, try simpler markdown |

## 📚 More Resources

- Notion API Docs: https://developers.notion.com/
- MCP Protocol: https://modelcontextprotocol.io/
- Notion Markdown Format: See Notion docs for supported blocks

## ✅ Checklist

- [ ] MCP connection link added to `config/mcp.config.json`
- [ ] Notion workspace accessible via MCP
- [ ] Test page can be fetched via MCP (optional verification)
- [ ] PRD page shared with MCP integration
- [ ] Parent page has write permissions for MCP
- [ ] Ready to start generating release notes

**Next:** Share your PRD link with Claude and start the workflow!
