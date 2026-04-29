# /project:launch-notes Command Prompt

## Execution Instructions for Claude

When a user types `/project:launch-notes` in a deployment folder, execute these steps:

### 1. Load Context Files

- Read `PRD.md` from the current working directory (full text)
- Read `../../team-context/team_descriptions.md` (contains 16 teams)

### 2. Understand Each Team's Profile

For each team, note their:
- **Function**: What they own and manage
- **Key Concerns**: What they care about at launch  
- **Tone**: How to communicate with them

### 3. Generate 16 Sections

For each team, create a section with this exact structure:

```markdown
## For [Team Name]

**What's changing**
[2-3 sentences specific to this team's function and concerns]

**Actions/decisions needed**
- [Specific, actionable bullet points]

**Risks / watch-outs**
- [Team-specific escalation flags]
```

### 4. Write Output File

Save all 16 sections to `launch-notes.md` in the current directory.

Format:
- Add a header: "# Pre-Launch Sync Notes"
- Add metadata: Feature name, date, purpose
- Add all 16 team sections
- Make it markdown-formatted and readable

### 5. Content Guidelines

**What's changing**: Translate PRD impact into language meaningful for each team's KPIs and daily work. Be specific - not generic.

**Actions/decisions needed**: Concrete pre-launch steps. Examples:
- Confirm X with team Y
- Update SOP for Z
- Test A in staging
- Get sign-off from B

**Risks/watch-outs**: Escalation flags specific to their domain.

### Example Output Structure

```markdown
# Pre-Launch Sync Notes

**Feature:** [Name]
**Generated:** [Date]

---

## For Compliance — Onboarding

**What's changing**
[Specific to KYC/KYB, customer segments, data collection]

**Actions/decisions needed**
- [KYC-specific actions]

**Risks / watch-outs**
- [Compliance-specific risks]

---

## For Risk

**What's changing**
[Specific to fraud, credit, operational risk]

**Actions/decisions needed**
- [Risk-specific actions]

**Risks / watch-outs**
- [Risk-specific escalations]

---

[... continue for all 16 teams ...]
```

## Quality Checklist

Before completing:
- [ ] All 16 teams have a section
- [ ] Each section has "What's changing", "Actions/decisions", "Risks/watch-outs"
- [ ] Language is tailored to each team's function and tone
- [ ] Actions are specific and concrete (not generic)
- [ ] Risks are team-specific escalation flags
- [ ] Uses details/numbers from the PRD where available
- [ ] File saved as launch-notes.md in current directory
- [ ] Markdown is properly formatted

## Teams to Cover (16 total)

1. Compliance — Onboarding
2. Compliance — Transaction Monitoring
3. Risk
4. Payment Operations
5. Treasury
6. Growth — Sales
7. Growth — Account Management
8. Partnerships
9. Legal
10. Finance
11. Licensing
12. Product — Payments Pod
13. Product — Operations Pod
14. Product — Merchant Pod
15. Product — Data
16. Engineering

## Usage

Users run this in a deployment folder:
```
/project:launch-notes
```

This command triggers Claude to:
1. Read PRD.md and team_descriptions.md
2. Generate all 16 notes
3. Write launch-notes.md
4. Complete in 2-3 minutes
