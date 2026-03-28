# 💸 CleanFinance

**CleanFinance** es una aplicación de finanzas personales enfocada en la simplicidad, privacidad y control total del usuario sobre sus datos.

Diseñada para personas no expertas en finanzas, permite gestionar ingresos, gastos, ahorros y reportes de forma clara, intuitiva y completamente offline.

---

## 🚀 Filosofía del producto

* 🔒 **Privacidad primero**: todos los datos se almacenan localmente
* 📱 **Offline-first**: no depende de internet
* 🧠 **Simplicidad real**: sin conceptos financieros complejos
* ⚡ **Rápida y liviana**: optimizada para uso diario
* 🎯 **Enfocada en hábitos**: no solo registro, sino mejora financiera

---

## 🧩 Funcionalidades principales (MVP)

### 🔐 Seguridads

* Autenticación con PIN
* Soporte para biometría (huella / face unlock)
* Almacenamiento seguro de credenciales

### 📊 Dashboard

* Resumen financiero general
* Balance actual
* Distribución de gastos
* Indicadores visuales simples

### 💳 Movimientos

* Registro de ingresos y gastos
* Categorización
* Historial de transacciones

### 🏷️ Categorías

* Categorías predefinidas
* Personalización futura

### 🎯 Ahorro

* Creación de metas de ahorro
* Seguimiento de progreso

### 📈 Reportes

* Visualización de hábitos financieros
* Análisis simple por categorías

### 🔄 Backup & Restore

* Exportación a JSON
* Importación manual de datos

---

## 🏗️ Arquitectura

La aplicación sigue una arquitectura modular basada en features:

```
lib/
│
├── app/            # Configuración global (theme, routes)
├── core/           # Lógica base (utils, constants, services)
├── features/       # Módulos funcionales (auth, finance, reports, etc.)
├── shared/         # Widgets reutilizables
```

### 🧠 Principios aplicados

* Separación de responsabilidades
* Escalabilidad por módulos
* Código reutilizable
* Bajo acoplamiento

---

## ⚙️ Stack tecnológico

* **Framework**: Flutter
* **Lenguaje**: Dart
* **State Management**: Riverpod
* **Base de datos**: SQLite (`sqflite`)
* **Seguridad**:

    * `flutter_secure_storage`
    * `local_auth`
* **Persistencia local**: offline-first

---

## ▶️ Cómo ejecutar el proyecto

### 1. Clonar el repositorio

```bash
git clone https://github.com/simonchito/CleanFinance.git
cd CleanFinance
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Ejecutar la app

```bash
flutter run
```

---

## 📦 Generar APK (release)

Para generar una APK lista para instalar:

```bash
flutter build apk --release
```

El archivo se genera en:

```
build/app/outputs/flutter-apk/app-release.apk
```

### 🔧 Personalizar nombre del APK

Podés renombrarlo manualmente a:

```
CleanFinance.apk
```

> ⚠️ Para distribución profesional, se recomienda firmar la APK con keystore propio.

---

## 🎨 UI / UX (visión)

La app apunta a un diseño:

* Minimalista
* Intuitivo
* Sin ruido visual
* Enfocado en claridad de información
* Con uso de gráficos simples y útiles

---

## 🛣️ Roadmap

### MVP (actual)

* ✔️ Registro de movimientos
* ✔️ Seguridad local
* ✔️ Dashboard básico
* ✔️ Persistencia local

### Próximas mejoras

* 📊 Gráficos avanzados
* 🔔 Alertas y recordatorios
* 💡 Recomendaciones financieras
* 🌐 Sincronización opcional (cloud)
* 🏷️ Gestión avanzada de categorías
* 📅 Presupuestos mensuales

---

## 🤝 Contribución

Este proyecto está en evolución. Se aceptan ideas, mejoras y sugerencias.

---

## 📄 Licencia

Definir licencia (MIT recomendada)

---

## 👨‍💻 Autor

**Facundo Simón Gastiarena**

* Técnico de Software
* Consultor SAP VIM / OpenText
* Desarrollador

---

## 💡 Visión a futuro

CleanFinance busca convertirse en una herramienta accesible, potente y confiable para el control financiero personal, sin comprometer la privacidad del usuario.

---


## Documentación

- Plan maestro: `docs/plan_maestro.md`
