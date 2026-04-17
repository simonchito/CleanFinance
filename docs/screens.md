# Screens

## Navigation overview

La app usa navegación imperativa con `Navigator` y `MaterialPageRoute`.

Flujo principal:

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

Pantallas adicionales se empujan desde esas tabs.

## Auth screens

### `AuthGateScreen`

Responsabilidad:

- leer `AuthState.status`
- decidir entre setup, unlock o shell principal

### `SetupPinScreen`

Responsabilidad:

- alta inicial de seguridad

Inputs actuales:

- PIN
- confirmación
- fecha de nacimiento
- documento personal
- toggle para biometría si está disponible

### `UnlockScreen`

Responsabilidad:

- desbloquear con PIN o biometría

Comportamiento actual:

- si biometría está disponible y habilitada, intenta usarla automáticamente una vez
- mantiene fallback a PIN
- ofrece ir a recuperación si hay datos configurados

### `RecoverAccessScreen`

Responsabilidad:

- recuperar acceso y definir nuevo PIN

Inputs actuales:

- fecha de nacimiento
- documento
- nuevo PIN
- confirmación
- toggle para biometría

## Main shell

### `HomeShell`

Responsabilidad:

- mantener las cinco tabs principales con `IndexedStack`
- escuchar lifecycle para auto-lock

Tabs:

- Dashboard
- Movements
- Savings
- Reports
- Settings

## Finance screens

### `DashboardScreen`

Muestra:

- saldo actual
- resumen del mes
- proyección de fin de mes
- recordatorios mensuales pendientes
- insights
- visuales de ingresos vs gastos
- tendencia mensual
- categorías principales
- movimientos recientes

### `MovementsScreen`

Muestra:

- listado de movimientos
- búsqueda por nota
- filtros por tipo, categoría y rango de fecha
- edición y borrado

Visualización actual:

- categoría/subcategoría
- fecha
- nota si existe
- monto
- chip de medio de pago si existe

### `MovementFormScreen`

Permite:

- crear o editar ingresos, gastos y ahorro

Campos actuales:

- tipo
- monto
- categoría
- subcategoría opcional
- meta de ahorro si el tipo es `saving`
- fecha
- medio de pago opcional
- nota opcional

UX actual:

- usa `SelectionSheetField` para selectores
- refleja el medio de pago elegido en tiempo real en el propio campo

### `SavingsScreen`

Muestra:

- metas activas y archivadas
- progreso
- aportes
- acciones rápidas para contribuir o editar

### `SavingsGoalFormScreen`

Campos actuales:

- nombre
- monto objetivo
- fecha objetivo opcional
- recordatorio mensual opcional

### `ReportsScreen`

Secciones actuales:

- financial health score
- cashflow del mes
- evolución mensual
- comparación por categorías
- ritmo de gasto
- forecast de metas
- breakdown por medio de pago
- insights

### `SettingsScreen`

Secciones actuales:

- appearance
- security
- organization
- data

Desde acá se navega a:

- `PaymentMethodsScreen`
- `ManageRemindersScreen`
- `CategoriesScreen`
- `BudgetsScreen`

### `CategoriesScreen`

Responsabilidad:

- gestionar categorías y subcategorías por scope

Scopes:

- income
- expense
- saving

Capacidades actuales:

- crear
- editar
- borrar categorías personalizadas
- definir `iconKey`
- crear subcategorías
- habilitar recordatorio mensual en subcategorías

### `ManageRemindersScreen`

Responsabilidad:

- centralizar edición y desactivación de recordatorios activos

Fuentes:

- subcategorías de gasto
- metas de ahorro

### `PaymentMethodsScreen`

Responsabilidad:

- gestionar la lista de medios de pago disponibles en el formulario de movimientos

Capacidades:

- agregar
- editar
- borrar

Los labels se normalizan con `PaymentMethodUtils`.

## Budget screens

### `BudgetsScreen`

Muestra:

- estado del presupuesto mensual por categoría de gasto

### `BudgetFormScreen`

Permite:

- crear o editar un presupuesto para el mes actual

Campos:

- categoría de gasto
- límite mensual

## Notas de UX/UI

- los selectores principales usan bottom sheets consistentes
- la navegación secundaria usa dialogs y pantallas push
- la app mantiene tarjetas redondeadas, spacing amplio y jerarquía visual simple
