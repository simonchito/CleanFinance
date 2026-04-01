# Screens

## Navigation Overview

The app uses imperative navigation with `Navigator` and `MaterialPageRoute`.

High-level flow:

```text
main.dart
  -> CleanFinanceApp
    -> AuthGateScreen
      -> SetupPinScreen | UnlockScreen | HomeShell

HomeShell tabs
  -> DashboardScreen
  -> MovementsScreen
  -> SavingsScreen
  -> ReportsScreen
  -> SettingsScreen
```

Additional screens are pushed from those main tabs.

## Authentication Screens

### `AuthGateScreen`

Purpose:

- reads auth state and selects the correct startup screen

Possible destinations:

- `SetupPinScreen`
- `UnlockScreen`
- `HomeShell`

### `SetupPinScreen`

Purpose:

- first-time setup of PIN, recovery answers, and optional biometrics

Main actions:

- enter PIN and confirmation
- enter birth date and document as recovery data
- optionally enable biometrics
- start the app

### `UnlockScreen`

Purpose:

- unlock access with PIN or biometrics

Main actions:

- enter PIN
- attempt biometric authentication automatically if enabled
- open recovery flow when recovery data exists

Navigation:

- pushes `RecoverAccessScreen`

### `RecoverAccessScreen`

Purpose:

- reset access using recovery answers and a new PIN

Main actions:

- enter birth date
- enter document
- enter and confirm new PIN
- optionally enable biometrics again

## Main Shell

### `HomeShell`

Purpose:

- hosts the primary app tabs with an `IndexedStack`
- handles app lifecycle auto-lock behavior

Tabs:

- Dashboard
- Movements
- Savings
- Reports
- Settings

## Finance Screens

### `DashboardScreen`

Purpose:

- show the main monthly financial summary and quick actions

Main content:

- current balance
- income, expense, movement count, and savings chips
- end-of-month projection
- pending monthly reminders
- insights
- income vs expense visual
- monthly trend
- top expense categories
- recent movements

Navigation:

- pushes `MovementFormScreen` for quick add
- pushes `MovementFormScreen` prefilled from a reminder card

### `MovementsScreen`

Purpose:

- list registered movements and provide search/filter/edit/delete actions

Main actions:

- filter by type
- filter by category and date range
- search by note
- open editor
- delete movement

Navigation:

- pushes `MovementFormScreen`
- pushes `CategoriesScreen`

### `MovementFormScreen`

Purpose:

- create or edit a movement

Supported movement types:

- income
- expense
- saving

Main fields:

- type
- amount
- category
- subcategory
- saving goal when type is saving
- date
- payment method
- note

### `SavingsScreen`

Purpose:

- show savings goals, progress, totals, and quick contribution actions

Main actions:

- create goal
- edit goal
- delete goal
- register a saving contribution for a goal

Navigation:

- pushes `SavingsGoalFormScreen`
- pushes `MovementFormScreen` prefilled as a saving contribution

### `SavingsGoalFormScreen`

Purpose:

- create or edit a savings goal

Main fields:

- goal name
- target amount
- target date
- monthly reminder toggle
- reminder day

### `ReportsScreen`

Purpose:

- present derived analytics and monthly reports

Main sections:

- financial health score
- cashflow summary
- monthly trend
- category comparison
- spending pace
- savings goal forecasts
- payment-method breakdown
- insights list

### `SettingsScreen`

Purpose:

- manage app preferences, security settings, organization tools, and local data operations

Main sections:

- appearance
- security
- organization
- data management

Navigation:

- pushes `PaymentMethodsScreen`
- pushes `ManageRemindersScreen`
- pushes `CategoriesScreen`
- pushes `BudgetsScreen`

### `CategoriesScreen`

Purpose:

- manage categories and subcategories grouped by scope

Tabs:

- income
- expense
- saving

Main actions:

- create category
- edit category
- delete category
- create subcategory

Reminder-specific behavior:

- expense subcategories can enable monthly reminders and choose a reminder day

### `ManageRemindersScreen`

Purpose:

- centralized management of active monthly reminders

Sections:

- expense reminders from expense subcategories
- savings reminders from savings goals

Main actions:

- edit reminder day
- disable reminder

### `PaymentMethodsScreen`

Purpose:

- manage the list of payment methods available in movement forms

Main actions:

- add payment method
- edit payment method
- delete payment method

## Budget Screens

### `BudgetsScreen`

Purpose:

- show the current month’s category budget statuses

Main actions:

- create budget
- refresh budget statuses
- open existing budget for editing

Navigation:

- pushes `BudgetFormScreen`

### `BudgetFormScreen`

Purpose:

- create or update the monthly budget for one expense category

Main fields:

- current month
- expense category
- monthly limit

Notes:

- category cannot be changed when editing an existing budget

## Navigation Notes

- there is no route registry or declarative router in the current project
- back navigation is handled with the default `Navigator.pop(...)`
- nested dialogs and bottom sheets are used for filters and reminder day editing
