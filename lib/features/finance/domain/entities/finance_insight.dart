enum FinanceInsightTone { positive, warning, neutral }

enum FinanceInsightKind { descriptive, diagnostic, predictive, actionable }

enum FinanceInsightType {
  overcommitted,
  monthWithMargin,
  dominantCategory,
  expenseIncrease,
  expenseDecrease,
  endOfMonthRisk,
  paceOnTrack,
  atypicalExpense,
  healthySavings,
  savingSuggestion,
  monthImproving,
  monthGettingTighter,
  goalOnTrack,
}

class FinanceInsight {
  const FinanceInsight({
    required this.type,
    required this.tone,
    required this.kind,
    this.categoryName,
    this.goalName,
    this.percentageValue,
    this.amountValue,
  });

  final FinanceInsightType type;
  final FinanceInsightTone tone;
  final FinanceInsightKind kind;
  final String? categoryName;
  final String? goalName;
  final double? percentageValue;
  final double? amountValue;
}
