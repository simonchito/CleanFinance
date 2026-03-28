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
          title: 'Más de lo que entra',
          message:
              'Tus gastos y ahorros ya consumieron ${(cashflow.committedRate * 100).round()}% de tus ingresos del mes.',
          tone: FinanceInsightTone.warning,
          kind: FinanceInsightKind.diagnostic,
        ),
      );
    } else if (cashflow.netBalance > 0) {
      insights.add(
        FinanceInsight(
          title: 'Mes con margen',
          message:
              'Después de gastar y ahorrar, todavía te queda un margen positivo este mes.',
          tone: FinanceInsightTone.positive,
          kind: FinanceInsightKind.descriptive,
        ),
      );
    }

    final topCategory = categoryComparison.dominantCategory;
    if (topCategory != null) {
      insights.add(
        FinanceInsight(
          title: 'Categoría dominante',
          message:
              '${topCategory.categoryName} concentra ${(topCategory.shareOfCurrent * 100).round()}% de tus gastos del mes.',
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
            title: 'Cambio brusco de gasto',
            message:
                '${variableCategory.categoryName} subió ${(variableCategory.deltaPercentage!.abs() * 100).round()}% frente al mes anterior.',
            tone: FinanceInsightTone.warning,
            kind: FinanceInsightKind.diagnostic,
          ),
        );
      } else {
        insights.add(
          FinanceInsight(
            title: 'Buen ajuste',
            message:
                '${variableCategory.categoryName} bajó ${(variableCategory.deltaPercentage!.abs() * 100).round()}% frente al mes anterior.',
            tone: FinanceInsightTone.positive,
            kind: FinanceInsightKind.diagnostic,
          ),
        );
      }
    }

    if (spendingPace.status == SpendingPaceStatus.risk) {
      insights.add(
        FinanceInsight(
          title: 'Riesgo de fin de mes',
          message:
              'Si seguís con este ritmo, podrías cerrar con un margen ${spendingPace.projectedNetBalance.abs().round()} por debajo de cero.',
          tone: FinanceInsightTone.warning,
          kind: FinanceInsightKind.predictive,
        ),
      );
    } else if (spendingPace.status == SpendingPaceStatus.onTrack) {
      insights.add(
        FinanceInsight(
          title: 'Ritmo bajo control',
          message:
              'Tu proyección de gasto cierra dentro del margen disponible para este mes.',
          tone: FinanceInsightTone.positive,
          kind: FinanceInsightKind.predictive,
        ),
      );
    }

    if (cashflow.income > 0 && largestExpense / cashflow.income >= 0.3) {
      insights.add(
        FinanceInsight(
          title: 'Gasto atípico',
          message:
              'Una sola compra representó ${(largestExpense / cashflow.income * 100).round()}% de tus ingresos del mes.',
          tone: FinanceInsightTone.warning,
          kind: FinanceInsightKind.diagnostic,
        ),
      );
    }

    if (cashflow.savingsRate >= 0.1) {
      insights.add(
        FinanceInsight(
          title: 'Ahorro saludable',
          message:
              'Ya separaste ${(cashflow.savingsRate * 100).round()}% de tus ingresos del mes.',
          tone: FinanceInsightTone.positive,
          kind: FinanceInsightKind.actionable,
        ),
      );
    } else if (cashflow.income > 0 && cashflow.savings <= 0) {
      insights.add(
        const FinanceInsight(
          title: 'Sugerencia simple',
          message:
              'Reservar aunque sea un 5% al cobrar puede darte más aire para fin de mes.',
          tone: FinanceInsightTone.neutral,
          kind: FinanceInsightKind.actionable,
        ),
      );
    }

    if (cashflow.netBalance > cashflow.previousNetBalance &&
        healthScore.level != FinancialHealthLevel.risk) {
      insights.add(
        const FinanceInsight(
          title: 'Mes en mejora',
          message: 'Tu resultado mensual viene mejor que el del período anterior.',
          tone: FinanceInsightTone.positive,
          kind: FinanceInsightKind.descriptive,
        ),
      );
    } else if (cashflow.netBalance < cashflow.previousNetBalance) {
      insights.add(
        const FinanceInsight(
          title: 'Mes más exigente',
          message: 'Tu margen bajó frente al mes anterior. Vale la pena revisar el ritmo.',
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
          title: 'Meta encaminada',
          message:
              '${closestGoal.progress.goal.name} ya va en ${(closestGoal.progress.progress * 100).round()}% y mantiene buen ritmo.',
          tone: FinanceInsightTone.positive,
          kind: FinanceInsightKind.actionable,
        ),
      );
    }

    return insights.take(6).toList();
  }
}
