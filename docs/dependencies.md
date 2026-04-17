# Dependencies

## Runtime dependencies

### Flutter SDK

#### `flutter`

Propósito:

- framework base

#### `flutter_localizations`

Propósito:

- delegates de localización de Flutter

## UI / UX

#### `cupertino_icons`

- set de iconos estilo iOS

#### `google_fonts`

- tipografía custom del theme
- actualmente se usa `Manrope`

#### `intl`

- fechas
- formatos localizados
- soporte de locale para montos y textos de fechas

## State management

#### `flutter_riverpod`

- providers
- dependency injection
- controllers y providers asíncronos

## Security

#### `cryptography`

- PBKDF2 para PIN y recuperación

#### `flutter_secure_storage`

- persistencia segura de PIN y datos de recuperación

#### `local_auth`

- autenticación biométrica

## Local persistence / files

#### `sqflite`

- base SQLite local

#### `path`

- composición de paths, principalmente para DB

#### `path_provider`

- directorios locales, usados por export de backup

#### `file_picker`

- elegir archivos JSON al importar backup

#### `share_plus`

- compartir archivo exportado del backup

## Utilities

#### `uuid`

- IDs para movimientos, categorías, metas y presupuestos

## Development dependencies

#### `flutter_test`

- framework de tests

#### `flutter_launcher_icons`

- generación de iconos launcher

#### `flutter_lints`

- reglas base de lint

#### `mocktail`

- mocking en tests

#### `pdf`

- tooling de generación PDF usado desde scripts/utilidades del repo, no desde el flujo principal de runtime revisado

## Notas

- no hay paquete de routing declarativo
- no hay cliente HTTP
- no hay dependencias de backend o sync cloud
- el soporte real por plataforma debe leerse junto con [`build-and-run.md`](D:/GITHUB/CleanFinance/docs/build-and-run.md)
