# Отчёт по ревизии репозитория `.dotfiles`

Дата: 2026-05-15. База ясна (Dotbot + ручные конфиги), здесь — только то, что реально ломается, конфликтует или устарело.

## 1. Баги (по приоритету)

### 1.1. `Makefile`: цели `backup` и `restore` сломаны
В рецептах используется `$config` и `$LATEST_BACKUP` без экранирования. Make разворачивает их в пустую строку до запуска shell:

```make
# backup
for config in .zshrc .gitconfig .tmux.conf .config/nvim .config/fish .config/ghostty; do \
    if [ -e "$(HOME)/$config" ]; then       # ← $c пустое, остаётся "$(HOME)/onfig"
        cp -r "$(HOME)/$config" "$(BACKUP_DIR)/"; \
```

Эффект: backup создаёт пустой каталог `~/.dotfiles-backup-TIMESTAMP` при каждом `make install`. `make restore` тоже не работает.

**Фикс:** заменить `$` на `$$` во всех ссылках на shell-переменные внутри рецептов (`$$config`, `$$LATEST_BACKUP`).

### 1.2. `make check` в документации отсутствует в Makefile
`CLAUDE.md` и `AGENTS.md` обещают `make check`, но цели нет. Либо добавить (например, `dotbot --only link --verbose` без `--write`, либо `find ~ -maxdepth 3 -lname '*/.dotfiles/*' -xtype l`), либо убрать из доков.

### 1.3. TPM ставится не туда, куда грузится
- `install.conf.yaml`: `git clone … ~/.config/tmux/plugins/tpm`
- `tmux/tmux.conf`: `run '~/.tmux/plugins/tpm/tpm'`

Сейчас работает только потому, что вручную создан второй каталог `~/.tmux/plugins/tpm`. После чистой установки на новой машине плагины tmux не подхватятся.

**Фикс:** в `tmux.conf` поменять путь на `~/.config/tmux/plugins/tpm/tpm` и установить `TMUX_PLUGIN_MANAGER_PATH=~/.config/tmux/plugins/`.

### 1.4. `~/.gitconfig-etp` не симлинкуется
`git/gitconfig` подключает `~/.gitconfig-etp` через `includeIf`, но в `install.conf.yaml` симлинка нет. Файл сейчас существует в `$HOME` как обычная копия — на чистой машине conditional include молча сломается.

**Фикс:** добавить `~/.gitconfig-etp: git/gitconfig-etp` в `link:`.

### 1.5. `gitignore_global` — неверный синтаксис комментариев
```
-- Ignore Globally .DS_Store
.DS_Store
```
`--` в `.gitignore` трактуется как обычный паттерн (просто не матчит файлы → «работает»). Корректный комментарий — `#`.

### 1.6. `git/gitconfig-local.example` / `gitconfig-work.example` упоминаются, но не существуют
`readme.md` и `AGENTS.md` советуют `cp git/gitconfig-local.example git/gitconfig-local`. Файлов с таким именем в репозитории нет → инструкция не выполнима.

**Фикс:** либо добавить шаблоны, либо удалить шаги из доков.

### 1.7. Расхождения в `CLAUDE.md`/`AGENTS.md` с реальностью
- Сказано «NvChad v3», в `nvim/init.lua`: `branch = "v2.5"`.
- `programming.lua`: neotest подключает только `neotest-golang`, никакого PHPUnit-адаптера нет — в доках написано «(Go/PHPUnit)».
- В `AGENTS.md` тема указана как `everblush`, в `lua/chadrc.lua` нужно проверить, но `CLAUDE.md` пишет `doomchad`. Документы рассинхронизированы между собой.

### 1.8. PHP-версии конфликтуют
`asdf/tool-versions`: `php 8.1.32`; `brew/Brewfile`: `brew "php"` (текущая = 8.4+). Так как `asdf/shims` идёт первым в PATH, brew-php недостижим. Либо удалить из Brewfile, либо явно решить, какая основная.

### 1.9. `make install` → `make backup` всегда создаёт каталог
Даже если бы цикл работал, новый таймштамп-каталог создаётся при каждом запуске. Со временем превращается в свалку. Стоит проверять, появилось ли что-то для бэкапа, и удалять пустые каталоги.

### 1.10. `install.conf.yaml: clean: ["~"]`
Чистит broken-симлинки только в `$HOME` верхнего уровня. Симлинки внутри `~/.config/{nvim,tmux,ghostty,htop,lazygit,tmuxinator,fish}` не подметаются. После переименования/удаления конфигов будут висеть «оборванные» ссылки.

**Фикс:**
```yaml
- clean:
    ['~', '~/.config']
    force: true
```

## 2. Узкие места и неэффективности

- **PATH «лесенкой» в `zsh/zshrc`** (`/opt/homebrew/bin`, `/opt/homebrew/sbin`, `bison`, `go`, asdf-shims). Работает благодаря `typeset -U path PATH`, но порядок неявный. Стоит собрать массивом `path=(... $path)` единым блоком.
- **`source <(fzf --zsh)`** — запуск fzf на каждом старте оболочки (~50–100 мс). Можно закэшировать в файл и source-ить его.
- **`compinit` ускорение**: текущая ветка `compinit -C` пропускает проверку прав, что нормально для личной машины — оставить как есть, но добавить `zsh-autosuggestions` через `brew` (он же установлен!) вместо OMZ-плагина, чтобы избежать дублирования.
- **OMZ-плагин `dotenv`** автоматически source-ит `.env` при `cd` — потенциальный риск при работе в чужих репозиториях. Либо включить prompt-режим (`ZSH_DOTENV_PROMPT=true`), либо отключить.
- **Brewfile**: `claude-code` как cask + `tabbyml/tabby`, `gstreamer-runtime`, `openmtp` — стоит проверить, реально ли всё используется. Эти каски тяжёлые.

## 3. Структурные предложения

### 3.1. Документация
`readme.md`, `CLAUDE.md`, `AGENTS.md`, `documentation.md`, `upgrade.md` — пять источников правды, частично дублирующих друг друга. Уже сейчас они рассинхронизированы (NvChad v2.5 vs v3, темы, PHPUnit и т.д.).

**Предложение:** один `README.md` для людей + `CLAUDE.md` как единственная точка для агентов. Остальное — в архив или удалить. `AGENTS.md` оставлять только если хочется ткнуть на него другим CLI-агентам — но тогда сделать его симлинком/инклюдом, а не копией.

### 3.2. Разделение «зон ответственности» в `install.conf.yaml`
Сейчас shell-секция делает `brew bundle` и клон TPM. На свежем mac без `brew` оба шага молча провалятся (есть `|| echo`). Имеет смысл вынести bootstrap (установка Homebrew, asdf, oh-my-zsh) в отдельный `bootstrap.sh`, чтобы `make install` оставался идемпотентным и быстрым.

### 3.3. Pre-commit hook / линтер dotbot-конфига
Лёгкий smoke-test: `./install --only link` в CI (или git hook) ловит как минимум опечатки в путях и пропавшие исходники. Можно добавить GitHub Action даже для приватного репо.

### 3.4. Nvim: вычистить мёртвый код
- `nvim/lua/plugins/ai-assistants.lua` — copilot disabled. Если не используется > пары месяцев — удалить, не держать «на всякий».
- DAP-конфиг для PHP жёстко прибит к `mason/packages/php-debug-adapter` — но Mason нигде в плагинах не настроен. Если Mason ставит NvChad — норм, иначе при первой попытке отладки `phpDebug.js` не найдётся. Стоит явно прописать `williamboman/mason.nvim` в plugins или хотя бы в README отметить требование.

### 3.5. `make clean` слишком жадный
`rm -rf ~/.tmux/resurrect/*` — это все сохранённые сессии tmux-resurrect. Если плагин используется — потеря данных. Оставить эту операцию за отдельной целью `make clean-tmux`, а основной `clean` ограничить кэшами.

## 4. Мелочи / косметика

- `.gitignore` игнорит `CLAUDE.md`, но файл уже tracked — конфликт смысла. Либо исключение из tracking, либо убрать строку.
- `.DS_Store` в корне репозитория физически лежит (`ls -la`), но не tracked — благодаря глобальному gitignore. Стоит добавить локально в `.gitignore` чтобы не зависеть от глобального.
- Submodule `dotbot` с `ignore = dirty` — ок, но иногда полезно периодически обновлять (`git submodule update --remote dotbot`).
- В `tmuxinator/dots.yml` и других — проверить, что пути проектов всё ещё валидны (часто устаревают).

## 5. План действий (приоритезированный)

1. Починить `Makefile` (баги 1.1, 1.2, 1.9).
2. Согласовать пути TPM (1.3).
3. Добавить симлинк `gitconfig-etp` (1.4).
4. Привести `gitignore_global` к корректному синтаксису (1.5).
5. Либо создать `*.example`, либо удалить упоминания из доков (1.6).
6. Синхронизировать `CLAUDE.md`/`AGENTS.md` с реальным состоянием (1.7) и решить, нужны ли оба.
7. Решить вопрос PHP-через-brew vs asdf (1.8).
8. `clean: ["~", "~/.config"]` (1.10).
9. Косметика (раздел 4).
10. Рефакторинг доков и bootstrap-флоу (раздел 3) — отдельной итерацией.
