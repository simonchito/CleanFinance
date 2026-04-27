import '../../../../core/utils/month_context.dart';
import '../entities/analytics_models.dart';
import '../entities/movement.dart';

class CategoryComparisonService {
  const CategoryComparisonService();

  CategoryComparisonReport build({
    required List<Movement> movements,
    required DateTime referenceDate,
    int topItems = 5,
  }) {
    final currentMonth = MonthContext.forDate(referenceDate);
    final previousMonth = currentMonth.previous();

    final currentTotals = <String, double>{};
    final previousTotals = <String, double>{};
    final metadataByKey = <String, ({String name, bool isDefault})>{};

    for (final movement in movements) {
      if (movement.type != MovementType.expense) {
        continue;
      }

      final categoryName = movement.categoryName ?? 'Sin categoría';
      final categoryKey = movement.categoryId.isEmpty
          ? 'name::$categoryName'
          : 'id::${movement.categoryId}';
      metadataByKey[categoryKey] = (
        name: categoryName,
        isDefault: movement.categoryIsDefault,
      );
      final occurredOnMonth =
          DateTime(movement.occurredOn.year, movement.occurredOn.month, 1);

      if (occurredOnMonth == currentMonth.startDate &&
          movement.occurredOn.isBefore(currentMonth.endDateExclusive)) {
        currentTotals.update(
          categoryKey,
          (value) => value + movement.amount,
          ifAbsent: () => movement.amount,
        );
      } else if (occurredOnMonth == previousMonth.startDate) {
        previousTotals.update(
          categoryKey,
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

    final categoryKeys = {
      ...rankedCurrent.map((entry) => entry.key),
      ...rankedPrevious.map((entry) => entry.key),
    }.take(topItems);

    final items = categoryKeys.map(
      (categoryKey) {
        final metadata = metadataByKey[categoryKey];
        return CategoryComparisonItem(
          categoryId:
              categoryKey.startsWith('id::') ? categoryKey.substring(4) : null,
          categoryName: metadata?.name ?? 'Sin categoría',
          categoryIsDefault: metadata?.isDefault ?? false,
          currentAmount: currentTotals[categoryKey] ?? 0,
          previousAmount: previousTotals[categoryKey] ?? 0,
          shareOfCurrent: totalCurrentExpense <= 0
              ? 0
              : (currentTotals[categoryKey] ?? 0) / totalCurrentExpense,
        );
      },
    ).toList()
      ..sort((a, b) => b.currentAmount.compareTo(a.currentAmount));

    return CategoryComparisonReport(
      totalCurrentExpense: totalCurrentExpense,
      totalPreviousExpense: totalPreviousExpense,
      items: items,
    );
  }
}
