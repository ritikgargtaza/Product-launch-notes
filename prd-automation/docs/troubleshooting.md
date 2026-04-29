# Troubleshooting Guide

## Common Issues & Solutions

### 1. MCP Notion Connection Issues

#### Problem: "MCP connection failed"

**Cause:** MCP server unreachable or misconfigured

**Solution:**
1. Check `config/mcp.config.json` for correct URL
2. Verify MCP server is running and accessible
3. Test URL in browser to ensure it's reachable
4. Check network/firewall settings

```bash
# Test MCP connection
curl -X GET your-mcp-connection-link/health
# Should return 200 OK
```

---

#### Problem: "Permission denied" when fetching PRD

**Cause:** Notion page not shared with MCP integration

**Solution:**
1. Open your PRD page in Notion
2. Click "Share" → find MCP integration
3. Ensure it has "Can edit" or "Can view" permission
4. If not listed, add it:
   - Click "Share" → "Invite"
   - Select the MCP integration
   - Grant permission

---

#### Problem: "Page not found" error

**Cause:** Incorrect page ID or URL format

**Solution:**
1. **Copy full Notion URL:**
   ```
   https://www.notion.so/Page-Title-abc123def456
   ```
   Not just the page ID

2. **Extract page ID correctly:**
   ```
   URL: https://www.notion.so/My-PRD-abc123def456?v=789
   Page ID: abc123def456 (the part after last hyphen)
   ```

3. **Or just provide the URL** - MCP can parse it automatically

---

### 2. Release Note Generation Issues

#### Problem: Generated content is too short/long

**Cause:** Prompt length guidance not specific enough

**Solution:**
1. Edit the team prompt in `../release-note-file/{team}.md`
2. Add specific length guidance:
   ```markdown
   ## Format Requirements
   - **Length:** 1000-1200 words
   - **Sections:** 5-7 main sections
   ```
3. Regenerate - Claude will follow new constraints

---

#### Problem: Generated content missing key information

**Cause:** Prompt doesn't specify that area

**Solution:**
1. Review what's missing
2. Add to team prompt's "Coverage Areas"
   ```markdown
   ## Coverage Areas
   1. **Missing Topic** - Specific guidance about this topic
      - Sub-point 1
      - Sub-point 2
   ```
3. Regenerate - Claude will include it

---

#### Problem: Generated content uses wrong tone/style

**Cause:** Prompt tone not clearly defined

**Solution:**
1. Edit team prompt - strengthen tone definition
   ```markdown
   **Tone:** Technical and precise, suitable for engineers
   **Language:** Use technical terms, include code examples
   **Avoid:** Marketing language, simplified analogies
   ```
2. Add quality checklist items:
   ```markdown
   - [ ] No marketing jargon or buzzwords
   - [ ] All statements technically accurate
   - [ ] Examples are valid code/configurations
   ```

---

### 3. Team-Related Issues

#### Problem: Agent doesn't suggest a team I expected

**Cause:** PRD doesn't clearly indicate team impact

**Solution:**
1. **Improve PRD content:**
   - Add specific sections mentioning that team's area
   - Be explicit about changes that affect them
   - Example: "Engineering impact: New API endpoints..."

2. **Or confirm manually:**
   - When agent suggests teams, choose "Add teams"
   - Manually add the team
   - Confirm inclusion

---

#### Problem: Team prompts not found

**Cause:** Wrong folder path or file naming

**Solution:**
1. Check folder exists: `../release-note-file/`
2. Check file naming: `{team-name}.md` (lowercase)
3. Examples:
   ```
   ✅ engineering.md
   ✅ product.md
   ✅ customer-success.md
   ❌ Engineering.md (wrong case)
   ❌ engineering_team.md (wrong format)
   ```
4. Verify files are readable (not locked)

---

#### Problem: "Team not recognized" when adding custom team

**Cause:** Team prompt file doesn't exist yet

**Solution:**
1. Create the file: `../release-note-file/{team-name}.md`
2. Add basic prompt content
3. Try again - agent will now recognize it

---

### 4. Notion Sub-Page Creation Issues

#### Problem: "Can't create sub-pages" error

**Cause:** Parent page not writable by MCP

**Solution:**
1. In Notion, open parent PRD page
2. Share with MCP integration (if not already done)
3. Ensure MCP has "Can edit" permission
4. Check that page is not locked or archived

---

#### Problem: Sub-pages created but in wrong location

**Cause:** Incorrect parent page ID provided

**Solution:**
1. Get correct parent page ID from URL
   ```
   https://www.notion.so/PRD-Page-abc123def456
   Parent ID = abc123def456
   ```
2. Verify this is the page where sub-pages should go
3. Retry creation with correct ID

---

#### Problem: Sub-pages created but content is malformed

**Cause:** Markdown to Notion block conversion issue

**Solution:**
1. **Check markdown formatting:**
   - Ensure proper heading levels (# ## ###)
   - Code blocks properly wrapped with ```
   - No unsupported syntax

2. **Simplify content:**
   - Remove complex HTML if present
   - Use standard markdown only
   - Test markdown validity

3. **Manual fix:**
   - Copy content to clipboard
   - Paste into Notion manually
   - Clean up formatting as needed

---

### 5. Configuration Issues

#### Problem: "Config file not found"

**Cause:** Wrong file path or structure

**Solution:**
1. Check file exists: `config/mcp.config.json`
2. Verify correct folder structure
3. If missing, copy from template:
   ```bash
   cp config/mcp.config.json.example config/mcp.config.json
   ```

---

#### Problem: Invalid JSON in config file

**Cause:** Syntax error in JSON

**Solution:**
1. Open `config/mcp.config.json` in editor
2. Check for common issues:
   - Missing commas between properties
   - Trailing commas (not allowed in JSON)
   - Unmatched quotes
   - Unmatched braces
3. Validate JSON:
   ```bash
   # Using Python
   python -m json.tool config/mcp.config.json
   # Should output without errors
   ```

---

### 6. Input/Output Issues

#### Problem: "Can't parse PRD content"

**Cause:** PRD format not recognized

**Solution:**
1. **If pasting directly:**
   - Ensure content is clear markdown
   - No special characters that break parsing
   - Use standard formatting

2. **If from Notion:**
   - Fetch again - may be temporary issue
   - Verify Notion page has content
   - Check page isn't empty or draft

---

#### Problem: Generated notes in output folder but not posted to Notion

**Cause:** User didn't confirm posting

**Solution:**
1. Check workflow - may be awaiting confirmation
2. Look in `output/generated-notes/` for files
3. Manually copy content and post if needed
4. Or restart workflow with confirmation

---

#### Problem: Output files are empty

**Cause:** Generation failed silently

**Solution:**
1. Check Claude API key is valid
2. Verify team prompts loaded correctly
3. Try generating again with verbose logging
4. Check error logs in `logs/` folder

---

### 7. Performance Issues

#### Problem: Generation taking too long

**Cause:** Large PRD or complex analysis

**Solution:**
1. **Reduce scope:**
   - Focus on fewer teams initially
   - Split large PRDs into sections

2. **Check API limits:**
   - Claude API might be rate-limited
   - Wait a few minutes and retry
   - Check usage limits in Claude dashboard

3. **Simplify team prompts:**
   - Remove verbose guidance
   - Focus on essentials only

---

#### Problem: "Timeout" error during generation

**Cause:** Request taking too long

**Solution:**
1. **Reduce content size:**
   - Shorter PRD summary
   - Fewer detailed examples

2. **Simplify request:**
   - Generate for fewer teams at once
   - Then do remaining teams separately

3. **Check network:**
   - Verify stable internet connection
   - Check for network timeouts in logs

---

### 8. Notion API Issues

#### Problem: Notion returns "rate_limit_exceeded"

**Cause:** Too many rapid requests to Notion API

**Solution:**
1. **Wait and retry:**
   - Notion has rate limits
   - Wait 5-10 minutes before retrying

2. **Space out requests:**
   - Generate for fewer teams at once
   - Create sub-pages sequentially, not parallel

3. **Check other integrations:**
   - Other apps might be hitting API too
   - Reduce their usage temporarily

---

#### Problem: "Insufficient permissions" to create sub-pages

**Cause:** Account doesn't have edit access to parent page

**Solution:**
1. **Check your Notion permissions:**
   - Open PRD page in Notion
   - Verify you have "Can edit" access
   - If not, ask page owner for access

2. **Check MCP integration permissions:**
   - In Notion, Settings → Integrations
   - Find MCP integration
   - Verify it has "Can create" permissions for child pages

---

## Diagnostic Checklist

### Before Reporting an Issue

Run through this checklist:

- [ ] MCP connection link is correct in `config/mcp.config.json`
- [ ] Notion page is shared with MCP integration
- [ ] Release-note-file folder exists with team prompts
- [ ] Team prompt files are named correctly (lowercase)
- [ ] Claude API key is valid
- [ ] Internet connection is stable
- [ ] Tried restarting the process
- [ ] Checked for error messages in logs/

### Gathering Information for Help

If you need help, provide:

1. **Error message:** Exact text of any error
2. **What you were doing:** Step in workflow when error occurred
3. **Files involved:** Which team prompt, which PRD, etc.
4. **Logs:** Check `logs/` for any error details
5. **Configuration:** Share relevant parts of `config/mcp.config.json` (hide sensitive data)

---

## Getting Help

### Resources

1. **Documentation:**
   - `main.md` - Complete guide
   - `src/orchestrator.md` - Workflow details
   - `docs/mcp-setup.md` - MCP configuration

2. **External:**
   - Notion API Docs: https://developers.notion.com/
   - Claude API Docs: https://docs.anthropic.com
   - MCP Protocol: https://modelcontextprotocol.io/

3. **Debug Steps:**
   - Enable verbose logging (if supported)
   - Check `logs/` folder for errors
   - Test with sample/simple PRD first
   - Isolate variable (test MCP alone, generation alone, etc.)

---

## Common Success Patterns

### What Works Well

✅ Clear, well-formatted PRDs  
✅ Specific team prompts (not generic)  
✅ Proper Notion permissions set up  
✅ MCP connection tested and working  
✅ Smaller batches (fewer teams at once)  
✅ Clear confirmation gates in workflow  

### What Often Fails

❌ Vague or incomplete PRD content  
❌ Generic team prompts that don't specify needs  
❌ MCP permissions not set correctly  
❌ Generating for too many teams at once  
❌ Invalid JSON in config files  
❌ Notion page locked or archived  

---

## Still Stuck?

If you've tried everything:

1. **Reset and retry:**
   ```bash
   # Start fresh
   rm output/generated-notes/*
   rm logs/*
   # Then retry the workflow
   ```

2. **Test components separately:**
   - Test MCP fetch alone (no generation)
   - Test Claude generation alone (no Notion)
   - Test Notion creation alone (no generation)

3. **Check Claude Code logs:**
   - Verbose output might show root cause
   - Check terminal for errors
   - Review MCP interaction logs

4. **Simplify the request:**
   - Use small test PRD
   - Test with one team
   - One step at a time

---

## FAQ

**Q: Can I generate notes without posting to Notion?**  
A: Yes - files are saved to `output/generated-notes/` regardless. Copy/post manually if needed.

**Q: What if I want to edit generated content before posting?**  
A: Notes are saved locally first. Review and edit before confirming posting to Notion.

**Q: How do I change a team's prompt?**  
A: Edit the file in `../release-note-file/{team}.md` and regenerate.

**Q: Can I add new teams on the fly?**  
A: Yes - create prompt file in release-note-file/ and agent will detect it.

**Q: What if the PRD changes after starting?**  
A: Start over with the updated PRD - you'll get new team suggestions and content.

---

**Need more help?** Review the main documentation or check the logs folder for detailed error information.
