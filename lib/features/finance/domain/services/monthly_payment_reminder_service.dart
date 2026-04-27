import '../entities/category.dart';
import '../entities/monthly_payment_reminder.dart';
import '../entities/monthly_reminder_schedule_item.dart';
import '../entities/movement.dart';
import '../entities/savings_goal.dart';

class MonthlyPaymentReminderService {
  const MonthlyPaymentReminderService();

  List<MonthlyPaymentReminder> buildDueReminders({
    required List<Category> expenseCategories,
    required List<SavingsGoalProgress> savingsGoals,
    required List<Movement> currentMonthMovements,
    required DateTime referenceDate,
  }) {
    final resolvedExpenseSubcategoryIds = currentMonthMovements
        .where(
          (movement) =>
              movement.type == MovementType.expense &&
              movement.subcategoryId != null,
        )
        .map((movement) => movement.subcategoryId!)
        .toSet();
    final resolvedSavingsGoalIds = currentMonthMovements
        .where(
          (movement) =>
              movement.type == MovementType.saving && movement.goalId != null,
        )
        .map((movement) => movement.goalId!)
        .toSet();

    final dueExpenseReminders = buildExpenseReminders(
      categories: expenseCategories,
      resolvedSubcategoryIds: resolvedExpenseSubcategoryIds,
      referenceDate: referenceDate,
    );
    final dueSavingsReminders = buildSavingsGoalReminders(
      goals: savingsGoals,
      resolvedGoalIds: resolvedSavingsGoalIds,
      referenceDate: referenceDate,
    );

    final reminders = [...dueExpenseReminders, ...dueSavingsReminders]
      ..sort((a, b) {
        final dayComparison = a.reminderDay.compareTo(b.reminderDay);
        if (dayComparison != 0) {
          return dayComparison;
        }
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      });

    return reminders;
  }

  List<MonthlyReminderScheduleItem> buildScheduledReminderItems({
    required List<Category> expenseCategories,
    required List<SavingsGoalProgress> savingsGoals,
  }) {
    final parentNames = {
      for (final category
          in expenseCategories.where((item) => item.parentId == null))
        category.id: category.name,
    };

    final expenseItems = expenseCategories
        .where(
          (category) =>
              category.scope == CategoryScope.expense &&
              category.isSubcategory &&
              category.reminderEnabled &&
              _isValidReminderDay(category.reminderDay),
        )
        .map(
          (category) => MonthlyReminderScheduleItem(
            id: category.id,
            source: MonthlyReminderSource.expenseSubcategory,
            title: category.name,
            subtitle: parentNames[category.parentId],
            reminderDay: category.reminderDay!,
          ),
        );

    final savingsItems = savingsGoals
        .where(
          (progress) =>
              !progress.goal.isArchived &&
              !progress.completed &&
              progress.goal.reminderEnabled &&
              _isValidReminderDay(progress.goal.reminderDay),
        )
        .map(
          (progress) => MonthlyReminderScheduleItem(
            id: progress.goal.id,
            source: MonthlyReminderSource.savingsGoal,
            title: progress.goal.name,
            reminderDay: progress.goal.reminderDay!,
          ),
        );

    final items = [...expenseItems, ...savingsItems]..sort((a, b) {
        final dayComparison = a.reminderDay.compareTo(b.reminderDay);
        if (dayComparison != 0) {
          return dayComparison;
        }
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      });
    return items;
  }

  List<MonthlyPaymentReminder> buildExpenseReminders({
    required List<Category> categories,
    required Set<String> resolvedSubcategoryIds,
    required DateTime referenceDate,
  }) {
    final parentNames = {
      for (final category in categories.where((item) => item.parentId == null))
        category.id: category.name,
    };

    return categories
        .where(
          (category) =>
              category.scope == CategoryScope.expense &&
              category.isSubcategory &&
              category.reminderEnabled &&
              !resolvedSubcategoryIds.contains(category.id) &&
              _isDue(category.reminderDay, referenceDate),
        )
        .map(
          (category) => MonthlyPaymentReminder(
            id: category.id,
            source: MonthlyReminderSource.expenseSubcategory,
            title: category.name,
            subtitle: parentNames[category.parentId],
            reminderDay: category.reminderDay!,
            status: MonthlyReminderStatus.due,
            categoryId: category.parentId,
            subcategoryId: category.id,
          ),
        )
        .toList();
  }

  List<MonthlyPaymentReminder> buildSavingsGoalReminders({
    required List<SavingsGoalProgress> goals,
    required Set<String> resolvedGoalIds,
    required DateTime referenceDate,
  }) {
    return goals
        .where(
          (progress) =>
              !progress.goal.isArchived &&
              !progress.completed &&
              progress.goal.reminderEnabled &&
              !resolvedGoalIds.contains(progress.goal.id) &&
              _isDue(progress.goal.reminderDay, referenceDate),
        )
        .map(
          (progress) => MonthlyPaymentReminder(
            id: progress.goal.id,
            source: MonthlyReminderSource.savingsGoal,
            title: progress.goal.name,
            subtitle: null,
            reminderDay: progress.goal.reminderDay!,
            status: MonthlyReminderStatus.due,
            goalId: progress.goal.id,
          ),
        )
        .toList();
  }

  bool _isDue(int? reminderDay, DateTime referenceDate) {
    return _isValidReminderDay(reminderDay) &&
        referenceDate.day >= reminderDay!;
  }

  bool _isValidReminderDay(int? reminderDay) {
    return reminderDay != null && reminderDay >= 1 && reminderDay <= 31;
  }
}
