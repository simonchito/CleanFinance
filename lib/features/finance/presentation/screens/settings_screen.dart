import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../shared/providers.dart';
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
    if (path == null) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Importar datos'),
          content: const Text(
            'La importación reemplaza los datos actuales. Asegurate de tener un backup.',
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
            'Esta acción elimina movimientos, metas y categorías personalizadas del dispositivo.',
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
    ref.invalidate(dashboardSummaryProvider);
    ref.invalidate(recentMovementsProvider);
    ref.invalidate(reportsSnapshotProvider);
    ref.invalidate(savingsGoalsProvider);
    ref.invalidate(categoriesProvider);
    ref.invalidate(movementsProvider);
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
            padding: const EdgeInsets.all(16),
            children: [
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personalización',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<ThemeMode>(
                      value: settings.themeMode,
                      decoration: const InputDecoration(labelText: 'Tema'),
                      items: const [
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text('Sistema'),
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
                      value: settings.currencyCode,
                      decoration: const InputDecoration(labelText: 'Moneda'),
                      items: const [
                        DropdownMenuItem(value: 'ARS', child: Text('ARS ($)')),
                        DropdownMenuItem(
                          value: 'USD',
                          child: Text('USD (US$)'),
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
              const SizedBox(height: 12),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seguridad',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Desbloqueo con biometría'),
                      subtitle: Text(
                        authState.biometricAvailable
                            ? 'Usá huella o Face ID/Touch ID según el dispositivo.'
                            : 'La biometría no está disponible en este dispositivo.',
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
                      value: settings.autoLockMinutes,
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
                    OutlinedButton(
                      onPressed: () {
                        ref.read(authControllerProvider.notifier).lock();
                      },
                      child: const Text('Bloquear ahora'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Datos',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => _exportData(context, ref),
                      child: const Text('Exportar backup'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => _importData(context, ref),
                      child: const Text('Importar backup'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CategoriesScreen(),
                          ),
                        );
                      },
                      child: const Text('Gestionar categorías'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => _clearAllData(context, ref),
                      child: const Text('Borrar todos los datos'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const SectionCard(
                child: Text(
                  'Privacidad: tus datos se guardan localmente en el dispositivo. La app no usa tracking ni envía información financiera a terceros.',
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('No se pudieron cargar los ajustes: $error'),
        ),
      ),
    );
  }
}
