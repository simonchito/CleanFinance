# State Management

## Riverpod Usage Overview

CleanFinance uses `flutter_riverpod` as the primary state and dependency management solution.

The current design combines:

- infrastructure providers
- repository providers
- domain service providers
- feature-specific asynchronous providers
- `StateNotifier` controllers for auth and settings
- a small `StateProvider` for amount visibility session override

## Provider Layers

## 1. Shared Dependency Providers

Defined in `lib/shared/providers.dart`.

These providers create and expose:

- `AppDatabase`
- `SecureStorageService`
- `PasswordHasher`
- `BiometricService`
- repository implementations
- stateless domain services

This is the dependency injection root of the app.

## 2. Feature Controllers

### `authControllerProvider`

Type:

- `StateNotifierProvider<AuthController, AuthState>`

Responsibilities:

- startup auth bootstrap
- PIN creation and verification
- biometric unlock
- access recovery
- auto-lock state transitions

### `settingsControllerProvider`

Type:

- `StateNotifierProvider<SettingsController, AsyncValue<AppSettings>>`

Responsibilities:

- load persisted settings
- update theme, locale, currency, payment methods
- update privacy and security-related settings

## 3. Async Screen Data Providers

Main finance providers in `finance_providers.dart`:

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

Budget provider:

- `categoryBudgetStatusProvider`

## 4. Session/UI-Specific Provider

### `showSensitiveAmountsOverrideProvider`

Type:

- `StateProvider<bool?>`

Purpose:

- provide a session-level override for amount visibility without changing the persisted preference every time

## Derived State Flow

### Authentication Flow

```text
authControllerProvider
  -> AuthController.bootstrap()
  -> AuthState
  -> AuthGateScreen
```

The UI watches `AuthState.status` and switches screens accordingly.

### Settings Flow

```text
settingsRepositoryProvider
  -> SettingsController
  -> settingsControllerProvider
  -> widgets read AsyncValue<AppSettings>
```

`showSensitiveAmountsProvider` combines:

- session override from `showSensitiveAmountsOverrideProvider`
- persisted settings from `settingsControllerProvider`
- privacy-first fallback while settings are still loading

### Finance Overview Flow

`financeOverviewProvider` is the main aggregation provider for dashboard and reports.

It orchestrates:

- movements repository
- savings goals repository
- analytics domain services

Outputs combined data for:

- dashboard summary blocks
- reports
- charts
- insights
- projections

### Reminder Flow

`monthlyDueRemindersProvider` currently:

1. loads expense categories
2. loads savings goals
3. loads current-month movements
4. passes all of that into `MonthlyPaymentReminderService`

This keeps reminder rules out of widgets.

## Mutation Pattern

The current project does not use a centralized command bus or dedicated use-case layer for write operations. Instead:

- screens call repository methods directly or via controllers
- after mutations, screens invalidate dependent providers

Examples:

- movement save invalidates overview, summaries, recent movements, reports, reminders, and budget status
- savings goal save invalidates goal and reminder providers
- category edits invalidate categories, reminders, and finance overview

## Thin vs Thick Providers

### Thin Providers

Many providers are thin orchestration wrappers around repositories or services.

Examples:

- `monthlyDueRemindersProvider`
- `categoryBudgetStatusProvider`
- `dashboardSummaryProvider`

### Rich Aggregation Provider

`financeOverviewProvider` is intentionally richer and composes several services into a single UI-oriented model.

## Relationship Between UI and Logic

### UI Layer

Screens typically:

- watch async providers
- render `loading / data / error`
- invoke repositories/controllers on user actions
- invalidate providers after writes

### Business Logic Layer

Business rules live mainly in:

- `AuthController`
- `SettingsController`
- domain services such as `BudgetService` and `MonthlyPaymentReminderService`

## Observed Tradeoffs

- Riverpod usage is straightforward and easy to follow
- provider invalidation is explicit, but can become repetitive
- some screen actions still call repositories directly rather than through dedicated application services
- there is no offline sync queue or event sourcing; the state source of truth is local storage plus derived providers
