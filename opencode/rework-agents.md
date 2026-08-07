# План доработки субагентов и команд

> Основано на сравнении с [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents).
> Исходный состав: 6 агентов (go-dev, symfony-dev, devops, dba, test-writer, research) + 4 команды (/res, /plan, /go, /clean).
> **Статус: ВЫПОЛНЕНО** (2026-08-06)

## Решения по итогам обсуждения

- **Подход:** фазами, каждая фаза — отдельный этап
- **Агент для /plan:** отдельный `architect` (не research)
- **Глубина агентов:** средняя (~100-120 строк), не VoltAgent-полная (200-300)
- **Новые агенты:** python-pro, code-reviewer, rust-engineer, debugger, security-auditor, zig-dev
- **DBA:** PostgreSQL-only
- **Zig:** писать с нуля

---

## Фаза 1: Foundation — workflow и orchestrator-агенты ✅

### 1.1 `opencode/agent/research.md` — дать system prompt

- [x] Роль: аналитик-исследователь кодовой базы
- [x] Методология: найти → понять → связать → выявить неясности
- [x] Правила: никакого кода, никаких решений, только анализ
- [x] Чеклист качества: все файлы найдены? зависимости определены? неясности задокументированы?
- [x] Формат отчёта (совместим с task-research.md)

### 1.2 `opencode/agent/architect.md` — создать

- [x] Роль: архитектор-проектировщик
- [x] Методология: понять контекст → изучить паттерны → спроектировать → оценить риски
- [x] Правила: только сигнатуры, интерфейсы, схемы — не реализация
- [x] Чеклист: компоненты спроектированы? сигнатуры ясны? миграции продуманы? тест-кейсы определены? риски оценены?
- [x] Архитектурные принципы (SOLID, следование стилю проекта)
- [x] Формат task-plan.md

### 1.3 `opencode/commands/res.md` — обновить

- [x] Убрать методологические детали (теперь в агенте)
- [x] Команда задаёт только задачу: прочитай task.md → создай task-research.md
- [x] Оставить `agent: research`

### 1.4 `opencode/commands/plan.md` — обновить

- [x] Сменить `agent: research` → `agent: architect`
- [x] Упростить: команда = задача, архитектор = методология
- [x] Оставить структуру task-plan.md в команде (спецификация формата)

### 1.5 `opencode/commands/review.md` — создать

- [x] Агент: `code-reviewer`
- [x] Задача: прочитать task-plan.md + task-log.md + git diff, провести ревью
- [x] Формат: список проблем (критические / важные / стиль) + рекомендации

### 1.6 `AGENTS.md` — обновить (базово)

- [x] Добавить `/review` команду
- [x] Отразить нового architect-агента
- [x] Обновить `make` цели при необходимости

---

## Фаза 2: Core stack — усиление существующих агентов ✅

### 2.1 `opencode/agent/go-dev.md` — расширить (32 → ~110 строк)

- [x] Concurrency patterns: worker pools, fan-in/fan-out, rate limiting, backpressure
- [x] Performance profiling: pprof, benchmark-driven, zero-allocation, sync.Pool
- [x] Memory management: escape analysis, GC tuning, slice/map pre-allocation
- [x] Observability: slog/zap, Prometheus, OpenTelemetry
- [x] Security: input validation, SQL injection, auth middleware, TLS
- [x] Build & tooling: cross-compilation, CGO guidelines, Makefile
- [x] Чеклист: gofmt, golangci-lint, race detector, coverage > 80%

### 2.2 `opencode/agent/symfony-dev.md` — расширить (38 → ~120 строк)

- [x] Version awareness: читать composer.lock, адаптировать под 6.4/7.x/8.0
- [x] Security: voters, #[IsGranted], firewalls, CORS, CSP, 2FA, composer audit
- [x] Deployment: FrankenPHP, Symfony CLI, docker, Deployer
- [x] Production readiness: Blackfire, Sentry, Monolog, OpenTelemetry
- [x] Доп. компоненты: Scheduler, Mercure, Notifier, Mailer, Workflow
- [x] Performance: OPcache, route/config кэширование, AssetMapper vs Encore
- [x] Enterprise: multi-tenancy, CQRS, DDD (кратко)
- [x] Чеклист: PSR-12, PHPStan level 9, coverage > 85%, security scan clean

### 2.3 `opencode/agent/devops.md` — расширить (48 → ~110 строк)

- [x] IaC: Terraform (кратко)
- [x] GitOps: ArgoCD/Flux, декларативные конфиги
- [x] Deployment strategies: blue-green, canary, rolling с rollback
- [x] Incident management: runbooks, postmortems, war rooms
- [x] SLI/SLO: определение и мониторинг
- [x] Secret management: Vault, sealed secrets
- [x] Docker advanced: SBOM, Cosign, image signing, supply chain
- [x] K8s advanced: HPA/VPA, PDB, network policies, service mesh (кратко)
- [x] Чеклист: автоматизация 100%, мониторинг, security, docs-as-code

### 2.4 `opencode/agent/dba.md` — расширить (46 → ~110 строк)

- [x] Replication: streaming, logical, failover, Patroni (кратко)
- [x] Backup & recovery: PITR, WAL archiving, retention
- [x] Vacuum: autovacuum tuning, bloat prevention, freeze, pg_repack
- [x] Partitioning: range/list/hash, partition pruning
- [x] Extensions: pg_stat_statements, pg_trgm, postgres_fdw, timescaledb
- [x] Monitoring: метрики, алерты, дашборды
- [x] Security hardening: scram-sha-256, SSL, RLS, audit logging
- [x] Connection pooling: pgbouncer
- [x] JSONB: индексные стратегии, паттерны запросов
- [x] Чеклист: EXPLAIN проанализирован, индексы оптимальны, блокировки проверены

### 2.5 `opencode/agent/test-writer.md` — расширить (41 → ~100 строк)

- [x] CI/CD integration: запуск в GitLab CI, quality gates
- [x] Flaky test management: retry, изоляция, цель <1% flaky
- [x] Mutation testing: Infection (PHP)
- [x] Coverage: thresholds, reporting
- [x] Test data: фабрики, фикстуры, изоляция, cleanup
- [x] Чеклист: AAA соблюдён, edge cases покрыты, моки изолированы

---

## Фаза 3: New agents — создание ✅

### 3.1 `opencode/agent/python-pro.md` — создать (~110 строк)

- [x] Python 3.11+, strict typing (mypy), async/await
- [x] FastAPI, Django, Flask
- [x] Pydantic, SQLAlchemy, Alembic, Celery
- [x] pytest, fixtures, Hypothesis (property-based)
- [x] Performance: profiling, vectorization, Cython
- [x] Security: bandit, input validation, secrets
- [x] Packaging: Poetry, virtual envs
- [x] TRIGGER/SKIP в description

### 3.2 `opencode/agent/code-reviewer.md` — создать (~120 строк)

- [x] Multi-language (Go, PHP, Python, Rust, bash, SQL)
- [x] Security first: injection, auth, sensitive data, dependencies
- [x] Code quality: SOLID, DRY, naming, complexity
- [x] Performance: queries, memory, algorithms
- [x] Tests: coverage, quality, edge cases
- [x] Constructive feedback format

### 3.3 `opencode/agent/rust-engineer.md` — создать (~110 строк)

- [x] Ownership & borrowing, lifetimes
- [x] Traits, generics, GATs
- [x] Error handling: thiserror, anyhow
- [x] Async: tokio
- [x] Unsafe guidelines
- [x] Testing: proptest, fuzzing, miri, criterion
- [x] FFI, C interop
- [x] Build: cargo workspace, feature flags

### 3.4 `opencode/agent/debugger.md` — создать (~110 строк)

- [x] Systematic approach: reproduce → isolate → fix → verify
- [x] Techniques: breakpoints, logs, binary search, divide-and-conquer
- [x] Memory bugs: leaks, corruption, use-after-free
- [x] Concurrency: race conditions, deadlocks
- [x] Performance debugging: profiling, bottlenecks
- [x] Postmortem format

### 3.5 `opencode/agent/security-auditor.md` — создать (~100 строк)

- [x] Vulnerability scanning (SAST, dependencies)
- [x] OWASP Top 10
- [x] Auth & authorization audit
- [x] Input validation, injection prevention
- [x] Secret management audit
- [x] Compliance (применимо)

### 3.6 `opencode/agent/zig-dev.md` — создать (~100 строк)

- [x] Zig 0.13+, comptime, allocators (GPA, Arena, FixedBuffer)
- [x] Error handling: try/catch, error unions
- [x] Build system: build.zig
- [x] C interop: @cImport, translate-c
- [x] Testing: test blocks, std.testing
- [x] Systems programming: no hidden allocations, explicit control

---

## Фаза 4: Polish ✅

### 4.1 `opencode/commands/go.md` — обновить

- [x] Добавить в секцию делегирования: python-pro, rust-engineer, zig-dev

### 4.2 `AGENTS.md` — финальное обновление

- [x] Отразить полный флоу: /res → /plan → /go → /review → /clean
- [x] Список агентов: 6 → 12
- [x] Per-tool reference: обновить docs/opencode.md

### 4.3 Проверка

- [x] `make check` — симлинки
- [ ] Тестовый прогон флоу на демо-задаче

---

## Итого: 18 изменений выполнено

| Файл                                 | Фаза | Действие          | Статус |
| ------------------------------------ | ---- | ----------------- | ------ |
| `opencode/agent/research.md`         | 1    | Переписать        | ✅ |
| `opencode/agent/architect.md`        | 1    | Создать           | ✅ |
| `opencode/commands/res.md`           | 1    | Обновить          | ✅ |
| `opencode/commands/plan.md`          | 1    | Обновить          | ✅ |
| `opencode/commands/review.md`        | 1    | Создать           | ✅ |
| `AGENTS.md`                          | 1    | Обновить (базово) | ✅ |
| `opencode/agent/go-dev.md`           | 2    | Расширить         | ✅ |
| `opencode/agent/symfony-dev.md`      | 2    | Расширить         | ✅ |
| `opencode/agent/devops.md`           | 2    | Расширить         | ✅ |
| `opencode/agent/dba.md`              | 2    | Расширить         | ✅ |
| `opencode/agent/test-writer.md`      | 2    | Расширить         | ✅ |
| `opencode/agent/python-pro.md`       | 3    | Создать           | ✅ |
| `opencode/agent/code-reviewer.md`    | 3    | Создать           | ✅ |
| `opencode/agent/rust-engineer.md`    | 3    | Создать           | ✅ |
| `opencode/agent/debugger.md`         | 3    | Создать           | ✅ |
| `opencode/agent/security-auditor.md` | 3    | Создать           | ✅ |
| `opencode/agent/zig-dev.md`          | 3    | Создать           | ✅ |
| `opencode/commands/go.md`            | 4    | Обновить          | ✅ |
