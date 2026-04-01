# Features

## Overview

The current repository implements three main runtime features:

- Authentication
- Finance
- Budgets

The budgets feature is separated from finance at the folder level but is functionally integrated into the overall app flow.

## Authentication

### Purpose

Protect local financial data behind a PIN-based lock screen, with optional biometric unlock and a recovery flow.

### Responsibilities

- initial app gatekeeping
- PIN creation
- PIN verification
- biometric unlock
- recovery questions and PIN reset
- auto-lock on app resume after a configured inactivity window

### Main Files

- `lib/features/auth/presentation/auth_controller.dart`
- `lib/features/auth/presentation/auth_state.dart`
- `lib/features/auth/presentation/providers/auth_providers.dart`
- `lib/features/auth/data/local_auth_repository.dart`

### Screens

- `AuthGateScreen`
- `SetupPinScreen`
- `UnlockScreen`
- `RecoverAccessScreen`

### Main Logic

- `AuthController.bootstrap()` decides the initial auth state
- `createPin(...)` stores hashed credentials and recovery data
- `unlockWithPin(...)` and `unlockWithBiometrics()` unlock the app
- `recoverAccess(...)` validates recovery answers and updates the PIN
- `onPaused()` / `onResumed(...)` implement auto-lock timing

## Finance

### Purpose

Provide the main product experience for registering finances and reviewing the current state of money, savings, reminders, and reports.

### Responsibilities

- dashboard summary
- movement creation and edition
- category and subcategory management
- savings goal management
- monthly reminder management
- reports and analytics
- settings, backup, import, export, and payment methods

### Main Screens

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

### Main Providers

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

### Main Domain Services

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

### Purpose

Let users define monthly spending limits per expense category and track the current status of each budget.

### Responsibilities

- create and update category budgets
- validate uniqueness per category and month
- calculate spending vs limit
- classify budget status (`normal`, `warning`, `exceeded`)

### Main Files

- `lib/features/budgets/data/repositories/local_budget_repository.dart`
- `lib/features/budgets/domain/services/budget_service.dart`
- `lib/features/budgets/presentation/providers/budget_providers.dart`

### Screens

- `BudgetsScreen`
- `BudgetFormScreen`

### Main Logic

- `LocalBudgetRepository` persists monthly budget rows
- `BudgetService.getCategoryBudgetStatuses(...)` joins budgets, expense categories, and current-month expense movements
- `categoryBudgetStatusProvider` exposes the computed list to the UI

## Feature Cross-Cutting Concerns

### Settings

Settings are implemented inside the finance feature, not as a standalone module.

Current responsibilities:

- locale
- theme preference
- currency
- amount visibility preference
- biometric setting mirror
- auto-lock minutes
- payment methods

### Monthly Reminders

Reminders are not stored as standalone records.

Current source of truth:

- expense reminders come from expense subcategories
- savings reminders come from savings goals

The dashboard only shows reminders currently due for the month according to `MonthlyPaymentReminderService`.

### Backup and Restore

Backup is implemented through the finance repository:

- export all local tables to JSON
- import JSON into SQLite
- reset local data

There is no cloud sync implementation in the current repository.
