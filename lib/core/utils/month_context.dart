class MonthContext {
  MonthContext._({
    required this.referenceDate,
    required this.startDate,
    required this.endDateExclusive,
    required this.daysElapsed,
    required this.totalDaysInMonth,
    required this.daysRemaining,
    required this.monthKey,
  });

  factory MonthContext.forDate(DateTime referenceDate) {
    final startDate = DateTime(referenceDate.year, referenceDate.month, 1);
    final endDateExclusive =
        DateTime(referenceDate.year, referenceDate.month + 1, 1);
    final totalDaysInMonth = DateTime(
      referenceDate.year,
      referenceDate.month + 1,
      0,
    ).day;
    final daysElapsed = referenceDate.day.clamp(1, totalDaysInMonth);
    final daysRemaining = (totalDaysInMonth - daysElapsed).clamp(
      0,
      totalDaysInMonth,
    );

    return MonthContext._(
      referenceDate: referenceDate,
      startDate: startDate,
      endDateExclusive: endDateExclusive,
      daysElapsed: daysElapsed,
      totalDaysInMonth: totalDaysInMonth,
      daysRemaining: daysRemaining,
      monthKey: monthKeyFor(referenceDate),
    );
  }

  final DateTime referenceDate;
  final DateTime startDate;
  final DateTime endDateExclusive;
  final int daysElapsed;
  final int totalDaysInMonth;
  final int daysRemaining;
  final String monthKey;

  DateTime get endDateInclusive =>
      endDateExclusive.subtract(const Duration(microseconds: 1));

  MonthContext previous() {
    return MonthContext.forDate(
      DateTime(startDate.year, startDate.month - 1, 1),
    );
  }

  static String monthKeyFor(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }
}
