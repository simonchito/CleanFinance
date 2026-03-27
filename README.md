# Clean Finance

Base inicial de una app móvil de finanzas personales, offline y enfocada en privacidad.

## Stack elegido

- Flutter
- Riverpod
- SQLite con `sqflite`
- `flutter_secure_storage`
- `local_auth`

## Estado actual

El repositorio contiene:

- documento funcional y técnico completo del MVP
- arquitectura base con clean core
- flujo local de autenticación con PIN + biometría
- base de datos local con migraciones simples
- pantallas iniciales del MVP
- exportación e importación manual en JSON

## Cómo continuar

Como en este entorno no está instalado Flutter, la estructura nativa de `android/` e `ios/` no pudo generarse automáticamente. Para completarla en una máquina con Flutter:

```bash
flutter create .
flutter pub get
flutter run
```

Después de ejecutar `flutter create .`, revisá que no se sobrescriban archivos existentes de `lib/`, `test/` y `pubspec.yaml`.

## Documentación

- Plan maestro: `docs/plan_maestro.md`
