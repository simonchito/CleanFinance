# CleanFinance Database Relationships

This project keeps migrations non-destructive, so foreign key enforcement is
introduced only where it is safe to do so.

## Current logical relationships

- `movements.category_id -> categories.id`
  - Required relationship.
  - Intended behavior: a movement must belong to a category.
  - Delete policy for new installs: `ON DELETE RESTRICT`.

- `movements.goal_id -> savings_goals.id`
  - Optional relationship.
  - Intended behavior: a saving movement may contribute to a savings goal.
  - Delete policy for new installs: `ON DELETE SET NULL`.

- `budgets.category_id -> categories.id`
  - Required relationship.
  - Intended behavior: each monthly budget belongs to one category.
  - Delete policy for new installs: `ON DELETE RESTRICT`.

## Important migration note

- Existing user databases are not recreated.
- Because SQLite cannot add foreign key constraints to existing tables without
  rebuilding them, older databases preserve their current schema.
- New installs receive the reinforced schema.
- The repository layer still keeps defensive deletion/import behavior so old and
  new databases behave consistently.
