import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/app_strings.dart';
import '../../../../brand_logo_asset.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/localization/app_locale_mode.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../budgets/presentation/screens/budgets_screen.dart';
import '../../domain/entities/app_theme_preference.dart';
import '../controllers/data_management_controller.dart';
import '../controllers/notification_settings_controller.dart';
import '../providers/finance_providers.dart';
import '../providers/monthly_reminder_notification_providers.dart';
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
      title: strings.localized(
        es: 'Proteger backup',
        en: 'Protect backup',
        pt: 'Proteger backup',
      ),
      description: strings.localized(
        es: 'Agregá una contraseña opcional. Si la dejás vacía, el backup se exportará como JSON legible.',
        en: 'Add an optional password. If you leave it empty, the backup will be exported as readable JSON.',
        pt: 'Adicione uma senha opcional. Se deixar vazio, o backup será exportado como JSON legível.',
      ),
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
      text: strings.localized(
        es: 'Backup local de CleanFinance',
        en: 'Local backup from CleanFinance',
        pt: 'Backup local do CleanFinance',
      ),
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            password.trim().isEmpty
                ? '${strings.exportBackup}: ${file.path}. ${strings.localized(es: 'Advertencia: el archivo no está cifrado.', en: 'Warning: the file is not encrypted.', pt: 'Aviso: o arquivo não está criptografado.')}'
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
      message: strings.localized(
        es: 'Esta acción reemplazará tus datos locales actuales. El archivo se validará antes de importar para no tocar tus datos si encuentra problemas.',
        en: 'This will replace your current local data. The file will be validated before importing so your existing data stays untouched if something is wrong.',
        pt: 'Esta ação substituirá seus dados locais atuais. O arquivo será validado antes da importação para manter seus dados intactos se algo estiver errado.',
      ),
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
        title: strings.localized(
          es: 'Importar backup',
          en: 'Import backup',
          pt: 'Importar backup',
        ),
        description: strings.localized(
          es: 'Si este backup fue protegido con contraseña, ingresala ahora. Si es un JSON plano, dejala vacía.',
          en: 'If this backup was protected with a password, enter it now. Leave it empty for plain JSON backups.',
          pt: 'Se este backup foi protegido com senha, informe agora. Deixe vazio para backups em JSON simples.',
        ),
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
              strings.localized(
                es: 'Datos importados correctamente.',
                en: 'Data imported successfully.',
                pt: 'Dados importados com sucesso.',
              ),
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
      title: strings.localized(
        es: 'Borrar todos los datos',
        en: 'Delete all data',
        pt: 'Excluir todos os dados',
      ),
      message: strings.localized(
        es: 'Esto eliminará la base local completa, el PIN, los datos de recuperación y las banderas de biometría, dejando la app como una instalación limpia.',
        en: 'This will remove the full local database, PIN, recovery data and biometric flags, leaving the app as a clean install.',
        pt: 'Isso removerá todo o banco local, PIN, dados de recuperação e biometria, deixando o app como uma instalação limpa.',
      ),
      confirmLabel: strings.localized(
        es: 'Borrar todo',
        en: 'Delete everything',
        pt: 'Excluir tudo',
      ),
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
            strings.localized(
              es: 'Se borraron todos los datos locales. La app quedó en estado de instalación limpia.',
              en: 'All local data was deleted. The app is now in clean-install state.',
              pt: 'Todos os dados locais foram excluídos. O app voltou ao estado inicial.',
            ),
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
                      labelText: strings.localized(
                        es: 'Contraseña (opcional)',
                        en: 'Password (optional)',
                        pt: 'Senha (opcional)',
                      ),
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

  Future<void> _pickNotificationTime(
    BuildContext context,
    WidgetRef ref, {
    required int hour,
    required int minute,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
    );
    if (picked == null) {
      return;
    }
    await ref.read(notificationSettingsControllerProvider).setReminderTime(
          hour: picked.hour,
          minute: picked.minute,
        );
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
            cacheExtent: 1800,
            shrinkWrap: true,
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
                            strings.localized(
                              es: 'Una app simple, privada y clara',
                              en: 'A simple, private and clear app',
                              pt: 'Um app simples, privado e claro',
                            ),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            strings.localized(
                              es: 'Configurá la experiencia para que se sienta realmente tuya.',
                              en: 'Adjust the experience so it really feels like yours.',
                              pt: 'Ajuste a experiência para que ela fique do seu jeito.',
                            ),
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
                      strings.security,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strings.localized(
                        es: 'Mantené acceso rápido sin perder privacidad.',
                        en: 'Keep fast access without losing privacy.',
                        pt: 'Mantenha o acesso rápido sem perder privacidade.',
                      ),
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
                            ? strings.localized(
                                es: 'Usá huella o reconocimiento facial si está disponible.',
                                en: 'Use fingerprint or face unlock if available.',
                                pt: 'Use digital ou reconhecimento facial se estiver disponível.',
                              )
                            : strings.localized(
                                es: 'Este dispositivo no tiene biometría disponible.',
                                en: 'This device does not support biometrics.',
                                pt: 'Este dispositivo não tem biometria disponível.',
                              ),
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
                        labelText: strings.localized(
                          es: 'Bloqueo automático',
                          en: 'Auto lock',
                          pt: 'Bloqueio automático',
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 1,
                          child: Text(strings.localized(
                              es: '1 minuto', en: '1 minute')),
                        ),
                        DropdownMenuItem(
                          value: 5,
                          child: Text(strings.localized(
                              es: '5 minutos', en: '5 minutes')),
                        ),
                        DropdownMenuItem(
                          value: 15,
                          child: Text(strings.localized(
                              es: '15 minutos', en: '15 minutes')),
                        ),
                        DropdownMenuItem(
                          value: 30,
                          child: Text(strings.localized(
                              es: '30 minutos', en: '30 minutes')),
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
                      strings.privacy,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strings.localized(
                        es: 'Revisá qué guarda CleanFinance de forma local, cómo funcionan los backups y qué datos nunca se envían a servidores.',
                        en: 'Review what CleanFinance stores locally, how backups work, and what is never sent to servers.',
                        pt: 'Veja o que o CleanFinance guarda localmente, como os backups funcionam e o que nunca é enviado a servidores.',
                      ),
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
                      initialValue: AppConstants.normalizeLocalePreferenceCode(
                        settings.localeCode,
                      ),
                      decoration: InputDecoration(labelText: strings.language),
                      items: [
                        DropdownMenuItem(
                          value: AppLocaleMode.system.preferenceCode,
                          child: Text(strings.useDeviceLanguage),
                        ),
                        DropdownMenuItem(
                          value: AppLocaleMode.spanish.preferenceCode,
                          child: Text(strings.spanish),
                        ),
                        DropdownMenuItem(
                          value: AppLocaleMode.english.preferenceCode,
                          child: Text(strings.english),
                        ),
                        DropdownMenuItem(
                          value: AppLocaleMode.portugueseBrazil.preferenceCode,
                          child: Text(strings.portugueseBrazil),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null &&
                            AppConstants.supportedLocalePreferenceCodes
                                .contains(value)) {
                          ref
                              .read(settingsControllerProvider.notifier)
                              .setLocalePreferenceCode(value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<AppThemePreference>(
                      initialValue: settings.themePreference,
                      decoration: InputDecoration(
                        labelText: strings.localized(es: 'Tema', en: 'Theme'),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: AppThemePreference.system,
                          child: Text(
                            strings.localized(
                              es: 'Seguir sistema',
                              en: 'Follow system',
                              pt: 'Seguir sistema',
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: AppThemePreference.light,
                          child:
                              Text(strings.localized(es: 'Claro', en: 'Light')),
                        ),
                        DropdownMenuItem(
                          value: AppThemePreference.dark,
                          child:
                              Text(strings.localized(es: 'Oscuro', en: 'Dark')),
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
                        labelText:
                            strings.localized(es: 'Moneda', en: 'Currency'),
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
                      strings.localized(
                          es: 'Notificaciones', en: 'Notifications'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strings.localized(
                        es: 'Recibí recordatorios mensuales en este teléfono.',
                        en: 'Receive monthly reminders on this device.',
                        pt: 'Receba lembretes mensais neste dispositivo.',
                      ),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 14),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        strings.localized(
                          es: 'Notificaciones del sistema',
                          en: 'System notifications',
                          pt: 'Notificações do sistema',
                        ),
                      ),
                      subtitle: _NotificationStatusText(
                        strings: strings,
                      ),
                      value: settings.notificationsEnabled,
                      onChanged: (value) => ref
                          .read(notificationSettingsControllerProvider)
                          .setNotificationsEnabled(value),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.schedule_outlined),
                      title: Text(
                        strings.localized(
                          es: 'Hora de recordatorio',
                          en: 'Reminder time',
                          pt: 'Hora do lembrete',
                        ),
                      ),
                      subtitle: Text(
                        MaterialLocalizations.of(context).formatTimeOfDay(
                          TimeOfDay(
                            hour: settings.notificationReminderHour,
                            minute: settings.notificationReminderMinute,
                          ),
                        ),
                      ),
                      onTap: settings.notificationsEnabled
                          ? () => _pickNotificationTime(
                                context,
                                ref,
                                hour: settings.notificationReminderHour,
                                minute: settings.notificationReminderMinute,
                              )
                          : null,
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
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.localized(es: 'Organización', en: 'Organization'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strings.localized(
                        es: 'Personalizá las listas que usás todos los días para que cargar datos siga siendo rápido y claro.',
                        en: 'Customize the lists you use every day so adding data stays quick and clear.',
                        pt: 'Personalize as listas que você usa todos os dias para registrar dados com rapidez e clareza.',
                      ),
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
                      strings.localized(
                        es: 'Tus datos viven en tu dispositivo. Podés exportarlos o restaurarlos cuando quieras.',
                        en: 'Your data lives on your device. You can export or restore it whenever you need.',
                        pt: 'Seus dados ficam no dispositivo. Você pode exportar ou restaurar quando precisar.',
                      ),
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
                        strings.localized(
                          es: 'Nota de seguridad: los backups locales pueden exportarse como JSON plano. Ahora podés agregar una contraseña opcional, pero los datos guardados en SQLite dentro del dispositivo siguen sin cifrado de base.',
                          en: 'Security note: local backups can be exported as plain JSON. You can now add an optional password, but data stored in SQLite on the device is still not database-encrypted.',
                          pt: 'Nota de segurança: backups locais podem ser exportados como JSON simples. Agora você pode adicionar uma senha opcional, mas os dados no SQLite do dispositivo ainda não têm criptografia de banco.',
                        ),
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
                        strings.localized(
                          es: 'Borrar todos los datos',
                          en: 'Delete all data',
                          pt: 'Excluir todos os dados',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                child: Text(
                  strings.localized(
                    es: 'Privacidad primero: no hay tracking, no se suben datos financieros y todo queda bajo tu control local.',
                    en: 'Privacy first: no tracking, no financial data uploads and everything stays under your local control.',
                    pt: 'Privacidade em primeiro lugar: sem rastreamento, sem envio de dados financeiros e tudo sob seu controle local.',
                  ),
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
              title: strings.localized(
                es: 'No se pudieron cargar los ajustes',
                en: 'Could not load settings',
                pt: 'Não foi possível carregar as configurações',
              ),
              message: '$error',
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationStatusText extends ConsumerWidget {
  const _NotificationStatusText({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusState = ref.watch(cleanFinanceNotificationStatusProvider);
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return statusState.when(
      data: (status) => Text(
        _labelFor(status),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
      ),
      loading: () => Text(
        strings.localized(
          es: 'Revisando permiso...',
          en: 'Checking permission...',
          pt: 'Verificando permissão...',
        ),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
      ),
      error: (_, __) => Text(
        strings.localized(
          es: 'No se pudo revisar el permiso',
          en: 'Permission status unavailable',
          pt: 'Não foi possível verificar a permissão',
        ),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
      ),
    );
  }

  String _labelFor(CleanFinanceNotificationStatus status) {
    switch (status) {
      case CleanFinanceNotificationStatus.disabled:
        return strings.localized(
          es: 'Notificaciones desactivadas',
          en: 'Notifications are off',
          pt: 'Notificações desativadas',
        );
      case CleanFinanceNotificationStatus.active:
        return strings.localized(
          es: 'Notificaciones activadas',
          en: 'Notifications enabled',
          pt: 'Notificações ativadas',
        );
      case CleanFinanceNotificationStatus.permissionPending:
        return strings.localized(
          es: 'Permiso pendiente',
          en: 'Permission pending',
          pt: 'Permissão pendente',
        );
      case CleanFinanceNotificationStatus.permissionDenied:
        return strings.localized(
          es: 'Permiso denegado',
          en: 'Permission denied',
          pt: 'Permissão negada',
        );
      case CleanFinanceNotificationStatus.unsupported:
        return strings.localized(
          es: 'No disponible en esta plataforma',
          en: 'Not available on this platform',
          pt: 'Não disponível nesta plataforma',
        );
    }
  }
}
