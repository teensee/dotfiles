---
description: Audit and build the AI guide library shared by Claude Code and opencode
agent: build
model: opencode-go/deepseek-v4-pro
---

Audit and build the project's AI guide library — one source shared by Claude Code and opencode.

Mode: $ARGUMENTS (`audit` | `build` | `refresh`; default `audit`). An optional second argument overrides the guides
directory (default `.opencode/docs/ai/`).

## Principles

- Single source of truth: plain markdown in `<guides-dir>`. Inside guides: no `@`-imports, no frontmatter-driven
  loading, no mandatory calls to tools of one specific agent.
- Root `AGENTS.md` is the shared entry point: hard rules as plain text (≤30 lines) + routing table
  "path glob → guides" + recipes table.
- Adapters carry no content of their own:
  - `CLAUDE.md` = `@AGENTS.md`;
  - `.claude/rules/<topic>.md` = `paths:` frontmatter + `@<guide>` lines;
  - `.claude/commands/<recipe>.md` and `.opencode/command/<recipe>.md` = "Follow `<recipe>`. Task: $ARGUMENTS".
- Every statement in a guide is verified against the code. Point to reference files instead of describing patterns
  abstractly. Knowledge that cannot be derived from code is marked `TODO(human)`.
- Git is read-only. Delete nothing without explicit confirmation. Whether the library is committed or kept local
  is the user's decision.

## 1. Audit (always)

1. Find existing guides: `AGENTS.md`, `CLAUDE.md`, `.opencode/docs/`, `docs/`, `.claude/rules/`, `.cursor/rules/`.
   Count lines.
2. Check git visibility: `git check-ignore -v` for each file (repo `.gitignore`, `.git/info/exclude`, global gitignore).
3. Find hot zones: directories ranked by change frequency over the last ~300 commits (`git log --stat`).
4. Verify every guide against the code (codegraph → rg): do the paths exist? Do the described patterns match how
   **most** of the code does it? Count the variants — never take the first example as the reference.
5. Find gaps: hot zones without a guide; legacy code an agent could copy as a pattern.

Output a report: discrepancies (`file:line` → actual fact in code), gaps, proposed structure.
In `audit` mode stop here.

## 2. Agreement (`build` / `refresh`)

Write the plan: target structure, examples of the new `AGENTS.md`, one adapter, one recipe, list of deletions.
**Stop and wait for explicit confirmation.**

In `refresh` mode limit the plan to discrepancies, broken links and new hot zones — do not restructure.

## 3. Build

1. Move or fix guides in `<guides-dir>`. Write new guides only from verified facts.
2. Mandatory files:
   - `README.md` — index + maintenance rules;
   - `legacy.md` — "do not copy" table: legacy pattern → where → follow instead;
   - `glossary.md` — business meaning of domain contexts, skeleton with `TODO(human)`.
3. Rewrite `AGENTS.md` (hard rules + routing + recipes); keep everything else that was there.
4. Create `.claude/rules/*` adapters and command wrappers for both tools.
5. Delete old files only after an explicit "yes".

## 4. Verification

- Every markdown link and `@`-import points to an existing file.
- Every code path in backticks exists (templates with `<...>` / `{...}` excluded).
- No references to the old location remain.
- `git status` shows exactly what is expected to be visible or hidden.

## 5. Report

What changed, which discrepancies were fixed, the `TODO(human)` list, what was not deleted, and how to check loading:
Claude Code — `/memory` after opening a file matching a glob; opencode — ask "which guides will you read when
editing X?" and compare with the routing table.
