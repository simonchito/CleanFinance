import 'package:clean_finance/features/finance/domain/entities/category.dart';
import 'package:clean_finance/features/finance/domain/entities/monthly_payment_reminder.dart';
import 'package:clean_finance/features/finance/domain/entities/savings_goal.dart';
import 'package:clean_finance/features/finance/domain/services/monthly_payment_reminder_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const service = MonthlyPaymentReminderService();

  Category expenseCategory({
    required String id,
    required String name,
    String? parentId,
    bool reminderEnabled = false,
    int? reminderDay,
  }) {
    final now = DateTime(2026, 1, 1);
    return Category(
      id: id,
      name: name,
      scope: CategoryScope.expense,
      parentId: parentId,
      isDefault: false,
      reminderEnabled: reminderEnabled,
      reminderDay: reminderDay,
      createdAt: now,
      updatedAt: now,
    );
  }

  SavingsGoalProgress savingsGoal({
    required String id,
    required String name,
    required bool reminderEnabled,
    int? reminderDay,
    bool isArchived = false,
    double targetAmount = 1000,
    double savedAmount = 100,
  }) {
    final now = DateTime(2026, 1, 1);
    return SavingsGoalProgress(
      goal: SavingsGoal(
        id: id,
        name: name,
        targetAmount: targetAmount,
        isArchived: isArchived,
        reminderEnabled: reminderEnabled,
        reminderDay: reminderDay,
        createdAt: now,
        updatedAt: now,
      ),
      savedAmount: savedAmount,
    );
  }

  test('returns due reminder for expense subcategory when day has passed', () {
    final reminders = service.buildDueReminders(
      expenseCategories: [
        expenseCategory(id: 'services', name: 'Servicios'),
        expenseCategory(
          id: 'netflix',
          name: 'Netflix',
          parentId: 'services',
          reminderEnabled: true,
          reminderDay: 10,
        ),
      ],
      savingsGoals: const [],
      referenceDate: DateTime(2026, 3, 20),
    );

    expect(reminders, hasLength(1));
    expect(reminders.single.source, MonthlyReminderSource.expenseSubcategory);
    expect(reminders.single.title, 'Netflix');
    expect(reminders.single.subtitle, 'Servicios');
  });

  test('does not return top level categories as expense reminders', () {
    final reminders = service.buildDueReminders(
      expenseCategories: [
        expenseCategory(
          id: 'services',
          name: 'Servicios',
          reminderEnabled: true,
          reminderDay: 10,
        ),
      ],
      savingsGoals: const [],
      referenceDate: DateTime(2026, 3, 20),
    );

    expect(reminders, isEmpty);
  });

  test('returns due reminder for active savings goal when day has passed', () {
    final reminders = service.buildDueReminders(
      expenseCategories: const [],
      savingsGoals: [
        savingsGoal(
          id: 'goal-travel',
          name: 'Viaje',
          reminderEnabled: true,
          reminderDay: 5,
        ),
      ],
      referenceDate: DateTime(2026, 3, 20),
    );

    expect(reminders, hasLength(1));
    expect(reminders.single.source, MonthlyReminderSource.savingsGoal);
    expect(reminders.single.title, 'Viaje');
  });

  test('does not return completed savings goals as due reminders', () {
    final reminders = service.buildDueReminders(
      expenseCategories: const [],
      savingsGoals: [
        savingsGoal(
          id: 'goal-emergency',
          name: 'Fondo',
          reminderEnabled: true,
          reminderDay: 5,
          targetAmount: 1000,
          savedAmount: 1000,
        ),
      ],
      referenceDate: DateTime(2026, 3, 20),
    );

    expect(reminders, isEmpty);
  });
}
