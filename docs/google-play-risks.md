# Riesgos de rechazo o fricción en Google Play - CleanFinance

## Riesgo alto

### 1. Política pública aún no alojada

El proyecto ya tiene política dentro de la app y documento listo para publicar, pero Google Play exige una URL pública, activa y no editable. Sin eso, la ficha no queda completa.

### 2. Keystore release aún pendiente de provisión definitiva

La configuración release ya no usa debug, pero el bundle final no puede generarse para Play sin `android/key.properties` y un upload keystore real.

## Riesgo medio

### 3. Datos sensibles de recuperación

La app pide fecha de nacimiento y documento personal para recuperación local. Aunque se guardan hasheados y no se envían a servidores, Google considera este tipo de dato como personal y sensible. Hay que mantener disclosures muy claros en onboarding, recovery y política pública.

### 4. Datos financieros locales sin cifrado de base

SQLite sigue sin cifrado en reposo. Eso no bloquea automáticamente Play, pero sí aumenta el riesgo de observación crítica si la política o la ficha sugieren una protección más fuerte de la que realmente existe.

### 5. Backups sin contraseña pueden quedar legibles

La app lo advierte correctamente, pero un usuario puede exportar JSON plano con movimientos y configuración. Es importante no prometer `datos siempre cifrados` en la ficha ni en la política.

## Riesgo bajo

### 6. Permiso biométrico

El permiso está alineado con una funcionalidad visible y esperable. El riesgo es bajo siempre que la ficha mencione protección local por PIN/biometría y que no se afirme falsamente que se almacenan biométricos.

### 7. Capturas de pantalla

Si se usan mocks, deben reflejar pantallas reales del producto. Como la app ya tiene UI consistente, lo recomendable es capturar el build release y evitar composiciones que parezcan features inexistentes.

## Recomendación final

Para una salida a testing interno o cerrado, el riesgo es manejable una vez firmado el bundle y alojada la política pública. Para producción abierta, conviene decidir antes si se mantiene la recuperación con documento personal, si se introduce cifrado de SQLite y si se obliga contraseña en exportación de backup.
