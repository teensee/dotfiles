# pi integration

Status: **plan, part of [harness-build.md](harness-build.md), not implemented.** Once done, this
file becomes the reference for the pi side of the dotfiles config.

## What pi is here

- pi v0.85, installed through the corporate `pi-vesna` bundle (`~/.local/bin/pi` ->
  `~/.local/share/pi-vesna/app/.../cli.js`).
- Global config: `~/.pi/agent/` — corporate `AGENTS.md`, `APPEND_SYSTEM.md`, `settings.json`
  (`packages`, `defaultProjectTrust`, `theme`), `mcp.json`, `models.json`, sessions. **These are
  never touched, symlinked, or tracked** — the bootstrap rewrites them (`.bak.20260916-*` in the dir
  prove it).
- Subagents come from the installed `pi-subagents` package; user agents load from
  `~/.pi/agent/agents/**/*.md`.
- Documented facts confirmed against the bundle docs
  (`~/.local/share/pi-vesna/app/node_modules/@earendil-works/pi-coding-agent/docs/`):
  - `pi install /absolute/path` registers a **local package** in settings without copying
    (`packages.md`); `package.json` `pi` key declares `extensions`/`prompts`/`skills` (conventional
    `extensions/`, `prompts/`, `skills/` dirs also auto-load);
  - prompt templates: `$ARGUMENTS`/`$@`, `description`, `argument-hint`; discovery is non-recursive
    per `prompts/` dir (`prompt-templates.md`);
  - `tool_call` blocks via `{ block: true, reason }`, fields `event.toolName`/`event.input`, typed
    via `isToolCallEventType("bash", event)`; `before_agent_start` returns `{ systemPrompt }`
    (`extensions.md`);
  - custom subagents do **not** inherit project context/skills, and foreground children never load
    ambient extensions (`pi-subagents/docs/agents.md`) — hence the per-agent fields below.

## Tracked layout

```
pi/
├── package.json            # local package manifest (pi key)
├── extensions/
│   ├── core.ts             # opencode/AGENTS.md -> system prompt
│   └── git-guard.ts        # blocks git write verbs from shared/git-deny.txt
├── agents/                 # GENERATED (dotbot: ~/.pi/agent/agents -> pi/agents)
├── prompts/                # GENERATED (loaded via the package)
└── skills -> ../opencode/skills
```

`package.json`:

```json
{
  "name": "dotfiles-pi",
  "private": true,
  "pi": {
    "extensions": ["./extensions"],
    "prompts": ["./prompts"],
    "skills": ["./skills"]
  }
}
```

`pi/skills` is a symlink to the single skill source; the manifest lists the symlinked root directly
(pi docs require that when a glob would continue through a symlink).

## Extensions

`extensions/core.ts` — appends the shared rules to every turn's system prompt; re-read on each
`before_agent_start`, so core edits apply without `/reload`:

```ts
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

const CORE = join(homedir(), ".dotfiles/opencode/AGENTS.md");

export default function (pi: ExtensionAPI) {
  pi.on("before_agent_start", async (event) => {
    return { systemPrompt: `${event.systemPrompt}\n\n${readFileSync(CORE, "utf8")}` };
  });
}
```

`extensions/git-guard.ts` — runtime enforcement of `shared/git-deny.txt` (pi has no settings-level
bash allow/deny). Blocks `git commit`, `git -C dir push`, chained `foo && git reset`, etc.:

```ts
import { isToolCallEventType, type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

const deny = readFileSync(join(homedir(), ".dotfiles/shared/git-deny.txt"), "utf8")
  .split("\n")
  .map((s) => s.trim())
  .filter(Boolean);

const esc = (s: string) => s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&").replace(/ /g, "\\s+");
const re = new RegExp(
  String.raw`(^|[;&|(\s])git(\s+-\S+(\s+\S+)?)*\s+(${deny.map(esc).join("|")})\b`,
);

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event) => {
    if (!isToolCallEventType("bash", event)) return;
    if (re.test(event.input.command)) {
      return {
        block: true,
        reason: "git — read-only (shared/git-deny.txt). Предложи команду пользователю.",
      };
    }
  });
}
```

Guard limits to accept: it is a regex over the command line — `sudo git`, `env git`, shell aliases,
and `git` hidden inside `$(...)` are not covered. It complements, not replaces, the prompt rule from
core.

## Generated pi agents

Rendered by `ai-build` from `opencode/agents/*.md` (see harness-build.md), with extra frontmatter
that pi needs and opencode/Claude do not have:

```yaml
name: go-dev
description: "..."
tools: read, grep, find, ls, bash, edit, write
inheritProjectContext: true
inheritSkills: true
advertise: true
extensions:
  /Users/vladislav/.dotfiles/pi/extensions/core.ts,
  /Users/vladislav/.dotfiles/pi/extensions/git-guard.ts
```

- `inheritProjectContext` — без него субагент не видит проектные `AGENTS.md`/`CLAUDE.md`.
- `inheritSkills` + `advertise` — каталог скиллов и видимость агента родителю.
- `extensions` — foreground-дети не грузят ambient extensions, поэтому core/guard перечислены явно.
  Побочный эффект: у такого ребёнка отключаются прочие ambient-расширения (например,
  `pi-mcp-adapter`), MCP-инструменты в pi-субагентах недоступны. Альтернатива на этап spike —
  `subagents.defaultExtensions` в settings или запуск детей в background.

## Manual steps (agent does not run these)

```sh
./install                       # dotbot: ~/.pi/agent/agents -> pi/agents
pi install ~/.dotfiles/pi       # local package -> ~/.pi/agent/settings.json
```

- codegraph for pi is added by hand to the untracked `~/.pi/agent/mcp.json`
  (`"codegraph": { "command": "codegraph", "args": ["serve", "--mcp"] }`).
- Corporate prompt templates in `~/.pi/agent/prompts/` keep loading; dotfiles prompts come from the
  package and do not replace the directory.

## Drift & recovery

- pi-vesna bootstrap may rewrite `~/.pi/agent/settings.json` and drop the local package entry:
  re-run `pi install ~/.dotfiles/pi`. If it rewrites `~/.pi/agent/agents` as a plain dir,
  `make check` flags it (like `.claude/*`); delete the plain dir and re-run `./install`.
- `make ai-check` catches divergence between generated `pi/agents`/`pi/prompts` and the opencode
  sources.

## Verification

1. `make check` — `~/.pi/agent/agents` symlink green.
2. New pi session: «Какие правила для git?» — отвечает по core; корпоративный онбординг из
   `~/.pi/agent/AGENTS.md` по-прежнему в контексте.
3. «Сделай `git commit -m x`» — tool call заблокирован с reason из git-guard; `git status` проходит.
4. `/plan` есть в списке prompts, пишет в `.opencode/ai/work/<branch>/task-plan.md`.
5. `subagent({ action: "list" })` видит `go-dev`, `architect`, ...; read-only агент не может
   редактировать.

## Open points

- Child-extension strategy (above) — validate in the phase-0 spike.
- `yt-comm` stays opencode-only for now; pi has YouTrack in corporate `mcp.json`, so it can be
  enabled later.
- Package agents via `pi.subagents.agents` manifest (no dotbot symlink) is a possible later
  simplification; current plan keeps the explicit symlink.
