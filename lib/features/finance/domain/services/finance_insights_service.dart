import '../entities/analytics_models.dart';
import '../entities/finance_insight.dart';

class FinanceInsightsService {
  const FinanceInsightsService();

  List<FinanceInsight> buildInsights({
    required CashflowSnapshot cashflow,
    required CategoryComparisonReport categoryComparison,
    required SpendingPaceReport spendingPace,
    required FinancialHealthScore healthScore,
    required double largestExpense,
    List<SavingsGoalForecast> savingsGoals = const [],
  }) {
    final insights = <FinanceInsight>[];

    if (cashflow.isOvercommitted) {
      insights.add(
        FinanceInsight(
          type: FinanceInsightType.overcommitted,
          percentageValue: cashflow.committedRate * 100,
          tone: FinanceInsightTone.warning,
          kind: FinanceInsightKind.diagnostic,
        ),
      );
    } else if (cashflow.netBalance > 0) {
      insights.add(
        const FinanceInsight(
          type: FinanceInsightType.monthWithMargin,
          tone: FinanceInsightTone.positive,
          kind: FinanceInsightKind.descriptive,
        ),
      );
    }

    final topCategory = categoryComparison.dominantCategory;
    if (topCategory != null) {
      insights.add(
        FinanceInsight(
          type: FinanceInsightType.dominantCategory,
          categoryName: topCategory.categoryName,
          categoryIsDefault: topCategory.categoryIsDefault,
          percentageValue: topCategory.shareOfCurrent * 100,
          tone: topCategory.shareOfCurrent >= 0.35
              ? FinanceInsightTone.warning
              : FinanceInsightTone.neutral,
          kind: FinanceInsightKind.descriptive,
        ),
      );
    }

    final variableCategory = categoryComparison.largestVariation;
    if (variableCategory != null &&
        (variableCategory.deltaPercentage?.abs() ?? 0) >= 0.25) {
      if (variableCategory.deltaAmount > 0) {
        insights.add(
          FinanceInsight(
            type: FinanceInsightType.expenseIncrease,
            categoryName: variableCategory.categoryName,
            categoryIsDefault: variableCategory.categoryIsDefault,
            percentageValue: variableCategory.deltaPercentage!.abs() * 100,
            tone: FinanceInsightTone.warning,
            kind: FinanceInsightKind.diagnostic,
          ),
        );
      } else {
        insights.add(
          FinanceInsight(
            type: FinanceInsightType.expenseDecrease,
            categoryName: variableCategory.categoryName,
            categoryIsDefault: variableCategory.categoryIsDefault,
            percentageValue: variableCategory.deltaPercentage!.abs() * 100,
            tone: FinanceInsightTone.positive,
            kind: FinanceInsightKind.diagnostic,
          ),
        );
      }
    }

    if (spendingPace.status == SpendingPaceStatus.risk) {
      insights.add(
        FinanceInsight(
          type: FinanceInsightType.endOfMonthRisk,
          amountValue: spendingPace.projectedNetBalance.abs(),
          tone: FinanceInsightTone.warning,
          kind: FinanceInsightKind.predictive,
        ),
      );
    } else if (spendingPace.status == SpendingPaceStatus.onTrack) {
      insights.add(
        const FinanceInsight(
          type: FinanceInsightType.paceOnTrack,
          tone: FinanceInsightTone.positive,
          kind: FinanceInsightKind.predictive,
        ),
      );
    }

    if (cashflow.income > 0 && largestExpense / cashflow.income >= 0.3) {
      insights.add(
        FinanceInsight(
          type: FinanceInsightType.atypicalExpense,
          percentageValue: (largestExpense / cashflow.income) * 100,
          tone: FinanceInsightTone.warning,
          kind: FinanceInsightKind.diagnostic,
        ),
      );
    }

    if (cashflow.savingsRate >= 0.1) {
      insights.add(
        FinanceInsight(
          type: FinanceInsightType.healthySavings,
          percentageValue: cashflow.savingsRate * 100,
          tone: FinanceInsightTone.positive,
          kind: FinanceInsightKind.actionable,
        ),
      );
    } else if (cashflow.income > 0 && cashflow.savings <= 0) {
      insights.add(
        const FinanceInsight(
          type: FinanceInsightType.savingSuggestion,
          tone: FinanceInsightTone.neutral,
          kind: FinanceInsightKind.actionable,
        ),
      );
    }

    if (cashflow.netBalance > cashflow.previousNetBalance &&
        healthScore.level != FinancialHealthLevel.risk) {
      insights.add(
        const FinanceInsight(
          type: FinanceInsightType.monthImproving,
          tone: FinanceInsightTone.positive,
          kind: FinanceInsightKind.descriptive,
        ),
      );
    } else if (cashflow.netBalance < cashflow.previousNetBalance) {
      insights.add(
        const FinanceInsight(
          type: FinanceInsightType.monthGettingTighter,
          tone: FinanceInsightTone.warning,
          kind: FinanceInsightKind.descriptive,
        ),
      );
    }

    final closestGoal = savingsGoals
        .where((goal) => goal.remainingAmount > 0)
        .cast<SavingsGoalForecast?>()
        .firstWhere(
          (goal) => goal != null && goal.progress.progress >= 0.6,
          orElse: () => null,
        );
    if (closestGoal != null && closestGoal.estimatedCompletionDate != null) {
      insights.add(
        FinanceInsight(
          type: FinanceInsightType.goalOnTrack,
          goalName: closestGoal.progress.goal.name,
          percentageValue: closestGoal.progress.progress * 100,
          tone: FinanceInsightTone.positive,
          kind: FinanceInsightKind.actionable,
        ),
      );
    }

    return insights.take(6).toList();
  }
}
