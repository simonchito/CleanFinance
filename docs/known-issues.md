# Known Issues

## Scope

Este documento lista límites, riesgos y puntos abiertos observables en el código actual del repo. No describe ideas hipotéticas de producto.

## Issues actuales

## 1. La privacidad de montos no se aplica de forma global

`showSensitiveAmounts` existe y el dashboard usa `AmountVisibilityFormatter`, pero varias pantallas todavía renderizan montos directamente con `CurrencyFormatter`.

Ejemplos actuales:

- `ReportsScreen`
- `MovementsScreen`
- `SavingsScreen`
- vistas de presupuestos

Impacto:

- la preferencia de privacidad no funciona todavía como ocultamiento global consistente

## 2. El esquema mantiene campos legacy de recordatorios en `movements`

La estrategia activa de recordatorios usa:

- subcategorías de gasto
- metas de ahorro

Pero el esquema y la entidad `Movement` todavía tienen:

- `monthly_reminder_enabled`
- `reminder_day`

Impacto:

- hay conceptos de recordatorio duplicados a nivel modelo/esquema
- hoy esos campos no son la fuente principal del flujo de recordatorios

## 3. La paridad física de esquema puede variar entre instalaciones nuevas y migradas

La app evita rebuilds destructivos de SQLite durante migraciones.

Impacto:

- instalaciones nuevas reciben el esquema más reforzado
- instalaciones antiguas pueden conservar diferencias físicas de schema
- la capa repositorio compensa parte de eso con validaciones defensivas

## 4. La navegación sigue descentralizada

La app usa `Navigator.push(...)` directamente desde múltiples pantallas.

Impacto:

- simple de seguir hoy
- menos centralizado para auditar o refactorizar a futuro

## 5. `LocalFinanceRepository` concentra varias responsabilidades

Actualmente implementa:

- `FinanceRepository`
- `MovementsRepository`
- `CategoriesRepository`
- `SavingsGoalsRepository`
- `SettingsRepository`
- `BackupRepository`

Impacto:

- menos ceremonia
- más acoplamiento de persistencia en una sola clase

## 6. Los settings cargan de forma asíncrona al inicio

`CleanFinanceApp` lee `settingsControllerProvider`, que resuelve asíncronamente.

Impacto:

- algunas preferencias pueden depender de defaults transitorios durante el arranque
- theme y locale no son estrictamente síncronos en el primer frame

## 7. El soporte real de Web/Desktop sigue sin validación cerrada

El repo incluye carpetas para esas plataformas, pero el runtime usa plugins pensados principalmente para mobile.

Estado:

- soporte real pendiente de validación por entorno

## 8. Varias eliminaciones siguen siendo directas desde UI

Ejemplos:

- movimientos
- metas
- medios de pago

Impacto:

- flujo rápido y simple
- confirmaciones y undo no están unificados en toda la app

## Límites deliberados del proyecto actual

- no hay backend
- no hay sync cloud
- no hay router declarativo
- no hay crash reporting remoto
- no hay cifrado de base SQLite

## Puntos abiertos

## 1. Tooling en `tool/`

Existe `tool/`, pero no es parte del flujo principal de runtime documentado.

## 2. Firma y distribución release

El repo permite builds, pero no documenta signing, CI/CD ni publicación en stores.

## 3. Validación multi-plataforma de biometría

El flujo móvil está contemplado, pero el comportamiento fuera de Android/iOS sigue pendiente de validación real.

## Seguimientos razonables

- unificar privacidad de montos en todas las pantallas
- decidir si los campos legacy de recordatorio en `movements` se eliminan o reutilizan
- revisar si `LocalFinanceRepository` necesita partirse si el producto sigue creciendo
- documentar plataformas realmente testeadas cuando esa validación exista
