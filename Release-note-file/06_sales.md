# Release Note Prompt — Sales

> **Team context:** Owns new merchant acquisition. Needs to be prepared to pitch before a feature goes live — not briefed after.
> **KPIs:** Pipeline generated, deal velocity, win rate.
> **Orientation:** Needs to know what's available, who it's for, and where to point prospects for details — not pricing or technical specs.

---

## Team Description (for context)

**Function:**
Acquires new merchants and enterprise clients. Before a launch, Sales needs to know what the feature does in plain language, who it's for, and whether all the supporting material is ready — product one-pager, Figma/demo video if available, and API docs published. They also need confidence that Compliance, Risk, Ops, and other relevant teams are aligned and ready, so they aren't selling something the business isn't ready to support. For technical or complex prospect questions, they escalate to Product.

**Key concerns at launch:**
- What does this feature do and who is the target customer — in plain, pitchable language?
- Is there a Figma, demo video, or visual they can use in conversations?
- Are API docs published and accessible to share with prospects?
- Are Compliance, Risk, and Ops aligned — can we actually deliver what we're selling?
- What are the known limitations or constraints to disclose so they don't overpromise?
- Which geographies and segments are in scope at launch?

**Tone:** Clear and commercial. Lead with what Sales can now say to a prospect. Make it easy to pitch. Flag any gaps in readiness that would block them from selling confidently.

---

## Prompt

```
You are a Senior PMM writing an internal pre-release sync note for the Sales team.

Context about this team: They acquire new merchants. Before going live, they need to know what the feature does (in plain language), who it's for, whether supporting materials are ready (Figma/video, API docs), and whether internal teams are aligned and ready to deliver. They escalate complex prospect questions to Product. No pricing detail needed.

PRD: [PASTE NOTION/CONFLUENCE LINK]

North star for this release: give Sales what they need to pitch confidently from day one — not a debrief after launch.

Write a short internal note using exactly this structure:

**What's changing**
2–3 sentences. What can Sales now say to a prospect that they couldn't before? Who is this for and what problem does it solve — in plain, jargon-free language?

**Actions / decisions needed**
Bullet list (3–5 items). Examples: confirm Figma or demo video is available and shareable, check API docs are published and live, verify Compliance/Risk/Ops are aligned and ready to support, identify target merchant segments to prioritise outreach, flag any geographies or segments excluded at launch.

**Risks / watch-outs**
2–3 bullets. What should Sales not promise? What known limitations or constraints need to be disclosed upfront? Are there any internal readiness gaps that could embarrass them mid-deal?

Tone: clear, commercial, confident. No pricing. Keep the full note under 400 words.
```
