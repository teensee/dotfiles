# OpenCode v2 migration

Status: **plan, approved 2026-10-14, not implemented.** Read this before migrating the opencode half
of the repo to OpenCode 2. Companion plan: [harness-build.md](harness-build.md) — its generator must
target the v2 layout from the start, do not migrate to v2 and to the generator separately.

## Decisions

- **Migrate immediately** — no long side-by-side period. v1.19 can run `opencode upgrade --major`;
  both versions use the `opencode` command and cannot be installed side by side under one name.
- **GitKraken hooks plugin stays off** — `opencode/plugins/gk-hooks.js` uses the v1 API and does not
  run in v2 (implementations must be ported). Keep it disabled until GitKraken ships a v2 version or
  we port it ourselves.
- **`opencode/AGENTS.md` becomes the single source of the global rules** — not a generated assembly.
  Claude Code `@`-imports it, pi reads it (see [pi.md](pi.md)); `shared/instructions-core.md` ceases
  to exist.
- **Scope**: the global config in this repo plus its docs. Project-level `opencode.jsonc` files
  (e.g. postgres MCP enablement) migrate separately, as projects are visited.
- Prerequisite: commit all pending work first.

## Breaking changes that touch this repo

| v1 | v2 |
| --- | --- |
| `instructions: [...]` resolved | **not resolved**; use `AGENTS.md` |
| `permission.bash` map | `permissions: [{action, resource, effect}]`, ordered, last match wins |
| actions `bash` / `task` | actions `shell` / `subagent`; new `external_directory` |
| `agent/` (singular) dir | `agents/` dir |
| agent frontmatter `permission` map, `tools`, `temperature` | `permissions` list; legacy keys not to use |
| `provider` | `providers`; `npm` -> `package`; `options` -> `settings` (+ `env` for credentials) |
| `mcp.<name>`, `enabled` | `mcp.servers.<name>`, `disabled` (inverted) |
| v1 plugin API (`server()` object) | v2 API (`Plugin.define` + `setup(ctx)`); full port required |
| `tui.jsonc` | `cli.json` (`https://opencode.ai/v2/cli.json`) |
| `~/.config/opencode/skills` | unchanged (v2 also reads `~/.claude/skills` natively) |

Reference docs: permissions, agents, providers, mcp-servers, skills, cli/config, and
`build/plugins/migrate-v1` under <https://opencode.ai/v2/docs/>.

## Stages

### 1. `opencode/AGENTS.md` as the single source

1. Create `opencode/AGENTS.md` (= `~/.config/opencode/AGENTS.md` through the whole-directory
   symlink): core text from `shared/instructions-core.md` plus the opencode residual from
   `opencode/instructions.md` (task workflow, pipeline), worded harness-neutral — Claude Code and pi
   read the same file.
2. `claude/CLAUDE.md`: `@`-import `opencode/AGENTS.md` instead of `shared/instructions-core.md`;
   keep only Claude-specific blocks.
3. Delete `shared/instructions-core.md` and `opencode/instructions.md`.
4. `opencode.jsonc`: drop the `instructions` array (ignored in v2).
5. **Open point** — task workflow: Claude writes task files to the project root, opencode to
   `.opencode/work/<branch>/`. One file for both harnesses forces one convention. Recommended: unify
   on `.opencode/work/<branch>/` now; [harness-build.md](harness-build.md) later moves it to
   `.opencode/ai/work/<branch>/`. Alternative: keep AGENTS.md core-only and leave the workflow to the
   command files.

### 2. `opencode/opencode.jsonc`

- Check every key against the v2 schema (`https://opencode.ai/config.json`).
- `permission.bash` -> `permissions` (action `shell`, order matters, last match wins):
  base `ask` -> read-only allowlist -> git read-only allows -> `git *` deny **last**; the shell
  pattern `git status *` also matches `git status` without arguments.
- Replace the `find /*`, `fd * /*`, `rg * /*` guards with `external_directory` rules (plus `read` /
  `edit` rules where needed).
- `provider.vesna` -> `providers.vesna`: `package: "@opencode/ai/providers/openai-compatible"`,
  `env: ["VESNA_API_KEY"]`, `settings.baseURL`; the `queryParams` (`tool_call_parser`) mapping is
  undocumented — verify empirically.
- `mcp` -> `mcp.servers`: codegraph with `codemode: false` to keep the `codegraph_explore` tool names
  used in the core instructions (or keep Code Mode and update the instruction texts); postgres
  `disabled: true`.
- `agent` -> `agents`: move the 14 model overrides; verify the current `opencode-go/*` model IDs in
  the v2 catalog.

### 3. Agents `opencode/agent/` -> `opencode/agents/`

- `git mv` the directory (dotbot links `~/.config/opencode` as a whole — no `install.conf.yaml`
  change).
- All 14 files: `permission:` map -> `permissions:` list; keep `mode: subagent`; remove legacy keys.
- Prompt texts: "Task tool" -> the subagent tool; re-check MCP tool mentions. The custom `explore`
  agent now shadows a v2 built-in of the same name — decide whether to keep the override.

### 4. Commands

- `subtask: true` -> `subagent: true` across `opencode/commands/*.md` (check all 10).
- Verify `agent:` / `model:`; `yt-comm` — YouTrack MCP naming under v2.

### 5. Plugin, package.json, TUI

- Remove `opencode/plugins/gk-hooks.js` from autoload (v2 discovers `plugins/` automatically);
  document that GitKraken hooks are temporarily off.
- Drop `@opencode-ai/plugin` and `@ai-sdk/openai-compatible` from `opencode/package.json`; decide on
  `node_modules` / the lockfile.
- Remove the empty `opencode/plugin/` directory.
- `tui.jsonc` -> `cli.json`: `mouse: false` plus keybinds with v2 command IDs.

### 6. Infra and docs

- `brew/Brewfile`: `anomalyco/tap/opencode` -> `anomalyco/tap/opencode-v2` (for new machines;
  locally `opencode upgrade --major`).
- `install.conf.yaml`, `scripts/_lib.sh`, `make check`: no structural change expected — verify.
- Update root `AGENTS.md`; `.opencode/docs/ai/{instructions,claude-code,workflow,harness-build,pi}.md`
  (rewrite the ai-build spec for the v2 layout: `agents/`, `permissions`, AGENTS.md source);
  `docs/opencode.md`.

### 7. Verification

1. `make backup` before stage 1; `make check` after.
2. v2 smoke: 14 agents listed; `git status` -> allow, `git commit` -> deny, external directory ->
   ask; the vesna provider responds; codegraph MCP connects; postgres disabled; commands and skills
   present.
3. Run `/task -> /res -> /plan -> /go` in a test project.
4. Docs sync per the repo's MANDATORY rule.

## Risks

- v2 shell scanner semantics for permission patterns.
- vesna `queryParams` mapping.
- `opencode-go/*` model IDs in the v2 catalog.
- MCP Code Mode renaming tools (codegraph, postgres references in the core instructions).
- GitKraken hooks absent in opencode until ported or updated (accepted).

## Suggested commits (user runs)

```
refactor(opencode): migrate config, agents and commands to OpenCode v2
refactor(ai): make opencode/AGENTS.md the single source of global rules
chore(brew): switch opencode tap to opencode-v2
docs(ai): update docs for the OpenCode v2 migration
```
