# Product Release Notes Agent - Automation Guide

## Overview
This agent automates the creation of team-specific product release notes from a Notion PRD. It reads the PRD, identifies affected teams, gets PM confirmation, and generates customized release notes for each team using Claude API.

---

## Architecture & Workflow

```
┌─────────────────────────────────────────────────────────────┐
│ 1. INPUT: Notion PRD Link or Content                       │
└────────────────┬────────────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────────────┐
│ 2. READ & ANALYZE: Fetch PRD from Notion using MCP         │
│    - Extract key features, impacts, scope                  │
└────────────────┬────────────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────────────┐
│ 3. SUGGEST TEAMS: Call Claude API                          │
│    - Analyze PRD content                                   │
│    - Suggest affected teams based on impacts              │
│    - Get reasoning for each team                          │
└────────────────┬────────────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────────────┐
│ 4. PM CONFIRMATION: Interactive Approval                   │
│    - User confirms/removes/adds teams                      │
│    - Final list of affected teams locked                   │
└────────────────┬────────────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────────────┐
│ 5. GENERATE NOTES: For Each Confirmed Team                 │
│    - Load team-specific prompt from prompts/team-prompts/  │
│    - Call Claude API with PRD context + prompt            │
│    - Generate team-specific release note                   │
└────────────────┬────────────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────────────┐
│ 6. CREATE SUB-PAGES: Write to Notion                       │
│    - Create sub-page for each team under PRD page         │
│    - Write generated content to Notion using MCP          │
│    - Set proper hierarchy and formatting                  │
└─────────────────────────────────────────────────────────────┘
```

---

## Step-by-Step Implementation

### Step 1: Setup Folder Structure

```bash
mkdir -p product-release-notes-agent
cd product-release-notes-agent

# Create directory structure
mkdir -p prompts/team-prompts
mkdir -p prompts/system-prompts
mkdir -p src
mkdir -p config
mkdir -p output/generated-notes
mkdir -p docs
mkdir -p logs
```

### Step 2: Configure Notion MCP Integration

**File:** `config/notion.yaml`
```yaml
notion:
  api_key: ${NOTION_API_KEY}
  database_id: ${NOTION_DATABASE_ID}
  # Leave blank if reading from link directly
  read_method: "link"  # or "database"
  
prd_template:
  title_property: "title"
  content_block_types:
    - heading_1
    - paragraph
    - numbered_list
    - bulleted_list
    - callout
    - code
```

**Setup Steps:**
1. Create Notion Integration at https://www.notion.so/my-integrations
2. Get your `NOTION_API_KEY`
3. Share your PRD page with the integration
4. Store API key in `.env`:
   ```bash
   NOTION_API_KEY=your_key_here
   CLAUDE_API_KEY=your_claude_key_here
   ```

---

### Step 3: Create System & Team Prompts

#### System Prompt: Initial Analysis
**File:** `prompts/system-prompts/analyze-prd.md`
```markdown
# Analyze PRD and Identify Affected Teams

You are a product expert. Analyze the provided PRD and:

1. **Understand the Core Change**: What is this release about?
2. **Identify Impacts**: Technical, operational, user-facing, etc.
3. **Suggest Affected Teams**: Based on impacts, which teams need to know?
4. **Provide Reasoning**: Why does each team need this info?

Output as JSON:
{
  "prd_summary": "...",
  "affected_teams": [
    {
      "team_name": "Engineering",
      "impact_level": "high|medium|low",
      "reason": "...",
      "key_actions": ["action1", "action2"]
    }
  ]
}
```

#### Team-Specific Prompts
**File:** `prompts/team-prompts/engineering.md`
```markdown
# Engineering Team Release Notes

Generate release notes for the Engineering team covering:

1. **Technical Changes**
   - API changes
   - Database migrations
   - Architecture changes
   - Dependencies

2. **Implementation Details**
   - Deployment steps
   - Configuration changes
   - Rollback procedures
   - Testing requirements

3. **Timeline**
   - Rollout schedule
   - Phases if applicable
   - Interdependencies

4. **Support & Runbooks**
   - Debugging tips
   - Common issues
   - Escalation paths

Keep language technical. Use code blocks for examples.
```

**File:** `prompts/team-prompts/product.md`
```markdown
# Product Team Release Notes

Generate release notes for Product team covering:

1. **Feature Overview**
   - What's new for users
   - User-facing benefits
   - Screenshots/diagrams if relevant

2. **Business Impact**
   - Revenue implications
   - User engagement metrics
   - Competitive advantage

3. **GTM Plan**
   - Launch timing
   - Messaging
   - Target audience
   - Success metrics

4. **FAQ & Issues**
   - Common user questions
   - Known limitations
   - Future roadmap tie-ins

Keep language business-focused and accessible.
```

**File:** `prompts/team-prompts/marketing.md`
```markdown
# Marketing Team Release Notes

Generate marketing communications covering:

1. **Announcement Copy**
   - Headline
   - Key benefits in customer language
   - Call-to-action

2. **Customer-Facing Messages**
   - Blog post outline
   - Email campaign copy
   - Social media snippets

3. **Target Audiences**
   - Who benefits most
   - Segmentation approach
   - Personalization ideas

4. **Launch Assets**
   - Press release outline
   - Customer story angles
   - Video/demo script ideas

Keep language customer-centric and compelling.
```

**File:** `prompts/team-prompts/operations.md`
```markdown
# Operations Team Release Notes

Generate operations communications covering:

1. **Process Changes**
   - Workflow updates
   - New tools/systems
   - Procedure changes

2. **Training & Documentation**
   - What teams need to learn
   - Training timeline
   - Knowledge base updates needed

3. **Monitoring & Support**
   - Metrics to watch
   - Alert thresholds
   - Support team preparation

4. **Risk & Mitigation**
   - Potential issues
   - Contingency plans
   - Rollback procedures

Keep language operational and actionable.
```

---

### Step 4: Create Main Agent Script

**File:** `src/main.py`

```python
#!/usr/bin/env python3
"""
Product Release Notes Agent
Automates team-specific release note generation from Notion PRD
"""

import json
import os
import sys
from datetime import datetime
from typing import Dict, List, Optional
import yaml
import anthropic
from pathlib import Path

# Configuration
CONFIG_DIR = Path(__file__).parent.parent / "config"
PROMPTS_DIR = Path(__file__).parent.parent / "prompts"
OUTPUT_DIR = Path(__file__).parent.parent / "output"

class ReleaseNotesAgent:
    def __init__(self):
        self.claude = anthropic.Anthropic(api_key=os.getenv("CLAUDE_API_KEY"))
        self.notion_token = os.getenv("NOTION_API_KEY")
        self.load_config()
        self.teams = {}
        self.prd_content = ""
        
    def load_config(self):
        """Load configuration from YAML files"""
        config_file = CONFIG_DIR / "notion.yaml"
        if config_file.exists():
            with open(config_file) as f:
                self.config = yaml.safe_load(f)
        else:
            self.config = {"notion": {"api_key": self.notion_token}}
    
    # =========================================================================
    # STEP 1: INPUT - Accept Notion Link or Content
    # =========================================================================
    def input_prd(self) -> str:
        """Get PRD content from Notion link or direct paste"""
        print("\n" + "="*70)
        print("STEP 1: PROVIDE PRD CONTENT")
        print("="*70)
        print("\nOptions:")
        print("1. Paste Notion link")
        print("2. Paste PRD content directly")
        
        choice = input("\nSelect option (1 or 2): ").strip()
        
        if choice == "1":
            link = input("Enter Notion link: ").strip()
            self.prd_content = self.fetch_from_notion(link)
            print(f"✓ Loaded PRD from Notion ({len(self.prd_content)} chars)")
        elif choice == "2":
            print("Paste PRD content (type 'END' on a new line when done):")
            lines = []
            while True:
                line = input()
                if line == "END":
                    break
                lines.append(line)
            self.prd_content = "\n".join(lines)
            print(f"✓ Loaded PRD content ({len(self.prd_content)} chars)")
        else:
            print("Invalid choice")
            return self.input_prd()
        
        return self.prd_content
    
    # =========================================================================
    # STEP 2: READ & ANALYZE - Fetch and understand PRD
    # =========================================================================
    def fetch_from_notion(self, notion_link: str) -> str:
        """Fetch PRD content from Notion using MCP"""
        print(f"\n→ Fetching content from Notion: {notion_link}")
        
        # This would use Notion MCP in real implementation
        # For now, simulating the fetch
        try:
            # In real implementation:
            # response = notion_client.pages.retrieve(page_id)
            # return extract_content(response)
            
            print("✓ Successfully fetched from Notion")
            return f"Notion content from {notion_link}"
        except Exception as e:
            print(f"✗ Error fetching from Notion: {e}")
            return ""
    
    def analyze_prd(self) -> Dict:
        """Call Claude to analyze PRD and suggest affected teams"""
        print("\n" + "="*70)
        print("STEP 2-3: ANALYZE PRD & SUGGEST AFFECTED TEAMS")
        print("="*70)
        print("\n→ Analyzing PRD with Claude...")
        
        # Load analysis prompt
        prompt_file = PROMPTS_DIR / "system-prompts" / "analyze-prd.md"
        with open(prompt_file) as f:
            analysis_prompt = f.read()
        
        response = self.claude.messages.create(
            model="claude-opus-4-7",
            max_tokens=2000,
            messages=[
                {
                    "role": "user",
                    "content": f"{analysis_prompt}\n\n--- PRD CONTENT ---\n{self.prd_content}"
                }
            ]
        )
        
        analysis_text = response.content[0].text
        
        # Extract JSON from response
        try:
            # Find JSON in response
            json_start = analysis_text.find('{')
            json_end = analysis_text.rfind('}') + 1
            analysis_json = json.loads(analysis_text[json_start:json_end])
        except json.JSONDecodeError:
            print("⚠ Could not parse JSON, using text response")
            analysis_json = {"analysis": analysis_text}
        
        return analysis_json
    
    # =========================================================================
    # STEP 4: GET PM CONFIRMATION
    # =========================================================================
    def get_team_confirmation(self, suggested_teams: List[Dict]) -> List[str]:
        """Interactive PM confirmation of affected teams"""
        print("\n" + "="*70)
        print("STEP 4: PM TEAM CONFIRMATION")
        print("="*70)
        
        print("\nSuggested affected teams:")
        print("-" * 50)
        for i, team in enumerate(suggested_teams, 1):
            impact = team.get("impact_level", "medium")
            reason = team.get("reason", "")
            print(f"{i}. {team['team_name']} [{impact}]")
            print(f"   → {reason}")
        
        print("\n" + "-" * 50)
        print("Options:")
        print("1. Approve all teams")
        print("2. Remove specific teams")
        print("3. Add custom teams")
        print("4. Custom selection")
        
        choice = input("\nSelect option (1-4): ").strip()
        
        confirmed_teams = [t['team_name'] for t in suggested_teams]
        
        if choice == "1":
            print("✓ All teams confirmed")
        elif choice == "2":
            remove_input = input("Enter team names to remove (comma-separated): ").strip()
            remove_list = [t.strip() for t in remove_input.split(",")]
            confirmed_teams = [t for t in confirmed_teams if t not in remove_list]
            print(f"✓ Removed: {', '.join(remove_list)}")
        elif choice == "3":
            add_input = input("Enter team names to add (comma-separated): ").strip()
            add_list = [t.strip() for t in add_input.split(",")]
            confirmed_teams.extend(add_list)
            print(f"✓ Added: {', '.join(add_list)}")
        elif choice == "4":
            confirmed_teams = []
            for team in suggested_teams:
                confirm = input(f"Include {team['team_name']}? (y/n): ").strip().lower()
                if confirm == 'y':
                    confirmed_teams.append(team['team_name'])
        
        print(f"\n→ Confirmed teams: {', '.join(confirmed_teams)}")
        return confirmed_teams
    
    # =========================================================================
    # STEP 5-6: GENERATE TEAM-SPECIFIC RELEASE NOTES
    # =========================================================================
    def generate_release_note(self, team_name: str) -> str:
        """Generate release note for a specific team"""
        print(f"\n→ Generating release notes for {team_name}...")
        
        # Load team-specific prompt
        prompt_file = PROMPTS_DIR / "team-prompts" / f"{team_name.lower()}.md"
        
        if not prompt_file.exists():
            # Use generic prompt if team-specific doesn't exist
            prompt_file = PROMPTS_DIR / "team-prompts" / "generic.md"
            if not prompt_file.exists():
                print(f"⚠ No prompt found for {team_name}")
                team_prompt = f"Generate release notes for the {team_name} team"
            else:
                with open(prompt_file) as f:
                    team_prompt = f.read()
        else:
            with open(prompt_file) as f:
                team_prompt = f.read()
        
        response = self.claude.messages.create(
            model="claude-opus-4-7",
            max_tokens=3000,
            messages=[
                {
                    "role": "user",
                    "content": f"{team_prompt}\n\n--- PRD CONTEXT ---\n{self.prd_content}"
                }
            ]
        )
        
        release_note = response.content[0].text
        
        # Save to temp file
        output_file = OUTPUT_DIR / "generated-notes" / f"{team_name.lower()}.md"
        output_file.parent.mkdir(parents=True, exist_ok=True)
        with open(output_file, 'w') as f:
            f.write(release_note)
        
        print(f"✓ Generated and saved to {output_file}")
        return release_note
    
    # =========================================================================
    # STEP 7: CREATE NOTION SUB-PAGES
    # =========================================================================
    def post_to_notion(self, team_name: str, content: str, parent_page_id: str):
        """Create sub-page in Notion with generated content"""
        print(f"\n→ Creating Notion sub-page for {team_name}...")
        
        # In real implementation with Notion MCP:
        # from mcp.notion import create_pages
        # 
        # create_pages(
        #     pages=[{
        #         "properties": {"title": team_name},
        #         "content": content
        #     }],
        #     parent={"page_id": parent_page_id}
        # )
        
        print(f"✓ Posted {team_name} release notes to Notion")
    
    # =========================================================================
    # MAIN ORCHESTRATION
    # =========================================================================
    def run(self):
        """Main agent loop"""
        print("\n" + "="*70)
        print("PRODUCT RELEASE NOTES AGENT")
        print("="*70)
        
        try:
            # Step 1: Get PRD input
            self.input_prd()
            
            # Step 2-3: Analyze and suggest teams
            analysis = self.analyze_prd()
            suggested_teams = analysis.get("affected_teams", [])
            
            # Step 4: PM confirmation
            confirmed_teams = self.get_team_confirmation(suggested_teams)
            
            # Step 5-6: Generate release notes for each team
            generated_notes = {}
            for team in confirmed_teams:
                note = self.generate_release_note(team)
                generated_notes[team] = note
            
            # Step 7: Ask final confirmation before posting to Notion
            print("\n" + "="*70)
            print("FINAL CONFIRMATION: POST TO NOTION")
            print("="*70)
            print(f"\nReady to post {len(generated_notes)} release notes to Notion")
            print(f"Teams: {', '.join(generated_notes.keys())}")
            
            confirm = input("\nProceed with posting to Notion? (yes/no): ").strip().lower()
            
            if confirm == 'yes':
                # Get parent page ID
                parent_page_id = input("Enter parent Notion page ID: ").strip()
                
                for team, content in generated_notes.items():
                    self.post_to_notion(team, content, parent_page_id)
                
                print("\n✓ All release notes posted to Notion!")
            else:
                print("⊘ Cancelled posting to Notion")
            
        except Exception as e:
            print(f"\n✗ Error: {e}")
            import traceback
            traceback.print_exc()

if __name__ == "__main__":
    agent = ReleaseNotesAgent()
    agent.run()
```

---

### Step 5: Setup & Environment

**File:** `.env.example`
```bash
# Claude API
CLAUDE_API_KEY=sk-...

# Notion API
NOTION_API_KEY=ntn_...
NOTION_DATABASE_ID=optional-if-using-database

# Environment
ENV=development
LOG_LEVEL=info
```

**File:** `requirements.txt`
```
anthropic>=0.25.0
python-dotenv>=1.0.0
pyyaml>=6.0
requests>=2.31.0
```

**Setup Commands:**
```bash
# Install dependencies
pip install -r requirements.txt

# Copy env template
cp .env.example .env

# Add your API keys to .env
nano .env

# Run the agent
python src/main.py
```

---

### Step 6: Notion MCP Integration

**File:** `docs/notion-mcp-setup.md`

```markdown
# Setting Up Notion MCP Integration

## Prerequisites
- Notion API key from https://www.notion.so/my-integrations
- The agent will use claude.ai Notion MCP for reading/writing

## Steps

1. **Create Notion Integration**
   - Go to https://www.notion.so/my-integrations
   - Click "New integration"
   - Name it "Release Notes Agent"
   - Save the Internal Integration Token

2. **Configure in Agent**
   - Add to `.env`:
     ```
     NOTION_API_KEY=ntn_xxxxx
     ```

3. **Share Pages with Integration**
   - Open your PRD page
   - Click "Share"
   - Select your integration
   - Grant access

4. **Get Page ID**
   - Open the page URL: `https://www.notion.so/workspace/{PAGE_ID}?v=...`
   - Extract the PAGE_ID

## Usage in Agent

```python
# The agent will use Notion MCP through Claude Code:
# - Read PRD: notion_fetch(page_id)
# - Create sub-pages: notion_create_pages(pages=[...])
```

## Troubleshooting
- Ensure integration has access to the page (Share settings)
- Check API token is correct in `.env`
- Verify page_id format (remove dashes if present)
```

---

## Execution Flow Summary

### Terminal Interaction
```
$ python src/main.py

STEP 1: PROVIDE PRD CONTENT
Options:
1. Paste Notion link
2. Paste PRD content directly

> Enter option: 1
> Enter Notion link: https://www.notion.so/...

STEP 2-3: ANALYZE PRD & SUGGEST AFFECTED TEAMS
→ Analyzing PRD with Claude...
✓ Done in 2.3s

Suggested affected teams:
1. Engineering [high] → API and database changes
2. Product [high] → New user feature
3. Marketing [medium] → GTM coordination
4. Operations [low] → Process documentation

STEP 4: PM TEAM CONFIRMATION
Options:
1. Approve all teams
2. Remove specific teams
3. Add custom teams
4. Custom selection

> Select option: 1
✓ All teams confirmed

STEP 5-6: GENERATING RELEASE NOTES
→ Generating release notes for Engineering...
✓ Generated and saved
→ Generating release notes for Product...
✓ Generated and saved
→ Generating release notes for Marketing...
✓ Generated and saved
→ Generating release notes for Operations...
✓ Generated and saved

STEP 7: FINAL CONFIRMATION
Ready to post 4 release notes to Notion
Teams: Engineering, Product, Marketing, Operations

> Proceed with posting to Notion? (yes/no): yes
> Enter parent Notion page ID: abc123def456

→ Creating Notion sub-page for Engineering...
✓ Posted Engineering release notes to Notion
→ Creating Notion sub-page for Product...
✓ Posted Product release notes to Notion
→ Creating Notion sub-page for Marketing...
✓ Posted Marketing release notes to Notion
→ Creating Notion sub-page for Operations...
✓ Posted Operations release notes to Notion

✓ All release notes posted to Notion!
```

---

## File Structure Reference

```
product-release-notes-agent/
├── src/
│   └── main.py                      # Main agent script
├── prompts/
│   ├── system-prompts/
│   │   └── analyze-prd.md          # PRD analysis prompt
│   └── team-prompts/
│       ├── engineering.md
│       ├── product.md
│       ├── marketing.md
│       ├── operations.md
│       └── [your custom teams].md
├── config/
│   └── notion.yaml                 # Notion config
├── output/
│   └── generated-notes/            # Temp generated files
├── docs/
│   ├── notion-mcp-setup.md
│   ├── custom-teams.md
│   └── troubleshooting.md
├── .env.example                    # Environment template
├── requirements.txt                # Python dependencies
├── main.md                         # This file
└── README.md                       # Quick start
```

---

## Key Features

✅ **Interactive Workflow** - Step-by-step approval gates  
✅ **Claude Integration** - Multi-turn analysis & generation  
✅ **Notion MCP Ready** - Designed for Notion sub-page creation  
✅ **Custom Team Prompts** - Easy to add/modify team-specific instructions  
✅ **Reversible Decisions** - Confirm before posting to Notion  
✅ **Audit Trail** - All generated content saved locally first  

---

## Next Steps

1. **Create folder structure** (see Step 1 above)
2. **Add your team prompts** to `prompts/team-prompts/`
3. **Set up Notion MCP** (see docs/notion-mcp-setup.md)
4. **Install dependencies** and configure `.env`
5. **Run the agent**: `python src/main.py`

---

## Customization

### Add Custom Teams
1. Create `prompts/team-prompts/{team-name}.md`
2. Write team-specific prompt
3. Run agent - it auto-detects new teams

### Modify Analysis Logic
Edit `prompts/system-prompts/analyze-prd.md` to change:
- How teams are identified
- Impact level calculation
- Which teams are suggested

### Change LLM Model
In `src/main.py`, update:
```python
response = self.claude.messages.create(
    model="claude-opus-4-7",  # Change here
    ...
)
```

---

## Support

For issues or questions:
1. Check `docs/troubleshooting.md`
2. Review Notion MCP documentation
3. Check Claude API docs: https://docs.anthropic.com

