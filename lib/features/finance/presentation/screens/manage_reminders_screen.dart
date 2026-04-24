import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_strings.dart';
import '../../../../shared/providers.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/savings_goal.dart';
import '../providers/finance_providers.dart';
import '../providers/monthly_reminder_notification_providers.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/selection_sheet_field.dart';
import '../widgets/section_card.dart';

class ManageRemindersScreen extends ConsumerWidget {
  const ManageRemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    final expenseCategoriesState = ref.watch(
      categoriesProvider(CategoryScope.expense),
    );
    final expenseRemindersState =
        ref.watch(expenseReminderSubcategoriesProvider);
    final savingsRemindersState = ref.watch(savingsGoalRemindersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(strings.manageReminders)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.isEnglish
                      ? 'Review your active monthly reminders'
                      : 'Revisá tus recordatorios mensuales activos',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  strings.isEnglish
                      ? 'Expense reminders come from subcategories and savings reminders come from goals.'
                      : 'Los recordatorios de gasto salen de subcategorías y los de ahorro salen de metas.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            strings.isEnglish ? 'Expense reminders' : 'Recordatorios de gastos',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          expenseRemindersState.when(
            data: (subcategories) {
              if (subcategories.isEmpty) {
                return EmptyStateView(
                  icon: Icons.receipt_long_outlined,
                  title: strings.isEnglish
                      ? 'No active expense reminders'
                      : 'No hay recordatorios de gasto activos',
                  message: strings.isEnglish
                      ? 'Enable reminders when creating or editing an expense subcategory.'
                      : 'Activá recordatorios al crear o editar una subcategoría de gastos.',
                );
              }

              final allExpenseCategories =
                  expenseCategoriesState.valueOrNull ?? const <Category>[];
              final parentNames = {
                for (final category in allExpenseCategories.where(
                  (item) => item.parentId == null,
                ))
                  category.id: category.name,
              };

              return Column(
                children: subcategories
                    .map(
                      (subcategory) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ReminderRow(
                          title: subcategory.name,
                          subtitle: parentNames[subcategory.parentId],
                          reminderDay: subcategory.reminderDay ?? 1,
                          icon: Icons.receipt_long_outlined,
                          onDisable: () =>
                              _disableExpenseReminder(ref, subcategory),
                          onEditDay: () => _editExpenseReminderDay(
                            context,
                            ref,
                            subcategory,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => EmptyStateView(
              icon: Icons.error_outline_rounded,
              title: strings.isEnglish
                  ? 'Could not load expense reminders'
                  : 'No se pudieron cargar los recordatorios de gasto',
              message: '$error',
            ),
          ),
          const SizedBox(height: 18),
          Text(
            strings.isEnglish ? 'Savings reminders' : 'Recordatorios de ahorro',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          savingsRemindersState.when(
            data: (goals) {
              if (goals.isEmpty) {
                return EmptyStateView(
                  icon: Icons.savings_outlined,
                  title: strings.isEnglish
                      ? 'No active savings reminders'
                      : 'No hay recordatorios de ahorro activos',
                  message: strings.isEnglish
                      ? 'Enable reminders when creating or editing a savings goal.'
                      : 'Activá recordatorios al crear o editar una meta de ahorro.',
                );
              }

              return Column(
                children: goals
                    .map(
                      (progress) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ReminderRow(
                          title: progress.goal.name,
                          subtitle: progress.completed
                              ? (strings.isEnglish
                                  ? 'Completed goal'
                                  : 'Meta completada')
                              : null,
                          reminderDay: progress.goal.reminderDay ?? 1,
                          icon: Icons.savings_outlined,
                          onDisable: () =>
                              _disableGoalReminder(ref, progress.goal),
                          onEditDay: () => _editGoalReminderDay(
                            context,
                            ref,
                            progress.goal,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => EmptyStateView(
              icon: Icons.error_outline_rounded,
              title: strings.isEnglish
                  ? 'Could not load savings reminders'
                  : 'No se pudieron cargar los recordatorios de ahorro',
              message: '$error',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _disableExpenseReminder(
      WidgetRef ref, Category subcategory) async {
    await ref.read(categoriesRepositoryProvider).upsertCategory(
          subcategory.copyWith(
            reminderEnabled: false,
            reminderDay: null,
            updatedAt: DateTime.now(),
          ),
        );
    await _syncNotifications(ref);
    _refresh(ref);
  }

  Future<void> _disableGoalReminder(WidgetRef ref, SavingsGoal goal) async {
    await ref.read(savingsGoalsRepositoryProvider).upsertSavingsGoal(
          goal.copyWith(
            reminderEnabled: false,
            reminderDay: null,
            updatedAt: DateTime.now(),
          ),
        );
    await _syncNotifications(ref);
    _refresh(ref);
  }

  Future<void> _editExpenseReminderDay(
    BuildContext context,
    WidgetRef ref,
    Category subcategory,
  ) async {
    final selectedDay = await _pickReminderDay(
      context,
      initialDay: subcategory.reminderDay ?? DateTime.now().day,
    );
    if (selectedDay == null) {
      return;
    }

    await ref.read(categoriesRepositoryProvider).upsertCategory(
          subcategory.copyWith(
            reminderEnabled: true,
            reminderDay: selectedDay,
            updatedAt: DateTime.now(),
          ),
        );
    await _syncNotifications(ref);
    _refresh(ref);
  }

  Future<void> _editGoalReminderDay(
    BuildContext context,
    WidgetRef ref,
    SavingsGoal goal,
  ) async {
    final selectedDay = await _pickReminderDay(
      context,
      initialDay: goal.reminderDay ?? DateTime.now().day,
    );
    if (selectedDay == null) {
      return;
    }

    await ref.read(savingsGoalsRepositoryProvider).upsertSavingsGoal(
          goal.copyWith(
            reminderEnabled: true,
            reminderDay: selectedDay,
            updatedAt: DateTime.now(),
          ),
        );
    await _syncNotifications(ref);
    _refresh(ref);
  }

  Future<void> _syncNotifications(WidgetRef ref) async {
    try {
      await ref
          .read(monthlyReminderNotificationSchedulerProvider)
          .syncScheduledReminders();
    } catch (_) {
      // Reminder edits should remain saved even if notification scheduling fails.
    }
  }

  Future<int?> _pickReminderDay(
    BuildContext context, {
    required int initialDay,
  }) async {
    final strings = AppStrings.of(context);
    return showSelectionSheet<int>(
      context: context,
      title: strings.reminderDay,
      description: strings.isEnglish
          ? 'Choose the day of month for the reminder.'
          : 'Elegí el día del mes para el recordatorio.',
      selectedValue: initialDay,
      maxHeight: 360,
      items: List.generate(
        31,
        (index) => SelectionSheetItem(
          value: index + 1,
          label: '${strings.reminderDayPrefix} ${index + 1}',
          iconData: Icons.calendar_month_outlined,
        ),
      ),
    );
  }

  void _refresh(WidgetRef ref) {
    ref.invalidate(categoriesProvider(CategoryScope.expense));
    ref.invalidate(expenseReminderSubcategoriesProvider);
    ref.invalidate(savingsGoalsProvider);
    ref.invalidate(savingsGoalRemindersProvider);
    ref.invalidate(monthlyDueRemindersProvider);
    ref.invalidate(financeOverviewProvider);
  }
}

class _ReminderRow extends StatelessWidget {
  const _ReminderRow({
    required this.title,
    required this.reminderDay,
    required this.icon,
    required this.onDisable,
    required this.onEditDay,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final int reminderDay;
  final IconData icon;
  final VoidCallback onDisable;
  final VoidCallback onEditDay;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;

    return SectionCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(
                  subtitle == null
                      ? '${strings.reminderDayPrefix} $reminderDay'
                      : '$subtitle · ${strings.reminderDayPrefix} $reminderDay',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEditDay,
            icon: const Icon(Icons.edit_calendar_outlined),
          ),
          IconButton(
            onPressed: onDisable,
            icon: const Icon(Icons.notifications_off_outlined),
          ),
        ],
      ),
    );
  }
}
