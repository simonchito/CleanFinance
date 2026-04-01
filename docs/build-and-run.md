# Build and Run

## Prerequisites

The repository is a Flutter application. To run it locally, you need:

- Flutter SDK compatible with `sdk: >=3.3.0 <4.0.0`
- Dart SDK bundled with Flutter
- platform toolchains for your target device or emulator

## Install Dependencies

```bash
flutter pub get
```

## Run in Debug

```bash
flutter run
```

If you have multiple devices connected:

```bash
flutter devices
flutter run -d <device-id>
```

## Run Tests

```bash
flutter test
```

Current automated tests cover:

- password hashing
- whole-amount formatting
- budget service rules
- analytics services
- monthly reminder service rules

## Static Analysis

```bash
flutter analyze
```

Lint configuration:

- `analysis_options.yaml`
- based on `flutter_lints`

## Build APK

Debug APK:

```bash
flutter build apk --debug
```

Release APK:

```bash
flutter build apk --release
```

Expected output path:

```text
build/app/outputs/flutter-apk/
```

## Other Platform Builds

The repository includes Flutter platform folders for:

- Android
- iOS
- Linux
- macOS
- Windows
- Web

Typical commands:

```bash
flutter build ios
flutter build macos
flutter build windows
flutter build linux
flutter build web
```

## Platform Support Status

### Repository-Level Presence

Platform directories exist for:

- `android/`
- `ios/`
- `linux/`
- `macos/`
- `windows/`
- `web/`

### Runtime Compatibility

The codebase uses plugins such as:

- `sqflite`
- `local_auth`
- `flutter_secure_storage`

Because the source code does not include explicit platform-guarded alternatives for every platform, full compatibility should be treated as:

- Android: likely intended
- iOS: likely intended
- Linux/macOS/Windows: partially supported at repository level, runtime verification pending
- Web: not determined and likely constrained by current plugin choices

## Known Runtime Considerations

### Biometrics

- depend on device support and OS configuration
- are explicitly handled when unavailable
- may not behave uniformly across all platforms

### Local Database

- SQLite is the storage backend
- new installs receive the latest schema version
- older installs rely on migrations without destructive rebuilds

### Backup Flow

- export creates a local JSON file in the app documents directory
- import reads a selected JSON file and replaces current local data

## App Startup Flow

```text
main.dart
  -> AppErrorHandler.run(...)
  -> WidgetsFlutterBinding.ensureInitialized()
  -> ProviderScope
  -> CleanFinanceApp
  -> AuthGateScreen
```

## Icons and Assets

The app currently declares:

- `assets/images/cleanfinance-logo.png`

Launcher icon generation is configured in `pubspec.yaml`.
