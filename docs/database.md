# Database

## Overview

CleanFinance uses SQLite through `sqflite`.

Main file:

- `lib/core/database/app_database.dart`

Database identity:

- Name: `clean_finance.db`
- Version: `6`

`AppDatabase.instance` memoizes a single `Database` instance.

## PRAGMA Configuration

On open, the app enables:

```sql
PRAGMA foreign_keys = ON
```

## Tables

### `categories`

Purpose:

- store top-level categories and subcategories

Columns:

- `id TEXT PRIMARY KEY`
- `name TEXT NOT NULL`
- `scope TEXT NOT NULL`
- `parent_id TEXT`
- `is_default INTEGER NOT NULL DEFAULT 0`
- `reminder_enabled INTEGER NOT NULL DEFAULT 0`
- `reminder_day INTEGER`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`

Notes:

- `parent_id != null` indicates a subcategory
- expense subcategories can act as recurring reminder sources

### `savings_goals`

Purpose:

- store savings goals and reminder configuration

Columns:

- `id TEXT PRIMARY KEY`
- `name TEXT NOT NULL`
- `target_amount REAL NOT NULL`
- `target_date TEXT`
- `is_archived INTEGER NOT NULL DEFAULT 0`
- `reminder_enabled INTEGER NOT NULL DEFAULT 0`
- `reminder_day INTEGER`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`

### `movements`

Purpose:

- store incomes, expenses, and saving contributions

Columns:

- `id TEXT PRIMARY KEY`
- `type TEXT NOT NULL`
- `amount REAL NOT NULL`
- `category_id TEXT NOT NULL`
- `subcategory_id TEXT`
- `goal_id TEXT`
- `occurred_on TEXT NOT NULL`
- `note TEXT`
- `payment_method TEXT`
- `monthly_reminder_enabled INTEGER NOT NULL DEFAULT 0`
- `reminder_day INTEGER`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`

Notes:

- `subcategory_id` links expenses to a specific subcategory when used
- `goal_id` links saving movements to a savings goal
- `monthly_reminder_enabled` and `reminder_day` still exist in the movement table, but the current reminder UI and reminder service derive reminders from subcategories and savings goals instead

### `budgets`

Purpose:

- store one monthly budget per expense category and month

Columns:

- `id TEXT PRIMARY KEY`
- `category_id TEXT NOT NULL`
- `monthly_limit REAL NOT NULL CHECK (monthly_limit >= 0)`
- `month TEXT NOT NULL`

Constraint:

- unique index on `(category_id, month)`

### `app_settings`

Purpose:

- store app-wide local preferences

Columns:

- `id INTEGER PRIMARY KEY CHECK (id = 1)`
- `currency_code TEXT NOT NULL`
- `currency_symbol TEXT NOT NULL`
- `show_sensitive_amounts INTEGER NOT NULL DEFAULT 1`
- `theme_mode TEXT NOT NULL`
- `biometric_enabled INTEGER NOT NULL DEFAULT 0`
- `auto_lock_minutes INTEGER NOT NULL DEFAULT 5`
- `locale_code TEXT NOT NULL DEFAULT 'es'`
- `payment_methods TEXT NOT NULL`

Notes:

- the table is seeded with a single row on database creation

## Relationships

Logical relationships documented in code and schema:

- `movements.category_id -> categories.id`
- `movements.goal_id -> savings_goals.id`
- `budgets.category_id -> categories.id`

Current delete behavior for new installs:

- category deletion is restricted when movements or budgets depend on it
- goal deletion sets `movements.goal_id` to `NULL`

Reference:

- `lib/core/database/schema_relationships.md`

## Important Migration Note

The repository explicitly documents that older SQLite databases are not rebuilt just to add foreign keys.

Implication:

- new installs receive the stronger schema
- older user databases may keep older physical schemas because SQLite does not add foreign keys retroactively without rebuilding tables
- repository logic still performs defensive cleanup and deletion checks to keep behavior aligned

## Current Migrations

### Version 2

- add `locale_code` to `app_settings`
- add `payment_methods` to `app_settings`

### Version 3

- create `budgets`
- create related budget indexes

### Version 4

- add `show_sensitive_amounts` to `app_settings`

### Version 5

- add `monthly_reminder_enabled` and `reminder_day` to `movements`
- add reminder-related movement index

### Version 6

- add `reminder_enabled` and `reminder_day` to `categories`
- add `reminder_enabled` and `reminder_day` to `savings_goals`

## Seed Data

`LocalFinanceRepository.ensureSeedData()` seeds default categories if the categories table is empty.

Default scopes currently seeded:

- income
- expense
- saving

Examples include:

- `Sueldo`
- `Freelance`
- `Comida`
- `Servicios`
- `Suscripciones`
- `Ahorro general`
- `Fondo de emergencia`
- `Viaje`

## Persistence Strategy

Concrete persistence is split across:

- `LocalFinanceRepository`
- `LocalBudgetRepository`

Patterns used:

- direct `db.insert`, `db.update`, `db.delete`, `db.query`
- `rawQuery` calls for aggregates and reporting
- manual mapping from `Map<String, Object?>` to domain entities

## Backup and Import

The finance repository exports the following tables to JSON:

- `categories`
- `movements`
- `savings_goals`
- `budgets`
- `app_settings`

Import behavior:

- clears those tables
- re-inserts imported data
- recreates default settings when the backup does not include them

## Date Handling

Dates are stored as ISO-8601 strings.

Examples of current query style:

- month aggregates use `occurred_on >= start` and `< endExclusive`
- movement filtering uses `occurred_on >= start` and `<= endInclusive`

The helper used to derive month bounds is:

- `lib/core/utils/month_context.dart`
