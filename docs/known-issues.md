# Known Issues

## Scope of This File

This document lists technical risks, limitations, and open points inferred directly from the current repository state.

Items are not speculative product ideas; they reflect code-level observations.

## Current Issues and Limitations

## 1. Amount privacy is not applied consistently across all screens

The project stores and reads `showSensitiveAmounts`, and the dashboard uses `AmountVisibilityFormatter`, but several screens still format amounts directly with `CurrencyFormatter`.

Examples detected:

- `DashboardScreen` respects amount visibility
- `ReportsScreen` renders values directly with `CurrencyFormatter`
- `MovementsScreen` renders values directly with `CurrencyFormatter`
- `SavingsScreen` renders values directly with `CurrencyFormatter`
- budget-related screens and widgets also render amounts directly

Impact:

- the privacy setting is not a guaranteed global concealment mechanism in the current codebase

## 2. Legacy reminder fields still exist on `movements`

The current reminder design derives reminders from:

- expense subcategories
- savings goals

However, the `movements` table and `Movement` entity still include:

- `monthly_reminder_enabled`
- `reminder_day`

Impact:

- duplicated reminder-related schema concepts remain in the codebase
- those fields appear to be legacy or transitional in the current implementation

## 3. Migration safety differs between new installs and older databases

The repository explicitly documents that older SQLite databases are not rebuilt just to add foreign keys.

Impact:

- schema enforcement may differ between new users and migrated users
- repository logic compensates, but physical schema parity is not guaranteed

## 4. Navigation is decentralized

Navigation uses direct `Navigator.push(...)` calls from many screens.

Impact:

- route flow is easy to follow locally
- harder to centralize, audit, or refactor globally

Status:

- acceptable for the current app size
- may become a maintenance issue as screen count grows

## 5. One finance repository handles many responsibilities

`LocalFinanceRepository` implements multiple interfaces:

- `FinanceRepository`
- `MovementsRepository`
- `CategoriesRepository`
- `SavingsGoalsRepository`
- `SettingsRepository`
- `BackupRepository`

Impact:

- simple dependency graph
- but concentrated persistence logic in a single class

## 6. Settings load asynchronously at startup

`CleanFinanceApp` reads settings from `settingsControllerProvider`, which loads asynchronously.

Impact:

- startup behavior can briefly depend on defaults until settings finish loading
- some preferences are therefore sensitive to initial-frame timing

Amount visibility already has a privacy-first fallback, but theme and locale still depend on async resolution timing.

## 7. Web support is not clearly implemented

The repository includes a `web/` directory, but the runtime code uses local-auth, secure-storage, and SQLite-oriented infrastructure without explicit web-specific fallbacks in the reviewed source.

Status:

- web support is not determined from the current code

## 8. Delete flows are mostly direct

Several delete actions call repositories immediately from the UI.

Examples:

- deleting movements
- deleting savings goals
- deleting payment methods

Impact:

- behavior is simple and fast
- confirmation and undo patterns are not consistently present

## 9. Router, remote sync, and crash reporting are not implemented

Not detected in the current repository:

- declarative routing package
- backend API integration
- cloud sync
- remote crash analytics

This is not a defect by itself, but it is an important boundary for future planning.

## 10. Some repository interfaces are very coarse-grained

The current repository contracts are pragmatic, but some feature boundaries are still broad.

Example:

- settings, backup, categories, movements, reports, and seed data are all partly coordinated through the same finance persistence layer

Impact:

- lower ceremony today
- harder extraction into independent modules later

## Open Points / Not Determined

## 1. Tooling under `tool/`

The repository contains a `tool/` directory, but its runtime role was not determined from the reviewed files.

## 2. Distribution signing and release process

The codebase and `pubspec.yaml` allow builds, but keystore signing, CI/CD, and store distribution setup are not documented in the runtime source.

## 3. Platform-specific biometric behavior beyond Android and iOS

The app checks for biometric availability, but cross-platform behavior outside primary mobile flows remains pending verification.

## Suggested Technical Follow-Ups

- unify amount privacy so all monetary widgets go through the same visibility-aware formatter
- remove or repurpose legacy movement-level reminder fields if they are no longer part of the product model
- consider splitting `LocalFinanceRepository` if feature growth continues
- introduce a routing strategy if the screen graph expands further
- document tested target platforms explicitly once runtime validation is complete
