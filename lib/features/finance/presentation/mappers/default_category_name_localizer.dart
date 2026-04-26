import '../../../../app/app_strings.dart';

class DefaultCategoryNameLocalizer {
  const DefaultCategoryNameLocalizer._();

  static String localize(String name, AppStrings strings) {
    final key = _translationKeysByName[_normalize(name)];
    if (key == null) {
      return name;
    }
    return strings.t(key);
  }

  static final Map<String, String> _translationKeysByName = {
    _normalize('Sueldo'): 'defaultCategoryNameSueldo',
    _normalize('Freelance'): 'defaultCategoryNameFreelance',
    _normalize('Venta'): 'defaultCategoryNameVenta',
    _normalize('Hogar'): 'defaultCategoryNameHogar',
    _normalize('Servicios'): 'defaultCategoryNameServicios',
    _normalize('Alimentos'): 'defaultCategoryNameAlimentos',
    _normalize('Alimentación'): 'defaultCategoryNameAlimentacion',
    _normalize('Transporte'): 'defaultCategoryNameTransporte',
    _normalize('Salud'): 'defaultCategoryNameSalud',
    _normalize('Educación'): 'defaultCategoryNameEducacion',
    _normalize('Compras'): 'defaultCategoryNameCompras',
    _normalize('Ocio'): 'defaultCategoryNameOcio',
    _normalize('Finanzas'): 'defaultCategoryNameFinanzas',
    _normalize('Familia'): 'defaultCategoryNameFamilia',
    _normalize('Trabajo'): 'defaultCategoryNameTrabajo',
    _normalize('Otros'): 'defaultCategoryNameOtros',
    _normalize('Ahorro general'): 'defaultCategoryNameAhorroGeneral',
    _normalize('Fondo de emergencia'): 'defaultCategoryNameFondoDeEmergencia',
    _normalize('Viaje'): 'defaultCategoryNameViaje',
    _normalize('Alquiler'): 'defaultCategoryNameAlquiler',
    _normalize('Decoración'): 'defaultCategoryNameDecoracion',
    _normalize('Electrodomésticos'): 'defaultCategoryNameElectrodomesticos',
    _normalize('Expensas'): 'defaultCategoryNameExpensas',
    _normalize('Limpieza'): 'defaultCategoryNameLimpieza',
    _normalize('Mantenimiento'): 'defaultCategoryNameMantenimiento',
    _normalize('Mantenimiento del vehículo'):
        'defaultCategoryNameMantenimientoDelVehiculo',
    _normalize('Muebles'): 'defaultCategoryNameMuebles',
    _normalize('Reparaciones'): 'defaultCategoryNameReparaciones',
    _normalize('Agua'): 'defaultCategoryNameAgua',
    _normalize('Cable / TV'): 'defaultCategoryNameCableTv',
    _normalize('Gas'): 'defaultCategoryNameGas',
    _normalize('Internet'): 'defaultCategoryNameInternet',
    _normalize('Luz'): 'defaultCategoryNameLuz',
    _normalize('Nube / Apps'): 'defaultCategoryNameNubeApps',
    _normalize('Streaming'): 'defaultCategoryNameStreaming',
    _normalize('Teléfono'): 'defaultCategoryNameTelefono',
    _normalize('Cafetería'): 'defaultCategoryNameCafeteria',
    _normalize('Carnicería'): 'defaultCategoryNameCarniceria',
    _normalize('Delivery'): 'defaultCategoryNameDelivery',
    _normalize('Panadería'): 'defaultCategoryNamePanaderia',
    _normalize('Restaurantes'): 'defaultCategoryNameRestaurantes',
    _normalize('Supermercado'): 'defaultCategoryNameSupermercado',
    _normalize('Verdulería'): 'defaultCategoryNameVerduleria',
    _normalize('Combustible'): 'defaultCategoryNameCombustible',
    _normalize('Estacionamiento'): 'defaultCategoryNameEstacionamiento',
    _normalize('Peajes'): 'defaultCategoryNamePeajes',
    _normalize('Seguro del auto'): 'defaultCategoryNameSeguroDelAuto',
    _normalize('Taxi / Remis'): 'defaultCategoryNameTaxiRemis',
    _normalize('Transporte público'): 'defaultCategoryNameTransportePublico',
    _normalize('Uber / Cabify'): 'defaultCategoryNameUberCabify',
    _normalize('Consultas médicas'): 'defaultCategoryNameConsultasMedicas',
    _normalize('Estudios'): 'defaultCategoryNameEstudios',
    _normalize('Medicamentos'): 'defaultCategoryNameMedicamentos',
    _normalize('Obra social / Prepaga'): 'defaultCategoryNameObraSocialPrepaga',
    _normalize('Odontología'): 'defaultCategoryNameOdontologia',
    _normalize('Óptica'): 'defaultCategoryNameOptica',
    _normalize('Cursos'): 'defaultCategoryNameCursos',
    _normalize('Cuotas'): 'defaultCategoryNameCuotas',
    _normalize('Libros'): 'defaultCategoryNameLibros',
    _normalize('Materiales'): 'defaultCategoryNameMateriales',
    _normalize('Suscripciones educativas'):
        'defaultCategoryNameSuscripcionesEducativas',
    _normalize('Calzado'): 'defaultCategoryNameCalzado',
    _normalize('Compras online'): 'defaultCategoryNameComprasOnline',
    _normalize('Regalos'): 'defaultCategoryNameRegalos',
    _normalize('Ropa'): 'defaultCategoryNameRopa',
    _normalize('Tecnología'): 'defaultCategoryNameTecnologia',
    _normalize('Cine'): 'defaultCategoryNameCine',
    _normalize('Eventos'): 'defaultCategoryNameEventos',
    _normalize('Hobbies'): 'defaultCategoryNameHobbies',
    _normalize('Juegos'): 'defaultCategoryNameJuegos',
    _normalize('Salidas'): 'defaultCategoryNameSalidas',
    _normalize('Vacaciones'): 'defaultCategoryNameVacaciones',
    _normalize('Comisiones bancarias'):
        'defaultCategoryNameComisionesBancarias',
    _normalize('Impuestos'): 'defaultCategoryNameImpuestos',
    _normalize('Intereses'): 'defaultCategoryNameIntereses',
    _normalize('Monotributo / Autónomos'):
        'defaultCategoryNameMonotributoAutonomos',
    _normalize('Tarjetas de crédito'): 'defaultCategoryNameTarjetasDeCredito',
    _normalize('Cuidado personal'): 'defaultCategoryNameCuidadoPersonal',
    _normalize('Guardería / Colegio'): 'defaultCategoryNameGuarderiaColegio',
    _normalize('Hijos'): 'defaultCategoryNameHijos',
    _normalize('Mascotas'): 'defaultCategoryNameMascotas',
    _normalize('Capacitación'): 'defaultCategoryNameCapacitacion',
    _normalize('Comidas laborales'): 'defaultCategoryNameComidasLaborales',
    _normalize('Herramientas'): 'defaultCategoryNameHerramientas',
    _normalize('Transporte laboral'): 'defaultCategoryNameTransporteLaboral',
    _normalize('Donaciones'): 'defaultCategoryNameDonaciones',
    _normalize('Imprevistos'): 'defaultCategoryNameImprevistos',
    _normalize('Varios'): 'defaultCategoryNameVarios',
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
