# Features

## Overview

El runtime actual del repo implementa tres módulos principales:

- Authentication
- Finance
- Budgets

`budgets` vive como feature separado a nivel carpetas, pero se integra funcionalmente con movimientos y categorías de gasto.

## Authentication

### Propósito

Proteger el acceso local a la app con PIN y biometría opcional, con recuperación local.

### Responsabilidades actuales

- gate inicial de la app
- alta de PIN
- validación de PIN
- desbloqueo biométrico
- recuperación de acceso
- auto-lock al volver desde background

### Componentes principales

- `AuthController`
- `AuthState`
- `LocalAuthRepository`
- `SecureStorageService`
- `BiometricService`

### Pantallas

- `AuthGateScreen`
- `SetupPinScreen`
- `UnlockScreen`
- `RecoverAccessScreen`

### Comportamiento real

- el PIN se guarda hasheado en secure storage
- fecha de nacimiento y documento también se guardan hasheados en secure storage
- la preferencia persistida de biometría se guarda en `app_settings.biometric_enabled`
- onboarding, unlock y settings usan esa misma preferencia
- si biometría no está disponible, la app vuelve a PIN sin romper el flujo

## Finance

### Propósito

Concentrar la experiencia principal de registro, seguimiento y lectura de la situación financiera local del usuario.

### Responsabilidades actuales

- dashboard
- alta, edición y borrado de movimientos
- categorías y subcategorías
- metas de ahorro
- recordatorios mensuales
- reportes
- settings
- backup/import/export
- medios de pago

### Pantallas principales

- `HomeShell`
- `DashboardScreen`
- `MovementsScreen`
- `MovementFormScreen`
- `SavingsScreen`
- `SavingsGoalFormScreen`
- `ReportsScreen`
- `SettingsScreen`
- `CategoriesScreen`
- `ManageRemindersScreen`
- `PaymentMethodsScreen`

### Providers principales

- `settingsControllerProvider`
- `showSensitiveAmountsProvider`
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

### Servicios de dominio principales

- `CashflowSnapshotService`
- `MonthlyTrendService`
- `CategoryComparisonService`
- `SpendingPaceService`
- `EndOfMonthProjectionService`
- `SavingsGoalReportService`
- `PaymentMethodReportService`
- `FinancialHealthScoreService`
- `FinanceInsightsService`
- `MonthlyPaymentReminderService`

## Budgets

### Propósito

Definir límites mensuales por categoría de gasto y calcular el estado del presupuesto en base al consumo actual.

### Responsabilidades actuales

- alta y edición de presupuestos mensuales
- unicidad por categoría y mes
- cálculo de consumo vs límite
- clasificación visual del estado del presupuesto

### Archivos principales

- `lib/features/budgets/data/repositories/local_budget_repository.dart`
- `lib/features/budgets/domain/services/budget_service.dart`
- `lib/features/budgets/presentation/providers/budget_providers.dart`

## Concerns transversales

### Settings

Settings están implementados dentro de `finance`.

Preferencias persistidas actuales:

- locale
- theme preference
- currency
- show/hide amounts
- biometric enabled
- auto-lock minutes
- payment methods

### Monthly reminders

Los recordatorios no viven como tabla independiente.

Fuentes reales:

- subcategorías de gasto con `reminderEnabled` y `reminderDay`
- metas de ahorro con `reminderEnabled` y `reminderDay`

### Payment methods

Catálogo base actual:

- `Transferencia`
- `Tarjeta débito`
- `Tarjeta crédito`
- `Efectivo`
- `QR`

Comportamiento actual:

- el formulario de movimientos usa los métodos configurados en settings
- el valor se canonicaliza con `PaymentMethodUtils`
- se persiste en `movements.payment_method`
- se ve en formulario, listados y reportes donde aporta valor

### Backup and restore

Implementado dentro de `LocalFinanceRepository`:

- exporta tablas locales a JSON
- importa JSON reemplazando datos locales
- restablece settings por default si el backup no incluye `app_settings`

No hay sync en nube ni backend en el código actual.
