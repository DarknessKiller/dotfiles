---
name: bitbucket-helper
description: Use when drafting, creating, getting, reading, or updating pull requests for self-hosted Bitbucket Server/Data Center repositories; when inferring Bitbucket project/repo from local git remotes such as /scm/PROJECT/repo.git or /projects/PROJECT/repos/repo; or when avoiding Bitbucket Cloud-only tools for self-hosted Bitbucket.
---

# Bitbucket Helper

## Table of Contents

  - [Bitbucket Helper / Overview](#bitbucket-helper-overview)
  - [Bitbucket Helper / Agent Integration](#bitbucket-helper-agent-integration)
  - [Bitbucket Helper / Workflow](#bitbucket-helper-workflow)
  - [Bitbucket Helper / Auth](#bitbucket-helper-auth)
  - [Bitbucket Helper / CLI Usage](#bitbucket-helper-cli-usage)
  - [Bitbucket Helper / Description Standards](#bitbucket-helper-description-standards)
  - [Description](#description)
  - [Test Plan](#test-plan)
  - [Test Result](#test-result)
  - [Code Risk](#code-risk)
  - [Related](#related)

---


**AI Context**: This documentation is optimized for AI consumption

---


## Bitbucket Helper / Overview

Use Bitbucket Helper for self-hosted Bitbucket Server/Data Center PR work. Avoid Bitbucket Cloud-only tools for these repositories.

Prefer the bundled AXI-style helper CLI for repeatable repo detection, PR Markdown drafting, and REST calls. Use `bitbucket-helper` when it is on `PATH`; otherwise run the wrapper directly from this folder:

```bash
bin/bitbucket-helper
```

The helper uses concise, structured stdout for agent consumption. Use `get` to read an existing PR; there is no `read` subcommand. Run a command with `--json` only when full raw Bitbucket API fields are needed.

## Bitbucket Helper / Agent Integration

This helper is agent-neutral. It can be referenced from Codex skills, Claude `CLAUDE.md`, OpenCode `AGENTS.md`, or any project-level agent instructions.

Use this compact instruction in Claude/OpenCode/Codex project memory when the skill folder is not auto-discovered:

```markdown
For self-hosted Bitbucket Server/Data Center pull requests, use Bitbucket Helper. Prefer `bitbucket-helper` if it is on PATH; otherwise run `/absolute/path/to/bitbucket-helper/bin/bitbucket-helper`. Use compact default output for agent decisions and add `--json` only when raw API fields are needed.
```

## Bitbucket Helper / Workflow

1. Inspect the local branch, target branch, commits, and diff before drafting.
2. Infer Bitbucket identity from `git remote -v`:
   - Clone URL: `https://host/scm/PROJECT/repo.git`
   - Browser URL: `https://host/projects/PROJECT/repos/repo`
3. Draft a PR description with exactly these top-level sections:
   - Description
   - Test Plan
   - Test Result
   - Code Risk
   - Related
4. Ask before creating or updating live PRs unless the user explicitly asked to create/update.
5. Use Bitbucket Server REST API, not Bitbucket Cloud API:
   - Create PR: `POST {base}/rest/api/1.0/projects/{PROJECT}/repos/{repo}/pull-requests`
   - Read PR: `GET {base}/rest/api/1.0/projects/{PROJECT}/repos/{repo}/pull-requests/{id}`
   - Update PR: `PUT {base}/rest/api/1.0/projects/{PROJECT}/repos/{repo}/pull-requests/{id}` after reading the current PR version
6. For updates, send a minimal PUT payload only. Do not echo read-only fields such as `author`; include title, description, version, fromRef, toRef, and reviewer user names.

## Bitbucket Helper / Auth

Use the repo's existing self-hosted Bitbucket environment variables:

```bash
BB_USER
BB_PASSWORD
```

Use raw `BB_PASSWORD`, not `BB_PASSWORD_ESCAPED`. The escaped value is only for embedding credentials in URLs.

The helper defaults to basic auth with:

```bash
Authorization: Basic base64(BB_USER:BB_PASSWORD)
```

Override `--user` only when intentionally using a different username. Use bearer auth only if explicitly requested by the user; it still reads the raw token from `BB_PASSWORD`.

Never print tokens. Never store tokens in repo files.

## Bitbucket Helper / CLI Usage

Draft only:

```bash
bitbucket-helper draft --repo-dir .
```

Create a PR using `BB_USER` and `BB_PASSWORD`:

```bash
bitbucket-helper create --repo-dir . --target main --title "PROJ-123: concise title"
```

Update an existing PR title/description:

```bash
bitbucket-helper update 123 --repo-dir . --title "PROJ-123: concise title"
```

Read an existing PR:

```bash
bitbucket-helper get 123 --repo-dir .
```

Read full raw Bitbucket fields when needed:

```bash
bitbucket-helper get 123 --repo-dir . --json
```

Refresh an existing PR description from the local branch:

```bash
bitbucket-helper update 123 --repo-dir . --refresh-description
```

Override detection when needed:

```bash
bitbucket-helper create --base-url https://bitbucket.example.com --project PROJ --repo repo --source feature/foo --target main
```

## Bitbucket Helper / Description Standards

Keep the title short and reviewable. Use Jira keys from branch or commits when present.

Use this body shape exactly for this repo:

```markdown
## Description
- What changed and why.

## Test Plan
- E2E: Planned/not applicable.
- Ginkgo: Planned/not applicable.

## Test Result
- E2E: Not run yet.
- Ginkgo: Not run yet.

## Code Risk
- Risk: Describe the main review/runtime risk.
- Rollback: Revert this PR.

## Related
- PROJ-123 or Not applicable.
```

Be explicit about uncertainty. If E2E or Ginkgo tests were not run, say so under `Test Result`. If target branch is guessed, state it before creating.
Do not add extra top-level headings such as `Files Touched`, `Changes`, or `Risk / Rollback`; fold those details into `Description` or `Code Risk`.
