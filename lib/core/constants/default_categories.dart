class DefaultSubcategoryDefinition {
  const DefaultSubcategoryDefinition({
    required this.name,
    required this.iconKey,
  });

  final String name;
  final String iconKey;
}

class DefaultCategoryDefinition {
  const DefaultCategoryDefinition({
    required this.name,
    required this.iconKey,
    required this.scope,
    this.subcategories = const <DefaultSubcategoryDefinition>[],
  });

  final String name;
  final String iconKey;
  final String scope;
  final List<DefaultSubcategoryDefinition> subcategories;
}

abstract final class DefaultCategories {
  static const List<DefaultCategoryDefinition> income = [
    DefaultCategoryDefinition(
      name: 'Sueldo',
      iconKey: 'payments',
      scope: 'income',
    ),
    DefaultCategoryDefinition(
      name: 'Freelance',
      iconKey: 'work',
      scope: 'income',
    ),
    DefaultCategoryDefinition(
      name: 'Venta',
      iconKey: 'storefront',
      scope: 'income',
    ),
  ];

  static const List<DefaultCategoryDefinition> expense = [
    DefaultCategoryDefinition(
      name: 'Hogar',
      iconKey: 'home',
      scope: 'expense',
      subcategories: [
        DefaultSubcategoryDefinition(name: 'Alquiler', iconKey: 'home'),
        DefaultSubcategoryDefinition(name: 'Decoración', iconKey: 'palette'),
        DefaultSubcategoryDefinition(
          name: 'Electrodomésticos',
          iconKey: 'kitchen',
        ),
        DefaultSubcategoryDefinition(name: 'Expensas', iconKey: 'receipt'),
        DefaultSubcategoryDefinition(
          name: 'Limpieza',
          iconKey: 'cleaning_services',
        ),
        DefaultSubcategoryDefinition(name: 'Mantenimiento', iconKey: 'build'),
        DefaultSubcategoryDefinition(name: 'Muebles', iconKey: 'chair'),
        DefaultSubcategoryDefinition(name: 'Reparaciones', iconKey: 'handyman'),
      ],
    ),
    DefaultCategoryDefinition(
      name: 'Servicios',
      iconKey: 'bolt',
      scope: 'expense',
      subcategories: [
        DefaultSubcategoryDefinition(name: 'Agua', iconKey: 'water_drop'),
        DefaultSubcategoryDefinition(name: 'Cable / TV', iconKey: 'tv'),
        DefaultSubcategoryDefinition(
          name: 'Gas',
          iconKey: 'local_fire_department',
        ),
        DefaultSubcategoryDefinition(name: 'Internet', iconKey: 'wifi'),
        DefaultSubcategoryDefinition(name: 'Luz', iconKey: 'electric_bolt'),
        DefaultSubcategoryDefinition(name: 'Nube / Apps', iconKey: 'cloud'),
        DefaultSubcategoryDefinition(
          name: 'Streaming',
          iconKey: 'play_circle',
        ),
        DefaultSubcategoryDefinition(name: 'Teléfono', iconKey: 'phone'),
      ],
    ),
    DefaultCategoryDefinition(
      name: 'Alimentos',
      iconKey: 'restaurant',
      scope: 'expense',
      subcategories: [
        DefaultSubcategoryDefinition(name: 'Cafetería', iconKey: 'coffee'),
        DefaultSubcategoryDefinition(name: 'Carnicería', iconKey: 'set_meal'),
        DefaultSubcategoryDefinition(
          name: 'Delivery',
          iconKey: 'delivery_dining',
        ),
        DefaultSubcategoryDefinition(
          name: 'Panadería',
          iconKey: 'bakery_dining',
        ),
        DefaultSubcategoryDefinition(
          name: 'Restaurantes',
          iconKey: 'restaurant_menu',
        ),
        DefaultSubcategoryDefinition(
          name: 'Supermercado',
          iconKey: 'shopping_cart',
        ),
        DefaultSubcategoryDefinition(name: 'Verdulería', iconKey: 'eco'),
      ],
    ),
    DefaultCategoryDefinition(
      name: 'Transporte',
      iconKey: 'car',
      scope: 'expense',
      subcategories: [
        DefaultSubcategoryDefinition(
          name: 'Combustible',
          iconKey: 'local_gas_station',
        ),
        DefaultSubcategoryDefinition(
          name: 'Estacionamiento',
          iconKey: 'local_parking',
        ),
        DefaultSubcategoryDefinition(
          name: 'Mantenimiento del vehículo',
          iconKey: 'build',
        ),
        DefaultSubcategoryDefinition(name: 'Peajes', iconKey: 'toll'),
        DefaultSubcategoryDefinition(
          name: 'Seguro del auto',
          iconKey: 'security',
        ),
        DefaultSubcategoryDefinition(
            name: 'Taxi / Remis', iconKey: 'local_taxi'),
        DefaultSubcategoryDefinition(
          name: 'Transporte público',
          iconKey: 'directions_bus',
        ),
        DefaultSubcategoryDefinition(
          name: 'Uber / Cabify',
          iconKey: 'emoji_transportation',
        ),
      ],
    ),
    DefaultCategoryDefinition(
      name: 'Salud',
      iconKey: 'health',
      scope: 'expense',
      subcategories: [
        DefaultSubcategoryDefinition(
          name: 'Consultas médicas',
          iconKey: 'medical_services',
        ),
        DefaultSubcategoryDefinition(name: 'Estudios', iconKey: 'science'),
        DefaultSubcategoryDefinition(
          name: 'Medicamentos',
          iconKey: 'medication',
        ),
        DefaultSubcategoryDefinition(
          name: 'Obra social / Prepaga',
          iconKey: 'health_and_safety',
        ),
        DefaultSubcategoryDefinition(name: 'Odontología', iconKey: 'mood'),
        DefaultSubcategoryDefinition(name: 'Óptica', iconKey: 'visibility'),
      ],
    ),
    DefaultCategoryDefinition(
      name: 'Educación',
      iconKey: 'education',
      scope: 'expense',
      subcategories: [
        DefaultSubcategoryDefinition(name: 'Cursos', iconKey: 'menu_book'),
        DefaultSubcategoryDefinition(name: 'Cuotas', iconKey: 'payments'),
        DefaultSubcategoryDefinition(name: 'Libros', iconKey: 'book'),
        DefaultSubcategoryDefinition(name: 'Materiales', iconKey: 'edit'),
        DefaultSubcategoryDefinition(
          name: 'Suscripciones educativas',
          iconKey: 'school',
        ),
      ],
    ),
    DefaultCategoryDefinition(
      name: 'Compras',
      iconKey: 'shopping',
      scope: 'expense',
      subcategories: [
        DefaultSubcategoryDefinition(name: 'Calzado', iconKey: 'hiking'),
        DefaultSubcategoryDefinition(
          name: 'Compras online',
          iconKey: 'language',
        ),
        DefaultSubcategoryDefinition(name: 'Hogar', iconKey: 'home'),
        DefaultSubcategoryDefinition(
          name: 'Regalos',
          iconKey: 'card_giftcard',
        ),
        DefaultSubcategoryDefinition(name: 'Ropa', iconKey: 'checkroom'),
        DefaultSubcategoryDefinition(name: 'Tecnología', iconKey: 'devices'),
      ],
    ),
    DefaultCategoryDefinition(
      name: 'Ocio',
      iconKey: 'entertainment',
      scope: 'expense',
      subcategories: [
        DefaultSubcategoryDefinition(name: 'Cine', iconKey: 'movie'),
        DefaultSubcategoryDefinition(name: 'Eventos', iconKey: 'event'),
        DefaultSubcategoryDefinition(
          name: 'Hobbies',
          iconKey: 'sports_esports',
        ),
        DefaultSubcategoryDefinition(
          name: 'Juegos',
          iconKey: 'sports_esports',
        ),
        DefaultSubcategoryDefinition(name: 'Salidas', iconKey: 'nightlife'),
        DefaultSubcategoryDefinition(name: 'Vacaciones', iconKey: 'flight'),
      ],
    ),
    DefaultCategoryDefinition(
      name: 'Finanzas',
      iconKey: 'finance',
      scope: 'expense',
      subcategories: [
        DefaultSubcategoryDefinition(
          name: 'Comisiones bancarias',
          iconKey: 'account_balance_wallet',
        ),
        DefaultSubcategoryDefinition(
          name: 'Impuestos',
          iconKey: 'receipt_long',
        ),
        DefaultSubcategoryDefinition(name: 'Intereses', iconKey: 'percent'),
        DefaultSubcategoryDefinition(
          name: 'Monotributo / Autónomos',
          iconKey: 'business',
        ),
        DefaultSubcategoryDefinition(
          name: 'Tarjetas de crédito',
          iconKey: 'credit_card',
        ),
      ],
    ),
    DefaultCategoryDefinition(
      name: 'Familia',
      iconKey: 'family',
      scope: 'expense',
      subcategories: [
        DefaultSubcategoryDefinition(
          name: 'Cuidado personal',
          iconKey: 'self_improvement',
        ),
        DefaultSubcategoryDefinition(
          name: 'Guardería / Colegio',
          iconKey: 'child_care',
        ),
        DefaultSubcategoryDefinition(
          name: 'Hijos',
          iconKey: 'child_friendly',
        ),
        DefaultSubcategoryDefinition(name: 'Mascotas', iconKey: 'pets'),
      ],
    ),
    DefaultCategoryDefinition(
      name: 'Trabajo',
      iconKey: 'work',
      scope: 'expense',
      subcategories: [
        DefaultSubcategoryDefinition(name: 'Capacitación', iconKey: 'school'),
        DefaultSubcategoryDefinition(
          name: 'Comidas laborales',
          iconKey: 'lunch_dining',
        ),
        DefaultSubcategoryDefinition(name: 'Herramientas', iconKey: 'build'),
        DefaultSubcategoryDefinition(
          name: 'Transporte laboral',
          iconKey: 'commute',
        ),
      ],
    ),
    DefaultCategoryDefinition(
      name: 'Otros',
      iconKey: 'category',
      scope: 'expense',
      subcategories: [
        DefaultSubcategoryDefinition(
          name: 'Donaciones',
          iconKey: 'volunteer_activism',
        ),
        DefaultSubcategoryDefinition(name: 'Imprevistos', iconKey: 'warning'),
        DefaultSubcategoryDefinition(name: 'Varios', iconKey: 'more_horiz'),
      ],
    ),
  ];

  static const List<DefaultCategoryDefinition> saving = [
    DefaultCategoryDefinition(
      name: 'Ahorro general',
      iconKey: 'savings',
      scope: 'saving',
    ),
    DefaultCategoryDefinition(
      name: 'Fondo de emergencia',
      iconKey: 'shield',
      scope: 'saving',
    ),
    DefaultCategoryDefinition(
      name: 'Viaje',
      iconKey: 'flight',
      scope: 'saving',
    ),
  ];

  static const List<DefaultCategoryDefinition> all = [
    ...income,
    ...expense,
    ...saving,
  ];
}
