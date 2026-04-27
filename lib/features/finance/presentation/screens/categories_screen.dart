import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/app_strings.dart';
import '../../../../core/constants/icon_options.dart';
import '../../../../core/utils/icon_mapper.dart';
import '../../../../shared/providers.dart';
import '../../../budgets/presentation/providers/budget_providers.dart';
import '../../domain/entities/category.dart';
import '../mappers/default_category_name_localizer.dart';
import '../providers/finance_providers.dart';
import '../providers/monthly_reminder_notification_providers.dart';
import '../widgets/confirm_action_dialog.dart';
import '../widgets/icon_picker_field.dart';
import '../widgets/selection_sheet_field.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(strings.manageCategories),
          bottom: TabBar(
            tabs: [
              Tab(text: strings.income),
              Tab(text: strings.expense),
              Tab(text: strings.savings),
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
    final strings = AppStrings.of(context);
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
            return Center(child: Text(strings.noCategories));
          }

          final topLevel = categories
              .where((category) => category.parentId == null)
              .toList();

          return ListView(
            padding: const EdgeInsets.all(12),
            children: topLevel.map((category) {
              final children = categories
                  .where((item) => item.parentId == category.id)
                  .toList();

              return Card(
                child: ExpansionTile(
                  leading: Icon(IconMapper.getIcon(category.iconKey)),
                  title: Text(
                    DefaultCategoryNameLocalizer.localizeCategory(
                      category,
                      strings,
                    ),
                  ),
                  subtitle: Text(
                    category.isDefault
                        ? (strings.t('defaultCategory'))
                        : (strings.t('customCategory')),
                  ),
                  children: [
                    for (final child in children)
                      _CategoryEntryRow(
                        icon: IconMapper.getIcon(child.iconKey),
                        title: DefaultCategoryNameLocalizer.localizeCategory(
                          child,
                          strings,
                        ),
                        onEdit: () => _showCategoryDialog(
                          context,
                          ref,
                          scope: scope,
                          initial: child,
                        ),
                        onDelete: child.isDefault
                            ? null
                            : () => _deleteCategory(context, ref, child),
                      ),
                    _CategoryEntryRow(
                      icon: IconMapper.getIcon(category.iconKey),
                      title: DefaultCategoryNameLocalizer.localizeCategory(
                        category,
                        strings,
                      ),
                      subtitle: strings.t('mainCategory'),
                      onEdit: () => _showCategoryDialog(
                        context,
                        ref,
                        scope: scope,
                        initial: category,
                      ),
                      onDelete: category.isDefault
                          ? null
                          : () => _deleteCategory(context, ref, category),
                    ),
                    ListTile(
                      leading: const Icon(Icons.add),
                      title: Text(
                        strings.t('addSubcategory'),
                      ),
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
        error: (error, _) => Center(
          child: Text(strings.categoriesLoadError(error)),
        ),
      ),
    );
  }

  Future<void> _deleteCategory(
    BuildContext context,
    WidgetRef ref,
    Category category,
  ) async {
    final strings = AppStrings.of(context);
    try {
      final categoryName = DefaultCategoryNameLocalizer.localizeCategory(
        category,
        strings,
      );
      final confirmed = await showConfirmActionDialog(
        context: context,
        title: category.isSubcategory
            ? (strings.t('eliminarSubcategoria'))
            : (strings.t('eliminarCategoria')),
        message: category.isSubcategory
            ? strings.deleteSubcategoryMessage(categoryName)
            : strings.deleteCategoryMessage(categoryName),
        confirmLabel: strings.t('eliminar'),
        cancelLabel: strings.cancel,
      );
      if (!confirmed) {
        return;
      }

      await ref.read(categoriesRepositoryProvider).deleteCategory(category.id);
      await _syncNotifications(ref);
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
    final strings = AppStrings.of(context);
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
    Category? parentCategory;
    if (selectedParentId != null) {
      for (final category in parents) {
        if (category.id == selectedParentId) {
          parentCategory = category;
          break;
        }
      }
    }
    var selectedIconKey = IconOptions.normalize(
      initial?.iconKey ?? parentCategory?.iconKey,
    );

    if (!context.mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            initial == null
                ? (strings.t('nuevaCategoria'))
                : (strings.t('editarCategoria')),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: strings.t('nombre'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    IconPickerField(
                      selectedIconKey: selectedIconKey,
                      onChanged: (value) =>
                          setState(() => selectedIconKey = value),
                    ),
                    const SizedBox(height: 12),
                    SelectionSheetField<String?>(
                      label: strings.t('categoriaPadre'),
                      value: selectedParentId,
                      placeholder: strings.t('sinCategoriaPadre'),
                      sheetTitle: strings.t('categoriaPadre'),
                      sheetDescription:
                          strings.t('elegiUnaCategoriaPrincipalSoloSiQueres'),
                      items: [
                        SelectionSheetItem<String?>(
                          value: null,
                          label: strings.t('sinCategoriaPadre'),
                          iconData: Icons.account_tree_outlined,
                        ),
                        ...parents.where((item) => item.id != initial?.id).map(
                              (item) => SelectionSheetItem<String?>(
                                value: item.id,
                                label: DefaultCategoryNameLocalizer
                                    .localizeCategory(
                                  item,
                                  strings,
                                ),
                                iconKey: item.iconKey,
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
                        title: Text(strings.monthlyReminder),
                        subtitle: Text(
                          strings.t('usaEstaSubcategoriaParaServiciosOGastos'),
                        ),
                        value: reminderEnabled,
                        onChanged: (value) => setState(() {
                          reminderEnabled = value;
                          reminderDay ??= DateTime.now().day;
                        }),
                      ),
                      if (reminderEnabled) ...[
                        const SizedBox(height: 8),
                        SelectionSheetField<int>(
                          label: strings.reminderDay,
                          value: reminderDay,
                          sheetTitle: strings.reminderDay,
                          items: List.generate(
                            31,
                            (index) => SelectionSheetItem(
                              value: index + 1,
                              label:
                                  '${strings.reminderDayPrefix} ${index + 1}',
                              iconData: Icons.calendar_month_outlined,
                            ),
                          ),
                          maxSheetHeight: 360,
                          onChanged: (value) =>
                              setState(() => reminderDay = value),
                        ),
                      ],
                    ],
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(strings.cancel),
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
                  iconKey: IconOptions.normalize(selectedIconKey),
                  scope: scope,
                  parentId: selectedParentId,
                  isDefault: initial?.isDefault ?? false,
                  reminderEnabled: selectedParentId != null && reminderEnabled,
                  reminderDay: selectedParentId != null && reminderEnabled
                      ? reminderDay
                      : null,
                  createdAt: initial?.createdAt ?? now,
                  updatedAt: now,
                );
                await ref
                    .read(categoriesRepositoryProvider)
                    .upsertCategory(category);
                await _syncNotifications(ref);
                ref.invalidate(categoriesProvider(scope));
                ref.invalidate(categoryBudgetStatusProvider);
                ref.invalidate(expenseReminderSubcategoriesProvider);
                ref.invalidate(monthlyDueRemindersProvider);
                ref.invalidate(financeOverviewProvider);
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

  Future<void> _syncNotifications(WidgetRef ref) async {
    try {
      await ref
          .read(monthlyReminderNotificationSchedulerProvider)
          .syncScheduledReminders();
    } catch (_) {
      // Category changes should not fail because notification scheduling failed.
    }
  }
}

class _CategoryEntryRow extends StatelessWidget {
  const _CategoryEntryRow({
    required this.title,
    required this.onEdit,
    required this.onDelete,
    required this.icon,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
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
          SizedBox(width: 24, child: Icon(icon, size: 20)),
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
