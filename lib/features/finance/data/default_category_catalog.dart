import '../domain/entities/category.dart';

class SeedCategoryDefinition {
  const SeedCategoryDefinition({
    required this.name,
    required this.scope,
    this.subcategories = const <String>[],
  });

  final String name;
  final CategoryScope scope;
  final List<String> subcategories;
}

abstract final class DefaultCategoryCatalog {
  static const List<SeedCategoryDefinition> categories = [
    SeedCategoryDefinition(name: 'Sueldo', scope: CategoryScope.income),
    SeedCategoryDefinition(name: 'Freelance', scope: CategoryScope.income),
    SeedCategoryDefinition(name: 'Venta', scope: CategoryScope.income),
    SeedCategoryDefinition(
      name: 'Hogar',
      scope: CategoryScope.expense,
      subcategories: [
        'Alquiler',
        'Expensas',
        'Reparaciones',
        'Mantenimiento',
        'Limpieza',
        'Muebles',
        'Electrodomésticos',
        'Decoración',
      ],
    ),
    SeedCategoryDefinition(
      name: 'Servicios',
      scope: CategoryScope.expense,
      subcategories: [
        'Luz',
        'Gas',
        'Agua',
        'Internet',
        'Cable y TV',
        'Teléfono',
        'Streaming',
        'Nube y apps',
      ],
    ),
    SeedCategoryDefinition(
      name: 'Alimentación',
      scope: CategoryScope.expense,
      subcategories: [
        'Supermercado',
        'Verdulería',
        'Carnicería',
        'Panadería',
        'Delivery',
        'Restaurantes',
        'Cafetería',
      ],
    ),
    SeedCategoryDefinition(
      name: 'Transporte',
      scope: CategoryScope.expense,
      subcategories: [
        'Combustible',
        'Transporte público',
        'Taxi / Remis',
        'Uber / Cabify',
        'Peajes',
        'Estacionamiento',
        'Mantenimiento del vehículo',
        'Seguro del auto',
      ],
    ),
    SeedCategoryDefinition(
      name: 'Salud',
      scope: CategoryScope.expense,
      subcategories: [
        'Obra social / prepaga',
        'Medicamentos',
        'Consultas médicas',
        'Estudios',
        'Odontología',
        'Óptica',
      ],
    ),
    SeedCategoryDefinition(
      name: 'Educación',
      scope: CategoryScope.expense,
      subcategories: [
        'Cuotas',
        'Cursos',
        'Libros',
        'Materiales',
        'Suscripciones educativas',
      ],
    ),
    SeedCategoryDefinition(
      name: 'Compras',
      scope: CategoryScope.expense,
      subcategories: [
        'Ropa',
        'Calzado',
        'Tecnología',
        'Hogar',
        'Regalos',
        'Compras online',
      ],
    ),
    SeedCategoryDefinition(
      name: 'Ocio',
      scope: CategoryScope.expense,
      subcategories: [
        'Salidas',
        'Cine',
        'Eventos',
        'Juegos',
        'Hobbies',
        'Vacaciones',
      ],
    ),
    SeedCategoryDefinition(
      name: 'Finanzas',
      scope: CategoryScope.expense,
      subcategories: [
        'Tarjetas de crédito',
        'Intereses',
        'Comisiones bancarias',
        'Impuestos',
        'Monotributo / Autónomos',
      ],
    ),
    SeedCategoryDefinition(
      name: 'Familia',
      scope: CategoryScope.expense,
      subcategories: [
        'Hijos',
        'Mascotas',
        'Cuidado personal',
        'Guardería / Colegio',
      ],
    ),
    SeedCategoryDefinition(
      name: 'Trabajo',
      scope: CategoryScope.expense,
      subcategories: [
        'Herramientas',
        'Transporte laboral',
        'Comidas laborales',
        'Capacitación',
      ],
    ),
    SeedCategoryDefinition(
      name: 'Otros',
      scope: CategoryScope.expense,
      subcategories: [
        'Donaciones',
        'Imprevistos',
        'Varios',
      ],
    ),
    SeedCategoryDefinition(
      name: 'Ahorro general',
      scope: CategoryScope.saving,
    ),
    SeedCategoryDefinition(
      name: 'Fondo de emergencia',
      scope: CategoryScope.saving,
    ),
    SeedCategoryDefinition(name: 'Viaje', scope: CategoryScope.saving),
  ];

  static final Map<String, int> _topLevelOrder = _buildTopLevelOrder();
  static final Map<String, int> _subcategoryOrder = _buildSubcategoryOrder();

  static int compare(
    Category left,
    Category right,
    Map<String, Category> categoriesById,
  ) {
    final scopeCompare = _scopeRank(left.scope).compareTo(_scopeRank(right.scope));
    if (scopeCompare != 0) {
      return scopeCompare;
    }

    final leftParent = left.parentId == null ? null : categoriesById[left.parentId];
    final rightParent =
        right.parentId == null ? null : categoriesById[right.parentId];
    final leftRootName = leftParent?.name ?? left.name;
    final rightRootName = rightParent?.name ?? right.name;

    final topLevelCompare = _compareOrder(
      _topLevelOrder[topLevelKey(left.scope, leftRootName)],
      _topLevelOrder[topLevelKey(right.scope, rightRootName)],
    );
    if (topLevelCompare != 0) {
      return topLevelCompare;
    }

    final levelCompare = (left.isSubcategory ? 1 : 0).compareTo(
      right.isSubcategory ? 1 : 0,
    );
    if (levelCompare != 0) {
      return levelCompare;
    }

    if (left.isSubcategory && right.isSubcategory) {
      final subcategoryCompare = _compareOrder(
        _subcategoryOrder[subcategoryKey(left.scope, leftRootName, left.name)],
        _subcategoryOrder[subcategoryKey(right.scope, rightRootName, right.name)],
      );
      if (subcategoryCompare != 0) {
        return subcategoryCompare;
      }
    }

    return normalizeName(left.name).compareTo(normalizeName(right.name));
  }

  static String topLevelKey(CategoryScope scope, String name) {
    return '${scope.name}::${normalizeName(name)}';
  }

  static String subcategoryKey(
    CategoryScope scope,
    String parentName,
    String childName,
  ) {
    return '${scope.name}::${normalizeName(parentName)}::${normalizeName(childName)}';
  }

  static String normalizeName(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
  }

  static int _scopeRank(CategoryScope scope) {
    return switch (scope) {
      CategoryScope.income => 0,
      CategoryScope.expense => 1,
      CategoryScope.saving => 2,
      CategoryScope.all => 3,
    };
  }

  static int _compareOrder(int? left, int? right) {
    if (left != null && right != null) {
      return left.compareTo(right);
    }
    if (left != null) {
      return -1;
    }
    if (right != null) {
      return 1;
    }
    return 0;
  }

  static Map<String, int> _buildTopLevelOrder() {
    final order = <String, int>{};
    for (var index = 0; index < categories.length; index++) {
      final category = categories[index];
      order[topLevelKey(category.scope, category.name)] = index;
    }
    return order;
  }

  static Map<String, int> _buildSubcategoryOrder() {
    final order = <String, int>{};
    for (final category in categories) {
      for (var index = 0; index < category.subcategories.length; index++) {
        order[subcategoryKey(
          category.scope,
          category.name,
          category.subcategories[index],
        )] = index;
      }
    }
    return order;
  }
}
