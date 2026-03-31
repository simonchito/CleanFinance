import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/app_strings.dart';
import '../../../../brand_logo_asset.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../budgets/presentation/providers/budget_providers.dart';
import '../../../budgets/presentation/screens/budgets_screen.dart';
import '../../domain/entities/app_theme_preference.dart';
import '../providers/finance_providers.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/section_card.dart';
import 'categories_screen.dart';
import 'payment_methods_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    final strings = AppStrings.of(context);
    final payload = await ref.read(backupRepositoryProvider).exportData();
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
        SnackBar(content: Text('${strings.exportBackup}: ${file.path}')),
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

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(strings.importBackup),
          content: Text(
            strings.isEnglish
                ? 'This will replace your current data. Export a backup first if you want a copy.'
                : 'Esta acción reemplaza los datos actuales. Si querés, exportá un backup antes de seguir.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(strings.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(strings.importBackup),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final payload = await File(path).readAsString();
    await ref.read(backupRepositoryProvider).importData(payload);
    ref.invalidate(settingsControllerProvider);
    ref.invalidate(financeOverviewProvider);
    ref.invalidate(dashboardSummaryProvider);
    ref.invalidate(recentMovementsProvider);
    ref.invalidate(reportsSnapshotProvider);
    ref.invalidate(savingsGoalsProvider);
    ref.invalidate(categoriesProvider);
    ref.invalidate(movementsProvider);
    ref.invalidate(monthlyDueRemindersProvider);
    ref.invalidate(categoryBudgetStatusProvider);

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
  }

  Future<void> _clearAllData(BuildContext context, WidgetRef ref) async {
    final strings = AppStrings.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(strings.isEnglish ? 'Delete data' : 'Borrar datos'),
          content: Text(
            strings.isEnglish
                ? 'Movements, goals and custom categories will be removed from this device.'
                : 'Se eliminarán movimientos, metas y categorías personalizadas del dispositivo.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(strings.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(strings.isEnglish ? 'Delete' : 'Borrar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await ref.read(backupRepositoryProvider).clearAllData();
    ref.invalidate(settingsControllerProvider);
    ref.invalidate(financeOverviewProvider);
    ref.invalidate(dashboardSummaryProvider);
    ref.invalidate(recentMovementsProvider);
    ref.invalidate(reportsSnapshotProvider);
    ref.invalidate(savingsGoalsProvider);
    ref.invalidate(categoriesProvider);
    ref.invalidate(movementsProvider);
    ref.invalidate(monthlyDueRemindersProvider);
    ref.invalidate(categoryBudgetStatusProvider);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            strings.isEnglish
                ? 'Local data was reset.'
                : 'Se restablecieron tus datos locales.',
          ),
        ),
      );
    }
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
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                            strings.isEnglish ? 'Follow system' : 'Seguir sistema',
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
                      title: Text(strings.showAmounts),
                      subtitle: Text(strings.amountPrivacyDescription),
                      value: settings.showSensitiveAmounts,
                      onChanged: (value) {
                        ref
                            .read(settingsControllerProvider.notifier)
                            .setShowSensitiveAmounts(value);
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
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                      value: settings.biometricEnabled,
                      onChanged: (value) async {
                        final success = await ref
                            .read(authControllerProvider.notifier)
                            .setBiometricEnabled(value);
                        if (success) {
                          await ref
                              .read(settingsControllerProvider.notifier)
                              .setBiometricEnabled(value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      initialValue: settings.autoLockMinutes,
                      decoration: InputDecoration(
                        labelText: strings.isEnglish ? 'Auto lock' : 'Bloqueo automático',
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 1,
                          child: Text(strings.isEnglish ? '1 minute' : '1 minuto'),
                        ),
                        DropdownMenuItem(
                          value: 5,
                          child: Text(strings.isEnglish ? '5 minutes' : '5 minutos'),
                        ),
                        DropdownMenuItem(
                          value: 15,
                          child: Text(strings.isEnglish ? '15 minutes' : '15 minutos'),
                        ),
                        DropdownMenuItem(
                          value: 30,
                          child: Text(strings.isEnglish ? '30 minutes' : '30 minutos'),
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
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 16),
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

