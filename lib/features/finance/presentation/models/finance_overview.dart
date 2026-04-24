import '../../domain/entities/analytics_models.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/entities/end_of_month_projection.dart';
import '../../domain/entities/finance_insight.dart';
import '../../domain/entities/movement.dart';
import '../../domain/entities/reports_snapshot.dart';

class FinanceOverview {
  const FinanceOverview({
    required this.summary,
    required this.reports,
    required this.recentMovements,
    required this.cashflow,
    required this.monthlyTrend,
    required this.categoryComparison,
    required this.spendingPace,
    required this.endOfMonthProjection,
    required this.savingsGoals,
    required this.paymentMethodReport,
    required this.healthScore,
    required this.insights,
  });

  final DashboardSummary summary;
  final ReportsSnapshot reports;
  final List<Movement> recentMovements;
  final CashflowSnapshot cashflow;
  final List<MonthlyTrendPoint> monthlyTrend;
  final CategoryComparisonReport categoryComparison;
  final SpendingPaceReport spendingPace;
  final EndOfMonthProjection endOfMonthProjection;
  final List<SavingsGoalForecast> savingsGoals;
  final PaymentMethodReport paymentMethodReport;
  final FinancialHealthScore healthScore;
  final List<FinanceInsight> insights;

  double get monthRemaining => cashflow.netBalance;
}
