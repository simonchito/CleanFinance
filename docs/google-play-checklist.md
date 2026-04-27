# Google Play Checklist - CleanFinance

Estado evaluado sobre el código del repositorio el 2026-04-27.

## 1. Identidad y build Android

- [x] `applicationId` y `namespace` dejan de usar `com.example.*`
- [x] `MainActivity` queda alineada con el package Android final
- [x] `compileSdk` fijado en 36
- [x] `targetSdk` fijado en 35
- [x] `minSdk` fijado en 24 para coincidir con `local_auth`
- [x] la build `release` ya no usa firma debug
- [x] la build `release` exige `android/key.properties` con keystore real antes de compilar
- [ ] generar y resguardar un upload keystore definitivo fuera del control de versiones
- [ ] completar `android/key.properties` en la máquina que va a firmar la release
- [ ] compilar el `.aab` final firmado con `flutter build appbundle --release`

## 2. Requisitos Play Store

- [x] validado contra documentación oficial: desde el 2025-08-31 las apps nuevas deben apuntar a Android 15 / API 35 o superior
- [x] manifest principal sin permisos peligrosos no justificados
- [x] permiso biométrico declarado para el prompt del sistema
- [x] `MainActivity` usa `FlutterFragmentActivity`, requisito del plugin `local_auth`
- [x] tema Android migrado a AppCompat para evitar problemas del diálogo biométrico en Android 8+
- [ ] revisar en el App Bundle final los permisos efectivos del manifest merge antes de subir a Play Console

## 3. Política de privacidad

- [x] creada una política de privacidad basada en el código real
- [x] política visible dentro de la app
- [x] documento listo para alojar públicamente en `docs/privacy-policy.html`
- [ ] publicar esa política en una URL pública, activa y no editable
- [ ] completar el contacto legal/privacidad definitivo del developer profile

## 4. Data Safety

- [x] inventario de datos documentado en `docs/google-play-data-safety.md`
- [x] evaluación basada en código: no hay recolección off-device por parte del desarrollador
- [x] evaluación basada en código: no hay sharing con terceros por SDKs o backend
- [ ] completar el formulario de Data Safety en Play Console siguiendo ese documento

## 5. Store Listing

- [x] nombre propuesto alineado al código: `CleanFinance`
- [x] categoría propuesta: `Finance`
- [x] descripciones corta y larga propuestas en `docs/google-play-store-listing.md`
- [x] plan de screenshots definido sin inventar features
- [ ] capturar screenshots reales desde un dispositivo o emulador release
- [ ] preparar ícono 512x512 y feature graphic 1024x500 para la ficha si aún no existen fuera del launcher icon

## 6. Riesgos antes de producción

- [x] identificados riesgos de rechazo y compliance en `docs/google-play-risks.md`
- [ ] decidir si la app va a mantener recuperación con fecha de nacimiento + documento en producción
- [ ] decidir si se va a cifrar SQLite antes del lanzamiento general
- [ ] revisar textos de onboarding/recovery para asegurar disclosure suficiente del uso de datos sensibles

## Veredicto operativo

Hoy el proyecto queda cercano a publicable para una subida a testing interno o cerrado, pero no debería considerarse listo para producción abierta hasta completar los pendientes marcados arriba.
