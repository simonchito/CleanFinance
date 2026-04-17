import 'package:flutter/material.dart';

import '../../../../app/app_strings.dart';
import '../widgets/section_card.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final sections = _buildSections(strings.isEnglish);

    return Scaffold(
      appBar: AppBar(title: Text(strings.privacyPolicy)),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        itemCount: sections.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final section = sections[index];
          return SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                ...section.paragraphs.map(
                  (paragraph) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SelectableText(
                      paragraph,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<_PolicySection> _buildSections(bool isEnglish) {
    if (isEnglish) {
      return const [
        _PolicySection(
          title: 'Summary',
          paragraphs: [
            'CleanFinance is an offline-first personal finance app. The app does not create online accounts, does not upload your financial records to developer servers, and does not include analytics, advertising, or tracking SDKs.',
            'This in-app privacy policy summarizes the data handling that can be confirmed from the current source code. The public privacy policy URL published in Google Play should mirror this text and include the final developer contact details.',
          ],
        ),
        _PolicySection(
          title: 'Data stored on your device',
          paragraphs: [
            'CleanFinance stores your categories, movements, savings goals, budgets, payment methods, language, theme, amount visibility preference, auto-lock preference, and biometric preference in a local SQLite database on the device.',
            'The app also stores a hashed PIN, hashed recovery answers for birth date and personal document, and PIN lockout state in Android secure storage. Recovery answers are collected only to let you reset access on the same device if you forget your PIN.',
          ],
        ),
        _PolicySection(
          title: 'Biometrics and permissions',
          paragraphs: [
            'If you enable biometric unlock, CleanFinance asks Android to verify your fingerprint or face locally on the device. The app does not receive or store your biometric template.',
            'The Android build requests the biometric permission required to show the system biometric prompt. No location, contacts, camera, microphone, SMS, phone, or advertising permissions are declared in the main Android manifest.',
          ],
        ),
        _PolicySection(
          title: 'Backups and file sharing',
          paragraphs: [
            'You can export your data manually from Settings. Exports contain your local financial database and settings. If you leave the password blank, the export is saved as readable JSON. If you provide a password, the export is encrypted before you share or store it.',
            'Imports are initiated by you and replace the current local database only after file validation. CleanFinance does not automatically sync backups to developer servers.',
          ],
        ),
        _PolicySection(
          title: 'Sharing, retention, and deletion',
          paragraphs: [
            'The app does not share personal or financial data with the developer or third parties. Data remains on the device unless you explicitly export and share a backup yourself.',
            'Your data stays on the device until you delete it, clear the app, uninstall the app, or use the in-app action to delete all local data. Deleting all local data removes the SQLite database, secure storage credentials, recovery data, and biometric flags.',
          ],
        ),
        _PolicySection(
          title: 'Security notes',
          paragraphs: [
            'Financial data stored in SQLite is local but not encrypted at the database-file level. Sensitive authentication data is stored hashed in secure storage. Release builds also disable Android cloud backup to reduce unintended copies of local financial data.',
            'Because recovery uses birth date and personal document, anyone who knows those values and has the device could attempt a local reset. Users should protect the device itself with Android screen lock.',
          ],
        ),
        _PolicySection(
          title: 'Privacy contact',
          paragraphs: [
            'The official privacy contact channel for the published app must be the developer email shown on the Google Play listing for CleanFinance. Before production launch, make sure the hosted public privacy policy includes that exact contact address.',
          ],
        ),
      ];
    }

    return const [
      _PolicySection(
        title: 'Resumen',
        paragraphs: [
          'CleanFinance es una app de finanzas personales offline-first. No crea cuentas online, no sube tus registros financieros a servidores del desarrollador y no incluye SDKs de analítica, publicidad ni tracking.',
          'Esta política dentro de la app resume el tratamiento de datos que puede confirmarse desde el código fuente actual. La URL pública de política de privacidad que se publique en Google Play debe reflejar este mismo contenido e incluir el contacto final del desarrollador.',
        ],
      ),
      _PolicySection(
        title: 'Datos guardados en tu dispositivo',
        paragraphs: [
          'CleanFinance guarda en una base SQLite local las categorías, movimientos, metas de ahorro, presupuestos, medios de pago, idioma, tema, preferencia de ocultar montos, preferencia de bloqueo automático y preferencia de biometría.',
          'La app también guarda en almacenamiento seguro de Android un PIN hasheado, respuestas de recuperación hasheadas para fecha de nacimiento y documento personal, y el estado de bloqueos temporales por intentos fallidos. Las respuestas de recuperación se piden solo para restablecer acceso en este mismo dispositivo si olvidás el PIN.',
        ],
      ),
      _PolicySection(
        title: 'Biometría y permisos',
        paragraphs: [
          'Si activás el desbloqueo biométrico, CleanFinance le pide a Android que valide tu huella o rostro de forma local en el dispositivo. La app no recibe ni almacena tu plantilla biométrica.',
          'La versión Android solicita el permiso biométrico necesario para mostrar el diálogo del sistema. El manifest principal no declara permisos de ubicación, contactos, cámara, micrófono, SMS, teléfono ni publicidad.',
        ],
      ),
      _PolicySection(
        title: 'Backups y compartición de archivos',
        paragraphs: [
          'Podés exportar tus datos manualmente desde Ajustes. La exportación incluye tu base financiera local y la configuración. Si dejás la contraseña vacía, el archivo se guarda como JSON legible. Si ingresás una contraseña, el archivo se cifra antes de compartirlo o guardarlo.',
          'Las importaciones son iniciadas por vos y reemplazan la base local actual solo después de validar el archivo. CleanFinance no sincroniza backups automáticamente con servidores del desarrollador.',
        ],
      ),
      _PolicySection(
        title: 'Compartición, retención y borrado',
        paragraphs: [
          'La app no comparte datos personales ni financieros con el desarrollador ni con terceros. Los datos quedan en el dispositivo, salvo que vos decidas exportar y compartir un backup manualmente.',
          'Tus datos permanecen en el dispositivo hasta que los borres, limpies la app, desinstales la app o uses la acción interna para borrar todos los datos locales. Borrar todos los datos elimina la base SQLite, las credenciales en almacenamiento seguro, los datos de recuperación y las banderas de biometría.',
        ],
      ),
      _PolicySection(
        title: 'Notas de seguridad',
        paragraphs: [
          'Los datos financieros guardados en SQLite son locales, pero no tienen cifrado a nivel de archivo de base de datos. Los datos sensibles de autenticación se guardan hasheados en almacenamiento seguro. Además, las builds release desactivan el backup en la nube de Android para reducir copias no deseadas de datos financieros locales.',
          'Como la recuperación usa fecha de nacimiento y documento personal, alguien que conozca esos datos y tenga el dispositivo podría intentar un restablecimiento local. Por eso es importante proteger el equipo con bloqueo de pantalla de Android.',
        ],
      ),
      _PolicySection(
        title: 'Contacto de privacidad',
        paragraphs: [
          'El canal oficial de contacto de privacidad para la app publicada debe ser el correo de desarrollador que figure en la ficha de Google Play de CleanFinance. Antes de salir a producción, asegurate de que la política pública alojada incluya esa dirección exacta.',
        ],
      ),
    ];
  }
}

class _PolicySection {
  const _PolicySection({
    required this.title,
    required this.paragraphs,
  });

  final String title;
  final List<String> paragraphs;
}
