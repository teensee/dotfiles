---
description: Refactor AGENTS.md into progressive-disclosure topic files
agent: build
subtask: true
model: opencode-go/deepseek-v4-flash
---

Refactor this project's root AGENTS.md to follow progressive disclosure: the root
file holds only what's relevant to _every_ task, and everything else moves into
topic files loaded on demand.

Work in this order and pause where noted.

1. Contradictions first. List any instructions that conflict. For each, show both
   versions and ask me which to keep — then wait for my answers before continuing.

2. Keep in root only the essentials:
   - One-sentence project description
   - Dependency/package manager and any non-default way to invoke it
   - Build / test / lint / static-analysis commands an agent couldn't guess from
     the repo
   - Hard rules that apply to every change
     Aim to keep the root readable at a glance (rough target: <50 lines).

3. Group everything else into topic files by area (adapt categories to my stack —
   framework/domain conventions, testing, data layer, git workflow, deployment).
   One file per coherent area.

4. Output the result. Put all topic files under `.opencode/docs/ai/`; the root
   AGENTS.md stays at the repo root and links into that directory.
   - The `.opencode/docs/ai/` layout (filenames you'd create)
   - The minimal root AGENTS.md, linking to each topic file with a one-line
     "read this when…" hint per link
   - The full contents of each topic file
     Preserve command strings, paths, and rules verbatim.

5. Flag for deletion (list them, let me confirm — don't delete silently) anything
   redundant with what a competent agent knows, too vague to act on, or generic
   filler ("write clean code", "follow best practices").

Constraints: only reorganize what's already in the file — don't invent conventions
I didn't state. Stay tool-agnostic about my code stack; infer it from the file.

Current AGENTS.md:
@AGENTS.md
