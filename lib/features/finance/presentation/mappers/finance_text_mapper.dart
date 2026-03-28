import '../../../../app/app_strings.dart';
import '../../domain/entities/analytics_models.dart';
import '../../domain/entities/end_of_month_projection.dart';
import '../../domain/entities/finance_insight.dart';

class LocalizedProjectionText {
  const LocalizedProjectionText({
    required this.riskLabel,
    required this.interpretation,
  });

  final String riskLabel;
  final String interpretation;
}

class LocalizedHealthScoreText {
  const LocalizedHealthScoreText({
    required this.label,
    required this.message,
  });

  final String label;
  final String message;
}

class LocalizedFinanceInsightText {
  const LocalizedFinanceInsightText({
    required this.title,
    required this.message,
    required this.kindLabel,
  });

  final String title;
  final String message;
  final String kindLabel;
}

class FinanceTextMapper {
  const FinanceTextMapper._();

  static LocalizedProjectionText projection(
    AppStrings strings,
    EndOfMonthProjection projection,
  ) {
    return LocalizedProjectionText(
      riskLabel: switch (projection.riskLevel) {
        ProjectionRiskLevel.low => strings.isEnglish ? 'Low' : 'Bajo',
        ProjectionRiskLevel.medium => strings.isEnglish ? 'Medium' : 'Medio',
        ProjectionRiskLevel.high => strings.isEnglish ? 'High' : 'Alto',
      },
      interpretation: switch (projection.interpretationType) {
        ProjectionInterpretationType.insufficientActivity => strings.isEnglish
            ? 'There is not enough activity yet this month for a solid projection.'
            : 'Todavia no hay suficiente actividad este mes para una proyeccion solida.',
        ProjectionInterpretationType.positiveBalance => strings.isEnglish
            ? 'You are on track to close the month with a positive balance if you keep this pace.'
            : 'Vas en camino a cerrar el mes con saldo positivo si mantenes este ritmo.',
        ProjectionInterpretationType.tightMargin => strings.isEnglish
            ? 'Your current pace could leave you with very little margin by month end.'
            : 'Tu ritmo actual podria dejarte con muy poco margen al cierre del mes.',
        ProjectionInterpretationType.deficitRisk => strings.isEnglish
            ? 'If spending continues at this pace, this month could close in deficit.'
            : 'Si el gasto sigue a este ritmo, este mes podria cerrar en deficit.',
      },
    );
  }

  static LocalizedHealthScoreText healthScore(
    AppStrings strings,
    FinancialHealthScore score,
  ) {
    return switch (score.level) {
      FinancialHealthLevel.strong => LocalizedHealthScoreText(
          label: strings.isEnglish ? 'Very healthy' : 'Muy saludable',
          message: strings.isEnglish
              ? 'Your month looks balanced and leaves enough room to absorb surprises.'
              : 'Tu mes viene equilibrado y con buen margen para absorber imprevistos.',
        ),
      FinancialHealthLevel.stable => LocalizedHealthScoreText(
          label: strings.isEnglish ? 'Stable' : 'Estable',
          message: strings.isEnglish
              ? 'Your numbers are fairly controlled, with a few points worth watching.'
              : 'Tus números están bastante controlados, con algunos puntos para seguir de cerca.',
        ),
      FinancialHealthLevel.attention => LocalizedHealthScoreText(
          label: strings.isEnglish ? 'Attention' : 'Atención',
          message: strings.isEnglish
              ? 'Your cash flow is still working, but it is worth adjusting before the month gets tighter.'
              : 'Tu flujo sigue funcionando, pero conviene ajustar antes de que el mes se ponga más justo.',
        ),
      FinancialHealthLevel.risk => LocalizedHealthScoreText(
          label: strings.isEnglish ? 'At risk' : 'En riesgo',
          message: strings.isEnglish
              ? 'Your current pace could leave you with very little margin before month end.'
              : 'El ritmo actual puede dejarte sin margen antes de cerrar el mes.',
        ),
    };
  }

  static LocalizedFinanceInsightText insight(
    AppStrings strings,
    FinanceInsight insight,
  ) {
    final percentage = insight.percentageValue?.round();
    final amount = insight.amountValue?.round();

    return LocalizedFinanceInsightText(
      title: switch (insight.type) {
        FinanceInsightType.overcommitted =>
          strings.isEnglish ? 'More than what comes in' : 'Más de lo que entra',
        FinanceInsightType.monthWithMargin =>
          strings.isEnglish ? 'Month with margin' : 'Mes con margen',
        FinanceInsightType.dominantCategory =>
          strings.isEnglish ? 'Dominant category' : 'Categoría dominante',
        FinanceInsightType.expenseIncrease =>
          strings.isEnglish ? 'Sharp spending change' : 'Cambio brusco de gasto',
        FinanceInsightType.expenseDecrease =>
          strings.isEnglish ? 'Good adjustment' : 'Buen ajuste',
        FinanceInsightType.endOfMonthRisk =>
          strings.isEnglish ? 'Month-end risk' : 'Riesgo de fin de mes',
        FinanceInsightType.paceOnTrack =>
          strings.isEnglish ? 'Pace under control' : 'Ritmo bajo control',
        FinanceInsightType.atypicalExpense =>
          strings.isEnglish ? 'Atypical expense' : 'Gasto atípico',
        FinanceInsightType.healthySavings =>
          strings.isEnglish ? 'Healthy savings' : 'Ahorro saludable',
        FinanceInsightType.savingSuggestion =>
          strings.isEnglish ? 'Simple suggestion' : 'Sugerencia simple',
        FinanceInsightType.monthImproving =>
          strings.isEnglish ? 'Month improving' : 'Mes en mejora',
        FinanceInsightType.monthGettingTighter =>
          strings.isEnglish ? 'More demanding month' : 'Mes más exigente',
        FinanceInsightType.goalOnTrack =>
          strings.isEnglish ? 'Goal on track' : 'Meta encaminada',
      },
      message: switch (insight.type) {
        FinanceInsightType.overcommitted => strings.isEnglish
            ? "Your expenses and savings have already consumed ${percentage ?? 0}% of this month's income."
            : 'Tus gastos y ahorros ya consumieron ${percentage ?? 0}% de tus ingresos del mes.',
        FinanceInsightType.monthWithMargin => strings.isEnglish
            ? 'After spending and saving, you still have a positive margin this month.'
            : 'Después de gastar y ahorrar, todavía te queda un margen positivo este mes.',
        FinanceInsightType.dominantCategory => strings.isEnglish
            ? "${insight.categoryName ?? 'This category'} accounts for ${percentage ?? 0}% of your monthly spending."
            : '${insight.categoryName ?? 'Esta categoría'} concentra ${percentage ?? 0}% de tus gastos del mes.',
        FinanceInsightType.expenseIncrease => strings.isEnglish
            ? "${insight.categoryName ?? 'This category'} went up ${percentage ?? 0}% versus last month."
            : '${insight.categoryName ?? 'Esta categoría'} subió ${percentage ?? 0}% frente al mes anterior.',
        FinanceInsightType.expenseDecrease => strings.isEnglish
            ? "${insight.categoryName ?? 'This category'} went down ${percentage ?? 0}% versus last month."
            : '${insight.categoryName ?? 'Esta categoría'} bajó ${percentage ?? 0}% frente al mes anterior.',
        FinanceInsightType.endOfMonthRisk => strings.isEnglish
            ? 'If you keep this pace, you could finish about ${amount ?? 0} below zero.'
            : 'Si seguís con este ritmo, podrías cerrar con un margen ${amount ?? 0} por debajo de cero.',
        FinanceInsightType.paceOnTrack => strings.isEnglish
            ? 'Your spending projection still closes within the margin available for this month.'
            : 'Tu proyección de gasto cierra dentro del margen disponible para este mes.',
        FinanceInsightType.atypicalExpense => strings.isEnglish
            ? "A single purchase represented ${percentage ?? 0}% of this month's income."
            : 'Una sola compra representó ${percentage ?? 0}% de tus ingresos del mes.',
        FinanceInsightType.healthySavings => strings.isEnglish
            ? "You have already set aside ${percentage ?? 0}% of this month's income."
            : 'Ya separaste ${percentage ?? 0}% de tus ingresos del mes.',
        FinanceInsightType.savingSuggestion => strings.isEnglish
            ? 'Setting aside even 5% when you get paid can give you more breathing room by month end.'
            : 'Reservar aunque sea un 5% al cobrar puede darte más aire para fin de mes.',
        FinanceInsightType.monthImproving => strings.isEnglish
            ? 'Your monthly result is coming in better than the previous period.'
            : 'Tu resultado mensual viene mejor que el del período anterior.',
        FinanceInsightType.monthGettingTighter => strings.isEnglish
            ? 'Your margin dropped versus last month. It is worth reviewing your pace.'
            : 'Tu margen bajó frente al mes anterior. Vale la pena revisar el ritmo.',
        FinanceInsightType.goalOnTrack => strings.isEnglish
            ? "${insight.goalName ?? 'Your goal'} is already at ${percentage ?? 0}% and keeping a good pace."
            : '${insight.goalName ?? 'Tu meta'} ya va en ${percentage ?? 0}% y mantiene buen ritmo.',
      },
      kindLabel: switch (insight.kind) {
        FinanceInsightKind.descriptive =>
          strings.isEnglish ? 'Overview' : 'Descriptivo',
        FinanceInsightKind.diagnostic =>
          strings.isEnglish ? 'Cause' : 'Diagnóstico',
        FinanceInsightKind.predictive =>
          strings.isEnglish ? 'Forecast' : 'Proyección',
        FinanceInsightKind.actionable =>
          strings.isEnglish ? 'Action' : 'Acción',
      },
    );
  }
}
