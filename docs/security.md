# Security

## Overview

La seguridad actual de CleanFinance es completamente local. No existe backend de autenticación, cuenta remota ni envío de credenciales a servidores.

Mecanismos implementados:

- PIN local de 6 dígitos
- biometría opcional
- recuperación local con dos datos configurados por el usuario
- auto-lock por lifecycle

## Componentes principales

### `SecureStorageService`

Archivo:

- `lib/core/security/secure_storage_service.dart`

Responsabilidad:

- encapsular `FlutterSecureStorage`
- guardar credenciales sensibles fuera de SQLite

Claves activas:

- `auth.credential`
- `auth.recovery.birth_date`
- `auth.recovery.document`

Clave legacy:

- `auth.biometric_enabled`

La preferencia de biometría ya no es la fuente de verdad actual; esa clave puede existir solo como compatibilidad para migrar instalaciones previas.

### `PasswordHasher`

Archivo:

- `lib/core/security/password_hasher.dart`

Responsabilidad:

- hashear PIN y respuestas de recuperación antes de persistirlas

Configuración real actual:

- PBKDF2
- HMAC-SHA256
- 120000 iteraciones
- salt aleatorio de 16 bytes
- 256 bits derivados

### `BiometricService`

Archivo:

- `lib/core/security/biometric_service.dart`

Responsabilidad:

- envolver `local_auth`
- consultar disponibilidad biométrica del dispositivo
- disparar autenticación biométrica

Comportamiento actual:

- consulta `canCheckBiometrics`
- si hace falta, cae a `isDeviceSupported()`
- autentica con `biometricOnly: true`

## Flujo real de autenticación

### Alta inicial

`SetupPinScreen` solicita:

- PIN
- confirmación de PIN
- fecha de nacimiento
- documento personal
- toggle opcional para habilitar biometría

Resultado:

- PIN hasheado en secure storage
- datos de recuperación hasheados en secure storage
- preferencia de biometría persistida en `app_settings.biometric_enabled`

### Unlock

`UnlockScreen` permite:

- desbloqueo por PIN
- intento automático de biometría si:
  - el dispositivo soporta biometría
  - la preferencia persistida está habilitada

Si biometría falla o no está disponible:

- la UI no se rompe
- el fallback sigue siendo PIN

### Recuperación

`RecoverAccessScreen` permite:

- validar fecha de nacimiento y documento
- definir un PIN nuevo
- volver a decidir si biometría queda habilitada

## Fuente de verdad de biometría

La fuente de verdad actual es:

- `app_settings.biometric_enabled`

Impacto:

- onboarding actualiza esa preferencia
- Ajustes lee y actualiza esa preferencia
- unlock decide si ofrece biometría a partir de esa preferencia

Comportamiento adicional:

- si la app encuentra el flag legacy en secure storage, intenta migrarlo
- si biometría deja de estar disponible, la preferencia se desactiva con degradación elegante a PIN

## Relación con Settings

`SettingsScreen` expone:

- switch de biometría
- minutos de auto-lock

El switch:

- muestra el estado efectivo de auth/settings
- se deshabilita cuando biometría no está disponible
- persiste sobre la misma preferencia usada en onboarding y unlock

## Auto-lock

`HomeShell` observa el lifecycle:

- en `paused`, `AuthController.onPaused()` guarda timestamp en memoria
- en `resumed`, `AuthController.onResumed(...)` compara el tiempo transcurrido con `autoLockMinutes`
- si se supera el umbral, la app vuelve a estado `locked`

Esto es un bloqueo de sesión, no cifrado de base de datos.

## Límites actuales

- no hay cifrado de SQLite
- no hay cuenta remota ni recuperación server-side
- no hay detección de root/jailbreak
- no hay audit log de eventos de autenticación
- soporte biométrico fuera de plataformas móviles principales requiere validación por entorno
