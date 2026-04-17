# Database

## Overview

CleanFinance usa SQLite vía `sqflite`.

Archivo principal:

- `lib/core/database/app_database.dart`

Identidad actual:

- nombre: `clean_finance.db`
- versión: `7`

`AppDatabase.instance` memoiza una sola instancia de `Database`.

Limitación de seguridad deliberada:

- la base SQLite local no está cifrada a nivel archivo
- el proyecto prioriza simplicidad y offline-first
- el acceso a la base se mantiene encapsulado en repositorios para aislar la superficie de lectura/escritura

## Configuración

Al abrir la base se ejecuta:

```sql
PRAGMA foreign_keys = ON
```

## Tablas

### `categories`

Propósito:

- categorías principales y subcategorías

Columnas:

- `id TEXT PRIMARY KEY`
- `name TEXT NOT NULL`
- `icon_key TEXT NOT NULL DEFAULT 'category'`
- `scope TEXT NOT NULL`
- `parent_id TEXT`
- `is_default INTEGER NOT NULL DEFAULT 0`
- `reminder_enabled INTEGER NOT NULL DEFAULT 0`
- `reminder_day INTEGER`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`

Notas:

- `parent_id != null` identifica subcategorías
- recordatorios mensuales de gastos salen de subcategorías de gasto

### `savings_goals`

Propósito:

- metas de ahorro y su configuración de recordatorios

Columnas:

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

Propósito:

- ingresos, gastos y aportes de ahorro

Columnas:

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

Notas:

- `payment_method` guarda el label canonicalizado del medio de pago
- `subcategory_id` vincula una subcategoría si corresponde
- `goal_id` se usa para movimientos de tipo `saving`
- `monthly_reminder_enabled` y `reminder_day` siguen existiendo por legado de esquema, pero la UI actual de recordatorios deriva recordatorios desde subcategorías y metas, no desde movimientos

### `budgets`

Propósito:

- un presupuesto mensual por categoría de gasto

Columnas:

- `id TEXT PRIMARY KEY`
- `category_id TEXT NOT NULL`
- `monthly_limit REAL NOT NULL CHECK (monthly_limit >= 0)`
- `month TEXT NOT NULL`

Restricción:

- índice único en `(category_id, month)`

### `app_settings`

Propósito:

- preferencias globales persistidas de la app

Columnas:

- `id INTEGER PRIMARY KEY CHECK (id = 1)`
- `currency_code TEXT NOT NULL`
- `currency_symbol TEXT NOT NULL`
- `show_sensitive_amounts INTEGER NOT NULL DEFAULT 1`
- `theme_mode TEXT NOT NULL`
- `biometric_enabled INTEGER NOT NULL DEFAULT 0`
- `auto_lock_minutes INTEGER NOT NULL DEFAULT 5`
- `locale_code TEXT NOT NULL DEFAULT 'es'`
- `payment_methods TEXT NOT NULL`

Notas:

- se inicializa con una única fila `id = 1`
- `biometric_enabled` es la fuente de verdad persistida para la preferencia de biometría
- `payment_methods` guarda una lista JSON de labels visibles/canonicalizados

## Relaciones

Relaciones lógicas actuales:

- `movements.category_id -> categories.id`
- `movements.goal_id -> savings_goals.id`
- `budgets.category_id -> categories.id`

Delete behavior para instalaciones nuevas:

- categoría: `ON DELETE RESTRICT`
- meta de ahorro: `ON DELETE SET NULL` en `movements.goal_id`

Referencia:

- [`lib/core/database/schema_relationships.md`](D:/GITHUB/CleanFinance/lib/core/database/schema_relationships.md)

## Migraciones actuales

### Version 2

- agrega `locale_code` a `app_settings`
- agrega `payment_methods` a `app_settings`

### Version 3

- crea tabla `budgets`
- crea índices de presupuestos

### Version 4

- agrega `show_sensitive_amounts` a `app_settings`

### Version 5

- agrega `monthly_reminder_enabled` y `reminder_day` a `movements`
- crea índice relacionado a recordatorios de movimientos

### Version 6

- agrega `reminder_enabled` y `reminder_day` a `categories`
- agrega `reminder_enabled` y `reminder_day` a `savings_goals`

### Version 7

- agrega `icon_key` a `categories`

## Seed actual

`LocalFinanceRepository.ensureSeedData()` usa `DefaultCategoriesSeed`.

Scopes seed actuales:

- income
- expense
- saving

Ejemplos:

- ingresos: `Sueldo`, `Freelance`, `Venta`
- ahorro: `Ahorro general`, `Fondo de emergencia`, `Viaje`
- gastos con subcategorías extensas: `Hogar`, `Servicios`, `Alimentos`, `Transporte`, `Salud`, `Educación`, `Compras`, `Ocio`, `Finanzas`, `Familia`, `Trabajo`, `Otros`

Cada categoría y subcategoría seeded tiene `iconKey`.

## Persistencia y repositorios

Persistencia concreta actual:

- `LocalFinanceRepository` maneja movimientos, categorías, metas, settings, backup y reportes
- `LocalBudgetRepository` maneja presupuestos

Implicancia:

- no debería accederse a SQLite desde pantallas o widgets
- el hardening de validaciones, import/export y saneamiento se concentra en esos repositorios

Patrones:

- `db.insert`, `db.update`, `db.delete`, `db.query`
- `rawQuery` para agregados y reportes
- mapeo manual desde `Map<String, Object?>`

## Backup e importación

El backup exporta:

- `categories`
- `movements`
- `savings_goals`
- `budgets`
- `app_settings`

La importación:

- borra esas tablas
- re-inserta los datos importados
- recrea settings default si el backup no trae `app_settings`
- limpia el flag legacy de biometría en secure storage

Seguridad actual del backup:

- si no se elige contraseña, el backup sigue siendo JSON plano
- opcionalmente puede exportarse/importarse como JSON cifrado con contraseña

## Fechas

Las fechas se guardan como strings ISO-8601.

El helper de contexto mensual actual es:

- `lib/core/utils/month_context.dart`
