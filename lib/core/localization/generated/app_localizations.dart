import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt')
  ];

  /// No description provided for @appName.
  ///
  /// In es, this message translates to:
  /// **'CleanFinance'**
  String get appName;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @useDeviceLanguage.
  ///
  /// In es, this message translates to:
  /// **'Usar idioma del dispositivo'**
  String get useDeviceLanguage;

  /// No description provided for @spanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @english.
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get english;

  /// No description provided for @dashboard.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get dashboard;

  /// No description provided for @movements.
  ///
  /// In es, this message translates to:
  /// **'Movimientos'**
  String get movements;

  /// No description provided for @savings.
  ///
  /// In es, this message translates to:
  /// **'Ahorros'**
  String get savings;

  /// No description provided for @reports.
  ///
  /// In es, this message translates to:
  /// **'Reportes'**
  String get reports;

  /// No description provided for @income.
  ///
  /// In es, this message translates to:
  /// **'Ingreso'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In es, this message translates to:
  /// **'Gasto'**
  String get expense;

  /// No description provided for @saving.
  ///
  /// In es, this message translates to:
  /// **'Ahorro'**
  String get saving;

  /// No description provided for @category.
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get category;

  /// No description provided for @subcategory.
  ///
  /// In es, this message translates to:
  /// **'Subcategoría'**
  String get subcategory;

  /// No description provided for @savingGoal.
  ///
  /// In es, this message translates to:
  /// **'Meta de ahorro'**
  String get savingGoal;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @apply.
  ///
  /// In es, this message translates to:
  /// **'Aplicar'**
  String get apply;

  /// No description provided for @clear.
  ///
  /// In es, this message translates to:
  /// **'Limpiar'**
  String get clear;

  /// No description provided for @privacyPolicy.
  ///
  /// In es, this message translates to:
  /// **'Política de privacidad'**
  String get privacyPolicy;

  /// No description provided for @paymentMethods.
  ///
  /// In es, this message translates to:
  /// **'Medios de pago'**
  String get paymentMethods;

  /// No description provided for @managePaymentMethods.
  ///
  /// In es, this message translates to:
  /// **'Gestionar medios de pago'**
  String get managePaymentMethods;

  /// No description provided for @manageReminders.
  ///
  /// In es, this message translates to:
  /// **'Gestionar recordatorios'**
  String get manageReminders;

  /// No description provided for @addPaymentMethod.
  ///
  /// In es, this message translates to:
  /// **'Agregar medio de pago'**
  String get addPaymentMethod;

  /// No description provided for @movementPaymentMethod.
  ///
  /// In es, this message translates to:
  /// **'Medio de pago'**
  String get movementPaymentMethod;

  /// No description provided for @paymentMethodTransfer.
  ///
  /// In es, this message translates to:
  /// **'Transferencia'**
  String get paymentMethodTransfer;

  /// No description provided for @paymentMethodDebitCard.
  ///
  /// In es, this message translates to:
  /// **'Tarjeta débito'**
  String get paymentMethodDebitCard;

  /// No description provided for @paymentMethodCreditCard.
  ///
  /// In es, this message translates to:
  /// **'Tarjeta crédito'**
  String get paymentMethodCreditCard;

  /// No description provided for @paymentMethodUnspecified.
  ///
  /// In es, this message translates to:
  /// **'Sin definir'**
  String get paymentMethodUnspecified;

  /// No description provided for @monthlyReminder.
  ///
  /// In es, this message translates to:
  /// **'Recordatorio mensual'**
  String get monthlyReminder;

  /// No description provided for @monthlyReminderDescription.
  ///
  /// In es, this message translates to:
  /// **'Usalo para gastos mensuales recurrentes y verlos como pendientes hasta registrar el pago.'**
  String get monthlyReminderDescription;

  /// No description provided for @movementReminderTitle.
  ///
  /// In es, this message translates to:
  /// **'Recordarme este gasto todos los meses'**
  String get movementReminderTitle;

  /// No description provided for @movementReminderSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Te avisaremos cerca del día de este movimiento.'**
  String get movementReminderSubtitle;

  /// No description provided for @movementReminderActive.
  ///
  /// In es, this message translates to:
  /// **'Recordatorio activo'**
  String get movementReminderActive;

  /// No description provided for @movementReminderDisabled.
  ///
  /// In es, this message translates to:
  /// **'Recordatorio desactivado'**
  String get movementReminderDisabled;

  /// No description provided for @movementReminderMonthlyDay.
  ///
  /// In es, this message translates to:
  /// **'Día {day} de cada mes'**
  String movementReminderMonthlyDay(Object day);

  /// No description provided for @movementReminderSettingsHint.
  ///
  /// In es, this message translates to:
  /// **'Este recordatorio también se puede cambiar desde Ajustes.'**
  String get movementReminderSettingsHint;

  /// No description provided for @reminderDay.
  ///
  /// In es, this message translates to:
  /// **'Día de recordatorio'**
  String get reminderDay;

  /// No description provided for @pendingThisMonth.
  ///
  /// In es, this message translates to:
  /// **'Pendientes este mes'**
  String get pendingThisMonth;

  /// No description provided for @reminderRegisterPayment.
  ///
  /// In es, this message translates to:
  /// **'Registrar pago'**
  String get reminderRegisterPayment;

  /// No description provided for @reminderLastRegistered.
  ///
  /// In es, this message translates to:
  /// **'Último registro'**
  String get reminderLastRegistered;

  /// No description provided for @noSubcategory.
  ///
  /// In es, this message translates to:
  /// **'Sin subcategoría'**
  String get noSubcategory;

  /// No description provided for @newMovement.
  ///
  /// In es, this message translates to:
  /// **'Nuevo movimiento'**
  String get newMovement;

  /// No description provided for @editMovement.
  ///
  /// In es, this message translates to:
  /// **'Editar movimiento'**
  String get editMovement;

  /// No description provided for @saveMovement.
  ///
  /// In es, this message translates to:
  /// **'Guardar movimiento'**
  String get saveMovement;

  /// No description provided for @saveChanges.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get saveChanges;

  /// No description provided for @unlimitedDate.
  ///
  /// In es, this message translates to:
  /// **'Sin fecha límite'**
  String get unlimitedDate;

  /// No description provided for @biometric.
  ///
  /// In es, this message translates to:
  /// **'Desbloqueo con biometría'**
  String get biometric;

  /// No description provided for @exportBackup.
  ///
  /// In es, this message translates to:
  /// **'Exportar backup'**
  String get exportBackup;

  /// No description provided for @importBackup.
  ///
  /// In es, this message translates to:
  /// **'Importar backup'**
  String get importBackup;

  /// No description provided for @manageCategories.
  ///
  /// In es, this message translates to:
  /// **'Gestionar categorías'**
  String get manageCategories;

  /// No description provided for @noCategories.
  ///
  /// In es, this message translates to:
  /// **'No hay categorías.'**
  String get noCategories;

  /// No description provided for @mainCategory.
  ///
  /// In es, this message translates to:
  /// **'Categoría principal'**
  String get mainCategory;

  /// No description provided for @addSubcategory.
  ///
  /// In es, this message translates to:
  /// **'Agregar subcategoría'**
  String get addSubcategory;

  /// No description provided for @manageBudgets.
  ///
  /// In es, this message translates to:
  /// **'Gestionar presupuestos'**
  String get manageBudgets;

  /// No description provided for @amountPrivacy.
  ///
  /// In es, this message translates to:
  /// **'Privacidad de montos'**
  String get amountPrivacy;

  /// No description provided for @amountPrivacyDescription.
  ///
  /// In es, this message translates to:
  /// **'Ocultá saldos y resúmenes cuando usás la app en público.'**
  String get amountPrivacyDescription;

  /// No description provided for @newBudget.
  ///
  /// In es, this message translates to:
  /// **'Nuevo presupuesto'**
  String get newBudget;

  /// No description provided for @editBudget.
  ///
  /// In es, this message translates to:
  /// **'Editar presupuesto'**
  String get editBudget;

  /// No description provided for @monthlyLimit.
  ///
  /// In es, this message translates to:
  /// **'Límite mensual'**
  String get monthlyLimit;

  /// No description provided for @searchByNote.
  ///
  /// In es, this message translates to:
  /// **'Buscar por nota o referencia'**
  String get searchByNote;

  /// No description provided for @setupTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu dinero, claro y bajo control'**
  String get setupTitle;

  /// No description provided for @unlockTitle.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido otra vez'**
  String get unlockTitle;

  /// No description provided for @recoverAccess.
  ///
  /// In es, this message translates to:
  /// **'Recuperar acceso'**
  String get recoverAccess;

  /// No description provided for @documentId.
  ///
  /// In es, this message translates to:
  /// **'Documento personal'**
  String get documentId;

  /// No description provided for @paymentMethodQr.
  ///
  /// In es, this message translates to:
  /// **'QR'**
  String get paymentMethodQr;

  /// No description provided for @text.
  ///
  /// In es, this message translates to:
  /// **'Atención'**
  String get text;

  /// No description provided for @text2.
  ///
  /// In es, this message translates to:
  /// **'Descriptivo'**
  String get text2;

  /// No description provided for @text3.
  ///
  /// In es, this message translates to:
  /// **'Diagnóstico'**
  String get text3;

  /// No description provided for @text4.
  ///
  /// In es, this message translates to:
  /// **'Proyección'**
  String get text4;

  /// No description provided for @text5.
  ///
  /// In es, this message translates to:
  /// **'Acción'**
  String get text5;

  /// No description provided for @text6.
  ///
  /// In es, this message translates to:
  /// **'Metas'**
  String get text6;

  /// No description provided for @appearance.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get appearance;

  /// No description provided for @privacy.
  ///
  /// In es, this message translates to:
  /// **'Privacidad'**
  String get privacy;

  /// No description provided for @security.
  ///
  /// In es, this message translates to:
  /// **'Seguridad'**
  String get security;

  /// No description provided for @data.
  ///
  /// In es, this message translates to:
  /// **'Datos'**
  String get data;

  /// No description provided for @paymentMethodCash.
  ///
  /// In es, this message translates to:
  /// **'Efectivo'**
  String get paymentMethodCash;

  /// No description provided for @reminderDayPrefix.
  ///
  /// In es, this message translates to:
  /// **'Día'**
  String get reminderDayPrefix;

  /// No description provided for @noGoal.
  ///
  /// In es, this message translates to:
  /// **'Sin meta'**
  String get noGoal;

  /// No description provided for @amount.
  ///
  /// In es, this message translates to:
  /// **'Monto'**
  String get amount;

  /// No description provided for @note.
  ///
  /// In es, this message translates to:
  /// **'Nota'**
  String get note;

  /// No description provided for @type.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get type;

  /// No description provided for @date.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get date;

  /// No description provided for @movement.
  ///
  /// In es, this message translates to:
  /// **'Movimiento'**
  String get movement;

  /// No description provided for @movementsTab.
  ///
  /// In es, this message translates to:
  /// **'Movs.'**
  String get movementsTab;

  /// No description provided for @createGoal.
  ///
  /// In es, this message translates to:
  /// **'Crear meta'**
  String get createGoal;

  /// No description provided for @newGoal.
  ///
  /// In es, this message translates to:
  /// **'Nueva meta'**
  String get newGoal;

  /// No description provided for @editGoal.
  ///
  /// In es, this message translates to:
  /// **'Editar meta'**
  String get editGoal;

  /// No description provided for @completed.
  ///
  /// In es, this message translates to:
  /// **'Completadas'**
  String get completed;

  /// No description provided for @activeGoals.
  ///
  /// In es, this message translates to:
  /// **'Metas activas'**
  String get activeGoals;

  /// No description provided for @achieved.
  ///
  /// In es, this message translates to:
  /// **'Lograda'**
  String get achieved;

  /// No description provided for @contribute.
  ///
  /// In es, this message translates to:
  /// **'Aportar'**
  String get contribute;

  /// No description provided for @defaultCategory.
  ///
  /// In es, this message translates to:
  /// **'Predefinida'**
  String get defaultCategory;

  /// No description provided for @customCategory.
  ///
  /// In es, this message translates to:
  /// **'Personalizada'**
  String get customCategory;

  /// No description provided for @budgets.
  ///
  /// In es, this message translates to:
  /// **'Presupuestos'**
  String get budgets;

  /// No description provided for @showAmounts.
  ///
  /// In es, this message translates to:
  /// **'Mostrar montos'**
  String get showAmounts;

  /// No description provided for @hideAmounts.
  ///
  /// In es, this message translates to:
  /// **'Ocultar montos'**
  String get hideAmounts;

  /// No description provided for @spent.
  ///
  /// In es, this message translates to:
  /// **'Gastado'**
  String get spent;

  /// No description provided for @remaining.
  ///
  /// In es, this message translates to:
  /// **'Disponible'**
  String get remaining;

  /// No description provided for @lockNow.
  ///
  /// In es, this message translates to:
  /// **'Bloquear ahora'**
  String get lockNow;

  /// No description provided for @add.
  ///
  /// In es, this message translates to:
  /// **'Agregar'**
  String get add;

  /// No description provided for @all.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get all;

  /// No description provided for @from.
  ///
  /// In es, this message translates to:
  /// **'Desde'**
  String get from;

  /// No description provided for @to.
  ///
  /// In es, this message translates to:
  /// **'Hasta'**
  String get to;

  /// No description provided for @filters.
  ///
  /// In es, this message translates to:
  /// **'Filtros'**
  String get filters;

  /// No description provided for @forgotPin.
  ///
  /// In es, this message translates to:
  /// **'Olvidé mi PIN'**
  String get forgotPin;

  /// No description provided for @birthDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de nacimiento'**
  String get birthDate;

  /// No description provided for @todaviaNoHaySuficienteActividadEsteMes.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay suficiente actividad este mes para una proyección sólida.'**
  String get todaviaNoHaySuficienteActividadEsteMes;

  /// No description provided for @vasEnCaminoACerrarElMes.
  ///
  /// In es, this message translates to:
  /// **'Vas en camino a cerrar el mes con saldo positivo si mantenés este ritmo.'**
  String get vasEnCaminoACerrarElMes;

  /// No description provided for @tuRitmoActualPodriaDejarteConMuy.
  ///
  /// In es, this message translates to:
  /// **'Tu ritmo actual podría dejarte con muy poco margen al cierre del mes.'**
  String get tuRitmoActualPodriaDejarteConMuy;

  /// No description provided for @siElGastoSigueAEsteRitmo.
  ///
  /// In es, this message translates to:
  /// **'Si el gasto sigue a este ritmo, este mes podría cerrar en déficit.'**
  String get siElGastoSigueAEsteRitmo;

  /// No description provided for @muySaludable.
  ///
  /// In es, this message translates to:
  /// **'Muy saludable'**
  String get muySaludable;

  /// No description provided for @tuMesVieneEquilibradoYConBuen.
  ///
  /// In es, this message translates to:
  /// **'Tu mes viene equilibrado y con buen margen para absorber imprevistos.'**
  String get tuMesVieneEquilibradoYConBuen;

  /// No description provided for @tusNumerosEstanBastanteControladosConAlgunos.
  ///
  /// In es, this message translates to:
  /// **'Tus números están bastante controlados, con algunos puntos para seguir de cerca.'**
  String get tusNumerosEstanBastanteControladosConAlgunos;

  /// No description provided for @tuFlujoSigueFuncionandoPeroConvieneAjustar.
  ///
  /// In es, this message translates to:
  /// **'Tu flujo sigue funcionando, pero conviene ajustar antes de que el mes se ponga más justo.'**
  String get tuFlujoSigueFuncionandoPeroConvieneAjustar;

  /// No description provided for @elRitmoActualPuedeDejarteSinMargen.
  ///
  /// In es, this message translates to:
  /// **'El ritmo actual puede dejarte sin margen antes de cerrar el mes.'**
  String get elRitmoActualPuedeDejarteSinMargen;

  /// No description provided for @masDeLoQueEntra.
  ///
  /// In es, this message translates to:
  /// **'Más de lo que entra'**
  String get masDeLoQueEntra;

  /// No description provided for @mesConMargen.
  ///
  /// In es, this message translates to:
  /// **'Mes con margen'**
  String get mesConMargen;

  /// No description provided for @categoriaDominante.
  ///
  /// In es, this message translates to:
  /// **'Categoría dominante'**
  String get categoriaDominante;

  /// No description provided for @cambioBruscoDeGasto.
  ///
  /// In es, this message translates to:
  /// **'Cambio brusco de gasto'**
  String get cambioBruscoDeGasto;

  /// No description provided for @buenAjuste.
  ///
  /// In es, this message translates to:
  /// **'Buen ajuste'**
  String get buenAjuste;

  /// No description provided for @riesgoDeFinDeMes.
  ///
  /// In es, this message translates to:
  /// **'Riesgo de fin de mes'**
  String get riesgoDeFinDeMes;

  /// No description provided for @ritmoBajoControl.
  ///
  /// In es, this message translates to:
  /// **'Ritmo bajo control'**
  String get ritmoBajoControl;

  /// No description provided for @gastoAtipico.
  ///
  /// In es, this message translates to:
  /// **'Gasto atípico'**
  String get gastoAtipico;

  /// No description provided for @ahorroSaludable.
  ///
  /// In es, this message translates to:
  /// **'Ahorro saludable'**
  String get ahorroSaludable;

  /// No description provided for @sugerenciaSimple.
  ///
  /// In es, this message translates to:
  /// **'Sugerencia simple'**
  String get sugerenciaSimple;

  /// No description provided for @mesEnMejora.
  ///
  /// In es, this message translates to:
  /// **'Mes en mejora'**
  String get mesEnMejora;

  /// No description provided for @mesMasExigente.
  ///
  /// In es, this message translates to:
  /// **'Mes más exigente'**
  String get mesMasExigente;

  /// No description provided for @metaEncaminada.
  ///
  /// In es, this message translates to:
  /// **'Meta encaminada'**
  String get metaEncaminada;

  /// No description provided for @despuesDeGastarYAhorrarTodaviaTe.
  ///
  /// In es, this message translates to:
  /// **'Después de gastar y ahorrar, todavía te queda un margen positivo este mes.'**
  String get despuesDeGastarYAhorrarTodaviaTe;

  /// No description provided for @tuProyeccionDeGastoCierraDentroDel.
  ///
  /// In es, this message translates to:
  /// **'Tu proyección de gasto cierra dentro del margen disponible para este mes.'**
  String get tuProyeccionDeGastoCierraDentroDel;

  /// No description provided for @reservarAunqueSeaUn5AlCobrar.
  ///
  /// In es, this message translates to:
  /// **'Reservar aunque sea un 5% al cobrar puede darte más aire para fin de mes.'**
  String get reservarAunqueSeaUn5AlCobrar;

  /// No description provided for @tuResultadoMensualVieneMejorQueEl.
  ///
  /// In es, this message translates to:
  /// **'Tu resultado mensual viene mejor que el del período anterior.'**
  String get tuResultadoMensualVieneMejorQueEl;

  /// No description provided for @tuMargenBajoFrenteAlMesAnterior.
  ///
  /// In es, this message translates to:
  /// **'Tu margen bajó frente al mes anterior. Vale la pena revisar el ritmo.'**
  String get tuMargenBajoFrenteAlMesAnterior;

  /// No description provided for @actualizaTuRegistro.
  ///
  /// In es, this message translates to:
  /// **'Actualizá tu registro'**
  String get actualizaTuRegistro;

  /// No description provided for @registraUnMovimientoEnSegundos.
  ///
  /// In es, this message translates to:
  /// **'Registrá un movimiento en segundos'**
  String get registraUnMovimientoEnSegundos;

  /// No description provided for @usaLenguajeSimpleYDejaSoloLa.
  ///
  /// In es, this message translates to:
  /// **'Usá lenguaje simple y dejá solo la información necesaria.'**
  String get usaLenguajeSimpleYDejaSoloLa;

  /// No description provided for @elegiQueTipoDeMovimientoQueresRegistrar.
  ///
  /// In es, this message translates to:
  /// **'Elegí qué tipo de movimiento querés registrar.'**
  String get elegiQueTipoDeMovimientoQueresRegistrar;

  /// No description provided for @ingresaUnMontoValido.
  ///
  /// In es, this message translates to:
  /// **'Ingresá un monto válido.'**
  String get ingresaUnMontoValido;

  /// No description provided for @elegiUnaCategoria.
  ///
  /// In es, this message translates to:
  /// **'Elegí una categoría'**
  String get elegiUnaCategoria;

  /// No description provided for @elegiLaCategoriaPrincipal.
  ///
  /// In es, this message translates to:
  /// **'Elegí la categoría principal.'**
  String get elegiLaCategoriaPrincipal;

  /// No description provided for @subcategoriaOpcional.
  ///
  /// In es, this message translates to:
  /// **'Subcategoría (opcional)'**
  String get subcategoriaOpcional;

  /// No description provided for @siAplicaElegiUnDetalleMasEspecifico.
  ///
  /// In es, this message translates to:
  /// **'Si aplica, elegí un detalle más específico.'**
  String get siAplicaElegiUnDetalleMasEspecifico;

  /// No description provided for @vinculaElMovimientoConUnaDeTus.
  ///
  /// In es, this message translates to:
  /// **'Vinculá el movimiento con una de tus metas de ahorro.'**
  String get vinculaElMovimientoConUnaDeTus;

  /// No description provided for @siGuardasAhoraQuedaraEnAhorroGeneral.
  ///
  /// In es, this message translates to:
  /// **'Si guardás ahora, quedará en Ahorro general y podés crear una meta después.'**
  String get siGuardasAhoraQuedaraEnAhorroGeneral;

  /// No description provided for @tipSiElegisUnaMetaVasA.
  ///
  /// In es, this message translates to:
  /// **'Tip: si elegís una meta, vas a seguir el progreso más fácil en Ahorros.'**
  String get tipSiElegisUnaMetaVasA;

  /// No description provided for @elegiUnMedioDePago.
  ///
  /// In es, this message translates to:
  /// **'Elegí un medio de pago'**
  String get elegiUnMedioDePago;

  /// No description provided for @ejemploCompraSemanalOPagoDeServicio.
  ///
  /// In es, this message translates to:
  /// **'Ejemplo: compra semanal o pago de servicio'**
  String get ejemploCompraSemanalOPagoDeServicio;

  /// No description provided for @protegerBackup.
  ///
  /// In es, this message translates to:
  /// **'Proteger backup'**
  String get protegerBackup;

  /// No description provided for @agregaUnaContrasenaOpcionalSiLaDejas.
  ///
  /// In es, this message translates to:
  /// **'Agregá una contraseña opcional. Si la dejás vacía, el backup se exportará como JSON legible.'**
  String get agregaUnaContrasenaOpcionalSiLaDejas;

  /// No description provided for @backupLocalDeCleanfinance.
  ///
  /// In es, this message translates to:
  /// **'Backup local de CleanFinance'**
  String get backupLocalDeCleanfinance;

  /// No description provided for @estaAccionReemplazaraTusDatosLocalesActuales.
  ///
  /// In es, this message translates to:
  /// **'Esta acción reemplazará tus datos locales actuales. El archivo se validará antes de importar para no tocar tus datos si encuentra problemas.'**
  String get estaAccionReemplazaraTusDatosLocalesActuales;

  /// No description provided for @siEsteBackupFueProtegidoConContrasena.
  ///
  /// In es, this message translates to:
  /// **'Si este backup fue protegido con contraseña, ingresala ahora. Si es un JSON plano, dejala vacía.'**
  String get siEsteBackupFueProtegidoConContrasena;

  /// No description provided for @datosImportadosCorrectamente.
  ///
  /// In es, this message translates to:
  /// **'Datos importados correctamente.'**
  String get datosImportadosCorrectamente;

  /// No description provided for @borrarTodosLosDatos.
  ///
  /// In es, this message translates to:
  /// **'Borrar todos los datos'**
  String get borrarTodosLosDatos;

  /// No description provided for @estoEliminaraLaBaseLocalCompletaEl.
  ///
  /// In es, this message translates to:
  /// **'Esto eliminará la base local completa, el PIN, los datos de recuperación y las banderas de biometría, dejando la app como una instalación limpia.'**
  String get estoEliminaraLaBaseLocalCompletaEl;

  /// No description provided for @borrarTodo.
  ///
  /// In es, this message translates to:
  /// **'Borrar todo'**
  String get borrarTodo;

  /// No description provided for @seBorraronTodosLosDatosLocalesLa.
  ///
  /// In es, this message translates to:
  /// **'Se borraron todos los datos locales. La app quedó en estado de instalación limpia.'**
  String get seBorraronTodosLosDatosLocalesLa;

  /// No description provided for @contrasenaOpcional.
  ///
  /// In es, this message translates to:
  /// **'Contraseña (opcional)'**
  String get contrasenaOpcional;

  /// No description provided for @unaAppSimplePrivadaYClara.
  ///
  /// In es, this message translates to:
  /// **'Una app simple, privada y clara'**
  String get unaAppSimplePrivadaYClara;

  /// No description provided for @configuraLaExperienciaParaQueSeSienta.
  ///
  /// In es, this message translates to:
  /// **'Configurá la experiencia para que se sienta realmente tuya.'**
  String get configuraLaExperienciaParaQueSeSienta;

  /// No description provided for @manteneAccesoRapidoSinPerderPrivacidad.
  ///
  /// In es, this message translates to:
  /// **'Mantené acceso rápido sin perder privacidad.'**
  String get manteneAccesoRapidoSinPerderPrivacidad;

  /// No description provided for @usaHuellaOReconocimientoFacialSiEsta.
  ///
  /// In es, this message translates to:
  /// **'Usá huella o reconocimiento facial si está disponible.'**
  String get usaHuellaOReconocimientoFacialSiEsta;

  /// No description provided for @esteDispositivoNoTieneBiometriaDisponible.
  ///
  /// In es, this message translates to:
  /// **'Este dispositivo no tiene biometría disponible.'**
  String get esteDispositivoNoTieneBiometriaDisponible;

  /// No description provided for @bloqueoAutomatico.
  ///
  /// In es, this message translates to:
  /// **'Bloqueo automático'**
  String get bloqueoAutomatico;

  /// No description provided for @revisaQueGuardaCleanfinanceDeFormaLocal.
  ///
  /// In es, this message translates to:
  /// **'Revisá qué guarda CleanFinance de forma local, cómo funcionan los backups y qué datos nunca se envían a servidores.'**
  String get revisaQueGuardaCleanfinanceDeFormaLocal;

  /// No description provided for @seguirSistema.
  ///
  /// In es, this message translates to:
  /// **'Seguir sistema'**
  String get seguirSistema;

  /// No description provided for @recibiRecordatoriosMensualesEnEsteTelefono.
  ///
  /// In es, this message translates to:
  /// **'Recibí recordatorios mensuales en este teléfono.'**
  String get recibiRecordatoriosMensualesEnEsteTelefono;

  /// No description provided for @notificacionesDelSistema.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones del sistema'**
  String get notificacionesDelSistema;

  /// No description provided for @horaDeRecordatorio.
  ///
  /// In es, this message translates to:
  /// **'Hora de recordatorio'**
  String get horaDeRecordatorio;

  /// No description provided for @personalizaLasListasQueUsasTodosLos.
  ///
  /// In es, this message translates to:
  /// **'Personalizá las listas que usás todos los días para que cargar datos siga siendo rápido y claro.'**
  String get personalizaLasListasQueUsasTodosLos;

  /// No description provided for @tusDatosVivenEnTuDispositivoPodes.
  ///
  /// In es, this message translates to:
  /// **'Tus datos viven en tu dispositivo. Podés exportarlos o restaurarlos cuando quieras.'**
  String get tusDatosVivenEnTuDispositivoPodes;

  /// No description provided for @notaDeSeguridadLosBackupsLocalesPueden.
  ///
  /// In es, this message translates to:
  /// **'Nota de seguridad: los backups locales pueden exportarse como JSON plano. Ahora podés agregar una contraseña opcional, pero los datos guardados en SQLite dentro del dispositivo siguen sin cifrado de base.'**
  String get notaDeSeguridadLosBackupsLocalesPueden;

  /// No description provided for @privacidadPrimeroNoHayTrackingNoSe.
  ///
  /// In es, this message translates to:
  /// **'Privacidad primero: no hay tracking, no se suben datos financieros y todo queda bajo tu control local.'**
  String get privacidadPrimeroNoHayTrackingNoSe;

  /// No description provided for @noSePudieronCargarLosAjustes.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron cargar los ajustes'**
  String get noSePudieronCargarLosAjustes;

  /// No description provided for @revisandoPermiso.
  ///
  /// In es, this message translates to:
  /// **'Revisando permiso...'**
  String get revisandoPermiso;

  /// No description provided for @noSePudoRevisarElPermiso.
  ///
  /// In es, this message translates to:
  /// **'No se pudo revisar el permiso'**
  String get noSePudoRevisarElPermiso;

  /// No description provided for @notificacionesDesactivadas.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones desactivadas'**
  String get notificacionesDesactivadas;

  /// No description provided for @notificacionesActivadas.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones activadas'**
  String get notificacionesActivadas;

  /// No description provided for @permisoPendiente.
  ///
  /// In es, this message translates to:
  /// **'Permiso pendiente'**
  String get permisoPendiente;

  /// No description provided for @permisoDenegado.
  ///
  /// In es, this message translates to:
  /// **'Permiso denegado'**
  String get permisoDenegado;

  /// No description provided for @noDisponibleEnEstaPlataforma.
  ///
  /// In es, this message translates to:
  /// **'No disponible en esta plataforma'**
  String get noDisponibleEnEstaPlataforma;

  /// No description provided for @errorInesperado.
  ///
  /// In es, this message translates to:
  /// **'Error inesperado.'**
  String get errorInesperado;

  /// No description provided for @pinIncorrecto.
  ///
  /// In es, this message translates to:
  /// **'PIN incorrecto.'**
  String get pinIncorrecto;

  /// No description provided for @nuevoPin.
  ///
  /// In es, this message translates to:
  /// **'Nuevo PIN'**
  String get nuevoPin;

  /// No description provided for @confirmarPin.
  ///
  /// In es, this message translates to:
  /// **'Confirmar PIN'**
  String get confirmarPin;

  /// No description provided for @validando.
  ///
  /// In es, this message translates to:
  /// **'Validando...'**
  String get validando;

  /// No description provided for @empezar.
  ///
  /// In es, this message translates to:
  /// **'Empezar'**
  String get empezar;

  /// No description provided for @desbloquear.
  ///
  /// In es, this message translates to:
  /// **'Desbloquear'**
  String get desbloquear;

  /// No description provided for @eliminarPresupuesto.
  ///
  /// In es, this message translates to:
  /// **'Eliminar presupuesto'**
  String get eliminarPresupuesto;

  /// No description provided for @eliminar.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get eliminar;

  /// No description provided for @guardando.
  ///
  /// In es, this message translates to:
  /// **'Guardando...'**
  String get guardando;

  /// No description provided for @reintentar.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get reintentar;

  /// No description provided for @atencion.
  ///
  /// In es, this message translates to:
  /// **'Atención'**
  String get atencion;

  /// No description provided for @excedido.
  ///
  /// In es, this message translates to:
  /// **'Excedido'**
  String get excedido;

  /// No description provided for @normal.
  ///
  /// In es, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @bajo.
  ///
  /// In es, this message translates to:
  /// **'Bajo'**
  String get bajo;

  /// No description provided for @medio.
  ///
  /// In es, this message translates to:
  /// **'Medio'**
  String get medio;

  /// No description provided for @alto.
  ///
  /// In es, this message translates to:
  /// **'Alto'**
  String get alto;

  /// No description provided for @estable.
  ///
  /// In es, this message translates to:
  /// **'Estable'**
  String get estable;

  /// No description provided for @enRiesgo.
  ///
  /// In es, this message translates to:
  /// **'En riesgo'**
  String get enRiesgo;

  /// No description provided for @eliminarCategoria.
  ///
  /// In es, this message translates to:
  /// **'Eliminar categoría'**
  String get eliminarCategoria;

  /// No description provided for @nuevaCategoria.
  ///
  /// In es, this message translates to:
  /// **'Nueva categoría'**
  String get nuevaCategoria;

  /// No description provided for @editarCategoria.
  ///
  /// In es, this message translates to:
  /// **'Editar categoría'**
  String get editarCategoria;

  /// No description provided for @nombre.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get nombre;

  /// No description provided for @recomendaciones.
  ///
  /// In es, this message translates to:
  /// **'Recomendaciones'**
  String get recomendaciones;

  /// No description provided for @movimientosRecientes.
  ///
  /// In es, this message translates to:
  /// **'Movimientos recientes'**
  String get movimientosRecientes;

  /// No description provided for @recordatoriosDeGastos.
  ///
  /// In es, this message translates to:
  /// **'Recordatorios de gastos'**
  String get recordatoriosDeGastos;

  /// No description provided for @recordatoriosDeAhorro.
  ///
  /// In es, this message translates to:
  /// **'Recordatorios de ahorro'**
  String get recordatoriosDeAhorro;

  /// No description provided for @eliminarMovimiento.
  ///
  /// In es, this message translates to:
  /// **'Eliminar movimiento'**
  String get eliminarMovimiento;

  /// No description provided for @agregarMovimiento.
  ///
  /// In es, this message translates to:
  /// **'Agregar movimiento'**
  String get agregarMovimiento;

  /// No description provided for @evolucionMensual.
  ///
  /// In es, this message translates to:
  /// **'Evolución mensual'**
  String get evolucionMensual;

  /// No description provided for @ritmoDeGasto.
  ///
  /// In es, this message translates to:
  /// **'Ritmo de gasto'**
  String get ritmoDeGasto;

  /// No description provided for @proyeccion.
  ///
  /// In es, this message translates to:
  /// **'Proyección'**
  String get proyeccion;

  /// No description provided for @estado.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get estado;

  /// No description provided for @metasDeAhorro.
  ///
  /// In es, this message translates to:
  /// **'Metas de ahorro'**
  String get metasDeAhorro;

  /// No description provided for @lecturaRapida.
  ///
  /// In es, this message translates to:
  /// **'Lectura rápida'**
  String get lecturaRapida;

  /// No description provided for @enRango.
  ///
  /// In es, this message translates to:
  /// **'En rango'**
  String get enRango;

  /// No description provided for @atencion2.
  ///
  /// In es, this message translates to:
  /// **'Atención'**
  String get atencion2;

  /// No description provided for @riesgo.
  ///
  /// In es, this message translates to:
  /// **'Riesgo'**
  String get riesgo;

  /// No description provided for @nuevo.
  ///
  /// In es, this message translates to:
  /// **'Nuevo'**
  String get nuevo;

  /// No description provided for @sinEstimacionTodavia.
  ///
  /// In es, this message translates to:
  /// **'Sin estimación todavía'**
  String get sinEstimacionTodavia;

  /// No description provided for @nombreDeLaMeta.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la meta'**
  String get nombreDeLaMeta;

  /// No description provided for @montoObjetivo.
  ///
  /// In es, this message translates to:
  /// **'Monto objetivo'**
  String get montoObjetivo;

  /// No description provided for @guardarMeta.
  ///
  /// In es, this message translates to:
  /// **'Guardar meta'**
  String get guardarMeta;

  /// No description provided for @eliminarMeta.
  ///
  /// In es, this message translates to:
  /// **'Eliminar meta'**
  String get eliminarMeta;

  /// No description provided for @ahorroGeneral.
  ///
  /// In es, this message translates to:
  /// **'Ahorro general'**
  String get ahorroGeneral;

  /// No description provided for @objetivo.
  ///
  /// In es, this message translates to:
  /// **'Objetivo'**
  String get objetivo;

  /// No description provided for @advertenciaElArchivoNoEstaCifrado.
  ///
  /// In es, this message translates to:
  /// **'Advertencia: el archivo no está cifrado.'**
  String get advertenciaElArchivoNoEstaCifrado;

  /// No description provided for @oneMinute.
  ///
  /// In es, this message translates to:
  /// **'1 minuto'**
  String get oneMinute;

  /// No description provided for @fiveMinutes.
  ///
  /// In es, this message translates to:
  /// **'5 minutos'**
  String get fiveMinutes;

  /// No description provided for @fifteenMinutes.
  ///
  /// In es, this message translates to:
  /// **'15 minutos'**
  String get fifteenMinutes;

  /// No description provided for @thirtyMinutes.
  ///
  /// In es, this message translates to:
  /// **'30 minutos'**
  String get thirtyMinutes;

  /// No description provided for @tema.
  ///
  /// In es, this message translates to:
  /// **'Tema'**
  String get tema;

  /// No description provided for @claro.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get claro;

  /// No description provided for @oscuro.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get oscuro;

  /// No description provided for @moneda.
  ///
  /// In es, this message translates to:
  /// **'Moneda'**
  String get moneda;

  /// No description provided for @notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notificaciones;

  /// No description provided for @organizacion.
  ///
  /// In es, this message translates to:
  /// **'Organización'**
  String get organizacion;

  /// No description provided for @netoEstimado.
  ///
  /// In es, this message translates to:
  /// **'Neto estimado'**
  String get netoEstimado;

  /// No description provided for @icono.
  ///
  /// In es, this message translates to:
  /// **'Ícono'**
  String get icono;

  /// No description provided for @tocaParaCambiar.
  ///
  /// In es, this message translates to:
  /// **'Tocá para cambiar'**
  String get tocaParaCambiar;

  /// No description provided for @elegiUnIcono.
  ///
  /// In es, this message translates to:
  /// **'Elegí un ícono'**
  String get elegiUnIcono;

  /// No description provided for @seleccionar.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar'**
  String get seleccionar;

  /// No description provided for @total.
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @movementFormMissingCategory.
  ///
  /// In es, this message translates to:
  /// **'Seleccioná una categoría antes de guardar.'**
  String get movementFormMissingCategory;

  /// No description provided for @movementFormLoadCategoriesError.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron cargar categorías: {error}'**
  String movementFormLoadCategoriesError(Object error);

  /// No description provided for @financeInsightOvercommittedMessage.
  ///
  /// In es, this message translates to:
  /// **'Tus gastos y ahorros ya consumieron {percentage}% de tus ingresos del mes.'**
  String financeInsightOvercommittedMessage(Object percentage);

  /// No description provided for @financeInsightDominantCategoryMessage.
  ///
  /// In es, this message translates to:
  /// **'{categoryName} concentra {percentage}% de tus gastos del mes.'**
  String financeInsightDominantCategoryMessage(
      Object percentage, Object categoryName);

  /// No description provided for @financeInsightExpenseIncreaseMessage.
  ///
  /// In es, this message translates to:
  /// **'{categoryName} subió {percentage}% frente al mes anterior.'**
  String financeInsightExpenseIncreaseMessage(
      Object percentage, Object categoryName);

  /// No description provided for @financeInsightExpenseDecreaseMessage.
  ///
  /// In es, this message translates to:
  /// **'{categoryName} bajó {percentage}% frente al mes anterior.'**
  String financeInsightExpenseDecreaseMessage(
      Object percentage, Object categoryName);

  /// No description provided for @financeInsightEndOfMonthRiskMessage.
  ///
  /// In es, this message translates to:
  /// **'Si seguís con este ritmo, podrías cerrar con un margen {amount} por debajo de cero.'**
  String financeInsightEndOfMonthRiskMessage(Object amount);

  /// No description provided for @financeInsightAtypicalExpenseMessage.
  ///
  /// In es, this message translates to:
  /// **'Una sola compra representó {percentage}% de tus ingresos del mes.'**
  String financeInsightAtypicalExpenseMessage(Object percentage);

  /// No description provided for @financeInsightHealthySavingsMessage.
  ///
  /// In es, this message translates to:
  /// **'Ya separaste {percentage}% de tus ingresos del mes.'**
  String financeInsightHealthySavingsMessage(Object percentage);

  /// No description provided for @financeInsightGoalOnTrackMessage.
  ///
  /// In es, this message translates to:
  /// **'{goalName} ya va en {percentage}% y mantiene buen ritmo.'**
  String financeInsightGoalOnTrackMessage(Object percentage, Object goalName);

  /// No description provided for @authRecoveryDocumentExample.
  ///
  /// In es, this message translates to:
  /// **'Ejemplo: 12345678'**
  String get authRecoveryDocumentExample;

  /// No description provided for @authUseBiometrics.
  ///
  /// In es, this message translates to:
  /// **'Usar biometría'**
  String get authUseBiometrics;

  /// No description provided for @authUnlockWithPinOrBiometrics.
  ///
  /// In es, this message translates to:
  /// **'Entrá con tu PIN o usá biometría para acceder rápido a tus finanzas.'**
  String get authUnlockWithPinOrBiometrics;

  /// No description provided for @authWaitBeforeRetry.
  ///
  /// In es, this message translates to:
  /// **'Esperá {seconds}s para volver a intentar.'**
  String authWaitBeforeRetry(Object seconds);

  /// No description provided for @authBiometricsEnabledTip.
  ///
  /// In es, this message translates to:
  /// **'Tip: si activaste biometría, entrar te lleva un toque.'**
  String get authBiometricsEnabledTip;

  /// No description provided for @authBiometricsUnavailablePinProtected.
  ///
  /// In es, this message translates to:
  /// **'La biometría no está disponible en este dispositivo, pero tu PIN sigue protegido localmente.'**
  String get authBiometricsUnavailablePinProtected;

  /// No description provided for @estaCategoria.
  ///
  /// In es, this message translates to:
  /// **'Esta categoría'**
  String get estaCategoria;

  /// No description provided for @tuMeta.
  ///
  /// In es, this message translates to:
  /// **'Tu meta'**
  String get tuMeta;

  /// No description provided for @revisaTusDatosDeRecuperacionEIntenta.
  ///
  /// In es, this message translates to:
  /// **'Revisá tus datos de recuperación e intentá nuevamente.'**
  String get revisaTusDatosDeRecuperacionEIntenta;

  /// No description provided for @laBiometriaNoEstaDisponibleEnEste.
  ///
  /// In es, this message translates to:
  /// **'La biometría no está disponible en este dispositivo.'**
  String get laBiometriaNoEstaDisponibleEnEste;

  /// No description provided for @noSePudoUsarLaBiometriaConfigura.
  ///
  /// In es, this message translates to:
  /// **'No se pudo usar la biometría. Configurá huella/rostro y bloqueo de pantalla.'**
  String get noSePudoUsarLaBiometriaConfigura;

  /// No description provided for @noSePudoValidarLaBiometriaVerifica.
  ///
  /// In es, this message translates to:
  /// **'No se pudo validar la biometría. Verificá la configuración del dispositivo.'**
  String get noSePudoValidarLaBiometriaVerifica;

  /// No description provided for @noSePudoVerificarLaRecuperacionRevisa.
  ///
  /// In es, this message translates to:
  /// **'No se pudo verificar la recuperación. Revisá tus datos e intentá nuevamente.'**
  String get noSePudoVerificarLaRecuperacionRevisa;

  /// No description provided for @algunasValidacionesDeSeguridadNoPudieronInicializarse.
  ///
  /// In es, this message translates to:
  /// **'Algunas validaciones de seguridad no pudieron inicializarse. La app está en modo seguro.'**
  String get algunasValidacionesDeSeguridadNoPudieronInicializarse;

  /// No description provided for @completaAmbasRespuestasDeRecuperacion.
  ///
  /// In es, this message translates to:
  /// **'Completá ambas respuestas de recuperación.'**
  String get completaAmbasRespuestasDeRecuperacion;

  /// No description provided for @usaUnaFechaValidaYUnDocumento.
  ///
  /// In es, this message translates to:
  /// **'Usá una fecha válida y un documento con al menos 6 caracteres.'**
  String get usaUnaFechaValidaYUnDocumento;

  /// No description provided for @losPinNoCoinciden.
  ///
  /// In es, this message translates to:
  /// **'Los PIN no coinciden.'**
  String get losPinNoCoinciden;

  /// No description provided for @recuperaTuAccesoSinComplicarte.
  ///
  /// In es, this message translates to:
  /// **'Recuperá tu acceso sin complicarte'**
  String get recuperaTuAccesoSinComplicarte;

  /// No description provided for @respondeTusDosPreguntasPersonalesYElegi.
  ///
  /// In es, this message translates to:
  /// **'Respondé tus dos preguntas personales y elegí un PIN nuevo.'**
  String get respondeTusDosPreguntasPersonalesYElegi;

  /// No description provided for @laRecuperacionLocalEsMenosRobustaQue.
  ///
  /// In es, this message translates to:
  /// **'La recuperación local es menos robusta que tu PIN. Si alguien conoce estos datos y tiene el dispositivo, podría intentar restablecer el acceso.'**
  String get laRecuperacionLocalEsMenosRobustaQue;

  /// No description provided for @ejemplo10021996.
  ///
  /// In es, this message translates to:
  /// **'Ejemplo: 10/02/1996'**
  String get ejemplo10021996;

  /// No description provided for @activarHuellaParaProximosAccesos.
  ///
  /// In es, this message translates to:
  /// **'Activar huella para próximos accesos'**
  String get activarHuellaParaProximosAccesos;

  /// No description provided for @asiVasAPoderEntrarMasRapido.
  ///
  /// In es, this message translates to:
  /// **'Así vas a poder entrar más rápido después de recuperar tu cuenta.'**
  String get asiVasAPoderEntrarMasRapido;

  /// No description provided for @completaTusDosPreguntasDeRecuperacion.
  ///
  /// In es, this message translates to:
  /// **'Completá tus dos preguntas de recuperación.'**
  String get completaTusDosPreguntasDeRecuperacion;

  /// No description provided for @creaUnPinCortoParaProtegerTus.
  ///
  /// In es, this message translates to:
  /// **'Creá un PIN corto para proteger tus datos. Todo queda guardado solo en tu dispositivo.'**
  String get creaUnPinCortoParaProtegerTus;

  /// No description provided for @elegiTuPin.
  ///
  /// In es, this message translates to:
  /// **'Elegí tu PIN'**
  String get elegiTuPin;

  /// No description provided for @repetiTuPin.
  ///
  /// In es, this message translates to:
  /// **'Repetí tu PIN'**
  String get repetiTuPin;

  /// No description provided for @activarHuellaParaEntrarMasRapido.
  ///
  /// In es, this message translates to:
  /// **'Activar huella para entrar más rápido'**
  String get activarHuellaParaEntrarMasRapido;

  /// No description provided for @laAppTeLaVaAOfrecer.
  ///
  /// In es, this message translates to:
  /// **'La app te la va a ofrecer en el próximo desbloqueo.'**
  String get laAppTeLaVaAOfrecer;

  /// No description provided for @configurando.
  ///
  /// In es, this message translates to:
  /// **'Configurando...'**
  String get configurando;

  /// No description provided for @guardamosEstasRespuestasSoloParaAyudarteA.
  ///
  /// In es, this message translates to:
  /// **'Guardamos estas respuestas solo para ayudarte a recuperar el acceso si olvidás tu PIN.'**
  String get guardamosEstasRespuestasSoloParaAyudarteA;

  /// No description provided for @lasRespuestasDeRecuperacionSonMasDebiles.
  ///
  /// In es, this message translates to:
  /// **'Las respuestas de recuperación son más débiles que tu PIN. Usá datos reales, pero tené en cuenta que alguien que los conozca podría intentar restablecer el acceso en este dispositivo.'**
  String get lasRespuestasDeRecuperacionSonMasDebiles;

  /// No description provided for @estePresupuestoMensualSeEliminaraYEl.
  ///
  /// In es, this message translates to:
  /// **'Este presupuesto mensual se eliminará y el seguimiento de esta categoría se detendrá hasta que crees uno nuevo.'**
  String get estePresupuestoMensualSeEliminaraYEl;

  /// No description provided for @seleccionaUnaCategoria.
  ///
  /// In es, this message translates to:
  /// **'Seleccioná una categoría.'**
  String get seleccionaUnaCategoria;

  /// No description provided for @primeroCreaUnaCategoriaDeGasto.
  ///
  /// In es, this message translates to:
  /// **'Primero creá una categoría de gasto'**
  String get primeroCreaUnaCategoriaDeGasto;

  /// No description provided for @losPresupuestosSeCreanAPartirDe.
  ///
  /// In es, this message translates to:
  /// **'Los presupuestos se crean a partir de tus categorías de gasto existentes.'**
  String get losPresupuestosSeCreanAPartirDe;

  /// No description provided for @ajustaEstePresupuestoMensual.
  ///
  /// In es, this message translates to:
  /// **'Ajustá este presupuesto mensual'**
  String get ajustaEstePresupuestoMensual;

  /// No description provided for @creaUnPresupuestoMensualPorCategoria.
  ///
  /// In es, this message translates to:
  /// **'Creá un presupuesto mensual por categoría'**
  String get creaUnPresupuestoMensualPorCategoria;

  /// No description provided for @losPresupuestosSeGuardanLocalmenteYSe.
  ///
  /// In es, this message translates to:
  /// **'Los presupuestos se guardan localmente y se comparan con tus gastos del mes actual.'**
  String get losPresupuestosSeGuardanLocalmenteYSe;

  /// No description provided for @elegiLaCategoriaDeGastoParaEste.
  ///
  /// In es, this message translates to:
  /// **'Elegí la categoría de gasto para este presupuesto mensual.'**
  String get elegiLaCategoriaDeGastoParaEste;

  /// No description provided for @ingresaUnLimiteMensualValido.
  ///
  /// In es, this message translates to:
  /// **'Ingresá un límite mensual válido.'**
  String get ingresaUnLimiteMensualValido;

  /// No description provided for @presupuestosMensuales.
  ///
  /// In es, this message translates to:
  /// **'Presupuestos mensuales'**
  String get presupuestosMensuales;

  /// No description provided for @seguiComoVieneCadaCategoriaEsteMes.
  ///
  /// In es, this message translates to:
  /// **'Seguí cómo viene cada categoría este mes y ajustá los límites cuando lo necesites.'**
  String get seguiComoVieneCadaCategoriaEsteMes;

  /// No description provided for @creaTuPrimerPresupuesto.
  ///
  /// In es, this message translates to:
  /// **'Creá tu primer presupuesto'**
  String get creaTuPrimerPresupuesto;

  /// No description provided for @definiUnLimiteMensualParaUnaCategoria.
  ///
  /// In es, this message translates to:
  /// **'Definí un límite mensual para una categoría de gasto y vamos a seguir cuánto ya gastaste.'**
  String get definiUnLimiteMensualParaUnaCategoria;

  /// No description provided for @agregarPresupuesto.
  ///
  /// In es, this message translates to:
  /// **'Agregar presupuesto'**
  String get agregarPresupuesto;

  /// No description provided for @noSePudieronCargarLosPresupuestos.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron cargar los presupuestos'**
  String get noSePudieronCargarLosPresupuestos;

  /// No description provided for @eliminarSubcategoria.
  ///
  /// In es, this message translates to:
  /// **'Eliminar subcategoría'**
  String get eliminarSubcategoria;

  /// No description provided for @categoriaPadre.
  ///
  /// In es, this message translates to:
  /// **'Categoría padre'**
  String get categoriaPadre;

  /// No description provided for @sinCategoriaPadre.
  ///
  /// In es, this message translates to:
  /// **'Sin categoría padre'**
  String get sinCategoriaPadre;

  /// No description provided for @elegiUnaCategoriaPrincipalSoloSiQueres.
  ///
  /// In es, this message translates to:
  /// **'Elegí una categoría principal solo si querés crear una subcategoría.'**
  String get elegiUnaCategoriaPrincipalSoloSiQueres;

  /// No description provided for @usaEstaSubcategoriaParaServiciosOGastos.
  ///
  /// In es, this message translates to:
  /// **'Usá esta subcategoría para servicios o gastos recurrentes.'**
  String get usaEstaSubcategoriaParaServiciosOGastos;

  /// No description provided for @saldoActual.
  ///
  /// In es, this message translates to:
  /// **'Saldo actual'**
  String get saldoActual;

  /// No description provided for @ahorroTotal.
  ///
  /// In es, this message translates to:
  /// **'Ahorro total'**
  String get ahorroTotal;

  /// No description provided for @todaviaNoHayRecomendaciones.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay recomendaciones'**
  String get todaviaNoHayRecomendaciones;

  /// No description provided for @cargaAlgunosMovimientosParaVerAlertasY.
  ///
  /// In es, this message translates to:
  /// **'Cargá algunos movimientos para ver alertas y recomendaciones simples.'**
  String get cargaAlgunosMovimientosParaVerAlertasY;

  /// No description provided for @ingresosVsGastos.
  ///
  /// In es, this message translates to:
  /// **'Ingresos vs gastos'**
  String get ingresosVsGastos;

  /// No description provided for @unaLecturaRapidaDeComoVieneEl.
  ///
  /// In es, this message translates to:
  /// **'Una lectura rápida de cómo viene el mes.'**
  String get unaLecturaRapidaDeComoVieneEl;

  /// No description provided for @comparaTusIngresosYGastosDeLos.
  ///
  /// In es, this message translates to:
  /// **'Compará tus ingresos y gastos de los últimos 6 meses.'**
  String get comparaTusIngresosYGastosDeLos;

  /// No description provided for @gastosPorCategoria.
  ///
  /// In es, this message translates to:
  /// **'Gastos por categoría'**
  String get gastosPorCategoria;

  /// No description provided for @simpleClaroYFacilDeLeer.
  ///
  /// In es, this message translates to:
  /// **'Simple, claro y fácil de leer.'**
  String get simpleClaroYFacilDeLeer;

  /// No description provided for @todaviaNoHayGastosSuficientes.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay gastos suficientes'**
  String get todaviaNoHayGastosSuficientes;

  /// No description provided for @cuandoRegistresGastosVasAVerTus.
  ///
  /// In es, this message translates to:
  /// **'Cuando registres gastos, vas a ver tus categorías principales acá.'**
  String get cuandoRegistresGastosVasAVerTus;

  /// No description provided for @agregarGasto.
  ///
  /// In es, this message translates to:
  /// **'Agregar gasto'**
  String get agregarGasto;

  /// No description provided for @empezaConTuPrimerMovimiento.
  ///
  /// In es, this message translates to:
  /// **'Empezá con tu primer movimiento'**
  String get empezaConTuPrimerMovimiento;

  /// No description provided for @cargarGastosEIngresosTeVaA.
  ///
  /// In es, this message translates to:
  /// **'Cargar gastos e ingresos te va a permitir ver resumen, alertas y gráficos.'**
  String get cargarGastosEIngresosTeVaA;

  /// No description provided for @noPudimosCargarElInicio.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar el inicio'**
  String get noPudimosCargarElInicio;

  /// No description provided for @sinCategoria.
  ///
  /// In es, this message translates to:
  /// **'Sin categoría'**
  String get sinCategoria;

  /// No description provided for @revisaTusRecordatoriosMensualesActivos.
  ///
  /// In es, this message translates to:
  /// **'Revisá tus recordatorios mensuales activos'**
  String get revisaTusRecordatoriosMensualesActivos;

  /// No description provided for @losRecordatoriosDeGastoSalenDeSubcategorias.
  ///
  /// In es, this message translates to:
  /// **'Los recordatorios de gasto salen de subcategorías y los de ahorro salen de metas.'**
  String get losRecordatoriosDeGastoSalenDeSubcategorias;

  /// No description provided for @noHayRecordatoriosDeGastoActivos.
  ///
  /// In es, this message translates to:
  /// **'No hay recordatorios de gasto activos'**
  String get noHayRecordatoriosDeGastoActivos;

  /// No description provided for @activaRecordatoriosAlCrearOEditarUna.
  ///
  /// In es, this message translates to:
  /// **'Activá recordatorios al crear o editar una subcategoría de gastos.'**
  String get activaRecordatoriosAlCrearOEditarUna;

  /// No description provided for @noSePudieronCargarLosRecordatoriosDe.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron cargar los recordatorios de gasto'**
  String get noSePudieronCargarLosRecordatoriosDe;

  /// No description provided for @noHayRecordatoriosDeAhorroActivos.
  ///
  /// In es, this message translates to:
  /// **'No hay recordatorios de ahorro activos'**
  String get noHayRecordatoriosDeAhorroActivos;

  /// No description provided for @activaRecordatoriosAlCrearOEditarUna2.
  ///
  /// In es, this message translates to:
  /// **'Activá recordatorios al crear o editar una meta de ahorro.'**
  String get activaRecordatoriosAlCrearOEditarUna2;

  /// No description provided for @metaCompletada.
  ///
  /// In es, this message translates to:
  /// **'Meta completada'**
  String get metaCompletada;

  /// No description provided for @noSePudieronCargarLosRecordatoriosDe2.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron cargar los recordatorios de ahorro'**
  String get noSePudieronCargarLosRecordatoriosDe2;

  /// No description provided for @elegiElDiaDelMesParaEl.
  ///
  /// In es, this message translates to:
  /// **'Elegí el día del mes para el recordatorio.'**
  String get elegiElDiaDelMesParaEl;

  /// No description provided for @seEliminaraEsteMovimientoDeFormaPermanente.
  ///
  /// In es, this message translates to:
  /// **'Se eliminará este movimiento de forma permanente. Verificá los datos antes de continuar.'**
  String get seEliminaraEsteMovimientoDeFormaPermanente;

  /// No description provided for @elegiSoloLoNecesarioParaEncontrarRapido.
  ///
  /// In es, this message translates to:
  /// **'Elegí solo lo necesario para encontrar rápido lo que buscás.'**
  String get elegiSoloLoNecesarioParaEncontrarRapido;

  /// No description provided for @filtraPorUnaCategoriaPrincipalParaAcotar.
  ///
  /// In es, this message translates to:
  /// **'Filtrá por una categoría principal para acotar la búsqueda.'**
  String get filtraPorUnaCategoriaPrincipalParaAcotar;

  /// No description provided for @noEncontramosMovimientos.
  ///
  /// In es, this message translates to:
  /// **'No encontramos movimientos'**
  String get noEncontramosMovimientos;

  /// No description provided for @probaCambiandoElFiltroOAgregandoUn.
  ///
  /// In es, this message translates to:
  /// **'Probá cambiando el filtro o agregando un nuevo registro.'**
  String get probaCambiandoElFiltroOAgregandoUn;

  /// No description provided for @noSePudieronCargarLosMovimientos.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron cargar los movimientos'**
  String get noSePudieronCargarLosMovimientos;

  /// No description provided for @editarMedioDePago.
  ///
  /// In es, this message translates to:
  /// **'Editar medio de pago'**
  String get editarMedioDePago;

  /// No description provided for @ejemploQrTransferenciaOEfectivo.
  ///
  /// In es, this message translates to:
  /// **'Ejemplo: QR, transferencia o efectivo'**
  String get ejemploQrTransferenciaOEfectivo;

  /// No description provided for @elegiSoloLosMediosDePagoQue.
  ///
  /// In es, this message translates to:
  /// **'Elegí solo los medios de pago que realmente usás'**
  String get elegiSoloLosMediosDePagoQue;

  /// No description provided for @estasOpcionesVanAAparecerComoDesplegable.
  ///
  /// In es, this message translates to:
  /// **'Estas opciones van a aparecer como desplegable al cargar un movimiento.'**
  String get estasOpcionesVanAAparecerComoDesplegable;

  /// No description provided for @todaviaNoHayMediosDePago.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay medios de pago'**
  String get todaviaNoHayMediosDePago;

  /// No description provided for @agregaTusOpcionesHabitualesComoTransferenciaDebito.
  ///
  /// In es, this message translates to:
  /// **'Agregá tus opciones habituales como transferencia, débito o efectivo.'**
  String get agregaTusOpcionesHabitualesComoTransferenciaDebito;

  /// No description provided for @saludFinanciera.
  ///
  /// In es, this message translates to:
  /// **'Salud financiera'**
  String get saludFinanciera;

  /// No description provided for @cashflowMensual.
  ///
  /// In es, this message translates to:
  /// **'Cashflow mensual'**
  String get cashflowMensual;

  /// No description provided for @unResumenRapidoParaEntenderCuantoEntro.
  ///
  /// In es, this message translates to:
  /// **'Un resumen rápido para entender cuánto entró, cuánto salió y qué margen te quedó.'**
  String get unResumenRapidoParaEntenderCuantoEntro;

  /// No description provided for @saldoNeto.
  ///
  /// In es, this message translates to:
  /// **'Saldo neto'**
  String get saldoNeto;

  /// No description provided for @comparaComoVienenTusIngresosYGastos.
  ///
  /// In es, this message translates to:
  /// **'Compará cómo vienen tus ingresos y gastos en los últimos meses.'**
  String get comparaComoVienenTusIngresosYGastos;

  /// No description provided for @topCategoriasDelMes.
  ///
  /// In es, this message translates to:
  /// **'Top categorías del mes'**
  String get topCategoriasDelMes;

  /// No description provided for @vasAVerEnQueSeFue.
  ///
  /// In es, this message translates to:
  /// **'Vas a ver en qué se fue más dinero y cómo cambió frente al mes anterior.'**
  String get vasAVerEnQueSeFue;

  /// No description provided for @sinDatosTodavia.
  ///
  /// In es, this message translates to:
  /// **'Sin datos todavía'**
  String get sinDatosTodavia;

  /// No description provided for @cuandoRegistresGastosVasAVerAca.
  ///
  /// In es, this message translates to:
  /// **'Cuando registres gastos, vas a ver acá en qué categorías se fue más dinero.'**
  String get cuandoRegistresGastosVasAVerAca;

  /// No description provided for @teMuestraSiElGastoAcumuladoVa.
  ///
  /// In es, this message translates to:
  /// **'Te muestra si el gasto acumulado va dentro del margen esperable para este momento del mes.'**
  String get teMuestraSiElGastoAcumuladoVa;

  /// No description provided for @esperadoHoy.
  ///
  /// In es, this message translates to:
  /// **'Esperado hoy'**
  String get esperadoHoy;

  /// No description provided for @elRitmoActualEsExigenteParaTu.
  ///
  /// In es, this message translates to:
  /// **'El ritmo actual es exigente para tu margen disponible.'**
  String get elRitmoActualEsExigenteParaTu;

  /// No description provided for @vasCercaDelLimiteConvieneMirarCon.
  ///
  /// In es, this message translates to:
  /// **'Vas cerca del límite. Conviene mirar con atención la segunda mitad del mes.'**
  String get vasCercaDelLimiteConvieneMirarCon;

  /// No description provided for @tuGastoVieneEnUnaZonaSaludable.
  ///
  /// In es, this message translates to:
  /// **'Tu gasto viene en una zona saludable para este momento del mes.'**
  String get tuGastoVieneEnUnaZonaSaludable;

  /// No description provided for @seguimientoSimpleDelAvanceRitmoDeAporte.
  ///
  /// In es, this message translates to:
  /// **'Seguimiento simple del avance, ritmo de aporte y fecha estimada de cumplimiento.'**
  String get seguimientoSimpleDelAvanceRitmoDeAporte;

  /// No description provided for @todaviaNoHayMetasParaAnalizar.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay metas para analizar'**
  String get todaviaNoHayMetasParaAnalizar;

  /// No description provided for @cuandoTengasMetasYAportesVasA.
  ///
  /// In es, this message translates to:
  /// **'Cuando tengas metas y aportes, vas a ver acá el ritmo de avance.'**
  String get cuandoTengasMetasYAportesVasA;

  /// No description provided for @gastosPorMedioDePago.
  ///
  /// In es, this message translates to:
  /// **'Gastos por medio de pago'**
  String get gastosPorMedioDePago;

  /// No description provided for @teAyudaAVerQueMetodoEstas.
  ///
  /// In es, this message translates to:
  /// **'Te ayuda a ver qué método estás usando más en el mes.'**
  String get teAyudaAVerQueMetodoEstas;

  /// No description provided for @noSePudieronCargarLosReportes.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron cargar los reportes'**
  String get noSePudieronCargarLosReportes;

  /// No description provided for @elegiUnDiaDeRecordatorioValido.
  ///
  /// In es, this message translates to:
  /// **'Elegí un día de recordatorio válido.'**
  String get elegiUnDiaDeRecordatorioValido;

  /// No description provided for @definiUnaMetaSimpleYVisible.
  ///
  /// In es, this message translates to:
  /// **'Definí una meta simple y visible'**
  String get definiUnaMetaSimpleYVisible;

  /// No description provided for @nombreClaroMontoObjetivoYFechaOpcional.
  ///
  /// In es, this message translates to:
  /// **'Nombre claro, monto objetivo y fecha opcional. Nada más.'**
  String get nombreClaroMontoObjetivoYFechaOpcional;

  /// No description provided for @ingresaUnNombre.
  ///
  /// In es, this message translates to:
  /// **'Ingresá un nombre.'**
  String get ingresaUnNombre;

  /// No description provided for @agregarFechaObjetivo.
  ///
  /// In es, this message translates to:
  /// **'Agregar fecha objetivo'**
  String get agregarFechaObjetivo;

  /// No description provided for @teAyudaANoOlvidarteDelAporte.
  ///
  /// In es, this message translates to:
  /// **'Te ayuda a no olvidarte del aporte mensual para esta meta.'**
  String get teAyudaANoOlvidarteDelAporte;

  /// No description provided for @elegiElDiaDelMesEnEl.
  ///
  /// In es, this message translates to:
  /// **'Elegí el día del mes en el que querés recibir el recordatorio.'**
  String get elegiElDiaDelMesEnEl;

  /// No description provided for @todaviaNoTenesAhorroRegistrado.
  ///
  /// In es, this message translates to:
  /// **'Todavía no tenés ahorro registrado'**
  String get todaviaNoTenesAhorroRegistrado;

  /// No description provided for @creaUnaMetaORegistraUnAporte.
  ///
  /// In es, this message translates to:
  /// **'Creá una meta o registrá un aporte para empezar a ordenar tus ahorros.'**
  String get creaUnaMetaORegistraUnAporte;

  /// No description provided for @totalAhorrado.
  ///
  /// In es, this message translates to:
  /// **'Total ahorrado'**
  String get totalAhorrado;

  /// No description provided for @todoLoQueAhorrasteEstaOrganizadoEn.
  ///
  /// In es, this message translates to:
  /// **'Todo lo que ahorraste está organizado en metas.'**
  String get todoLoQueAhorrasteEstaOrganizadoEn;

  /// No description provided for @logradas.
  ///
  /// In es, this message translates to:
  /// **'Logradas'**
  String get logradas;

  /// No description provided for @metasLogradas.
  ///
  /// In es, this message translates to:
  /// **'Metas logradas'**
  String get metasLogradas;

  /// No description provided for @noPudimosCargarTusMetas.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar tus metas'**
  String get noPudimosCargarTusMetas;

  /// No description provided for @noPudimosCargarAhorros.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar ahorros'**
  String get noPudimosCargarAhorros;

  /// No description provided for @dineroGuardadoSinUnaMetaEspecifica.
  ///
  /// In es, this message translates to:
  /// **'Dinero guardado sin una meta específica.'**
  String get dineroGuardadoSinUnaMetaEspecifica;

  /// No description provided for @creaUnaMetaParaOrganizarMejorTus.
  ///
  /// In es, this message translates to:
  /// **'Creá una meta para organizar mejor tus ahorros.'**
  String get creaUnaMetaParaOrganizarMejorTus;

  /// No description provided for @excelenteYaAlcanzasteEstaMeta.
  ///
  /// In es, this message translates to:
  /// **'Excelente. Ya alcanzaste esta meta.'**
  String get excelenteYaAlcanzasteEstaMeta;

  /// No description provided for @proyeccionDeFinDeMes.
  ///
  /// In es, this message translates to:
  /// **'Proyeccion de fin de mes'**
  String get proyeccionDeFinDeMes;

  /// No description provided for @gastoProyectado.
  ///
  /// In es, this message translates to:
  /// **'Gasto proyectado'**
  String get gastoProyectado;

  /// No description provided for @usaUnaOpcionClaraParaReconocerMas.
  ///
  /// In es, this message translates to:
  /// **'Usá una opción clara para reconocer más rápido la categoría.'**
  String get usaUnaOpcionClaraParaReconocerMas;

  /// No description provided for @iconoSeleccionado.
  ///
  /// In es, this message translates to:
  /// **'Ícono seleccionado'**
  String get iconoSeleccionado;

  /// No description provided for @todaviaTeQuedaPagarOAhorrarPara.
  ///
  /// In es, this message translates to:
  /// **'Todavía te queda pagar o ahorrar para:'**
  String get todaviaTeQuedaPagarOAhorrarPara;

  /// No description provided for @pinLabel.
  ///
  /// In es, this message translates to:
  /// **'PIN'**
  String get pinLabel;

  /// No description provided for @authPinLengthInvalid.
  ///
  /// In es, this message translates to:
  /// **'El PIN debe tener {length} dígitos.'**
  String authPinLengthInvalid(Object length);

  /// No description provided for @authLockoutActive.
  ///
  /// In es, this message translates to:
  /// **'Demasiados intentos fallidos. Esperá {seconds} segundos antes de volver a intentar.'**
  String authLockoutActive(Object seconds);

  /// No description provided for @categoriesLoadError.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron cargar las categorías: {error}'**
  String categoriesLoadError(Object error);

  /// No description provided for @deleteSubcategoryMessage.
  ///
  /// In es, this message translates to:
  /// **'Se eliminará la subcategoría \"{name}\". Si tiene movimientos o dependencias, la app lo bloqueará antes de borrar.'**
  String deleteSubcategoryMessage(Object name);

  /// No description provided for @deleteCategoryMessage.
  ///
  /// In es, this message translates to:
  /// **'Se eliminará la categoría \"{name}\". Si tiene movimientos, subcategorías o presupuestos asociados, la app lo bloqueará antes de borrar.'**
  String deleteCategoryMessage(Object name);

  /// No description provided for @dashboardRemainingPositive.
  ///
  /// In es, this message translates to:
  /// **'Te quedan {amount} este mes.'**
  String dashboardRemainingPositive(Object amount);

  /// No description provided for @dashboardRemainingNegative.
  ///
  /// In es, this message translates to:
  /// **'Este mes vas {amount} por encima de tu margen.'**
  String dashboardRemainingNegative(Object amount);

  /// No description provided for @projectionAverageExpensePace.
  ///
  /// In es, this message translates to:
  /// **'Ritmo promedio: {amount}/día. Quedan {days} días.'**
  String projectionAverageExpensePace(Object amount, Object days);

  /// No description provided for @reportsShareOfTotal.
  ///
  /// In es, this message translates to:
  /// **'{percentage}% del total'**
  String reportsShareOfTotal(Object percentage);

  /// No description provided for @reportsPreviousMonth.
  ///
  /// In es, this message translates to:
  /// **'Mes anterior: {amount}'**
  String reportsPreviousMonth(Object amount);

  /// No description provided for @savingsGoalProgress.
  ///
  /// In es, this message translates to:
  /// **'{saved} de {target}'**
  String savingsGoalProgress(Object saved, Object target);

  /// No description provided for @goalAverageContribution.
  ///
  /// In es, this message translates to:
  /// **'Aporte promedio: {amount} por mes'**
  String goalAverageContribution(Object amount);

  /// No description provided for @goalContributionThisMonth.
  ///
  /// In es, this message translates to:
  /// **'Aporte este mes: {amount}'**
  String goalContributionThisMonth(Object amount);

  /// No description provided for @goalEstimatedDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha estimada: {date}'**
  String goalEstimatedDate(Object date);

  /// No description provided for @deleteSavingsGoalMessage.
  ///
  /// In es, this message translates to:
  /// **'Se eliminará la meta \"{name}\". Los aportes ya registrados seguirán existiendo, pero dejarán de estar vinculados a esta meta.'**
  String deleteSavingsGoalMessage(Object name);

  /// No description provided for @savingsGeneralIncluded.
  ///
  /// In es, this message translates to:
  /// **'Incluye {amount} en ahorro general.'**
  String savingsGeneralIncluded(Object amount);

  /// No description provided for @savingsContributionCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 aporte registrado.} other{{count} aportes registrados.}}'**
  String savingsContributionCount(num count);

  /// No description provided for @savingsContributionCountWithDate.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 aporte · último: {date}.} other{{count} aportes · último: {date}.}}'**
  String savingsContributionCountWithDate(num count, Object date);

  /// No description provided for @savingsGoalTargetDate.
  ///
  /// In es, this message translates to:
  /// **'Objetivo: {date}'**
  String savingsGoalTargetDate(Object date);

  /// No description provided for @savingsGoalRemaining.
  ///
  /// In es, this message translates to:
  /// **'Te falta {amount} para llegar.'**
  String savingsGoalRemaining(Object amount);

  /// No description provided for @privacySummaryTitle.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get privacySummaryTitle;

  /// No description provided for @privacySummaryBody1.
  ///
  /// In es, this message translates to:
  /// **'CleanFinance es una app de finanzas personales offline-first. No crea cuentas online, no sube tus registros financieros a servidores del desarrollador y no incluye SDKs de analítica, publicidad ni tracking.'**
  String get privacySummaryBody1;

  /// No description provided for @privacySummaryBody2.
  ///
  /// In es, this message translates to:
  /// **'Esta política dentro de la app resume el tratamiento de datos que puede confirmarse desde el código fuente actual. La URL pública de política de privacidad que se publique en Google Play debe reflejar este mismo contenido e incluir el contacto final del desarrollador.'**
  String get privacySummaryBody2;

  /// No description provided for @privacyStoredDataTitle.
  ///
  /// In es, this message translates to:
  /// **'Datos guardados en tu dispositivo'**
  String get privacyStoredDataTitle;

  /// No description provided for @privacyStoredDataBody1.
  ///
  /// In es, this message translates to:
  /// **'CleanFinance guarda en una base SQLite local las categorías, movimientos, metas de ahorro, presupuestos, medios de pago, idioma, tema, preferencia de ocultar montos, preferencia de bloqueo automático y preferencia de biometría.'**
  String get privacyStoredDataBody1;

  /// No description provided for @privacyStoredDataBody2.
  ///
  /// In es, this message translates to:
  /// **'La app también guarda en almacenamiento seguro de Android un PIN hasheado, respuestas de recuperación hasheadas para fecha de nacimiento y documento personal, y el estado de bloqueos temporales por intentos fallidos. Las respuestas de recuperación se piden solo para restablecer acceso en este mismo dispositivo si olvidás el PIN.'**
  String get privacyStoredDataBody2;

  /// No description provided for @privacyBiometricsTitle.
  ///
  /// In es, this message translates to:
  /// **'Biometría y permisos'**
  String get privacyBiometricsTitle;

  /// No description provided for @privacyBiometricsBody1.
  ///
  /// In es, this message translates to:
  /// **'Si activás el desbloqueo biométrico, CleanFinance le pide a Android que valide tu huella o rostro de forma local en el dispositivo. La app no recibe ni almacena tu plantilla biométrica.'**
  String get privacyBiometricsBody1;

  /// No description provided for @privacyBiometricsBody2.
  ///
  /// In es, this message translates to:
  /// **'La versión Android solicita el permiso biométrico necesario para mostrar el diálogo del sistema. El manifest principal no declara permisos de ubicación, contactos, cámara, micrófono, SMS, teléfono ni publicidad.'**
  String get privacyBiometricsBody2;

  /// No description provided for @privacyBackupsTitle.
  ///
  /// In es, this message translates to:
  /// **'Backups y compartición de archivos'**
  String get privacyBackupsTitle;

  /// No description provided for @privacyBackupsBody1.
  ///
  /// In es, this message translates to:
  /// **'Podés exportar tus datos manualmente desde Configuración. La exportación incluye tu base financiera local y la configuración. Si dejás la contraseña vacía, el archivo se guarda como JSON legible. Si ingresás una contraseña, el archivo se cifra antes de compartirlo o guardarlo.'**
  String get privacyBackupsBody1;

  /// No description provided for @privacyBackupsBody2.
  ///
  /// In es, this message translates to:
  /// **'Las importaciones son iniciadas por vos y reemplazan la base local actual solo después de validar el archivo. CleanFinance no sincroniza backups automáticamente con servidores del desarrollador.'**
  String get privacyBackupsBody2;

  /// No description provided for @privacySharingTitle.
  ///
  /// In es, this message translates to:
  /// **'Compartición, retención y borrado'**
  String get privacySharingTitle;

  /// No description provided for @privacySharingBody1.
  ///
  /// In es, this message translates to:
  /// **'La app no comparte datos personales ni financieros con el desarrollador ni con terceros. Los datos quedan en el dispositivo, salvo que vos decidas exportar y compartir un backup manualmente.'**
  String get privacySharingBody1;

  /// No description provided for @privacySharingBody2.
  ///
  /// In es, this message translates to:
  /// **'Tus datos permanecen en el dispositivo hasta que los borres, limpies la app, desinstales la app o uses la acción interna para borrar todos los datos locales. Borrar todos los datos elimina la base SQLite, las credenciales en almacenamiento seguro, los datos de recuperación y las banderas de biometría.'**
  String get privacySharingBody2;

  /// No description provided for @privacySecurityTitle.
  ///
  /// In es, this message translates to:
  /// **'Notas de seguridad'**
  String get privacySecurityTitle;

  /// No description provided for @privacySecurityBody1.
  ///
  /// In es, this message translates to:
  /// **'Los datos financieros guardados en SQLite son locales, pero no tienen cifrado a nivel de archivo de base de datos. Los datos sensibles de autenticación se guardan hasheados en almacenamiento seguro. Además, las builds release desactivan el backup en la nube de Android para reducir copias no deseadas de datos financieros locales.'**
  String get privacySecurityBody1;

  /// No description provided for @privacySecurityBody2.
  ///
  /// In es, this message translates to:
  /// **'Como la recuperación usa fecha de nacimiento y documento personal, alguien que conozca esos datos y tenga el dispositivo podría intentar un restablecimiento local. Por eso es importante proteger el equipo con bloqueo de pantalla de Android.'**
  String get privacySecurityBody2;

  /// No description provided for @privacyContactTitle.
  ///
  /// In es, this message translates to:
  /// **'Contacto de privacidad'**
  String get privacyContactTitle;

  /// No description provided for @privacyContactBody1.
  ///
  /// In es, this message translates to:
  /// **'El canal oficial de contacto de privacidad para la app publicada debe ser el correo de desarrollador que figure en la ficha de Google Play de CleanFinance. Antes de salir a producción, asegurate de que la política pública alojada incluya esa dirección exacta.'**
  String get privacyContactBody1;

  /// No description provided for @iconOptionCategory.
  ///
  /// In es, this message translates to:
  /// **'General'**
  String get iconOptionCategory;

  /// No description provided for @iconOptionHome.
  ///
  /// In es, this message translates to:
  /// **'Hogar'**
  String get iconOptionHome;

  /// No description provided for @iconOptionBolt.
  ///
  /// In es, this message translates to:
  /// **'Servicios'**
  String get iconOptionBolt;

  /// No description provided for @iconOptionRestaurant.
  ///
  /// In es, this message translates to:
  /// **'Comida'**
  String get iconOptionRestaurant;

  /// No description provided for @iconOptionCar.
  ///
  /// In es, this message translates to:
  /// **'Transporte'**
  String get iconOptionCar;

  /// No description provided for @iconOptionHealth.
  ///
  /// In es, this message translates to:
  /// **'Salud'**
  String get iconOptionHealth;

  /// No description provided for @iconOptionEducation.
  ///
  /// In es, this message translates to:
  /// **'Educación'**
  String get iconOptionEducation;

  /// No description provided for @iconOptionShopping.
  ///
  /// In es, this message translates to:
  /// **'Compras'**
  String get iconOptionShopping;

  /// No description provided for @iconOptionEntertainment.
  ///
  /// In es, this message translates to:
  /// **'Ocio'**
  String get iconOptionEntertainment;

  /// No description provided for @iconOptionFinance.
  ///
  /// In es, this message translates to:
  /// **'Finanzas'**
  String get iconOptionFinance;

  /// No description provided for @iconOptionFamily.
  ///
  /// In es, this message translates to:
  /// **'Familia'**
  String get iconOptionFamily;

  /// No description provided for @iconOptionWork.
  ///
  /// In es, this message translates to:
  /// **'Trabajo'**
  String get iconOptionWork;

  /// No description provided for @iconOptionPayments.
  ///
  /// In es, this message translates to:
  /// **'Pagos'**
  String get iconOptionPayments;

  /// No description provided for @iconOptionStorefront.
  ///
  /// In es, this message translates to:
  /// **'Ventas'**
  String get iconOptionStorefront;

  /// No description provided for @iconOptionSavings.
  ///
  /// In es, this message translates to:
  /// **'Ahorro'**
  String get iconOptionSavings;

  /// No description provided for @iconOptionShield.
  ///
  /// In es, this message translates to:
  /// **'Protección'**
  String get iconOptionShield;

  /// No description provided for @iconOptionFlight.
  ///
  /// In es, this message translates to:
  /// **'Viajes'**
  String get iconOptionFlight;

  /// No description provided for @iconOptionPalette.
  ///
  /// In es, this message translates to:
  /// **'Decoración'**
  String get iconOptionPalette;

  /// No description provided for @iconOptionKitchen.
  ///
  /// In es, this message translates to:
  /// **'Cocina'**
  String get iconOptionKitchen;

  /// No description provided for @iconOptionReceipt.
  ///
  /// In es, this message translates to:
  /// **'Facturas'**
  String get iconOptionReceipt;

  /// No description provided for @iconOptionCleaningServices.
  ///
  /// In es, this message translates to:
  /// **'Limpieza'**
  String get iconOptionCleaningServices;

  /// No description provided for @iconOptionBuild.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento'**
  String get iconOptionBuild;

  /// No description provided for @iconOptionChair.
  ///
  /// In es, this message translates to:
  /// **'Muebles'**
  String get iconOptionChair;

  /// No description provided for @iconOptionHandyman.
  ///
  /// In es, this message translates to:
  /// **'Reparaciones'**
  String get iconOptionHandyman;

  /// No description provided for @iconOptionWaterDrop.
  ///
  /// In es, this message translates to:
  /// **'Agua'**
  String get iconOptionWaterDrop;

  /// No description provided for @iconOptionTv.
  ///
  /// In es, this message translates to:
  /// **'TV'**
  String get iconOptionTv;

  /// No description provided for @iconOptionLocalFireDepartment.
  ///
  /// In es, this message translates to:
  /// **'Gas'**
  String get iconOptionLocalFireDepartment;

  /// No description provided for @iconOptionWifi.
  ///
  /// In es, this message translates to:
  /// **'Internet'**
  String get iconOptionWifi;

  /// No description provided for @iconOptionElectricBolt.
  ///
  /// In es, this message translates to:
  /// **'Luz'**
  String get iconOptionElectricBolt;

  /// No description provided for @iconOptionCloud.
  ///
  /// In es, this message translates to:
  /// **'Apps'**
  String get iconOptionCloud;

  /// No description provided for @iconOptionPlayCircle.
  ///
  /// In es, this message translates to:
  /// **'Streaming'**
  String get iconOptionPlayCircle;

  /// No description provided for @iconOptionPhone.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get iconOptionPhone;

  /// No description provided for @iconOptionCoffee.
  ///
  /// In es, this message translates to:
  /// **'Cafetería'**
  String get iconOptionCoffee;

  /// No description provided for @iconOptionSetMeal.
  ///
  /// In es, this message translates to:
  /// **'Carnicería'**
  String get iconOptionSetMeal;

  /// No description provided for @iconOptionDeliveryDining.
  ///
  /// In es, this message translates to:
  /// **'Delivery'**
  String get iconOptionDeliveryDining;

  /// No description provided for @iconOptionBakeryDining.
  ///
  /// In es, this message translates to:
  /// **'Panadería'**
  String get iconOptionBakeryDining;

  /// No description provided for @iconOptionRestaurantMenu.
  ///
  /// In es, this message translates to:
  /// **'Restaurantes'**
  String get iconOptionRestaurantMenu;

  /// No description provided for @iconOptionShoppingCart.
  ///
  /// In es, this message translates to:
  /// **'Supermercado'**
  String get iconOptionShoppingCart;

  /// No description provided for @iconOptionEco.
  ///
  /// In es, this message translates to:
  /// **'Verdulería'**
  String get iconOptionEco;

  /// No description provided for @iconOptionLocalGasStation.
  ///
  /// In es, this message translates to:
  /// **'Combustible'**
  String get iconOptionLocalGasStation;

  /// No description provided for @iconOptionLocalParking.
  ///
  /// In es, this message translates to:
  /// **'Estacionamiento'**
  String get iconOptionLocalParking;

  /// No description provided for @iconOptionToll.
  ///
  /// In es, this message translates to:
  /// **'Peajes'**
  String get iconOptionToll;

  /// No description provided for @iconOptionSecurity.
  ///
  /// In es, this message translates to:
  /// **'Seguro'**
  String get iconOptionSecurity;

  /// No description provided for @iconOptionLocalTaxi.
  ///
  /// In es, this message translates to:
  /// **'Taxi'**
  String get iconOptionLocalTaxi;

  /// No description provided for @iconOptionDirectionsBus.
  ///
  /// In es, this message translates to:
  /// **'Colectivo'**
  String get iconOptionDirectionsBus;

  /// No description provided for @iconOptionEmojiTransportation.
  ///
  /// In es, this message translates to:
  /// **'Movilidad'**
  String get iconOptionEmojiTransportation;

  /// No description provided for @iconOptionMedicalServices.
  ///
  /// In es, this message translates to:
  /// **'Consultas'**
  String get iconOptionMedicalServices;

  /// No description provided for @iconOptionScience.
  ///
  /// In es, this message translates to:
  /// **'Estudios'**
  String get iconOptionScience;

  /// No description provided for @iconOptionMedication.
  ///
  /// In es, this message translates to:
  /// **'Medicamentos'**
  String get iconOptionMedication;

  /// No description provided for @iconOptionHealthAndSafety.
  ///
  /// In es, this message translates to:
  /// **'Prepaga'**
  String get iconOptionHealthAndSafety;

  /// No description provided for @iconOptionMood.
  ///
  /// In es, this message translates to:
  /// **'Odontología'**
  String get iconOptionMood;

  /// No description provided for @iconOptionVisibility.
  ///
  /// In es, this message translates to:
  /// **'Óptica'**
  String get iconOptionVisibility;

  /// No description provided for @iconOptionMenuBook.
  ///
  /// In es, this message translates to:
  /// **'Cursos'**
  String get iconOptionMenuBook;

  /// No description provided for @iconOptionBook.
  ///
  /// In es, this message translates to:
  /// **'Libros'**
  String get iconOptionBook;

  /// No description provided for @iconOptionEdit.
  ///
  /// In es, this message translates to:
  /// **'Materiales'**
  String get iconOptionEdit;

  /// No description provided for @iconOptionSchool.
  ///
  /// In es, this message translates to:
  /// **'Capacitación'**
  String get iconOptionSchool;

  /// No description provided for @iconOptionHiking.
  ///
  /// In es, this message translates to:
  /// **'Calzado'**
  String get iconOptionHiking;

  /// No description provided for @iconOptionLanguage.
  ///
  /// In es, this message translates to:
  /// **'Online'**
  String get iconOptionLanguage;

  /// No description provided for @iconOptionCardGiftcard.
  ///
  /// In es, this message translates to:
  /// **'Regalos'**
  String get iconOptionCardGiftcard;

  /// No description provided for @iconOptionCheckroom.
  ///
  /// In es, this message translates to:
  /// **'Ropa'**
  String get iconOptionCheckroom;

  /// No description provided for @iconOptionDevices.
  ///
  /// In es, this message translates to:
  /// **'Tecnología'**
  String get iconOptionDevices;

  /// No description provided for @iconOptionMovie.
  ///
  /// In es, this message translates to:
  /// **'Cine'**
  String get iconOptionMovie;

  /// No description provided for @iconOptionEvent.
  ///
  /// In es, this message translates to:
  /// **'Eventos'**
  String get iconOptionEvent;

  /// No description provided for @iconOptionSportsEsports.
  ///
  /// In es, this message translates to:
  /// **'Juegos'**
  String get iconOptionSportsEsports;

  /// No description provided for @iconOptionNightlife.
  ///
  /// In es, this message translates to:
  /// **'Salidas'**
  String get iconOptionNightlife;

  /// No description provided for @iconOptionAccountBalanceWallet.
  ///
  /// In es, this message translates to:
  /// **'Comisiones'**
  String get iconOptionAccountBalanceWallet;

  /// No description provided for @iconOptionReceiptLong.
  ///
  /// In es, this message translates to:
  /// **'Impuestos'**
  String get iconOptionReceiptLong;

  /// No description provided for @iconOptionPercent.
  ///
  /// In es, this message translates to:
  /// **'Intereses'**
  String get iconOptionPercent;

  /// No description provided for @iconOptionBusiness.
  ///
  /// In es, this message translates to:
  /// **'Monotributo'**
  String get iconOptionBusiness;

  /// No description provided for @iconOptionCreditCard.
  ///
  /// In es, this message translates to:
  /// **'Tarjetas'**
  String get iconOptionCreditCard;

  /// No description provided for @iconOptionSelfImprovement.
  ///
  /// In es, this message translates to:
  /// **'Personal'**
  String get iconOptionSelfImprovement;

  /// No description provided for @iconOptionChildCare.
  ///
  /// In es, this message translates to:
  /// **'Guardería'**
  String get iconOptionChildCare;

  /// No description provided for @iconOptionChildFriendly.
  ///
  /// In es, this message translates to:
  /// **'Hijos'**
  String get iconOptionChildFriendly;

  /// No description provided for @iconOptionPets.
  ///
  /// In es, this message translates to:
  /// **'Mascotas'**
  String get iconOptionPets;

  /// No description provided for @iconOptionLunchDining.
  ///
  /// In es, this message translates to:
  /// **'Comidas'**
  String get iconOptionLunchDining;

  /// No description provided for @iconOptionCommute.
  ///
  /// In es, this message translates to:
  /// **'Traslados'**
  String get iconOptionCommute;

  /// No description provided for @iconOptionVolunteerActivism.
  ///
  /// In es, this message translates to:
  /// **'Donaciones'**
  String get iconOptionVolunteerActivism;

  /// No description provided for @iconOptionWarning.
  ///
  /// In es, this message translates to:
  /// **'Imprevistos'**
  String get iconOptionWarning;

  /// No description provided for @iconOptionMoreHoriz.
  ///
  /// In es, this message translates to:
  /// **'Varios'**
  String get iconOptionMoreHoriz;

  /// No description provided for @defaultCategoryNameHobbies.
  ///
  /// In es, this message translates to:
  /// **'Hobbies'**
  String get defaultCategoryNameHobbies;

  /// No description provided for @defaultCategoryNameCompras.
  ///
  /// In es, this message translates to:
  /// **'Compras'**
  String get defaultCategoryNameCompras;

  /// No description provided for @defaultCategoryNameImpuestos.
  ///
  /// In es, this message translates to:
  /// **'Impuestos'**
  String get defaultCategoryNameImpuestos;

  /// No description provided for @defaultCategoryNameLimpieza.
  ///
  /// In es, this message translates to:
  /// **'Limpieza'**
  String get defaultCategoryNameLimpieza;

  /// No description provided for @defaultCategoryNameMuebles.
  ///
  /// In es, this message translates to:
  /// **'Muebles'**
  String get defaultCategoryNameMuebles;

  /// No description provided for @defaultCategoryNameMantenimientoDelVehiculo.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento del vehículo'**
  String get defaultCategoryNameMantenimientoDelVehiculo;

  /// No description provided for @defaultCategoryNameMateriales.
  ///
  /// In es, this message translates to:
  /// **'Materiales'**
  String get defaultCategoryNameMateriales;

  /// No description provided for @defaultCategoryNameExpensas.
  ///
  /// In es, this message translates to:
  /// **'Expensas'**
  String get defaultCategoryNameExpensas;

  /// No description provided for @defaultCategoryNameInternet.
  ///
  /// In es, this message translates to:
  /// **'Internet'**
  String get defaultCategoryNameInternet;

  /// No description provided for @defaultCategoryNameAlquiler.
  ///
  /// In es, this message translates to:
  /// **'Alquiler'**
  String get defaultCategoryNameAlquiler;

  /// No description provided for @defaultCategoryNamePanaderia.
  ///
  /// In es, this message translates to:
  /// **'Panadería'**
  String get defaultCategoryNamePanaderia;

  /// No description provided for @defaultCategoryNameComisionesBancarias.
  ///
  /// In es, this message translates to:
  /// **'Comisiones bancarias'**
  String get defaultCategoryNameComisionesBancarias;

  /// No description provided for @defaultCategoryNameDonaciones.
  ///
  /// In es, this message translates to:
  /// **'Donaciones'**
  String get defaultCategoryNameDonaciones;

  /// No description provided for @defaultCategoryNameElectrodomesticos.
  ///
  /// In es, this message translates to:
  /// **'Electrodomésticos'**
  String get defaultCategoryNameElectrodomesticos;

  /// No description provided for @defaultCategoryNameEstacionamiento.
  ///
  /// In es, this message translates to:
  /// **'Estacionamiento'**
  String get defaultCategoryNameEstacionamiento;

  /// No description provided for @defaultCategoryNameTransportePublico.
  ///
  /// In es, this message translates to:
  /// **'Transporte público'**
  String get defaultCategoryNameTransportePublico;

  /// No description provided for @defaultCategoryNameOdontologia.
  ///
  /// In es, this message translates to:
  /// **'Odontología'**
  String get defaultCategoryNameOdontologia;

  /// No description provided for @defaultCategoryNameTrabajo.
  ///
  /// In es, this message translates to:
  /// **'Trabajo'**
  String get defaultCategoryNameTrabajo;

  /// No description provided for @defaultCategoryNameOcio.
  ///
  /// In es, this message translates to:
  /// **'Ocio'**
  String get defaultCategoryNameOcio;

  /// No description provided for @defaultCategoryNameVerduleria.
  ///
  /// In es, this message translates to:
  /// **'Verdulería'**
  String get defaultCategoryNameVerduleria;

  /// No description provided for @defaultCategoryNameSueldo.
  ///
  /// In es, this message translates to:
  /// **'Sueldo'**
  String get defaultCategoryNameSueldo;

  /// No description provided for @defaultCategoryNameOptica.
  ///
  /// In es, this message translates to:
  /// **'Óptica'**
  String get defaultCategoryNameOptica;

  /// No description provided for @defaultCategoryNameUberCabify.
  ///
  /// In es, this message translates to:
  /// **'Uber / Cabify'**
  String get defaultCategoryNameUberCabify;

  /// No description provided for @defaultCategoryNameCafeteria.
  ///
  /// In es, this message translates to:
  /// **'Cafetería'**
  String get defaultCategoryNameCafeteria;

  /// No description provided for @defaultCategoryNameRegalos.
  ///
  /// In es, this message translates to:
  /// **'Regalos'**
  String get defaultCategoryNameRegalos;

  /// No description provided for @defaultCategoryNameObraSocialPrepaga.
  ///
  /// In es, this message translates to:
  /// **'Obra social / Prepaga'**
  String get defaultCategoryNameObraSocialPrepaga;

  /// No description provided for @defaultCategoryNameConsultasMedicas.
  ///
  /// In es, this message translates to:
  /// **'Consultas médicas'**
  String get defaultCategoryNameConsultasMedicas;

  /// No description provided for @defaultCategoryNameEstudios.
  ///
  /// In es, this message translates to:
  /// **'Estudios'**
  String get defaultCategoryNameEstudios;

  /// No description provided for @defaultCategoryNameCine.
  ///
  /// In es, this message translates to:
  /// **'Cine'**
  String get defaultCategoryNameCine;

  /// No description provided for @defaultCategoryNameAlimentacion.
  ///
  /// In es, this message translates to:
  /// **'Alimentación'**
  String get defaultCategoryNameAlimentacion;

  /// No description provided for @defaultCategoryNameCuidadoPersonal.
  ///
  /// In es, this message translates to:
  /// **'Cuidado personal'**
  String get defaultCategoryNameCuidadoPersonal;

  /// No description provided for @defaultCategoryNameGuarderiaColegio.
  ///
  /// In es, this message translates to:
  /// **'Guardería / Colegio'**
  String get defaultCategoryNameGuarderiaColegio;

  /// No description provided for @defaultCategoryNameHerramientas.
  ///
  /// In es, this message translates to:
  /// **'Herramientas'**
  String get defaultCategoryNameHerramientas;

  /// No description provided for @defaultCategoryNameCombustible.
  ///
  /// In es, this message translates to:
  /// **'Combustible'**
  String get defaultCategoryNameCombustible;

  /// No description provided for @defaultCategoryNameMantenimiento.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento'**
  String get defaultCategoryNameMantenimiento;

  /// No description provided for @defaultCategoryNameLuz.
  ///
  /// In es, this message translates to:
  /// **'Luz'**
  String get defaultCategoryNameLuz;

  /// No description provided for @defaultCategoryNameLibros.
  ///
  /// In es, this message translates to:
  /// **'Libros'**
  String get defaultCategoryNameLibros;

  /// No description provided for @defaultCategoryNameTelefono.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get defaultCategoryNameTelefono;

  /// No description provided for @defaultCategoryNameHijos.
  ///
  /// In es, this message translates to:
  /// **'Hijos'**
  String get defaultCategoryNameHijos;

  /// No description provided for @defaultCategoryNameSalidas.
  ///
  /// In es, this message translates to:
  /// **'Salidas'**
  String get defaultCategoryNameSalidas;

  /// No description provided for @defaultCategoryNameFinanzas.
  ///
  /// In es, this message translates to:
  /// **'Finanzas'**
  String get defaultCategoryNameFinanzas;

  /// No description provided for @defaultCategoryNameCuotas.
  ///
  /// In es, this message translates to:
  /// **'Cuotas'**
  String get defaultCategoryNameCuotas;

  /// No description provided for @defaultCategoryNameServicios.
  ///
  /// In es, this message translates to:
  /// **'Servicios'**
  String get defaultCategoryNameServicios;

  /// No description provided for @defaultCategoryNameReparaciones.
  ///
  /// In es, this message translates to:
  /// **'Reparaciones'**
  String get defaultCategoryNameReparaciones;

  /// No description provided for @defaultCategoryNameSuscripcionesEducativas.
  ///
  /// In es, this message translates to:
  /// **'Suscripciones educativas'**
  String get defaultCategoryNameSuscripcionesEducativas;

  /// No description provided for @defaultCategoryNameTaxiRemis.
  ///
  /// In es, this message translates to:
  /// **'Taxi / Remis'**
  String get defaultCategoryNameTaxiRemis;

  /// No description provided for @defaultCategoryNameDecoracion.
  ///
  /// In es, this message translates to:
  /// **'Decoración'**
  String get defaultCategoryNameDecoracion;

  /// No description provided for @defaultCategoryNameTecnologia.
  ///
  /// In es, this message translates to:
  /// **'Tecnología'**
  String get defaultCategoryNameTecnologia;

  /// No description provided for @defaultCategoryNameSalud.
  ///
  /// In es, this message translates to:
  /// **'Salud'**
  String get defaultCategoryNameSalud;

  /// No description provided for @defaultCategoryNameIntereses.
  ///
  /// In es, this message translates to:
  /// **'Intereses'**
  String get defaultCategoryNameIntereses;

  /// No description provided for @defaultCategoryNameJuegos.
  ///
  /// In es, this message translates to:
  /// **'Juegos'**
  String get defaultCategoryNameJuegos;

  /// No description provided for @defaultCategoryNameSupermercado.
  ///
  /// In es, this message translates to:
  /// **'Supermercado'**
  String get defaultCategoryNameSupermercado;

  /// No description provided for @defaultCategoryNameCalzado.
  ///
  /// In es, this message translates to:
  /// **'Calzado'**
  String get defaultCategoryNameCalzado;

  /// No description provided for @defaultCategoryNameViaje.
  ///
  /// In es, this message translates to:
  /// **'Viaje'**
  String get defaultCategoryNameViaje;

  /// No description provided for @defaultCategoryNameCableTv.
  ///
  /// In es, this message translates to:
  /// **'Cable / TV'**
  String get defaultCategoryNameCableTv;

  /// No description provided for @defaultCategoryNamePeajes.
  ///
  /// In es, this message translates to:
  /// **'Peajes'**
  String get defaultCategoryNamePeajes;

  /// No description provided for @defaultCategoryNameVarios.
  ///
  /// In es, this message translates to:
  /// **'Varios'**
  String get defaultCategoryNameVarios;

  /// No description provided for @defaultCategoryNameRestaurantes.
  ///
  /// In es, this message translates to:
  /// **'Restaurantes'**
  String get defaultCategoryNameRestaurantes;

  /// No description provided for @defaultCategoryNameMonotributoAutonomos.
  ///
  /// In es, this message translates to:
  /// **'Monotributo / Autónomos'**
  String get defaultCategoryNameMonotributoAutonomos;

  /// No description provided for @defaultCategoryNameEventos.
  ///
  /// In es, this message translates to:
  /// **'Eventos'**
  String get defaultCategoryNameEventos;

  /// No description provided for @defaultCategoryNameAlimentos.
  ///
  /// In es, this message translates to:
  /// **'Alimentos'**
  String get defaultCategoryNameAlimentos;

  /// No description provided for @defaultCategoryNameMascotas.
  ///
  /// In es, this message translates to:
  /// **'Mascotas'**
  String get defaultCategoryNameMascotas;

  /// No description provided for @defaultCategoryNameVacaciones.
  ///
  /// In es, this message translates to:
  /// **'Vacaciones'**
  String get defaultCategoryNameVacaciones;

  /// No description provided for @defaultCategoryNameFondoDeEmergencia.
  ///
  /// In es, this message translates to:
  /// **'Fondo de emergencia'**
  String get defaultCategoryNameFondoDeEmergencia;

  /// No description provided for @defaultCategoryNameMedicamentos.
  ///
  /// In es, this message translates to:
  /// **'Medicamentos'**
  String get defaultCategoryNameMedicamentos;

  /// No description provided for @defaultCategoryNameTransporte.
  ///
  /// In es, this message translates to:
  /// **'Transporte'**
  String get defaultCategoryNameTransporte;

  /// No description provided for @defaultCategoryNameImprevistos.
  ///
  /// In es, this message translates to:
  /// **'Imprevistos'**
  String get defaultCategoryNameImprevistos;

  /// No description provided for @defaultCategoryNameCapacitacion.
  ///
  /// In es, this message translates to:
  /// **'Capacitación'**
  String get defaultCategoryNameCapacitacion;

  /// No description provided for @defaultCategoryNameAgua.
  ///
  /// In es, this message translates to:
  /// **'Agua'**
  String get defaultCategoryNameAgua;

  /// No description provided for @defaultCategoryNameEducacion.
  ///
  /// In es, this message translates to:
  /// **'Educación'**
  String get defaultCategoryNameEducacion;

  /// No description provided for @defaultCategoryNameFreelance.
  ///
  /// In es, this message translates to:
  /// **'Freelance'**
  String get defaultCategoryNameFreelance;

  /// No description provided for @defaultCategoryNameTarjetasDeCredito.
  ///
  /// In es, this message translates to:
  /// **'Tarjetas de crédito'**
  String get defaultCategoryNameTarjetasDeCredito;

  /// No description provided for @defaultCategoryNameCursos.
  ///
  /// In es, this message translates to:
  /// **'Cursos'**
  String get defaultCategoryNameCursos;

  /// No description provided for @defaultCategoryNameRopa.
  ///
  /// In es, this message translates to:
  /// **'Ropa'**
  String get defaultCategoryNameRopa;

  /// No description provided for @defaultCategoryNameComprasOnline.
  ///
  /// In es, this message translates to:
  /// **'Compras online'**
  String get defaultCategoryNameComprasOnline;

  /// No description provided for @defaultCategoryNameHogar.
  ///
  /// In es, this message translates to:
  /// **'Hogar'**
  String get defaultCategoryNameHogar;

  /// No description provided for @defaultCategoryNameSeguroDelAuto.
  ///
  /// In es, this message translates to:
  /// **'Seguro del auto'**
  String get defaultCategoryNameSeguroDelAuto;

  /// No description provided for @defaultCategoryNameStreaming.
  ///
  /// In es, this message translates to:
  /// **'Streaming'**
  String get defaultCategoryNameStreaming;

  /// No description provided for @defaultCategoryNameGas.
  ///
  /// In es, this message translates to:
  /// **'Gas'**
  String get defaultCategoryNameGas;

  /// No description provided for @defaultCategoryNameVenta.
  ///
  /// In es, this message translates to:
  /// **'Venta'**
  String get defaultCategoryNameVenta;

  /// No description provided for @defaultCategoryNameDelivery.
  ///
  /// In es, this message translates to:
  /// **'Delivery'**
  String get defaultCategoryNameDelivery;

  /// No description provided for @defaultCategoryNameCarniceria.
  ///
  /// In es, this message translates to:
  /// **'Carnicería'**
  String get defaultCategoryNameCarniceria;

  /// No description provided for @defaultCategoryNameNubeApps.
  ///
  /// In es, this message translates to:
  /// **'Nube / Apps'**
  String get defaultCategoryNameNubeApps;

  /// No description provided for @defaultCategoryNameFamilia.
  ///
  /// In es, this message translates to:
  /// **'Familia'**
  String get defaultCategoryNameFamilia;

  /// No description provided for @defaultCategoryNameComidasLaborales.
  ///
  /// In es, this message translates to:
  /// **'Comidas laborales'**
  String get defaultCategoryNameComidasLaborales;

  /// No description provided for @defaultCategoryNameTransporteLaboral.
  ///
  /// In es, this message translates to:
  /// **'Transporte laboral'**
  String get defaultCategoryNameTransporteLaboral;

  /// No description provided for @defaultCategoryNameAhorroGeneral.
  ///
  /// In es, this message translates to:
  /// **'Ahorro general'**
  String get defaultCategoryNameAhorroGeneral;

  /// No description provided for @defaultCategoryNameOtros.
  ///
  /// In es, this message translates to:
  /// **'Otros'**
  String get defaultCategoryNameOtros;

  /// No description provided for @portuguese.
  ///
  /// In es, this message translates to:
  /// **'Portugués'**
  String get portuguese;

  /// No description provided for @technicalErrorDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalle técnico: {error}'**
  String technicalErrorDetails(Object error);

  /// No description provided for @currencyArsOption.
  ///
  /// In es, this message translates to:
  /// **'ARS (\$)'**
  String get currencyArsOption;

  /// No description provided for @currencyUsdOption.
  ///
  /// In es, this message translates to:
  /// **'USD (US\$)'**
  String get currencyUsdOption;

  /// No description provided for @currencyEurOption.
  ///
  /// In es, this message translates to:
  /// **'EUR (€)'**
  String get currencyEurOption;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
