---
name: creating-worktrees
description: Use when the user asks to create a worktree, git worktree, new isolated workspace, branch workspace, repo-local .worktrees path, or CodeGraph initialization for a worktree.
---

# Creating Worktrees

## Table of Contents

  - [Creating Worktrees / Overview](#creating-worktrees-overview)
  - [Creating Worktrees / Quick Reference](#creating-worktrees-quick-reference)
  - [Creating Worktrees / Workflow](#creating-worktrees-workflow)
  - [Creating Worktrees / Fish Sketch](#creating-worktrees-fish-sketch)
  - [Creating Worktrees / Common Mistakes](#creating-worktrees-common-mistakes)
  - [Creating Worktrees / Stop Conditions](#creating-worktrees-stop-conditions)

---


**AI Context**: This documentation is optimized for AI consumption

---


## Creating Worktrees / Overview

Create repo-local worktrees at `.worktrees/<branch>-<YYYYMMDD-HHMMSS>`. Use local Git exclude for `.worktrees/`. Initialize CodeGraph only when the source repo already has `.codegraph/` or the user explicitly asks for CodeGraph.

## Creating Worktrees / Quick Reference

| Decision | Rule |
| --- | --- |
| Worktree parent | Repository root `.worktrees/` |
| Worktree name | `<branch-or-task-slug>-<YYYYMMDD-HHMMSS>` |
| Path slug | Replace `/`, spaces, and unusual characters with `-` |
| Ignore rule | Add `.worktrees/` to local Git exclude from `git rev-parse --git-path info/exclude` |
| Shared ignore | Edit `.gitignore` only when the user explicitly asks |
| CodeGraph | Run `codegraph init <path>` only when source has `.codegraph/` or user asks |

## Creating Worktrees / Workflow

1. Find repo root with `git rev-parse --show-toplevel`.
2. If already inside a linked worktree, do not create a nested worktree. Report current path.
3. Get branch/task name from the request. If missing, ask one question. If the user gives a task title instead of a valid git branch, derive a simple slug and use that as the branch.
4. Build path under repo root:
   - sanitize branch/task for path use (`/`, spaces, weird chars → `-`)
   - append timestamp: `<slug>-<YYYYMMDD-HHMMSS>`
5. Ensure `.worktrees/` is ignored before `git worktree add`:
   - add exact `.worktrees/` line to local exclude from `git rev-parse --git-path info/exclude`
   - do not edit `.gitignore` unless user explicitly asks for a shared ignore rule
6. Create worktree:
   - branch exists: `git worktree add <path> <branch>`
   - branch missing: `git worktree add -b <branch> <path>`
   - branch already checked out elsewhere: report existing worktree; do not force
7. Run `codegraph init` inside the new worktree only if:
   - source repo root had `.codegraph/`, or
   - user explicitly asked for CodeGraph
8. Report path, branch, local exclude change, and CodeGraph result.

## Creating Worktrees / Fish Sketch

```fish
set repo_root (git rev-parse --show-toplevel)
set raw_name <branch-or-task-name>
set slug (string replace -ra '[^A-Za-z0-9._-]+' '-' -- $raw_name)
set branch $raw_name
if not git check-ref-format --branch "$branch" >/dev/null 2>&1
    set branch $slug
end
set stamp (date +%Y%m%d-%H%M%S)
set path "$repo_root/.worktrees/$slug-$stamp"
set wants_codegraph 0

test -d "$repo_root/.codegraph"; and set wants_codegraph 1
# If user explicitly asked for CodeGraph, set wants_codegraph 1 too.

mkdir -p "$repo_root/.worktrees"
set exclude (git -C "$repo_root" rev-parse --git-path info/exclude)
mkdir -p (dirname "$exclude")
if not test -f "$exclude"
    touch "$exclude"
end
if not string match -qx '.worktrees/' < "$exclude"
    printf '\n.worktrees/\n' >> "$exclude"
end

if git -C "$repo_root" show-ref --verify --quiet "refs/heads/$branch"
    git -C "$repo_root" worktree add "$path" "$branch"
else
    git -C "$repo_root" worktree add -b "$branch" "$path"
end

if test "$wants_codegraph" = 1
    codegraph init "$path"
end
```

## Creating Worktrees / Common Mistakes

| Mistake | Fix |
| --- | --- |
| Using global worktree dir | Always use repo root `.worktrees/` |
| Missing timestamp | Always append `YYYYMMDD-HHMMSS` |
| Editing `.gitignore` by default | Use local `.git/info/exclude`; no commit needed |
| Running CodeGraph everywhere | Only when `.codegraph/` exists or user asks |
| Creating nested worktree | Detect linked worktree first |
| Committing ignore changes | Local exclude is untracked; never commit unless user explicitly asks to commit |

## Creating Worktrees / Stop Conditions

- Not in a git repo.
- Branch/task name missing and user has not supplied one.
- Cannot write local Git exclude.
- `git worktree add` fails.
- `codegraph` command missing when CodeGraph is required.
