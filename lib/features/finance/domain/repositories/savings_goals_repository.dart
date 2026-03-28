import '../entities/savings_goal.dart';

abstract class SavingsGoalsRepository {
  Future<List<SavingsGoalProgress>> getSavingsGoals();
  Future<void> upsertSavingsGoal(SavingsGoal goal);
  Future<void> deleteSavingsGoal(String goalId);
}
