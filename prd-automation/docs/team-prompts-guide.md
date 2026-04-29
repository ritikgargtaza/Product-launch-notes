# Team-Specific Prompts Guide

This guide explains how to write and maintain effective team-specific prompts for release note generation.

## Overview

Each team has a unique prompt template that guides Claude in generating release notes tailored to that team's needs and perspective.

**Location:** `../release-note-file/`

**Format:** Markdown (`.md`) files, one per team

**Naming:** `{team-name}.md` (lowercase, hyphens for spaces)

Examples:
- `engineering.md`
- `product.md`
- `marketing.md`
- `operations.md`
- `sales.md`
- `customer-success.md`

## Prompt Structure

Each prompt should have these sections:

### 1. Role & Context
Define who the audience is and what they care about.

```markdown
# {Team Name} Release Notes

You are writing release notes for the {Team} team.

**Audience:** [Who reads this - engineers, managers, customers, etc.]
**Goal:** [What should they understand or do after reading]
**Tone:** [Technical, conversational, formal, etc.]
```

### 2. Key Content Areas
Specify what topics should be covered for this team.

```markdown
## Coverage Areas

1. **[Area 1]** - What aspects should be covered
   - Specific consideration 1
   - Specific consideration 2

2. **[Area 2]** - Another important area
   - Related topics
   - Business implications
```

### 3. Format & Structure
Define how the content should be organized.

```markdown
## Format Requirements

- Use clear headings and subheadings
- Include code examples where relevant
- Add [specific formatting: tables, lists, diagrams, etc.]
- Keep sections [specific length guidance]
```

### 4. Success Criteria
What makes a good release note for this team?

```markdown
## Quality Checklist

- [ ] Covers all [specific areas]
- [ ] Uses appropriate language and examples
- [ ] Provides actionable information
- [ ] Includes [specific details like timelines, links, etc.]
- [ ] Is [readability criteria: concise, comprehensive, etc.]
```

## Example Prompts

### Engineering Team Prompt

**File:** `engineering.md`

```markdown
# Engineering Release Notes

You are writing technical release notes for the Engineering team.

**Audience:** Backend, frontend, DevOps, and QA engineers  
**Goal:** Ensure engineers understand technical changes and can implement/test effectively  
**Tone:** Technical, precise, actionable

## Coverage Areas

1. **Technical Changes**
   - Architecture modifications
   - API changes (endpoints, payloads, authentication)
   - Database schema changes or migrations
   - Library and dependency updates
   - Performance implications

2. **Implementation Details**
   - Breaking changes
   - Deprecations
   - Migration steps required
   - Rollback procedures
   - Backward compatibility notes

3. **Deployment & Rollout**
   - Deployment order (if multiple services)
   - Feature flags or gradual rollout strategy
   - Environment-specific configurations
   - Testing requirements
   - Rollback triggers

4. **Monitoring & Support**
   - Metrics to monitor
   - New alerts or alert threshold changes
   - Common failure modes
   - Debugging guidance
   - Runbook links

5. **Dependencies & Integration Points**
   - Services affected
   - Cross-team dependencies
   - Third-party integrations changed
   - Data format changes

## Format Requirements

- **Length:** 800-1500 words
- Use code blocks for API examples:
  ```
  POST /api/v2/...
  ```
- Include migration examples if applicable
- Use tables for comparing old vs new
- Add numbered steps for multi-step processes
- Include links to relevant documentation

## Quality Checklist

- [ ] All API changes documented with examples
- [ ] Breaking changes clearly highlighted
- [ ] Migration steps are step-by-step and testable
- [ ] Rollback plan is documented
- [ ] Performance impact quantified if significant
- [ ] Monitoring metrics identified
- [ ] Links to related PRs or issues included
- [ ] No ambiguity about rollout timing
```

### Product Team Prompt

**File:** `product.md`

```markdown
# Product Release Notes

You are writing release notes for the Product team.

**Audience:** Product managers, designers, product analysts  
**Goal:** Understand feature implications, user impact, and go-to-market readiness  
**Tone:** Business-focused, user-centric, strategic

## Coverage Areas

1. **Feature Overview**
   - What's new from the user perspective
   - Problem solved or value delivered
   - User-facing benefits and capabilities
   - Feature stage (beta, GA, sunset, etc.)

2. **Product Impact**
   - User engagement implications
   - Retention or churn impact
   - Competitive differentiation
   - User research findings (if applicable)

3. **Go-to-Market Plan**
   - Target user segments
   - Launch timing and phases
   - Messaging strategy
   - Success metrics and targets
   - Key stakeholders or dependencies

4. **FAQ & Edge Cases**
   - Common user questions
   - Known limitations
   - Workarounds if applicable
   - Future roadmap implications

5. **Analytics & Measurement**
   - Key metrics to track
   - Dashboard/reporting setup
   - Success criteria

## Format Requirements

- **Length:** 600-1000 words
- Use bullet points for benefits and features
- Include user personas if relevant
- Link to related design specs or user research
- Add timeline visualization if phased rollout
- User-friendly language (avoid jargon)

## Quality Checklist

- [ ] User benefits clearly articulated
- [ ] Impact on key metrics explained
- [ ] Success metrics defined and measurable
- [ ] Go-to-market strategy clear
- [ ] Edge cases and limitations transparent
- [ ] Future roadmap connections noted
- [ ] Analytics instrumentation planned
- [ ] No unnecessary technical jargon
```

### Marketing Team Prompt

**File:** `marketing.md`

```markdown
# Marketing Release Notes

You are writing customer-facing marketing communications for this release.

**Audience:** Customers, prospects, media, analysts  
**Goal:** Generate excitement, drive adoption, communicate value  
**Tone:** Compelling, customer-centric, accessible

## Coverage Areas

1. **Announcement Copy**
   - Catchy headline/announcement
   - One-paragraph summary of the big idea
   - Key customer benefits
   - Why it matters (business impact)

2. **Customer-Facing Features**
   - What users can now do
   - How it improves their workflow
   - Time/cost savings if quantifiable
   - Visual descriptions (if available)

3. **Target Audiences & Messaging**
   - Primary audience segment
   - Secondary audiences
   - Customized messaging for each segment
   - Industry-specific implications

4. **Marketing Assets & Channels**
   - Blog post outline
   - Social media snippets (LinkedIn, Twitter, etc.)
   - Email campaign angles
   - Customer story ideas
   - Demo/video script ideas
   - Press release outline

5. **Customer Success & Support**
   - FAQ for customers
   - Training recommendations
   - Success resources needed
   - Timeline for customer rollout

## Format Requirements

- **Length:** 400-700 words
- **Structure:**
  - Headline
  - Subheading
  - 2-3 main benefit sections
  - Call-to-action
- Use customer-friendly language
- Include quotes or testimonials if available
- Link to resource pages or documentation

## Quality Checklist

- [ ] Headline is compelling and clear
- [ ] Benefits focused on customer value, not features
- [ ] Language is accessible (no jargon)
- [ ] Multiple audience segments addressed
- [ ] Marketing assets outlined
- [ ] Customer success plan included
- [ ] Calls-to-action clear
- [ ] Timeline aligned with product launch
```

### Operations Team Prompt

**File:** `operations.md`

```markdown
# Operations Release Notes

You are writing release notes for the Operations team.

**Audience:** Operations managers, SREs, on-call engineers, support team  
**Goal:** Ensure smooth deployment and support readiness  
**Tone:** Clear, procedural, risk-aware

## Coverage Areas

1. **Operational Changes**
   - New or modified processes
   - Tool or system changes
   - Workflow updates
   - Automation changes
   - On-call impact

2. **Deployment & Runout**
   - Deployment steps
   - Pre-deployment checklist
   - Rollout strategy (immediate, phased, canary)
   - Timing and windows
   - Dependencies with other teams

3. **Monitoring & Alerting**
   - New metrics to monitor
   - Alert thresholds (if changed)
   - Dashboard links for viewing
   - Expected baseline values
   - Anomaly detection setup

4. **Risk & Mitigation**
   - Potential failure points
   - Mitigation strategies
   - Rollback procedures
   - Escalation paths
   - Incident response plan

5. **Support & Escalation**
   - How to handle customer issues
   - Troubleshooting steps
   - When to escalate
   - On-call contacts for different issues
   - Known issues and workarounds

## Format Requirements

- **Length:** 600-1000 words
- Use numbered lists for sequential procedures
- Include decision trees if troubleshooting
- Bold important warnings or critical steps
- Include direct links to monitoring/dashboards
- Provide copy-paste ready commands or configs

## Quality Checklist

- [ ] All deployment steps documented
- [ ] Rollback procedure is clear and tested
- [ ] Monitoring setup defined
- [ ] Alert thresholds specified
- [ ] Escalation paths clear
- [ ] Customer impact scenarios covered
- [ ] Timeline and dependencies clear
- [ ] Links to runbooks included
```

## Best Practices

### ✅ DO

- **Be specific** - Use exact numbers, links, and examples
- **Assume context** - Don't over-explain basics; assume team knowledge
- **Highlight action items** - What does this team need to DO?
- **Include examples** - Code samples, screenshots, mockups
- **Anticipate questions** - Answer "why" not just "what"
- **Use team language** - Match terminology and style the team uses
- **Link resources** - Runbooks, docs, dashboards, related PRs
- **Provide data** - Performance metrics, user impact numbers, timelines

### ❌ DON'T

- **Generic content** - Copy/paste the same thing for all teams
- **Too much detail** - Don't include info other teams don't need
- **Jargon without context** - Explain specialized terms
- **Missing timelines** - Always specify when things happen
- **Vague success criteria** - Define how to measure success
- **Forget edge cases** - Call out known issues and workarounds
- **Omit the "why"** - Explain the business/technical rationale

## Tips for Each Team

### Engineering
- Include code diffs or examples
- Specify test coverage expectations
- Call out performance implications
- Provide migration scripts if needed

### Product
- Focus on user outcomes
- Include competitive context
- Mention go-to-market timeline
- Link to specs and design documents

### Marketing
- Make it exciting and customer-focused
- Provide messaging frameworks
- Include asset specifications
- Timeline for campaigns

### Operations
- Be procedural and step-by-step
- Include monitoring and alert details
- Provide rollback procedures
- Specify escalation paths

### Sales / Customer Success
- Focus on customer value
- Include messaging talking points
- Highlight ROI or time savings
- Provide FAQ and objection handling

## Testing Your Prompt

### Before Publishing

1. **Read the template** - Does it make sense?
2. **Check completeness** - Are all sections covered?
3. **Test with a sample PRD** - Have Claude generate using your prompt
4. **Review output** - Is the generated content good?
5. **Iterate** - Refine based on output quality

### Questions to Answer

- Would your team member find this immediately useful?
- Is anything confusing or unclear?
- Is any critical information missing?
- Would they want more or less detail?
- Does it match your team's expectations?

## Versioning Your Prompts

### Track Changes

```markdown
# Product Release Notes

**Version:** 2.1  
**Last Updated:** 2026-04-01  
**Author:** Product Manager

## Recent Changes (v2.1)
- Added "Analytics & Measurement" section
- Removed "Regulatory" section (rarely used)
- Updated examples to match new template

[rest of prompt...]
```

### Update Strategy

- Keep prompts fresh as team needs evolve
- Review quarterly with team lead
- Update when past release notes identify gaps
- Add examples from successful releases
- Remove sections that never get used

## Adding New Teams

### Create a New Prompt

1. Create `../release-note-file/{team-name}.md`
2. Use template structure above
3. Customize for your team
4. Test with sample PRD
5. Share with team for feedback
6. Agent auto-detects and uses for next generation

Example: To add a "Legal" team:

```bash
touch ../release-note-file/legal.md
# Edit file with appropriate legal considerations
# Next time agent runs, Legal team will appear in suggestions
```

## Example: Real Release Notes

See `examples/` folder for:
- Sample generated release notes
- Prompts that produced them
- Team feedback and iterations

## Questions?

- **How detailed should it be?** - As much as engineers/managers typically need
- **How long?** - 500-1500 words depending on team
- **Update frequency?** - When team needs change or feedback suggests changes
- **Can we customize per feature?** - Override per-feature by providing custom context

---

**Next Step:** Open `../release-note-file/` and review your existing team prompts!
