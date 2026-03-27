import '../entities/finance_insight.dart';

class FinanceInsightsService {
  const FinanceInsightsService();

  List<FinanceInsight> buildInsights({
    required double monthIncome,
    required double monthExpense,
    required double monthSavings,
    required double previousNetMonth,
    required double currentNetMonth,
    required double averageExpense,
    required Map<String, double> currentCategoryExpenses,
    required Map<String, double> previousCategoryExpenses,
    required double largestExpense,
  }) {
    final insights = <FinanceInsight>[];

    final safeAverageExpense = averageExpense <= 0 ? monthExpense : averageExpense;
    if (monthExpense > safeAverageExpense * 1.15 && safeAverageExpense > 0) {
      insights.add(
        const FinanceInsight(
          title: 'Cuidado con el ritmo',
          message: 'Estás gastando más de lo habitual este mes.',
          tone: FinanceInsightTone.warning,
        ),
      );
    } else {
      insights.add(
        const FinanceInsight(
          title: 'Ritmo saludable',
          message: 'Tus gastos vienen controlados frente a tu promedio reciente.',
          tone: FinanceInsightTone.positive,
        ),
      );
    }

    final topCategory = _topCategory(currentCategoryExpenses);
    if (topCategory != null) {
      final previous = previousCategoryExpenses[topCategory.key] ?? 0;
      if (topCategory.value > previous * 1.12 && topCategory.value > 0) {
        insights.add(
          FinanceInsight(
            title: 'Tu foco cambió',
            message: 'Gastaste más en ${topCategory.key.toLowerCase()} este mes.',
            tone: FinanceInsightTone.warning,
          ),
        );
      } else if (previous > 0 && topCategory.value < previous * 0.88) {
        insights.add(
          FinanceInsight(
            title: 'Buen ajuste',
            message: 'Reduciste tus gastos en ${topCategory.key.toLowerCase()}.',
            tone: FinanceInsightTone.positive,
          ),
        );
      }
    }

    if (monthSavings > 0 && currentNetMonth >= previousNetMonth) {
      insights.add(
        const FinanceInsight(
          title: 'Vas bien',
          message: 'Estás ahorrando más que el mes pasado o manteniendo un buen margen.',
          tone: FinanceInsightTone.positive,
        ),
      );
    } else if (monthIncome > 0 && monthSavings == 0) {
      insights.add(
        const FinanceInsight(
          title: 'Sugerencia de ahorro',
          message: 'Probá apartar una parte de tus ingresos apenas entra el mes.',
          tone: FinanceInsightTone.neutral,
        ),
      );
    }

    if (largestExpense > 0 && largestExpense > safeAverageExpense * 0.45) {
      insights.add(
        const FinanceInsight(
          title: 'Gasto alto detectado',
          message: 'Tuviste un gasto grande recientemente. Revisalo para mantener control.',
          tone: FinanceInsightTone.neutral,
        ),
      );
    }

    return insights.take(4).toList();
  }

  MapEntry<String, double>? _topCategory(Map<String, double> categoryExpenses) {
    if (categoryExpenses.isEmpty) {
      return null;
    }

    final sorted = categoryExpenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first;
  }
}
