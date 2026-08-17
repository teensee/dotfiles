---
description: Напоминалка — рецепт read-only пользователя Postgres для opencode MCP
agent: build
subtask: true
model: opencode-go/deepseek-v4-flash
---

Напомни рецепт создания read-only пользователя Postgres для opencode MCP (`postgres`).

$ARGUMENTS — если пользователь передал значения (например `appdb`, `opencode_ro`, `change-me`), подставь их в шаблон; если нет — выведи шаблон с плейсхолдерами `<db>`, `<role>`, `<password>`.

## 1. SQL — создать роль с правами только на чтение

```sql
CREATE ROLE <role> LOGIN PASSWORD '<password>';
GRANT CONNECT ON DATABASE <db> TO <role>;
GRANT USAGE ON SCHEMA public TO <role>;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO <role>;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO <role>;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO <role>;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON SEQUENCES TO <role>;
ALTER ROLE <role> SET default_transaction_read_only = on;
```

## 2. Выполнить в докере

```bash
docker exec -i <container> psql -U postgres
# вставить SQL выше (или: docker exec -i <container> psql -U postgres < file.sql)
```

Убедись, что порт опубликован в docker-compose (`ports: - "5432:5432"`).

## 3. Строка подключения и env

```bash
export DATABASE_OPENCODE_RO_URI="postgresql://<role>:<password>@localhost:5432/<db>"
```

## 4. Включить MCP в проектном opencode.json

```json
{
  "mcp": {
    "postgres": {
      "type": "local",
      "command": ["npx", "-y", "@modelcontextprotocol/server-postgres"],
      "environment": { "DATABASE_URI": "{env:DATABASE_OPENCODE_RO_URI}" },
      "enabled": true
    }
  }
}
```

## 5. Проверка

```bash
psql "$DATABASE_OPENCODE_RO_URI" -c "SELECT 1;"        # должно работать
psql "$DATABASE_OPENCODE_RO_URI" -c "CREATE TABLE t(id int);"   # должно упасть (read-only)
```