# Linting

`make lint` runs five targets; each can be run on its own. Responsibility is split three ways:

- `Makefile` — target names only, each one calls a script
- `scripts/lint/*.sh` — **how** to run a linter (tool check, invocation, logging)
- the linter's own config — **what** it covers

Because scoping lives in the configs, running `markdownlint .`, `prettier --check .`, `biome lint .`
or `stylua --check .` straight from the shell (or from the editor) gives exactly the same result as
`make`. Every script also runs directly and from any cwd — it `cd`s to `$DOTFILES_DIR` itself.

| Target      | Script                 | Tools                              | Scope defined by                         |
| ----------- | ---------------------- | ---------------------------------- | ---------------------------------------- |
| `lint`      | `scripts/lint/all.sh`  | all of the below                   | —                                        |
| `lint-sh`   | `scripts/lint/sh.sh`   | `shellcheck`, `shfmt -d`           | `git ls-files` (see below)               |
| `lint-md`   | `scripts/lint/md.sh`   | `markdownlint`, `prettier --check` | `.markdownlintignore`, `.prettierignore` |
| `lint-json` | `scripts/lint/json.sh` | `biome lint`                       | `biome.json` (`files.includes`)          |
| `lint-lua`  | `scripts/lint/lua.sh`  | `stylua --check`                   | `.styluaignore`                          |
| `lint-yaml` | `scripts/lint/yaml.sh` | `prettier --check`                 | `.prettierignore`                        |
| `lint-deps` | `scripts/lint/deps.sh` | —                                  | —                                        |

`scripts/lint/_common.sh` holds `require_tools` (each script checks only the tools it needs, so
`make lint-sh` works without prettier installed) and `LINT_TOOLS` for `deps.sh`. `all.sh` does not
stop at the first failure: it runs all five and prints the list of failed ones at the end.

`shellcheck` and `shfmt` are the exception to config-defined scope: they do not walk the tree and
have no ignore-file mechanism at all (`shellcheck` only takes `--exclude=CODE`, `shfmt` has no
config). `_common.sh:lint_shell_files` gives them an explicit `git ls-files '*.sh' install` list —
that is file _selection_, not an exclusion rule, and nothing is filtered out of it.

Scripts target bash 3.2 (the system bash on macOS), so no `mapfile` — `sh.sh` fills its array with a
`while read` loop.

## Ownership

One tool owns each file type; no two linters touch the same file:

- `shellcheck` + `shfmt` — `*.sh` and `./install` (extensionless, has a shebang)
- `markdownlint` + `prettier` — `*.md`
- `prettier` — `*.yaml`, `*.yml`
- `biome` — `*.json`, `*.jsonc`, `*.js`. Parsing catches invalid JSON, so no separate `jq` pass.
  `biome lint`, not `biome check`: `check` would enforce biome's own formatting and rewrite
  `zed/settings.json` (tabs, no trailing commas) against the intended style
- `stylua` — `*.lua`, against `nvim/.stylua.toml`, which stylua finds by the checked file's
  directory (no `--config-path` needed; the same config nvim's conform uses)

`.prettierignore` lists `*.json`/`*.jsonc`/`*.js`/`*.ts`/`*.html` for that reason: prettier would
strip the deliberate trailing commas from `zed/settings.json`, in the editor as well as in lint.

## Configs

- `.markdownlint.jsonc` — rule tuning (below)
- `.markdownlintignore` — vendored skills, submodule, `node_modules/`, task-pipeline scratch files
  (markdownlint does not read `.gitignore`)
- `.prettierignore` — vendored skills, submodule, the types biome owns, `.opencode/mcp/`
- `.prettierrc.json` — `*.md`: `proseWrap: always`, `printWidth: 100`; also read by the editors
- `biome.json` — `files.includes` excludes vendored skills, submodule and `node_modules`;
  `vcs.useIgnoreFile` must be set explicitly (biome ignores `.gitignore` by default);
  `allowTrailingCommas` override for `zed/settings.json` (see commit `ee34984`); `$schema` points at
  `latest` so brew upgrades don't desync it
- `.shellcheckrc` — `external-sources=true` + `source-path=SCRIPTDIR`: scripts source `_lib.sh` via
  `$(dirname "$0")`, so shellcheck is told where to look instead of blanket-disabling SC1091
- `.styluaignore` — vendored skills, submodule
- `nvim/.stylua.toml` — Lua style (4 spaces, width 120)

## Disabled markdownlint rules

- `MD013` line-length — prose wraps at 100 via prettier; tables and code stay long
- `MD033` inline HTML
- `MD041` first-line-heading — agent/command files and prompt fragments
  (`shared/instructions-core.md`, `claude/commands/*.md`) deliberately start without an H1;
  narrowing the rule via `front_matter_title` does not help, the frontmatter has no title field
- `MD060` table-column-style
- `MD024` duplicate headings with `siblings_only: true` — skills reuse headings like "Gate Function"
  under different parents

## Vendored files

`opencode/skills/` (the superpowers pack) and the `dotbot/` submodule are upstream files;
reformatting them turns the next sync into a merge conflict. They are excluded in
`.markdownlintignore`, `.prettierignore`, `.styluaignore` and `biome.json`.

The one exception is `shfmt`, which has no ignore mechanism whatsoever — the three vendored `*.sh`
scripts are therefore formatted along with ours. That is a deliberate choice: after an upstream sync
they just get run through `shfmt -w` again.

## Not covered

`*.fish` (no practical linter), `*.tpl` templates, `*.toml` (a single file; `taplo` is installed if
it ever grows), `*.php` fixtures. There is no pre-commit hook or CI — linting is a deliberate manual
`make lint`.
