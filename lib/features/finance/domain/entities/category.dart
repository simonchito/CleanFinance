enum CategoryScope { income, expense, saving, all }

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.scope,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
    this.parentId,
  });

  final String id;
  final String name;
  final CategoryScope scope;
  final String? parentId;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isSubcategory => parentId != null;

  Category copyWith({
    String? id,
    String? name,
    CategoryScope? scope,
    String? parentId,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      scope: scope ?? this.scope,
      parentId: parentId ?? this.parentId,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
