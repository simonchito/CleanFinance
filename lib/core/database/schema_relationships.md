# CleanFinance Database Relationships

Este archivo documenta las relaciones lógicas actuales del esquema y una limitación importante de migraciones no destructivas.

## Relaciones lógicas actuales

- `movements.category_id -> categories.id`
  - relación requerida
  - un movimiento siempre pertenece a una categoría principal
  - delete policy para instalaciones nuevas: `ON DELETE RESTRICT`

- `movements.goal_id -> savings_goals.id`
  - relación opcional
  - un movimiento de tipo `saving` puede vincularse a una meta
  - delete policy para instalaciones nuevas: `ON DELETE SET NULL`

- `budgets.category_id -> categories.id`
  - relación requerida
  - cada presupuesto mensual pertenece a una categoría de gasto
  - delete policy para instalaciones nuevas: `ON DELETE RESTRICT`

## Nota importante de migraciones

- las bases existentes no se reconstruyen de forma destructiva
- SQLite no agrega foreign keys retroactivamente sin rebuild de tabla
- instalaciones nuevas reciben el esquema reforzado más reciente
- instalaciones antiguas pueden conservar diferencias físicas de schema
- la capa repositorio mantiene validaciones defensivas para reducir diferencias de comportamiento
