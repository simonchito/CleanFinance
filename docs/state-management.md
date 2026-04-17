# State Management

## Overview

CleanFinance usa `flutter_riverpod` para dos cosas principales:

- inyección de dependencias
- lectura y derivación de estado de la app

La estructura actual combina:

- providers de infraestructura compartida
- providers de repositorios
- providers de servicios de dominio
- controllers con `StateNotifier`
- providers asíncronos por pantalla

## 1. Shared dependency providers

Definidos en:

- `lib/shared/providers.dart`

Exponen:

- `AppDatabase`
- `SecureStorageService`
- `PasswordHasher`
- `BiometricService`
- repositorios concretos
- servicios de dominio stateless

Este archivo funciona como root de composición del proyecto.

## 2. Controllers

### `authControllerProvider`

Tipo:

- `StateNotifierProvider<AuthController, AuthState>`

Responsabilidades:

- bootstrap inicial de auth
- alta de PIN
- desbloqueo por PIN
- desbloqueo biométrico
- recuperación
- cambios de estado lock/unlock
- auto-lock por lifecycle

### `settingsControllerProvider`

Tipo:

- `StateNotifierProvider<SettingsController, AsyncValue<AppSettings>>`

Responsabilidades:

- cargar settings persistidos
- actualizar locale, theme y moneda
- actualizar privacidad de montos
- actualizar biometría
- actualizar auto-lock
- actualizar medios de pago

## 3. Async screen providers

Principales en `finance_providers.dart`:

- `dashboardSummaryProvider`
- `recentMovementsProvider`
- `categoriesProvider`
- `movementsProvider`
- `savingsGoalsProvider`
- `reportsSnapshotProvider`
- `monthlyDueRemindersProvider`
- `expenseReminderSubcategoriesProvider`
- `savingsGoalRemindersProvider`
- `endOfMonthProjectionProvider`
- `financeOverviewProvider`

En budgets:

- `categoryBudgetStatusProvider`

## 4. Session/UI provider

### `showSensitiveAmountsOverrideProvider`

Tipo:

- `StateProvider<bool?>`

Uso:

- override de sesión para la privacidad de montos sin reescribir inmediatamente la preferencia persistida en cada interacción

## Flujos derivados

### Auth flow

```text
authControllerProvider
  -> AuthController.bootstrap()
  -> AuthState
  -> AuthGateScreen
```

La UI observa `AuthState.status` y decide pantalla.

### Settings flow

```text
settingsRepositoryProvider
  -> SettingsController
  -> settingsControllerProvider
  -> widgets leen AsyncValue<AppSettings>
```

`showSensitiveAmountsProvider` combina:

- override de sesión
- valor persistido en settings
- fallback privacy-first mientras settings cargan

### Finance overview flow

`financeOverviewProvider` es el provider agregado principal para dashboard y reportes.

Combina:

- repositorio de movimientos
- repositorio de metas
- varios servicios de dominio de analítica

Produce:

- summary
- cashflow
- trend
- comparison
- pace
- projection
- reports
- payment method report
- insights

### Reminder flow

`monthlyDueRemindersProvider`:

1. carga subcategorías de gasto
2. carga metas de ahorro
3. carga movimientos del mes
4. delega reglas a `MonthlyPaymentReminderService`

## Patrón de mutación actual

El proyecto no centraliza todas las escrituras en una capa de use cases.

Patrón visible:

- algunas acciones usan controllers
- otras llaman repositorios desde la pantalla
- luego invalidan providers afectados

Ejemplos:

- guardar movimiento invalida overview, listados, reportes, reminders y budgets
- guardar categorías invalida categorías, reminders, overview y budget status
- guardar settings actualiza el `AsyncValue<AppSettings>` en el controller

## Tradeoffs

- Riverpod se usa de forma directa y fácil de seguir
- la invalidación manual es explícita pero repetitiva
- hay mezcla deliberada entre controllers y llamadas directas a repositorios según el flujo
- la fuente de verdad sigue siendo almacenamiento local más providers derivados
