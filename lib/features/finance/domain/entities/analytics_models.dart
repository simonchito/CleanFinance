import '../../../../core/utils/month_context.dart';
import 'movement.dart';
import 'savings_goal.dart';

class MonthlyTrendPoint {
  const MonthlyTrendPoint({
    required this.label,
    required this.income,
    required this.expense,
    required this.savings,
  });

  final String label;
  final double income;
  final double expense;
  final double savings;
}

class CategoryComparisonItem {
  const CategoryComparisonItem({
    required this.categoryName,
    required this.currentAmount,
    required this.previousAmount,
    required this.shareOfCurrent,
  });

  final String categoryName;
  final double currentAmount;
  final double previousAmount;
  final double shareOfCurrent;

  double get deltaAmount => currentAmount - previousAmount;

  double? get deltaPercentage {
    if (previousAmount <= 0) {
      return null;
    }
    return deltaAmount / previousAmount;
  }
}

class CategoryComparisonReport {
  const CategoryComparisonReport({
    required this.totalCurrentExpense,
    required this.totalPreviousExpense,
    required this.items,
  });

  final double totalCurrentExpense;
  final double totalPreviousExpense;
  final List<CategoryComparisonItem> items;

  CategoryComparisonItem? get dominantCategory =>
      items.isEmpty ? null : items.first;

  CategoryComparisonItem? get largestVariation {
    if (items.isEmpty) {
      return null;
    }
    final ranked = [...items]..sort(
        (a, b) => (b.deltaPercentage?.abs() ?? 0)
            .compareTo(a.deltaPercentage?.abs() ?? 0),
      );
    return ranked.first;
  }
}

class CashflowSnapshot {
  const CashflowSnapshot({
    required this.income,
    required this.expense,
    required this.savings,
    required this.netBalance,
    required this.previousNetBalance,
  });

  final double income;
  final double expense;
  final double savings;
  final double netBalance;
  final double previousNetBalance;

  double get savingsRate => income <= 0 ? 0 : savings / income;
  double get expenseRate => income <= 0 ? 0 : expense / income;
  double get committedRate => income <= 0 ? 0 : (expense + savings) / income;
  bool get isOvercommitted => income > 0 && committedRate > 1;
}

enum SpendingPaceStatus { onTrack, watch, risk }

class SpendingPaceReport {
  const SpendingPaceReport({
    required this.spentSoFar,
    required this.expectedSpendToDate,
    required this.projectedEndOfMonth,
    required this.averageDailySpend,
    required this.daysElapsed,
    required this.daysInMonth,
    required this.safeSpendingCapacity,
    required this.projectedNetBalance,
    required this.status,
  });

  final double spentSoFar;
  final double expectedSpendToDate;
  final double projectedEndOfMonth;
  final double averageDailySpend;
  final int daysElapsed;
  final int daysInMonth;
  final double safeSpendingCapacity;
  final double projectedNetBalance;
  final SpendingPaceStatus status;

  double get progressRatio {
    if (expectedSpendToDate <= 0) {
      return 0;
    }
    return spentSoFar / expectedSpendToDate;
  }
}

class SavingsGoalForecast {
  const SavingsGoalForecast({
    required this.progress,
    required this.averageMonthlyContribution,
    required this.currentMonthContribution,
    required this.estimatedCompletionDate,
  });

  final SavingsGoalProgress progress;
  final double averageMonthlyContribution;
  final double currentMonthContribution;
  final DateTime? estimatedCompletionDate;

  double get remainingAmount =>
      (progress.goal.targetAmount - progress.savedAmount).clamp(
        0,
        progress.goal.targetAmount,
      );
}

class PaymentMethodSpend {
  const PaymentMethodSpend({
    required this.name,
    required this.amount,
    required this.share,
  });

  final String name;
  final double amount;
  final double share;
}

class PaymentMethodReport {
  const PaymentMethodReport({
    required this.totalExpense,
    required this.items,
  });

  final double totalExpense;
  final List<PaymentMethodSpend> items;
}

enum FinancialHealthLevel { strong, stable, attention, risk }

class FinancialHealthScore {
  const FinancialHealthScore({
    required this.score,
    required this.level,
  });

  final int score;
  final FinancialHealthLevel level;
}

double largestExpenseForMonth(
    List<Movement> movements, DateTime referenceDate) {
  final monthContext = MonthContext.forDate(referenceDate);
  var largestExpense = 0.0;

  for (final movement in movements) {
    if (movement.type != MovementType.expense) {
      continue;
    }
    if (movement.occurredOn.isBefore(monthContext.startDate) ||
        !movement.occurredOn.isBefore(monthContext.endDateExclusive)) {
      continue;
    }
    if (movement.amount > largestExpense) {
      largestExpense = movement.amount;
    }
  }

  return largestExpense;
}
