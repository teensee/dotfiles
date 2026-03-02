# Upgrade Notes — dotfiles-1 → master

Сравнение ветки `dotfiles-1` с `master`. Изменения разбиты на три категории:
**обоснованные миграции**, **аддитивные улучшения** и **новый стек (требует отдельной оценки)**.

---

## 1. Обоснованные миграции

### SQL: sqlls → sql_formatter
**Файлы:** `conform.lua`, `lspconfig.lua`

`sqlls` использовался одновременно и как LSP, и как форматтер — что избыточно.
`sql-formatter` (npm-пакет) форматирует значительно лучше и без LSP-сервера.
LSP для SQL убран полностью: sqlls давал нестабильную работу и практически не использовался.

**Требует:** `npm install -g sql-formatter`

---

### PHP LSP: финализация конфига intelephense
**Файл:** `lspconfig.lua`

Переход с phpactor на intelephense был начат в коммите `fc6dd13`.
Данный коммит завершает его: убирает закомментированный phpactor,
добавляет полный список stubs и настройки файлов.

**Примечание:** phpactor остаётся как инструмент рефакторинга (`:Phpactor`),
но больше не является LSP-сервером.

---

### Dadbod completion: nvim-cmp → blink.cmp
**Файлы:** `blink-cmp.lua`, `database.lua`

Старый способ (FileType autocmd с nvim-cmp) конфликтовал с blink.cmp.
Теперь dadbod интегрирован через `per_filetype` в blink.cmp — корректно и без дублирования.

---

### Copilot отключён
**Файлы:** `ai-assistants.lua`, `blink-cmp.lua`

`enabled = false` и удаление из completion sources.
Copilot-плагины остаются в конфиге, но не загружаются.
Возврат: убрать `enabled = false`, раскомментировать в blink-cmp.

---

## 2. Аддитивные улучшения (без breaking changes)

### Treesitter: twig + sql парсеры
**Файл:** `nvim-treesitter.lua`

Чисто аддитивно. twig нужен для PHP-шаблонов, sql для подсветки запросов.

---

### Noice: включена signature popup
**Файл:** `ui.lua`

Была отключена из-за бага прыжка курсора. Включена с `auto_open`.
Если баг вернётся — откатить на `enabled = false`.

---

### Trouble.nvim
**Файл:** `nvim/lua/plugins/trouble.lua` (новый)

Лёгкий плагин диагностик. Команды: `:Trouble diagnostics`, `:Trouble qflist`.
Маппинги `<leader>xx`, `<leader>xd`, `<leader>xl`, `<leader>xq` в `mappings.lua`.

---

### Which-key группы
**Файл:** `mappings.lua`

Описания групп `<leader>d`, `<leader>g`, `<leader>x`, `<leader>t`, `<leader>o`
для читаемости в which-key popup.

---

### LSP маппинги вынесены в mappings.lua
**Файл:** `mappings.lua`

`gd`, `gr`, `gi`, `<leader>rn`, `<leader>ca`, `<leader>D` — стандартные LSP-биндинги.
Ранее могли быть разбросаны по on_attach или отсутствовать.

---

### tmux: качество жизни
**Файл:** `tmux/tmux.conf`

Все изменения аддитивны:
- `base-index 1` / `pane-base-index 1` — нумерация с 1 (привычнее)
- `renumber-windows on` — авторенумерация при закрытии
- `bind | / -` — splits в текущей директории (вместо дефолтных `%` и `"`)
- `bind Tab` — быстрый возврат на последнее окно
- `bind C-s` — синхронизация ввода на все панели
- copy-mode vi: `v` / `y` для выделения и копирования
- `bind -r H/J/K/L` — resize панелей с повторением

---

## 3. Новый стек (требует отдельной оценки перед мержем в master)

Следующие изменения вводят полностью новые инструменты, которые:
- требуют внешних зависимостей (mason packages, npm)
- занимают заметное место в startup
- пока не прошли реальную проверку в работе

### nvim-dap + nvim-dap-ui + nvim-dap-go
**Файл:** `programming.lua`

Отладчик для PHP (Xdebug) и Go (Delve).
- PHP требует `mason install php-debug-adapter` и настроенный Xdebug в проекте
- pathMappings захардкожены (`/var/www/html`) — нужна адаптация под проекты
- Go через dap-go работает из коробки при наличии `dlv`

**Статус:** стоит держать на feature-ветке до реального использования в проекте.

---

### neotest + neotest-golang + neotest-phpunit
**Файл:** `programming.lua`

Test runner с UI.
- golang-адаптер работает с `go test`
- phpunit-адаптер требует `phpunit` в проекте (composer или глобально)

**Статус:** то же, что dap — полезно, но требует проверки под конкретные проекты.

---

### nvim-lint (golangci-lint + phpstan)
**Файл:** `programming.lua`

Запускается на BufWritePost/InsertLeave.
- Требует `golangci-lint` и `phpstan` установленных глобально или в проекте
- Без них будут молчаливые ошибки (try_lint просто не найдёт бинарник)

**Статус:** обоснован, но нужно убедиться что бинарники доступны. Можно мержить с оговоркой.

---

## Итог: рекомендуемое разбиение для мержа в master

| Группа | Рекомендация |
|--------|--------------|
| SQL миграция (sqlls → sql_formatter) | ✅ мержить |
| intelephense финализация | ✅ мержить |
| Dadbod → blink.cmp | ✅ мержить |
| Copilot отключён | ✅ мержить |
| Treesitter parsers | ✅ мержить |
| Noice signature | ✅ мержить |
| Trouble.nvim | ✅ мержить |
| Which-key группы + LSP mappings | ✅ мержить |
| tmux QoL | ✅ мержить |
| nvim-dap + dap-ui + dap-go | ⏳ feature branch |
| neotest | ⏳ feature branch |
| nvim-lint | ⚠️ мержить с проверкой бинарников |
