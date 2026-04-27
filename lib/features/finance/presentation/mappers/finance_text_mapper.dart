import '../../../../app/app_strings.dart';
import '../../../../core/utils/amount_visibility_formatter.dart';
import '../../domain/entities/analytics_models.dart';
import '../../domain/entities/end_of_month_projection.dart';
import '../../domain/entities/finance_insight.dart';
import 'default_category_name_localizer.dart';

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
        ProjectionRiskLevel.low => strings.t('bajo'),
        ProjectionRiskLevel.medium => strings.t('medio'),
        ProjectionRiskLevel.high => strings.t('alto'),
      },
      interpretation: switch (projection.interpretationType) {
        ProjectionInterpretationType.insufficientActivity =>
          strings.t('todaviaNoHaySuficienteActividadEsteMes'),
        ProjectionInterpretationType.positiveBalance =>
          strings.t('vasEnCaminoACerrarElMes'),
        ProjectionInterpretationType.tightMargin =>
          strings.t('tuRitmoActualPodriaDejarteConMuy'),
        ProjectionInterpretationType.deficitRisk =>
          strings.t('siElGastoSigueAEsteRitmo'),
      },
    );
  }

  static LocalizedHealthScoreText healthScore(
    AppStrings strings,
    FinancialHealthScore score,
  ) {
    return switch (score.level) {
      FinancialHealthLevel.strong => LocalizedHealthScoreText(
          label: strings.t('muySaludable'),
          message: strings.t('tuMesVieneEquilibradoYConBuen'),
        ),
      FinancialHealthLevel.stable => LocalizedHealthScoreText(
          label: strings.t('estable'),
          message: strings.t('tusNumerosEstanBastanteControladosConAlgunos'),
        ),
      FinancialHealthLevel.attention => LocalizedHealthScoreText(
          label: strings.t('atencion'),
          message: strings.t('tuFlujoSigueFuncionandoPeroConvieneAjustar'),
        ),
      FinancialHealthLevel.risk => LocalizedHealthScoreText(
          label: strings.t('enRiesgo'),
          message: strings.t('elRitmoActualPuedeDejarteSinMargen'),
        ),
    };
  }

  static LocalizedFinanceInsightText insight(
    AppStrings strings,
    FinanceInsight insight, {
    bool showAmounts = true,
    String currencySymbol = r'$',
  }) {
    final percentage = insight.percentageValue?.round();
    final amount = insight.amountValue == null
        ? null
        : AmountVisibilityFormatter.formatCurrency(
            amount: insight.amountValue!,
            symbol: currencySymbol,
            isVisible: showAmounts,
            localeCode: strings.languageCode,
          );
    final categoryName = insight.categoryName == null
        ? strings.t('estaCategoria')
        : DefaultCategoryNameLocalizer.localizeDefaultName(
            insight.categoryName!,
            strings,
            isDefault: insight.categoryIsDefault,
          );

    return LocalizedFinanceInsightText(
      title: switch (insight.type) {
        FinanceInsightType.overcommitted => strings.t('masDeLoQueEntra'),
        FinanceInsightType.monthWithMargin => strings.t('mesConMargen'),
        FinanceInsightType.dominantCategory => strings.t('categoriaDominante'),
        FinanceInsightType.expenseIncrease => strings.t('cambioBruscoDeGasto'),
        FinanceInsightType.expenseDecrease => strings.t('buenAjuste'),
        FinanceInsightType.endOfMonthRisk => strings.t('riesgoDeFinDeMes'),
        FinanceInsightType.paceOnTrack => strings.t('ritmoBajoControl'),
        FinanceInsightType.atypicalExpense => strings.t('gastoAtipico'),
        FinanceInsightType.healthySavings => strings.t('ahorroSaludable'),
        FinanceInsightType.savingSuggestion => strings.t('sugerenciaSimple'),
        FinanceInsightType.monthImproving => strings.t('mesEnMejora'),
        FinanceInsightType.monthGettingTighter => strings.t('mesMasExigente'),
        FinanceInsightType.goalOnTrack => strings.t('metaEncaminada'),
      },
      message: switch (insight.type) {
        FinanceInsightType.overcommitted =>
          strings.financeInsightOvercommittedMessage(percentage ?? 0),
        FinanceInsightType.monthWithMargin =>
          strings.t('despuesDeGastarYAhorrarTodaviaTe'),
        FinanceInsightType.dominantCategory =>
          strings.financeInsightDominantCategoryMessage(
            categoryName,
            percentage ?? 0,
          ),
        FinanceInsightType.expenseIncrease =>
          strings.financeInsightExpenseIncreaseMessage(
            categoryName,
            percentage ?? 0,
          ),
        FinanceInsightType.expenseDecrease =>
          strings.financeInsightExpenseDecreaseMessage(
            categoryName,
            percentage ?? 0,
          ),
        FinanceInsightType.endOfMonthRisk =>
          strings.financeInsightEndOfMonthRiskMessage(amount ?? '0'),
        FinanceInsightType.paceOnTrack =>
          strings.t('tuProyeccionDeGastoCierraDentroDel'),
        FinanceInsightType.atypicalExpense =>
          strings.financeInsightAtypicalExpenseMessage(percentage ?? 0),
        FinanceInsightType.healthySavings =>
          strings.financeInsightHealthySavingsMessage(percentage ?? 0),
        FinanceInsightType.savingSuggestion =>
          strings.t('reservarAunqueSeaUn5AlCobrar'),
        FinanceInsightType.monthImproving =>
          strings.t('tuResultadoMensualVieneMejorQueEl'),
        FinanceInsightType.monthGettingTighter =>
          strings.t('tuMargenBajoFrenteAlMesAnterior'),
        FinanceInsightType.goalOnTrack =>
          strings.financeInsightGoalOnTrackMessage(
            insight.goalName ?? strings.t('tuMeta'),
            percentage ?? 0,
          ),
      },
      kindLabel: switch (insight.kind) {
        FinanceInsightKind.descriptive => strings.text2,
        FinanceInsightKind.diagnostic => strings.text3,
        FinanceInsightKind.predictive => strings.text4,
        FinanceInsightKind.actionable => strings.text5,
      },
    );
  }
}
