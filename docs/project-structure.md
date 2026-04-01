# Project Structure

## Top-Level Structure

```text
CleanFinance/
├── android/
├── assets/
├── docs/
├── ios/
├── lib/
├── linux/
├── macos/
├── test/
├── tool/
├── web/
├── windows/
├── analysis_options.yaml
├── pubspec.yaml
└── README.md
```

## Main Source Tree

```text
lib/
├── app/
│   ├── theme/
│   ├── widgets/
│   ├── app.dart
│   └── app_strings.dart
├── core/
│   ├── constants/
│   ├── database/
│   ├── errors/
│   ├── security/
│   └── utils/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── budgets/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── finance/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── shared/
├── brand_logo_asset.dart
└── main.dart
```

## Folder Purpose

### `lib/app/`

Application-wide configuration and UI resources.

- `app.dart`: creates `MaterialApp`, theme mode, locale, and root screen
- `app_strings.dart`: app copy and localization helper logic
- `theme/`: palette and theme configuration
- `widgets/`: app-level reusable branding widgets

### `lib/core/`

Shared infrastructure and low-level utilities.

- `constants/`: application constants such as database version and defaults
- `database/`: SQLite opening, schema creation, and migrations
- `errors/`: global error capture and reporting
- `security/`: hashing, biometrics, and secure storage wrappers
- `utils/`: formatting and month/date helpers

### `lib/features/auth/`

Authentication and unlock lifecycle.

- `data/`: secure-storage-backed auth repository
- `domain/`: auth repository contract
- `presentation/`: auth controller, state, provider, and screens

### `lib/features/finance/`

Main finance product feature.

- `data/`: local repository for movements, categories, goals, settings, backup
- `domain/entities/`: finance data models
- `domain/repositories/`: repository contracts
- `domain/services/`: analytics and reminder business rules
- `presentation/controllers/`: settings controller
- `presentation/mappers/`: view-specific mapping helpers
- `presentation/models/`: composed UI model (`FinanceOverview`)
- `presentation/providers/`: Riverpod providers for finance screens
- `presentation/screens/`: main finance screens
- `presentation/widgets/`: reusable UI widgets for finance

### `lib/features/budgets/`

Monthly category budget management.

- `data/repositories/`: SQLite-backed budget repository
- `domain/models/`: budget entities and computed budget status models
- `domain/repositories/`: budget repository contract
- `domain/services/`: budget calculations and orchestration
- `presentation/providers/`: budget providers
- `presentation/screens/`: budget list and editor
- `presentation/widgets/`: reusable budget cards

### `lib/shared/`

Global Riverpod dependency wiring.

- `providers.dart`: repositories, services, and infrastructure providers shared across features

### `test/`

Automated tests currently focused on:

- budget rules
- analytics services
- reminder rules
- password hashing
- whole-amount formatting
- default Flutter widget test scaffold

## Conventions Detected

### Naming

- files use `snake_case.dart`
- classes use `PascalCase`
- providers follow a `...Provider` suffix
- controllers use the `...Controller` suffix
- domain services use the `...Service` suffix

### Layer Placement

- domain entities and contracts avoid Flutter imports
- concrete persistence lives under `data`
- most widget trees live under `presentation/screens` and `presentation/widgets`

### State Access

- shared infrastructure is defined once in `lib/shared/providers.dart`
- feature providers build on top of those dependencies
- screens read providers directly through `WidgetRef`

### Navigation

- screen transitions use `Navigator` and `MaterialPageRoute`
- navigation is local to the calling screen rather than centralized

## Notes About the Current Repository

- the repo already contains a `docs/` directory with product-oriented documents not tied to the runtime source tree
- `tool/` exists at the repository root, but its purpose is not determined from the files reviewed in this pass
