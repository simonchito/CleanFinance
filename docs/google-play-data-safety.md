# Google Play Data Safety - CleanFinance

Evaluación basada en el código actual del repositorio.

## Resumen ejecutivo

- CleanFinance no transmite datos del usuario a servidores propios ni de terceros.
- No hay SDKs de analytics, ads, crash reporting ni login remoto.
- La app trabaja localmente con SQLite, secure storage, biometría del sistema y archivos elegidos por el usuario.

Con la definición oficial de Google Play, el procesamiento solo on-device no se declara como `data collected`. Por eso, salvo que se agregue telemetría o sincronización remota en el futuro, la respuesta esperada en Data Safety es:

- `Data collected`: No
- `Data shared`: No

## Por qué la respuesta es "No data collected"

Google Play define `collect` como transmitir datos desde la app fuera del dispositivo del usuario. En CleanFinance, el código actual:

- guarda finanzas y preferencias en SQLite local
- guarda PIN, datos de recuperación y lockout en `flutter_secure_storage`
- usa `local_auth` para autenticación local
- exporta backups solo cuando el usuario lo inicia manualmente
- comparte el archivo exportado solo por acción explícita del usuario con `share_plus`

No existe backend ni endpoint remoto.

## Datos que la app sí maneja localmente

### SQLite local

- movimientos financieros
- categorías y subcategorías
- metas de ahorro
- presupuestos
- medios de pago
- preferencias de idioma, moneda, tema, ocultar montos, auto-lock y biometría

### Secure Storage

- hash del PIN
- hash de fecha de nacimiento de recuperación
- hash de documento personal de recuperación
- estado persistido de intentos fallidos y bloqueo temporal
- flag legacy de biometría para migración

### Archivos

- exportación manual de backup como JSON plano o JSON cifrado con contraseña

## Respuesta sugerida para el formulario

### Data collected

- No

### Data shared

- No

### Security practices

- `Data is encrypted in transit`: No aplica actualmente, porque la app no envía datos a servidores
- `You can request that data is deleted`: No aplica como mecanismo remoto de cuenta; la app sí ofrece borrado local completo desde Ajustes

## Nota importante para Play Console

Si antes de publicar se agregan analytics, crash reporting, sync cloud, login, backend o SDKs publicitarios, esta evaluación deja de ser válida y el formulario debe rehacerse.
