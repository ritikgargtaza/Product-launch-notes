# Example Workflow: Generate Release Notes

This example shows a typical execution of the release notes generation workflow.

## Scenario

**Input:** New payments API PRD needs team-specific release notes

**Expected Output:** 4 release notes (Engineering, Product, Marketing, Operations) posted to Notion

---

## Execution Log

### STEP 1: Provide PRD Content

```
User: I have a new PRD for the payments API redesign. 
      Here's the Notion link: https://www.notion.so/Payments-API-Redesign-abc123def456

Claude: ✓ Received Notion link
        ✓ Loading PRD from Notion...
```

**What happens:**
- Claude uses MCP tool: `notion_fetch`
- Retrieves full PRD content as markdown
- Stores for analysis

---

### STEP 2-3: Analyze PRD & Suggest Teams

```
Claude: Analyzing PRD content...
        ✓ Completed in 2.1 seconds
        
        === ANALYSIS RESULTS ===
        
        PRD Summary:
        This release redesigns the payments API for improved performance,
        security, and developer experience. Includes new endpoints, 
        deprecation of 3 legacy endpoints, OAuth 2.0 support, and 
        enhanced error handling.
        
        Suggested Affected Teams:
        
        1️⃣  ENGINEERING [HIGH IMPACT]
            Reason: Significant API changes, new authentication mechanism,
                   multiple breaking changes, database schema updates
            Key impacts:
            - New REST endpoints (v2 API)
            - OAuth 2.0 authentication (replaces API keys)
            - 3 deprecated endpoints (v1)
            - Database migrations required
            - Load testing needed
        
        2️⃣  PRODUCT [HIGH IMPACT]
            Reason: New features (OAuth) improve user experience and security,
                   affects feature roadmap and go-to-market
            Key impacts:
            - OAuth 2.0 improves security story
            - Simplified integration for app developers
            - Better error messages improve DX
            - Competitive advantage vs current offering
        
        3️⃣  MARKETING [MEDIUM IMPACT]
            Reason: New features require customer communication and enablement
            Key impacts:
            - OAuth 2.0 is a selling point
            - Developer education needed
            - Messaging opportunity for security improvements
            - Migration guide for existing customers
        
        4️⃣  OPERATIONS [MEDIUM IMPACT]
            Reason: API changes affect monitoring, support, and customer issues
            Key impacts:
            - New monitoring for v2 endpoints
            - Support team training on new endpoints
            - Potential customer escalations during migration
            - Deployment coordination needed

Options:
✅ Approve all teams
❌ Remove specific teams
➕ Add custom teams
🔄 Custom selection
```

**What happens:**
- Claude analyzes PRD content
- Identifies affected teams based on content
- Provides reasoning for each team
- Awaits your confirmation

---

### STEP 4: Team Confirmation

```
User: Approve all

Claude: ✓ Confirmed all 4 teams:
        - Engineering
        - Product
        - Marketing
        - Operations
        
        Proceeding to generate release notes...
```

**What happens:**
- Teams are finalized
- Next step: Load team-specific prompts and generate

---

### STEP 5-6: Generate Team-Specific Release Notes

```
Claude: Loading team prompts and generating content...

        → Loading prompt: engineering.md
        ✓ Loaded (512 bytes)
        
        → Generating Engineering release notes...
        ✓ Generated (1,847 words)
        ✓ Saved to: output/generated-notes/engineering.md
        
        → Loading prompt: product.md
        ✓ Loaded (381 bytes)
        
        → Generating Product release notes...
        ✓ Generated (1,243 words)
        ✓ Saved to: output/generated-notes/product.md
        
        → Loading prompt: marketing.md
        ✓ Loaded (425 bytes)
        
        → Generating Marketing release notes...
        ✓ Generated (956 words)
        ✓ Saved to: output/generated-notes/marketing.md
        
        → Loading prompt: operations.md
        ✓ Loaded (496 bytes)
        
        → Generating Operations release notes...
        ✓ Generated (1,124 words)
        ✓ Saved to: output/generated-notes/operations.md
        
        ✓ All release notes generated successfully
```

**What happens:**
- For each confirmed team:
  1. Load team-specific prompt from release-note-file/
  2. Call Claude with (prompt + PRD content)
  3. Receive generated release note
  4. Save locally to output/generated-notes/
  5. Move to next team

---

### STEP 7: Review Generated Content

```
Claude: Generated 4 release notes for review:

        =============== ENGINEERING ===============
        # Engineering Release Notes: Payments API Redesign
        
        ## Overview
        This release introduces a completely redesigned Payments API (v2)
        that provides improved performance, enhanced security, and better 
        developer experience...
        
        [Content preview - 1,847 words total]
        
        ✅ Ready to post | 🔄 Show next | 📝 Edit | ❌ Skip
        
        
        =============== PRODUCT ===============
        # Product Team Release Notes: Payments API Redesign
        
        ## Feature Overview
        The redesigned Payments API introduces OAuth 2.0 support,
        reducing complexity for app developers and enabling more 
        granular permission management...
        
        [Content preview - 1,243 words total]
        
        ✅ Ready to post | 🔄 Show next | 📝 Edit | ❌ Skip
        
        
        =============== MARKETING ===============
        # Marketing Release Notes: Payments API Redesign
        
        ## Announcement
        We're excited to announce the next generation of our Payments API,
        designed to give developers more control, better security, and 
        a simpler integration experience...
        
        [Content preview - 956 words total]
        
        ✅ Ready to post | 🔄 Show next | 📝 Edit | ❌ Skip
        
        
        =============== OPERATIONS ===============
        # Operations Release Notes: Payments API Redesign
        
        ## Deployment Overview
        The Payments API redesign will be deployed in phases to ensure
        stability and allow time for customer migration...
        
        [Content preview - 1,124 words total]
        
        ✅ Ready to post | 🔄 Show next | 📝 Edit | ❌ Skip


Summary:
📊 Total generated: 4 release notes
📝 Total words: 5,170
⏱️  Generated in: 8.3 seconds

Options:
✅ Post all to Notion
📝 Edit specific team notes
❌ Remove a team
➕ Add and generate for new team
🔄 Regenerate all
```

**What happens:**
- Show preview of all generated content
- User can review, edit, or regenerate
- User can approve or make changes

---

### STEP 8: Create Notion Sub-Pages

```
User: Post all to Notion

Claude: ✓ Ready to post to Notion
        
        Before we proceed, confirm:
        - Parent Notion page (where sub-pages will be created):
          https://www.notion.so/Payments-API-Redesign-abc123def456
        
        This is correct? (yes/no)

User: yes

Claude: Creating sub-pages in Notion...

        → Engineering Release Notes
          ✓ Created page
          ✓ Added content
          ✓ Link: https://www.notion.so/Engineering-Release-Notes-xyz789
        
        → Product Release Notes
          ✓ Created page
          ✓ Added content
          ✓ Link: https://www.notion.so/Product-Release-Notes-xyz790
        
        → Marketing Release Notes
          ✓ Created page
          ✓ Added content
          ✓ Link: https://www.notion.so/Marketing-Release-Notes-xyz791
        
        → Operations Release Notes
          ✓ Created page
          ✓ Added content
          ✓ Link: https://www.notion.so/Operations-Release-Notes-xyz792
        
        ✅ ALL COMPLETE!
```

**What happens:**
- For each generated release note:
  1. Call MCP tool: `notion_create_pages`
  2. Create sub-page under parent PRD page
  3. Write generated markdown content
  4. Return created page URL

---

### FINAL SUMMARY

```
✅ WORKFLOW COMPLETE

Generated Release Notes:
├── 🔗 Engineering Release Notes
│   └── https://www.notion.so/Engineering-Release-Notes-xyz789
├── 🔗 Product Release Notes
│   └── https://www.notion.so/Product-Release-Notes-xyz790
├── 🔗 Marketing Release Notes
│   └── https://www.notion.so/Marketing-Release-Notes-xyz791
└── 🔗 Operations Release Notes
    └── https://www.notion.so/Operations-Release-Notes-xyz792

All release notes are now live in Notion!

Next steps:
1. Review each sub-page in Notion
2. Share with respective teams
3. Update with any additional information
4. Pin important notes or create team announcements

Stats:
⏱️  Total time: 12 minutes
📝 Total content: 5,170 words
👥 Teams covered: 4
✅ Notion pages created: 4
```

---

## Key Points from This Workflow

### Automation Highlights

✅ **Zero-touch reading:** MCP fetched full PRD automatically  
✅ **Intelligent suggestions:** Claude identified all affected teams  
✅ **Batch generation:** All 4 release notes generated in parallel  
✅ **Validation gates:** User confirmed teams before generation  
✅ **Local review:** Content saved locally before posting  
✅ **Notion integration:** MCP created sub-pages automatically  

### User Decisions

1. **PRD input** - User provided Notion link
2. **Team confirmation** - User approved suggested teams
3. **Final approval** - User confirmed before posting
4. **Parent page** - User confirmed destination page

### Time Saved

**Without automation:**
- Manually read PRD: 15 min
- Analyze per team: 10 min each (40 min total)
- Write notes per team: 30 min each (120 min total)
- Create Notion pages: 15 min
- **Total: ~190 minutes**

**With automation:**
- Provide PRD: 1 min
- Confirm teams: 2 min
- Review generated content: 5 min
- Approve posting: 1 min
- **Total: ~9 minutes**

**Savings: 181 minutes (3+ hours per release)**

---

## Variations

### Variation 1: Different Team Set

If only Engineering and Product are affected:

```
Claude: Suggested 4 teams
User: Remove Marketing and Operations
Claude: ✓ Confirmed 2 teams
       → Generating for Engineering...
       → Generating for Product...
       ✓ Complete
```

### Variation 2: Add Custom Team

If Legal needs a release note:

```
Claude: Suggested 4 teams
User: Add Legal team
Claude: ✓ Looking for legal.md in release-note-file/
       ✓ Found
       → Generating for Engineering...
       → Generating for Product...
       → Generating for Marketing...
       → Generating for Operations...
       → Generating for Legal...
       ✓ Complete
```

### Variation 3: Edit Before Posting

If a note needs adjustment:

```
Claude: [Shows generated content]
User: Edit the Engineering notes - add more about rollback
Claude: [Shows Engineering content for editing]
User: [Edits and returns]
Claude: ✓ Updated
       → Post all to Notion...
       ✓ Complete
```

---

## Success Criteria Met

- ✅ PRD read from Notion via MCP
- ✅ Affected teams identified automatically
- ✅ User confirmed team selection
- ✅ Team-specific prompts loaded
- ✅ Unique content generated for each team
- ✅ Content reviewed before posting
- ✅ Sub-pages created in Notion hierarchy
- ✅ User received links to all pages

---

This workflow demonstrates the complete end-to-end process. Each execution will be similar, with variations based on user input and PRD content.
