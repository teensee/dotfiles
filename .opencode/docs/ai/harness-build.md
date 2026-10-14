# Harness-independent AI config build

Status: **plan, approved 2026-10-04, not implemented.** Canonical plan (supersedes the root-level
`harness-independent-build.md` draft until it is deleted). Read this before implementing or
reviewing the generator, and [pi.md](pi.md) for the pi half. The generator must target the OpenCode
v2 layout from the start — see [opencode-v2-migration.md](opencode-v2-migration.md).

## Idea

`opencode/` stays the **source of truth**. `scripts/ai-build` renders Claude Code and pi files from
it. Generated files are **committed**; `make ai-check` catches manual edits and divergence. Task
working files live in `.opencode/ai/work/<branch>/` in every harness.

```
                    ┌──────────────── ИСТОЧНИК (правится руками) ────────────────┐
                    │ shared/instructions-core.md   shared/git-deny.txt          │
                    │ opencode/agent/*.md           opencode/commands/*.md       │
                    │ opencode/skills/              opencode.jsonc (agent.model) │
                    └───────────────────────────┬────────────────────────────────┘
                                                │ scripts/ai-build
                     ┌──────────────────────────┼───────────────────────────┐
                     ▼                          ▼                           ▼
             opencode (как есть)        claude/agents/*.md            pi/agents/*.md
                                        claude/commands/*.md          pi/prompts/*.md
                                        (GENERATED)                   (GENERATED)
                                                                      pi/extensions/core.ts
                                                                      pi/extensions/git-guard.ts
```

## Recorded decisions

- Source of truth: `opencode/` (agent/command frontmatter + bodies), `shared/instructions-core.md`,
  `shared/git-deny.txt`, `opencode.jsonc` (agent models).
- Generated artifacts (claude/agents, claude/commands, pi/agents, pi/prompts) are committed.
- Unified task dir `.opencode/ai/work/<branch>/` for opencode, Claude Code, pi.
- pi: local package `pi/` + symlinked `~/.pi/agent/agents`; corporate `~/.pi/agent/` files
  (`AGENTS.md`, `APPEND_SYSTEM.md`, `mcp.json`, `settings.json`) are never touched or symlinked.
- pi runtime git guard is an extension (`git-guard.ts`), not settings — pi has no settings-level
  bash allow/deny.
- Descriptions stay RU (as in opencode sources); bodies are already EN.

## Generator corrections (vs the root draft)

Findings verified against the live configs; fold these into the implementation:

1. **Quote every YAML scalar.** Current `claude/agents/*.md` descriptions are invalid YAML —
   `yq --front-matter=extract '.' claude/agents/go-dev.md` fails with
   `mapping values are not allowed in this context` (`TRIGGER: ...` unquoted). Emit descriptions
   JSON-quoted (`jq -Rn --arg s "$desc" '$s'`) for Claude **and** pi.
2. **Agent rename map for Claude.** `explore` collides with Claude's built-in agent; the current
   file deliberately uses `name: explore-ru`. Generator needs
   `AGENT_RENAME_CLAUDE=( [explore]=explore-ru )` (file name stays `explore.md`).
3. **Explicit Claude model overrides.** The `tier()` heuristic (`*-pro|*glm-* -> opus`, else
   `sonnet`) would move `explore` and `test-writer` from `haiku` to `sonnet`. Add
   `CLAUDE_MODEL_OVERRIDES=( [explore]=haiku [test-writer]=haiku )`; keep the heuristic for the rest
   (it reproduces the current opus/sonnet split).
4. **pi children need context and guard explicitly.** pi-subagents custom agents start with a clean
   prompt: no project context, no skills catalog, and foreground children never load ambient
   extensions. Generated pi agents must include: `inheritProjectContext: true`,
   `inheritSkills: true`, `advertise: true`, and
   `extensions:<abs>/pi/extensions/core.ts, <abs>/pi/extensions/git-guard.ts` (absolute paths
   expanded by the generator). Verify in the phase-0 spike; alternative knobs are
   `subagents.defaultExtensions` (settings) or forcing background children.
5. **`pi install` accepts a local path** (`pi install /absolute/path/to/package` — added to settings
   without copying, `docs/packages.md`), so no symlink fallback for prompts/extensions is needed.
   The extensions API is confirmed: `before_agent_start` returns `{ systemPrompt }`; `tool_call`
   exposes `event.toolName`/`event.input` and blocks with `{ block: true, reason }`
   (`isToolCallEventType("bash", event)` for typing). Docs live in the pi-vesna app bundle:
   `~/.local/share/pi-vesna/app/node_modules/@earendil-works/pi-coding-agent/docs/extensions.md`.
6. **opencode ignores unknown frontmatter keys by routing them into `options`** (built-in
   customize-opencode skill). Do not smuggle harness metadata (`x-tier` etc.) into opencode files;
   keep harness mapping inside `ai-build` maps.

## Ai-build spec

`scripts/ai-build` (bash + `yq` + `jq`), `--check` renders into `mktemp -d` and `diff -ru`s against
the repo. Outputs: `claude/agents`, `claude/commands`, `pi/agents`, `pi/prompts`.

```bash
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC_AGENTS="$ROOT/opencode/agent"; SRC_CMDS="$ROOT/opencode/commands"
OC_CONF="$ROOT/opencode/opencode.jsonc"
OUT="$ROOT"; CHECK=0
[[ "${1:-}" == "--check" ]] && { CHECK=1; OUT="$(mktemp -d)"; }

RENAME_CMD=( [review-task]=review )
RENAME_AGENT_CLAUDE=( [explore]=explore-ru )
SKIP_CMDS=" yt-comm "
CLAUDE_MODEL_OVERRIDES=( [explore]=haiku [test-writer]=haiku )
PI_EXTRAS="inheritProjectContext: true
inheritSkills: true
advertise: true
extensions: $ROOT/pi/extensions/core.ts, $ROOT/pi/extensions/git-guard.ts"

body()   { awk 'c>=2{print;next} /^---$/{c++}' "$1"; }
fm()     { yq --front-matter=extract "$2" "$1"; }
oneline(){ tr '\n' ' ' | sed 's/  */ /g; s/ $//'; }
q()      { jq -Rn --arg s "$1" '$s'; }           # YAML-safe double-quoted scalar
marker() { echo "<!-- GENERATED by scripts/ai-build from ${1#$ROOT/} — do not edit -->"; }
model_of(){ yq -p json -o y ".agent.\"$1\".model // \"\"" <(sed 's#^\s*//.*##' "$OC_CONF"); }
tier()   { case "$(model_of "$1")" in *-pro|*glm-*) echo smart ;; *) echo fast ;; esac; }
# writes() -> writer vs reader; PI_EXTRAS added to every pi agent
```

Key behaviors:

- Descriptions: `oneline` then `q` (correction 1). Claude agent frontmatter: `name`, `description`,
  `tools` (`Read, Write, Edit, Bash, Grep, Glob` for writers, `Read, Bash, Grep, Glob` for readers),
  `model` (override -> tier -> opus/sonnet).
- pi agent frontmatter: `name`, `description`, `tools` (`read, grep, find, ls, bash` [+
  `edit, write`]) + `PI_EXTRAS`.
- Commands: `RENAME_CMD`, `SKIP_CMDS`; body copied verbatim, then for Claude/pi append
  `Делегируй это агенту \`<agent>\`.`when the source has`agent:`(opencode runs the command inside the agent via`agent:`+`subtask:`;
  Claude/pi run in the main session).
- `--check` also: `diff -r` per generated dir (catches manual edits and files deleted from the
  source but left in output), and compares `claude/settings.json` `permissions.deny` git entries
  with `shared/git-deny.txt` (`Bash(git <verb>:*)` mapping). Optionally assert `opencode.jsonc`
  still contains `"git *": "deny"`.

### Rendered examples (`go-dev`)

```markdown
# claude/agents/go-dev.md

---

name: go-dev description: "Go разработчик. TRIGGER: файлы *.go, go.mod; ... SKIP: PHP, SQL без
Go-контекста, DevOps." tools: Read, Write, Edit, Bash, Grep, Glob model: sonnet
---

<!-- GENERATED by scripts/ai-build from opencode/agent/go-dev.md — do not edit -->

You are a senior Go developer. ...
```

```markdown
# pi/agents/go-dev.md

---

name: go-dev description: "Go разработчик. TRIGGER: ..." tools: read, grep, find, ls, bash, edit,
write inheritProjectContext: true inheritSkills: true advertise: true extensions:
/Users/vladislav/.dotfiles/pi/extensions/core.ts,
/Users/vladislav/.dotfiles/pi/extensions/git-guard.ts
---

<!-- GENERATED ... -->

You are a senior Go developer. ...
```

## Task workflow: one directory for all harnesses

New block in `shared/instructions-core.md` (moves out of the two residual files):

```markdown
## Task workflow

Пайплайн: `/task → /res → /plan → /go → /review → /clean`.

Рабочие файлы задачи лежат в `.opencode/ai/work/<текущий-бранч>/` — одинаково в opencode, Claude
Code и pi:

- `task.md` — описание задачи (`/task`)
- `task-research.md` — ресёрч (`/res`, агент `research`)
- `task-plan.md` — план (`/plan`, агент `architect`)
- `task-log.md` — лог реализации (`/go`)

Бранч: `git branch --show-current`, если пусто — `git rev-parse --abbrev-ref HEAD`. `.opencode/` в
проектах игнорируется — рабочие файлы не коммитятся.
```

Consequences:

- `opencode/commands/*.md` stop repeating branch detection and the old `.opencode/work/<branch>/`
  path; they reference «см. «Task workflow»» and the new path. Same for agent prompts and
  `edit_allow` patterns (`.opencode/work/**/task-plan.md` -> `.opencode/ai/work/**/task-plan.md`).
- `claude/CLAUDE.md` drops its Task workflow block; `opencode/instructions.md` is emptied, deleted,
  and removed from `opencode.jsonc`'s `instructions` array (core alone covers both).
- `.opencode/.gitignore` gains `ai/`; root `.gitignore`'s `.opencode/work/` entry is replaced by
  `.opencode/ai/work/` (repo-local; work projects already ignore `.opencode/` wholesale).

## `shared/git-deny.txt`

One verb list (no `Bash(...)` wrapper):
`add commit push pull fetch checkout switch merge rebase reset restore "stash pop" "stash drop" clean rm`.
Consumers: `pi/extensions/git-guard.ts` (runtime), `ai-build --check` (Claude deny parity). opencode
already denies `"git *"` and allow-lists read verbs in `opencode.jsonc`.

## pi

Full design in [pi.md](pi.md). Summary: tracked `pi/` package (`package.json` with
`pi.extensions`/`pi.prompts`/`pi.skills`, `extensions/core.ts`, `extensions/git-guard.ts`, generated
`agents/` + `prompts/`, `skills -> ../opencode/skills`); dotbot symlinks only
`~/.pi/agent/agents -> pi/agents`; user runs `pi install ~/.dotfiles/pi` once (registers the local
package in `~/.pi/agent/settings.json`); corporate pi files stay untouched.

## Make, dotbot, `_lib.sh`

```make
ai:        ## Сгенерировать claude/ и pi/ из opencode/
	@scripts/ai-build

ai-check:  ## Проверить, что генерат совпадает с источником
	@scripts/ai-build --check

check: ai-check   # + существующая проверка симлинков
```

- `install.conf.yaml`: add `~/.pi/agent/agents: pi/agents` (generated files are committed, so
  `./install` needs no build step).
- `scripts/_lib.sh` `TARGETS` += `.pi/agent/agents`.
- No `.gitignore` entries for generated dirs (they are committed).

## Work sequence

| #   | Step                                                                                        | Touch                                                                                     | Verify                                                                |
| --- | ------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| 1   | `make backup`                                                                               | —                                                                                         | `~/.dotfiles-backup-*` appears                                        |
| 2   | Unified task dir                                                                            | `opencode/commands/*`, `shared/instructions-core.md`, residuals, `edit_allow`, gitignores | `rg '\.opencode/work/'` -> only maybe CHANGELOG/docs mentions updated |
| 3   | Harness-neutral command bodies                                                              | `opencode/commands/*`                                                                     | text reads the same in any harness                                    |
| 4   | `shared/git-deny.txt`                                                                       | new                                                                                       | —                                                                     |
| 5   | Generator                                                                                   | `scripts/ai-build`                                                                        | `scripts/ai-build --check` after first run                            |
| 6   | First generation (Claude copies become EN bodies, quoted YAML, explore-ru, haiku overrides) | `claude/agents/*`, `claude/commands/*`                                                    | `git diff --stat claude/`                                             |
| 7   | pi package (`core.ts`, `git-guard.ts`, manifest)                                            | `pi/`                                                                                     | manual pi checks, see pi.md                                           |
| 8   | Make / dotbot / `_lib.sh`                                                                   | `Makefile`, `install.conf.yaml`, `scripts/_lib.sh`                                        | `make check`                                                          |
| 9   | Manual user steps                                                                           | `./install`, `pi install ~/.dotfiles/pi`, codegraph MCP                                   | pi.md §Manual steps                                                   |
| 10  | Docs                                                                                        | `.opencode/docs/ai/*`, `AGENTS.md`, `docs/`                                               | review                                                                |
| 11  | Commits (user)                                                                              | —                                                                                         | message drafts below                                                  |

## Verification end-to-end

1. `make ai-check` exits 0; append a line to `claude/agents/dba.md` -> check fails with diff;
   revert.
2. Remove `commit` from `claude/settings.json` deny -> `ai-check` reports mismatch with
   `git-deny.txt`.
3. **Claude Code**: `/agents` lists 14; `/plan` in a test repo delegates `architect` and writes
   `.opencode/ai/work/<branch>/task-plan.md`.
4. **opencode**: same `/plan` scenario, same path.
5. **pi**: git rules answered from core; `git commit` tool call blocked by git-guard with reason;
   `/plan` present in prompts; `subagent` sees `go-dev`/`architect`; corporate onboarding from
   `AGENTS.md` still in context.
6. `make check`: all symlinks green including `~/.pi/agent/agents`.

## Risks / open points

- **Tier heuristic is approximate.** Overrides keep today's routing; if more precision is needed
  later, add a mapping table to `ai-build` (not to opencode frontmatter — unknown keys land in
  `options`).
- **pi bootstrap may overwrite `~/.pi/agent/settings.json`** and drop the local package entry;
  recovery is re-running `pi install ~/.dotfiles/pi` — documented in pi.md.
- **pi child-extension strategy** (per-agent `extensions` vs `subagents.defaultExtensions`) is
  phase-0 spike material; per-agent keeps it in tracked generated files, but disables ambient
  extensions (pi-mcp-adapter) inside children.
- **`yt-comm` is opencode-only in v1** (opencode-specific YouTrack MCP flow); pi has YouTrack in its
  corporate `mcp.json`, so it can be enabled later.
- **Generated files committed** means every source edit needs `make ai` + the diff is part of the
  commit; `ai-check` in `make check` is the guard.
- **pi document paths**: extensions API/docs live in the pi-vesna bundle
  (`~/.local/share/pi-vesna/app/node_modules/...`), not in `~/.pi/agent/npm` as the root draft said.

## Docs impact when implemented

- `instructions.md`: replace "Agents and commands are not unified this way" with the generator rule
  («правишь только `opencode/`»), note the unified task dir.
- `claude-code.md`: mark `claude/agents`/`claude/commands` as GENERATED.
- `pi.md` (this plan -> reference): package, extensions, manual steps, drift.
- `workflow.md`, `architecture.md`: `.opencode/ai/work/<branch>/`, `pi/`, `make ai`.
- `AGENTS.md`: Commands table (`make ai`, `make ai-check`), topic links.
- `readme.md` / `docs/opencode.md`: pi in "What's included", task dir.

Suggested commits (user runs them):

```
refactor(opencode): unify task work dir to .opencode/ai/work/<branch>
feat(scripts): add ai-build generator for claude and pi configs
refactor(claude): generate agents and commands from opencode sources
feat(pi): add dotfiles pi package with core instructions and git guard
docs(ai): document harness-independent build and pi setup
```
