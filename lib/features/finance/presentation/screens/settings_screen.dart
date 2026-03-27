import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/widgets/brand_logo.dart';
import '../../../../shared/providers.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/section_card.dart';
import 'categories_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    final payload = await ref.read(financeRepositoryProvider).exportData();
    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      '${directory.path}/clean_finance_backup_${DateTime.now().millisecondsSinceEpoch}.json',
    );
    await file.writeAsString(payload);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Backup local de Clean Finance',
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backup generado en ${file.path}')),
      );
    }
  }

  Future<void> _importData(BuildContext context, WidgetRef ref) async {
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
          title: const Text('Importar backup'),
          content: const Text(
            'Esta acción reemplaza los datos actuales. Si querés, exportá un backup antes de seguir.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Importar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final payload = await File(path).readAsString();
    await ref.read(financeRepositoryProvider).importData(payload);
    ref.invalidate(settingsControllerProvider);
    ref.invalidate(financeOverviewProvider);
    ref.invalidate(dashboardSummaryProvider);
    ref.invalidate(recentMovementsProvider);
    ref.invalidate(reportsSnapshotProvider);
    ref.invalidate(savingsGoalsProvider);
    ref.invalidate(categoriesProvider);
    ref.invalidate(movementsProvider);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos importados correctamente.')),
      );
    }
  }

  Future<void> _clearAllData(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Borrar datos'),
          content: const Text(
            'Se eliminarán movimientos, metas y categorías personalizadas del dispositivo.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Borrar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await ref.read(financeRepositoryProvider).clearAllData();
    ref.invalidate(settingsControllerProvider);
    ref.invalidate(financeOverviewProvider);
    ref.invalidate(dashboardSummaryProvider);
    ref.invalidate(recentMovementsProvider);
    ref.invalidate(reportsSnapshotProvider);
    ref.invalidate(savingsGoalsProvider);
    ref.invalidate(categoriesProvider);
    ref.invalidate(movementsProvider);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Se restablecieron tus datos locales.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsControllerProvider);
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
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
                            'Una app simple, privada y clara',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Configurá la experiencia para que se sienta realmente tuya.',
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
                      'Apariencia',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<ThemeMode>(
                      initialValue: settings.themeMode,
                      decoration: const InputDecoration(labelText: 'Tema'),
                      items: const [
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text('Seguir sistema'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text('Claro'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text('Oscuro'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(settingsControllerProvider.notifier)
                              .setThemeMode(value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: settings.currencyCode,
                      decoration: const InputDecoration(labelText: 'Moneda'),
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
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seguridad',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mantené acceso rápido sin perder privacidad.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 14),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Desbloqueo con biometría'),
                      subtitle: Text(
                        authState.biometricAvailable
                            ? 'Usá huella o reconocimiento facial si está disponible.'
                            : 'Este dispositivo no tiene biometría disponible.',
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
                      decoration: const InputDecoration(
                        labelText: 'Bloqueo automático',
                      ),
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('1 minuto')),
                        DropdownMenuItem(value: 5, child: Text('5 minutos')),
                        DropdownMenuItem(value: 15, child: Text('15 minutos')),
                        DropdownMenuItem(value: 30, child: Text('30 minutos')),
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
                      label: const Text('Bloquear ahora'),
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
                      'Datos',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tus datos viven en tu dispositivo. Podés exportarlos o restaurarlos cuando quieras.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => _exportData(context, ref),
                      icon: const Icon(Icons.ios_share_rounded),
                      label: const Text('Exportar backup'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => _importData(context, ref),
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Importar backup'),
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
                      label: const Text('Gestionar categorías'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => _clearAllData(context, ref),
                      child: const Text('Borrar todos los datos'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const SectionCard(
                child: Text(
                  'Privacidad primero: no hay tracking, no se suben datos financieros y todo queda bajo tu control local.',
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
              title: 'No se pudieron cargar los ajustes',
              message: '$error',
            ),
          ],
        ),
      ),
    );
  }
}
