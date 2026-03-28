import '../entities/dashboard_summary.dart';
import '../entities/movement.dart';
import '../entities/movement_filter.dart';
import '../entities/reports_snapshot.dart';

abstract class MovementsRepository {
  Future<DashboardSummary> getDashboardSummary(DateTime month);
  Future<List<Movement>> getMovements({
    MovementFilter filter = const MovementFilter(),
  });
  Future<void> upsertMovement(Movement movement);
  Future<void> deleteMovement(String movementId);
  Future<ReportsSnapshot> getReportsSnapshot(DateTime month);
}
