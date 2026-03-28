import '../entities/analytics_models.dart';

class FinancialHealthScoreService {
  const FinancialHealthScoreService();

  FinancialHealthScore build({
    required CashflowSnapshot cashflow,
    required SpendingPaceReport spendingPace,
    required CategoryComparisonReport categoryComparison,
  }) {
    var score = 50;

    if (cashflow.netBalance >= 0) {
      score += 18;
    } else {
      score -= 18;
    }

    if (cashflow.savingsRate >= 0.2) {
      score += 16;
    } else if (cashflow.savingsRate >= 0.1) {
      score += 10;
    } else if (cashflow.savingsRate > 0) {
      score += 4;
    } else {
      score -= 8;
    }

    switch (spendingPace.status) {
      case SpendingPaceStatus.onTrack:
        score += 10;
      case SpendingPaceStatus.watch:
        score += 2;
      case SpendingPaceStatus.risk:
        score -= 14;
    }

    if (cashflow.income > 0 && cashflow.committedRate <= 0.85) {
      score += 8;
    } else if (cashflow.isOvercommitted) {
      score -= 12;
    }

    if ((categoryComparison.dominantCategory?.shareOfCurrent ?? 0) > 0.45) {
      score -= 6;
    }

    final normalizedScore = score.clamp(0, 100);

    if (normalizedScore >= 80) {
      return FinancialHealthScore(
        score: normalizedScore,
        level: FinancialHealthLevel.strong,
        label: 'Muy saludable',
        message:
            'Tu mes viene equilibrado y con buen margen para absorber imprevistos.',
      );
    }
    if (normalizedScore >= 60) {
      return FinancialHealthScore(
        score: normalizedScore,
        level: FinancialHealthLevel.stable,
        label: 'Estable',
        message:
            'Tus números están bastante controlados, con algunos puntos para seguir de cerca.',
      );
    }
    if (normalizedScore >= 40) {
      return FinancialHealthScore(
        score: normalizedScore,
        level: FinancialHealthLevel.attention,
        label: 'Atención',
        message:
            'Tu flujo sigue funcionando, pero conviene ajustar antes de que el mes se ponga más justo.',
      );
    }

    return FinancialHealthScore(
      score: normalizedScore,
      level: FinancialHealthLevel.risk,
      label: 'En riesgo',
      message: 'El ritmo actual puede dejarte sin margen antes de cerrar el mes.',
    );
  }
}
