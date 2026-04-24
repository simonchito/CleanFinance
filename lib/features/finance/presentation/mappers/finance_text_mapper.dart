import '../../../../app/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
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
        ProjectionRiskLevel.low =>
          strings.localized(es: 'Bajo', en: 'Low', pt: 'Baixo'),
        ProjectionRiskLevel.medium =>
          strings.localized(es: 'Medio', en: 'Medium', pt: 'Médio'),
        ProjectionRiskLevel.high =>
          strings.localized(es: 'Alto', en: 'High', pt: 'Alto'),
      },
      interpretation: switch (projection.interpretationType) {
        ProjectionInterpretationType.insufficientActivity => strings.localized(
            es: 'Todavía no hay suficiente actividad este mes para una proyección sólida.',
            en: 'There is not enough activity yet this month for a solid projection.',
            pt: 'Ainda não há atividade suficiente neste mês para uma projeção confiável.',
          ),
        ProjectionInterpretationType.positiveBalance => strings.localized(
            es: 'Vas en camino a cerrar el mes con saldo positivo si mantenés este ritmo.',
            en: 'You are on track to close the month with a positive balance if you keep this pace.',
            pt: 'Você está no caminho para fechar o mês com saldo positivo se mantiver esse ritmo.',
          ),
        ProjectionInterpretationType.tightMargin => strings.localized(
            es: 'Tu ritmo actual podría dejarte con muy poco margen al cierre del mes.',
            en: 'Your current pace could leave you with very little margin by month end.',
            pt: 'Seu ritmo atual pode deixar pouca margem até o fim do mês.',
          ),
        ProjectionInterpretationType.deficitRisk => strings.localized(
            es: 'Si el gasto sigue a este ritmo, este mes podría cerrar en déficit.',
            en: 'If spending continues at this pace, this month could close in deficit.',
            pt: 'Se os gastos continuarem nesse ritmo, o mês pode fechar no negativo.',
          ),
      },
    );
  }

  static LocalizedHealthScoreText healthScore(
    AppStrings strings,
    FinancialHealthScore score,
  ) {
    return switch (score.level) {
      FinancialHealthLevel.strong => LocalizedHealthScoreText(
          label: strings.localized(
            es: 'Muy saludable',
            en: 'Very healthy',
            pt: 'Muito saudável',
          ),
          message: strings.localized(
            es: 'Tu mes viene equilibrado y con buen margen para absorber imprevistos.',
            en: 'Your month looks balanced and leaves enough room to absorb surprises.',
            pt: 'Seu mês está equilibrado e com boa margem para imprevistos.',
          ),
        ),
      FinancialHealthLevel.stable => LocalizedHealthScoreText(
          label: strings.localized(es: 'Estable', en: 'Stable', pt: 'Estável'),
          message: strings.localized(
            es: 'Tus números están bastante controlados, con algunos puntos para seguir de cerca.',
            en: 'Your numbers are fairly controlled, with a few points worth watching.',
            pt: 'Seus números estão bem controlados, com alguns pontos para acompanhar.',
          ),
        ),
      FinancialHealthLevel.attention => LocalizedHealthScoreText(
          label: strings.localized(
            es: 'Atención',
            en: 'Attention',
            pt: 'Atenção',
          ),
          message: strings.localized(
            es: 'Tu flujo sigue funcionando, pero conviene ajustar antes de que el mes se ponga más justo.',
            en: 'Your cash flow is still working, but it is worth adjusting before the month gets tighter.',
            pt: 'Seu fluxo ainda funciona, mas vale ajustar antes que o mês aperte.',
          ),
        ),
      FinancialHealthLevel.risk => LocalizedHealthScoreText(
          label:
              strings.localized(es: 'En riesgo', en: 'At risk', pt: 'Em risco'),
          message: strings.localized(
            es: 'El ritmo actual puede dejarte sin margen antes de cerrar el mes.',
            en: 'Your current pace could leave you with very little margin before month end.',
            pt: 'O ritmo atual pode deixar você com pouca margem antes do fim do mês.',
          ),
        ),
    };
  }

  static LocalizedFinanceInsightText insight(
    AppStrings strings,
    FinanceInsight insight,
  ) {
    final percentage = insight.percentageValue?.round();
    final amount = insight.amountValue == null
        ? null
        : CurrencyFormatter.formatWholeNumber(
            insight.amountValue!,
            localeCode: strings.languageCode,
          );

    return LocalizedFinanceInsightText(
      title: switch (insight.type) {
        FinanceInsightType.overcommitted => strings.localized(
            es: 'Más de lo que entra',
            en: 'More than what comes in',
            pt: 'Mais do que entra',
          ),
        FinanceInsightType.monthWithMargin => strings.localized(
            es: 'Mes con margen',
            en: 'Month with margin',
            pt: 'Mês com folga',
          ),
        FinanceInsightType.dominantCategory => strings.localized(
            es: 'Categoría dominante',
            en: 'Dominant category',
            pt: 'Categoria dominante',
          ),
        FinanceInsightType.expenseIncrease => strings.localized(
            es: 'Cambio brusco de gasto',
            en: 'Sharp spending change',
            pt: 'Mudança forte nos gastos',
          ),
        FinanceInsightType.expenseDecrease => strings.localized(
            es: 'Buen ajuste',
            en: 'Good adjustment',
            pt: 'Bom ajuste',
          ),
        FinanceInsightType.endOfMonthRisk => strings.localized(
            es: 'Riesgo de fin de mes',
            en: 'Month-end risk',
            pt: 'Risco no fim do mês',
          ),
        FinanceInsightType.paceOnTrack => strings.localized(
            es: 'Ritmo bajo control',
            en: 'Pace under control',
            pt: 'Ritmo sob controle',
          ),
        FinanceInsightType.atypicalExpense => strings.localized(
            es: 'Gasto atípico',
            en: 'Atypical expense',
            pt: 'Despesa atípica',
          ),
        FinanceInsightType.healthySavings => strings.localized(
            es: 'Ahorro saludable',
            en: 'Healthy savings',
            pt: 'Economia saudável',
          ),
        FinanceInsightType.savingSuggestion => strings.localized(
            es: 'Sugerencia simple',
            en: 'Simple suggestion',
            pt: 'Sugestão simples',
          ),
        FinanceInsightType.monthImproving => strings.localized(
            es: 'Mes en mejora',
            en: 'Month improving',
            pt: 'Mês melhorando',
          ),
        FinanceInsightType.monthGettingTighter => strings.localized(
            es: 'Mes más exigente',
            en: 'More demanding month',
            pt: 'Mês mais apertado',
          ),
        FinanceInsightType.goalOnTrack => strings.localized(
            es: 'Meta encaminada',
            en: 'Goal on track',
            pt: 'Meta no caminho',
          ),
      },
      message: switch (insight.type) {
        FinanceInsightType.overcommitted => strings.localized(
            es: 'Tus gastos y ahorros ya consumieron ${percentage ?? 0}% de tus ingresos del mes.',
            en: "Your expenses and savings have already consumed ${percentage ?? 0}% of this month's income.",
            pt: 'Suas despesas e economias já consumiram ${percentage ?? 0}% da receita do mês.',
          ),
        FinanceInsightType.monthWithMargin => strings.localized(
            es: 'Después de gastar y ahorrar, todavía te queda un margen positivo este mes.',
            en: 'After spending and saving, you still have a positive margin this month.',
            pt: 'Depois de gastar e economizar, ainda sobra uma margem positiva neste mês.',
          ),
        FinanceInsightType.dominantCategory => strings.localized(
            es: '${insight.categoryName ?? 'Esta categoría'} concentra ${percentage ?? 0}% de tus gastos del mes.',
            en: "${insight.categoryName ?? 'This category'} accounts for ${percentage ?? 0}% of your monthly spending.",
            pt: '${insight.categoryName ?? 'Esta categoria'} concentra ${percentage ?? 0}% dos seus gastos do mês.',
          ),
        FinanceInsightType.expenseIncrease => strings.localized(
            es: '${insight.categoryName ?? 'Esta categoría'} subió ${percentage ?? 0}% frente al mes anterior.',
            en: "${insight.categoryName ?? 'This category'} went up ${percentage ?? 0}% versus last month.",
            pt: '${insight.categoryName ?? 'Esta categoria'} subiu ${percentage ?? 0}% em relação ao mês anterior.',
          ),
        FinanceInsightType.expenseDecrease => strings.localized(
            es: '${insight.categoryName ?? 'Esta categoría'} bajó ${percentage ?? 0}% frente al mes anterior.',
            en: "${insight.categoryName ?? 'This category'} went down ${percentage ?? 0}% versus last month.",
            pt: '${insight.categoryName ?? 'Esta categoria'} caiu ${percentage ?? 0}% em relação ao mês anterior.',
          ),
        FinanceInsightType.endOfMonthRisk => strings.localized(
            es: 'Si seguís con este ritmo, podrías cerrar con un margen ${amount ?? '0'} por debajo de cero.',
            en: 'If you keep this pace, you could finish about ${amount ?? '0'} below zero.',
            pt: 'Se mantiver esse ritmo, você pode fechar cerca de ${amount ?? '0'} abaixo de zero.',
          ),
        FinanceInsightType.paceOnTrack => strings.localized(
            es: 'Tu proyección de gasto cierra dentro del margen disponible para este mes.',
            en: 'Your spending projection still closes within the margin available for this month.',
            pt: 'Sua projeção de gastos ainda fecha dentro da margem disponível para este mês.',
          ),
        FinanceInsightType.atypicalExpense => strings.localized(
            es: 'Una sola compra representó ${percentage ?? 0}% de tus ingresos del mes.',
            en: "A single purchase represented ${percentage ?? 0}% of this month's income.",
            pt: 'Uma única compra representou ${percentage ?? 0}% da receita do mês.',
          ),
        FinanceInsightType.healthySavings => strings.localized(
            es: 'Ya separaste ${percentage ?? 0}% de tus ingresos del mes.',
            en: "You have already set aside ${percentage ?? 0}% of this month's income.",
            pt: 'Você já separou ${percentage ?? 0}% da receita do mês.',
          ),
        FinanceInsightType.savingSuggestion => strings.localized(
            es: 'Reservar aunque sea un 5% al cobrar puede darte más aire para fin de mes.',
            en: 'Setting aside even 5% when you get paid can give you more breathing room by month end.',
            pt: 'Separar até 5% ao receber pode dar mais folga até o fim do mês.',
          ),
        FinanceInsightType.monthImproving => strings.localized(
            es: 'Tu resultado mensual viene mejor que el del período anterior.',
            en: 'Your monthly result is coming in better than the previous period.',
            pt: 'Seu resultado mensal está melhor que o do período anterior.',
          ),
        FinanceInsightType.monthGettingTighter => strings.localized(
            es: 'Tu margen bajó frente al mes anterior. Vale la pena revisar el ritmo.',
            en: 'Your margin dropped versus last month. It is worth reviewing your pace.',
            pt: 'Sua margem caiu em relação ao mês anterior. Vale revisar o ritmo.',
          ),
        FinanceInsightType.goalOnTrack => strings.localized(
            es: '${insight.goalName ?? 'Tu meta'} ya va en ${percentage ?? 0}% y mantiene buen ritmo.',
            en: "${insight.goalName ?? 'Your goal'} is already at ${percentage ?? 0}% and keeping a good pace.",
            pt: '${insight.goalName ?? 'Sua meta'} já chegou a ${percentage ?? 0}% e mantém um bom ritmo.',
          ),
      },
      kindLabel: switch (insight.kind) {
        FinanceInsightKind.descriptive => strings.localized(
            es: 'Descriptivo',
            en: 'Overview',
            pt: 'Resumo',
          ),
        FinanceInsightKind.diagnostic => strings.localized(
            es: 'Diagnóstico',
            en: 'Cause',
            pt: 'Diagnóstico',
          ),
        FinanceInsightKind.predictive => strings.localized(
            es: 'Proyección',
            en: 'Forecast',
            pt: 'Projeção',
          ),
        FinanceInsightKind.actionable => strings.localized(
            es: 'Acción',
            en: 'Action',
            pt: 'Ação',
          ),
      },
    );
  }
}
