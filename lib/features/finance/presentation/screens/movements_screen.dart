import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/payment_method_utils.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/providers.dart';
import '../../domain/entities/movement.dart';
import '../../domain/entities/movement_filter.dart';
import '../providers/finance_providers.dart';
import '../utils/payment_method_icon_resolver.dart';
import '../widgets/confirm_action_dialog.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/selection_sheet_field.dart';
import '../widgets/section_card.dart';
import 'categories_screen.dart';
import 'movement_form_screen.dart';

class MovementsScreen extends ConsumerStatefulWidget {
  const MovementsScreen({super.key});

  @override
  ConsumerState<MovementsScreen> createState() => _MovementsScreenState();
}

class _MovementsScreenState extends ConsumerState<MovementsScreen> {
  MovementFilter _filter = const MovementFilter();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openEditor([Movement? movement]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MovementFormScreen(initialMovement: movement),
      ),
    );
    _refresh();
  }

  void _refresh() {
    ref.invalidate(financeOverviewProvider);
    ref.invalidate(dashboardSummaryProvider);
    ref.invalidate(recentMovementsProvider);
    ref.invalidate(reportsSnapshotProvider);
    ref.invalidate(savingsGoalsProvider);
    ref.invalidate(movementsProvider);
    ref.invalidate(monthlyDueRemindersProvider);
    setState(() {});
  }

  Future<void> _deleteMovement(Movement movement) async {
    final confirmed = await showConfirmActionDialog(
      context: context,
      title: 'Eliminar movimiento',
      message:
          'Se eliminará este movimiento de forma permanente. Verificá los datos antes de continuar.',
      confirmLabel: 'Eliminar',
    );
    if (!confirmed) {
      return;
    }

    await ref.read(movementsRepositoryProvider).deleteMovement(movement.id);
    _refresh();
  }

  Future<void> _openFilters() async {
    DateTime? startDate = _filter.startDate;
    DateTime? endDate = _filter.endDate;
    String? selectedCategoryId = _filter.categoryId;
    final categories = await ref.read(categoriesProvider(null).future);
    final topLevelCategories =
        categories.where((category) => category.parentId == null).toList();

    if (!mounted) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              Future<void> pickStart() async {
                final picked = await showDatePicker(
                  context: context,
                  locale: const Locale('es'),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  initialDate: startDate ?? DateTime.now(),
                );
                if (picked != null) {
                  setModalState(() => startDate = picked);
                }
              }

              Future<void> pickEnd() async {
                final picked = await showDatePicker(
                  context: context,
                  locale: const Locale('es'),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  initialDate: endDate ?? DateTime.now(),
                );
                if (picked != null) {
                  setModalState(() => endDate = picked);
                }
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filtrar movimientos',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Elegí solo lo necesario para encontrar rápido lo que buscás.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 18),
                  SelectionSheetField<String?>(
                    label: 'Categoría',
                    value: selectedCategoryId,
                    placeholder: 'Todas',
                    sheetTitle: 'Categoría',
                    sheetDescription:
                        'Filtrá por una categoría principal para acotar la búsqueda.',
                    items: [
                      const SelectionSheetItem<String?>(
                        value: null,
                        label: 'Todas',
                        iconData: Icons.layers_clear_outlined,
                      ),
                      ...topLevelCategories.map(
                        (category) => SelectionSheetItem<String?>(
                          value: category.id,
                          label: category.name,
                          iconKey: category.iconKey,
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setModalState(() => selectedCategoryId = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: pickStart,
                          child: Text(
                            startDate == null
                                ? 'Desde'
                                : DateFormat('dd/MM/yyyy').format(startDate!),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: pickEnd,
                          child: Text(
                            endDate == null
                                ? 'Hasta'
                                : DateFormat('dd/MM/yyyy').format(endDate!),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _filter = const MovementFilter();
                              _searchController.clear();
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text('Limpiar'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            setState(() {
                              _filter = _filter.copyWith(
                                startDate: startDate,
                                endDate: endDate,
                                categoryId: selectedCategoryId,
                                clearDates:
                                    startDate == null && endDate == null,
                                clearCategory: selectedCategoryId == null,
                              );
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text('Aplicar'),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final movementsState = ref.watch(movementsProvider(_filter));
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final symbol = settings?.currencySymbol ?? r'$';
    final localeCode = settings?.localeCode ?? 'es';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movimientos'),
        actions: [
          IconButton(
            onPressed: _openFilters,
            icon: const Icon(Icons.filter_alt_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CategoriesScreen()),
              );
            },
            icon: const Icon(Icons.category_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'movements-fab',
        onPressed: _openEditor,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuevo'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Buscar por nota o referencia',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _filter = _filter.copyWith(
                        search: value.trim().isEmpty ? null : value.trim(),
                        clearSearch: value.trim().isEmpty,
                      );
                    });
                  },
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _TypeChip(
                        label: 'Todos',
                        selected: _filter.type == null,
                        onTap: () => setState(() {
                          _filter = _filter.copyWith(clearType: true);
                        }),
                      ),
                      _TypeChip(
                        label: 'Ingresos',
                        selected: _filter.type == MovementType.income,
                        onTap: () => setState(() {
                          _filter = _filter.copyWith(type: MovementType.income);
                        }),
                      ),
                      _TypeChip(
                        label: 'Gastos',
                        selected: _filter.type == MovementType.expense,
                        onTap: () => setState(() {
                          _filter =
                              _filter.copyWith(type: MovementType.expense);
                        }),
                      ),
                      _TypeChip(
                        label: 'Ahorro',
                        selected: _filter.type == MovementType.saving,
                        onTap: () => setState(() {
                          _filter = _filter.copyWith(type: MovementType.saving);
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          movementsState.when(
            data: (movements) {
              if (movements.isEmpty) {
                return EmptyStateView(
                  icon: Icons.receipt_long_outlined,
                  title: 'No encontramos movimientos',
                  message:
                      'Probá cambiando el filtro o agregando un nuevo registro.',
                  actionLabel: 'Agregar movimiento',
                  onAction: _openEditor,
                );
              }

              return Column(
                children: movements.map((movement) {
                  final scheme = Theme.of(context).colorScheme;
                  final (icon, color, prefix) = switch (movement.type) {
                    MovementType.income => (
                        Icons.arrow_upward_rounded,
                        scheme.primary,
                        '+',
                      ),
                    MovementType.expense => (
                        Icons.arrow_downward_rounded,
                        scheme.error,
                        '-',
                      ),
                    MovementType.saving => (
                        Icons.savings_rounded,
                        scheme.secondary,
                        '+',
                      ),
                  };

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SectionCard(
                      onTap: () => _openEditor(movement),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(icon, color: color),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movement.subcategoryName ??
                                      movement.categoryName ??
                                      'Sin categoría',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  [
                                    if (movement.subcategoryName != null &&
                                        movement.categoryName != null)
                                      movement.categoryName!,
                                    DateFormat('d MMM yyyy', 'es')
                                        .format(movement.occurredOn),
                                    if (movement.note?.isNotEmpty == true)
                                      movement.note!,
                                  ].join(' · '),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: scheme.onSurfaceVariant,
                                      ),
                                ),
                                if (movement.paymentMethod?.isNotEmpty ==
                                    true) ...[
                                  const SizedBox(height: 10),
                                  _MovementMetadataChip(
                                    icon: PaymentMethodIconResolver.resolve(
                                      movement.paymentMethod!,
                                    ),
                                    label: PaymentMethodUtils.canonicalizeLabel(
                                      movement.paymentMethod!,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '$prefix ${CurrencyFormatter.format(movement.amount, symbol: symbol, localeCode: localeCode)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(color: color),
                              ),
                              const SizedBox(height: 10),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                onPressed: () => _deleteMovement(movement),
                                icon: const Icon(Icons.delete_outline_rounded),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => EmptyStateView(
              icon: Icons.error_outline_rounded,
              title: 'No se pudieron cargar los movimientos',
              message: '$error',
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _MovementMetadataChip extends StatelessWidget {
  const _MovementMetadataChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
