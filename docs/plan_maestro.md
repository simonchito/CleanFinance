# Clean Finance - Plan Funcional y Técnico

## 1. Nombre tentativo de la app

**Clean Finance**

Alternativas viables:

- Saldo Claro
- Fondo Simple
- Casa de Ahorro

Elegí **Clean Finance** porque comunica orden, sobriedad y control, y funciona bien como nombre de producto publicable.

## 2. Concepto general

Aplicación móvil personal para administrar dinero de forma **100% offline**, privada y rápida. La app se enfoca en registrar movimientos, visualizar el saldo disponible, organizar categorías y subcategorías, y seguir metas de ahorro sin depender de servidores, cuentas online ni sincronización en la nube.

## 3. Problema que resuelve

Resuelve la necesidad de llevar control financiero diario sin fricción, sin hojas de cálculo complejas y sin entregar datos sensibles a terceros. Apunta a personas que quieren:

- saber cuánto dinero tienen realmente disponible
- registrar ingresos y gastos en segundos
- separar ahorro del gasto corriente
- revisar el comportamiento mensual de su dinero
- mantener control privado en el propio dispositivo

## 4. Perfil de usuario

Usuario individual, no empresarial, que:

- usa el teléfono como herramienta principal
- quiere una experiencia simple y rápida
- valora privacidad y control local
- no necesita colaboración multiusuario en el MVP
- puede no tener formación financiera técnica

## 5. Alcance del MVP

El MVP cubre:

- autenticación local con PIN y biometría
- dashboard con resumen financiero
- ABM de movimientos
- ABM de categorías
- metas de ahorro con seguimiento de progreso
- historial filtrable
- reportes simples y livianos
- ajustes esenciales
- exportación/importación manual local
- borrado total de datos

No incluye en esta fase:

- sincronización
- backend
- presupuestos
- cuentas múltiples
- OCR de tickets
- integración bancaria
- multiusuario

## 6. Funcionalidades del MVP

### Dashboard

- saldo disponible
- ingresos del mes
- gastos del mes
- ahorro acumulado
- movimientos recientes
- acceso rápido a cargar movimiento

### Movimientos

- crear ingreso, gasto y ahorro
- editar y eliminar
- categoría obligatoria
- subcategoría opcional
- fecha
- nota opcional
- medio de pago opcional
- vínculo opcional con meta de ahorro

### Categorías

- categorías predefinidas iniciales
- crear, editar, eliminar
- soporte para subcategorías mediante relación padre-hijo

### Ahorros

- crear metas
- monto objetivo
- fecha objetivo opcional
- registrar aportes
- ver progreso actual

### Historial

- lista cronológica
- filtros por rango de fechas
- filtros por tipo
- filtros por categoría
- búsqueda simple por nota

### Reportes

- ingresos vs gastos
- gasto por categoría
- resumen mensual
- evolución comparada contra período anterior

### Ajustes

- moneda
- tema claro/oscuro
- biometría
- tiempo de bloqueo automático
- exportar/importar JSON
- borrar datos
- bloqueo manual
- información de privacidad

## 7. Funcionalidades futuras

- presupuestos mensuales por categoría
- cuentas múltiples
- transferencias entre cuentas
- etiquetas
- recurrencias
- sincronización opcional cifrada
- backup externo opcional
- widget de pantalla de inicio
- exportación CSV/PDF
- insights financieros

## 8. Flujo funcional completo

1. Primer ingreso.
2. La app detecta que no existe credencial local.
3. El usuario crea un PIN local seguro.
4. La app inicializa configuración base y categorías predefinidas.
5. El usuario entra al dashboard.
6. Registra ingresos, gastos y ahorros.
7. Consulta historial y reportes.
8. Crea metas de ahorro y registra aportes.
9. Ajusta tema, moneda, biometría y tiempo de auto-bloqueo.
10. Exporta o importa un backup manual cuando lo necesita.
11. Si la app queda inactiva, vuelve a pantalla de desbloqueo.

## 9. Estructura de pantallas

- Splash / Gate
- Crear PIN
- Desbloqueo
- Home Shell con navegación inferior
- Inicio
- Movimientos
- Editor de movimiento
- Gestión de categorías
- Ahorros
- Editor de meta
- Reportes
- Ajustes

## 10. Flujo de navegación

### Flujo raíz

- Splash/Gate
- Crear PIN o Desbloqueo
- Home Shell

### Navegación principal

- Inicio
- Movimientos
- Ahorros
- Reportes
- Ajustes

### Navegación secundaria

- desde Movimientos: editor de movimiento y categorías
- desde Ahorros: editor de meta y aporte
- desde Ajustes: importación, exportación y acciones sensibles

Decisión UX:

- uso de **bottom navigation** de 5 items por ser el patrón más natural y usable con una mano para este tipo de app
- acciones de alta frecuencia accesibles con FAB o botones primarios

## 11. Modelo de datos

### Entidades principales

**Movement**

- id
- type: income | expense | saving
- amount
- categoryId
- subcategoryId opcional
- goalId opcional
- occurredOn
- note opcional
- paymentMethod opcional
- createdAt
- updatedAt

**Category**

- id
- name
- scope: income | expense | saving | all
- parentId opcional
- isDefault
- createdAt
- updatedAt

**SavingsGoal**

- id
- name
- targetAmount
- targetDate opcional
- isArchived
- createdAt
- updatedAt

**AppSettings**

- currencyCode
- currencySymbol
- themeMode
- biometricEnabled
- autoLockMinutes

### Entidades derivadas

- DashboardSummary
- SavingsGoalProgress
- ReportsSnapshot
- MovementFilter

## 12. Diseño de base de datos local

Motor recomendado: **SQLite** con `sqflite`.

Motivo:

- relacional y robusto
- excelente para datos financieros estructurados
- consultas agregadas simples
- fácil de migrar y testear
- sin codegen obligatorio

### Tablas

**categories**

- id TEXT PK
- name TEXT NOT NULL
- scope TEXT NOT NULL
- parent_id TEXT NULL
- is_default INTEGER NOT NULL
- created_at TEXT NOT NULL
- updated_at TEXT NOT NULL

**movements**

- id TEXT PK
- type TEXT NOT NULL
- amount REAL NOT NULL
- category_id TEXT NOT NULL
- subcategory_id TEXT NULL
- goal_id TEXT NULL
- occurred_on TEXT NOT NULL
- note TEXT NULL
- payment_method TEXT NULL
- created_at TEXT NOT NULL
- updated_at TEXT NOT NULL

**savings_goals**

- id TEXT PK
- name TEXT NOT NULL
- target_amount REAL NOT NULL
- target_date TEXT NULL
- is_archived INTEGER NOT NULL
- created_at TEXT NOT NULL
- updated_at TEXT NOT NULL

**app_settings**

- id INTEGER PK CHECK id = 1
- currency_code TEXT NOT NULL
- currency_symbol TEXT NOT NULL
- theme_mode TEXT NOT NULL
- biometric_enabled INTEGER NOT NULL
- auto_lock_minutes INTEGER NOT NULL

### Estrategia de migraciones

- `schemaVersion` incremental
- scripts controlados en `onUpgrade`
- migraciones aditivas o con transformación transaccional
- respaldo previo sugerido antes de migraciones mayores en futuras versiones

## 13. Estrategia de autenticación local + biometría

### Decisión del MVP

- credencial base local: **PIN de 6 dígitos**
- almacenamiento: hash derivado con PBKDF2 + salt aleatorio
- ubicación del secreto: secure storage del sistema
- acceso cómodo: biometría opcional sobre la misma sesión local

### Reglas

- la biometría nunca reemplaza el alta inicial del PIN
- si no hay biometría disponible, se informa de forma clara y se usa PIN
- si falla la biometría, siempre existe fallback al PIN
- al volver de background se evalúa tiempo de inactividad
- bloqueo manual disponible desde Ajustes

### Recuperación local simple viable

Sin backend, la recuperación segura real es limitada. Para no debilitar seguridad:

- no se implementa “recuperar PIN” en el MVP
- la salida segura es borrar los datos locales y reconfigurar la app
- si más adelante se quiere recuperación, debe estar basada en passphrase de exportación o backup cifrado, no en preguntas inseguras

## 14. Estrategia de almacenamiento seguro

### Secretos y flags sensibles

`flutter_secure_storage`

- PIN hasheado
- salt
- iteraciones
- preferencia de biometría

### Datos funcionales

SQLite local dentro del sandbox de la app.

### Nivel de seguridad buscado

- secretos en Keychain / Keystore
- datos funcionales en sandbox local
- sin texto plano para credenciales
- sin exponer archivos fuera del flujo explícito de exportación

Nota de arquitectura:

Para el MVP priorizo simplicidad y mantenibilidad. Si en una siguiente fase se requiere cifrado completo de la base, el dominio y los repositorios quedan preparados para migrar a SQLCipher sin romper el core.

## 15. Arquitectura técnica recomendada

### Enfoque

**Clean Architecture pragmática + clean core**

Capas:

- `presentation`
- `domain`
- `data`
- `core`

### Principios aplicados

- dominio aislado de Flutter y de SQLite
- repositorios como contratos
- casos de uso donde aportan claridad
- validaciones en el core y en el dominio, no incrustadas en widgets
- UI reactiva y delgada
- bajo acoplamiento con plugins

### Estado

**Riverpod**

- simple para DI
- testeable
- claro para flujos async
- sin boilerplate excesivo

## 16. Justificación del stack elegido

## Elección: Flutter

### Por qué Flutter para este caso

- una sola base de código móvil madura para Android y iPhone
- excelente rendimiento percibido para UI simple y rápida
- muy buen control visual para una interfaz sobria y consistente
- ecosistema sólido para almacenamiento local, secure storage y biometría
- menor variabilidad visual entre plataformas cuando se busca identidad propia cuidada
- buena mantenibilidad para un producto personal offline

### Por qué no React Native en este caso

- suele depender más de integración y compatibilidad entre paquetes nativos
- el costo de variación del ecosistema puede ser mayor para un MVP offline pequeño
- para una app privada, local y centrada en fluidez de UI, Flutter ofrece una base más cerrada y predecible

### Gestor de estado recomendado

Riverpod.

### Base de datos local recomendada

SQLite con `sqflite`.

### Almacenamiento seguro recomendado

`flutter_secure_storage`.

### Biometría

`local_auth`.

### Importación/exportación

JSON local con selector nativo (`file_picker`) y exportación compartible (`share_plus`).

## 17. Estructura de carpetas del proyecto

```text
lib/
  app/
    app.dart
    theme/
  core/
    constants/
    database/
    security/
    utils/
  shared/
    providers.dart
  features/
    auth/
      data/
      domain/
      presentation/
    finance/
      data/
      domain/
      presentation/
test/
docs/
```

## 18. Reglas de negocio principales

- no existe sesión válida sin credencial base local
- monto de movimiento siempre mayor a cero
- todo movimiento debe tener tipo y categoría válidos
- una meta de ahorro debe tener monto objetivo mayor a cero
- una categoría con movimientos asociados no se elimina directamente
- el saldo disponible = ingresos - gastos - ahorros
- el ahorro acumulado = suma histórica de movimientos `saving`
- el progreso de una meta = suma de movimientos `saving` vinculados a esa meta
- la biometría solo se habilita si el dispositivo la soporta

## 19. Lineamientos de UI/UX

- mobile-first real
- prioridad a una sola mano
- layout limpio y aireado
- densidad baja
- contraste alto
- pocos colores
- énfasis visual en números importantes
- formularios cortos
- CTA claros
- vacíos útiles y tranquilos
- lenguaje humano, breve y directo

### Dirección visual propuesta

- base neutra cálida
- acentos verde oliva / grafito
- tarjetas suaves con bordes amplios
- iconografía simple
- jerarquía visual fuerte en saldo y métricas

## 20. Consideraciones de accesibilidad

- targets táctiles amplios
- contraste AA o superior
- textos claros y sin depender solo del color
- soporte para escalado de fuente
- labels semánticos
- navegación consistente
- feedback para error, vacío, carga y éxito

## 21. Consideraciones de privacidad y publicación en tiendas

- sin analytics invasivas
- sin SDKs publicitarios
- sin tracking
- sin recolección externa de datos financieros
- disclosures claros sobre almacenamiento local
- biometría usada solo para desbloqueo local
- permisos mínimos
- import/export solo bajo acción explícita del usuario

### App Store / Play Store

- incluir texto de privacidad simple y coherente
- evitar claims confusos tipo “banco” o “inversión”
- explicar que la app funciona offline y guarda datos localmente
- documentar en metadatos si el usuario puede borrar toda su información

## 22. Roadmap por fases

### Fase 0

- definición funcional
- diseño técnico
- scaffold base

### Fase 1

- auth local
- dashboard
- movimientos
- categorías
- ajustes base

### Fase 2

- metas de ahorro
- reportes
- export/import
- hardening de UX

### Fase 3

- tests más amplios
- optimización
- pulido de publicación

### Fase 4

- presupuestos
- cuentas múltiples
- sync opcional

## 23. Riesgos técnicos y cómo mitigarlos

### Riesgo: sobreingeniería

Mitigación:

- stack acotado
- sin codegen obligatorio
- sin backend en MVP

### Riesgo: pérdida de datos por importación defectuosa

Mitigación:

- importación transaccional
- validación de estructura JSON
- backup previo recomendado

### Riesgo: mala UX en autenticación

Mitigación:

- PIN corto y claro
- biometría opcional
- mensajes concretos ante indisponibilidad

### Riesgo: bloqueo excesivo por auto-lock

Mitigación:

- tiempo configurable
- valor por defecto razonable

### Riesgo: deuda futura al agregar sync

Mitigación:

- dominio aislado
- repositorios desacoplados
- modelos consistentes

## 24. Recomendaciones de testing

### Unit tests

- hasheo y verificación de PIN
- reglas de saldo
- agregados de dashboard
- filtros de movimientos
- cálculo de progreso de metas

### Integration tests

- onboarding
- desbloqueo por PIN
- desbloqueo por biometría cuando exista
- CRUD de movimiento
- exportación/importación

### Widget tests

- AuthGate
- HomeShell
- formularios
- estados vacíos

## 25. Proyecto base inicial

Se implementa una base Flutter con:

- theme claro/oscuro
- auth local
- secure storage
- SQLite con versión de esquema
- repositorios desacoplados
- dashboard funcional
- movimientos con CRUD
- metas de ahorro con aportes
- reportes simples
- ajustes
- exportación e importación JSON

## Fuentes consultadas

- Flutter app architecture guide: https://docs.flutter.dev/app-architecture/guide
- Flutter SQLite cookbook: https://docs.flutter.dev/cookbook/persistence/sqlite?v=1.1.1
- `local_auth` en pub.dev: https://pub.dev/packages/local_auth
- `flutter_secure_storage` en pub.dev: https://pub.dev/packages/flutter_secure_storage
- React Native architecture overview: https://reactnative.dev/architecture/overview
