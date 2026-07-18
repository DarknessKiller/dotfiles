# Atlas.md

## Table of Contents

* [Atlas.md / Core Principles](#agentsmd--core-principles)
* [Atlas.md / Context Propagation](#agentsmd--context-propagation)
* [Atlas.md / Go Style](#agentsmd--go-style)
* [Atlas.md / Architecture](#agentsmd--architecture)
* [Atlas.md / Error Handling](#agentsmd--error-handling)
* [Atlas.md / Testing](#agentsmd--testing)
* [Atlas.md / Fish Shell](#agentsmd--fish-shell)
* [Atlas.md / Git](#agentsmd--git)
* [Atlas.md / Generated Code Expectations](#agentsmd--generated-code-expectations)
* [Atlas.md / Clarification Policy](#agentsmd--clarification-policy)

---

**AI Context:** This document is optimized for AI agents.

---

## Atlas.md / Core Principles

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

## Atlas.md / Context Propagation

* Use the most appropriate context type for the current layer.
* Propagate the existing request context through all downstream operations.
* Never replace or recreate an existing request context.
* Avoid `context.Background()` and `context.TODO()` in request flows.
* `context.Background()` is only acceptable during application bootstrap or intentionally detached background workers.

---

## Atlas.md / Go Style

* Prefer explicit code over magic.
* Prefer the standard library before introducing dependencies.
* Prefer constructor dependency injection.
* Avoid package-level mutable state.
* Avoid premature optimization.
* Avoid `make([]T, 0)` unless capacity is known or benchmarking justifies it.

---

## Atlas.md / Architecture

Preferred flow:

Handler → Service → Repository

Rules:

* Keep handlers thin.
* Business logic belongs in services.
* Repositories are responsible only for persistence.
* Do not bypass architectural layers.

---

## Atlas.md / Error Handling

* Never silently ignore errors.
* Wrap errors with meaningful context.
* Return actionable errors whenever possible.

---

## Atlas.md / Testing

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

## Atlas.md / Fish Shell

Assume fish shell unless specified otherwise.

* Generate fish-compatible commands.
* Suggest useful `abbr` entries for repetitive workflows.

---

## Atlas.md / Git

Use Conventional Commits.

Avoid vague commit messages.

---

## Atlas.md / Generated Code Expectations

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

## Atlas.md / Clarification Policy

Never invent:

* API contracts.
* Database schemas.
* Business rules.
* Requirements.

Request clarification whenever required information is missing.

