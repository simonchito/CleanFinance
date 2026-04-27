enum BudgetStatus { normal, warning, exceeded }

class CategoryBudgetStatus {
  const CategoryBudgetStatus({
    required this.categoryId,
    required this.categoryName,
    required this.monthlyLimit,
    required this.spent,
    required this.remaining,
    required this.percentageUsed,
    required this.status,
    this.categoryIsDefault = false,
  });

  final String categoryId;
  final String categoryName;
  final bool categoryIsDefault;
  final double monthlyLimit;
  final double spent;
  final double remaining;
  final double percentageUsed;
  final BudgetStatus status;
}
