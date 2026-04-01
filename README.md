# CleanFinance

CleanFinance es una app Flutter de finanzas personales enfocada en simplicidad, privacidad y funcionamiento offline-first.

El proyecto actual usa almacenamiento local, autenticación con PIN, soporte biométrico opcional, gestión de movimientos, metas de ahorro, presupuestos mensuales, recordatorios mensuales y reportes derivados desde datos locales.

## Estado actual

Stack principal:

- Flutter + Dart
- Riverpod
- SQLite (`sqflite`)
- `flutter_secure_storage`
- `local_auth`

Arquitectura actual:

- organización modular por features
- separación en `data`, `domain` y `presentation`
- providers compartidos en `lib/shared/providers.dart`
- servicios de dominio para analítica, recordatorios y presupuestos

## Funcionalidades implementadas

### Seguridad y acceso

- configuración inicial con PIN local
- recuperación de acceso con datos configurados por el usuario
- desbloqueo por biometría cuando el dispositivo lo permite
- auto-lock por inactividad al volver desde background

### Dashboard

- saldo actual
- resumen mensual de ingresos, gastos, ahorros y cantidad de movimientos
- proyección de fin de mes
- movimientos recientes
- insights y métricas visuales
- card de recordatorios mensuales pendientes

### Movimientos

- alta y edición de ingresos, gastos y ahorros
- categorías y subcategorías
- filtro por tipo, categoría, rango de fecha y búsqueda por nota
- medios de pago configurables
- formateo automático de montos enteros

### Categorías

- gestión de categorías de ingresos, gastos y ahorro
- soporte de subcategorías
- recordatorios mensuales en subcategorías de gasto

### Metas de ahorro

- alta y edición de metas
- seguimiento de progreso
- aportes vinculados mediante movimientos de ahorro
- recordatorios mensuales por meta

### Presupuestos

- creación de presupuestos mensuales por categoría de gasto
- cálculo de estado por consumo actual
- estados `normal`, `warning` y `exceeded`

### Reportes

- cashflow mensual
- evolución mensual
- comparación por categorías
- ritmo de gasto
- forecast de metas de ahorro
- gastos por medio de pago
- score de salud financiera

### Datos locales

- exportación de backup a JSON
- importación manual de backup
- limpieza de datos locales

## Estructura del proyecto

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

Resumen por carpeta:

- `app/`: configuración global, theme y strings
- `core/`: constantes, base de datos, seguridad, errores y utilidades
- `features/auth/`: acceso, PIN, biometría y recuperación
- `features/finance/`: dashboard, movimientos, categorías, metas, recordatorios, reportes y settings
- `features/budgets/`: presupuestos mensuales
- `shared/`: providers de infraestructura y servicios compartidos

## Cómo ejecutar

### Instalar dependencias

```bash
flutter pub get
```

### Ejecutar la app

```bash
flutter run
```

### Análisis estático

```bash
flutter analyze
```

### Tests

```bash
flutter test
```

### Generar APK

```bash
flutter build apk --release
```

## Documentación técnica

La carpeta [`docs/`](/D:/GITHUB/CleanFinance/docs) refleja el estado actual del código.

Documentos principales:

- [architecture.md](/D:/GITHUB/CleanFinance/docs/architecture.md)
- [project-structure.md](/D:/GITHUB/CleanFinance/docs/project-structure.md)
- [features.md](/D:/GITHUB/CleanFinance/docs/features.md)
- [screens.md](/D:/GITHUB/CleanFinance/docs/screens.md)
- [state-management.md](/D:/GITHUB/CleanFinance/docs/state-management.md)
- [database.md](/D:/GITHUB/CleanFinance/docs/database.md)
- [security.md](/D:/GITHUB/CleanFinance/docs/security.md)
- [dependencies.md](/D:/GITHUB/CleanFinance/docs/dependencies.md)
- [build-and-run.md](/D:/GITHUB/CleanFinance/docs/build-and-run.md)
- [known-issues.md](/D:/GITHUB/CleanFinance/docs/known-issues.md)
- [plan_maestro.md](/D:/GITHUB/CleanFinance/docs/plan_maestro.md)

## Notas importantes

- el proyecto es local-first; no hay integración backend en el código actual
- la persistencia principal es SQLite y secure storage
- el soporte exacto de todas las plataformas incluidas en el repo debe validarse por entorno, especialmente web y desktop
- si necesitás detalle técnico fino, tomá `/docs` como fuente principal antes que este README
