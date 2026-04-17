# CleanFinance

CleanFinance es una app Flutter de finanzas personales simple, privada y local-first. Está pensada para usuarios no profesionales que quieren registrar ingresos, gastos y ahorro sin depender de una cuenta online ni de integraciones externas.

La fuente de verdad del proyecto es el código actual del repositorio. Este README resume el estado real y deriva a la documentación técnica específica en [`docs/`](D:/GITHUB/CleanFinance/docs).

## Identidad del proyecto

- app de finanzas personales offline-first
- datos y preferencias guardados localmente en el dispositivo
- autenticación local con PIN y biometría opcional
- UI moderna y minimalista con Material 3, tarjetas redondeadas y selectores tipo bottom sheet

## Stack actual

- Flutter + Dart
- Riverpod
- SQLite con `sqflite`
- `flutter_secure_storage`
- `local_auth`
- `intl`, `google_fonts`, `file_picker`, `share_plus`, `path_provider`

## Arquitectura

El proyecto usa una estructura modular por features con separación liviana entre `data`, `domain` y `presentation`.

```text
lib/
├── app/
├── core/
├── features/
│   ├── auth/
│   ├── budgets/
│   └── finance/
├── shared/
└── main.dart
```

Resumen:

- `app/`: configuración global, theme, strings y widgets de marca
- `core/`: constantes, base de datos, seguridad, errores y utilidades compartidas
- `features/auth/`: setup de PIN, desbloqueo, biometría y recuperación
- `features/finance/`: dashboard, movimientos, categorías, ahorro, reportes, settings y backups
- `features/budgets/`: presupuestos mensuales por categoría
- `shared/providers.dart`: wiring global de dependencias, repositorios y servicios

## Funcionalidades implementadas

### Seguridad

- alta inicial de PIN de 6 dígitos
- recuperación con fecha de nacimiento y documento
- desbloqueo por biometría cuando el dispositivo lo soporta y la preferencia está habilitada
- auto-lock al volver desde background según el tiempo configurado

### Finanzas

- alta y edición de ingresos, gastos y movimientos de ahorro
- categorías y subcategorías con `iconKey`
- metas de ahorro
- presupuestos mensuales por categoría
- medios de pago configurables
- recordatorios mensuales derivados de subcategorías de gasto y metas de ahorro
- dashboard con resumen mensual, proyección, insights y recordatorios
- reportes por cashflow, categorías, ritmo de gasto, metas y medios de pago
- exportación e importación local en JSON

## Flujo actual de seguridad

- el PIN y los datos de recuperación viven en secure storage
- la preferencia persistida de biometría vive en `app_settings.biometric_enabled`
- onboarding, desbloqueo y Ajustes usan la misma preferencia persistida
- si biometría no está disponible, la app degrada a PIN sin romper la UI

## Flujo actual de movimientos

Cada movimiento persiste:

- tipo: `income`, `expense`, `saving`
- monto
- categoría principal
- subcategoría opcional
- meta de ahorro opcional si el tipo es `saving`
- fecha
- nota opcional
- medio de pago opcional

Los medios de pago base actuales son:

- `Transferencia`
- `Tarjeta débito`
- `Tarjeta crédito`
- `Efectivo`
- `QR`

## Ejecutar el proyecto

Instalar dependencias:

```bash
flutter pub get
```

Ejecutar:

```bash
flutter run
```

Análisis estático:

```bash
flutter analyze
```

Tests:

```bash
flutter test
```

Build Android:

```bash
flutter build apk --release
flutter build appbundle --release
```

## Plataformas

Estado que se puede afirmar desde el código actual:

- Android: flujo principal esperado
- iOS: el repo incluye carpeta y dependencias compatibles a nivel fuente, pero requiere validación de runtime
- Desktop y Web: el repo incluye carpetas/plataformas, pero el uso de `sqflite`, `flutter_secure_storage` y `local_auth` hace que el soporte real deba considerarse pendiente de validación por entorno

## Documentación

Documentos principales:

- [architecture.md](D:/GITHUB/CleanFinance/docs/architecture.md)
- [project-structure.md](D:/GITHUB/CleanFinance/docs/project-structure.md)
- [features.md](D:/GITHUB/CleanFinance/docs/features.md)
- [screens.md](D:/GITHUB/CleanFinance/docs/screens.md)
- [state-management.md](D:/GITHUB/CleanFinance/docs/state-management.md)
- [database.md](D:/GITHUB/CleanFinance/docs/database.md)
- [security.md](D:/GITHUB/CleanFinance/docs/security.md)
- [dependencies.md](D:/GITHUB/CleanFinance/docs/dependencies.md)
- [build-and-run.md](D:/GITHUB/CleanFinance/docs/build-and-run.md)
- [known-issues.md](D:/GITHUB/CleanFinance/docs/known-issues.md)
- [plan_maestro.md](D:/GITHUB/CleanFinance/docs/plan_maestro.md)

## Nota sobre documentación histórica

[`docs/plan_maestro.md`](D:/GITHUB/CleanFinance/docs/plan_maestro.md) conserva contexto de visión y decisiones de producto previas. No debe usarse como fuente de verdad por encima del código y de la documentación técnica actualizada.
