// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CleanFinance';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get useDeviceLanguage => 'Use device language';

  @override
  String get spanish => 'Spanish';

  @override
  String get english => 'English';

  @override
  String get dashboard => 'Home';

  @override
  String get movements => 'Movements';

  @override
  String get savings => 'Savings';

  @override
  String get reports => 'Reports';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get saving => 'Saving';

  @override
  String get category => 'Category';

  @override
  String get subcategory => 'Subcategory';

  @override
  String get savingGoal => 'Savings goal';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get apply => 'Apply';

  @override
  String get clear => 'Clear';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get paymentMethods => 'Payment methods';

  @override
  String get managePaymentMethods => 'Manage payment methods';

  @override
  String get manageReminders => 'Manage reminders';

  @override
  String get addPaymentMethod => 'Add payment method';

  @override
  String get movementPaymentMethod => 'Payment method';

  @override
  String get paymentMethodTransfer => 'Bank transfer';

  @override
  String get paymentMethodDebitCard => 'Debit card';

  @override
  String get paymentMethodCreditCard => 'Credit card';

  @override
  String get paymentMethodUnspecified => 'Unspecified';

  @override
  String get monthlyReminder => 'Monthly reminder';

  @override
  String get monthlyReminderDescription =>
      'Use this for recurring monthly expenses so they appear as pending until you register the payment.';

  @override
  String get movementReminderTitle =>
      'Remind me about this expense every month';

  @override
  String get movementReminderSubtitle =>
      'We will notify you near the day of this transaction.';

  @override
  String get movementReminderActive => 'Reminder active';

  @override
  String get movementReminderDisabled => 'Reminder disabled';

  @override
  String movementReminderMonthlyDay(Object day) {
    return 'Day $day of every month';
  }

  @override
  String get movementReminderSettingsHint =>
      'You can also change this reminder from Settings.';

  @override
  String get reminderDay => 'Reminder day';

  @override
  String get pendingThisMonth => 'Pending this month';

  @override
  String get reminderRegisterPayment => 'Register payment';

  @override
  String get reminderLastRegistered => 'Last registered';

  @override
  String get noSubcategory => 'No subcategory';

  @override
  String get newMovement => 'New movement';

  @override
  String get editMovement => 'Edit movement';

  @override
  String get saveMovement => 'Save movement';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get unlimitedDate => 'No deadline';

  @override
  String get biometric => 'Biometric unlock';

  @override
  String get exportBackup => 'Export backup';

  @override
  String get importBackup => 'Import backup';

  @override
  String get manageCategories => 'Manage categories';

  @override
  String get noCategories => 'No categories yet.';

  @override
  String get mainCategory => 'Main category';

  @override
  String get addSubcategory => 'Add subcategory';

  @override
  String get manageBudgets => 'Manage budgets';

  @override
  String get amountPrivacy => 'Amount privacy';

  @override
  String get amountPrivacyDescription =>
      'Hide balances and summaries when using the app in public.';

  @override
  String get newBudget => 'New budget';

  @override
  String get editBudget => 'Edit budget';

  @override
  String get monthlyLimit => 'Monthly limit';

  @override
  String get searchByNote => 'Search by note or reference';

  @override
  String get setupTitle => 'Your money, clear and under control';

  @override
  String get unlockTitle => 'Welcome back';

  @override
  String get recoverAccess => 'Recover access';

  @override
  String get documentId => 'Personal document';

  @override
  String get paymentMethodQr => 'QR';

  @override
  String get text => 'Attention';

  @override
  String get text2 => 'Overview';

  @override
  String get text3 => 'Cause';

  @override
  String get text4 => 'Forecast';

  @override
  String get text5 => 'Action';

  @override
  String get text6 => 'Goals';

  @override
  String get appearance => 'Appearance';

  @override
  String get privacy => 'Privacy';

  @override
  String get security => 'Security';

  @override
  String get data => 'Data';

  @override
  String get paymentMethodCash => 'Cash';

  @override
  String get reminderDayPrefix => 'Day';

  @override
  String get noGoal => 'No goal';

  @override
  String get amount => 'Amount';

  @override
  String get note => 'Note';

  @override
  String get type => 'Type';

  @override
  String get date => 'Date';

  @override
  String get movement => 'Movement';

  @override
  String get movementFallbackTitle => 'Movement';

  @override
  String get recentMovementUntitled => 'Movement';

  @override
  String get movementNoDescription => 'No description';

  @override
  String get movementsTab => 'Activity';

  @override
  String get createGoal => 'Create goal';

  @override
  String get newGoal => 'New goal';

  @override
  String get editGoal => 'Edit goal';

  @override
  String get completed => 'Completed';

  @override
  String get activeGoals => 'Active goals';

  @override
  String get achieved => 'Achieved';

  @override
  String get contribute => 'Contribute';

  @override
  String get defaultCategory => 'Default';

  @override
  String get customCategory => 'Custom';

  @override
  String get budgets => 'Budgets';

  @override
  String get showAmounts => 'Show amounts';

  @override
  String get hideAmounts => 'Hide amounts';

  @override
  String get spent => 'Spent';

  @override
  String get remaining => 'Remaining';

  @override
  String get lockNow => 'Lock now';

  @override
  String get add => 'Add';

  @override
  String get all => 'All';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get filters => 'Filters';

  @override
  String get forgotPin => 'I forgot my PIN';

  @override
  String get birthDate => 'Birth date';

  @override
  String get todaviaNoHaySuficienteActividadEsteMes =>
      'There is not enough activity yet this month for a solid projection.';

  @override
  String get vasEnCaminoACerrarElMes =>
      'You are on track to close the month with a positive balance if you keep this pace.';

  @override
  String get tuRitmoActualPodriaDejarteConMuy =>
      'Your current pace could leave you with very little margin by month end.';

  @override
  String get siElGastoSigueAEsteRitmo =>
      'If spending continues at this pace, this month could close in deficit.';

  @override
  String get muySaludable => 'Very healthy';

  @override
  String get tuMesVieneEquilibradoYConBuen =>
      'Your month looks balanced and leaves enough room to absorb surprises.';

  @override
  String get tusNumerosEstanBastanteControladosConAlgunos =>
      'Your numbers are fairly controlled, with a few points worth watching.';

  @override
  String get tuFlujoSigueFuncionandoPeroConvieneAjustar =>
      'Your cash flow is still working, but it is worth adjusting before the month gets tighter.';

  @override
  String get elRitmoActualPuedeDejarteSinMargen =>
      'Your current pace could leave you with very little margin before month end.';

  @override
  String get masDeLoQueEntra => 'More than what comes in';

  @override
  String get mesConMargen => 'Month with margin';

  @override
  String get categoriaDominante => 'Dominant category';

  @override
  String get cambioBruscoDeGasto => 'Sharp spending change';

  @override
  String get buenAjuste => 'Good adjustment';

  @override
  String get riesgoDeFinDeMes => 'Month-end risk';

  @override
  String get ritmoBajoControl => 'Pace under control';

  @override
  String get gastoAtipico => 'Atypical expense';

  @override
  String get ahorroSaludable => 'Healthy savings';

  @override
  String get sugerenciaSimple => 'Simple suggestion';

  @override
  String get mesEnMejora => 'Month improving';

  @override
  String get mesMasExigente => 'More demanding month';

  @override
  String get metaEncaminada => 'Goal on track';

  @override
  String get despuesDeGastarYAhorrarTodaviaTe =>
      'After spending and saving, you still have a positive margin this month.';

  @override
  String get tuProyeccionDeGastoCierraDentroDel =>
      'Your spending projection still closes within the margin available for this month.';

  @override
  String get reservarAunqueSeaUn5AlCobrar =>
      'Setting aside even 5% when you get paid can give you more breathing room by month end.';

  @override
  String get tuResultadoMensualVieneMejorQueEl =>
      'Your monthly result is coming in better than the previous period.';

  @override
  String get tuMargenBajoFrenteAlMesAnterior =>
      'Your margin dropped versus last month. It is worth reviewing your pace.';

  @override
  String get actualizaTuRegistro => 'Update your movement';

  @override
  String get registraUnMovimientoEnSegundos => 'Add a movement in seconds';

  @override
  String get usaLenguajeSimpleYDejaSoloLa =>
      'Use simple language and keep only what matters.';

  @override
  String get elegiQueTipoDeMovimientoQueresRegistrar =>
      'Choose the kind of movement you want to register.';

  @override
  String get ingresaUnMontoValido => 'Enter a valid amount.';

  @override
  String get elegiUnaCategoria => 'Choose a category';

  @override
  String get elegiLaCategoriaPrincipal => 'Choose the main category.';

  @override
  String get subcategoriaOpcional => 'Subcategory (optional)';

  @override
  String get siAplicaElegiUnDetalleMasEspecifico =>
      'If it applies, choose a more specific detail.';

  @override
  String get vinculaElMovimientoConUnaDeTus =>
      'Link the movement to one of your savings goals.';

  @override
  String get siGuardasAhoraQuedaraEnAhorroGeneral =>
      'If you save now, it will appear as General savings and you can create a goal later.';

  @override
  String get tipSiElegisUnaMetaVasA =>
      'Tip: if you pick a goal, you can track progress faster in Savings.';

  @override
  String get elegiUnMedioDePago => 'Choose a payment method';

  @override
  String get ejemploCompraSemanalOPagoDeServicio =>
      'Example: weekly groceries or utility bill';

  @override
  String get protegerBackup => 'Protect backup';

  @override
  String get agregaUnaContrasenaOpcionalSiLaDejas =>
      'Add an optional password. If you leave it empty, the backup will be exported as readable JSON.';

  @override
  String get backupLocalDeCleanfinance => 'Local backup from CleanFinance';

  @override
  String get estaAccionReemplazaraTusDatosLocalesActuales =>
      'This will replace your current local data. The file will be validated before importing so your existing data stays untouched if something is wrong.';

  @override
  String get siEsteBackupFueProtegidoConContrasena =>
      'If this backup was protected with a password, enter it now. Leave it empty for plain JSON backups.';

  @override
  String get datosImportadosCorrectamente => 'Data imported successfully.';

  @override
  String get borrarTodosLosDatos => 'Delete all data';

  @override
  String get estoEliminaraLaBaseLocalCompletaEl =>
      'This will remove the full local database, PIN, recovery data and biometric flags, leaving the app as a clean install.';

  @override
  String get borrarTodo => 'Delete everything';

  @override
  String get seBorraronTodosLosDatosLocalesLa =>
      'All local data was deleted. The app is now in clean-install state.';

  @override
  String get contrasenaOpcional => 'Password (optional)';

  @override
  String get unaAppSimplePrivadaYClara => 'A simple, private and clear app';

  @override
  String get configuraLaExperienciaParaQueSeSienta =>
      'Adjust the experience so it really feels like yours.';

  @override
  String get manteneAccesoRapidoSinPerderPrivacidad =>
      'Keep fast access without losing privacy.';

  @override
  String get usaHuellaOReconocimientoFacialSiEsta =>
      'Use fingerprint or face unlock if available.';

  @override
  String get esteDispositivoNoTieneBiometriaDisponible =>
      'This device does not support biometrics.';

  @override
  String get bloqueoAutomatico => 'Auto lock';

  @override
  String get revisaQueGuardaCleanfinanceDeFormaLocal =>
      'Review what CleanFinance stores locally, how backups work, and what is never sent to servers.';

  @override
  String get seguirSistema => 'Follow system';

  @override
  String get recibiRecordatoriosMensualesEnEsteTelefono =>
      'Receive monthly reminders on this device.';

  @override
  String get notificacionesDelSistema => 'System notifications';

  @override
  String get horaDeRecordatorio => 'Reminder time';

  @override
  String get personalizaLasListasQueUsasTodosLos =>
      'Customize the lists you use every day so adding data stays quick and clear.';

  @override
  String get tusDatosVivenEnTuDispositivoPodes =>
      'Your data lives on your device. You can export or restore it whenever you need.';

  @override
  String get notaDeSeguridadLosBackupsLocalesPueden =>
      'Security note: local backups can be exported as plain JSON. You can now add an optional password, but data stored in SQLite on the device is still not database-encrypted.';

  @override
  String get privacidadPrimeroNoHayTrackingNoSe =>
      'Privacy first: no tracking, no financial data uploads and everything stays under your local control.';

  @override
  String get noSePudieronCargarLosAjustes => 'Could not load settings';

  @override
  String get revisandoPermiso => 'Checking permission...';

  @override
  String get noSePudoRevisarElPermiso => 'Permission status unavailable';

  @override
  String get notificacionesDesactivadas => 'Notifications are off';

  @override
  String get notificacionesActivadas => 'Notifications enabled';

  @override
  String get permisoPendiente => 'Permission pending';

  @override
  String get permisoDenegado => 'Permission denied';

  @override
  String get noDisponibleEnEstaPlataforma => 'Not available on this platform';

  @override
  String get errorInesperado => 'Unexpected error.';

  @override
  String get pinIncorrecto => 'Incorrect PIN.';

  @override
  String get nuevoPin => 'New PIN';

  @override
  String get confirmarPin => 'Confirm PIN';

  @override
  String get validando => 'Validating...';

  @override
  String get empezar => 'Start';

  @override
  String get desbloquear => 'Unlock';

  @override
  String get eliminarPresupuesto => 'Delete budget';

  @override
  String get eliminar => 'Delete';

  @override
  String get guardando => 'Saving...';

  @override
  String get reintentar => 'Retry';

  @override
  String get atencion => 'Attention';

  @override
  String get excedido => 'Exceeded';

  @override
  String get normal => 'Normal';

  @override
  String get bajo => 'Low';

  @override
  String get medio => 'Medium';

  @override
  String get alto => 'High';

  @override
  String get estable => 'Stable';

  @override
  String get enRiesgo => 'At risk';

  @override
  String get eliminarCategoria => 'Delete category';

  @override
  String get nuevaCategoria => 'New category';

  @override
  String get editarCategoria => 'Edit category';

  @override
  String get nombre => 'Name';

  @override
  String get recomendaciones => 'Insights';

  @override
  String get movimientosRecientes => 'Recent movements';

  @override
  String get recordatoriosDeGastos => 'Expense reminders';

  @override
  String get recordatoriosDeAhorro => 'Savings reminders';

  @override
  String get eliminarMovimiento => 'Delete movement';

  @override
  String get agregarMovimiento => 'Add movement';

  @override
  String get evolucionMensual => 'Monthly trend';

  @override
  String get ritmoDeGasto => 'Spending pace';

  @override
  String get proyeccion => 'Projection';

  @override
  String get estado => 'Status';

  @override
  String get metasDeAhorro => 'Savings goals';

  @override
  String get lecturaRapida => 'Quick read';

  @override
  String get enRango => 'On track';

  @override
  String get atencion2 => 'Watch';

  @override
  String get riesgo => 'Risk';

  @override
  String get nuevo => 'New';

  @override
  String get sinEstimacionTodavia => 'No estimate yet';

  @override
  String get nombreDeLaMeta => 'Goal name';

  @override
  String get montoObjetivo => 'Target amount';

  @override
  String get guardarMeta => 'Save goal';

  @override
  String get eliminarMeta => 'Delete goal';

  @override
  String get ahorroGeneral => 'General savings';

  @override
  String get objetivo => 'Target';

  @override
  String get advertenciaElArchivoNoEstaCifrado =>
      'Warning: the file is not encrypted.';

  @override
  String get oneMinute => '1 minute';

  @override
  String get fiveMinutes => '5 minutes';

  @override
  String get fifteenMinutes => '15 minutes';

  @override
  String get thirtyMinutes => '30 minutes';

  @override
  String get tema => 'Theme';

  @override
  String get claro => 'Light';

  @override
  String get oscuro => 'Dark';

  @override
  String get moneda => 'Currency';

  @override
  String get notificaciones => 'Notifications';

  @override
  String get organizacion => 'Organization';

  @override
  String get netoEstimado => 'Projected net';

  @override
  String get icono => 'Icon';

  @override
  String get tocaParaCambiar => 'Tap to change';

  @override
  String get elegiUnIcono => 'Choose an icon';

  @override
  String get seleccionar => 'Select';

  @override
  String get total => 'Total';

  @override
  String get movementFormMissingCategory => 'Select a category before saving.';

  @override
  String movementFormLoadCategoriesError(Object error) {
    return 'Could not load categories: $error';
  }

  @override
  String financeInsightOvercommittedMessage(Object percentage) {
    return 'Your expenses and savings have already consumed $percentage% of this month\'s income.';
  }

  @override
  String financeInsightDominantCategoryMessage(
      Object percentage, Object categoryName) {
    return '$categoryName accounts for $percentage% of your monthly spending.';
  }

  @override
  String financeInsightExpenseIncreaseMessage(
      Object percentage, Object categoryName) {
    return '$categoryName went up $percentage% versus last month.';
  }

  @override
  String financeInsightExpenseDecreaseMessage(
      Object percentage, Object categoryName) {
    return '$categoryName went down $percentage% versus last month.';
  }

  @override
  String financeInsightEndOfMonthRiskMessage(Object amount) {
    return 'If you keep this pace, you could finish about $amount below zero.';
  }

  @override
  String financeInsightAtypicalExpenseMessage(Object percentage) {
    return 'A single purchase represented $percentage% of this month\'s income.';
  }

  @override
  String financeInsightHealthySavingsMessage(Object percentage) {
    return 'You have already set aside $percentage% of this month\'s income.';
  }

  @override
  String financeInsightGoalOnTrackMessage(Object percentage, Object goalName) {
    return '$goalName is already at $percentage% and keeping a good pace.';
  }

  @override
  String get authRecoveryDocumentExample => 'Example: 12345678';

  @override
  String get authUseBiometrics => 'Use biometrics';

  @override
  String get authUnlockWithPinOrBiometrics =>
      'Sign in with your PIN or use biometrics for faster access.';

  @override
  String authWaitBeforeRetry(Object seconds) {
    return 'Wait ${seconds}s before trying again.';
  }

  @override
  String get authBiometricsEnabledTip =>
      'Tip: if biometrics are enabled, sign-in takes just one touch.';

  @override
  String get authBiometricsUnavailablePinProtected =>
      'Biometrics are not available on this device, but your PIN remains locally protected.';

  @override
  String get estaCategoria => 'This category';

  @override
  String get tuMeta => 'Your goal';

  @override
  String get revisaTusDatosDeRecuperacionEIntenta =>
      'Check your recovery data and try again.';

  @override
  String get laBiometriaNoEstaDisponibleEnEste =>
      'Biometrics are not available on this device.';

  @override
  String get noSePudoUsarLaBiometriaConfigura =>
      'Could not use biometrics. Configure fingerprint/face and screen lock.';

  @override
  String get noSePudoValidarLaBiometriaVerifica =>
      'Biometric validation failed. Verify device biometric setup.';

  @override
  String get noSePudoVerificarLaRecuperacionRevisa =>
      'Recovery verification failed. Check your answers and try again.';

  @override
  String get algunasValidacionesDeSeguridadNoPudieronInicializarse =>
      'Some security checks failed to initialize. The app is running in safe mode.';

  @override
  String get completaAmbasRespuestasDeRecuperacion =>
      'Complete both recovery answers.';

  @override
  String get usaUnaFechaValidaYUnDocumento =>
      'Use a valid date and a document with at least 6 characters.';

  @override
  String get losPinNoCoinciden => 'PIN values do not match.';

  @override
  String get recuperaTuAccesoSinComplicarte =>
      'Recover access without complications';

  @override
  String get respondeTusDosPreguntasPersonalesYElegi =>
      'Answer your two personal questions and choose a new PIN.';

  @override
  String get laRecuperacionLocalEsMenosRobustaQue =>
      'Local recovery is less robust than your PIN. If someone knows this data and has the device, they could try to reset access.';

  @override
  String get ejemplo10021996 => 'Example: 02/10/1996';

  @override
  String get activarHuellaParaProximosAccesos =>
      'Enable biometrics for next unlocks';

  @override
  String get asiVasAPoderEntrarMasRapido =>
      'This lets you sign in faster after recovery.';

  @override
  String get completaTusDosPreguntasDeRecuperacion =>
      'Complete both recovery answers.';

  @override
  String get creaUnPinCortoParaProtegerTus =>
      'Create a short PIN to protect your data. Everything stays only on your device.';

  @override
  String get elegiTuPin => 'Choose your PIN';

  @override
  String get repetiTuPin => 'Repeat your PIN';

  @override
  String get activarHuellaParaEntrarMasRapido =>
      'Enable fingerprint for faster access';

  @override
  String get laAppTeLaVaAOfrecer => 'The app will offer it on the next unlock.';

  @override
  String get configurando => 'Setting up...';

  @override
  String get guardamosEstasRespuestasSoloParaAyudarteA =>
      'We store these answers only to help you recover access if you forget your PIN.';

  @override
  String get lasRespuestasDeRecuperacionSonMasDebiles =>
      'Recovery answers are weaker than your PIN. Use real values, but remember that anyone who knows them could try to reset access on this device.';

  @override
  String get estePresupuestoMensualSeEliminaraYEl =>
      'This monthly budget will be removed and tracking for this category will stop until you create a new one.';

  @override
  String get seleccionaUnaCategoria => 'Select a category.';

  @override
  String get primeroCreaUnaCategoriaDeGasto =>
      'Create an expense category first';

  @override
  String get losPresupuestosSeCreanAPartirDe =>
      'Budgets are created from your existing expense categories.';

  @override
  String get ajustaEstePresupuestoMensual => 'Adjust this monthly budget';

  @override
  String get creaUnPresupuestoMensualPorCategoria =>
      'Create a monthly budget by category';

  @override
  String get losPresupuestosSeGuardanLocalmenteYSe =>
      'Budgets are stored locally and tracked against your current-month expenses.';

  @override
  String get elegiLaCategoriaDeGastoParaEste =>
      'Choose the expense category for this monthly budget.';

  @override
  String get ingresaUnLimiteMensualValido => 'Enter a valid monthly limit.';

  @override
  String get presupuestosMensuales => 'Monthly budgets';

  @override
  String get seguiComoVieneCadaCategoriaEsteMes =>
      'Track how each category is doing this month and update limits whenever you need.';

  @override
  String get creaTuPrimerPresupuesto => 'Create your first budget';

  @override
  String get definiUnLimiteMensualParaUnaCategoria =>
      'Set a monthly limit for an expense category and we will track how much you have already spent.';

  @override
  String get agregarPresupuesto => 'Add budget';

  @override
  String get noSePudieronCargarLosPresupuestos => 'Could not load budgets';

  @override
  String get eliminarSubcategoria => 'Delete subcategory';

  @override
  String get categoriaPadre => 'Parent category';

  @override
  String get sinCategoriaPadre => 'No parent category';

  @override
  String get elegiUnaCategoriaPrincipalSoloSiQueres =>
      'Choose a top-level category only if you want a subcategory.';

  @override
  String get usaEstaSubcategoriaParaServiciosOGastos =>
      'Use this subcategory for recurring services or expenses.';

  @override
  String get saldoActual => 'Current balance';

  @override
  String get ahorroTotal => 'Total savings';

  @override
  String get todaviaNoHayRecomendaciones => 'There are no insights yet';

  @override
  String get cargaAlgunosMovimientosParaVerAlertasY =>
      'Add a few movements to see simple alerts and suggestions.';

  @override
  String get ingresosVsGastos => 'Income vs expense';

  @override
  String get unaLecturaRapidaDeComoVieneEl =>
      'A quick read on how this month is going.';

  @override
  String get comparaTusIngresosYGastosDeLos =>
      'Compare your income and expenses over the last 6 months.';

  @override
  String get gastosPorCategoria => 'Expenses by category';

  @override
  String get simpleClaroYFacilDeLeer => 'Simple, clear and easy to read.';

  @override
  String get todaviaNoHayGastosSuficientes => 'Not enough expense data yet';

  @override
  String get cuandoRegistresGastosVasAVerTus =>
      'Once you register expenses, your top categories will show here.';

  @override
  String get agregarGasto => 'Add expense';

  @override
  String get empezaConTuPrimerMovimiento => 'Start with your first movement';

  @override
  String get cargarGastosEIngresosTeVaA =>
      'Adding income and expenses helps unlock summaries, alerts and charts.';

  @override
  String get noPudimosCargarElInicio => 'Could not load home';

  @override
  String get sinCategoria => 'Uncategorized';

  @override
  String get revisaTusRecordatoriosMensualesActivos =>
      'Review your active monthly reminders';

  @override
  String get losRecordatoriosDeGastoSalenDeSubcategorias =>
      'Expense reminders come from subcategories and savings reminders come from goals.';

  @override
  String get noHayRecordatoriosDeGastoActivos => 'No active expense reminders';

  @override
  String get activaRecordatoriosAlCrearOEditarUna =>
      'Enable reminders when creating or editing an expense subcategory.';

  @override
  String get noSePudieronCargarLosRecordatoriosDe =>
      'Could not load expense reminders';

  @override
  String get noHayRecordatoriosDeAhorroActivos => 'No active savings reminders';

  @override
  String get activaRecordatoriosAlCrearOEditarUna2 =>
      'Enable reminders when creating or editing a savings goal.';

  @override
  String get metaCompletada => 'Completed goal';

  @override
  String get noSePudieronCargarLosRecordatoriosDe2 =>
      'Could not load savings reminders';

  @override
  String get elegiElDiaDelMesParaEl =>
      'Choose the day of month for the reminder.';

  @override
  String get seEliminaraEsteMovimientoDeFormaPermanente =>
      'This movement will be permanently deleted. Verify the details before continuing.';

  @override
  String get elegiSoloLoNecesarioParaEncontrarRapido =>
      'Choose only what you need to quickly find what you are looking for.';

  @override
  String get filtraPorUnaCategoriaPrincipalParaAcotar =>
      'Filter by a main category to narrow the search.';

  @override
  String get noEncontramosMovimientos => 'No movements found';

  @override
  String get probaCambiandoElFiltroOAgregandoUn =>
      'Try changing the filters or adding a new record.';

  @override
  String get noSePudieronCargarLosMovimientos => 'Could not load movements';

  @override
  String get editarMedioDePago => 'Edit payment method';

  @override
  String get ejemploQrTransferenciaOEfectivo => 'Example: QR, transfer or cash';

  @override
  String get elegiSoloLosMediosDePagoQue =>
      'Choose the payment methods you really use';

  @override
  String get estasOpcionesVanAAparecerComoDesplegable =>
      'These options will appear as a dropdown when creating a movement.';

  @override
  String get todaviaNoHayMediosDePago => 'No payment methods yet';

  @override
  String get agregaTusOpcionesHabitualesComoTransferenciaDebito =>
      'Add your common options like transfer, debit card or cash.';

  @override
  String get saludFinanciera => 'Financial health';

  @override
  String get cashflowMensual => 'Monthly cashflow';

  @override
  String get unResumenRapidoParaEntenderCuantoEntro =>
      'A quick summary of what came in, what went out, and the margin left.';

  @override
  String get saldoNeto => 'Net balance';

  @override
  String get comparaComoVienenTusIngresosYGastos =>
      'Compare how your income and expenses evolved in recent months.';

  @override
  String get topCategoriasDelMes => 'Top categories this month';

  @override
  String get vasAVerEnQueSeFue =>
      'See where most money went and how it changed versus last month.';

  @override
  String get sinDatosTodavia => 'No data yet';

  @override
  String get cuandoRegistresGastosVasAVerAca =>
      'Once you register expenses, you will see where most spending goes.';

  @override
  String get teMuestraSiElGastoAcumuladoVa =>
      'Shows whether your cumulative spending is inside the expected range for this point in the month.';

  @override
  String get esperadoHoy => 'Expected today';

  @override
  String get elRitmoActualEsExigenteParaTu =>
      'Your current pace is demanding for the available margin.';

  @override
  String get vasCercaDelLimiteConvieneMirarCon =>
      'You are close to the limit. It is worth watching the second half of the month carefully.';

  @override
  String get tuGastoVieneEnUnaZonaSaludable =>
      'Your spending is currently in a healthy zone for this time of month.';

  @override
  String get seguimientoSimpleDelAvanceRitmoDeAporte =>
      'Simple tracking of progress, contribution pace and estimated completion date.';

  @override
  String get todaviaNoHayMetasParaAnalizar => 'No goals to analyze yet';

  @override
  String get cuandoTengasMetasYAportesVasA =>
      'Once you have goals and contributions, progress pace will show here.';

  @override
  String get gastosPorMedioDePago => 'Expenses by payment method';

  @override
  String get teAyudaAVerQueMetodoEstas =>
      'Helps you see which payment method you use the most this month.';

  @override
  String get noSePudieronCargarLosReportes => 'Could not load reports';

  @override
  String get elegiUnDiaDeRecordatorioValido => 'Choose a valid reminder day.';

  @override
  String get definiUnaMetaSimpleYVisible => 'Define a simple and visible goal';

  @override
  String get nombreClaroMontoObjetivoYFechaOpcional =>
      'Clear name, target amount and optional date. Nothing else.';

  @override
  String get ingresaUnNombre => 'Enter a name.';

  @override
  String get agregarFechaObjetivo => 'Add target date';

  @override
  String get teAyudaANoOlvidarteDelAporte =>
      'Helps you remember monthly contributions for this goal.';

  @override
  String get elegiElDiaDelMesEnEl =>
      'Choose the day of month when you want the reminder.';

  @override
  String get todaviaNoTenesAhorroRegistrado => 'No savings recorded yet';

  @override
  String get creaUnaMetaORegistraUnAporte =>
      'Create a goal or register a contribution to start organizing your savings.';

  @override
  String get totalAhorrado => 'Total saved';

  @override
  String get todoLoQueAhorrasteEstaOrganizadoEn =>
      'Everything you saved is already organized into goals.';

  @override
  String get logradas => 'Completed';

  @override
  String get metasLogradas => 'Completed goals';

  @override
  String get noPudimosCargarTusMetas => 'Could not load your goals';

  @override
  String get noPudimosCargarAhorros => 'Could not load savings';

  @override
  String get dineroGuardadoSinUnaMetaEspecifica =>
      'Money saved without a specific goal.';

  @override
  String get creaUnaMetaParaOrganizarMejorTus =>
      'Create a goal to organize your savings better.';

  @override
  String get excelenteYaAlcanzasteEstaMeta =>
      'Great. You already achieved this goal.';

  @override
  String get proyeccionDeFinDeMes => 'End-of-month projection';

  @override
  String get gastoProyectado => 'Projected expense';

  @override
  String get usaUnaOpcionClaraParaReconocerMas =>
      'Use a clear option to recognize the category faster.';

  @override
  String get iconoSeleccionado => 'Selected icon';

  @override
  String get todaviaTeQuedaPagarOAhorrarPara =>
      'You still need to pay or save for:';

  @override
  String get pinLabel => 'PIN';

  @override
  String authPinLengthInvalid(Object length) {
    return 'PIN must be $length digits.';
  }

  @override
  String authLockoutActive(Object seconds) {
    return 'Too many failed attempts. Wait $seconds seconds before trying again.';
  }

  @override
  String categoriesLoadError(Object error) {
    return 'Could not load categories: $error';
  }

  @override
  String deleteSubcategoryMessage(Object name) {
    return 'The subcategory \"$name\" will be deleted. If there are linked transactions or dependencies, the app will block deletion.';
  }

  @override
  String deleteCategoryMessage(Object name) {
    return 'The category \"$name\" will be deleted. If there are linked transactions, subcategories, or budgets, the app will block deletion.';
  }

  @override
  String dashboardRemainingPositive(Object amount) {
    return 'You still have $amount left this month.';
  }

  @override
  String dashboardRemainingNegative(Object amount) {
    return 'This month you are $amount above your margin.';
  }

  @override
  String projectionAverageExpensePace(Object amount, Object days) {
    return 'Average expense pace: $amount/day. $days days left.';
  }

  @override
  String reportsShareOfTotal(Object percentage) {
    return '$percentage% of total';
  }

  @override
  String reportsPreviousMonth(Object amount) {
    return 'Previous month: $amount';
  }

  @override
  String savingsGoalProgress(Object saved, Object target) {
    return '$saved of $target';
  }

  @override
  String goalAverageContribution(Object amount) {
    return 'Average contribution: $amount per month';
  }

  @override
  String goalContributionThisMonth(Object amount) {
    return 'Contribution this month: $amount';
  }

  @override
  String goalEstimatedDate(Object date) {
    return 'Estimated date: $date';
  }

  @override
  String deleteSavingsGoalMessage(Object name) {
    return 'The goal \"$name\" will be deleted. Existing contributions will remain but no longer be linked to this goal.';
  }

  @override
  String savingsGeneralIncluded(Object amount) {
    return 'Includes $amount in general savings.';
  }

  @override
  String savingsContributionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contributions recorded.',
      one: '1 contribution recorded.',
    );
    return '$_temp0';
  }

  @override
  String savingsContributionCountWithDate(num count, Object date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contributions · last: $date.',
      one: '1 contribution · last: $date.',
    );
    return '$_temp0';
  }

  @override
  String savingsGoalTargetDate(Object date) {
    return 'Target: $date';
  }

  @override
  String savingsGoalRemaining(Object amount) {
    return 'You still need $amount to reach it.';
  }

  @override
  String get privacySummaryTitle => 'Summary';

  @override
  String get privacySummaryBody1 =>
      'CleanFinance is an offline-first personal finance app. The app does not create online accounts, does not upload your financial records to developer servers, and does not include analytics, advertising, or tracking SDKs.';

  @override
  String get privacySummaryBody2 =>
      'This in-app privacy policy summarizes the data handling that can be confirmed from the current source code. The public privacy policy URL published in Google Play should mirror this text and include the final developer contact details.';

  @override
  String get privacyStoredDataTitle => 'Data stored on your device';

  @override
  String get privacyStoredDataBody1 =>
      'CleanFinance stores your categories, transactions, savings goals, budgets, payment methods, language, theme, amount visibility preference, auto-lock preference, and biometric preference in a local SQLite database on the device.';

  @override
  String get privacyStoredDataBody2 =>
      'The app also stores a hashed PIN, hashed recovery answers for birth date and personal document, and PIN lockout state in Android secure storage. Recovery answers are collected only to let you reset access on the same device if you forget your PIN.';

  @override
  String get privacyBiometricsTitle => 'Biometrics and permissions';

  @override
  String get privacyBiometricsBody1 =>
      'If you enable biometric unlock, CleanFinance asks Android to verify your fingerprint or face locally on the device. The app does not receive or store your biometric template.';

  @override
  String get privacyBiometricsBody2 =>
      'The Android build requests the biometric permission required to show the system biometric prompt. No location, contacts, camera, microphone, SMS, phone, or advertising permissions are declared in the main Android manifest.';

  @override
  String get privacyBackupsTitle => 'Backups and file sharing';

  @override
  String get privacyBackupsBody1 =>
      'You can export your data manually from Settings. Exports contain your local financial database and settings. If you leave the password blank, the export is saved as readable JSON. If you provide a password, the export is encrypted before you share or store it.';

  @override
  String get privacyBackupsBody2 =>
      'Imports are initiated by you and replace the current local database only after file validation. CleanFinance does not automatically sync backups to developer servers.';

  @override
  String get privacySharingTitle => 'Sharing, retention, and deletion';

  @override
  String get privacySharingBody1 =>
      'The app does not share personal or financial data with the developer or third parties. Data remains on the device unless you explicitly export and share a backup yourself.';

  @override
  String get privacySharingBody2 =>
      'Your data stays on the device until you delete it, clear the app, uninstall the app, or use the in-app action to delete all local data. Deleting all local data removes the SQLite database, secure storage credentials, recovery data, and biometric flags.';

  @override
  String get privacySecurityTitle => 'Security notes';

  @override
  String get privacySecurityBody1 =>
      'Financial data stored in SQLite is local but not encrypted at the database-file level. Sensitive authentication data is stored hashed in secure storage. Release builds also disable Android cloud backup to reduce unintended copies of local financial data.';

  @override
  String get privacySecurityBody2 =>
      'Because recovery uses birth date and personal document, anyone who knows those values and has the device could attempt a local reset. Users should protect the device itself with Android screen lock.';

  @override
  String get privacyContactTitle => 'Privacy contact';

  @override
  String get privacyContactBody1 =>
      'The official privacy contact channel for the published app must be the developer email shown on the Google Play listing for CleanFinance. Before production launch, make sure the hosted public privacy policy includes that exact contact address.';

  @override
  String get iconOptionCategory => 'General';

  @override
  String get iconOptionHome => 'Home';

  @override
  String get iconOptionBolt => 'Services';

  @override
  String get iconOptionRestaurant => 'Food';

  @override
  String get iconOptionCar => 'Transport';

  @override
  String get iconOptionHealth => 'Health';

  @override
  String get iconOptionEducation => 'Education';

  @override
  String get iconOptionShopping => 'Shopping';

  @override
  String get iconOptionEntertainment => 'Leisure';

  @override
  String get iconOptionFinance => 'Finance';

  @override
  String get iconOptionFamily => 'Family';

  @override
  String get iconOptionWork => 'Work';

  @override
  String get iconOptionPayments => 'Payments';

  @override
  String get iconOptionStorefront => 'Sales';

  @override
  String get iconOptionSavings => 'Savings';

  @override
  String get iconOptionShield => 'Protection';

  @override
  String get iconOptionFlight => 'Travel';

  @override
  String get iconOptionPalette => 'Decor';

  @override
  String get iconOptionKitchen => 'Kitchen';

  @override
  String get iconOptionReceipt => 'Bills';

  @override
  String get iconOptionCleaningServices => 'Cleaning';

  @override
  String get iconOptionBuild => 'Maintenance';

  @override
  String get iconOptionChair => 'Furniture';

  @override
  String get iconOptionHandyman => 'Repairs';

  @override
  String get iconOptionWaterDrop => 'Water';

  @override
  String get iconOptionTv => 'TV';

  @override
  String get iconOptionLocalFireDepartment => 'Gas';

  @override
  String get iconOptionWifi => 'Internet';

  @override
  String get iconOptionElectricBolt => 'Electricity';

  @override
  String get iconOptionCloud => 'Apps';

  @override
  String get iconOptionPlayCircle => 'Streaming';

  @override
  String get iconOptionPhone => 'Phone';

  @override
  String get iconOptionCoffee => 'Coffee shop';

  @override
  String get iconOptionSetMeal => 'Butcher';

  @override
  String get iconOptionDeliveryDining => 'Delivery';

  @override
  String get iconOptionBakeryDining => 'Bakery';

  @override
  String get iconOptionRestaurantMenu => 'Restaurants';

  @override
  String get iconOptionShoppingCart => 'Supermarket';

  @override
  String get iconOptionEco => 'Produce store';

  @override
  String get iconOptionLocalGasStation => 'Fuel';

  @override
  String get iconOptionLocalParking => 'Parking';

  @override
  String get iconOptionToll => 'Tolls';

  @override
  String get iconOptionSecurity => 'Insurance';

  @override
  String get iconOptionLocalTaxi => 'Taxi';

  @override
  String get iconOptionDirectionsBus => 'Bus';

  @override
  String get iconOptionEmojiTransportation => 'Mobility';

  @override
  String get iconOptionMedicalServices => 'Appointments';

  @override
  String get iconOptionScience => 'Tests';

  @override
  String get iconOptionMedication => 'Medication';

  @override
  String get iconOptionHealthAndSafety => 'Health plan';

  @override
  String get iconOptionMood => 'Dentistry';

  @override
  String get iconOptionVisibility => 'Optical';

  @override
  String get iconOptionMenuBook => 'Courses';

  @override
  String get iconOptionBook => 'Books';

  @override
  String get iconOptionEdit => 'Supplies';

  @override
  String get iconOptionSchool => 'Training';

  @override
  String get iconOptionHiking => 'Footwear';

  @override
  String get iconOptionLanguage => 'Online';

  @override
  String get iconOptionCardGiftcard => 'Gifts';

  @override
  String get iconOptionCheckroom => 'Clothing';

  @override
  String get iconOptionDevices => 'Technology';

  @override
  String get iconOptionMovie => 'Cinema';

  @override
  String get iconOptionEvent => 'Events';

  @override
  String get iconOptionSportsEsports => 'Games';

  @override
  String get iconOptionNightlife => 'Going out';

  @override
  String get iconOptionAccountBalanceWallet => 'Fees';

  @override
  String get iconOptionReceiptLong => 'Taxes';

  @override
  String get iconOptionPercent => 'Interest';

  @override
  String get iconOptionBusiness => 'Self-employed tax';

  @override
  String get iconOptionCreditCard => 'Cards';

  @override
  String get iconOptionSelfImprovement => 'Personal';

  @override
  String get iconOptionChildCare => 'Daycare';

  @override
  String get iconOptionChildFriendly => 'Children';

  @override
  String get iconOptionPets => 'Pets';

  @override
  String get iconOptionLunchDining => 'Meals';

  @override
  String get iconOptionCommute => 'Commutes';

  @override
  String get iconOptionVolunteerActivism => 'Donations';

  @override
  String get iconOptionWarning => 'Unexpected';

  @override
  String get iconOptionMoreHoriz => 'Miscellaneous';

  @override
  String get defaultCategoryNameHobbies => 'Hobbies';

  @override
  String get defaultCategoryNameCompras => 'Shopping';

  @override
  String get defaultCategoryNameImpuestos => 'Taxes';

  @override
  String get defaultCategoryNameLimpieza => 'Cleaning';

  @override
  String get defaultCategoryNameMuebles => 'Furniture';

  @override
  String get defaultCategoryNameMantenimientoDelVehiculo =>
      'Vehicle maintenance';

  @override
  String get defaultCategoryNameMateriales => 'Supplies';

  @override
  String get defaultCategoryNameExpensas => 'Condo fees';

  @override
  String get defaultCategoryNameInternet => 'Internet';

  @override
  String get defaultCategoryNameAlquiler => 'Rent';

  @override
  String get defaultCategoryNamePanaderia => 'Bakery';

  @override
  String get defaultCategoryNameComisionesBancarias => 'Bank fees';

  @override
  String get defaultCategoryNameDonaciones => 'Donations';

  @override
  String get defaultCategoryNameElectrodomesticos => 'Appliances';

  @override
  String get defaultCategoryNameEstacionamiento => 'Parking';

  @override
  String get defaultCategoryNameTransportePublico => 'Public transport';

  @override
  String get defaultCategoryNameOdontologia => 'Dentistry';

  @override
  String get defaultCategoryNameTrabajo => 'Work';

  @override
  String get defaultCategoryNameOcio => 'Entertainment';

  @override
  String get defaultCategoryNameVerduleria => 'Produce store';

  @override
  String get defaultCategoryNameSueldo => 'Salary';

  @override
  String get defaultCategoryNameOptica => 'Optical';

  @override
  String get defaultCategoryNameUberCabify => 'Uber / Cabify';

  @override
  String get defaultCategoryNameCafeteria => 'Coffee shop';

  @override
  String get defaultCategoryNameRegalos => 'Gifts';

  @override
  String get defaultCategoryNameObraSocialPrepaga => 'Health insurance';

  @override
  String get defaultCategoryNameConsultasMedicas => 'Medical appointments';

  @override
  String get defaultCategoryNameEstudios => 'Medical tests';

  @override
  String get defaultCategoryNameCine => 'Cinema';

  @override
  String get defaultCategoryNameAlimentacion => 'Food';

  @override
  String get defaultCategoryNameCuidadoPersonal => 'Personal care';

  @override
  String get defaultCategoryNameGuarderiaColegio => 'Daycare / School';

  @override
  String get defaultCategoryNameHerramientas => 'Tools';

  @override
  String get defaultCategoryNameCombustible => 'Fuel';

  @override
  String get defaultCategoryNameMantenimiento => 'Maintenance';

  @override
  String get defaultCategoryNameLuz => 'Electricity';

  @override
  String get defaultCategoryNameLibros => 'Books';

  @override
  String get defaultCategoryNameTelefono => 'Phone';

  @override
  String get defaultCategoryNameHijos => 'Children';

  @override
  String get defaultCategoryNameSalidas => 'Going out';

  @override
  String get defaultCategoryNameFinanzas => 'Finance';

  @override
  String get defaultCategoryNameCuotas => 'Tuition';

  @override
  String get defaultCategoryNameServicios => 'Services';

  @override
  String get defaultCategoryNameReparaciones => 'Repairs';

  @override
  String get defaultCategoryNameSuscripcionesEducativas =>
      'Educational subscriptions';

  @override
  String get defaultCategoryNameTaxiRemis => 'Taxi / Cab';

  @override
  String get defaultCategoryNameDecoracion => 'Decor';

  @override
  String get defaultCategoryNameTecnologia => 'Technology';

  @override
  String get defaultCategoryNameSalud => 'Health';

  @override
  String get defaultCategoryNameIntereses => 'Interest';

  @override
  String get defaultCategoryNameJuegos => 'Games';

  @override
  String get defaultCategoryNameSupermercado => 'Supermarket';

  @override
  String get defaultCategoryNameCalzado => 'Footwear';

  @override
  String get defaultCategoryNameViaje => 'Travel';

  @override
  String get defaultCategoryNameCableTv => 'Cable / TV';

  @override
  String get defaultCategoryNamePeajes => 'Tolls';

  @override
  String get defaultCategoryNameVarios => 'Miscellaneous';

  @override
  String get defaultCategoryNameRestaurantes => 'Restaurants';

  @override
  String get defaultCategoryNameMonotributoAutonomos => 'Self-employed taxes';

  @override
  String get defaultCategoryNameEventos => 'Events';

  @override
  String get defaultCategoryNameAlimentos => 'Food';

  @override
  String get defaultCategoryNameMascotas => 'Pets';

  @override
  String get defaultCategoryNameVacaciones => 'Holidays';

  @override
  String get defaultCategoryNameFondoDeEmergencia => 'Emergency fund';

  @override
  String get defaultCategoryNameMedicamentos => 'Medication';

  @override
  String get defaultCategoryNameTransporte => 'Transport';

  @override
  String get defaultCategoryNameImprevistos => 'Unexpected expenses';

  @override
  String get defaultCategoryNameCapacitacion => 'Training';

  @override
  String get defaultCategoryNameAgua => 'Water';

  @override
  String get defaultCategoryNameEducacion => 'Education';

  @override
  String get defaultCategoryNameFreelance => 'Freelance';

  @override
  String get defaultCategoryNameTarjetasDeCredito => 'Credit cards';

  @override
  String get defaultCategoryNameCursos => 'Courses';

  @override
  String get defaultCategoryNameRopa => 'Clothing';

  @override
  String get defaultCategoryNameComprasOnline => 'Online shopping';

  @override
  String get defaultCategoryNameHogar => 'Home';

  @override
  String get defaultCategoryNameSeguroDelAuto => 'Car insurance';

  @override
  String get defaultCategoryNameStreaming => 'Streaming';

  @override
  String get defaultCategoryNameGas => 'Gas';

  @override
  String get defaultCategoryNameVenta => 'Sale';

  @override
  String get defaultCategoryNameDelivery => 'Delivery';

  @override
  String get defaultCategoryNameCarniceria => 'Butcher';

  @override
  String get defaultCategoryNameNubeApps => 'Cloud / Apps';

  @override
  String get defaultCategoryNameFamilia => 'Family';

  @override
  String get defaultCategoryNameComidasLaborales => 'Work meals';

  @override
  String get defaultCategoryNameTransporteLaboral => 'Work transport';

  @override
  String get defaultCategoryNameAhorroGeneral => 'General savings';

  @override
  String get defaultCategoryNameOtros => 'Other';

  @override
  String technicalErrorDetails(Object error) {
    return 'Technical details: $error';
  }

  @override
  String get currencyArsOption => 'ARS (\$)';

  @override
  String get currencyUsdOption => 'USD (US\$)';

  @override
  String get currencyEurOption => 'EUR (€)';
}
