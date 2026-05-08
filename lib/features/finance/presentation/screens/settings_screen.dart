import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      title: strings.t('protegerBackup'),
      description: strings.t('agregaUnaContrasenaOpcionalSiLaDejas'),
      confirmLabel: strings.exportBackup,
    );
    if (password == null) {
      return;
    }

    final payload = await ref
        .read(dataManagementControllerProvider)
        .exportData(password: password);
    final filename =
        'clean_finance_backup_${DateTime.now().millisecondsSinceEpoch}.json';
    final file = XFile.fromData(
      utf8.encode(payload),
      name: filename,
      mimeType: 'application/json',
    );

    await Share.shareXFiles(
      [file],
      text: strings.t('backupLocalDeCleanfinance'),
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            password.trim().isEmpty
                ? '${strings.exportBackup}: $filename. ${strings.t('advertenciaElArchivoNoEstaCifrado')}'
                : '${strings.exportBackup}: $filename',
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
      withData: true,
    );
    final fileBytes = result?.files.single.bytes;
    if (fileBytes == null || !context.mounted) {
      return;
    }

    final confirmed = await showConfirmActionDialog(
      context: context,
      title: strings.importBackup,
      message: strings.t('estaAccionReemplazaraTusDatosLocalesActuales'),
      confirmLabel: strings.importBackup,
      cancelLabel: strings.cancel,
    );

    if (!confirmed) {
      return;
    }

    try {
      final payload = utf8.decode(fileBytes);
      if (!context.mounted) {
        return;
      }
      final password = await _requestBackupPassword(
        context,
        title: strings.t('importBackup'),
        description: strings.t('siEsteBackupFueProtegidoConContrasena'),
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
              strings.t('datosImportadosCorrectamente'),
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
      title: strings.t('borrarTodosLosDatos'),
      message: strings.t('estoEliminaraLaBaseLocalCompletaEl'),
      confirmLabel: strings.t('borrarTodo'),
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
            strings.t('seBorraronTodosLosDatosLocalesLa'),
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
                      labelText: strings.t('contrasenaOpcional'),
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
                            strings.t('unaAppSimplePrivadaYClara'),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            strings.t('configuraLaExperienciaParaQueSeSienta'),
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
              OutlinedButton.icon(
                onPressed: () {
                  ref.read(authControllerProvider.notifier).lock();
                },
                icon: const Icon(Icons.logout_rounded),
                label: Text(strings.exitApp),
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
                      strings.t('manteneAccesoRapidoSinPerderPrivacidad'),
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
                            ? strings.t('usaHuellaOReconocimientoFacialSiEsta')
                            : strings
                                .t('esteDispositivoNoTieneBiometriaDisponible'),
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
                        labelText: strings.t('bloqueoAutomatico'),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 1,
                          child: Text(strings.t('oneMinute')),
                        ),
                        DropdownMenuItem(
                          value: 5,
                          child: Text(strings.t('fiveMinutes')),
                        ),
                        DropdownMenuItem(
                          value: 15,
                          child: Text(strings.t('fifteenMinutes')),
                        ),
                        DropdownMenuItem(
                          value: 30,
                          child: Text(strings.t('thirtyMinutes')),
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
                      strings.t('revisaQueGuardaCleanfinanceDeFormaLocal'),
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
                          value: AppLocaleMode.portuguese.preferenceCode,
                          child: Text(strings.portuguese),
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
                        labelText: strings.t('tema'),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: AppThemePreference.system,
                          child: Text(
                            strings.t('seguirSistema'),
                          ),
                        ),
                        DropdownMenuItem(
                          value: AppThemePreference.light,
                          child: Text(strings.t('claro')),
                        ),
                        DropdownMenuItem(
                          value: AppThemePreference.dark,
                          child: Text(strings.t('oscuro')),
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
                        labelText: strings.t('moneda'),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'ARS',
                          child: Text(strings.currencyArsOption),
                        ),
                        DropdownMenuItem(
                          value: 'USD',
                          child: Text(strings.currencyUsdOption),
                        ),
                        DropdownMenuItem(
                          value: 'EUR',
                          child: Text(strings.currencyEurOption),
                        ),
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
                      strings.t('notificaciones'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strings.t('recibiRecordatoriosMensualesEnEsteTelefono'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 14),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        strings.t('notificacionesDelSistema'),
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
                        strings.t('horaDeRecordatorio'),
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
                      strings.t('organizacion'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strings.t('personalizaLasListasQueUsasTodosLos'),
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
                      strings.t('tusDatosVivenEnTuDispositivoPodes'),
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
                        strings.t('notaDeSeguridadLosBackupsLocalesPueden'),
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
                        strings.t('borrarTodosLosDatos'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                child: Text(
                  strings.t('privacidadPrimeroNoHayTrackingNoSe'),
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
              title: strings.t('noSePudieronCargarLosAjustes'),
              message: strings.technicalErrorDetails(error),
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
        strings.t('revisandoPermiso'),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
      ),
      error: (_, __) => Text(
        strings.t('noSePudoRevisarElPermiso'),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
      ),
    );
  }

  String _labelFor(CleanFinanceNotificationStatus status) {
    switch (status) {
      case CleanFinanceNotificationStatus.disabled:
        return strings.t('notificacionesDesactivadas');
      case CleanFinanceNotificationStatus.active:
        return strings.t('notificacionesActivadas');
      case CleanFinanceNotificationStatus.permissionPending:
        return strings.t('permisoPendiente');
      case CleanFinanceNotificationStatus.permissionDenied:
        return strings.t('permisoDenegado');
      case CleanFinanceNotificationStatus.unsupported:
        return strings.t('noDisponibleEnEstaPlataforma');
    }
  }
}
