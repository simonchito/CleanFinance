enum CategoryScope { income, expense, saving, all }

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.scope,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
    this.parentId,
    this.reminderEnabled = false,
    this.reminderDay,
  });

  final String id;
  final String name;
  final String iconKey;
  final CategoryScope scope;
  final String? parentId;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool reminderEnabled;
  final int? reminderDay;

  bool get isSubcategory => parentId != null;

  Category copyWith({
    String? id,
    String? name,
    String? iconKey,
    CategoryScope? scope,
    String? parentId,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? reminderEnabled,
    int? reminderDay,
    bool clearReminderDay = false,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      iconKey: iconKey ?? this.iconKey,
      scope: scope ?? this.scope,
      parentId: parentId ?? this.parentId,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderDay: clearReminderDay ? null : reminderDay ?? this.reminderDay,
    );
  }
}
