# Security

## Overview

Security in CleanFinance is local and device-oriented. The current implementation does not send credentials or financial data to a backend service.

Main mechanisms:

- PIN-based authentication
- optional biometric unlock
- secure storage for credentials and recovery data
- auto-lock on app lifecycle resume

## Core Components

### `SecureStorageService`

File:

- `lib/core/security/secure_storage_service.dart`

Purpose:

- wrap `FlutterSecureStorage`
- persist auth-related secrets outside SQLite

Stored keys:

- `auth.credential`
- `auth.biometric_enabled`
- `auth.recovery.birth_date`
- `auth.recovery.document`

### `PasswordHasher`

File:

- `lib/core/security/password_hasher.dart`

Purpose:

- hash PINs and recovery secrets before storage

Current algorithm details from code:

- PBKDF2
- HMAC-SHA256
- 120000 iterations
- 16-byte random salt
- 256 derived bits

The implementation compares derived hashes using a custom constant-time style list equality helper.

### `BiometricService`

File:

- `lib/core/security/biometric_service.dart`

Purpose:

- wrap `local_auth`
- check biometric/device support
- attempt biometric-only authentication

Behavior:

- uses `canCheckBiometrics`
- falls back to `isDeviceSupported()`
- authenticates with `biometricOnly: true`

## Authentication Flow

### First-Time Setup

The user creates:

- a 6-digit PIN
- recovery answers:
  - birth date
  - document identifier

Optional:

- enable biometrics

### Unlock

The app supports:

- PIN unlock
- biometric unlock when available and enabled

### Recovery

If recovery data exists, the user can:

- answer both recovery prompts
- set a new PIN
- optionally re-enable biometrics

## Auto-Lock

`HomeShell` listens to app lifecycle changes:

- on pause, the current timestamp is stored in memory
- on resume, `AuthController.onResumed(...)` compares elapsed time with the configured auto-lock minutes
- if the threshold is reached, the app returns to the locked state

This is a session lock, not a process-level encryption feature.

## Interaction with Settings

The app stores a biometric-enabled flag in two places:

- secure storage for auth behavior
- `app_settings` in SQLite for settings UI state and app preferences

The settings screen updates both through:

- `AuthController.setBiometricEnabled(...)`
- `SettingsController.setBiometricEnabled(...)`

## Error Handling

Global error handling is configured in:

- `lib/core/errors/app_error_handler.dart`

Covered hooks:

- `FlutterError.onError`
- `PlatformDispatcher.instance.onError`
- `runZonedGuarded`
- custom `ErrorWidget.builder`

Current behavior:

- prints structured diagnostics in debug output
- renders a readable in-app fallback widget for widget build failures

No remote crash reporting integration is present in the current code.

## Security Boundaries

### Protected in Secure Storage

- hashed PIN payload
- biometric enabled flag
- hashed recovery secrets

### Protected in SQLite

- finance data
- app settings

SQLite data is local to the device, but the codebase does not implement database encryption.

## Platform and Support Notes

### Biometric Support

Biometrics depend on:

- device support
- OS configuration
- plugin availability

The app already handles unavailable biometrics by disabling related actions and surfacing messages.

### Web Support

The repository includes a `web/` directory, but the current source code has no web-specific guards around local auth, secure storage, or SQLite-backed repositories.

Status:

- web runtime support is not determined from the code reviewed
- biometric and persistence behavior on web should be treated as pending verification

## Current Limitations

- no remote account system
- no server-side recovery
- no database encryption layer
- no anti-tamper or jailbreak/root detection
- no audit log for auth events
