# PRD Release Notes Orchestrator

This is the main orchestration file that coordinates all steps in the release notes generation workflow using Claude's MCP Notion integration.

## Quick Start for Claude Code / Antigravity

### Prerequisites
1. MCP Notion connection link configured
2. Release-note-file folder exists with team prompts (`.md` files)
3. Claude API access (for generation)

---

## Execution Steps

### STEP 1: Accept PRD Input

**Option A: From Notion Link**
```
User provides: https://www.notion.so/PRD-Page-abc123def456

Call MCP Tool: notion_fetch
  - page_id: extracted from URL
  - include_discussions: true
  - Returns: Full page content as markdown
```

**Option B: Paste Content**
```
User pastes PRD content directly into conversation
Claude stores in memory for processing
```

---

### STEP 2: Analyze PRD with Claude

**Prompt:**
```
Analyze this PRD and identify ALL affected teams based on:
1. Feature scope and impact
2. Technical changes
3. User-facing changes
4. Operational changes
5. Regulatory/compliance implications

For each team, provide:
- Team name
- Impact level (high/medium/low)
- Key impact reasons
- Required actions

Output as JSON with structure:
{
  "prd_summary": "one paragraph summary",
  "affected_teams": [
    {
      "team_name": "Engineering",
      "impact_level": "high",
      "reason": "...",
      "key_impacts": ["..."]
    }
  ]
}
```

---

### STEP 3: Suggest Teams to User

**Display:**
```
Suggested affected teams:
1. Engineering [HIGH] → API changes, migrations
2. Product [HIGH] → New feature launch
3. Marketing [MEDIUM] → GTM messaging needed
4. Operations [LOW] → Documentation updates

Available actions:
✅ Approve all
❌ Remove teams
➕ Add teams
🔄 Custom selection
```

---

### STEP 4: PM Confirmation Gate

**User chooses:**
- ✅ Approve all → proceed with all suggested teams
- ❌ Remove → specify which teams to exclude
- ➕ Add → specify additional teams
- 🔄 Custom → approve/reject each individually

**Output:** Final confirmed team list

---

### STEP 5-6: Generate Team-Specific Release Notes

**For each confirmed team:**

1. **Load Team Prompt**
   ```
   File: ../release-note-file/{team_name}.md
   Returns: Team-specific prompt template
   ```

2. **Call Claude with Context**
   ```
   Prompt = Team Template + PRD Content
   
   Message to Claude:
   {team_template_content}
   
   ---PRD CONTEXT---
   {prd_content}
   
   Generate detailed, team-specific release notes...
   ```

3. **Receive Generated Content**
   ```
   Claude returns: Formatted release notes markdown
   Save to: output/generated-notes/{team_name}.md
   ```

4. **Repeat for Each Team**
   ```
   Loop through all confirmed teams
   Generate unique content for each
   Save all locally before posting
   ```

---

### STEP 7: User Review & Approval

**Display to User:**
```
Generated 4 release notes:
✅ Engineering (2.3 KB)
✅ Product (1.8 KB)
✅ Marketing (1.5 KB)
✅ Operations (0.9 KB)

Review options:
1. View each release note (generated locally)
2. Edit before posting
3. Approve all and post to Notion
4. Remove/add teams and regenerate
```

---

### STEP 8: Create Notion Sub-Pages

**For each approved release note:**

```
Call MCP Tool: notion_create_pages

Input:
{
  "pages": [
    {
      "properties": {
        "title": "{Team Name} Release Notes"
      },
      "content": "{generated_release_note_markdown}",
      "parent": {
        "page_id": "{parent_prd_page_id}"
      }
    }
  ]
}

Returns: Created page URLs for each team
```

**Repeat for each team**, creating hierarchical sub-pages under the main PRD page.

---

## MCP Tools Used

| Step | Tool | Purpose |
|------|------|---------|
| 2 | `notion_fetch` | Read full PRD content |
| 5-6 | N/A (File read) | Load team prompts from release-note-file |
| 8 | `notion_create_pages` | Create sub-pages for each team |
| 8 | `notion_update_page` | Link sub-pages back to parent PRD |

---

## Data Flow

```
┌─────────────────────────────────────────────┐
│ User Input: Notion Link or Pasted PRD      │
└──────────────┬──────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────┐
│ MCP: notion_fetch(page_id)                  │
│ Returns: Full PRD markdown content          │
└──────────────┬──────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────┐
│ Claude: Analyze & Suggest Teams             │
│ Input: PRD content                          │
│ Output: JSON with team suggestions          │
└──────────────┬──────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────┐
│ User: Confirm/Modify Team List              │
│ Output: Final confirmed teams               │
└──────────────┬──────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────┐
│ FOR EACH TEAM:                              │
│ 1. Load prompt from release-note-file/      │
│ 2. Claude: Generate team-specific notes     │
│ 3. Save locally to output/generated-notes/  │
└──────────────┬──────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────┐
│ User: Review & Approve Generated Notes      │
│ Option to edit before posting               │
└──────────────┬──────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────┐
│ MCP: notion_create_pages (FOR EACH TEAM)    │
│ Creates sub-pages with generated content    │
│ Returns: Created page IDs and URLs          │
└──────────────┬──────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────┐
│ ✅ COMPLETE                                 │
│ All release notes posted to Notion          │
└─────────────────────────────────────────────┘
```

---

## How to Use in Claude Code / Antigravity

### Method 1: Interactive Conversation

1. Load this folder in Claude Code: `prd-automation/`
2. Share your Notion PRD link or paste content
3. Claude handles the entire workflow:
   - Reads PRD via MCP
   - Analyzes with Claude API
   - Loads team prompts from `release-note-file/`
   - Generates content
   - Creates Notion sub-pages via MCP
   - Provides feedback at each gate

### Method 2: Using Workflows

Create workflow files in `workflows/` directory:

**File:** `workflows/generate-release-notes.workflow`
```yaml
name: Generate Team Release Notes
trigger: manual

steps:
  - step: accept_prd_input
    description: Get PRD link or content
    
  - step: fetch_notion
    tool: notion_fetch
    description: Read full PRD from Notion
    
  - step: analyze_prd
    description: Claude analyzes and suggests teams
    
  - step: confirm_teams
    description: User confirms affected teams
    
  - step: load_prompts
    source: ../release-note-file/
    description: Load team-specific prompts
    
  - step: generate_notes
    description: Claude generates team-specific notes
    
  - step: review_content
    description: User reviews generated content
    
  - step: post_to_notion
    tool: notion_create_pages
    description: Create sub-pages in Notion
    
  - step: completion
    description: Summary and links to new pages
```

---

## Configuration

Update `config/mcp.config.json`:

```json
{
  "mcp_server": {
    "url": "YOUR_MCP_CONNECTION_LINK"
  },
  "prompts_path": "path/to/release-note-file",
  "notion": {
    "parent_prd_page_id": "abc123def456"  // Optional: set default
  }
}
```

---

## Expected Prompts in release-note-file/

Each team should have a markdown file with its specific prompt:

```
release-note-file/
├── engineering.md      → Technical release notes template
├── product.md          → Product team communications
├── marketing.md        → Customer-facing messaging
├── operations.md       → Operational/process changes
├── sales.md            → Sales enablement content
├── support.md          → Support/customer success content
└── [custom-team].md    → Any additional teams
```

---

## Output Structure

```
output/
└── generated-notes/
    ├── engineering.md          ← Generated release note
    ├── product.md              ← Generated release note
    ├── marketing.md            ← Generated release note
    └── operations.md           ← Generated release note
```

Each file contains the generated release notes in markdown format.

---

## Success Criteria

✅ PRD content fetched successfully from Notion  
✅ Claude identified 3+ affected teams  
✅ User confirmed team selection  
✅ Team-specific prompts loaded from release-note-file  
✅ Release notes generated for all confirmed teams  
✅ All sub-pages created in Notion hierarchy  
✅ User received links to all new pages  

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| MCP not connecting to Notion | Verify MCP connection link in `config/mcp.config.json` |
| Can't find release-note-file prompts | Check path in config, ensure files exist |
| Claude can't analyze PRD | Ensure PRD content is properly formatted markdown |
| Notion sub-pages not created | Verify parent page ID is correct and accessible |
| Generated notes are too long/short | Adjust prompt in release-note-file templates |

---

## Next Steps

1. ✅ Folder structure created
2. ✅ MCP configuration set up
3. ⏳ Load into Claude Code or Antigravity
4. ⏳ Provide Notion PRD link
5. ⏳ Claude orchestrates the entire workflow

**To start:** Open this folder in Claude Code and share your PRD link!
