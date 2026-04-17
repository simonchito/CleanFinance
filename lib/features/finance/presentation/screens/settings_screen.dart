import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/app_strings.dart';
import '../../../../brand_logo_asset.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../budgets/presentation/screens/budgets_screen.dart';
import '../../domain/entities/app_theme_preference.dart';
import '../controllers/data_management_controller.dart';
import '../providers/finance_providers.dart';
import '../widgets/confirm_action_dialog.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/section_card.dart';
import 'categories_screen.dart';
import 'manage_reminders_screen.dart';
import 'payment_methods_screen.dart';
import 'privacy_policy_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    final strings = AppStrings.of(context);
    final password = await _requestBackupPassword(
      context,
      title: strings.isEnglish ? 'Protect backup' : 'Proteger backup',
      description: strings.isEnglish
          ? 'Add an optional password. If you leave it empty, the backup will be exported as readable JSON.'
          : 'Agregá una contraseña opcional. Si la dejás vacía, el backup se exportará como JSON legible.',
      confirmLabel: strings.exportBackup,
    );
    if (password == null) {
      return;
    }

    final payload = await ref
        .read(dataManagementControllerProvider)
        .exportData(password: password);
    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      '${directory.path}/clean_finance_backup_${DateTime.now().millisecondsSinceEpoch}.json',
    );
    await file.writeAsString(payload);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: strings.isEnglish
          ? 'Local backup from CleanFinance'
          : 'Backup local de CleanFinance',
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            password.trim().isEmpty
                ? '${strings.exportBackup}: ${file.path}. Advertencia: el archivo no está cifrado.'
                : '${strings.exportBackup}: ${file.path}',
          ),
        ),
      );
    }
  }

  Future<void> _importData(BuildContext context, WidgetRef ref) async {
    final strings = AppStrings.of(context);
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    final path = result?.files.single.path;
    if (path == null || !context.mounted) {
      return;
    }

    final confirmed = await showConfirmActionDialog(
      context: context,
      title: strings.importBackup,
      message: strings.isEnglish
          ? 'This will replace your current local data. The file will be validated before importing so your existing data stays untouched if something is wrong.'
          : 'Esta acción reemplazará tus datos locales actuales. El archivo se validará antes de importar para no tocar tus datos si encuentra problemas.',
      confirmLabel: strings.importBackup,
      cancelLabel: strings.cancel,
    );

    if (!confirmed) {
      return;
    }

    try {
      final payload = await File(path).readAsString();
      if (!context.mounted) {
        return;
      }
      final password = await _requestBackupPassword(
        context,
        title: strings.isEnglish ? 'Import backup' : 'Importar backup',
        description: strings.isEnglish
            ? 'If this backup was protected with a password, enter it now. Leave it empty for plain JSON backups.'
            : 'Si este backup fue protegido con contraseña, ingresala ahora. Si es un JSON plano, dejala vacía.',
        confirmLabel: strings.importBackup,
      );
      if (!context.mounted) {
        return;
      }
      if (password == null) {
        return;
      }

      await ref
          .read(dataManagementControllerProvider)
          .importData(payload, password: password);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              strings.isEnglish
                  ? 'Data imported successfully.'
                  : 'Datos importados correctamente.',
            ),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        final message =
            error is FormatException ? error.message : error.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  Future<void> _clearAllData(BuildContext context, WidgetRef ref) async {
    final strings = AppStrings.of(context);
    final confirmed = await showConfirmActionDialog(
      context: context,
      title: strings.isEnglish ? 'Delete all data' : 'Borrar todos los datos',
      message: strings.isEnglish
          ? 'This will remove the full local database, PIN, recovery data and biometric flags, leaving the app as a clean install.'
          : 'Esto eliminará la base local completa, el PIN, los datos de recuperación y las banderas de biometría, dejando la app como una instalación limpia.',
      confirmLabel: strings.isEnglish ? 'Delete everything' : 'Borrar todo',
      cancelLabel: strings.cancel,
    );

    if (!confirmed) {
      return;
    }

    await ref.read(dataManagementControllerProvider).clearAllData();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            strings.isEnglish
                ? 'All local data was deleted. The app is now in clean-install state.'
                : 'Se borraron todos los datos locales. La app quedó en estado de instalación limpia.',
          ),
        ),
      );
    }
  }

  Future<String?> _requestBackupPassword(
    BuildContext context, {
    required String title,
    required String description,
    required String confirmLabel,
  }) async {
    final strings = AppStrings.of(context);
    final controller = TextEditingController();
    var obscureText = true;

    final result = await showDialog<String?>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(description),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      labelText: strings.isEnglish
                          ? 'Password (optional)'
                          : 'Contraseña (opcional)',
                      suffixIcon: IconButton(
                        onPressed: () =>
                            setState(() => obscureText = !obscureText),
                        icon: Icon(
                          obscureText
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(null),
                  child: Text(strings.cancel),
                ),
                FilledButton(
                  onPressed: () =>
                      Navigator.of(dialogContext).pop(controller.text.trim()),
                  child: Text(confirmLabel),
                ),
              ],
            );
          },
        );
      },
    );

    controller.dispose();
    return result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    final settingsState = ref.watch(settingsControllerProvider);
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(strings.settings)),
      body: settingsState.when(
        data: (settings) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
            children: [
              SectionCard(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withValues(alpha: 0.38),
                  ],
                ),
                child: Row(
                  children: [
                    const BrandLogo(size: 58),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.isEnglish
                                ? 'A simple, private and clear app'
                                : 'Una app simple, privada y clara',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            strings.isEnglish
                                ? 'Adjust the experience so it really feels like yours.'
                                : 'Configurá la experiencia para que se sienta realmente tuya.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.privacy,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strings.isEnglish
                          ? 'Review what CleanFinance stores locally, how backups work, and what is never sent to servers.'
                          : 'Revisá qué guarda CleanFinance de forma local, cómo funcionan los backups y qué datos nunca se envían a servidores.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PrivacyPolicyScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.privacy_tip_outlined),
                      label: Text(strings.privacyPolicy),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.appearance,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: settings.localeCode,
                      decoration: InputDecoration(labelText: strings.language),
                      items: [
                        DropdownMenuItem(
                          value: 'es',
                          child: Text(strings.spanish),
                        ),
                        DropdownMenuItem(
                          value: 'en',
                          child: Text(strings.english),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null &&
                            AppConstants.supportedLocaleCodes.contains(value)) {
                          ref
                              .read(settingsControllerProvider.notifier)
                              .setLocaleCode(value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<AppThemePreference>(
                      initialValue: settings.themePreference,
                      decoration: InputDecoration(
                        labelText: strings.isEnglish ? 'Theme' : 'Tema',
                      ),
                      items: [
                        DropdownMenuItem(
                          value: AppThemePreference.system,
                          child: Text(
                            strings.isEnglish
                                ? 'Follow system'
                                : 'Seguir sistema',
                          ),
                        ),
                        DropdownMenuItem(
                          value: AppThemePreference.light,
                          child: Text(strings.isEnglish ? 'Light' : 'Claro'),
                        ),
                        DropdownMenuItem(
                          value: AppThemePreference.dark,
                          child: Text(strings.isEnglish ? 'Dark' : 'Oscuro'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(settingsControllerProvider.notifier)
                              .setThemePreference(value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: settings.currencyCode,
                      decoration: InputDecoration(
                        labelText: strings.isEnglish ? 'Currency' : 'Moneda',
                      ),
                      items: const [
                        DropdownMenuItem(value: 'ARS', child: Text('ARS (\$)')),
                        DropdownMenuItem(
                          value: 'USD',
                          child: Text('USD (US\$)'),
                        ),
                        DropdownMenuItem(value: 'EUR', child: Text('EUR (€)')),
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        final symbol = switch (value) {
                          'USD' => 'US\$',
                          'EUR' => '€',
                          _ => r'$',
                        };
                        ref
                            .read(settingsControllerProvider.notifier)
                            .setCurrency(code: value, symbol: symbol);
                      },
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(strings.hideAmounts),
                      subtitle: Text(strings.amountPrivacyDescription),
                      value: !settings.showSensitiveAmounts,
                      onChanged: (value) async {
                        final visible = !value;
                        ref
                            .read(showSensitiveAmountsOverrideProvider.notifier)
                            .state = visible;
                        await ref
                            .read(settingsControllerProvider.notifier)
                            .setShowSensitiveAmounts(visible);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.security,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strings.isEnglish
                          ? 'Keep fast access without losing privacy.'
                          : 'Mantené acceso rápido sin perder privacidad.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 14),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(strings.biometric),
                      subtitle: Text(
                        authState.biometricAvailable
                            ? (strings.isEnglish
                                ? 'Use fingerprint or face unlock if available.'
                                : 'Usá huella o reconocimiento facial si está disponible.')
                            : (strings.isEnglish
                                ? 'This device does not support biometrics.'
                                : 'Este dispositivo no tiene biometría disponible.'),
                      ),
                      value: authState.biometricEnabled,
                      onChanged: authState.biometricAvailable
                          ? (value) async {
                              final success = await ref
                                  .read(authControllerProvider.notifier)
                                  .setBiometricEnabled(value);
                              if (success) {
                                await ref
                                    .read(settingsControllerProvider.notifier)
                                    .setBiometricEnabled(value);
                              }
                            }
                          : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      initialValue: settings.autoLockMinutes,
                      decoration: InputDecoration(
                        labelText: strings.isEnglish
                            ? 'Auto lock'
                            : 'Bloqueo automático',
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 1,
                          child:
                              Text(strings.isEnglish ? '1 minute' : '1 minuto'),
                        ),
                        DropdownMenuItem(
                          value: 5,
                          child: Text(
                              strings.isEnglish ? '5 minutes' : '5 minutos'),
                        ),
                        DropdownMenuItem(
                          value: 15,
                          child: Text(
                              strings.isEnglish ? '15 minutes' : '15 minutos'),
                        ),
                        DropdownMenuItem(
                          value: 30,
                          child: Text(
                              strings.isEnglish ? '30 minutes' : '30 minutos'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(settingsControllerProvider.notifier)
                              .setAutoLockMinutes(value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        ref.read(authControllerProvider.notifier).lock();
                      },
                      icon: const Icon(Icons.lock_outline_rounded),
                      label: Text(strings.lockNow),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.isEnglish ? 'Organization' : 'Organización',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strings.isEnglish
                          ? 'Customize the lists you use every day so adding data stays quick and clear.'
                          : 'Personalizá las listas que usás todos los días para que cargar datos siga siendo rápido y claro.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PaymentMethodsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.account_balance_wallet_outlined),
                      label: Text(strings.managePaymentMethods),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ManageRemindersScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.notifications_active_outlined),
                      label: Text(strings.manageReminders),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CategoriesScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.category_outlined),
                      label: Text(strings.manageCategories),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const BudgetsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.account_balance_outlined),
                      label: Text(strings.manageBudgets),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.data,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strings.isEnglish
                          ? 'Your data lives on your device. You can export or restore it whenever you need.'
                          : 'Tus datos viven en tu dispositivo. Podés exportarlos o restaurarlos cuando quieras.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        strings.isEnglish
                            ? 'Security note: local backups can be exported as plain JSON. You can now add an optional password, but data stored in SQLite on the device is still not database-encrypted.'
                            : 'Nota de seguridad: los backups locales pueden exportarse como JSON plano. Ahora podés agregar una contraseña opcional, pero los datos guardados en SQLite dentro del dispositivo siguen sin cifrado de base.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () => _exportData(context, ref),
                      icon: const Icon(Icons.ios_share_rounded),
                      label: Text(strings.exportBackup),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => _importData(context, ref),
                      icon: const Icon(Icons.download_rounded),
                      label: Text(strings.importBackup),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => _clearAllData(context, ref),
                      child: Text(
                        strings.isEnglish
                            ? 'Delete all data'
                            : 'Borrar todos los datos',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                child: Text(
                  strings.isEnglish
                      ? 'Privacy first: no tracking, no financial data uploads and everything stays under your local control.'
                      : 'Privacidad primero: no hay tracking, no se suben datos financieros y todo queda bajo tu control local.',
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            EmptyStateView(
              icon: Icons.error_outline_rounded,
              title: strings.isEnglish
                  ? 'Could not load settings'
                  : 'No se pudieron cargar los ajustes',
              message: '$error',
            ),
          ],
        ),
      ),
    );
  }
}
