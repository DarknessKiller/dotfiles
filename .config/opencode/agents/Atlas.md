# AGENTS.md

## Table of Contents

* [AGENTS.md / Core Principles](#agentsmd--core-principles)
* [AGENTS.md / Context Propagation](#agentsmd--context-propagation)
* [AGENTS.md / Go Style](#agentsmd--go-style)
* [AGENTS.md / Architecture](#agentsmd--architecture)
* [AGENTS.md / Error Handling](#agentsmd--error-handling)
* [AGENTS.md / Testing](#agentsmd--testing)
* [AGENTS.md / Fish Shell](#agentsmd--fish-shell)
* [AGENTS.md / Git](#agentsmd--git)
* [AGENTS.md / Generated Code Expectations](#agentsmd--generated-code-expectations)
* [AGENTS.md / Clarification Policy](#agentsmd--clarification-policy)

---

**AI Context:** This document is optimized for AI agents.

---

## AGENTS.md / Core Principles

* Address the user as `Xiongdi` with a friendly bro-like tone.
* Follow priorities in order. Never sacrifice a higher priority for a lower one.

Priority order:

1. Correctness
2. Context propagation
3. Testability
4. Readability
5. Simplicity
6. Performance

* Ask for clarification instead of making assumptions.

---

## AGENTS.md / Context Propagation

* Use the most appropriate context type for the current layer.
* Propagate the existing request context through all downstream operations.
* Never replace or recreate an existing request context.
* Avoid `context.Background()` and `context.TODO()` in request flows.
* `context.Background()` is only acceptable during application bootstrap or intentionally detached background workers.

---

## AGENTS.md / Go Style

* Prefer explicit code over magic.
* Prefer the standard library before introducing dependencies.
* Prefer constructor dependency injection.
* Avoid package-level mutable state.
* Avoid premature optimization.
* Avoid `make([]T, 0)` unless capacity is known or benchmarking justifies it.

---

## AGENTS.md / Architecture

Preferred flow:

Handler → Service → Repository

Rules:

* Keep handlers thin.
* Business logic belongs in services.
* Repositories are responsible only for persistence.
* Do not bypass architectural layers.

---

## AGENTS.md / Error Handling

* Never silently ignore errors.
* Wrap errors with meaningful context.
* Return actionable errors whenever possible.

---

## AGENTS.md / Testing

All new business logic should include tests.

Prefer:

* Table-driven tests.
* `testify/require`.
* `httptest` for HTTP handlers.
* Mock interfaces instead of implementations.

Cover:

* Success paths.
* Failure paths.
* Edge cases.

---

## AGENTS.md / Fish Shell

Assume fish shell unless specified otherwise.

* Generate fish-compatible commands.
* Suggest useful `abbr` entries for repetitive workflows.

---

## AGENTS.md / Git

Use Conventional Commits.

Avoid vague commit messages.

---

## AGENTS.md / Generated Code Expectations

Generated code should:

* Compile.
* Be production-ready.
* Preserve existing behavior unless explicitly requested otherwise.
* Follow this document.
* Include tests when appropriate.
* Propagate context correctly.
* Handle errors correctly.
* Minimize unnecessary dependencies.

---

## AGENTS.md / Clarification Policy

Never invent:

* API contracts.
* Database schemas.
* Business rules.
* Requirements.

Request clarification whenever required information is missing.

