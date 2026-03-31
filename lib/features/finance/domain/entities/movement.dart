enum MovementType { income, expense, saving }

class Movement {
  const Movement({
    required this.id,
    required this.type,
    required this.amount,
    required this.categoryId,
    required this.occurredOn,
    required this.createdAt,
    required this.updatedAt,
    this.subcategoryId,
    this.goalId,
    this.note,
    this.paymentMethod,
    this.categoryName,
    this.subcategoryName,
    this.monthlyReminderEnabled = false,
    this.reminderDay,
  });

  final String id;
  final MovementType type;
  final double amount;
  final String categoryId;
  final String? subcategoryId;
  final String? goalId;
  final DateTime occurredOn;
  final String? note;
  final String? paymentMethod;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? categoryName;
  final String? subcategoryName;
  final bool monthlyReminderEnabled;
  final int? reminderDay;

  Movement copyWith({
    String? id,
    MovementType? type,
    double? amount,
    String? categoryId,
    String? subcategoryId,
    String? goalId,
    DateTime? occurredOn,
    String? note,
    String? paymentMethod,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? categoryName,
    String? subcategoryName,
    bool? monthlyReminderEnabled,
    int? reminderDay,
  }) {
    return Movement(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      goalId: goalId ?? this.goalId,
      occurredOn: occurredOn ?? this.occurredOn,
      note: note ?? this.note,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      categoryName: categoryName ?? this.categoryName,
      subcategoryName: subcategoryName ?? this.subcategoryName,
      monthlyReminderEnabled:
          monthlyReminderEnabled ?? this.monthlyReminderEnabled,
      reminderDay: reminderDay ?? this.reminderDay,
    );
  }
}
