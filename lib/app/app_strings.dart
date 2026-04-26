import 'package:flutter/widgets.dart';

import 'package:clean_finance/core/utils/payment_method_utils.dart';

import '../core/localization/generated/app_localizations.dart';
import '../core/localization/generated/app_localizations_en.dart';
import '../core/localization/generated/app_localizations_es.dart';
import '../core/localization/generated/app_localizations_pt.dart';

class AppStrings {
  AppStrings(this._l10n);

  final AppLocalizations _l10n;

  static AppStrings of(BuildContext context) {
    final l10n = Localizations.of<AppLocalizations>(
          context,
          AppLocalizations,
        ) ??
        switch (Localizations.localeOf(context).languageCode) {
          'en' => AppLocalizationsEn(),
          'pt' => AppLocalizationsPt(),
          _ => AppLocalizationsEs(),
        };
    return AppStrings(l10n);
  }

  String get languageCode => _l10n.localeName;
  bool get isEnglish => _l10n.localeName.startsWith('en');
  bool get isPortuguese => _l10n.localeName.startsWith('pt');

  String get appName => _l10n.appName;
  String get settings => _l10n.settings;
  String get language => _l10n.language;
  String get useDeviceLanguage => _l10n.useDeviceLanguage;
  String get spanish => _l10n.spanish;
  String get english => _l10n.english;
  String get dashboard => _l10n.dashboard;
  String get movements => _l10n.movements;
  String get savings => _l10n.savings;
  String get reports => _l10n.reports;
  String get income => _l10n.income;
  String get expense => _l10n.expense;
  String get saving => _l10n.saving;
  String get category => _l10n.category;
  String get subcategory => _l10n.subcategory;
  String get savingGoal => _l10n.savingGoal;
  String get cancel => _l10n.cancel;
  String get save => _l10n.save;
  String get apply => _l10n.apply;
  String get clear => _l10n.clear;
  String get privacyPolicy => _l10n.privacyPolicy;
  String get paymentMethods => _l10n.paymentMethods;
  String get managePaymentMethods => _l10n.managePaymentMethods;
  String get manageReminders => _l10n.manageReminders;
  String get addPaymentMethod => _l10n.addPaymentMethod;
  String get movementPaymentMethod => _l10n.movementPaymentMethod;
  String get paymentMethodTransfer => _l10n.paymentMethodTransfer;
  String get paymentMethodDebitCard => _l10n.paymentMethodDebitCard;
  String get paymentMethodCreditCard => _l10n.paymentMethodCreditCard;
  String get paymentMethodUnspecified => _l10n.paymentMethodUnspecified;
  String get monthlyReminder => _l10n.monthlyReminder;
  String get monthlyReminderDescription => _l10n.monthlyReminderDescription;
  String get reminderDay => _l10n.reminderDay;
  String get pendingThisMonth => _l10n.pendingThisMonth;
  String get reminderRegisterPayment => _l10n.reminderRegisterPayment;
  String get reminderLastRegistered => _l10n.reminderLastRegistered;
  String get noSubcategory => _l10n.noSubcategory;
  String get newMovement => _l10n.newMovement;
  String get editMovement => _l10n.editMovement;
  String get saveMovement => _l10n.saveMovement;
  String get saveChanges => _l10n.saveChanges;
  String get unlimitedDate => _l10n.unlimitedDate;
  String get biometric => _l10n.biometric;
  String get exportBackup => _l10n.exportBackup;
  String get importBackup => _l10n.importBackup;
  String get manageCategories => _l10n.manageCategories;
  String get noCategories => _l10n.noCategories;
  String get mainCategory => _l10n.mainCategory;
  String get addSubcategory => _l10n.addSubcategory;
  String get manageBudgets => _l10n.manageBudgets;
  String get amountPrivacy => _l10n.amountPrivacy;
  String get amountPrivacyDescription => _l10n.amountPrivacyDescription;
  String get newBudget => _l10n.newBudget;
  String get editBudget => _l10n.editBudget;
  String get monthlyLimit => _l10n.monthlyLimit;
  String get searchByNote => _l10n.searchByNote;
  String get setupTitle => _l10n.setupTitle;
  String get unlockTitle => _l10n.unlockTitle;
  String get recoverAccess => _l10n.recoverAccess;
  String get documentId => _l10n.documentId;
  String get paymentMethodQr => _l10n.paymentMethodQr;
  String get text => _l10n.text;
  String get text2 => _l10n.text2;
  String get text3 => _l10n.text3;
  String get text4 => _l10n.text4;
  String get text5 => _l10n.text5;
  String get text6 => _l10n.text6;
  String get appearance => _l10n.appearance;
  String get privacy => _l10n.privacy;
  String get security => _l10n.security;
  String get data => _l10n.data;
  String get paymentMethodCash => _l10n.paymentMethodCash;
  String get reminderDayPrefix => _l10n.reminderDayPrefix;
  String get noGoal => _l10n.noGoal;
  String get amount => _l10n.amount;
  String get note => _l10n.note;
  String get type => _l10n.type;
  String get date => _l10n.date;
  String get movement => _l10n.movement;
  String get movementsTab => _l10n.movementsTab;
  String get createGoal => _l10n.createGoal;
  String get newGoal => _l10n.newGoal;
  String get editGoal => _l10n.editGoal;
  String get completed => _l10n.completed;
  String get activeGoals => _l10n.activeGoals;
  String get achieved => _l10n.achieved;
  String get contribute => _l10n.contribute;
  String get defaultCategory => _l10n.defaultCategory;
  String get customCategory => _l10n.customCategory;
  String get budgets => _l10n.budgets;
  String get showAmounts => _l10n.showAmounts;
  String get hideAmounts => _l10n.hideAmounts;
  String get spent => _l10n.spent;
  String get remaining => _l10n.remaining;
  String get lockNow => _l10n.lockNow;
  String get add => _l10n.add;
  String get all => _l10n.all;
  String get from => _l10n.from;
  String get to => _l10n.to;
  String get filters => _l10n.filters;
  String get forgotPin => _l10n.forgotPin;
  String get birthDate => _l10n.birthDate;
  String get todaviaNoHaySuficienteActividadEsteMes =>
      _l10n.todaviaNoHaySuficienteActividadEsteMes;
  String get vasEnCaminoACerrarElMes => _l10n.vasEnCaminoACerrarElMes;
  String get tuRitmoActualPodriaDejarteConMuy =>
      _l10n.tuRitmoActualPodriaDejarteConMuy;
  String get siElGastoSigueAEsteRitmo => _l10n.siElGastoSigueAEsteRitmo;
  String get muySaludable => _l10n.muySaludable;
  String get tuMesVieneEquilibradoYConBuen =>
      _l10n.tuMesVieneEquilibradoYConBuen;
  String get tusNumerosEstanBastanteControladosConAlgunos =>
      _l10n.tusNumerosEstanBastanteControladosConAlgunos;
  String get tuFlujoSigueFuncionandoPeroConvieneAjustar =>
      _l10n.tuFlujoSigueFuncionandoPeroConvieneAjustar;
  String get elRitmoActualPuedeDejarteSinMargen =>
      _l10n.elRitmoActualPuedeDejarteSinMargen;
  String get masDeLoQueEntra => _l10n.masDeLoQueEntra;
  String get mesConMargen => _l10n.mesConMargen;
  String get categoriaDominante => _l10n.categoriaDominante;
  String get cambioBruscoDeGasto => _l10n.cambioBruscoDeGasto;
  String get buenAjuste => _l10n.buenAjuste;
  String get riesgoDeFinDeMes => _l10n.riesgoDeFinDeMes;
  String get ritmoBajoControl => _l10n.ritmoBajoControl;
  String get gastoAtipico => _l10n.gastoAtipico;
  String get ahorroSaludable => _l10n.ahorroSaludable;
  String get sugerenciaSimple => _l10n.sugerenciaSimple;
  String get mesEnMejora => _l10n.mesEnMejora;
  String get mesMasExigente => _l10n.mesMasExigente;
  String get metaEncaminada => _l10n.metaEncaminada;
  String get despuesDeGastarYAhorrarTodaviaTe =>
      _l10n.despuesDeGastarYAhorrarTodaviaTe;
  String get tuProyeccionDeGastoCierraDentroDel =>
      _l10n.tuProyeccionDeGastoCierraDentroDel;
  String get reservarAunqueSeaUn5AlCobrar => _l10n.reservarAunqueSeaUn5AlCobrar;
  String get tuResultadoMensualVieneMejorQueEl =>
      _l10n.tuResultadoMensualVieneMejorQueEl;
  String get tuMargenBajoFrenteAlMesAnterior =>
      _l10n.tuMargenBajoFrenteAlMesAnterior;
  String get actualizaTuRegistro => _l10n.actualizaTuRegistro;
  String get registraUnMovimientoEnSegundos =>
      _l10n.registraUnMovimientoEnSegundos;
  String get usaLenguajeSimpleYDejaSoloLa => _l10n.usaLenguajeSimpleYDejaSoloLa;
  String get elegiQueTipoDeMovimientoQueresRegistrar =>
      _l10n.elegiQueTipoDeMovimientoQueresRegistrar;
  String get ingresaUnMontoValido => _l10n.ingresaUnMontoValido;
  String get elegiUnaCategoria => _l10n.elegiUnaCategoria;
  String get elegiLaCategoriaPrincipal => _l10n.elegiLaCategoriaPrincipal;
  String get subcategoriaOpcional => _l10n.subcategoriaOpcional;
  String get siAplicaElegiUnDetalleMasEspecifico =>
      _l10n.siAplicaElegiUnDetalleMasEspecifico;
  String get vinculaElMovimientoConUnaDeTus =>
      _l10n.vinculaElMovimientoConUnaDeTus;
  String get siGuardasAhoraQuedaraEnAhorroGeneral =>
      _l10n.siGuardasAhoraQuedaraEnAhorroGeneral;
  String get tipSiElegisUnaMetaVasA => _l10n.tipSiElegisUnaMetaVasA;
  String get elegiUnMedioDePago => _l10n.elegiUnMedioDePago;
  String get ejemploCompraSemanalOPagoDeServicio =>
      _l10n.ejemploCompraSemanalOPagoDeServicio;
  String get protegerBackup => _l10n.protegerBackup;
  String get agregaUnaContrasenaOpcionalSiLaDejas =>
      _l10n.agregaUnaContrasenaOpcionalSiLaDejas;
  String get backupLocalDeCleanfinance => _l10n.backupLocalDeCleanfinance;
  String get estaAccionReemplazaraTusDatosLocalesActuales =>
      _l10n.estaAccionReemplazaraTusDatosLocalesActuales;
  String get siEsteBackupFueProtegidoConContrasena =>
      _l10n.siEsteBackupFueProtegidoConContrasena;
  String get datosImportadosCorrectamente => _l10n.datosImportadosCorrectamente;
  String get borrarTodosLosDatos => _l10n.borrarTodosLosDatos;
  String get estoEliminaraLaBaseLocalCompletaEl =>
      _l10n.estoEliminaraLaBaseLocalCompletaEl;
  String get borrarTodo => _l10n.borrarTodo;
  String get seBorraronTodosLosDatosLocalesLa =>
      _l10n.seBorraronTodosLosDatosLocalesLa;
  String get contrasenaOpcional => _l10n.contrasenaOpcional;
  String get unaAppSimplePrivadaYClara => _l10n.unaAppSimplePrivadaYClara;
  String get configuraLaExperienciaParaQueSeSienta =>
      _l10n.configuraLaExperienciaParaQueSeSienta;
  String get manteneAccesoRapidoSinPerderPrivacidad =>
      _l10n.manteneAccesoRapidoSinPerderPrivacidad;
  String get usaHuellaOReconocimientoFacialSiEsta =>
      _l10n.usaHuellaOReconocimientoFacialSiEsta;
  String get esteDispositivoNoTieneBiometriaDisponible =>
      _l10n.esteDispositivoNoTieneBiometriaDisponible;
  String get bloqueoAutomatico => _l10n.bloqueoAutomatico;
  String get revisaQueGuardaCleanfinanceDeFormaLocal =>
      _l10n.revisaQueGuardaCleanfinanceDeFormaLocal;
  String get seguirSistema => _l10n.seguirSistema;
  String get recibiRecordatoriosMensualesEnEsteTelefono =>
      _l10n.recibiRecordatoriosMensualesEnEsteTelefono;
  String get notificacionesDelSistema => _l10n.notificacionesDelSistema;
  String get horaDeRecordatorio => _l10n.horaDeRecordatorio;
  String get personalizaLasListasQueUsasTodosLos =>
      _l10n.personalizaLasListasQueUsasTodosLos;
  String get tusDatosVivenEnTuDispositivoPodes =>
      _l10n.tusDatosVivenEnTuDispositivoPodes;
  String get notaDeSeguridadLosBackupsLocalesPueden =>
      _l10n.notaDeSeguridadLosBackupsLocalesPueden;
  String get privacidadPrimeroNoHayTrackingNoSe =>
      _l10n.privacidadPrimeroNoHayTrackingNoSe;
  String get noSePudieronCargarLosAjustes => _l10n.noSePudieronCargarLosAjustes;
  String get revisandoPermiso => _l10n.revisandoPermiso;
  String get noSePudoRevisarElPermiso => _l10n.noSePudoRevisarElPermiso;
  String get notificacionesDesactivadas => _l10n.notificacionesDesactivadas;
  String get notificacionesActivadas => _l10n.notificacionesActivadas;
  String get permisoPendiente => _l10n.permisoPendiente;
  String get permisoDenegado => _l10n.permisoDenegado;
  String get noDisponibleEnEstaPlataforma => _l10n.noDisponibleEnEstaPlataforma;
  String get errorInesperado => _l10n.errorInesperado;
  String get pinIncorrecto => _l10n.pinIncorrecto;
  String get nuevoPin => _l10n.nuevoPin;
  String get confirmarPin => _l10n.confirmarPin;
  String get validando => _l10n.validando;
  String get empezar => _l10n.empezar;
  String get desbloquear => _l10n.desbloquear;
  String get eliminarPresupuesto => _l10n.eliminarPresupuesto;
  String get eliminar => _l10n.eliminar;
  String get guardando => _l10n.guardando;
  String get reintentar => _l10n.reintentar;
  String get atencion => _l10n.atencion;
  String get excedido => _l10n.excedido;
  String get normal => _l10n.normal;
  String get bajo => _l10n.bajo;
  String get medio => _l10n.medio;
  String get alto => _l10n.alto;
  String get estable => _l10n.estable;
  String get enRiesgo => _l10n.enRiesgo;
  String get eliminarCategoria => _l10n.eliminarCategoria;
  String get nuevaCategoria => _l10n.nuevaCategoria;
  String get editarCategoria => _l10n.editarCategoria;
  String get nombre => _l10n.nombre;
  String get recomendaciones => _l10n.recomendaciones;
  String get movimientosRecientes => _l10n.movimientosRecientes;
  String get recordatoriosDeGastos => _l10n.recordatoriosDeGastos;
  String get recordatoriosDeAhorro => _l10n.recordatoriosDeAhorro;
  String get eliminarMovimiento => _l10n.eliminarMovimiento;
  String get agregarMovimiento => _l10n.agregarMovimiento;
  String get evolucionMensual => _l10n.evolucionMensual;
  String get ritmoDeGasto => _l10n.ritmoDeGasto;
  String get proyeccion => _l10n.proyeccion;
  String get estado => _l10n.estado;
  String get metasDeAhorro => _l10n.metasDeAhorro;
  String get lecturaRapida => _l10n.lecturaRapida;
  String get enRango => _l10n.enRango;
  String get atencion2 => _l10n.atencion2;
  String get riesgo => _l10n.riesgo;
  String get nuevo => _l10n.nuevo;
  String get sinEstimacionTodavia => _l10n.sinEstimacionTodavia;
  String get nombreDeLaMeta => _l10n.nombreDeLaMeta;
  String get montoObjetivo => _l10n.montoObjetivo;
  String get guardarMeta => _l10n.guardarMeta;
  String get eliminarMeta => _l10n.eliminarMeta;
  String get ahorroGeneral => _l10n.ahorroGeneral;
  String get objetivo => _l10n.objetivo;
  String get advertenciaElArchivoNoEstaCifrado =>
      _l10n.advertenciaElArchivoNoEstaCifrado;
  String get oneMinute => _l10n.oneMinute;
  String get fiveMinutes => _l10n.fiveMinutes;
  String get fifteenMinutes => _l10n.fifteenMinutes;
  String get thirtyMinutes => _l10n.thirtyMinutes;
  String get tema => _l10n.tema;
  String get claro => _l10n.claro;
  String get oscuro => _l10n.oscuro;
  String get moneda => _l10n.moneda;
  String get notificaciones => _l10n.notificaciones;
  String get organizacion => _l10n.organizacion;
  String get netoEstimado => _l10n.netoEstimado;
  String get icono => _l10n.icono;
  String get tocaParaCambiar => _l10n.tocaParaCambiar;
  String get elegiUnIcono => _l10n.elegiUnIcono;
  String get seleccionar => _l10n.seleccionar;
  String get total => _l10n.total;
  String get movementFormMissingCategory => _l10n.movementFormMissingCategory;
  String get authRecoveryDocumentExample => _l10n.authRecoveryDocumentExample;
  String get authUseBiometrics => _l10n.authUseBiometrics;
  String get authUnlockWithPinOrBiometrics =>
      _l10n.authUnlockWithPinOrBiometrics;
  String get authBiometricsEnabledTip => _l10n.authBiometricsEnabledTip;
  String get authBiometricsUnavailablePinProtected =>
      _l10n.authBiometricsUnavailablePinProtected;
  String get estaCategoria => _l10n.estaCategoria;
  String get tuMeta => _l10n.tuMeta;
  String get revisaTusDatosDeRecuperacionEIntenta =>
      _l10n.revisaTusDatosDeRecuperacionEIntenta;
  String get laBiometriaNoEstaDisponibleEnEste =>
      _l10n.laBiometriaNoEstaDisponibleEnEste;
  String get noSePudoUsarLaBiometriaConfigura =>
      _l10n.noSePudoUsarLaBiometriaConfigura;
  String get noSePudoValidarLaBiometriaVerifica =>
      _l10n.noSePudoValidarLaBiometriaVerifica;
  String get noSePudoVerificarLaRecuperacionRevisa =>
      _l10n.noSePudoVerificarLaRecuperacionRevisa;
  String get algunasValidacionesDeSeguridadNoPudieronInicializarse =>
      _l10n.algunasValidacionesDeSeguridadNoPudieronInicializarse;
  String get completaAmbasRespuestasDeRecuperacion =>
      _l10n.completaAmbasRespuestasDeRecuperacion;
  String get usaUnaFechaValidaYUnDocumento =>
      _l10n.usaUnaFechaValidaYUnDocumento;
  String get losPinNoCoinciden => _l10n.losPinNoCoinciden;
  String get recuperaTuAccesoSinComplicarte =>
      _l10n.recuperaTuAccesoSinComplicarte;
  String get respondeTusDosPreguntasPersonalesYElegi =>
      _l10n.respondeTusDosPreguntasPersonalesYElegi;
  String get laRecuperacionLocalEsMenosRobustaQue =>
      _l10n.laRecuperacionLocalEsMenosRobustaQue;
  String get ejemplo10021996 => _l10n.ejemplo10021996;
  String get activarHuellaParaProximosAccesos =>
      _l10n.activarHuellaParaProximosAccesos;
  String get asiVasAPoderEntrarMasRapido => _l10n.asiVasAPoderEntrarMasRapido;
  String get completaTusDosPreguntasDeRecuperacion =>
      _l10n.completaTusDosPreguntasDeRecuperacion;
  String get creaUnPinCortoParaProtegerTus =>
      _l10n.creaUnPinCortoParaProtegerTus;
  String get elegiTuPin => _l10n.elegiTuPin;
  String get repetiTuPin => _l10n.repetiTuPin;
  String get activarHuellaParaEntrarMasRapido =>
      _l10n.activarHuellaParaEntrarMasRapido;
  String get laAppTeLaVaAOfrecer => _l10n.laAppTeLaVaAOfrecer;
  String get configurando => _l10n.configurando;
  String get guardamosEstasRespuestasSoloParaAyudarteA =>
      _l10n.guardamosEstasRespuestasSoloParaAyudarteA;
  String get lasRespuestasDeRecuperacionSonMasDebiles =>
      _l10n.lasRespuestasDeRecuperacionSonMasDebiles;
  String get estePresupuestoMensualSeEliminaraYEl =>
      _l10n.estePresupuestoMensualSeEliminaraYEl;
  String get seleccionaUnaCategoria => _l10n.seleccionaUnaCategoria;
  String get primeroCreaUnaCategoriaDeGasto =>
      _l10n.primeroCreaUnaCategoriaDeGasto;
  String get losPresupuestosSeCreanAPartirDe =>
      _l10n.losPresupuestosSeCreanAPartirDe;
  String get ajustaEstePresupuestoMensual => _l10n.ajustaEstePresupuestoMensual;
  String get creaUnPresupuestoMensualPorCategoria =>
      _l10n.creaUnPresupuestoMensualPorCategoria;
  String get losPresupuestosSeGuardanLocalmenteYSe =>
      _l10n.losPresupuestosSeGuardanLocalmenteYSe;
  String get elegiLaCategoriaDeGastoParaEste =>
      _l10n.elegiLaCategoriaDeGastoParaEste;
  String get ingresaUnLimiteMensualValido => _l10n.ingresaUnLimiteMensualValido;
  String get presupuestosMensuales => _l10n.presupuestosMensuales;
  String get seguiComoVieneCadaCategoriaEsteMes =>
      _l10n.seguiComoVieneCadaCategoriaEsteMes;
  String get creaTuPrimerPresupuesto => _l10n.creaTuPrimerPresupuesto;
  String get definiUnLimiteMensualParaUnaCategoria =>
      _l10n.definiUnLimiteMensualParaUnaCategoria;
  String get agregarPresupuesto => _l10n.agregarPresupuesto;
  String get noSePudieronCargarLosPresupuestos =>
      _l10n.noSePudieronCargarLosPresupuestos;
  String get eliminarSubcategoria => _l10n.eliminarSubcategoria;
  String get categoriaPadre => _l10n.categoriaPadre;
  String get sinCategoriaPadre => _l10n.sinCategoriaPadre;
  String get elegiUnaCategoriaPrincipalSoloSiQueres =>
      _l10n.elegiUnaCategoriaPrincipalSoloSiQueres;
  String get usaEstaSubcategoriaParaServiciosOGastos =>
      _l10n.usaEstaSubcategoriaParaServiciosOGastos;
  String get saldoActual => _l10n.saldoActual;
  String get ahorroTotal => _l10n.ahorroTotal;
  String get todaviaNoHayRecomendaciones => _l10n.todaviaNoHayRecomendaciones;
  String get cargaAlgunosMovimientosParaVerAlertasY =>
      _l10n.cargaAlgunosMovimientosParaVerAlertasY;
  String get ingresosVsGastos => _l10n.ingresosVsGastos;
  String get unaLecturaRapidaDeComoVieneEl =>
      _l10n.unaLecturaRapidaDeComoVieneEl;
  String get comparaTusIngresosYGastosDeLos =>
      _l10n.comparaTusIngresosYGastosDeLos;
  String get gastosPorCategoria => _l10n.gastosPorCategoria;
  String get simpleClaroYFacilDeLeer => _l10n.simpleClaroYFacilDeLeer;
  String get todaviaNoHayGastosSuficientes =>
      _l10n.todaviaNoHayGastosSuficientes;
  String get cuandoRegistresGastosVasAVerTus =>
      _l10n.cuandoRegistresGastosVasAVerTus;
  String get agregarGasto => _l10n.agregarGasto;
  String get empezaConTuPrimerMovimiento => _l10n.empezaConTuPrimerMovimiento;
  String get cargarGastosEIngresosTeVaA => _l10n.cargarGastosEIngresosTeVaA;
  String get noPudimosCargarElInicio => _l10n.noPudimosCargarElInicio;
  String get sinCategoria => _l10n.sinCategoria;
  String get revisaTusRecordatoriosMensualesActivos =>
      _l10n.revisaTusRecordatoriosMensualesActivos;
  String get losRecordatoriosDeGastoSalenDeSubcategorias =>
      _l10n.losRecordatoriosDeGastoSalenDeSubcategorias;
  String get noHayRecordatoriosDeGastoActivos =>
      _l10n.noHayRecordatoriosDeGastoActivos;
  String get activaRecordatoriosAlCrearOEditarUna =>
      _l10n.activaRecordatoriosAlCrearOEditarUna;
  String get noSePudieronCargarLosRecordatoriosDe =>
      _l10n.noSePudieronCargarLosRecordatoriosDe;
  String get noHayRecordatoriosDeAhorroActivos =>
      _l10n.noHayRecordatoriosDeAhorroActivos;
  String get activaRecordatoriosAlCrearOEditarUna2 =>
      _l10n.activaRecordatoriosAlCrearOEditarUna2;
  String get metaCompletada => _l10n.metaCompletada;
  String get noSePudieronCargarLosRecordatoriosDe2 =>
      _l10n.noSePudieronCargarLosRecordatoriosDe2;
  String get elegiElDiaDelMesParaEl => _l10n.elegiElDiaDelMesParaEl;
  String get seEliminaraEsteMovimientoDeFormaPermanente =>
      _l10n.seEliminaraEsteMovimientoDeFormaPermanente;
  String get elegiSoloLoNecesarioParaEncontrarRapido =>
      _l10n.elegiSoloLoNecesarioParaEncontrarRapido;
  String get filtraPorUnaCategoriaPrincipalParaAcotar =>
      _l10n.filtraPorUnaCategoriaPrincipalParaAcotar;
  String get noEncontramosMovimientos => _l10n.noEncontramosMovimientos;
  String get probaCambiandoElFiltroOAgregandoUn =>
      _l10n.probaCambiandoElFiltroOAgregandoUn;
  String get noSePudieronCargarLosMovimientos =>
      _l10n.noSePudieronCargarLosMovimientos;
  String get editarMedioDePago => _l10n.editarMedioDePago;
  String get ejemploQrTransferenciaOEfectivo =>
      _l10n.ejemploQrTransferenciaOEfectivo;
  String get elegiSoloLosMediosDePagoQue => _l10n.elegiSoloLosMediosDePagoQue;
  String get estasOpcionesVanAAparecerComoDesplegable =>
      _l10n.estasOpcionesVanAAparecerComoDesplegable;
  String get todaviaNoHayMediosDePago => _l10n.todaviaNoHayMediosDePago;
  String get agregaTusOpcionesHabitualesComoTransferenciaDebito =>
      _l10n.agregaTusOpcionesHabitualesComoTransferenciaDebito;
  String get saludFinanciera => _l10n.saludFinanciera;
  String get cashflowMensual => _l10n.cashflowMensual;
  String get unResumenRapidoParaEntenderCuantoEntro =>
      _l10n.unResumenRapidoParaEntenderCuantoEntro;
  String get saldoNeto => _l10n.saldoNeto;
  String get comparaComoVienenTusIngresosYGastos =>
      _l10n.comparaComoVienenTusIngresosYGastos;
  String get topCategoriasDelMes => _l10n.topCategoriasDelMes;
  String get vasAVerEnQueSeFue => _l10n.vasAVerEnQueSeFue;
  String get sinDatosTodavia => _l10n.sinDatosTodavia;
  String get cuandoRegistresGastosVasAVerAca =>
      _l10n.cuandoRegistresGastosVasAVerAca;
  String get teMuestraSiElGastoAcumuladoVa =>
      _l10n.teMuestraSiElGastoAcumuladoVa;
  String get esperadoHoy => _l10n.esperadoHoy;
  String get elRitmoActualEsExigenteParaTu =>
      _l10n.elRitmoActualEsExigenteParaTu;
  String get vasCercaDelLimiteConvieneMirarCon =>
      _l10n.vasCercaDelLimiteConvieneMirarCon;
  String get tuGastoVieneEnUnaZonaSaludable =>
      _l10n.tuGastoVieneEnUnaZonaSaludable;
  String get seguimientoSimpleDelAvanceRitmoDeAporte =>
      _l10n.seguimientoSimpleDelAvanceRitmoDeAporte;
  String get todaviaNoHayMetasParaAnalizar =>
      _l10n.todaviaNoHayMetasParaAnalizar;
  String get cuandoTengasMetasYAportesVasA =>
      _l10n.cuandoTengasMetasYAportesVasA;
  String get gastosPorMedioDePago => _l10n.gastosPorMedioDePago;
  String get teAyudaAVerQueMetodoEstas => _l10n.teAyudaAVerQueMetodoEstas;
  String get noSePudieronCargarLosReportes =>
      _l10n.noSePudieronCargarLosReportes;
  String get elegiUnDiaDeRecordatorioValido =>
      _l10n.elegiUnDiaDeRecordatorioValido;
  String get definiUnaMetaSimpleYVisible => _l10n.definiUnaMetaSimpleYVisible;
  String get nombreClaroMontoObjetivoYFechaOpcional =>
      _l10n.nombreClaroMontoObjetivoYFechaOpcional;
  String get ingresaUnNombre => _l10n.ingresaUnNombre;
  String get agregarFechaObjetivo => _l10n.agregarFechaObjetivo;
  String get teAyudaANoOlvidarteDelAporte => _l10n.teAyudaANoOlvidarteDelAporte;
  String get elegiElDiaDelMesEnEl => _l10n.elegiElDiaDelMesEnEl;
  String get todaviaNoTenesAhorroRegistrado =>
      _l10n.todaviaNoTenesAhorroRegistrado;
  String get creaUnaMetaORegistraUnAporte => _l10n.creaUnaMetaORegistraUnAporte;
  String get totalAhorrado => _l10n.totalAhorrado;
  String get todoLoQueAhorrasteEstaOrganizadoEn =>
      _l10n.todoLoQueAhorrasteEstaOrganizadoEn;
  String get logradas => _l10n.logradas;
  String get metasLogradas => _l10n.metasLogradas;
  String get noPudimosCargarTusMetas => _l10n.noPudimosCargarTusMetas;
  String get noPudimosCargarAhorros => _l10n.noPudimosCargarAhorros;
  String get dineroGuardadoSinUnaMetaEspecifica =>
      _l10n.dineroGuardadoSinUnaMetaEspecifica;
  String get creaUnaMetaParaOrganizarMejorTus =>
      _l10n.creaUnaMetaParaOrganizarMejorTus;
  String get excelenteYaAlcanzasteEstaMeta =>
      _l10n.excelenteYaAlcanzasteEstaMeta;
  String get proyeccionDeFinDeMes => _l10n.proyeccionDeFinDeMes;
  String get gastoProyectado => _l10n.gastoProyectado;
  String get usaUnaOpcionClaraParaReconocerMas =>
      _l10n.usaUnaOpcionClaraParaReconocerMas;
  String get iconoSeleccionado => _l10n.iconoSeleccionado;
  String get todaviaTeQuedaPagarOAhorrarPara =>
      _l10n.todaviaTeQuedaPagarOAhorrarPara;
  String get pinLabel => _l10n.pinLabel;
  String get privacySummaryTitle => _l10n.privacySummaryTitle;
  String get privacySummaryBody1 => _l10n.privacySummaryBody1;
  String get privacySummaryBody2 => _l10n.privacySummaryBody2;
  String get privacyStoredDataTitle => _l10n.privacyStoredDataTitle;
  String get privacyStoredDataBody1 => _l10n.privacyStoredDataBody1;
  String get privacyStoredDataBody2 => _l10n.privacyStoredDataBody2;
  String get privacyBiometricsTitle => _l10n.privacyBiometricsTitle;
  String get privacyBiometricsBody1 => _l10n.privacyBiometricsBody1;
  String get privacyBiometricsBody2 => _l10n.privacyBiometricsBody2;
  String get privacyBackupsTitle => _l10n.privacyBackupsTitle;
  String get privacyBackupsBody1 => _l10n.privacyBackupsBody1;
  String get privacyBackupsBody2 => _l10n.privacyBackupsBody2;
  String get privacySharingTitle => _l10n.privacySharingTitle;
  String get privacySharingBody1 => _l10n.privacySharingBody1;
  String get privacySharingBody2 => _l10n.privacySharingBody2;
  String get privacySecurityTitle => _l10n.privacySecurityTitle;
  String get privacySecurityBody1 => _l10n.privacySecurityBody1;
  String get privacySecurityBody2 => _l10n.privacySecurityBody2;
  String get privacyContactTitle => _l10n.privacyContactTitle;
  String get privacyContactBody1 => _l10n.privacyContactBody1;
  String get iconOptionCategory => _l10n.iconOptionCategory;
  String get iconOptionHome => _l10n.iconOptionHome;
  String get iconOptionBolt => _l10n.iconOptionBolt;
  String get iconOptionRestaurant => _l10n.iconOptionRestaurant;
  String get iconOptionCar => _l10n.iconOptionCar;
  String get iconOptionHealth => _l10n.iconOptionHealth;
  String get iconOptionEducation => _l10n.iconOptionEducation;
  String get iconOptionShopping => _l10n.iconOptionShopping;
  String get iconOptionEntertainment => _l10n.iconOptionEntertainment;
  String get iconOptionFinance => _l10n.iconOptionFinance;
  String get iconOptionFamily => _l10n.iconOptionFamily;
  String get iconOptionWork => _l10n.iconOptionWork;
  String get iconOptionPayments => _l10n.iconOptionPayments;
  String get iconOptionStorefront => _l10n.iconOptionStorefront;
  String get iconOptionSavings => _l10n.iconOptionSavings;
  String get iconOptionShield => _l10n.iconOptionShield;
  String get iconOptionFlight => _l10n.iconOptionFlight;
  String get iconOptionPalette => _l10n.iconOptionPalette;
  String get iconOptionKitchen => _l10n.iconOptionKitchen;
  String get iconOptionReceipt => _l10n.iconOptionReceipt;
  String get iconOptionCleaningServices => _l10n.iconOptionCleaningServices;
  String get iconOptionBuild => _l10n.iconOptionBuild;
  String get iconOptionChair => _l10n.iconOptionChair;
  String get iconOptionHandyman => _l10n.iconOptionHandyman;
  String get iconOptionWaterDrop => _l10n.iconOptionWaterDrop;
  String get iconOptionTv => _l10n.iconOptionTv;
  String get iconOptionLocalFireDepartment =>
      _l10n.iconOptionLocalFireDepartment;
  String get iconOptionWifi => _l10n.iconOptionWifi;
  String get iconOptionElectricBolt => _l10n.iconOptionElectricBolt;
  String get iconOptionCloud => _l10n.iconOptionCloud;
  String get iconOptionPlayCircle => _l10n.iconOptionPlayCircle;
  String get iconOptionPhone => _l10n.iconOptionPhone;
  String get iconOptionCoffee => _l10n.iconOptionCoffee;
  String get iconOptionSetMeal => _l10n.iconOptionSetMeal;
  String get iconOptionDeliveryDining => _l10n.iconOptionDeliveryDining;
  String get iconOptionBakeryDining => _l10n.iconOptionBakeryDining;
  String get iconOptionRestaurantMenu => _l10n.iconOptionRestaurantMenu;
  String get iconOptionShoppingCart => _l10n.iconOptionShoppingCart;
  String get iconOptionEco => _l10n.iconOptionEco;
  String get iconOptionLocalGasStation => _l10n.iconOptionLocalGasStation;
  String get iconOptionLocalParking => _l10n.iconOptionLocalParking;
  String get iconOptionToll => _l10n.iconOptionToll;
  String get iconOptionSecurity => _l10n.iconOptionSecurity;
  String get iconOptionLocalTaxi => _l10n.iconOptionLocalTaxi;
  String get iconOptionDirectionsBus => _l10n.iconOptionDirectionsBus;
  String get iconOptionEmojiTransportation =>
      _l10n.iconOptionEmojiTransportation;
  String get iconOptionMedicalServices => _l10n.iconOptionMedicalServices;
  String get iconOptionScience => _l10n.iconOptionScience;
  String get iconOptionMedication => _l10n.iconOptionMedication;
  String get iconOptionHealthAndSafety => _l10n.iconOptionHealthAndSafety;
  String get iconOptionMood => _l10n.iconOptionMood;
  String get iconOptionVisibility => _l10n.iconOptionVisibility;
  String get iconOptionMenuBook => _l10n.iconOptionMenuBook;
  String get iconOptionBook => _l10n.iconOptionBook;
  String get iconOptionEdit => _l10n.iconOptionEdit;
  String get iconOptionSchool => _l10n.iconOptionSchool;
  String get iconOptionHiking => _l10n.iconOptionHiking;
  String get iconOptionLanguage => _l10n.iconOptionLanguage;
  String get iconOptionCardGiftcard => _l10n.iconOptionCardGiftcard;
  String get iconOptionCheckroom => _l10n.iconOptionCheckroom;
  String get iconOptionDevices => _l10n.iconOptionDevices;
  String get iconOptionMovie => _l10n.iconOptionMovie;
  String get iconOptionEvent => _l10n.iconOptionEvent;
  String get iconOptionSportsEsports => _l10n.iconOptionSportsEsports;
  String get iconOptionNightlife => _l10n.iconOptionNightlife;
  String get iconOptionAccountBalanceWallet =>
      _l10n.iconOptionAccountBalanceWallet;
  String get iconOptionReceiptLong => _l10n.iconOptionReceiptLong;
  String get iconOptionPercent => _l10n.iconOptionPercent;
  String get iconOptionBusiness => _l10n.iconOptionBusiness;
  String get iconOptionCreditCard => _l10n.iconOptionCreditCard;
  String get iconOptionSelfImprovement => _l10n.iconOptionSelfImprovement;
  String get iconOptionChildCare => _l10n.iconOptionChildCare;
  String get iconOptionChildFriendly => _l10n.iconOptionChildFriendly;
  String get iconOptionPets => _l10n.iconOptionPets;
  String get iconOptionLunchDining => _l10n.iconOptionLunchDining;
  String get iconOptionCommute => _l10n.iconOptionCommute;
  String get iconOptionVolunteerActivism => _l10n.iconOptionVolunteerActivism;
  String get iconOptionWarning => _l10n.iconOptionWarning;
  String get iconOptionMoreHoriz => _l10n.iconOptionMoreHoriz;
  String get defaultCategoryNameHobbies => _l10n.defaultCategoryNameHobbies;
  String get defaultCategoryNameCompras => _l10n.defaultCategoryNameCompras;
  String get defaultCategoryNameImpuestos => _l10n.defaultCategoryNameImpuestos;
  String get defaultCategoryNameLimpieza => _l10n.defaultCategoryNameLimpieza;
  String get defaultCategoryNameMuebles => _l10n.defaultCategoryNameMuebles;
  String get defaultCategoryNameMantenimientoDelVehiculo =>
      _l10n.defaultCategoryNameMantenimientoDelVehiculo;
  String get defaultCategoryNameMateriales =>
      _l10n.defaultCategoryNameMateriales;
  String get defaultCategoryNameExpensas => _l10n.defaultCategoryNameExpensas;
  String get defaultCategoryNameInternet => _l10n.defaultCategoryNameInternet;
  String get defaultCategoryNameAlquiler => _l10n.defaultCategoryNameAlquiler;
  String get defaultCategoryNamePanaderia => _l10n.defaultCategoryNamePanaderia;
  String get defaultCategoryNameComisionesBancarias =>
      _l10n.defaultCategoryNameComisionesBancarias;
  String get defaultCategoryNameDonaciones =>
      _l10n.defaultCategoryNameDonaciones;
  String get defaultCategoryNameElectrodomesticos =>
      _l10n.defaultCategoryNameElectrodomesticos;
  String get defaultCategoryNameEstacionamiento =>
      _l10n.defaultCategoryNameEstacionamiento;
  String get defaultCategoryNameTransportePublico =>
      _l10n.defaultCategoryNameTransportePublico;
  String get defaultCategoryNameOdontologia =>
      _l10n.defaultCategoryNameOdontologia;
  String get defaultCategoryNameTrabajo => _l10n.defaultCategoryNameTrabajo;
  String get defaultCategoryNameOcio => _l10n.defaultCategoryNameOcio;
  String get defaultCategoryNameVerduleria =>
      _l10n.defaultCategoryNameVerduleria;
  String get defaultCategoryNameSueldo => _l10n.defaultCategoryNameSueldo;
  String get defaultCategoryNameOptica => _l10n.defaultCategoryNameOptica;
  String get defaultCategoryNameUberCabify =>
      _l10n.defaultCategoryNameUberCabify;
  String get defaultCategoryNameCafeteria => _l10n.defaultCategoryNameCafeteria;
  String get defaultCategoryNameRegalos => _l10n.defaultCategoryNameRegalos;
  String get defaultCategoryNameObraSocialPrepaga =>
      _l10n.defaultCategoryNameObraSocialPrepaga;
  String get defaultCategoryNameConsultasMedicas =>
      _l10n.defaultCategoryNameConsultasMedicas;
  String get defaultCategoryNameEstudios => _l10n.defaultCategoryNameEstudios;
  String get defaultCategoryNameCine => _l10n.defaultCategoryNameCine;
  String get defaultCategoryNameAlimentacion =>
      _l10n.defaultCategoryNameAlimentacion;
  String get defaultCategoryNameCuidadoPersonal =>
      _l10n.defaultCategoryNameCuidadoPersonal;
  String get defaultCategoryNameGuarderiaColegio =>
      _l10n.defaultCategoryNameGuarderiaColegio;
  String get defaultCategoryNameHerramientas =>
      _l10n.defaultCategoryNameHerramientas;
  String get defaultCategoryNameCombustible =>
      _l10n.defaultCategoryNameCombustible;
  String get defaultCategoryNameMantenimiento =>
      _l10n.defaultCategoryNameMantenimiento;
  String get defaultCategoryNameLuz => _l10n.defaultCategoryNameLuz;
  String get defaultCategoryNameLibros => _l10n.defaultCategoryNameLibros;
  String get defaultCategoryNameTelefono => _l10n.defaultCategoryNameTelefono;
  String get defaultCategoryNameHijos => _l10n.defaultCategoryNameHijos;
  String get defaultCategoryNameSalidas => _l10n.defaultCategoryNameSalidas;
  String get defaultCategoryNameFinanzas => _l10n.defaultCategoryNameFinanzas;
  String get defaultCategoryNameCuotas => _l10n.defaultCategoryNameCuotas;
  String get defaultCategoryNameServicios => _l10n.defaultCategoryNameServicios;
  String get defaultCategoryNameReparaciones =>
      _l10n.defaultCategoryNameReparaciones;
  String get defaultCategoryNameSuscripcionesEducativas =>
      _l10n.defaultCategoryNameSuscripcionesEducativas;
  String get defaultCategoryNameTaxiRemis => _l10n.defaultCategoryNameTaxiRemis;
  String get defaultCategoryNameDecoracion =>
      _l10n.defaultCategoryNameDecoracion;
  String get defaultCategoryNameTecnologia =>
      _l10n.defaultCategoryNameTecnologia;
  String get defaultCategoryNameSalud => _l10n.defaultCategoryNameSalud;
  String get defaultCategoryNameIntereses => _l10n.defaultCategoryNameIntereses;
  String get defaultCategoryNameJuegos => _l10n.defaultCategoryNameJuegos;
  String get defaultCategoryNameSupermercado =>
      _l10n.defaultCategoryNameSupermercado;
  String get defaultCategoryNameCalzado => _l10n.defaultCategoryNameCalzado;
  String get defaultCategoryNameViaje => _l10n.defaultCategoryNameViaje;
  String get defaultCategoryNameCableTv => _l10n.defaultCategoryNameCableTv;
  String get defaultCategoryNamePeajes => _l10n.defaultCategoryNamePeajes;
  String get defaultCategoryNameVarios => _l10n.defaultCategoryNameVarios;
  String get defaultCategoryNameRestaurantes =>
      _l10n.defaultCategoryNameRestaurantes;
  String get defaultCategoryNameMonotributoAutonomos =>
      _l10n.defaultCategoryNameMonotributoAutonomos;
  String get defaultCategoryNameEventos => _l10n.defaultCategoryNameEventos;
  String get defaultCategoryNameAlimentos => _l10n.defaultCategoryNameAlimentos;
  String get defaultCategoryNameMascotas => _l10n.defaultCategoryNameMascotas;
  String get defaultCategoryNameVacaciones =>
      _l10n.defaultCategoryNameVacaciones;
  String get defaultCategoryNameFondoDeEmergencia =>
      _l10n.defaultCategoryNameFondoDeEmergencia;
  String get defaultCategoryNameMedicamentos =>
      _l10n.defaultCategoryNameMedicamentos;
  String get defaultCategoryNameTransporte =>
      _l10n.defaultCategoryNameTransporte;
  String get defaultCategoryNameImprevistos =>
      _l10n.defaultCategoryNameImprevistos;
  String get defaultCategoryNameCapacitacion =>
      _l10n.defaultCategoryNameCapacitacion;
  String get defaultCategoryNameAgua => _l10n.defaultCategoryNameAgua;
  String get defaultCategoryNameEducacion => _l10n.defaultCategoryNameEducacion;
  String get defaultCategoryNameFreelance => _l10n.defaultCategoryNameFreelance;
  String get defaultCategoryNameTarjetasDeCredito =>
      _l10n.defaultCategoryNameTarjetasDeCredito;
  String get defaultCategoryNameCursos => _l10n.defaultCategoryNameCursos;
  String get defaultCategoryNameRopa => _l10n.defaultCategoryNameRopa;
  String get defaultCategoryNameComprasOnline =>
      _l10n.defaultCategoryNameComprasOnline;
  String get defaultCategoryNameHogar => _l10n.defaultCategoryNameHogar;
  String get defaultCategoryNameSeguroDelAuto =>
      _l10n.defaultCategoryNameSeguroDelAuto;
  String get defaultCategoryNameStreaming => _l10n.defaultCategoryNameStreaming;
  String get defaultCategoryNameGas => _l10n.defaultCategoryNameGas;
  String get defaultCategoryNameVenta => _l10n.defaultCategoryNameVenta;
  String get defaultCategoryNameDelivery => _l10n.defaultCategoryNameDelivery;
  String get defaultCategoryNameCarniceria =>
      _l10n.defaultCategoryNameCarniceria;
  String get defaultCategoryNameNubeApps => _l10n.defaultCategoryNameNubeApps;
  String get defaultCategoryNameFamilia => _l10n.defaultCategoryNameFamilia;
  String get defaultCategoryNameComidasLaborales =>
      _l10n.defaultCategoryNameComidasLaborales;
  String get defaultCategoryNameTransporteLaboral =>
      _l10n.defaultCategoryNameTransporteLaboral;
  String get defaultCategoryNameAhorroGeneral =>
      _l10n.defaultCategoryNameAhorroGeneral;
  String get defaultCategoryNameOtros => _l10n.defaultCategoryNameOtros;
  String get portuguese => _l10n.portuguese;
  String get currencyArsOption => _l10n.currencyArsOption;
  String get currencyUsdOption => _l10n.currencyUsdOption;
  String get currencyEurOption => _l10n.currencyEurOption;

  String movementFormLoadCategoriesError(Object error) =>
      _l10n.movementFormLoadCategoriesError(error);
  String financeInsightOvercommittedMessage(Object percentage) =>
      _l10n.financeInsightOvercommittedMessage(percentage);
  String financeInsightDominantCategoryMessage(
          Object categoryName, Object percentage) =>
      _l10n.financeInsightDominantCategoryMessage(categoryName, percentage);
  String financeInsightExpenseIncreaseMessage(
          Object categoryName, Object percentage) =>
      _l10n.financeInsightExpenseIncreaseMessage(categoryName, percentage);
  String financeInsightExpenseDecreaseMessage(
          Object categoryName, Object percentage) =>
      _l10n.financeInsightExpenseDecreaseMessage(categoryName, percentage);
  String financeInsightEndOfMonthRiskMessage(Object amount) =>
      _l10n.financeInsightEndOfMonthRiskMessage(amount);
  String financeInsightAtypicalExpenseMessage(Object percentage) =>
      _l10n.financeInsightAtypicalExpenseMessage(percentage);
  String financeInsightHealthySavingsMessage(Object percentage) =>
      _l10n.financeInsightHealthySavingsMessage(percentage);
  String financeInsightGoalOnTrackMessage(Object goalName, Object percentage) =>
      _l10n.financeInsightGoalOnTrackMessage(goalName, percentage);
  String authWaitBeforeRetry(Object seconds) =>
      _l10n.authWaitBeforeRetry(seconds);
  String authPinLengthInvalid(Object length) =>
      _l10n.authPinLengthInvalid(length);
  String authLockoutActive(Object seconds) => _l10n.authLockoutActive(seconds);
  String categoriesLoadError(Object error) => _l10n.categoriesLoadError(error);
  String deleteSubcategoryMessage(Object name) =>
      _l10n.deleteSubcategoryMessage(name);
  String deleteCategoryMessage(Object name) =>
      _l10n.deleteCategoryMessage(name);
  String dashboardRemainingPositive(Object amount) =>
      _l10n.dashboardRemainingPositive(amount);
  String dashboardRemainingNegative(Object amount) =>
      _l10n.dashboardRemainingNegative(amount);
  String projectionAverageExpensePace(Object amount, Object days) =>
      _l10n.projectionAverageExpensePace(amount, days);
  String reportsShareOfTotal(Object percentage) =>
      _l10n.reportsShareOfTotal(percentage);
  String reportsPreviousMonth(Object amount) =>
      _l10n.reportsPreviousMonth(amount);
  String savingsGoalProgress(Object saved, Object target) =>
      _l10n.savingsGoalProgress(saved, target);
  String goalAverageContribution(Object amount) =>
      _l10n.goalAverageContribution(amount);
  String goalContributionThisMonth(Object amount) =>
      _l10n.goalContributionThisMonth(amount);
  String goalEstimatedDate(Object date) => _l10n.goalEstimatedDate(date);
  String deleteSavingsGoalMessage(Object name) =>
      _l10n.deleteSavingsGoalMessage(name);
  String savingsGeneralIncluded(Object amount) =>
      _l10n.savingsGeneralIncluded(amount);
  String savingsContributionCount(num count) =>
      _l10n.savingsContributionCount(count);
  String savingsContributionCountWithDate(num count, Object date) =>
      _l10n.savingsContributionCountWithDate(count, date);
  String savingsGoalTargetDate(Object date) =>
      _l10n.savingsGoalTargetDate(date);
  String savingsGoalRemaining(Object amount) =>
      _l10n.savingsGoalRemaining(amount);
  String technicalErrorDetails(Object error) =>
      _l10n.technicalErrorDetails(error);

  String t(String key) {
    return switch (key) {
      'appName' => _l10n.appName,
      'settings' => _l10n.settings,
      'language' => _l10n.language,
      'useDeviceLanguage' => _l10n.useDeviceLanguage,
      'spanish' => _l10n.spanish,
      'english' => _l10n.english,
      'dashboard' => _l10n.dashboard,
      'movements' => _l10n.movements,
      'savings' => _l10n.savings,
      'reports' => _l10n.reports,
      'income' => _l10n.income,
      'expense' => _l10n.expense,
      'saving' => _l10n.saving,
      'category' => _l10n.category,
      'subcategory' => _l10n.subcategory,
      'savingGoal' => _l10n.savingGoal,
      'cancel' => _l10n.cancel,
      'save' => _l10n.save,
      'apply' => _l10n.apply,
      'clear' => _l10n.clear,
      'privacyPolicy' => _l10n.privacyPolicy,
      'paymentMethods' => _l10n.paymentMethods,
      'managePaymentMethods' => _l10n.managePaymentMethods,
      'manageReminders' => _l10n.manageReminders,
      'addPaymentMethod' => _l10n.addPaymentMethod,
      'movementPaymentMethod' => _l10n.movementPaymentMethod,
      'paymentMethodTransfer' => _l10n.paymentMethodTransfer,
      'paymentMethodDebitCard' => _l10n.paymentMethodDebitCard,
      'paymentMethodCreditCard' => _l10n.paymentMethodCreditCard,
      'paymentMethodUnspecified' => _l10n.paymentMethodUnspecified,
      'monthlyReminder' => _l10n.monthlyReminder,
      'monthlyReminderDescription' => _l10n.monthlyReminderDescription,
      'reminderDay' => _l10n.reminderDay,
      'pendingThisMonth' => _l10n.pendingThisMonth,
      'reminderRegisterPayment' => _l10n.reminderRegisterPayment,
      'reminderLastRegistered' => _l10n.reminderLastRegistered,
      'noSubcategory' => _l10n.noSubcategory,
      'newMovement' => _l10n.newMovement,
      'editMovement' => _l10n.editMovement,
      'saveMovement' => _l10n.saveMovement,
      'saveChanges' => _l10n.saveChanges,
      'unlimitedDate' => _l10n.unlimitedDate,
      'biometric' => _l10n.biometric,
      'exportBackup' => _l10n.exportBackup,
      'importBackup' => _l10n.importBackup,
      'manageCategories' => _l10n.manageCategories,
      'noCategories' => _l10n.noCategories,
      'mainCategory' => _l10n.mainCategory,
      'addSubcategory' => _l10n.addSubcategory,
      'manageBudgets' => _l10n.manageBudgets,
      'amountPrivacy' => _l10n.amountPrivacy,
      'amountPrivacyDescription' => _l10n.amountPrivacyDescription,
      'newBudget' => _l10n.newBudget,
      'editBudget' => _l10n.editBudget,
      'monthlyLimit' => _l10n.monthlyLimit,
      'searchByNote' => _l10n.searchByNote,
      'setupTitle' => _l10n.setupTitle,
      'unlockTitle' => _l10n.unlockTitle,
      'recoverAccess' => _l10n.recoverAccess,
      'documentId' => _l10n.documentId,
      'paymentMethodQr' => _l10n.paymentMethodQr,
      'text' => _l10n.text,
      'text2' => _l10n.text2,
      'text3' => _l10n.text3,
      'text4' => _l10n.text4,
      'text5' => _l10n.text5,
      'text6' => _l10n.text6,
      'appearance' => _l10n.appearance,
      'privacy' => _l10n.privacy,
      'security' => _l10n.security,
      'data' => _l10n.data,
      'paymentMethodCash' => _l10n.paymentMethodCash,
      'reminderDayPrefix' => _l10n.reminderDayPrefix,
      'noGoal' => _l10n.noGoal,
      'amount' => _l10n.amount,
      'note' => _l10n.note,
      'type' => _l10n.type,
      'date' => _l10n.date,
      'movement' => _l10n.movement,
      'movementsTab' => _l10n.movementsTab,
      'createGoal' => _l10n.createGoal,
      'newGoal' => _l10n.newGoal,
      'editGoal' => _l10n.editGoal,
      'completed' => _l10n.completed,
      'activeGoals' => _l10n.activeGoals,
      'achieved' => _l10n.achieved,
      'contribute' => _l10n.contribute,
      'defaultCategory' => _l10n.defaultCategory,
      'customCategory' => _l10n.customCategory,
      'budgets' => _l10n.budgets,
      'showAmounts' => _l10n.showAmounts,
      'hideAmounts' => _l10n.hideAmounts,
      'spent' => _l10n.spent,
      'remaining' => _l10n.remaining,
      'lockNow' => _l10n.lockNow,
      'add' => _l10n.add,
      'all' => _l10n.all,
      'from' => _l10n.from,
      'to' => _l10n.to,
      'filters' => _l10n.filters,
      'forgotPin' => _l10n.forgotPin,
      'birthDate' => _l10n.birthDate,
      'todaviaNoHaySuficienteActividadEsteMes' =>
        _l10n.todaviaNoHaySuficienteActividadEsteMes,
      'vasEnCaminoACerrarElMes' => _l10n.vasEnCaminoACerrarElMes,
      'tuRitmoActualPodriaDejarteConMuy' =>
        _l10n.tuRitmoActualPodriaDejarteConMuy,
      'siElGastoSigueAEsteRitmo' => _l10n.siElGastoSigueAEsteRitmo,
      'muySaludable' => _l10n.muySaludable,
      'tuMesVieneEquilibradoYConBuen' => _l10n.tuMesVieneEquilibradoYConBuen,
      'tusNumerosEstanBastanteControladosConAlgunos' =>
        _l10n.tusNumerosEstanBastanteControladosConAlgunos,
      'tuFlujoSigueFuncionandoPeroConvieneAjustar' =>
        _l10n.tuFlujoSigueFuncionandoPeroConvieneAjustar,
      'elRitmoActualPuedeDejarteSinMargen' =>
        _l10n.elRitmoActualPuedeDejarteSinMargen,
      'masDeLoQueEntra' => _l10n.masDeLoQueEntra,
      'mesConMargen' => _l10n.mesConMargen,
      'categoriaDominante' => _l10n.categoriaDominante,
      'cambioBruscoDeGasto' => _l10n.cambioBruscoDeGasto,
      'buenAjuste' => _l10n.buenAjuste,
      'riesgoDeFinDeMes' => _l10n.riesgoDeFinDeMes,
      'ritmoBajoControl' => _l10n.ritmoBajoControl,
      'gastoAtipico' => _l10n.gastoAtipico,
      'ahorroSaludable' => _l10n.ahorroSaludable,
      'sugerenciaSimple' => _l10n.sugerenciaSimple,
      'mesEnMejora' => _l10n.mesEnMejora,
      'mesMasExigente' => _l10n.mesMasExigente,
      'metaEncaminada' => _l10n.metaEncaminada,
      'despuesDeGastarYAhorrarTodaviaTe' =>
        _l10n.despuesDeGastarYAhorrarTodaviaTe,
      'tuProyeccionDeGastoCierraDentroDel' =>
        _l10n.tuProyeccionDeGastoCierraDentroDel,
      'reservarAunqueSeaUn5AlCobrar' => _l10n.reservarAunqueSeaUn5AlCobrar,
      'tuResultadoMensualVieneMejorQueEl' =>
        _l10n.tuResultadoMensualVieneMejorQueEl,
      'tuMargenBajoFrenteAlMesAnterior' =>
        _l10n.tuMargenBajoFrenteAlMesAnterior,
      'actualizaTuRegistro' => _l10n.actualizaTuRegistro,
      'registraUnMovimientoEnSegundos' => _l10n.registraUnMovimientoEnSegundos,
      'usaLenguajeSimpleYDejaSoloLa' => _l10n.usaLenguajeSimpleYDejaSoloLa,
      'elegiQueTipoDeMovimientoQueresRegistrar' =>
        _l10n.elegiQueTipoDeMovimientoQueresRegistrar,
      'ingresaUnMontoValido' => _l10n.ingresaUnMontoValido,
      'elegiUnaCategoria' => _l10n.elegiUnaCategoria,
      'elegiLaCategoriaPrincipal' => _l10n.elegiLaCategoriaPrincipal,
      'subcategoriaOpcional' => _l10n.subcategoriaOpcional,
      'siAplicaElegiUnDetalleMasEspecifico' =>
        _l10n.siAplicaElegiUnDetalleMasEspecifico,
      'vinculaElMovimientoConUnaDeTus' => _l10n.vinculaElMovimientoConUnaDeTus,
      'siGuardasAhoraQuedaraEnAhorroGeneral' =>
        _l10n.siGuardasAhoraQuedaraEnAhorroGeneral,
      'tipSiElegisUnaMetaVasA' => _l10n.tipSiElegisUnaMetaVasA,
      'elegiUnMedioDePago' => _l10n.elegiUnMedioDePago,
      'ejemploCompraSemanalOPagoDeServicio' =>
        _l10n.ejemploCompraSemanalOPagoDeServicio,
      'protegerBackup' => _l10n.protegerBackup,
      'agregaUnaContrasenaOpcionalSiLaDejas' =>
        _l10n.agregaUnaContrasenaOpcionalSiLaDejas,
      'backupLocalDeCleanfinance' => _l10n.backupLocalDeCleanfinance,
      'estaAccionReemplazaraTusDatosLocalesActuales' =>
        _l10n.estaAccionReemplazaraTusDatosLocalesActuales,
      'siEsteBackupFueProtegidoConContrasena' =>
        _l10n.siEsteBackupFueProtegidoConContrasena,
      'datosImportadosCorrectamente' => _l10n.datosImportadosCorrectamente,
      'borrarTodosLosDatos' => _l10n.borrarTodosLosDatos,
      'estoEliminaraLaBaseLocalCompletaEl' =>
        _l10n.estoEliminaraLaBaseLocalCompletaEl,
      'borrarTodo' => _l10n.borrarTodo,
      'seBorraronTodosLosDatosLocalesLa' =>
        _l10n.seBorraronTodosLosDatosLocalesLa,
      'contrasenaOpcional' => _l10n.contrasenaOpcional,
      'unaAppSimplePrivadaYClara' => _l10n.unaAppSimplePrivadaYClara,
      'configuraLaExperienciaParaQueSeSienta' =>
        _l10n.configuraLaExperienciaParaQueSeSienta,
      'manteneAccesoRapidoSinPerderPrivacidad' =>
        _l10n.manteneAccesoRapidoSinPerderPrivacidad,
      'usaHuellaOReconocimientoFacialSiEsta' =>
        _l10n.usaHuellaOReconocimientoFacialSiEsta,
      'esteDispositivoNoTieneBiometriaDisponible' =>
        _l10n.esteDispositivoNoTieneBiometriaDisponible,
      'bloqueoAutomatico' => _l10n.bloqueoAutomatico,
      'revisaQueGuardaCleanfinanceDeFormaLocal' =>
        _l10n.revisaQueGuardaCleanfinanceDeFormaLocal,
      'seguirSistema' => _l10n.seguirSistema,
      'recibiRecordatoriosMensualesEnEsteTelefono' =>
        _l10n.recibiRecordatoriosMensualesEnEsteTelefono,
      'notificacionesDelSistema' => _l10n.notificacionesDelSistema,
      'horaDeRecordatorio' => _l10n.horaDeRecordatorio,
      'personalizaLasListasQueUsasTodosLos' =>
        _l10n.personalizaLasListasQueUsasTodosLos,
      'tusDatosVivenEnTuDispositivoPodes' =>
        _l10n.tusDatosVivenEnTuDispositivoPodes,
      'notaDeSeguridadLosBackupsLocalesPueden' =>
        _l10n.notaDeSeguridadLosBackupsLocalesPueden,
      'privacidadPrimeroNoHayTrackingNoSe' =>
        _l10n.privacidadPrimeroNoHayTrackingNoSe,
      'noSePudieronCargarLosAjustes' => _l10n.noSePudieronCargarLosAjustes,
      'revisandoPermiso' => _l10n.revisandoPermiso,
      'noSePudoRevisarElPermiso' => _l10n.noSePudoRevisarElPermiso,
      'notificacionesDesactivadas' => _l10n.notificacionesDesactivadas,
      'notificacionesActivadas' => _l10n.notificacionesActivadas,
      'permisoPendiente' => _l10n.permisoPendiente,
      'permisoDenegado' => _l10n.permisoDenegado,
      'noDisponibleEnEstaPlataforma' => _l10n.noDisponibleEnEstaPlataforma,
      'errorInesperado' => _l10n.errorInesperado,
      'pinIncorrecto' => _l10n.pinIncorrecto,
      'nuevoPin' => _l10n.nuevoPin,
      'confirmarPin' => _l10n.confirmarPin,
      'validando' => _l10n.validando,
      'empezar' => _l10n.empezar,
      'desbloquear' => _l10n.desbloquear,
      'eliminarPresupuesto' => _l10n.eliminarPresupuesto,
      'eliminar' => _l10n.eliminar,
      'guardando' => _l10n.guardando,
      'reintentar' => _l10n.reintentar,
      'atencion' => _l10n.atencion,
      'excedido' => _l10n.excedido,
      'normal' => _l10n.normal,
      'bajo' => _l10n.bajo,
      'medio' => _l10n.medio,
      'alto' => _l10n.alto,
      'estable' => _l10n.estable,
      'enRiesgo' => _l10n.enRiesgo,
      'eliminarCategoria' => _l10n.eliminarCategoria,
      'nuevaCategoria' => _l10n.nuevaCategoria,
      'editarCategoria' => _l10n.editarCategoria,
      'nombre' => _l10n.nombre,
      'recomendaciones' => _l10n.recomendaciones,
      'movimientosRecientes' => _l10n.movimientosRecientes,
      'recordatoriosDeGastos' => _l10n.recordatoriosDeGastos,
      'recordatoriosDeAhorro' => _l10n.recordatoriosDeAhorro,
      'eliminarMovimiento' => _l10n.eliminarMovimiento,
      'agregarMovimiento' => _l10n.agregarMovimiento,
      'evolucionMensual' => _l10n.evolucionMensual,
      'ritmoDeGasto' => _l10n.ritmoDeGasto,
      'proyeccion' => _l10n.proyeccion,
      'estado' => _l10n.estado,
      'metasDeAhorro' => _l10n.metasDeAhorro,
      'lecturaRapida' => _l10n.lecturaRapida,
      'enRango' => _l10n.enRango,
      'atencion2' => _l10n.atencion2,
      'riesgo' => _l10n.riesgo,
      'nuevo' => _l10n.nuevo,
      'sinEstimacionTodavia' => _l10n.sinEstimacionTodavia,
      'nombreDeLaMeta' => _l10n.nombreDeLaMeta,
      'montoObjetivo' => _l10n.montoObjetivo,
      'guardarMeta' => _l10n.guardarMeta,
      'eliminarMeta' => _l10n.eliminarMeta,
      'ahorroGeneral' => _l10n.ahorroGeneral,
      'objetivo' => _l10n.objetivo,
      'advertenciaElArchivoNoEstaCifrado' =>
        _l10n.advertenciaElArchivoNoEstaCifrado,
      'oneMinute' => _l10n.oneMinute,
      'fiveMinutes' => _l10n.fiveMinutes,
      'fifteenMinutes' => _l10n.fifteenMinutes,
      'thirtyMinutes' => _l10n.thirtyMinutes,
      'tema' => _l10n.tema,
      'claro' => _l10n.claro,
      'oscuro' => _l10n.oscuro,
      'moneda' => _l10n.moneda,
      'notificaciones' => _l10n.notificaciones,
      'organizacion' => _l10n.organizacion,
      'netoEstimado' => _l10n.netoEstimado,
      'icono' => _l10n.icono,
      'tocaParaCambiar' => _l10n.tocaParaCambiar,
      'elegiUnIcono' => _l10n.elegiUnIcono,
      'seleccionar' => _l10n.seleccionar,
      'total' => _l10n.total,
      'movementFormMissingCategory' => _l10n.movementFormMissingCategory,
      'authRecoveryDocumentExample' => _l10n.authRecoveryDocumentExample,
      'authUseBiometrics' => _l10n.authUseBiometrics,
      'authUnlockWithPinOrBiometrics' => _l10n.authUnlockWithPinOrBiometrics,
      'authBiometricsEnabledTip' => _l10n.authBiometricsEnabledTip,
      'authBiometricsUnavailablePinProtected' =>
        _l10n.authBiometricsUnavailablePinProtected,
      'estaCategoria' => _l10n.estaCategoria,
      'tuMeta' => _l10n.tuMeta,
      'revisaTusDatosDeRecuperacionEIntenta' =>
        _l10n.revisaTusDatosDeRecuperacionEIntenta,
      'laBiometriaNoEstaDisponibleEnEste' =>
        _l10n.laBiometriaNoEstaDisponibleEnEste,
      'noSePudoUsarLaBiometriaConfigura' =>
        _l10n.noSePudoUsarLaBiometriaConfigura,
      'noSePudoValidarLaBiometriaVerifica' =>
        _l10n.noSePudoValidarLaBiometriaVerifica,
      'noSePudoVerificarLaRecuperacionRevisa' =>
        _l10n.noSePudoVerificarLaRecuperacionRevisa,
      'algunasValidacionesDeSeguridadNoPudieronInicializarse' =>
        _l10n.algunasValidacionesDeSeguridadNoPudieronInicializarse,
      'completaAmbasRespuestasDeRecuperacion' =>
        _l10n.completaAmbasRespuestasDeRecuperacion,
      'usaUnaFechaValidaYUnDocumento' => _l10n.usaUnaFechaValidaYUnDocumento,
      'losPinNoCoinciden' => _l10n.losPinNoCoinciden,
      'recuperaTuAccesoSinComplicarte' => _l10n.recuperaTuAccesoSinComplicarte,
      'respondeTusDosPreguntasPersonalesYElegi' =>
        _l10n.respondeTusDosPreguntasPersonalesYElegi,
      'laRecuperacionLocalEsMenosRobustaQue' =>
        _l10n.laRecuperacionLocalEsMenosRobustaQue,
      'ejemplo10021996' => _l10n.ejemplo10021996,
      'activarHuellaParaProximosAccesos' =>
        _l10n.activarHuellaParaProximosAccesos,
      'asiVasAPoderEntrarMasRapido' => _l10n.asiVasAPoderEntrarMasRapido,
      'completaTusDosPreguntasDeRecuperacion' =>
        _l10n.completaTusDosPreguntasDeRecuperacion,
      'creaUnPinCortoParaProtegerTus' => _l10n.creaUnPinCortoParaProtegerTus,
      'elegiTuPin' => _l10n.elegiTuPin,
      'repetiTuPin' => _l10n.repetiTuPin,
      'activarHuellaParaEntrarMasRapido' =>
        _l10n.activarHuellaParaEntrarMasRapido,
      'laAppTeLaVaAOfrecer' => _l10n.laAppTeLaVaAOfrecer,
      'configurando' => _l10n.configurando,
      'guardamosEstasRespuestasSoloParaAyudarteA' =>
        _l10n.guardamosEstasRespuestasSoloParaAyudarteA,
      'lasRespuestasDeRecuperacionSonMasDebiles' =>
        _l10n.lasRespuestasDeRecuperacionSonMasDebiles,
      'estePresupuestoMensualSeEliminaraYEl' =>
        _l10n.estePresupuestoMensualSeEliminaraYEl,
      'seleccionaUnaCategoria' => _l10n.seleccionaUnaCategoria,
      'primeroCreaUnaCategoriaDeGasto' => _l10n.primeroCreaUnaCategoriaDeGasto,
      'losPresupuestosSeCreanAPartirDe' =>
        _l10n.losPresupuestosSeCreanAPartirDe,
      'ajustaEstePresupuestoMensual' => _l10n.ajustaEstePresupuestoMensual,
      'creaUnPresupuestoMensualPorCategoria' =>
        _l10n.creaUnPresupuestoMensualPorCategoria,
      'losPresupuestosSeGuardanLocalmenteYSe' =>
        _l10n.losPresupuestosSeGuardanLocalmenteYSe,
      'elegiLaCategoriaDeGastoParaEste' =>
        _l10n.elegiLaCategoriaDeGastoParaEste,
      'ingresaUnLimiteMensualValido' => _l10n.ingresaUnLimiteMensualValido,
      'presupuestosMensuales' => _l10n.presupuestosMensuales,
      'seguiComoVieneCadaCategoriaEsteMes' =>
        _l10n.seguiComoVieneCadaCategoriaEsteMes,
      'creaTuPrimerPresupuesto' => _l10n.creaTuPrimerPresupuesto,
      'definiUnLimiteMensualParaUnaCategoria' =>
        _l10n.definiUnLimiteMensualParaUnaCategoria,
      'agregarPresupuesto' => _l10n.agregarPresupuesto,
      'noSePudieronCargarLosPresupuestos' =>
        _l10n.noSePudieronCargarLosPresupuestos,
      'eliminarSubcategoria' => _l10n.eliminarSubcategoria,
      'categoriaPadre' => _l10n.categoriaPadre,
      'sinCategoriaPadre' => _l10n.sinCategoriaPadre,
      'elegiUnaCategoriaPrincipalSoloSiQueres' =>
        _l10n.elegiUnaCategoriaPrincipalSoloSiQueres,
      'usaEstaSubcategoriaParaServiciosOGastos' =>
        _l10n.usaEstaSubcategoriaParaServiciosOGastos,
      'saldoActual' => _l10n.saldoActual,
      'ahorroTotal' => _l10n.ahorroTotal,
      'todaviaNoHayRecomendaciones' => _l10n.todaviaNoHayRecomendaciones,
      'cargaAlgunosMovimientosParaVerAlertasY' =>
        _l10n.cargaAlgunosMovimientosParaVerAlertasY,
      'ingresosVsGastos' => _l10n.ingresosVsGastos,
      'unaLecturaRapidaDeComoVieneEl' => _l10n.unaLecturaRapidaDeComoVieneEl,
      'comparaTusIngresosYGastosDeLos' => _l10n.comparaTusIngresosYGastosDeLos,
      'gastosPorCategoria' => _l10n.gastosPorCategoria,
      'simpleClaroYFacilDeLeer' => _l10n.simpleClaroYFacilDeLeer,
      'todaviaNoHayGastosSuficientes' => _l10n.todaviaNoHayGastosSuficientes,
      'cuandoRegistresGastosVasAVerTus' =>
        _l10n.cuandoRegistresGastosVasAVerTus,
      'agregarGasto' => _l10n.agregarGasto,
      'empezaConTuPrimerMovimiento' => _l10n.empezaConTuPrimerMovimiento,
      'cargarGastosEIngresosTeVaA' => _l10n.cargarGastosEIngresosTeVaA,
      'noPudimosCargarElInicio' => _l10n.noPudimosCargarElInicio,
      'sinCategoria' => _l10n.sinCategoria,
      'revisaTusRecordatoriosMensualesActivos' =>
        _l10n.revisaTusRecordatoriosMensualesActivos,
      'losRecordatoriosDeGastoSalenDeSubcategorias' =>
        _l10n.losRecordatoriosDeGastoSalenDeSubcategorias,
      'noHayRecordatoriosDeGastoActivos' =>
        _l10n.noHayRecordatoriosDeGastoActivos,
      'activaRecordatoriosAlCrearOEditarUna' =>
        _l10n.activaRecordatoriosAlCrearOEditarUna,
      'noSePudieronCargarLosRecordatoriosDe' =>
        _l10n.noSePudieronCargarLosRecordatoriosDe,
      'noHayRecordatoriosDeAhorroActivos' =>
        _l10n.noHayRecordatoriosDeAhorroActivos,
      'activaRecordatoriosAlCrearOEditarUna2' =>
        _l10n.activaRecordatoriosAlCrearOEditarUna2,
      'metaCompletada' => _l10n.metaCompletada,
      'noSePudieronCargarLosRecordatoriosDe2' =>
        _l10n.noSePudieronCargarLosRecordatoriosDe2,
      'elegiElDiaDelMesParaEl' => _l10n.elegiElDiaDelMesParaEl,
      'seEliminaraEsteMovimientoDeFormaPermanente' =>
        _l10n.seEliminaraEsteMovimientoDeFormaPermanente,
      'elegiSoloLoNecesarioParaEncontrarRapido' =>
        _l10n.elegiSoloLoNecesarioParaEncontrarRapido,
      'filtraPorUnaCategoriaPrincipalParaAcotar' =>
        _l10n.filtraPorUnaCategoriaPrincipalParaAcotar,
      'noEncontramosMovimientos' => _l10n.noEncontramosMovimientos,
      'probaCambiandoElFiltroOAgregandoUn' =>
        _l10n.probaCambiandoElFiltroOAgregandoUn,
      'noSePudieronCargarLosMovimientos' =>
        _l10n.noSePudieronCargarLosMovimientos,
      'editarMedioDePago' => _l10n.editarMedioDePago,
      'ejemploQrTransferenciaOEfectivo' =>
        _l10n.ejemploQrTransferenciaOEfectivo,
      'elegiSoloLosMediosDePagoQue' => _l10n.elegiSoloLosMediosDePagoQue,
      'estasOpcionesVanAAparecerComoDesplegable' =>
        _l10n.estasOpcionesVanAAparecerComoDesplegable,
      'todaviaNoHayMediosDePago' => _l10n.todaviaNoHayMediosDePago,
      'agregaTusOpcionesHabitualesComoTransferenciaDebito' =>
        _l10n.agregaTusOpcionesHabitualesComoTransferenciaDebito,
      'saludFinanciera' => _l10n.saludFinanciera,
      'cashflowMensual' => _l10n.cashflowMensual,
      'unResumenRapidoParaEntenderCuantoEntro' =>
        _l10n.unResumenRapidoParaEntenderCuantoEntro,
      'saldoNeto' => _l10n.saldoNeto,
      'comparaComoVienenTusIngresosYGastos' =>
        _l10n.comparaComoVienenTusIngresosYGastos,
      'topCategoriasDelMes' => _l10n.topCategoriasDelMes,
      'vasAVerEnQueSeFue' => _l10n.vasAVerEnQueSeFue,
      'sinDatosTodavia' => _l10n.sinDatosTodavia,
      'cuandoRegistresGastosVasAVerAca' =>
        _l10n.cuandoRegistresGastosVasAVerAca,
      'teMuestraSiElGastoAcumuladoVa' => _l10n.teMuestraSiElGastoAcumuladoVa,
      'esperadoHoy' => _l10n.esperadoHoy,
      'elRitmoActualEsExigenteParaTu' => _l10n.elRitmoActualEsExigenteParaTu,
      'vasCercaDelLimiteConvieneMirarCon' =>
        _l10n.vasCercaDelLimiteConvieneMirarCon,
      'tuGastoVieneEnUnaZonaSaludable' => _l10n.tuGastoVieneEnUnaZonaSaludable,
      'seguimientoSimpleDelAvanceRitmoDeAporte' =>
        _l10n.seguimientoSimpleDelAvanceRitmoDeAporte,
      'todaviaNoHayMetasParaAnalizar' => _l10n.todaviaNoHayMetasParaAnalizar,
      'cuandoTengasMetasYAportesVasA' => _l10n.cuandoTengasMetasYAportesVasA,
      'gastosPorMedioDePago' => _l10n.gastosPorMedioDePago,
      'teAyudaAVerQueMetodoEstas' => _l10n.teAyudaAVerQueMetodoEstas,
      'noSePudieronCargarLosReportes' => _l10n.noSePudieronCargarLosReportes,
      'elegiUnDiaDeRecordatorioValido' => _l10n.elegiUnDiaDeRecordatorioValido,
      'definiUnaMetaSimpleYVisible' => _l10n.definiUnaMetaSimpleYVisible,
      'nombreClaroMontoObjetivoYFechaOpcional' =>
        _l10n.nombreClaroMontoObjetivoYFechaOpcional,
      'ingresaUnNombre' => _l10n.ingresaUnNombre,
      'agregarFechaObjetivo' => _l10n.agregarFechaObjetivo,
      'teAyudaANoOlvidarteDelAporte' => _l10n.teAyudaANoOlvidarteDelAporte,
      'elegiElDiaDelMesEnEl' => _l10n.elegiElDiaDelMesEnEl,
      'todaviaNoTenesAhorroRegistrado' => _l10n.todaviaNoTenesAhorroRegistrado,
      'creaUnaMetaORegistraUnAporte' => _l10n.creaUnaMetaORegistraUnAporte,
      'totalAhorrado' => _l10n.totalAhorrado,
      'todoLoQueAhorrasteEstaOrganizadoEn' =>
        _l10n.todoLoQueAhorrasteEstaOrganizadoEn,
      'logradas' => _l10n.logradas,
      'metasLogradas' => _l10n.metasLogradas,
      'noPudimosCargarTusMetas' => _l10n.noPudimosCargarTusMetas,
      'noPudimosCargarAhorros' => _l10n.noPudimosCargarAhorros,
      'dineroGuardadoSinUnaMetaEspecifica' =>
        _l10n.dineroGuardadoSinUnaMetaEspecifica,
      'creaUnaMetaParaOrganizarMejorTus' =>
        _l10n.creaUnaMetaParaOrganizarMejorTus,
      'excelenteYaAlcanzasteEstaMeta' => _l10n.excelenteYaAlcanzasteEstaMeta,
      'proyeccionDeFinDeMes' => _l10n.proyeccionDeFinDeMes,
      'gastoProyectado' => _l10n.gastoProyectado,
      'usaUnaOpcionClaraParaReconocerMas' =>
        _l10n.usaUnaOpcionClaraParaReconocerMas,
      'iconoSeleccionado' => _l10n.iconoSeleccionado,
      'todaviaTeQuedaPagarOAhorrarPara' =>
        _l10n.todaviaTeQuedaPagarOAhorrarPara,
      'pinLabel' => _l10n.pinLabel,
      'privacySummaryTitle' => _l10n.privacySummaryTitle,
      'privacySummaryBody1' => _l10n.privacySummaryBody1,
      'privacySummaryBody2' => _l10n.privacySummaryBody2,
      'privacyStoredDataTitle' => _l10n.privacyStoredDataTitle,
      'privacyStoredDataBody1' => _l10n.privacyStoredDataBody1,
      'privacyStoredDataBody2' => _l10n.privacyStoredDataBody2,
      'privacyBiometricsTitle' => _l10n.privacyBiometricsTitle,
      'privacyBiometricsBody1' => _l10n.privacyBiometricsBody1,
      'privacyBiometricsBody2' => _l10n.privacyBiometricsBody2,
      'privacyBackupsTitle' => _l10n.privacyBackupsTitle,
      'privacyBackupsBody1' => _l10n.privacyBackupsBody1,
      'privacyBackupsBody2' => _l10n.privacyBackupsBody2,
      'privacySharingTitle' => _l10n.privacySharingTitle,
      'privacySharingBody1' => _l10n.privacySharingBody1,
      'privacySharingBody2' => _l10n.privacySharingBody2,
      'privacySecurityTitle' => _l10n.privacySecurityTitle,
      'privacySecurityBody1' => _l10n.privacySecurityBody1,
      'privacySecurityBody2' => _l10n.privacySecurityBody2,
      'privacyContactTitle' => _l10n.privacyContactTitle,
      'privacyContactBody1' => _l10n.privacyContactBody1,
      'iconOptionCategory' => _l10n.iconOptionCategory,
      'iconOptionHome' => _l10n.iconOptionHome,
      'iconOptionBolt' => _l10n.iconOptionBolt,
      'iconOptionRestaurant' => _l10n.iconOptionRestaurant,
      'iconOptionCar' => _l10n.iconOptionCar,
      'iconOptionHealth' => _l10n.iconOptionHealth,
      'iconOptionEducation' => _l10n.iconOptionEducation,
      'iconOptionShopping' => _l10n.iconOptionShopping,
      'iconOptionEntertainment' => _l10n.iconOptionEntertainment,
      'iconOptionFinance' => _l10n.iconOptionFinance,
      'iconOptionFamily' => _l10n.iconOptionFamily,
      'iconOptionWork' => _l10n.iconOptionWork,
      'iconOptionPayments' => _l10n.iconOptionPayments,
      'iconOptionStorefront' => _l10n.iconOptionStorefront,
      'iconOptionSavings' => _l10n.iconOptionSavings,
      'iconOptionShield' => _l10n.iconOptionShield,
      'iconOptionFlight' => _l10n.iconOptionFlight,
      'iconOptionPalette' => _l10n.iconOptionPalette,
      'iconOptionKitchen' => _l10n.iconOptionKitchen,
      'iconOptionReceipt' => _l10n.iconOptionReceipt,
      'iconOptionCleaningServices' => _l10n.iconOptionCleaningServices,
      'iconOptionBuild' => _l10n.iconOptionBuild,
      'iconOptionChair' => _l10n.iconOptionChair,
      'iconOptionHandyman' => _l10n.iconOptionHandyman,
      'iconOptionWaterDrop' => _l10n.iconOptionWaterDrop,
      'iconOptionTv' => _l10n.iconOptionTv,
      'iconOptionLocalFireDepartment' => _l10n.iconOptionLocalFireDepartment,
      'iconOptionWifi' => _l10n.iconOptionWifi,
      'iconOptionElectricBolt' => _l10n.iconOptionElectricBolt,
      'iconOptionCloud' => _l10n.iconOptionCloud,
      'iconOptionPlayCircle' => _l10n.iconOptionPlayCircle,
      'iconOptionPhone' => _l10n.iconOptionPhone,
      'iconOptionCoffee' => _l10n.iconOptionCoffee,
      'iconOptionSetMeal' => _l10n.iconOptionSetMeal,
      'iconOptionDeliveryDining' => _l10n.iconOptionDeliveryDining,
      'iconOptionBakeryDining' => _l10n.iconOptionBakeryDining,
      'iconOptionRestaurantMenu' => _l10n.iconOptionRestaurantMenu,
      'iconOptionShoppingCart' => _l10n.iconOptionShoppingCart,
      'iconOptionEco' => _l10n.iconOptionEco,
      'iconOptionLocalGasStation' => _l10n.iconOptionLocalGasStation,
      'iconOptionLocalParking' => _l10n.iconOptionLocalParking,
      'iconOptionToll' => _l10n.iconOptionToll,
      'iconOptionSecurity' => _l10n.iconOptionSecurity,
      'iconOptionLocalTaxi' => _l10n.iconOptionLocalTaxi,
      'iconOptionDirectionsBus' => _l10n.iconOptionDirectionsBus,
      'iconOptionEmojiTransportation' => _l10n.iconOptionEmojiTransportation,
      'iconOptionMedicalServices' => _l10n.iconOptionMedicalServices,
      'iconOptionScience' => _l10n.iconOptionScience,
      'iconOptionMedication' => _l10n.iconOptionMedication,
      'iconOptionHealthAndSafety' => _l10n.iconOptionHealthAndSafety,
      'iconOptionMood' => _l10n.iconOptionMood,
      'iconOptionVisibility' => _l10n.iconOptionVisibility,
      'iconOptionMenuBook' => _l10n.iconOptionMenuBook,
      'iconOptionBook' => _l10n.iconOptionBook,
      'iconOptionEdit' => _l10n.iconOptionEdit,
      'iconOptionSchool' => _l10n.iconOptionSchool,
      'iconOptionHiking' => _l10n.iconOptionHiking,
      'iconOptionLanguage' => _l10n.iconOptionLanguage,
      'iconOptionCardGiftcard' => _l10n.iconOptionCardGiftcard,
      'iconOptionCheckroom' => _l10n.iconOptionCheckroom,
      'iconOptionDevices' => _l10n.iconOptionDevices,
      'iconOptionMovie' => _l10n.iconOptionMovie,
      'iconOptionEvent' => _l10n.iconOptionEvent,
      'iconOptionSportsEsports' => _l10n.iconOptionSportsEsports,
      'iconOptionNightlife' => _l10n.iconOptionNightlife,
      'iconOptionAccountBalanceWallet' => _l10n.iconOptionAccountBalanceWallet,
      'iconOptionReceiptLong' => _l10n.iconOptionReceiptLong,
      'iconOptionPercent' => _l10n.iconOptionPercent,
      'iconOptionBusiness' => _l10n.iconOptionBusiness,
      'iconOptionCreditCard' => _l10n.iconOptionCreditCard,
      'iconOptionSelfImprovement' => _l10n.iconOptionSelfImprovement,
      'iconOptionChildCare' => _l10n.iconOptionChildCare,
      'iconOptionChildFriendly' => _l10n.iconOptionChildFriendly,
      'iconOptionPets' => _l10n.iconOptionPets,
      'iconOptionLunchDining' => _l10n.iconOptionLunchDining,
      'iconOptionCommute' => _l10n.iconOptionCommute,
      'iconOptionVolunteerActivism' => _l10n.iconOptionVolunteerActivism,
      'iconOptionWarning' => _l10n.iconOptionWarning,
      'iconOptionMoreHoriz' => _l10n.iconOptionMoreHoriz,
      'defaultCategoryNameHobbies' => _l10n.defaultCategoryNameHobbies,
      'defaultCategoryNameCompras' => _l10n.defaultCategoryNameCompras,
      'defaultCategoryNameImpuestos' => _l10n.defaultCategoryNameImpuestos,
      'defaultCategoryNameLimpieza' => _l10n.defaultCategoryNameLimpieza,
      'defaultCategoryNameMuebles' => _l10n.defaultCategoryNameMuebles,
      'defaultCategoryNameMantenimientoDelVehiculo' =>
        _l10n.defaultCategoryNameMantenimientoDelVehiculo,
      'defaultCategoryNameMateriales' => _l10n.defaultCategoryNameMateriales,
      'defaultCategoryNameExpensas' => _l10n.defaultCategoryNameExpensas,
      'defaultCategoryNameInternet' => _l10n.defaultCategoryNameInternet,
      'defaultCategoryNameAlquiler' => _l10n.defaultCategoryNameAlquiler,
      'defaultCategoryNamePanaderia' => _l10n.defaultCategoryNamePanaderia,
      'defaultCategoryNameComisionesBancarias' =>
        _l10n.defaultCategoryNameComisionesBancarias,
      'defaultCategoryNameDonaciones' => _l10n.defaultCategoryNameDonaciones,
      'defaultCategoryNameElectrodomesticos' =>
        _l10n.defaultCategoryNameElectrodomesticos,
      'defaultCategoryNameEstacionamiento' =>
        _l10n.defaultCategoryNameEstacionamiento,
      'defaultCategoryNameTransportePublico' =>
        _l10n.defaultCategoryNameTransportePublico,
      'defaultCategoryNameOdontologia' => _l10n.defaultCategoryNameOdontologia,
      'defaultCategoryNameTrabajo' => _l10n.defaultCategoryNameTrabajo,
      'defaultCategoryNameOcio' => _l10n.defaultCategoryNameOcio,
      'defaultCategoryNameVerduleria' => _l10n.defaultCategoryNameVerduleria,
      'defaultCategoryNameSueldo' => _l10n.defaultCategoryNameSueldo,
      'defaultCategoryNameOptica' => _l10n.defaultCategoryNameOptica,
      'defaultCategoryNameUberCabify' => _l10n.defaultCategoryNameUberCabify,
      'defaultCategoryNameCafeteria' => _l10n.defaultCategoryNameCafeteria,
      'defaultCategoryNameRegalos' => _l10n.defaultCategoryNameRegalos,
      'defaultCategoryNameObraSocialPrepaga' =>
        _l10n.defaultCategoryNameObraSocialPrepaga,
      'defaultCategoryNameConsultasMedicas' =>
        _l10n.defaultCategoryNameConsultasMedicas,
      'defaultCategoryNameEstudios' => _l10n.defaultCategoryNameEstudios,
      'defaultCategoryNameCine' => _l10n.defaultCategoryNameCine,
      'defaultCategoryNameAlimentacion' =>
        _l10n.defaultCategoryNameAlimentacion,
      'defaultCategoryNameCuidadoPersonal' =>
        _l10n.defaultCategoryNameCuidadoPersonal,
      'defaultCategoryNameGuarderiaColegio' =>
        _l10n.defaultCategoryNameGuarderiaColegio,
      'defaultCategoryNameHerramientas' =>
        _l10n.defaultCategoryNameHerramientas,
      'defaultCategoryNameCombustible' => _l10n.defaultCategoryNameCombustible,
      'defaultCategoryNameMantenimiento' =>
        _l10n.defaultCategoryNameMantenimiento,
      'defaultCategoryNameLuz' => _l10n.defaultCategoryNameLuz,
      'defaultCategoryNameLibros' => _l10n.defaultCategoryNameLibros,
      'defaultCategoryNameTelefono' => _l10n.defaultCategoryNameTelefono,
      'defaultCategoryNameHijos' => _l10n.defaultCategoryNameHijos,
      'defaultCategoryNameSalidas' => _l10n.defaultCategoryNameSalidas,
      'defaultCategoryNameFinanzas' => _l10n.defaultCategoryNameFinanzas,
      'defaultCategoryNameCuotas' => _l10n.defaultCategoryNameCuotas,
      'defaultCategoryNameServicios' => _l10n.defaultCategoryNameServicios,
      'defaultCategoryNameReparaciones' =>
        _l10n.defaultCategoryNameReparaciones,
      'defaultCategoryNameSuscripcionesEducativas' =>
        _l10n.defaultCategoryNameSuscripcionesEducativas,
      'defaultCategoryNameTaxiRemis' => _l10n.defaultCategoryNameTaxiRemis,
      'defaultCategoryNameDecoracion' => _l10n.defaultCategoryNameDecoracion,
      'defaultCategoryNameTecnologia' => _l10n.defaultCategoryNameTecnologia,
      'defaultCategoryNameSalud' => _l10n.defaultCategoryNameSalud,
      'defaultCategoryNameIntereses' => _l10n.defaultCategoryNameIntereses,
      'defaultCategoryNameJuegos' => _l10n.defaultCategoryNameJuegos,
      'defaultCategoryNameSupermercado' =>
        _l10n.defaultCategoryNameSupermercado,
      'defaultCategoryNameCalzado' => _l10n.defaultCategoryNameCalzado,
      'defaultCategoryNameViaje' => _l10n.defaultCategoryNameViaje,
      'defaultCategoryNameCableTv' => _l10n.defaultCategoryNameCableTv,
      'defaultCategoryNamePeajes' => _l10n.defaultCategoryNamePeajes,
      'defaultCategoryNameVarios' => _l10n.defaultCategoryNameVarios,
      'defaultCategoryNameRestaurantes' =>
        _l10n.defaultCategoryNameRestaurantes,
      'defaultCategoryNameMonotributoAutonomos' =>
        _l10n.defaultCategoryNameMonotributoAutonomos,
      'defaultCategoryNameEventos' => _l10n.defaultCategoryNameEventos,
      'defaultCategoryNameAlimentos' => _l10n.defaultCategoryNameAlimentos,
      'defaultCategoryNameMascotas' => _l10n.defaultCategoryNameMascotas,
      'defaultCategoryNameVacaciones' => _l10n.defaultCategoryNameVacaciones,
      'defaultCategoryNameFondoDeEmergencia' =>
        _l10n.defaultCategoryNameFondoDeEmergencia,
      'defaultCategoryNameMedicamentos' =>
        _l10n.defaultCategoryNameMedicamentos,
      'defaultCategoryNameTransporte' => _l10n.defaultCategoryNameTransporte,
      'defaultCategoryNameImprevistos' => _l10n.defaultCategoryNameImprevistos,
      'defaultCategoryNameCapacitacion' =>
        _l10n.defaultCategoryNameCapacitacion,
      'defaultCategoryNameAgua' => _l10n.defaultCategoryNameAgua,
      'defaultCategoryNameEducacion' => _l10n.defaultCategoryNameEducacion,
      'defaultCategoryNameFreelance' => _l10n.defaultCategoryNameFreelance,
      'defaultCategoryNameTarjetasDeCredito' =>
        _l10n.defaultCategoryNameTarjetasDeCredito,
      'defaultCategoryNameCursos' => _l10n.defaultCategoryNameCursos,
      'defaultCategoryNameRopa' => _l10n.defaultCategoryNameRopa,
      'defaultCategoryNameComprasOnline' =>
        _l10n.defaultCategoryNameComprasOnline,
      'defaultCategoryNameHogar' => _l10n.defaultCategoryNameHogar,
      'defaultCategoryNameSeguroDelAuto' =>
        _l10n.defaultCategoryNameSeguroDelAuto,
      'defaultCategoryNameStreaming' => _l10n.defaultCategoryNameStreaming,
      'defaultCategoryNameGas' => _l10n.defaultCategoryNameGas,
      'defaultCategoryNameVenta' => _l10n.defaultCategoryNameVenta,
      'defaultCategoryNameDelivery' => _l10n.defaultCategoryNameDelivery,
      'defaultCategoryNameCarniceria' => _l10n.defaultCategoryNameCarniceria,
      'defaultCategoryNameNubeApps' => _l10n.defaultCategoryNameNubeApps,
      'defaultCategoryNameFamilia' => _l10n.defaultCategoryNameFamilia,
      'defaultCategoryNameComidasLaborales' =>
        _l10n.defaultCategoryNameComidasLaborales,
      'defaultCategoryNameTransporteLaboral' =>
        _l10n.defaultCategoryNameTransporteLaboral,
      'defaultCategoryNameAhorroGeneral' =>
        _l10n.defaultCategoryNameAhorroGeneral,
      'defaultCategoryNameOtros' => _l10n.defaultCategoryNameOtros,
      'portuguese' => _l10n.portuguese,
      _ => key,
    };
  }

  String paymentMethodDisplayName(String value) {
    final canonical = PaymentMethodUtils.canonicalizeLabel(value);
    return switch (canonical) {
      PaymentMethodUtils.transfer => paymentMethodTransfer,
      PaymentMethodUtils.debitCard => paymentMethodDebitCard,
      PaymentMethodUtils.creditCard => paymentMethodCreditCard,
      PaymentMethodUtils.cash => paymentMethodCash,
      PaymentMethodUtils.qr => paymentMethodQr,
      PaymentMethodUtils.unspecified => paymentMethodUnspecified,
      _ => value.trim(),
    };
  }
}
