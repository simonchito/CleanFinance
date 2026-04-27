# Build and Run

## Prerequisitos

Necesitás:

- Flutter SDK compatible con `sdk: >=3.3.0 <4.0.0`
- Dart incluido con Flutter
- Android Studio o toolchains de la plataforma objetivo
- emulador o dispositivo físico si querés validar mobile

## Dependencias

```bash
flutter pub get
```

## Ejecutar en debug

```bash
flutter run
```

Si hay múltiples dispositivos:

```bash
flutter devices
flutter run -d <device-id>
```

## Análisis estático

```bash
flutter analyze
```

Lint config:

- `analysis_options.yaml`
- basado en `flutter_lints`

## Tests

```bash
flutter test
```

Ejemplos de tests existentes en el repo:

- `test/auth_controller_test.dart`
- `test/movement_form_screen_test.dart`
- `test/payment_method_utils_test.dart`
- `test/budget_service_test.dart`
- `test/finance_analytics_services_test.dart`
- `test/monthly_payment_reminder_service_test.dart`

## Build Android

APK debug:

```bash
flutter build apk --debug
```

APK release:

```bash
flutter build apk --release
```

App Bundle:

```bash
flutter build appbundle --release
```

Salida esperada:

```text
build/app/outputs/
```

Configuración Android actual:

- `namespace`: `app.cleanfinance`
- `applicationId`: `app.cleanfinance`
- `minSdk`: 24
- `targetSdk`: 35
- `compileSdk`: 36
- Java/Kotlin target: 17
- core library desugaring: habilitado
- permisos principales: biometría, notificaciones y boot completed para recordatorios

Firma release:

- `android/key.properties` debe existir solo en la máquina de firma.
- El archivo debe definir `storeFile`, `storePassword`, `keyAlias` y `keyPassword`.
- El keystore real (`.jks`, `.keystore`, `.p12`) no debe versionarse.
- Si se intenta una tarea release sin signing, Gradle falla de forma explícita.

## Localización

Idiomas soportados:

- Español (`es`)
- Inglés (`en`)

El modo `system` usa el idioma del teléfono si está soportado y cae a español en cualquier otro caso. Las preferencias manuales se guardan en `app_settings.locale_code`. Portugués/`pt_BR` no está soportado en esta versión.

## Otras plataformas

El repo incluye carpetas para:

- Android
- iOS
- Linux
- macOS
- Windows
- Web

Comandos típicos de Flutter:

```bash
flutter build ios
flutter build macos
flutter build windows
flutter build linux
flutter build web
```

## Estado de soporte por plataforma

Lo que sí puede afirmarse desde el código:

- Android: flujo principal esperado
- iOS: plausible a nivel dependencias/carpeta, requiere validación de runtime
- Desktop: presencia de carpetas, pero soporte real depende de plugins usados
- Web: presencia de carpeta, pero el proyecto no implementa guards específicos para plugins de auth, secure storage y SQLite

Plugins que condicionan soporte real:

- `sqflite`
- `flutter_secure_storage`
- `local_auth`
- `file_picker`
- `share_plus`

## Consideraciones de runtime

### Startup

```text
main.dart
  -> AppErrorHandler.run(...)
  -> WidgetsFlutterBinding.ensureInitialized()
  -> ProviderScope
  -> CleanFinanceApp
  -> AuthGateScreen
```

### Backup local

- exporta un JSON al directorio de documentos de la app
- usa `share_plus` para compartir el archivo
- importa un JSON elegido con `file_picker`
- la importación reemplaza los datos locales actuales

### Biometría

- depende del soporte del dispositivo y de la configuración del sistema
- si no está disponible, la app sigue funcionando con PIN

## Problemas comunes a revisar

- si `flutter run` no encuentra dispositivo, validar `flutter doctor`
- en plataformas no móviles, verificar compatibilidad real de `sqflite`, `local_auth` y `flutter_secure_storage`
- para iOS/release signing, el repo no documenta aún configuración de firma o distribución
