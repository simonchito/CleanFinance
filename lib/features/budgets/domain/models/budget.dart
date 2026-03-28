class Budget {
  const Budget({
    required this.id,
    required this.categoryId,
    required this.monthlyLimit,
    required this.month,
  });

  final String id;
  final String categoryId;
  final double monthlyLimit;
  final String month;

  Budget copyWith({
    String? id,
    String? categoryId,
    double? monthlyLimit,
    String? month,
  }) {
    return Budget(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      month: month ?? this.month,
    );
  }

  static String monthKeyFor(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  static bool isValidMonth(String value) {
    return RegExp(r'^\d{4}-\d{2}$').hasMatch(value);
  }
}
