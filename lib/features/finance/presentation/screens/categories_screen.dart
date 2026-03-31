import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/providers.dart';
import '../../../budgets/presentation/providers/budget_providers.dart';
import '../../domain/entities/category.dart';
import '../providers/finance_providers.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Categorías'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Ingresos'),
              Tab(text: 'Gastos'),
              Tab(text: 'Ahorros'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _CategoryTab(scope: CategoryScope.income),
            _CategoryTab(scope: CategoryScope.expense),
            _CategoryTab(scope: CategoryScope.saving),
          ],
        ),
      ),
    );
  }
}

class _CategoryTab extends ConsumerWidget {
  const _CategoryTab({required this.scope});

  final CategoryScope scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(categoriesProvider(scope));

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'categories-${scope.name}-fab',
        onPressed: () => _showCategoryDialog(context, ref, scope: scope),
        child: const Icon(Icons.add),
      ),
      body: categoriesState.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No hay categorías.'));
          }

          final topLevel =
              categories.where((category) => category.parentId == null).toList();

          return ListView(
            padding: const EdgeInsets.all(12),
            children: topLevel.map((category) {
              final children = categories
                  .where((item) => item.parentId == category.id)
                  .toList();

              return Card(
                child: ExpansionTile(
                  title: Text(category.name),
                  subtitle: Text(
                    category.isDefault ? 'Predefinida' : 'Personalizada',
                  ),
                  children: [
                    for (final child in children)
                      _CategoryEntryRow(
                        icon: Icons.subdirectory_arrow_right,
                        title: child.name,
                        onEdit: () => _showCategoryDialog(
                          context,
                          ref,
                          scope: scope,
                          initial: child,
                        ),
                        onDelete: child.isDefault
                            ? null
                            : () => _deleteCategory(context, ref, child.id),
                      ),
                    _CategoryEntryRow(
                      title: category.name,
                      subtitle: 'Categoría principal',
                      onEdit: () => _showCategoryDialog(
                        context,
                        ref,
                        scope: scope,
                        initial: category,
                      ),
                      onDelete: category.isDefault
                          ? null
                          : () => _deleteCategory(context, ref, category.id),
                    ),
                    ListTile(
                      leading: const Icon(Icons.add),
                      title: const Text('Agregar subcategoría'),
                      onTap: () => _showCategoryDialog(
                        context,
                        ref,
                        scope: scope,
                        parentId: category.id,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Future<void> _deleteCategory(
    BuildContext context,
    WidgetRef ref,
    String categoryId,
  ) async {
    try {
      await ref.read(categoriesRepositoryProvider).deleteCategory(categoryId);
      ref.invalidate(categoriesProvider(scope));
      ref.invalidate(categoryBudgetStatusProvider);
      ref.invalidate(expenseReminderSubcategoriesProvider);
      ref.invalidate(monthlyDueRemindersProvider);
      ref.invalidate(financeOverviewProvider);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    }
  }

  Future<void> _showCategoryDialog(
    BuildContext context,
    WidgetRef ref, {
    required CategoryScope scope,
    Category? initial,
    String? parentId,
  }) async {
    final nameController = TextEditingController(text: initial?.name ?? '');
    String? selectedParentId = initial?.parentId ?? parentId;
    var reminderEnabled =
        initial?.isSubcategory == true && initial?.reminderEnabled == true;
    int? reminderDay = initial?.reminderDay ??
        ((initial?.isSubcategory == true || parentId != null)
            ? DateTime.now().day
            : null);
    final categories = await ref.read(categoriesProvider(scope).future);
    final parents =
        categories.where((category) => category.parentId == null).toList();

    if (!context.mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(initial == null ? 'Nueva categoría' : 'Editar categoría'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedParentId,
                    decoration: const InputDecoration(
                      labelText: 'Categoría padre',
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('Sin categoría padre'),
                      ),
                      ...parents
                          .where((item) => item.id != initial?.id)
                          .map(
                            (item) => DropdownMenuItem(
                              value: item.id,
                              child: Text(item.name),
                            ),
                          ),
                    ],
                    onChanged: (value) => setState(() {
                      selectedParentId = value;
                      if (selectedParentId == null) {
                        reminderEnabled = false;
                        reminderDay = null;
                      } else {
                        reminderDay ??= DateTime.now().day;
                      }
                    }),
                  ),
                  if (selectedParentId != null) ...[
                    const SizedBox(height: 12),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Recordatorio mensual'),
                      subtitle: const Text(
                        'Usá esta subcategoría para servicios o gastos recurrentes.',
                      ),
                      value: reminderEnabled,
                      onChanged: (value) => setState(() {
                        reminderEnabled = value;
                        reminderDay ??= DateTime.now().day;
                      }),
                    ),
                    if (reminderEnabled) ...[
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        initialValue: reminderDay,
                        decoration: const InputDecoration(
                          labelText: 'Día de recordatorio',
                        ),
                        items: List.generate(
                          31,
                          (index) => DropdownMenuItem(
                            value: index + 1,
                            child: Text('Día ${index + 1}'),
                          ),
                        ),
                        onChanged: (value) => setState(() => reminderDay = value),
                      ),
                    ],
                  ],
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                final trimmedName = nameController.text.trim();
                if (trimmedName.isEmpty) {
                  return;
                }

                final now = DateTime.now();
                final category = Category(
                  id: initial?.id ?? const Uuid().v4(),
                  name: trimmedName,
                  scope: scope,
                  parentId: selectedParentId,
                  isDefault: initial?.isDefault ?? false,
                  reminderEnabled: selectedParentId != null && reminderEnabled,
                  reminderDay:
                      selectedParentId != null && reminderEnabled
                          ? reminderDay
                          : null,
                  createdAt: initial?.createdAt ?? now,
                  updatedAt: now,
                );
                await ref
                    .read(categoriesRepositoryProvider)
                    .upsertCategory(category);
                ref.invalidate(categoriesProvider(scope));
                ref.invalidate(categoryBudgetStatusProvider);
                ref.invalidate(expenseReminderSubcategoriesProvider);
                ref.invalidate(monthlyDueRemindersProvider);
                ref.invalidate(financeOverviewProvider);
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}

class _CategoryEntryRow extends StatelessWidget {
  const _CategoryEntryRow({
    required this.title,
    required this.onEdit,
    required this.onDelete,
    this.subtitle,
    this.icon,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: icon == null ? null : Icon(icon, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyLarge,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          _ActionsRow(
            onEdit: onEdit,
            onDelete: onDelete,
          ),
        ],
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  const _ActionsRow({
    required this.onEdit,
    required this.onDelete,
  });

  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    );
  }
}
