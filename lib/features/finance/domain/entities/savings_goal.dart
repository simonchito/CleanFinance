class SavingsGoal {
  const SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
    this.targetDate,
  });

  final String id;
  final String name;
  final double targetAmount;
  final DateTime? targetDate;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;

  SavingsGoal copyWith({
    String? id,
    String? name,
    double? targetAmount,
    DateTime? targetDate,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SavingsGoal(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      targetDate: targetDate ?? this.targetDate,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class SavingsGoalProgress {
  const SavingsGoalProgress({
    required this.goal,
    required this.savedAmount,
  });

  final SavingsGoal goal;
  final double savedAmount;

  double get progress {
    if (goal.targetAmount <= 0) {
      return 0;
    }
    return (savedAmount / goal.targetAmount).clamp(0, 1);
  }

  bool get completed => savedAmount >= goal.targetAmount;
}
