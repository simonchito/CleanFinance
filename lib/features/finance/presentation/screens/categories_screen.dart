import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/providers.dart';
import '../../domain/entities/category.dart';

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
                      ListTile(
                        title: Text(child.name),
                        leading: const Icon(Icons.subdirectory_arrow_right),
                        trailing: _ActionsRow(
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
                      ),
                    ListTile(
                      title: Text(category.name),
                      subtitle: const Text('Categoría principal'),
                      trailing: _ActionsRow(
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
      await ref.read(financeRepositoryProvider).deleteCategory(categoryId);
      ref.invalidate(categoriesProvider(scope));
      ref.invalidate(categoryBudgetStatusProvider);
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
                    onChanged: (value) => setState(() => selectedParentId = value),
                  ),
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
                  createdAt: initial?.createdAt ?? now,
                  updatedAt: now,
                );
                await ref.read(financeRepositoryProvider).upsertCategory(category);
                ref.invalidate(categoriesProvider(scope));
                ref.invalidate(categoryBudgetStatusProvider);
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
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    );
  }
}
