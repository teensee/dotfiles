# Decoupling plan: Claude Code ↔ opencode дубли и дрейф

Аудит от 24.09.2026. Цель — убрать дублирование конфигов между opencode и Claude Code,
зафиксировать единые источники правды и починить накопившийся дрейф доков.

## Статус

- A. Skills — **выполнено** 24.09.2026
- B. CodeGraph — **выполнено** 24.09.2026
- C. Agents/commands — отложено
- D. settings.json — **выполнено** 24.09.2026
- E. Фиксы доков — **выполнено** 24.09.2026
- F. Мелочи — не начато

## Что найдено аудитом

**P1. Зеркало Claude Code дрейфует системно**

- `~/.claude/settings.json` — уже plain file (не симлинк), и он свежее репы: в live есть
  `gitkraken-hooks@gitkraken` + `extraKnownMarketplaces`, в репе нет → потерянные настройки.
- Agents: 14/14 разошлись. Claude-версии заморожены на коммите `eaaa193`, opencode ушёл вперёд
  (codegraph-first, postgres-правила, quality checklist, EN-язык). Доки утверждают «ported 1:1» —
  неправда.
- Commands: 8/8 разошлись + naming drift: opencode — `/review-task`, а доки и Claude — `/review`;
  `/yt-comm` у Claude нет.
- CodeGraph-блок лежит в 3 файлах (`claude/CLAUDE.md`, `opencode/instructions.md`,
  `opencode/AGENTS.md`) и частично дублирует §«Приоритет инструментов» в shared core.

**P2. Skills** — 66 файлов, байт-в-байт идентичны (`diff -rq claude/skills opencode/skills` пуст).

**P3. Доки дрейфуют**

- `docs/opencode.md`: `plugin/` → `plugins/` (opencode грузит именно plural; `plugin/` — пустая
  локальная папка, git её не трекает); `/review` → `/review-task`; описание `instructions.md`
  устарело. Пункт про `package.json`/`node_modules` — **не дрейф**: файл существует и намеренно
  игнорируется через `opencode/.gitignore`.
- `.opencode/docs/ai/workflow.md`: `/review` → `/review-task` (2 места).
- `opencode/instructions.md:17`: `/review` → `/review-task` — глобальная инструкция зовёт
  несуществующую команду.
- `docs/zed.md`: «hard-wrap 120 chars», а в `.prettierrc.json` — `printWidth: 100`.
- `.opencode/docs/ai/claude-code.md`: «ported 1:1» неверно; `instructions.md`: процесс «mirror by
  hand» на практике не выполнялся.

**P4. Мелочи**

- `brew/Brewfile`: формула `zsh-autosuggestions` не используется (работает OMZ-клон).
- `fish/fish_variables` — машинное состояние, fish его перезаписывает → churn.
- Два zed-коммита с одинаковым сообщением (`da7c54d` + `f0d2541`).
- `opencode/plugins/gk-hooks.js` — автогенерируемый GitKraken'ом файл с машинным путём (ок).

## Решения

- Claude Code используется изредка → унификация agents/commands (генератор или drift-check)
  откладывается. Канон при унификации — EN, как в opencode.
- Сделаны A, B, D и E (24.09.2026); F — в бэклоге.

## План

### A. Skills — один источник вместо двух [ВЫПОЛНЕНО 24.09.2026]

Итог: `claude/skills/` удалён (66 файлов), `~/.claude/skills` → `opencode/skills`; чтение
SKILL.md через линк проверено, `make check` — OK.

1. Удалить `claude/skills/` (66 файлов, точный дубль).
2. `install.conf.yaml`: `~/.claude/skills: claude/skills` → `~/.claude/skills: opencode/skills`
   (канон — `opencode/skills/`, файлы не переписываются).
3. Docs: `claude-code.md` (скиллы — та же директория по ссылке), `docs/opencode.md`,
   `architecture.md`, `readme.md`.

### B. CodeGraph-блок — один экземпляр [ВЫПОЛНЕНО 24.09.2026]

Итог: блок в конце `shared/instructions-core.md`; `claude/CLAUDE.md`, `opencode/instructions.md`
очищены, `opencode/AGENTS.md` удалён; `rg CODEGRAPH_START` → только core.

1. Перенести блок (с маркерами `CODEGRAPH_START/END`) в конец `shared/instructions-core.md` —
   он подключён к обоим тулзам.
2. Удалить блок из `claude/CLAUDE.md`, `opencode/instructions.md`, `opencode/AGENTS.md`
   (последний после этого пуст — удалить файл).
3. Docs: `instructions.md` / `claude-code.md` — источник правды core; если codegraph доинжектит
   блок обратно, удалять.
4. Проверка: `rg CODEGRAPH_START` → ровно 1 файл.

### C. Agents/commands — отложено

Дрейф зафиксировать в доках честно (ручной перенос, разошлись; унификация EN-каноном —
отдельная задача). Варианты на потом:

- C1: генератор `claude/*` из `opencode/*` + drift-check (`make check-drift`);
- C2: только drift-check без генерации;
- C3: сократить дубли (если Claude почти не нужен).

### D. `~/.claude/settings.json` — вернуть симлинк и потерянный gitkraken [ВЫПОЛНЕНО 24.09.2026]

Итог: оба расхождения (`gitkraken-hooks@gitkraken`, `extraKnownMarketplaces`) смержены в
`claude/settings.json` (семантический diff с live пуст), live забэкаплен в temp и удалён,
симлинк восстановлен через `./dotbot/bin/dotbot --only link`; `make check` — все `OK`;
known-drift в `claude-code.md` расширен (UI Claude при работе с плагинами).

1. Смержить в `claude/settings.json`: `gitkraken-hooks@gitkraken`, `extraKnownMarketplaces`
   (есть в live, нет в репе).
2. Бэкап live → temp, `rm ~/.claude/settings.json`, затем dotbot relink.
3. `claude-code.md`: расширить known-drift — не только codegraph, но и UI Claude при включении
   плагинов перезаписывает файл.

### E. Фиксы доков (дрейф) [ВЫПОЛНЕНО 24.09.2026]

Итог: `/review` → `/review-task` в `opencode/instructions.md`, `docs/opencode.md`,
`.opencode/docs/ai/workflow.md` (2 места) и `opencode/commands/go.md` (в план не входил — найден
grep'ом по репе); `docs/opencode.md` — `plugins/` + gk-hooks.js, `package.json` через
`opencode/.gitignore`, новое описание `instructions.md`; `docs/zed.md` — 100 chars по
`.prettierrc.json`; `.opencode/docs/ai/instructions.md` + `claude-code.md` — реальный статус
agents/commands (14/14 и 8/8 разошлись, заморожены на `eaaa193`). Таблицы перевыровнены prettier'ом
точечно (полный реформат откатан — prettier не является общим стандартом репы: 6 доков не clean).

1. `docs/opencode.md`: `plugin/` → `plugins/` (+gk-hooks.js), актуализировать
   `package.json`-пункт (существует, но игнорируется через `opencode/.gitignore`),
   `/review` → `/review-task`, обновить описание `instructions.md`.
2. `.opencode/docs/ai/workflow.md`: `/review` → `/review-task` (2 места).
3. `opencode/instructions.md`: `/review` → `/review-task`.
4. `docs/zed.md`: 120 → 100 (по `.prettierrc.json`), уточнить формулировку prettier.
5. `.opencode/docs/ai/instructions.md` + `claude-code.md`: описать реальный статус
   agents/commands.

### F. Мелочи

1. `brew/Brewfile`: убрать `zsh-autosuggestions` (затем `brew uninstall zsh-autosuggestions`,
   иначе `brewup` вернёт строку).
2. `.gitignore`: `fish/fish_variables` + `git rm --cached fish/fish_variables`.

## Порядок исполнения и верификация

A, B, D и E выполнены 24.09.2026 (перелинковка сделана, `make check` — всё `OK`, включая
`.claude/settings.json`). Остаток: F.

1. (остаток) F.
2. После правок: `./dotbot/bin/dotbot -d . -c install.conf.yaml --only link`, затем `make check` —
   ждём все `OK`.
3. `jq . claude/settings.json`; `rg CODEGRAPH_START`; `rg 'claude/skills'`; `readlink ~/.claude/skills`.

## Коммиты (делает пользователь, git у агента read-only)

Готово к коммиту (A/B/D/E, правки в рабочем дереве): 1–4. Не начато: 5.

1. `refactor(skills): single skills dir shared between opencode and Claude Code`
2. `refactor(instructions): one CodeGraph block in shared core`
3. `fix(claude): restore settings symlink, track gitkraken plugin`
4. `docs: fix drift (opencode plugin dir, /review-task, prettier width)`
5. `chore: drop unused zsh-autosuggestions formula, ignore fish_variables`
   (+ `git rm --cached fish/fish_variables`)
6. (опционально) squash `da7c54d` + `f0d2541` — дубль сообщения у zed.
