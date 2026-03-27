import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/providers.dart';
import '../../domain/entities/movement.dart';
import '../../domain/entities/movement_filter.dart';
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
    ref.invalidate(dashboardSummaryProvider);
    ref.invalidate(recentMovementsProvider);
    ref.invalidate(reportsSnapshotProvider);
    ref.invalidate(savingsGoalsProvider);
    ref.invalidate(movementsProvider);
    setState(() {});
  }

  Future<void> _deleteMovement(Movement movement) async {
    await ref.read(financeRepositoryProvider).deleteMovement(movement.id);
    _refresh();
  }

  Future<void> _openFilters() async {
    DateTime? startDate = _filter.startDate;
    DateTime? endDate = _filter.endDate;
    String? selectedCategoryId = _filter.categoryId;
    final categories = await ref.read(categoriesProvider(null).future);

    if (!mounted) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
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
                children: [
                  Text(
                    'Filtros',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategoryId,
                    decoration: const InputDecoration(labelText: 'Categoría'),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('Todas'),
                      ),
                      ...categories.map(
                        (category) => DropdownMenuItem(
                          value: category.id,
                          child: Text(category.name),
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
                      const SizedBox(width: 12),
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
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setModalState(() {
                              startDate = null;
                              endDate = null;
                              selectedCategoryId = null;
                            });
                          },
                          child: const Text('Limpiar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            setState(() {
                              _filter = _filter.copyWith(
                                startDate: startDate,
                                endDate: endDate,
                                categoryId: selectedCategoryId,
                                clearDates: startDate == null && endDate == null,
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
    final symbol =
        ref.watch(settingsControllerProvider).valueOrNull?.currencySymbol ?? r'$';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Buscar por nota',
              prefixIcon: Icon(Icons.search),
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
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'Todos',
                  selected: _filter.type == null,
                  onTap: () => setState(() {
                    _filter = _filter.copyWith(clearType: true);
                  }),
                ),
                _FilterChip(
                  label: 'Ingresos',
                  selected: _filter.type == MovementType.income,
                  onTap: () => setState(() {
                    _filter = _filter.copyWith(type: MovementType.income);
                  }),
                ),
                _FilterChip(
                  label: 'Gastos',
                  selected: _filter.type == MovementType.expense,
                  onTap: () => setState(() {
                    _filter = _filter.copyWith(type: MovementType.expense);
                  }),
                ),
                _FilterChip(
                  label: 'Ahorros',
                  selected: _filter.type == MovementType.saving,
                  onTap: () => setState(() {
                    _filter = _filter.copyWith(type: MovementType.saving);
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          movementsState.when(
            data: (movements) {
              if (movements.isEmpty) {
                return const SectionCard(
                  child: Text('No hay movimientos para este filtro.'),
                );
              }

              return SectionCard(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: movements.map((movement) {
                    final color = switch (movement.type) {
                      MovementType.income => Colors.green.shade700,
                      MovementType.expense => Colors.red.shade700,
                      MovementType.saving =>
                        Theme.of(context).colorScheme.primary,
                    };

                    return ListTile(
                      title: Text(movement.categoryName ?? 'Sin categoría'),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(movement.occurredOn) +
                            (movement.note?.isNotEmpty == true
                                ? ' · ${movement.note}'
                                : ''),
                      ),
                      trailing: Text(
                        CurrencyFormatter.format(movement.amount, symbol: symbol),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: color),
                      ),
                      onTap: () => _openEditor(movement),
                      onLongPress: () => _deleteMovement(movement),
                    );
                  }).toList(),
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Text('No se pudieron cargar movimientos: $error'),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
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
