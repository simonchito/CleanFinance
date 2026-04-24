import '../../../../app/app_strings.dart';

class DefaultCategoryNameLocalizer {
  const DefaultCategoryNameLocalizer._();

  static String localize(String name, AppStrings strings) {
    if (!strings.isEnglish) {
      return name;
    }
    return _esToEn[_normalize(name)] ?? name;
  }

  static final Map<String, String> _esToEn = {
    _normalize('Sueldo'): 'Salary',
    _normalize('Freelance'): 'Freelance',
    _normalize('Venta'): 'Sale',
    _normalize('Hogar'): 'Home',
    _normalize('Servicios'): 'Services',
    _normalize('Alimentos'): 'Food',
    _normalize('Alimentación'): 'Food',
    _normalize('Transporte'): 'Transport',
    _normalize('Salud'): 'Health',
    _normalize('Educación'): 'Education',
    _normalize('Compras'): 'Shopping',
    _normalize('Ocio'): 'Leisure',
    _normalize('Finanzas'): 'Finance',
    _normalize('Familia'): 'Family',
    _normalize('Trabajo'): 'Work',
    _normalize('Otros'): 'Other',
    _normalize('Ahorro general'): 'General savings',
    _normalize('Fondo de emergencia'): 'Emergency fund',
    _normalize('Viaje'): 'Travel',
    _normalize('Alquiler'): 'Rent',
    _normalize('Decoración'): 'Decor',
    _normalize('Electrodomésticos'): 'Appliances',
    _normalize('Expensas'): 'Condo fees',
    _normalize('Limpieza'): 'Cleaning',
    _normalize('Mantenimiento'): 'Maintenance',
    _normalize('Mantenimiento del vehículo'): 'Vehicle maintenance',
    _normalize('Muebles'): 'Furniture',
    _normalize('Reparaciones'): 'Repairs',
    _normalize('Agua'): 'Water',
    _normalize('Cable / TV'): 'Cable / TV',
    _normalize('Gas'): 'Gas',
    _normalize('Internet'): 'Internet',
    _normalize('Luz'): 'Electricity',
    _normalize('Nube / Apps'): 'Cloud / Apps',
    _normalize('Streaming'): 'Streaming',
    _normalize('Teléfono'): 'Phone',
    _normalize('Cafetería'): 'Coffee shop',
    _normalize('Carnicería'): 'Butcher',
    _normalize('Delivery'): 'Delivery',
    _normalize('Panadería'): 'Bakery',
    _normalize('Restaurantes'): 'Restaurants',
    _normalize('Supermercado'): 'Supermarket',
    _normalize('Verdulería'): 'Produce store',
    _normalize('Combustible'): 'Fuel',
    _normalize('Estacionamiento'): 'Parking',
    _normalize('Peajes'): 'Tolls',
    _normalize('Seguro del auto'): 'Car insurance',
    _normalize('Taxi / Remis'): 'Taxi / Cab',
    _normalize('Transporte público'): 'Public transport',
    _normalize('Uber / Cabify'): 'Uber / Cabify',
    _normalize('Consultas médicas'): 'Medical appointments',
    _normalize('Estudios'): 'Medical tests',
    _normalize('Medicamentos'): 'Medication',
    _normalize('Obra social / Prepaga'): 'Health insurance',
    _normalize('Odontología'): 'Dentistry',
    _normalize('Óptica'): 'Optical',
    _normalize('Cursos'): 'Courses',
    _normalize('Cuotas'): 'Tuition',
    _normalize('Libros'): 'Books',
    _normalize('Materiales'): 'Supplies',
    _normalize('Suscripciones educativas'): 'Educational subscriptions',
    _normalize('Calzado'): 'Footwear',
    _normalize('Compras online'): 'Online shopping',
    _normalize('Regalos'): 'Gifts',
    _normalize('Ropa'): 'Clothing',
    _normalize('Tecnología'): 'Technology',
    _normalize('Cine'): 'Cinema',
    _normalize('Eventos'): 'Events',
    _normalize('Hobbies'): 'Hobbies',
    _normalize('Juegos'): 'Games',
    _normalize('Salidas'): 'Going out',
    _normalize('Vacaciones'): 'Holidays',
    _normalize('Comisiones bancarias'): 'Bank fees',
    _normalize('Impuestos'): 'Taxes',
    _normalize('Intereses'): 'Interest',
    _normalize('Monotributo / Autónomos'): 'Self-employed taxes',
    _normalize('Tarjetas de crédito'): 'Credit cards',
    _normalize('Cuidado personal'): 'Personal care',
    _normalize('Guardería / Colegio'): 'Daycare / School',
    _normalize('Hijos'): 'Children',
    _normalize('Mascotas'): 'Pets',
    _normalize('Capacitación'): 'Training',
    _normalize('Comidas laborales'): 'Work meals',
    _normalize('Herramientas'): 'Tools',
    _normalize('Transporte laboral'): 'Work transport',
    _normalize('Donaciones'): 'Donations',
    _normalize('Imprevistos'): 'Unexpected expenses',
    _normalize('Varios'): 'Miscellaneous',
  };

  static String _normalize(String value) {
    final lower = value.trim().toLowerCase();
    final buffer = StringBuffer();
    for (final rune in lower.runes) {
      buffer.write(_replacementByRune[rune] ?? String.fromCharCode(rune));
    }
    return buffer.toString().replaceAll(RegExp(r'\s+'), ' ');
  }

  static const Map<int, String> _replacementByRune = {
    225: 'a', // á
    233: 'e', // é
    237: 'i', // í
    243: 'o', // ó
    250: 'u', // ú
    252: 'u', // ü
    241: 'n', // ñ
  };
}
