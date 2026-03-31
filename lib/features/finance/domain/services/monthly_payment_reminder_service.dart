import '../entities/category.dart';
import '../entities/monthly_payment_reminder.dart';
import '../entities/savings_goal.dart';

class MonthlyPaymentReminderService {
  const MonthlyPaymentReminderService();

  List<MonthlyPaymentReminder> buildDueReminders({
    required List<Category> expenseCategories,
    required List<SavingsGoalProgress> savingsGoals,
    required DateTime referenceDate,
  }) {
    final dueExpenseReminders = buildExpenseReminders(
      categories: expenseCategories,
      referenceDate: referenceDate,
    );
    final dueSavingsReminders = buildSavingsGoalReminders(
      goals: savingsGoals,
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

  List<MonthlyPaymentReminder> buildExpenseReminders({
    required List<Category> categories,
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
    required DateTime referenceDate,
  }) {
    return goals
        .where(
          (progress) =>
              !progress.goal.isArchived &&
              !progress.completed &&
              progress.goal.reminderEnabled &&
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
    return reminderDay != null &&
        reminderDay >= 1 &&
        reminderDay <= 31 &&
        referenceDate.day >= reminderDay;
  }
}
