import '../entities/end_of_month_projection.dart';

class EndOfMonthProjectionService {
  const EndOfMonthProjectionService();

  static const double weakMarginRatio = 0.10;

  EndOfMonthProjection build({
    required DateTime referenceDate,
    required double incomeSoFar,
    required double expenseSoFar,
  }) {
    final totalDaysInMonth = DateTime(
      referenceDate.year,
      referenceDate.month + 1,
      0,
    ).day;
    final daysElapsed = referenceDate.day.clamp(1, totalDaysInMonth);
    final daysRemaining = (totalDaysInMonth - daysElapsed).clamp(
      0,
      totalDaysInMonth,
    );
    final avgDailyExpense = expenseSoFar / daysElapsed;
    final projectedExpense = avgDailyExpense * totalDaysInMonth;
    final projectedNet = incomeSoFar - projectedExpense;
    final riskLevel = _riskLevelFor(
      projectedNet: projectedNet,
      incomeSoFar: incomeSoFar,
    );

    return EndOfMonthProjection(
      incomeSoFar: incomeSoFar,
      expenseSoFar: expenseSoFar,
      avgDailyExpense: avgDailyExpense,
      daysElapsed: daysElapsed,
      totalDaysInMonth: totalDaysInMonth,
      daysRemaining: daysRemaining,
      projectedExpense: projectedExpense,
      projectedNet: projectedNet,
      riskLevel: riskLevel,
      interpretation: _interpretationFor(
        riskLevel: riskLevel,
        incomeSoFar: incomeSoFar,
        expenseSoFar: expenseSoFar,
      ),
    );
  }

  ProjectionRiskLevel _riskLevelFor({
    required double projectedNet,
    required double incomeSoFar,
  }) {
    if (projectedNet < 0) {
      return ProjectionRiskLevel.high;
    }

    final weakMarginThreshold = incomeSoFar <= 0
        ? 0
        : incomeSoFar * weakMarginRatio;

    if (projectedNet <= weakMarginThreshold) {
      return ProjectionRiskLevel.medium;
    }

    return ProjectionRiskLevel.low;
  }

  String _interpretationFor({
    required ProjectionRiskLevel riskLevel,
    required double incomeSoFar,
    required double expenseSoFar,
  }) {
    if (incomeSoFar <= 0 && expenseSoFar <= 0) {
      return 'Todavia no hay suficiente actividad este mes para una proyeccion solida.';
    }

    return switch (riskLevel) {
      ProjectionRiskLevel.low =>
        'Vas en camino a cerrar el mes con saldo positivo si mantenes este ritmo.',
      ProjectionRiskLevel.medium =>
        'Tu ritmo actual podria dejarte con muy poco margen al cierre del mes.',
      ProjectionRiskLevel.high =>
        'Si el gasto sigue a este ritmo, este mes podria cerrar en deficit.',
    };
  }
}
