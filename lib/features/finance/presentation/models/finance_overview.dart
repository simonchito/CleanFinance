import '../../domain/entities/dashboard_summary.dart';
import '../../domain/entities/finance_insight.dart';
import '../../domain/entities/movement.dart';
import '../../domain/entities/reports_snapshot.dart';

class MonthlyTrendPoint {
  const MonthlyTrendPoint({
    required this.label,
    required this.income,
    required this.expense,
  });

  final String label;
  final double income;
  final double expense;
}

class FinanceOverview {
  const FinanceOverview({
    required this.summary,
    required this.reports,
    required this.recentMovements,
    required this.monthlyTrend,
    required this.insights,
    required this.monthRemaining,
    required this.averageExpense,
    required this.largestExpense,
  });

  final DashboardSummary summary;
  final ReportsSnapshot reports;
  final List<Movement> recentMovements;
  final List<MonthlyTrendPoint> monthlyTrend;
  final List<FinanceInsight> insights;
  final double monthRemaining;
  final double averageExpense;
  final double largestExpense;
}
