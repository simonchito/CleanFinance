import '../../../../core/utils/month_context.dart';
import '../entities/end_of_month_projection.dart';

class EndOfMonthProjectionService {
  const EndOfMonthProjectionService();

  static const double weakMarginRatio = 0.10;

  EndOfMonthProjection build({
    required DateTime referenceDate,
    required double incomeSoFar,
    required double expenseSoFar,
  }) {
    final monthContext = MonthContext.forDate(referenceDate);
    final avgDailyExpense = expenseSoFar / monthContext.daysElapsed;
    final projectedExpense = avgDailyExpense * monthContext.totalDaysInMonth;
    final projectedNet = incomeSoFar - projectedExpense;
    final riskLevel = _riskLevelFor(
      projectedNet: projectedNet,
      incomeSoFar: incomeSoFar,
    );

    return EndOfMonthProjection(
      incomeSoFar: incomeSoFar,
      expenseSoFar: expenseSoFar,
      avgDailyExpense: avgDailyExpense,
      daysElapsed: monthContext.daysElapsed,
      totalDaysInMonth: monthContext.totalDaysInMonth,
      daysRemaining: monthContext.daysRemaining,
      projectedExpense: projectedExpense,
      projectedNet: projectedNet,
      riskLevel: riskLevel,
      interpretationType: _interpretationFor(
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

    final weakMarginThreshold =
        incomeSoFar <= 0 ? 0 : incomeSoFar * weakMarginRatio;

    if (projectedNet <= weakMarginThreshold) {
      return ProjectionRiskLevel.medium;
    }

    return ProjectionRiskLevel.low;
  }

  ProjectionInterpretationType _interpretationFor({
    required ProjectionRiskLevel riskLevel,
    required double incomeSoFar,
    required double expenseSoFar,
  }) {
    if (incomeSoFar <= 0 && expenseSoFar <= 0) {
      return ProjectionInterpretationType.insufficientActivity;
    }

    return switch (riskLevel) {
      ProjectionRiskLevel.low => ProjectionInterpretationType.positiveBalance,
      ProjectionRiskLevel.medium => ProjectionInterpretationType.tightMargin,
      ProjectionRiskLevel.high => ProjectionInterpretationType.deficitRisk,
    };
  }
}
