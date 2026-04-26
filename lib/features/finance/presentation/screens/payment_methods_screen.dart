import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_strings.dart';
import '../../../../core/utils/payment_method_utils.dart';
import '../providers/finance_providers.dart';
import '../utils/payment_method_icon_resolver.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/section_card.dart';

class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  Future<void> _showMethodDialog(
    BuildContext context,
    WidgetRef ref, {
    String? initialValue,
    int? index,
  }) async {
    final strings = AppStrings.of(context);
    final controller = TextEditingController(
      text: initialValue == null
          ? ''
          : strings.paymentMethodDisplayName(initialValue),
    );
    final currentMethods = List<String>.from(
        ref.read(settingsControllerProvider).valueOrNull?.paymentMethods ?? []);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            initialValue == null
                ? strings.addPaymentMethod
                : (strings.t('editarMedioDePago')),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: strings.movementPaymentMethod,
              hintText: strings.t('ejemploQrTransferenciaOEfectivo'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(strings.cancel),
            ),
            FilledButton(
              onPressed: () async {
                final value = PaymentMethodUtils.canonicalizeLabel(
                  controller.text,
                );
                if (value.isEmpty) {
                  return;
                }
                if (index != null) {
                  currentMethods[index] = value;
                } else {
                  currentMethods.add(value);
                }
                await ref
                    .read(settingsControllerProvider.notifier)
                    .setPaymentMethods(
                      PaymentMethodUtils.normalizeMethods(currentMethods),
                    );
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text(strings.save),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    final methods =
        ref.watch(settingsControllerProvider).valueOrNull?.paymentMethods ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(strings.managePaymentMethods)),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'payment-methods-fab',
        onPressed: () => _showMethodDialog(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: Text(strings.add),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.t('elegiSoloLosMediosDePagoQue'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  strings.t('estasOpcionesVanAAparecerComoDesplegable'),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (methods.isEmpty)
            EmptyStateView(
              icon: Icons.account_balance_wallet_outlined,
              title: strings.t('todaviaNoHayMediosDePago'),
              message: strings
                  .t('agregaTusOpcionesHabitualesComoTransferenciaDebito'),
              actionLabel: strings.addPaymentMethod,
              onAction: () => _showMethodDialog(context, ref),
            )
          else
            ...methods.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SectionCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              PaymentMethodIconResolver.resolve(entry.value),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              strings.paymentMethodDisplayName(entry.value),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _showMethodDialog(
                              context,
                              ref,
                              initialValue: entry.value,
                              index: entry.key,
                            ),
                            icon: const Icon(Icons.edit_outlined),
                          ),
                          IconButton(
                            onPressed: () async {
                              final updated = [...methods]..removeAt(entry.key);
                              await ref
                                  .read(settingsControllerProvider.notifier)
                                  .setPaymentMethods(updated);
                            },
                            icon: const Icon(Icons.delete_outline_rounded),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
