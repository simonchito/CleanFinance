# Project Structure

## Top level

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

## Main source tree

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
│   ├── budgets/
│   └── finance/
├── shared/
├── brand_logo_asset.dart
└── main.dart
```

## Responsabilidad por carpeta

### `lib/app/`

- `app.dart`: `MaterialApp`, theme mode, locale y root screen
- `app_strings.dart`: copy y helper simple de localización
- `theme/`: palette y theme Material 3
- `widgets/`: widgets globales de marca

### `lib/core/`

- `constants/`: defaults, catálogos e icon options
- `database/`: apertura, schema, migraciones y seed helpers
- `errors/`: manejo global de errores
- `security/`: secure storage, biometría y hashing
- `utils/`: formateadores, mapeos de iconos y helpers varios

### `lib/features/auth/`

- `data/`: repositorio local de auth
- `domain/`: contrato de repositorio
- `presentation/`: controller, state, provider y pantallas de auth

### `lib/features/finance/`

- `data/`: repositorio local principal para datos financieros
- `domain/entities/`: modelos de dominio como `Movement`, `Category`, `AppSettings`
- `domain/repositories/`: contratos
- `domain/services/`: reglas derivadas para reportes, insights y recordatorios
- `presentation/controllers/`: `SettingsController`
- `presentation/providers/`: providers de lectura
- `presentation/screens/`: pantallas de dashboard, movimientos, ahorro, reportes, settings, categorías y recordatorios
- `presentation/widgets/`: building blocks de UI reutilizables
- `presentation/utils/`: helpers visuales como íconos de medio de pago

### `lib/features/budgets/`

- `data/repositories/`: persistencia local de presupuestos
- `domain/models/`: entidades y estados de presupuesto
- `domain/repositories/`: contrato
- `domain/services/`: cálculos de presupuesto
- `presentation/providers/`: provider de estados calculados
- `presentation/screens/`: listado y formulario

### `lib/shared/`

- `providers.dart`: composición global de dependencias

### `test/`

Cobertura actual visible en el repo:

- hashing y seguridad
- movement form
- payment methods
- services de analítica
- services de recordatorios
- budgets
- formateo de montos

## Convenciones actuales

- archivos en `snake_case.dart`
- clases en `PascalCase`
- providers con sufijo `Provider`
- controllers con sufijo `Controller`
- services con sufijo `Service`

## Patrones visibles

- entidades y contratos sin imports de Flutter
- persistencia concreta bajo `data`
- UI dividida entre `screens` y `widgets`
- navegación imperativa con `Navigator` y `MaterialPageRoute`
- acceso a estado mediante `WidgetRef`

## Notas

- `tool/` contiene tooling auxiliar del repo y no forma parte del runtime principal
- `docs/` mantiene documentación técnica y de producto
- `docs/plan_maestro.md` se conserva como documento histórico, no como fuente de verdad del estado actual
