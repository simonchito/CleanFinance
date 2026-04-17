# Architecture

## Overview

CleanFinance es una app Flutter local-first de finanzas personales. El código actual está organizado por features y usa Riverpod tanto para inyección de dependencias como para orquestación de estado.

Flujo principal de runtime:

1. `lib/main.dart` arranca la app dentro de `AppErrorHandler.run(...)`.
2. `ProviderScope` expone infraestructura, repositorios, servicios y controllers.
3. `CleanFinanceApp` lee settings persistidos para theme y locale.
4. `AuthGateScreen` decide entre setup, unlock o shell principal.
5. `HomeShell` mantiene las cinco secciones principales con `IndexedStack`.

## Capas reales

El proyecto sigue una clean architecture liviana y pragmática.

### Data

Responsabilidad:

- persistencia SQLite
- acceso a secure storage
- integración con plugins nativos
- mapeo entre filas/valores crudos y entidades de dominio

Archivos principales:

- `lib/core/database/app_database.dart`
- `lib/features/auth/data/local_auth_repository.dart`
- `lib/features/finance/data/local_finance_repository.dart`
- `lib/features/budgets/data/repositories/local_budget_repository.dart`

### Domain

Responsabilidad:

- entidades
- contratos de repositorio
- servicios puros de negocio y analítica

Ejemplos:

- `movement.dart`
- `category.dart`
- `app_settings.dart`
- `monthly_payment_reminder_service.dart`
- `budget_service.dart`
- `payment_method_report_service.dart`

### Presentation

Responsabilidad:

- pantallas
- widgets reutilizables
- controllers
- providers de lectura
- mappers orientados a UI

Ejemplos:

- `features/auth/presentation/`
- `features/finance/presentation/`
- `features/budgets/presentation/`

## Organización por features

Features de runtime actuales:

- `auth`
- `finance`
- `budgets`

`finance` concentra la mayor parte del producto: dashboard, movimientos, categorías, ahorro, recordatorios, reportes, settings, backup y medios de pago.

## Wiring e inyección de dependencias

`lib/shared/providers.dart` es el punto de composición principal.

Expone:

- `AppDatabase`
- `SecureStorageService`
- `PasswordHasher`
- `BiometricService`
- repositorios concretos
- servicios de dominio stateless

Patrones usados en Riverpod:

- `Provider` para infraestructura, repositorios y servicios puros
- `StateNotifierProvider` para `AuthController` y `SettingsController`
- `FutureProvider` y `FutureProvider.family` para lectura asíncrona de datos
- `StateProvider` para overrides pequeños de sesión, como privacidad de montos

## Flujo de autenticación

`AuthController.bootstrap()`:

- verifica si existe credencial local
- verifica disponibilidad de biometría
- lee la preferencia persistida de biometría
- verifica si hay datos de recuperación

Resultado:

- `setupRequired` si no hay PIN
- `locked` si ya existe credencial
- `unlocked` cuando el usuario valida PIN o biometría

## Flujo principal de la app

`HomeShell` mantiene montadas cinco tabs:

- Dashboard
- Movements
- Savings
- Reports
- Settings

También escucha el lifecycle para aplicar auto-lock según `autoLockMinutes`.

## Persistencia

Persistencia actual:

- SQLite para datos de negocio y preferencias de app
- secure storage para PIN y datos de recuperación

Fuente de verdad actual de biometría:

- `app_settings.biometric_enabled`

Secure storage mantiene una clave legacy de biometría solo para compatibilidad/migración de instalaciones previas; el comportamiento actual usa settings.

## Patrón de escritura

El proyecto no usa una capa formal de use cases para todas las mutaciones.

Patrón actual:

- algunas escrituras pasan por controllers (`AuthController`, `SettingsController`)
- otras escrituras llaman repositorios directamente desde pantallas
- después de mutar, las pantallas invalidan providers dependientes

## Características y tradeoffs actuales

Fortalezas:

- estructura simple de seguir
- separación clara entre persistencia y lógica derivada
- app completamente local-first
- servicios de dominio aislados para analítica, presupuestos y recordatorios

Tradeoffs:

- navegación distribuida por pantalla con `Navigator`
- `LocalFinanceRepository` concentra muchas responsabilidades
- varias pantallas invalidan providers manualmente después de guardar
- carga asíncrona de settings al inicio, con algunos defaults transitorios hasta que resuelve
