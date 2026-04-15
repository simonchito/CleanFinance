class IconOption {
  const IconOption({
    required this.key,
    required this.label,
  });

  final String key;
  final String label;
}

abstract final class IconOptions {
  static const String defaultKey = 'category';

  static const List<IconOption> all = [
    IconOption(key: 'category', label: 'General'),
    IconOption(key: 'home', label: 'Hogar'),
    IconOption(key: 'bolt', label: 'Servicios'),
    IconOption(key: 'restaurant', label: 'Comida'),
    IconOption(key: 'car', label: 'Transporte'),
    IconOption(key: 'health', label: 'Salud'),
    IconOption(key: 'education', label: 'Educación'),
    IconOption(key: 'shopping', label: 'Compras'),
    IconOption(key: 'entertainment', label: 'Ocio'),
    IconOption(key: 'finance', label: 'Finanzas'),
    IconOption(key: 'family', label: 'Familia'),
    IconOption(key: 'work', label: 'Trabajo'),
    IconOption(key: 'payments', label: 'Pagos'),
    IconOption(key: 'storefront', label: 'Ventas'),
    IconOption(key: 'savings', label: 'Ahorro'),
    IconOption(key: 'shield', label: 'Protección'),
    IconOption(key: 'flight', label: 'Viajes'),
    IconOption(key: 'palette', label: 'Decoración'),
    IconOption(key: 'kitchen', label: 'Cocina'),
    IconOption(key: 'receipt', label: 'Facturas'),
    IconOption(key: 'cleaning_services', label: 'Limpieza'),
    IconOption(key: 'build', label: 'Mantenimiento'),
    IconOption(key: 'chair', label: 'Muebles'),
    IconOption(key: 'handyman', label: 'Reparaciones'),
    IconOption(key: 'water_drop', label: 'Agua'),
    IconOption(key: 'tv', label: 'TV'),
    IconOption(key: 'local_fire_department', label: 'Gas'),
    IconOption(key: 'wifi', label: 'Internet'),
    IconOption(key: 'electric_bolt', label: 'Luz'),
    IconOption(key: 'cloud', label: 'Apps'),
    IconOption(key: 'play_circle', label: 'Streaming'),
    IconOption(key: 'phone', label: 'Teléfono'),
    IconOption(key: 'coffee', label: 'Cafetería'),
    IconOption(key: 'set_meal', label: 'Carnicería'),
    IconOption(key: 'delivery_dining', label: 'Delivery'),
    IconOption(key: 'bakery_dining', label: 'Panadería'),
    IconOption(key: 'restaurant_menu', label: 'Restaurantes'),
    IconOption(key: 'shopping_cart', label: 'Supermercado'),
    IconOption(key: 'eco', label: 'Verdulería'),
    IconOption(key: 'local_gas_station', label: 'Combustible'),
    IconOption(key: 'local_parking', label: 'Estacionamiento'),
    IconOption(key: 'toll', label: 'Peajes'),
    IconOption(key: 'security', label: 'Seguro'),
    IconOption(key: 'local_taxi', label: 'Taxi'),
    IconOption(key: 'directions_bus', label: 'Colectivo'),
    IconOption(key: 'emoji_transportation', label: 'Movilidad'),
    IconOption(key: 'medical_services', label: 'Consultas'),
    IconOption(key: 'science', label: 'Estudios'),
    IconOption(key: 'medication', label: 'Medicamentos'),
    IconOption(key: 'health_and_safety', label: 'Prepaga'),
    IconOption(key: 'mood', label: 'Odontología'),
    IconOption(key: 'visibility', label: 'Óptica'),
    IconOption(key: 'menu_book', label: 'Cursos'),
    IconOption(key: 'book', label: 'Libros'),
    IconOption(key: 'edit', label: 'Materiales'),
    IconOption(key: 'school', label: 'Capacitación'),
    IconOption(key: 'hiking', label: 'Calzado'),
    IconOption(key: 'language', label: 'Online'),
    IconOption(key: 'card_giftcard', label: 'Regalos'),
    IconOption(key: 'checkroom', label: 'Ropa'),
    IconOption(key: 'devices', label: 'Tecnología'),
    IconOption(key: 'movie', label: 'Cine'),
    IconOption(key: 'event', label: 'Eventos'),
    IconOption(key: 'sports_esports', label: 'Juegos'),
    IconOption(key: 'nightlife', label: 'Salidas'),
    IconOption(key: 'account_balance_wallet', label: 'Comisiones'),
    IconOption(key: 'receipt_long', label: 'Impuestos'),
    IconOption(key: 'percent', label: 'Intereses'),
    IconOption(key: 'business', label: 'Monotributo'),
    IconOption(key: 'credit_card', label: 'Tarjetas'),
    IconOption(key: 'self_improvement', label: 'Personal'),
    IconOption(key: 'child_care', label: 'Guardería'),
    IconOption(key: 'child_friendly', label: 'Hijos'),
    IconOption(key: 'pets', label: 'Mascotas'),
    IconOption(key: 'lunch_dining', label: 'Comidas'),
    IconOption(key: 'commute', label: 'Traslados'),
    IconOption(key: 'volunteer_activism', label: 'Donaciones'),
    IconOption(key: 'warning', label: 'Imprevistos'),
    IconOption(key: 'more_horiz', label: 'Varios'),
  ];

  static final Map<String, String> _labelsByKey = {
    for (final option in all) option.key: option.label,
  };

  static bool isSupported(String? key) {
    if (key == null) {
      return false;
    }
    return _labelsByKey.containsKey(key);
  }

  static String normalize(String? key) {
    if (isSupported(key)) {
      return key!;
    }
    return defaultKey;
  }

  static String labelFor(String? key) {
    return _labelsByKey[normalize(key)] ?? _labelsByKey[defaultKey]!;
  }
}
