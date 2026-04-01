# Architecture

## Overview

CleanFinance is a Flutter application with a local-first personal finance scope. The codebase is organized mainly by feature and uses Riverpod for dependency injection and state management.

Runtime entry flow:

1. `lib/main.dart` starts the app inside `AppErrorHandler.run(...)`.
2. `ProviderScope` exposes repositories, services, controllers, and screen-level providers.
3. `CleanFinanceApp` reads persisted settings to configure theme and locale.
4. `AuthGateScreen` decides whether the user sees setup, unlock, or the main shell.
5. `HomeShell` hosts the main finance experience through a bottom navigation shell.

## Layers

The repository follows a lightweight clean architecture style with three recurring layers.

### Data

The data layer contains concrete persistence and integration code.

Examples:

- `lib/core/database/app_database.dart`
- `lib/features/auth/data/local_auth_repository.dart`
- `lib/features/finance/data/local_finance_repository.dart`
- `lib/features/budgets/data/repositories/local_budget_repository.dart`

Responsibilities:

- open and migrate the SQLite database
- read and write secure storage values
- map raw storage rows to domain entities
- implement repository interfaces used by upper layers

### Domain

The domain layer contains entities, repository contracts, and pure services.

Examples:

- entities: `movement.dart`, `category.dart`, `savings_goal.dart`, `app_settings.dart`
- repository contracts: `auth_repository.dart`, `movements_repository.dart`, `budget_repository.dart`
- services: `monthly_trend_service.dart`, `budget_service.dart`, `monthly_payment_reminder_service.dart`

Responsibilities:

- represent business data
- define contracts between UI and persistence
- encapsulate derived calculations and business rules

### Presentation

The presentation layer contains screens, widgets, controllers, mappers, and feature providers.

Examples:

- auth screens under `lib/features/auth/presentation/screens/`
- finance screens under `lib/features/finance/presentation/screens/`
- budget screens under `lib/features/budgets/presentation/screens/`

Responsibilities:

- build widgets and screen flows
- trigger repository calls through providers/controllers
- render derived state from providers
- keep UI-specific logic close to the view

## Feature Organization

Main runtime features currently present:

- `auth`
- `finance`
- `budgets`

The `finance` feature is the largest one and contains dashboard, movements, categories, savings goals, reminders, reports, settings, and supporting UI widgets.

## State Management Pattern

Riverpod is used in two main ways:

- global dependency providers in `lib/shared/providers.dart`
- feature-scoped providers in each presentation module

Patterns detected:

- `Provider` for repositories and stateless domain services
- `StateNotifierProvider` for auth and settings controllers
- `FutureProvider` and `FutureProvider.family` for async screen data
- `StateProvider` for small presentation/session overrides

## Navigation Pattern

Navigation is imperative and screen-based:

- `MaterialPageRoute`
- `Navigator.push(...)`
- `Navigator.pop(...)`

There is no dedicated router package in the current codebase.

## General App Flow

### Bootstrap and Authentication

- `AuthController.bootstrap()` checks whether a credential exists, whether biometrics are available, whether biometric login is enabled, and whether recovery data exists.
- Depending on that result, the app routes to `SetupPinScreen`, `UnlockScreen`, or `HomeShell`.

### Main Finance Shell

`HomeShell` uses an `IndexedStack` and a `NavigationBar` to keep five sections mounted:

- Dashboard
- Movements
- Savings
- Reports
- Settings

It also listens to app lifecycle events to support auto-lock behavior.

### Data Refresh Strategy

The current app relies on Riverpod invalidation after mutations. Common mutation flows call `ref.invalidate(...)` for the affected providers after saving or deleting data.

## Architectural Characteristics

### Strengths

- clear split between data access and business calculations
- repositories are injected through Riverpod, making testing simpler
- analytics and reminder rules are mostly isolated in domain services
- the app is fully local-first in its current implementation

### Current Tradeoffs

- navigation is decentralized and inferred from individual screens
- some presentation logic remains embedded directly in widgets and dialogs
- one large finance repository implements several interfaces, which keeps things simple but centralizes many responsibilities
- settings loading is asynchronous, so some startup values can briefly depend on defaults until the persisted state resolves

## Patterns in Use

- feature-based modular structure
- repository pattern
- StateNotifier-based controllers
- pure domain services for analytics and reminder calculations
- local-first persistence with SQLite and secure storage
- Provider-based dependency injection
