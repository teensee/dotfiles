# Hurl scratch — примеры. Запуск: hurl scratch_N.hurl

# === GET ===
GET https://jsonplaceholder.typicode.com/todos/1
HTTP 200
[Asserts]
jsonpath "$.id" isInteger

# === POST ===
POST https://jsonplaceholder.typicode.com/posts
Content-Type: application/json
{
  "title": "foo",
  "body": "bar",
  "userId": 1
}
HTTP 201
[Asserts]
jsonpath "$.id" isInteger
