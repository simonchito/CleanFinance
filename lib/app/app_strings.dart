import 'package:flutter/widgets.dart';

class AppStrings {
  AppStrings._(this.languageCode);

  final String languageCode;

  bool get isEnglish => languageCode == 'en';

  static AppStrings of(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    return AppStrings._(code);
  }

  Locale get locale => Locale(languageCode);

  String get appName => 'CleanFinance';
  String get spanish => isEnglish ? 'Spanish' : 'Español';
  String get english => isEnglish ? 'English' : 'Inglés';
  String get settings => isEnglish ? 'Settings' : 'Ajustes';
  String get appearance => isEnglish ? 'Appearance' : 'Apariencia';
  String get security => isEnglish ? 'Security' : 'Seguridad';
  String get data => isEnglish ? 'Data' : 'Datos';
  String get language => isEnglish ? 'Language' : 'Idioma';
  String get paymentMethods => isEnglish ? 'Payment methods' : 'Medios de pago';
  String get managePaymentMethods =>
      isEnglish ? 'Manage payment methods' : 'Gestionar medios de pago';
  String get addPaymentMethod =>
      isEnglish ? 'Add payment method' : 'Agregar medio de pago';
  String get movementPaymentMethod =>
      isEnglish ? 'Payment method' : 'Medio de pago';
  String get noSubcategory =>
      isEnglish ? 'No subcategory' : 'Sin subcategoría';
  String get noGoal => isEnglish ? 'No goal' : 'Sin meta';
  String get category => isEnglish ? 'Category' : 'Categoría';
  String get subcategory => isEnglish ? 'Subcategory' : 'Subcategoría';
  String get amount => isEnglish ? 'Amount' : 'Monto';
  String get note => isEnglish ? 'Note' : 'Nota';
  String get type => isEnglish ? 'Type' : 'Tipo';
  String get date => isEnglish ? 'Date' : 'Fecha';
  String get savingGoal => isEnglish ? 'Savings goal' : 'Meta de ahorro';
  String get movement => isEnglish ? 'Movement' : 'Movimiento';
  String get newMovement =>
      isEnglish ? 'New movement' : 'Nuevo movimiento';
  String get editMovement =>
      isEnglish ? 'Edit movement' : 'Editar movimiento';
  String get saveMovement =>
      isEnglish ? 'Save movement' : 'Guardar movimiento';
  String get saveChanges =>
      isEnglish ? 'Save changes' : 'Guardar cambios';
  String get income => isEnglish ? 'Income' : 'Ingreso';
  String get expense => isEnglish ? 'Expense' : 'Gasto';
  String get saving => isEnglish ? 'Saving' : 'Ahorro';
  String get dashboard => isEnglish ? 'Home' : 'Inicio';
  String get movements => isEnglish ? 'Movements' : 'Movimientos';
  String get movementsTab => isEnglish ? 'Activity' : 'Movs.';
  String get savings => isEnglish ? 'Savings' : 'Ahorros';
  String get reports => isEnglish ? 'Reports' : 'Reportes';
  String get createGoal => isEnglish ? 'Create goal' : 'Crear meta';
  String get newGoal => isEnglish ? 'New goal' : 'Nueva meta';
  String get completed => isEnglish ? 'Completed' : 'Completadas';
  String get activeGoals => isEnglish ? 'Active goals' : 'Metas activas';
  String get achieved => isEnglish ? 'Achieved' : 'Lograda';
  String get contribute => isEnglish ? 'Contribute' : 'Aportar';
  String get unlimitedDate =>
      isEnglish ? 'No deadline' : 'Sin fecha límite';
  String get biometric =>
      isEnglish ? 'Biometric unlock' : 'Desbloqueo con biometría';
  String get exportBackup =>
      isEnglish ? 'Export backup' : 'Exportar backup';
  String get importBackup =>
      isEnglish ? 'Import backup' : 'Importar backup';
  String get manageCategories =>
      isEnglish ? 'Manage categories' : 'Gestionar categorías';
  String get lockNow => isEnglish ? 'Lock now' : 'Bloquear ahora';
  String get add => isEnglish ? 'Add' : 'Agregar';
  String get cancel => isEnglish ? 'Cancel' : 'Cancelar';
  String get save => isEnglish ? 'Save' : 'Guardar';
  String get all => isEnglish ? 'All' : 'Todos';
  String get from => isEnglish ? 'From' : 'Desde';
  String get to => isEnglish ? 'To' : 'Hasta';
  String get clear => isEnglish ? 'Clear' : 'Limpiar';
  String get apply => isEnglish ? 'Apply' : 'Aplicar';
  String get filters => isEnglish ? 'Filters' : 'Filtros';
  String get searchByNote =>
      isEnglish ? 'Search by note or reference' : 'Buscar por nota o referencia';
  String get setupTitle =>
      isEnglish ? 'Your money, clear and under control' : 'Tu dinero, claro y bajo control';
  String get unlockTitle =>
      isEnglish ? 'Welcome back' : 'Bienvenido otra vez';
  String get forgotPin =>
      isEnglish ? 'I forgot my PIN' : 'Olvidé mi PIN';
  String get recoverAccess =>
      isEnglish ? 'Recover access' : 'Recuperar acceso';
  String get birthDate =>
      isEnglish ? 'Birth date' : 'Fecha de nacimiento';
  String get documentId =>
      isEnglish ? 'Personal document' : 'Documento personal';
}
