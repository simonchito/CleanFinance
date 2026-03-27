class CategorySpend {
  const CategorySpend({
    required this.categoryName,
    required this.amount,
  });

  final String categoryName;
  final double amount;
}

class ReportsSnapshot {
  const ReportsSnapshot({
    required this.incomeMonth,
    required this.expenseMonth,
    required this.savingsMonth,
    required this.netMonth,
    required this.previousNetMonth,
    required this.topExpenseCategories,
  });

  final double incomeMonth;
  final double expenseMonth;
  final double savingsMonth;
  final double netMonth;
  final double previousNetMonth;
  final List<CategorySpend> topExpenseCategories;
}
