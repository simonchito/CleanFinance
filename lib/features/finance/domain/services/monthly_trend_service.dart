import 'package:intl/intl.dart';

import '../entities/analytics_models.dart';
import '../entities/movement.dart';

class MonthlyTrendService {
  const MonthlyTrendService();

  List<MonthlyTrendPoint> build({
    required List<Movement> movements,
    required DateTime referenceDate,
    String locale = 'es',
    int months = 6,
  }) {
    final monthlyBuckets = <String, ({double income, double expense})>{};

    for (var i = 0; i < months; i++) {
      final month = DateTime(
        referenceDate.year,
        referenceDate.month - (months - 1 - i),
        1,
      );
      final key = _monthKey(month);
      monthlyBuckets[key] = (income: 0, expense: 0);
    }

    for (final movement in movements) {
      final key = _monthKey(
        DateTime(movement.occurredOn.year, movement.occurredOn.month, 1),
      );
      final bucket = monthlyBuckets[key];
      if (bucket == null) {
        continue;
      }

      switch (movement.type) {
        case MovementType.income:
          monthlyBuckets[key] = (
            income: bucket.income + movement.amount,
            expense: bucket.expense,
          );
        case MovementType.expense:
          monthlyBuckets[key] = (
            income: bucket.income,
            expense: bucket.expense + movement.amount,
          );
        case MovementType.saving:
          break;
      }
    }

    return monthlyBuckets.entries
        .map(
          (entry) => MonthlyTrendPoint(
            label: _monthLabel(entry.key, locale),
            income: entry.value.income,
            expense: entry.value.expense,
          ),
        )
        .toList();
  }

  String _monthKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}';

  String _monthLabel(String key, String locale) {
    final parts = key.split('-');
    final month = DateTime(int.parse(parts[0]), int.parse(parts[1]), 1);
    final raw = DateFormat('MMM', locale).format(month);
    if (raw.isEmpty) {
      return raw;
    }
    return raw[0].toUpperCase() + raw.substring(1).replaceAll('.', '');
  }
}
