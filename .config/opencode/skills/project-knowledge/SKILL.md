---
name: project-knowledge
description: retrieve jira and confluence context with atlassian twg, summarize authoritative findings, and write durable owner notes to blinko mcp when information should be remembered later. use when asked to search jira, confluence, internal project docs, tickets, decisions, blockers, or to capture long-lived project knowledge for the owner.
---

# Project Knowledge

## Table of Contents

  - [Project Knowledge / Overview](#project-knowledge-overview)
  - [Project Knowledge / Workflow](#project-knowledge-workflow)
  - [Project Knowledge / Jira](#project-knowledge-jira)
  - [Project Knowledge / Confluence](#project-knowledge-confluence)
  - [Project Knowledge / Blinko MCP Notes](#project-knowledge-blinko-mcp-notes)
  - [Project Knowledge / Response Shape](#project-knowledge-response-shape)

---


**AI Context**: This documentation is optimized for AI consumption

---


## Project Knowledge / Overview

Use this skill to find authoritative project context in Jira and Confluence, then persist only durable owner-relevant notes in Blinko MCP.

## Project Knowledge / Workflow

1. Determine whether the request needs Jira, Confluence, both, or a Blinko note.
2. Search the most likely source first, then expand only when needed.
3. Prefer authoritative, current, and source-of-truth content over drafts or summaries.
4. Summarize the result with exact keys, titles, statuses, and decision context.
5. Write to Blinko only when the finding is durable and useful to the repository owner later.

## Project Knowledge / Jira

Use Jira for:

- issue status
- assignee and ownership
- priority and scope
- blockers and dependencies
- acceptance criteria
- linked issues
- decision-making comments

Rules:

- Preserve exact issue keys and status names.
- Surface ambiguity when multiple tickets match.
- Call out blockers, overdue work, and scope changes.
- Do not guess the intended ticket when the result set is unclear.

## Project Knowledge / Confluence

Use Confluence for:

- specifications
- design docs
- architecture notes
- runbooks
- meeting notes
- project decisions
- process documentation

- Prefer the latest authoritative page.
- Identify whether a page is a source of truth, draft, or archived note.
- Call out contradictions, stale sections, and missing decisions.
- Preserve related Jira keys and references when present.

## Project Knowledge / Blinko MCP Notes

Write a Blinko note only when the information is likely to matter later to the owner.

Save:

- important decisions
- blockers that need follow-up
- scope, ownership, or timeline changes
- recurring issues or root causes
- long-lived project context
- action items the owner should remember

Do not save:

- temporary debugging details
- verbose search transcripts
- duplicate information
- low-value observations
- routine implementation noise

Note style:

- keep it concise
- make it factual and actionable
- include source identifiers when useful
- separate facts from interpretation

## Project Knowledge / Response Shape

When responding, include:

- what was found
- where it came from
- what matters for the owner
- whether a Blinko note was written

If the requested item is unclear, ask for the missing key, page title, team name, or search term instead of guessing.

