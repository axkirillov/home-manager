---
name: sql
description: Use when the user asks for SQL query generation, database inspection, or data retrieval.
compatibility: opencode
---

# SQL Instructions

Use this skill when the user requests SQL queries, database inspection, or data analysis.

## Environment Configuration

Every repository is expected to have an `.envrc` file containing the following environment variables:
- `PROD_DB_NAME`
- `PROD_DB_PASS`
- `PROD_DB_PORT`
- `PROD_DB_HOST` (should be `127.0.0.1` for TCP)

Optional (if applicable):
- `PROD_DB_USER`

Ensure these are available or sourced before running commands.

### Database Connection Troubleshooting (TCP vs Socket)

If you connect with `-h localhost`, the MySQL client may default to a Unix socket connection and fail with errors like:
- `ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/tmp/mysql.sock'`

This commonly happens when the database is exposed via a TCP port (container/tunnel) rather than a local socket.

Fix: force TCP by using `127.0.0.1` instead of `localhost` (or specify TCP protocol explicitly):

```bash
export PROD_DB_HOST=127.0.0.1
# or when running manually:
mysql -h 127.0.0.1 -P 6000 --protocol=TCP ...
```

## Operating Principles

### 1. Mandatory Schema Inspection
You excel at understanding natural language requests related to database operations and translating them into SQL queries. 

**Before writing any query, you MUST inspect the relevant database schema.** 

To do this:
1. Use the `bash` tool with a MySQL client.
2. Connect to the database and run schema inspection commands (e.g., `SHOW TABLES;`, `DESCRIBE <table_name>;`).
3. **Do not assume** table or column names.

Once you have the schema context, generate the required SQL (SELECT, joins, subqueries, etc.). Explain the generated SQL clearly, detailing what each part does and how it relates to the confirmed schema.

### 2. Execution and Presentation
If you are trying to **RUN** the query (to verify it or show data to the user):
-   **Always use LIMIT** to make the output small (e.g., `LIMIT 5`).
-   However, **present the final query without LIMIT to the USER** (unless the logic specifically requires it, e.g., "top 10").

### 3. Safety Protocols
-   **NEVER run UPDATE, DELETE, DROP, or ALTER COMMANDS!!!!**
-   This skill is strictly for read-only operations.

## Command Templates

### Inspection
```bash
# List tables
mysql --protocol=TCP -u ${PROD_DB_USER:-root} -p$PROD_DB_PASS -h ${PROD_DB_HOST:-127.0.0.1} -P $PROD_DB_PORT $PROD_DB_NAME -e "SHOW TABLES;"

# Describe table
mysql --protocol=TCP -u ${PROD_DB_USER:-root} -p$PROD_DB_PASS -h ${PROD_DB_HOST:-127.0.0.1} -P $PROD_DB_PORT $PROD_DB_NAME -e "DESCRIBE specific_table;"
```
