import '../entities/analytics_models.dart';
import '../entities/movement.dart';

class CategoryComparisonService {
  const CategoryComparisonService();

  CategoryComparisonReport build({
    required List<Movement> movements,
    required DateTime referenceDate,
    int topItems = 5,
  }) {
    final currentMonthStart = DateTime(referenceDate.year, referenceDate.month, 1);
    final currentMonthEnd =
        DateTime(referenceDate.year, referenceDate.month + 1, 1);
    final previousMonthStart =
        DateTime(referenceDate.year, referenceDate.month - 1, 1);

    final currentTotals = <String, double>{};
    final previousTotals = <String, double>{};

    for (final movement in movements) {
      if (movement.type != MovementType.expense) {
        continue;
      }

      final categoryName = movement.categoryName ?? 'Sin categoría';
      final occurredOnMonth =
          DateTime(movement.occurredOn.year, movement.occurredOn.month, 1);

      if (occurredOnMonth == currentMonthStart &&
          movement.occurredOn.isBefore(currentMonthEnd)) {
        currentTotals.update(
          categoryName,
          (value) => value + movement.amount,
          ifAbsent: () => movement.amount,
        );
      } else if (occurredOnMonth == previousMonthStart) {
        previousTotals.update(
          categoryName,
          (value) => value + movement.amount,
          ifAbsent: () => movement.amount,
        );
      }
    }

    final totalCurrentExpense =
        currentTotals.values.fold<double>(0, (sum, value) => sum + value);
    final totalPreviousExpense =
        previousTotals.values.fold<double>(0, (sum, value) => sum + value);

    final rankedCurrent = currentTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final rankedPrevious = previousTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final categoryNames = {
      ...rankedCurrent.map((entry) => entry.key),
      ...rankedPrevious.map((entry) => entry.key),
    }.take(topItems);

    final items = categoryNames
        .map(
          (categoryName) => CategoryComparisonItem(
            categoryName: categoryName,
            currentAmount: currentTotals[categoryName] ?? 0,
            previousAmount: previousTotals[categoryName] ?? 0,
            shareOfCurrent: totalCurrentExpense <= 0
                ? 0
                : (currentTotals[categoryName] ?? 0) / totalCurrentExpense,
          ),
        )
        .toList()
      ..sort((a, b) => b.currentAmount.compareTo(a.currentAmount));

    return CategoryComparisonReport(
      totalCurrentExpense: totalCurrentExpense,
      totalPreviousExpense: totalPreviousExpense,
      items: items,
    );
  }
}

