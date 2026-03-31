import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_strings.dart';
import '../providers/finance_providers.dart';
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
    final controller = TextEditingController(text: initialValue ?? '');
    final currentMethods =
        List<String>.from(ref.read(settingsControllerProvider).valueOrNull?.paymentMethods ?? []);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            initialValue == null
                ? strings.addPaymentMethod
                : (strings.isEnglish ? 'Edit payment method' : 'Editar medio de pago'),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: strings.movementPaymentMethod,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(strings.cancel),
            ),
            FilledButton(
              onPressed: () async {
                final value = controller.text.trim();
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
                    .setPaymentMethods(currentMethods.toSet().toList());
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
                  strings.isEnglish
                      ? 'Choose the payment methods you really use'
                      : 'Elegí solo los medios de pago que realmente usás',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  strings.isEnglish
                      ? 'These options will appear as a dropdown when creating a movement.'
                      : 'Estas opciones van a aparecer como desplegable al cargar un movimiento.',
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
              title: strings.isEnglish
                  ? 'No payment methods yet'
                  : 'Todavía no hay medios de pago',
              message: strings.isEnglish
                  ? 'Add your common options like transfer, debit card or cash.'
                  : 'Agregá tus opciones habituales como transferencia, débito o efectivo.',
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
                          Expanded(
                            child: Text(
                              entry.value,
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
