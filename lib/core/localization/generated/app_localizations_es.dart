// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'CleanFinance';

  @override
  String get settings => 'Ajustes';

  @override
  String get language => 'Idioma';

  @override
  String get useDeviceLanguage => 'Usar idioma del dispositivo';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'Inglés';

  @override
  String get dashboard => 'Inicio';

  @override
  String get movements => 'Movimientos';

  @override
  String get savings => 'Ahorros';

  @override
  String get reports => 'Reportes';

  @override
  String get income => 'Ingreso';

  @override
  String get expense => 'Gasto';

  @override
  String get saving => 'Ahorro';

  @override
  String get category => 'Categoría';

  @override
  String get subcategory => 'Subcategoría';

  @override
  String get savingGoal => 'Meta de ahorro';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get apply => 'Aplicar';

  @override
  String get clear => 'Limpiar';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get paymentMethods => 'Medios de pago';

  @override
  String get managePaymentMethods => 'Gestionar medios de pago';

  @override
  String get manageReminders => 'Gestionar recordatorios';

  @override
  String get addPaymentMethod => 'Agregar medio de pago';

  @override
  String get movementPaymentMethod => 'Medio de pago';

  @override
  String get paymentMethodTransfer => 'Transferencia';

  @override
  String get paymentMethodDebitCard => 'Tarjeta débito';

  @override
  String get paymentMethodCreditCard => 'Tarjeta crédito';

  @override
  String get paymentMethodUnspecified => 'Sin definir';

  @override
  String get monthlyReminder => 'Recordatorio mensual';

  @override
  String get monthlyReminderDescription =>
      'Usalo para gastos mensuales recurrentes y verlos como pendientes hasta registrar el pago.';

  @override
  String get movementReminderTitle => 'Recordarme este gasto todos los meses';

  @override
  String get movementReminderSubtitle =>
      'Te avisaremos cerca del día de este movimiento.';

  @override
  String get movementReminderActive => 'Recordatorio activo';

  @override
  String get movementReminderDisabled => 'Recordatorio desactivado';

  @override
  String movementReminderMonthlyDay(Object day) {
    return 'Día $day de cada mes';
  }

  @override
  String get movementReminderSettingsHint =>
      'Este recordatorio también se puede cambiar desde Ajustes.';

  @override
  String get reminderDay => 'Día de recordatorio';

  @override
  String get pendingThisMonth => 'Pendientes este mes';

  @override
  String get reminderRegisterPayment => 'Registrar pago';

  @override
  String get reminderLastRegistered => 'Último registro';

  @override
  String get noSubcategory => 'Sin subcategoría';

  @override
  String get newMovement => 'Nuevo movimiento';

  @override
  String get editMovement => 'Editar movimiento';

  @override
  String get saveMovement => 'Guardar movimiento';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get unlimitedDate => 'Sin fecha límite';

  @override
  String get biometric => 'Desbloqueo con biometría';

  @override
  String get exportBackup => 'Exportar backup';

  @override
  String get importBackup => 'Importar backup';

  @override
  String get manageCategories => 'Gestionar categorías';

  @override
  String get noCategories => 'No hay categorías.';

  @override
  String get mainCategory => 'Categoría principal';

  @override
  String get addSubcategory => 'Agregar subcategoría';

  @override
  String get manageBudgets => 'Gestionar presupuestos';

  @override
  String get amountPrivacy => 'Privacidad de montos';

  @override
  String get amountPrivacyDescription =>
      'Ocultá saldos y resúmenes cuando usás la app en público.';

  @override
  String get newBudget => 'Nuevo presupuesto';

  @override
  String get editBudget => 'Editar presupuesto';

  @override
  String get monthlyLimit => 'Límite mensual';

  @override
  String get searchByNote => 'Buscar por nota o referencia';

  @override
  String get setupTitle => 'Tu dinero, claro y bajo control';

  @override
  String get unlockTitle => 'Bienvenido otra vez';

  @override
  String get recoverAccess => 'Recuperar acceso';

  @override
  String get documentId => 'Documento personal';

  @override
  String get paymentMethodQr => 'QR';

  @override
  String get text => 'Atención';

  @override
  String get text2 => 'Descriptivo';

  @override
  String get text3 => 'Diagnóstico';

  @override
  String get text4 => 'Proyección';

  @override
  String get text5 => 'Acción';

  @override
  String get text6 => 'Metas';

  @override
  String get appearance => 'Apariencia';

  @override
  String get privacy => 'Privacidad';

  @override
  String get security => 'Seguridad';

  @override
  String get data => 'Datos';

  @override
  String get paymentMethodCash => 'Efectivo';

  @override
  String get reminderDayPrefix => 'Día';

  @override
  String get noGoal => 'Sin meta';

  @override
  String get amount => 'Monto';

  @override
  String get note => 'Nota';

  @override
  String get type => 'Tipo';

  @override
  String get date => 'Fecha';

  @override
  String get movement => 'Movimiento';

  @override
  String get movementFallbackTitle => 'Movimiento';

  @override
  String get recentMovementUntitled => 'Movimiento';

  @override
  String get movementNoDescription => 'Sin descripción';

  @override
  String get movementsTab => 'Movs.';

  @override
  String get createGoal => 'Crear meta';

  @override
  String get newGoal => 'Nueva meta';

  @override
  String get editGoal => 'Editar meta';

  @override
  String get completed => 'Completadas';

  @override
  String get activeGoals => 'Metas activas';

  @override
  String get achieved => 'Lograda';

  @override
  String get contribute => 'Aportar';

  @override
  String get defaultCategory => 'Predefinida';

  @override
  String get customCategory => 'Personalizada';

  @override
  String get budgets => 'Presupuestos';

  @override
  String get showAmounts => 'Mostrar montos';

  @override
  String get hideAmounts => 'Ocultar montos';

  @override
  String get spent => 'Gastado';

  @override
  String get remaining => 'Disponible';

  @override
  String get lockNow => 'Bloquear ahora';

  @override
  String get add => 'Agregar';

  @override
  String get all => 'Todos';

  @override
  String get from => 'Desde';

  @override
  String get to => 'Hasta';

  @override
  String get filters => 'Filtros';

  @override
  String get forgotPin => 'Olvidé mi PIN';

  @override
  String get birthDate => 'Fecha de nacimiento';

  @override
  String get todaviaNoHaySuficienteActividadEsteMes =>
      'Todavía no hay suficiente actividad este mes para una proyección sólida.';

  @override
  String get vasEnCaminoACerrarElMes =>
      'Vas en camino a cerrar el mes con saldo positivo si mantenés este ritmo.';

  @override
  String get tuRitmoActualPodriaDejarteConMuy =>
      'Tu ritmo actual podría dejarte con muy poco margen al cierre del mes.';

  @override
  String get siElGastoSigueAEsteRitmo =>
      'Si el gasto sigue a este ritmo, este mes podría cerrar en déficit.';

  @override
  String get muySaludable => 'Muy saludable';

  @override
  String get tuMesVieneEquilibradoYConBuen =>
      'Tu mes viene equilibrado y con buen margen para absorber imprevistos.';

  @override
  String get tusNumerosEstanBastanteControladosConAlgunos =>
      'Tus números están bastante controlados, con algunos puntos para seguir de cerca.';

  @override
  String get tuFlujoSigueFuncionandoPeroConvieneAjustar =>
      'Tu flujo sigue funcionando, pero conviene ajustar antes de que el mes se ponga más justo.';

  @override
  String get elRitmoActualPuedeDejarteSinMargen =>
      'El ritmo actual puede dejarte sin margen antes de cerrar el mes.';

  @override
  String get masDeLoQueEntra => 'Más de lo que entra';

  @override
  String get mesConMargen => 'Mes con margen';

  @override
  String get categoriaDominante => 'Categoría dominante';

  @override
  String get cambioBruscoDeGasto => 'Cambio brusco de gasto';

  @override
  String get buenAjuste => 'Buen ajuste';

  @override
  String get riesgoDeFinDeMes => 'Riesgo de fin de mes';

  @override
  String get ritmoBajoControl => 'Ritmo bajo control';

  @override
  String get gastoAtipico => 'Gasto atípico';

  @override
  String get ahorroSaludable => 'Ahorro saludable';

  @override
  String get sugerenciaSimple => 'Sugerencia simple';

  @override
  String get mesEnMejora => 'Mes en mejora';

  @override
  String get mesMasExigente => 'Mes más exigente';

  @override
  String get metaEncaminada => 'Meta encaminada';

  @override
  String get despuesDeGastarYAhorrarTodaviaTe =>
      'Después de gastar y ahorrar, todavía te queda un margen positivo este mes.';

  @override
  String get tuProyeccionDeGastoCierraDentroDel =>
      'Tu proyección de gasto cierra dentro del margen disponible para este mes.';

  @override
  String get reservarAunqueSeaUn5AlCobrar =>
      'Reservar aunque sea un 5% al cobrar puede darte más aire para fin de mes.';

  @override
  String get tuResultadoMensualVieneMejorQueEl =>
      'Tu resultado mensual viene mejor que el del período anterior.';

  @override
  String get tuMargenBajoFrenteAlMesAnterior =>
      'Tu margen bajó frente al mes anterior. Vale la pena revisar el ritmo.';

  @override
  String get actualizaTuRegistro => 'Actualizá tu registro';

  @override
  String get registraUnMovimientoEnSegundos =>
      'Registrá un movimiento en segundos';

  @override
  String get usaLenguajeSimpleYDejaSoloLa =>
      'Usá lenguaje simple y dejá solo la información necesaria.';

  @override
  String get elegiQueTipoDeMovimientoQueresRegistrar =>
      'Elegí qué tipo de movimiento querés registrar.';

  @override
  String get ingresaUnMontoValido => 'Ingresá un monto válido.';

  @override
  String get elegiUnaCategoria => 'Elegí una categoría';

  @override
  String get elegiLaCategoriaPrincipal => 'Elegí la categoría principal.';

  @override
  String get subcategoriaOpcional => 'Subcategoría (opcional)';

  @override
  String get siAplicaElegiUnDetalleMasEspecifico =>
      'Si aplica, elegí un detalle más específico.';

  @override
  String get vinculaElMovimientoConUnaDeTus =>
      'Vinculá el movimiento con una de tus metas de ahorro.';

  @override
  String get siGuardasAhoraQuedaraEnAhorroGeneral =>
      'Si guardás ahora, quedará en Ahorro general y podés crear una meta después.';

  @override
  String get tipSiElegisUnaMetaVasA =>
      'Tip: si elegís una meta, vas a seguir el progreso más fácil en Ahorros.';

  @override
  String get elegiUnMedioDePago => 'Elegí un medio de pago';

  @override
  String get ejemploCompraSemanalOPagoDeServicio =>
      'Ejemplo: compra semanal o pago de servicio';

  @override
  String get protegerBackup => 'Proteger backup';

  @override
  String get agregaUnaContrasenaOpcionalSiLaDejas =>
      'Agregá una contraseña opcional. Si la dejás vacía, el backup se exportará como JSON legible.';

  @override
  String get backupLocalDeCleanfinance => 'Backup local de CleanFinance';

  @override
  String get estaAccionReemplazaraTusDatosLocalesActuales =>
      'Esta acción reemplazará tus datos locales actuales. El archivo se validará antes de importar para no tocar tus datos si encuentra problemas.';

  @override
  String get siEsteBackupFueProtegidoConContrasena =>
      'Si este backup fue protegido con contraseña, ingresala ahora. Si es un JSON plano, dejala vacía.';

  @override
  String get datosImportadosCorrectamente => 'Datos importados correctamente.';

  @override
  String get borrarTodosLosDatos => 'Borrar todos los datos';

  @override
  String get estoEliminaraLaBaseLocalCompletaEl =>
      'Esto eliminará la base local completa, el PIN, los datos de recuperación y las banderas de biometría, dejando la app como una instalación limpia.';

  @override
  String get borrarTodo => 'Borrar todo';

  @override
  String get seBorraronTodosLosDatosLocalesLa =>
      'Se borraron todos los datos locales. La app quedó en estado de instalación limpia.';

  @override
  String get contrasenaOpcional => 'Contraseña (opcional)';

  @override
  String get unaAppSimplePrivadaYClara => 'Una app simple, privada y clara';

  @override
  String get configuraLaExperienciaParaQueSeSienta =>
      'Configurá la experiencia para que se sienta realmente tuya.';

  @override
  String get manteneAccesoRapidoSinPerderPrivacidad =>
      'Mantené acceso rápido sin perder privacidad.';

  @override
  String get usaHuellaOReconocimientoFacialSiEsta =>
      'Usá huella o reconocimiento facial si está disponible.';

  @override
  String get esteDispositivoNoTieneBiometriaDisponible =>
      'Este dispositivo no tiene biometría disponible.';

  @override
  String get bloqueoAutomatico => 'Bloqueo automático';

  @override
  String get revisaQueGuardaCleanfinanceDeFormaLocal =>
      'Revisá qué guarda CleanFinance de forma local, cómo funcionan los backups y qué datos nunca se envían a servidores.';

  @override
  String get seguirSistema => 'Seguir sistema';

  @override
  String get recibiRecordatoriosMensualesEnEsteTelefono =>
      'Recibí recordatorios mensuales en este teléfono.';

  @override
  String get notificacionesDelSistema => 'Notificaciones del sistema';

  @override
  String get horaDeRecordatorio => 'Hora de recordatorio';

  @override
  String get personalizaLasListasQueUsasTodosLos =>
      'Personalizá las listas que usás todos los días para que cargar datos siga siendo rápido y claro.';

  @override
  String get tusDatosVivenEnTuDispositivoPodes =>
      'Tus datos viven en tu dispositivo. Podés exportarlos o restaurarlos cuando quieras.';

  @override
  String get notaDeSeguridadLosBackupsLocalesPueden =>
      'Nota de seguridad: los backups locales pueden exportarse como JSON plano. Ahora podés agregar una contraseña opcional, pero los datos guardados en SQLite dentro del dispositivo siguen sin cifrado de base.';

  @override
  String get privacidadPrimeroNoHayTrackingNoSe =>
      'Privacidad primero: no hay tracking, no se suben datos financieros y todo queda bajo tu control local.';

  @override
  String get noSePudieronCargarLosAjustes =>
      'No se pudieron cargar los ajustes';

  @override
  String get revisandoPermiso => 'Revisando permiso...';

  @override
  String get noSePudoRevisarElPermiso => 'No se pudo revisar el permiso';

  @override
  String get notificacionesDesactivadas => 'Notificaciones desactivadas';

  @override
  String get notificacionesActivadas => 'Notificaciones activadas';

  @override
  String get permisoPendiente => 'Permiso pendiente';

  @override
  String get permisoDenegado => 'Permiso denegado';

  @override
  String get noDisponibleEnEstaPlataforma => 'No disponible en esta plataforma';

  @override
  String get errorInesperado => 'Error inesperado.';

  @override
  String get pinIncorrecto => 'PIN incorrecto.';

  @override
  String get nuevoPin => 'Nuevo PIN';

  @override
  String get confirmarPin => 'Confirmar PIN';

  @override
  String get validando => 'Validando...';

  @override
  String get empezar => 'Empezar';

  @override
  String get desbloquear => 'Desbloquear';

  @override
  String get eliminarPresupuesto => 'Eliminar presupuesto';

  @override
  String get eliminar => 'Eliminar';

  @override
  String get guardando => 'Guardando...';

  @override
  String get reintentar => 'Reintentar';

  @override
  String get atencion => 'Atención';

  @override
  String get excedido => 'Excedido';

  @override
  String get normal => 'Normal';

  @override
  String get bajo => 'Bajo';

  @override
  String get medio => 'Medio';

  @override
  String get alto => 'Alto';

  @override
  String get estable => 'Estable';

  @override
  String get enRiesgo => 'En riesgo';

  @override
  String get eliminarCategoria => 'Eliminar categoría';

  @override
  String get nuevaCategoria => 'Nueva categoría';

  @override
  String get editarCategoria => 'Editar categoría';

  @override
  String get nombre => 'Nombre';

  @override
  String get recomendaciones => 'Recomendaciones';

  @override
  String get movimientosRecientes => 'Movimientos recientes';

  @override
  String get recordatoriosDeGastos => 'Recordatorios de gastos';

  @override
  String get recordatoriosDeAhorro => 'Recordatorios de ahorro';

  @override
  String get eliminarMovimiento => 'Eliminar movimiento';

  @override
  String get agregarMovimiento => 'Agregar movimiento';

  @override
  String get evolucionMensual => 'Evolución mensual';

  @override
  String get ritmoDeGasto => 'Ritmo de gasto';

  @override
  String get proyeccion => 'Proyección';

  @override
  String get estado => 'Estado';

  @override
  String get metasDeAhorro => 'Metas de ahorro';

  @override
  String get lecturaRapida => 'Lectura rápida';

  @override
  String get enRango => 'En rango';

  @override
  String get atencion2 => 'Atención';

  @override
  String get riesgo => 'Riesgo';

  @override
  String get nuevo => 'Nuevo';

  @override
  String get sinEstimacionTodavia => 'Sin estimación todavía';

  @override
  String get nombreDeLaMeta => 'Nombre de la meta';

  @override
  String get montoObjetivo => 'Monto objetivo';

  @override
  String get guardarMeta => 'Guardar meta';

  @override
  String get eliminarMeta => 'Eliminar meta';

  @override
  String get ahorroGeneral => 'Ahorro general';

  @override
  String get objetivo => 'Objetivo';

  @override
  String get advertenciaElArchivoNoEstaCifrado =>
      'Advertencia: el archivo no está cifrado.';

  @override
  String get oneMinute => '1 minuto';

  @override
  String get fiveMinutes => '5 minutos';

  @override
  String get fifteenMinutes => '15 minutos';

  @override
  String get thirtyMinutes => '30 minutos';

  @override
  String get tema => 'Tema';

  @override
  String get claro => 'Claro';

  @override
  String get oscuro => 'Oscuro';

  @override
  String get moneda => 'Moneda';

  @override
  String get notificaciones => 'Notificaciones';

  @override
  String get organizacion => 'Organización';

  @override
  String get netoEstimado => 'Neto estimado';

  @override
  String get icono => 'Ícono';

  @override
  String get tocaParaCambiar => 'Tocá para cambiar';

  @override
  String get elegiUnIcono => 'Elegí un ícono';

  @override
  String get seleccionar => 'Seleccionar';

  @override
  String get total => 'Total';

  @override
  String get movementFormMissingCategory =>
      'Seleccioná una categoría antes de guardar.';

  @override
  String movementFormLoadCategoriesError(Object error) {
    return 'No se pudieron cargar categorías: $error';
  }

  @override
  String financeInsightOvercommittedMessage(Object percentage) {
    return 'Tus gastos y ahorros ya consumieron $percentage% de tus ingresos del mes.';
  }

  @override
  String financeInsightDominantCategoryMessage(
      Object percentage, Object categoryName) {
    return '$categoryName concentra $percentage% de tus gastos del mes.';
  }

  @override
  String financeInsightExpenseIncreaseMessage(
      Object percentage, Object categoryName) {
    return '$categoryName subió $percentage% frente al mes anterior.';
  }

  @override
  String financeInsightExpenseDecreaseMessage(
      Object percentage, Object categoryName) {
    return '$categoryName bajó $percentage% frente al mes anterior.';
  }

  @override
  String financeInsightEndOfMonthRiskMessage(Object amount) {
    return 'Si seguís con este ritmo, podrías cerrar con un margen $amount por debajo de cero.';
  }

  @override
  String financeInsightAtypicalExpenseMessage(Object percentage) {
    return 'Una sola compra representó $percentage% de tus ingresos del mes.';
  }

  @override
  String financeInsightHealthySavingsMessage(Object percentage) {
    return 'Ya separaste $percentage% de tus ingresos del mes.';
  }

  @override
  String financeInsightGoalOnTrackMessage(Object percentage, Object goalName) {
    return '$goalName ya va en $percentage% y mantiene buen ritmo.';
  }

  @override
  String get authRecoveryDocumentExample => 'Ejemplo: 12345678';

  @override
  String get authUseBiometrics => 'Usar biometría';

  @override
  String get authUnlockWithPinOrBiometrics =>
      'Entrá con tu PIN o usá biometría para acceder rápido a tus finanzas.';

  @override
  String authWaitBeforeRetry(Object seconds) {
    return 'Esperá ${seconds}s para volver a intentar.';
  }

  @override
  String get authBiometricsEnabledTip =>
      'Tip: si activaste biometría, entrar te lleva un toque.';

  @override
  String get authBiometricsUnavailablePinProtected =>
      'La biometría no está disponible en este dispositivo, pero tu PIN sigue protegido localmente.';

  @override
  String get estaCategoria => 'Esta categoría';

  @override
  String get tuMeta => 'Tu meta';

  @override
  String get revisaTusDatosDeRecuperacionEIntenta =>
      'Revisá tus datos de recuperación e intentá nuevamente.';

  @override
  String get laBiometriaNoEstaDisponibleEnEste =>
      'La biometría no está disponible en este dispositivo.';

  @override
  String get noSePudoUsarLaBiometriaConfigura =>
      'No se pudo usar la biometría. Configurá huella/rostro y bloqueo de pantalla.';

  @override
  String get noSePudoValidarLaBiometriaVerifica =>
      'No se pudo validar la biometría. Verificá la configuración del dispositivo.';

  @override
  String get noSePudoVerificarLaRecuperacionRevisa =>
      'No se pudo verificar la recuperación. Revisá tus datos e intentá nuevamente.';

  @override
  String get algunasValidacionesDeSeguridadNoPudieronInicializarse =>
      'Algunas validaciones de seguridad no pudieron inicializarse. La app está en modo seguro.';

  @override
  String get completaAmbasRespuestasDeRecuperacion =>
      'Completá ambas respuestas de recuperación.';

  @override
  String get usaUnaFechaValidaYUnDocumento =>
      'Usá una fecha válida y un documento con al menos 6 caracteres.';

  @override
  String get losPinNoCoinciden => 'Los PIN no coinciden.';

  @override
  String get recuperaTuAccesoSinComplicarte =>
      'Recuperá tu acceso sin complicarte';

  @override
  String get respondeTusDosPreguntasPersonalesYElegi =>
      'Respondé tus dos preguntas personales y elegí un PIN nuevo.';

  @override
  String get laRecuperacionLocalEsMenosRobustaQue =>
      'La recuperación local es menos robusta que tu PIN. Si alguien conoce estos datos y tiene el dispositivo, podría intentar restablecer el acceso.';

  @override
  String get ejemplo10021996 => 'Ejemplo: 10/02/1996';

  @override
  String get activarHuellaParaProximosAccesos =>
      'Activar huella para próximos accesos';

  @override
  String get asiVasAPoderEntrarMasRapido =>
      'Así vas a poder entrar más rápido después de recuperar tu cuenta.';

  @override
  String get completaTusDosPreguntasDeRecuperacion =>
      'Completá tus dos preguntas de recuperación.';

  @override
  String get creaUnPinCortoParaProtegerTus =>
      'Creá un PIN corto para proteger tus datos. Todo queda guardado solo en tu dispositivo.';

  @override
  String get elegiTuPin => 'Elegí tu PIN';

  @override
  String get repetiTuPin => 'Repetí tu PIN';

  @override
  String get activarHuellaParaEntrarMasRapido =>
      'Activar huella para entrar más rápido';

  @override
  String get laAppTeLaVaAOfrecer =>
      'La app te la va a ofrecer en el próximo desbloqueo.';

  @override
  String get configurando => 'Configurando...';

  @override
  String get guardamosEstasRespuestasSoloParaAyudarteA =>
      'Guardamos estas respuestas solo para ayudarte a recuperar el acceso si olvidás tu PIN.';

  @override
  String get lasRespuestasDeRecuperacionSonMasDebiles =>
      'Las respuestas de recuperación son más débiles que tu PIN. Usá datos reales, pero tené en cuenta que alguien que los conozca podría intentar restablecer el acceso en este dispositivo.';

  @override
  String get estePresupuestoMensualSeEliminaraYEl =>
      'Este presupuesto mensual se eliminará y el seguimiento de esta categoría se detendrá hasta que crees uno nuevo.';

  @override
  String get seleccionaUnaCategoria => 'Seleccioná una categoría.';

  @override
  String get primeroCreaUnaCategoriaDeGasto =>
      'Primero creá una categoría de gasto';

  @override
  String get losPresupuestosSeCreanAPartirDe =>
      'Los presupuestos se crean a partir de tus categorías de gasto existentes.';

  @override
  String get ajustaEstePresupuestoMensual => 'Ajustá este presupuesto mensual';

  @override
  String get creaUnPresupuestoMensualPorCategoria =>
      'Creá un presupuesto mensual por categoría';

  @override
  String get losPresupuestosSeGuardanLocalmenteYSe =>
      'Los presupuestos se guardan localmente y se comparan con tus gastos del mes actual.';

  @override
  String get elegiLaCategoriaDeGastoParaEste =>
      'Elegí la categoría de gasto para este presupuesto mensual.';

  @override
  String get ingresaUnLimiteMensualValido =>
      'Ingresá un límite mensual válido.';

  @override
  String get presupuestosMensuales => 'Presupuestos mensuales';

  @override
  String get seguiComoVieneCadaCategoriaEsteMes =>
      'Seguí cómo viene cada categoría este mes y ajustá los límites cuando lo necesites.';

  @override
  String get creaTuPrimerPresupuesto => 'Creá tu primer presupuesto';

  @override
  String get definiUnLimiteMensualParaUnaCategoria =>
      'Definí un límite mensual para una categoría de gasto y vamos a seguir cuánto ya gastaste.';

  @override
  String get agregarPresupuesto => 'Agregar presupuesto';

  @override
  String get noSePudieronCargarLosPresupuestos =>
      'No se pudieron cargar los presupuestos';

  @override
  String get eliminarSubcategoria => 'Eliminar subcategoría';

  @override
  String get categoriaPadre => 'Categoría padre';

  @override
  String get sinCategoriaPadre => 'Sin categoría padre';

  @override
  String get elegiUnaCategoriaPrincipalSoloSiQueres =>
      'Elegí una categoría principal solo si querés crear una subcategoría.';

  @override
  String get usaEstaSubcategoriaParaServiciosOGastos =>
      'Usá esta subcategoría para servicios o gastos recurrentes.';

  @override
  String get saldoActual => 'Saldo actual';

  @override
  String get ahorroTotal => 'Ahorro total';

  @override
  String get todaviaNoHayRecomendaciones => 'Todavía no hay recomendaciones';

  @override
  String get cargaAlgunosMovimientosParaVerAlertasY =>
      'Cargá algunos movimientos para ver alertas y recomendaciones simples.';

  @override
  String get ingresosVsGastos => 'Ingresos vs gastos';

  @override
  String get unaLecturaRapidaDeComoVieneEl =>
      'Una lectura rápida de cómo viene el mes.';

  @override
  String get comparaTusIngresosYGastosDeLos =>
      'Compará tus ingresos y gastos de los últimos 6 meses.';

  @override
  String get gastosPorCategoria => 'Gastos por categoría';

  @override
  String get simpleClaroYFacilDeLeer => 'Simple, claro y fácil de leer.';

  @override
  String get todaviaNoHayGastosSuficientes =>
      'Todavía no hay gastos suficientes';

  @override
  String get cuandoRegistresGastosVasAVerTus =>
      'Cuando registres gastos, vas a ver tus categorías principales acá.';

  @override
  String get agregarGasto => 'Agregar gasto';

  @override
  String get empezaConTuPrimerMovimiento => 'Empezá con tu primer movimiento';

  @override
  String get cargarGastosEIngresosTeVaA =>
      'Cargar gastos e ingresos te va a permitir ver resumen, alertas y gráficos.';

  @override
  String get noPudimosCargarElInicio => 'No pudimos cargar el inicio';

  @override
  String get sinCategoria => 'Sin categoría';

  @override
  String get revisaTusRecordatoriosMensualesActivos =>
      'Revisá tus recordatorios mensuales activos';

  @override
  String get losRecordatoriosDeGastoSalenDeSubcategorias =>
      'Los recordatorios de gasto salen de subcategorías y los de ahorro salen de metas.';

  @override
  String get noHayRecordatoriosDeGastoActivos =>
      'No hay recordatorios de gasto activos';

  @override
  String get activaRecordatoriosAlCrearOEditarUna =>
      'Activá recordatorios al crear o editar una subcategoría de gastos.';

  @override
  String get noSePudieronCargarLosRecordatoriosDe =>
      'No se pudieron cargar los recordatorios de gasto';

  @override
  String get noHayRecordatoriosDeAhorroActivos =>
      'No hay recordatorios de ahorro activos';

  @override
  String get activaRecordatoriosAlCrearOEditarUna2 =>
      'Activá recordatorios al crear o editar una meta de ahorro.';

  @override
  String get metaCompletada => 'Meta completada';

  @override
  String get noSePudieronCargarLosRecordatoriosDe2 =>
      'No se pudieron cargar los recordatorios de ahorro';

  @override
  String get elegiElDiaDelMesParaEl =>
      'Elegí el día del mes para el recordatorio.';

  @override
  String get seEliminaraEsteMovimientoDeFormaPermanente =>
      'Se eliminará este movimiento de forma permanente. Verificá los datos antes de continuar.';

  @override
  String get elegiSoloLoNecesarioParaEncontrarRapido =>
      'Elegí solo lo necesario para encontrar rápido lo que buscás.';

  @override
  String get filtraPorUnaCategoriaPrincipalParaAcotar =>
      'Filtrá por una categoría principal para acotar la búsqueda.';

  @override
  String get noEncontramosMovimientos => 'No encontramos movimientos';

  @override
  String get probaCambiandoElFiltroOAgregandoUn =>
      'Probá cambiando el filtro o agregando un nuevo registro.';

  @override
  String get noSePudieronCargarLosMovimientos =>
      'No se pudieron cargar los movimientos';

  @override
  String get editarMedioDePago => 'Editar medio de pago';

  @override
  String get ejemploQrTransferenciaOEfectivo =>
      'Ejemplo: QR, transferencia o efectivo';

  @override
  String get elegiSoloLosMediosDePagoQue =>
      'Elegí solo los medios de pago que realmente usás';

  @override
  String get estasOpcionesVanAAparecerComoDesplegable =>
      'Estas opciones van a aparecer como desplegable al cargar un movimiento.';

  @override
  String get todaviaNoHayMediosDePago => 'Todavía no hay medios de pago';

  @override
  String get agregaTusOpcionesHabitualesComoTransferenciaDebito =>
      'Agregá tus opciones habituales como transferencia, débito o efectivo.';

  @override
  String get saludFinanciera => 'Salud financiera';

  @override
  String get cashflowMensual => 'Cashflow mensual';

  @override
  String get unResumenRapidoParaEntenderCuantoEntro =>
      'Un resumen rápido para entender cuánto entró, cuánto salió y qué margen te quedó.';

  @override
  String get saldoNeto => 'Saldo neto';

  @override
  String get comparaComoVienenTusIngresosYGastos =>
      'Compará cómo vienen tus ingresos y gastos en los últimos meses.';

  @override
  String get topCategoriasDelMes => 'Top categorías del mes';

  @override
  String get vasAVerEnQueSeFue =>
      'Vas a ver en qué se fue más dinero y cómo cambió frente al mes anterior.';

  @override
  String get sinDatosTodavia => 'Sin datos todavía';

  @override
  String get cuandoRegistresGastosVasAVerAca =>
      'Cuando registres gastos, vas a ver acá en qué categorías se fue más dinero.';

  @override
  String get teMuestraSiElGastoAcumuladoVa =>
      'Te muestra si el gasto acumulado va dentro del margen esperable para este momento del mes.';

  @override
  String get esperadoHoy => 'Esperado hoy';

  @override
  String get elRitmoActualEsExigenteParaTu =>
      'El ritmo actual es exigente para tu margen disponible.';

  @override
  String get vasCercaDelLimiteConvieneMirarCon =>
      'Vas cerca del límite. Conviene mirar con atención la segunda mitad del mes.';

  @override
  String get tuGastoVieneEnUnaZonaSaludable =>
      'Tu gasto viene en una zona saludable para este momento del mes.';

  @override
  String get seguimientoSimpleDelAvanceRitmoDeAporte =>
      'Seguimiento simple del avance, ritmo de aporte y fecha estimada de cumplimiento.';

  @override
  String get todaviaNoHayMetasParaAnalizar =>
      'Todavía no hay metas para analizar';

  @override
  String get cuandoTengasMetasYAportesVasA =>
      'Cuando tengas metas y aportes, vas a ver acá el ritmo de avance.';

  @override
  String get gastosPorMedioDePago => 'Gastos por medio de pago';

  @override
  String get teAyudaAVerQueMetodoEstas =>
      'Te ayuda a ver qué método estás usando más en el mes.';

  @override
  String get noSePudieronCargarLosReportes =>
      'No se pudieron cargar los reportes';

  @override
  String get elegiUnDiaDeRecordatorioValido =>
      'Elegí un día de recordatorio válido.';

  @override
  String get definiUnaMetaSimpleYVisible => 'Definí una meta simple y visible';

  @override
  String get nombreClaroMontoObjetivoYFechaOpcional =>
      'Nombre claro, monto objetivo y fecha opcional. Nada más.';

  @override
  String get ingresaUnNombre => 'Ingresá un nombre.';

  @override
  String get agregarFechaObjetivo => 'Agregar fecha objetivo';

  @override
  String get teAyudaANoOlvidarteDelAporte =>
      'Te ayuda a no olvidarte del aporte mensual para esta meta.';

  @override
  String get elegiElDiaDelMesEnEl =>
      'Elegí el día del mes en el que querés recibir el recordatorio.';

  @override
  String get todaviaNoTenesAhorroRegistrado =>
      'Todavía no tenés ahorro registrado';

  @override
  String get creaUnaMetaORegistraUnAporte =>
      'Creá una meta o registrá un aporte para empezar a ordenar tus ahorros.';

  @override
  String get totalAhorrado => 'Total ahorrado';

  @override
  String get todoLoQueAhorrasteEstaOrganizadoEn =>
      'Todo lo que ahorraste está organizado en metas.';

  @override
  String get logradas => 'Logradas';

  @override
  String get metasLogradas => 'Metas logradas';

  @override
  String get noPudimosCargarTusMetas => 'No pudimos cargar tus metas';

  @override
  String get noPudimosCargarAhorros => 'No pudimos cargar ahorros';

  @override
  String get dineroGuardadoSinUnaMetaEspecifica =>
      'Dinero guardado sin una meta específica.';

  @override
  String get creaUnaMetaParaOrganizarMejorTus =>
      'Creá una meta para organizar mejor tus ahorros.';

  @override
  String get excelenteYaAlcanzasteEstaMeta =>
      'Excelente. Ya alcanzaste esta meta.';

  @override
  String get proyeccionDeFinDeMes => 'Proyeccion de fin de mes';

  @override
  String get gastoProyectado => 'Gasto proyectado';

  @override
  String get usaUnaOpcionClaraParaReconocerMas =>
      'Usá una opción clara para reconocer más rápido la categoría.';

  @override
  String get iconoSeleccionado => 'Ícono seleccionado';

  @override
  String get todaviaTeQuedaPagarOAhorrarPara =>
      'Todavía te queda pagar o ahorrar para:';

  @override
  String get pinLabel => 'PIN';

  @override
  String authPinLengthInvalid(Object length) {
    return 'El PIN debe tener $length dígitos.';
  }

  @override
  String authLockoutActive(Object seconds) {
    return 'Demasiados intentos fallidos. Esperá $seconds segundos antes de volver a intentar.';
  }

  @override
  String categoriesLoadError(Object error) {
    return 'No se pudieron cargar las categorías: $error';
  }

  @override
  String deleteSubcategoryMessage(Object name) {
    return 'Se eliminará la subcategoría \"$name\". Si tiene movimientos o dependencias, la app lo bloqueará antes de borrar.';
  }

  @override
  String deleteCategoryMessage(Object name) {
    return 'Se eliminará la categoría \"$name\". Si tiene movimientos, subcategorías o presupuestos asociados, la app lo bloqueará antes de borrar.';
  }

  @override
  String dashboardRemainingPositive(Object amount) {
    return 'Te quedan $amount este mes.';
  }

  @override
  String dashboardRemainingNegative(Object amount) {
    return 'Este mes vas $amount por encima de tu margen.';
  }

  @override
  String projectionAverageExpensePace(Object amount, Object days) {
    return 'Ritmo promedio: $amount/día. Quedan $days días.';
  }

  @override
  String reportsShareOfTotal(Object percentage) {
    return '$percentage% del total';
  }

  @override
  String reportsPreviousMonth(Object amount) {
    return 'Mes anterior: $amount';
  }

  @override
  String savingsGoalProgress(Object saved, Object target) {
    return '$saved de $target';
  }

  @override
  String goalAverageContribution(Object amount) {
    return 'Aporte promedio: $amount por mes';
  }

  @override
  String goalContributionThisMonth(Object amount) {
    return 'Aporte este mes: $amount';
  }

  @override
  String goalEstimatedDate(Object date) {
    return 'Fecha estimada: $date';
  }

  @override
  String deleteSavingsGoalMessage(Object name) {
    return 'Se eliminará la meta \"$name\". Los aportes ya registrados seguirán existiendo, pero dejarán de estar vinculados a esta meta.';
  }

  @override
  String savingsGeneralIncluded(Object amount) {
    return 'Incluye $amount en ahorro general.';
  }

  @override
  String savingsContributionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aportes registrados.',
      one: '1 aporte registrado.',
    );
    return '$_temp0';
  }

  @override
  String savingsContributionCountWithDate(num count, Object date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aportes · último: $date.',
      one: '1 aporte · último: $date.',
    );
    return '$_temp0';
  }

  @override
  String savingsGoalTargetDate(Object date) {
    return 'Objetivo: $date';
  }

  @override
  String savingsGoalRemaining(Object amount) {
    return 'Te falta $amount para llegar.';
  }

  @override
  String get privacySummaryTitle => 'Resumen';

  @override
  String get privacySummaryBody1 =>
      'CleanFinance es una app de finanzas personales offline-first. No crea cuentas online, no sube tus registros financieros a servidores del desarrollador y no incluye SDKs de analítica, publicidad ni tracking.';

  @override
  String get privacySummaryBody2 =>
      'Esta política dentro de la app resume el tratamiento de datos que puede confirmarse desde el código fuente actual. La URL pública de política de privacidad que se publique en Google Play debe reflejar este mismo contenido e incluir el contacto final del desarrollador.';

  @override
  String get privacyStoredDataTitle => 'Datos guardados en tu dispositivo';

  @override
  String get privacyStoredDataBody1 =>
      'CleanFinance guarda en una base SQLite local las categorías, movimientos, metas de ahorro, presupuestos, medios de pago, idioma, tema, preferencia de ocultar montos, preferencia de bloqueo automático y preferencia de biometría.';

  @override
  String get privacyStoredDataBody2 =>
      'La app también guarda en almacenamiento seguro de Android un PIN hasheado, respuestas de recuperación hasheadas para fecha de nacimiento y documento personal, y el estado de bloqueos temporales por intentos fallidos. Las respuestas de recuperación se piden solo para restablecer acceso en este mismo dispositivo si olvidás el PIN.';

  @override
  String get privacyBiometricsTitle => 'Biometría y permisos';

  @override
  String get privacyBiometricsBody1 =>
      'Si activás el desbloqueo biométrico, CleanFinance le pide a Android que valide tu huella o rostro de forma local en el dispositivo. La app no recibe ni almacena tu plantilla biométrica.';

  @override
  String get privacyBiometricsBody2 =>
      'La versión Android solicita el permiso biométrico necesario para mostrar el diálogo del sistema. El manifest principal no declara permisos de ubicación, contactos, cámara, micrófono, SMS, teléfono ni publicidad.';

  @override
  String get privacyBackupsTitle => 'Backups y compartición de archivos';

  @override
  String get privacyBackupsBody1 =>
      'Podés exportar tus datos manualmente desde Configuración. La exportación incluye tu base financiera local y la configuración. Si dejás la contraseña vacía, el archivo se guarda como JSON legible. Si ingresás una contraseña, el archivo se cifra antes de compartirlo o guardarlo.';

  @override
  String get privacyBackupsBody2 =>
      'Las importaciones son iniciadas por vos y reemplazan la base local actual solo después de validar el archivo. CleanFinance no sincroniza backups automáticamente con servidores del desarrollador.';

  @override
  String get privacySharingTitle => 'Compartición, retención y borrado';

  @override
  String get privacySharingBody1 =>
      'La app no comparte datos personales ni financieros con el desarrollador ni con terceros. Los datos quedan en el dispositivo, salvo que vos decidas exportar y compartir un backup manualmente.';

  @override
  String get privacySharingBody2 =>
      'Tus datos permanecen en el dispositivo hasta que los borres, limpies la app, desinstales la app o uses la acción interna para borrar todos los datos locales. Borrar todos los datos elimina la base SQLite, las credenciales en almacenamiento seguro, los datos de recuperación y las banderas de biometría.';

  @override
  String get privacySecurityTitle => 'Notas de seguridad';

  @override
  String get privacySecurityBody1 =>
      'Los datos financieros guardados en SQLite son locales, pero no tienen cifrado a nivel de archivo de base de datos. Los datos sensibles de autenticación se guardan hasheados en almacenamiento seguro. Además, las builds release desactivan el backup en la nube de Android para reducir copias no deseadas de datos financieros locales.';

  @override
  String get privacySecurityBody2 =>
      'Como la recuperación usa fecha de nacimiento y documento personal, alguien que conozca esos datos y tenga el dispositivo podría intentar un restablecimiento local. Por eso es importante proteger el equipo con bloqueo de pantalla de Android.';

  @override
  String get privacyContactTitle => 'Contacto de privacidad';

  @override
  String get privacyContactBody1 =>
      'El canal oficial de contacto de privacidad para la app publicada debe ser el correo de desarrollador que figure en la ficha de Google Play de CleanFinance. Antes de salir a producción, asegurate de que la política pública alojada incluya esa dirección exacta.';

  @override
  String get iconOptionCategory => 'General';

  @override
  String get iconOptionHome => 'Hogar';

  @override
  String get iconOptionBolt => 'Servicios';

  @override
  String get iconOptionRestaurant => 'Comida';

  @override
  String get iconOptionCar => 'Transporte';

  @override
  String get iconOptionHealth => 'Salud';

  @override
  String get iconOptionEducation => 'Educación';

  @override
  String get iconOptionShopping => 'Compras';

  @override
  String get iconOptionEntertainment => 'Ocio';

  @override
  String get iconOptionFinance => 'Finanzas';

  @override
  String get iconOptionFamily => 'Familia';

  @override
  String get iconOptionWork => 'Trabajo';

  @override
  String get iconOptionPayments => 'Pagos';

  @override
  String get iconOptionStorefront => 'Ventas';

  @override
  String get iconOptionSavings => 'Ahorro';

  @override
  String get iconOptionShield => 'Protección';

  @override
  String get iconOptionFlight => 'Viajes';

  @override
  String get iconOptionPalette => 'Decoración';

  @override
  String get iconOptionKitchen => 'Cocina';

  @override
  String get iconOptionReceipt => 'Facturas';

  @override
  String get iconOptionCleaningServices => 'Limpieza';

  @override
  String get iconOptionBuild => 'Mantenimiento';

  @override
  String get iconOptionChair => 'Muebles';

  @override
  String get iconOptionHandyman => 'Reparaciones';

  @override
  String get iconOptionWaterDrop => 'Agua';

  @override
  String get iconOptionTv => 'TV';

  @override
  String get iconOptionLocalFireDepartment => 'Gas';

  @override
  String get iconOptionWifi => 'Internet';

  @override
  String get iconOptionElectricBolt => 'Luz';

  @override
  String get iconOptionCloud => 'Apps';

  @override
  String get iconOptionPlayCircle => 'Streaming';

  @override
  String get iconOptionPhone => 'Teléfono';

  @override
  String get iconOptionCoffee => 'Cafetería';

  @override
  String get iconOptionSetMeal => 'Carnicería';

  @override
  String get iconOptionDeliveryDining => 'Delivery';

  @override
  String get iconOptionBakeryDining => 'Panadería';

  @override
  String get iconOptionRestaurantMenu => 'Restaurantes';

  @override
  String get iconOptionShoppingCart => 'Supermercado';

  @override
  String get iconOptionEco => 'Verdulería';

  @override
  String get iconOptionLocalGasStation => 'Combustible';

  @override
  String get iconOptionLocalParking => 'Estacionamiento';

  @override
  String get iconOptionToll => 'Peajes';

  @override
  String get iconOptionSecurity => 'Seguro';

  @override
  String get iconOptionLocalTaxi => 'Taxi';

  @override
  String get iconOptionDirectionsBus => 'Colectivo';

  @override
  String get iconOptionEmojiTransportation => 'Movilidad';

  @override
  String get iconOptionMedicalServices => 'Consultas';

  @override
  String get iconOptionScience => 'Estudios';

  @override
  String get iconOptionMedication => 'Medicamentos';

  @override
  String get iconOptionHealthAndSafety => 'Prepaga';

  @override
  String get iconOptionMood => 'Odontología';

  @override
  String get iconOptionVisibility => 'Óptica';

  @override
  String get iconOptionMenuBook => 'Cursos';

  @override
  String get iconOptionBook => 'Libros';

  @override
  String get iconOptionEdit => 'Materiales';

  @override
  String get iconOptionSchool => 'Capacitación';

  @override
  String get iconOptionHiking => 'Calzado';

  @override
  String get iconOptionLanguage => 'Online';

  @override
  String get iconOptionCardGiftcard => 'Regalos';

  @override
  String get iconOptionCheckroom => 'Ropa';

  @override
  String get iconOptionDevices => 'Tecnología';

  @override
  String get iconOptionMovie => 'Cine';

  @override
  String get iconOptionEvent => 'Eventos';

  @override
  String get iconOptionSportsEsports => 'Juegos';

  @override
  String get iconOptionNightlife => 'Salidas';

  @override
  String get iconOptionAccountBalanceWallet => 'Comisiones';

  @override
  String get iconOptionReceiptLong => 'Impuestos';

  @override
  String get iconOptionPercent => 'Intereses';

  @override
  String get iconOptionBusiness => 'Monotributo';

  @override
  String get iconOptionCreditCard => 'Tarjetas';

  @override
  String get iconOptionSelfImprovement => 'Personal';

  @override
  String get iconOptionChildCare => 'Guardería';

  @override
  String get iconOptionChildFriendly => 'Hijos';

  @override
  String get iconOptionPets => 'Mascotas';

  @override
  String get iconOptionLunchDining => 'Comidas';

  @override
  String get iconOptionCommute => 'Traslados';

  @override
  String get iconOptionVolunteerActivism => 'Donaciones';

  @override
  String get iconOptionWarning => 'Imprevistos';

  @override
  String get iconOptionMoreHoriz => 'Varios';

  @override
  String get defaultCategoryNameHobbies => 'Hobbies';

  @override
  String get defaultCategoryNameCompras => 'Compras';

  @override
  String get defaultCategoryNameImpuestos => 'Impuestos';

  @override
  String get defaultCategoryNameLimpieza => 'Limpieza';

  @override
  String get defaultCategoryNameMuebles => 'Muebles';

  @override
  String get defaultCategoryNameMantenimientoDelVehiculo =>
      'Mantenimiento del vehículo';

  @override
  String get defaultCategoryNameMateriales => 'Materiales';

  @override
  String get defaultCategoryNameExpensas => 'Expensas';

  @override
  String get defaultCategoryNameInternet => 'Internet';

  @override
  String get defaultCategoryNameAlquiler => 'Alquiler';

  @override
  String get defaultCategoryNamePanaderia => 'Panadería';

  @override
  String get defaultCategoryNameComisionesBancarias => 'Comisiones bancarias';

  @override
  String get defaultCategoryNameDonaciones => 'Donaciones';

  @override
  String get defaultCategoryNameElectrodomesticos => 'Electrodomésticos';

  @override
  String get defaultCategoryNameEstacionamiento => 'Estacionamiento';

  @override
  String get defaultCategoryNameTransportePublico => 'Transporte público';

  @override
  String get defaultCategoryNameOdontologia => 'Odontología';

  @override
  String get defaultCategoryNameTrabajo => 'Trabajo';

  @override
  String get defaultCategoryNameOcio => 'Entretenimiento';

  @override
  String get defaultCategoryNameVerduleria => 'Verdulería';

  @override
  String get defaultCategoryNameSueldo => 'Sueldo';

  @override
  String get defaultCategoryNameOptica => 'Óptica';

  @override
  String get defaultCategoryNameUberCabify => 'Uber / Cabify';

  @override
  String get defaultCategoryNameCafeteria => 'Cafetería';

  @override
  String get defaultCategoryNameRegalos => 'Regalos';

  @override
  String get defaultCategoryNameObraSocialPrepaga => 'Obra social / Prepaga';

  @override
  String get defaultCategoryNameConsultasMedicas => 'Consultas médicas';

  @override
  String get defaultCategoryNameEstudios => 'Estudios';

  @override
  String get defaultCategoryNameCine => 'Cine';

  @override
  String get defaultCategoryNameAlimentacion => 'Comida';

  @override
  String get defaultCategoryNameCuidadoPersonal => 'Cuidado personal';

  @override
  String get defaultCategoryNameGuarderiaColegio => 'Guardería / Colegio';

  @override
  String get defaultCategoryNameHerramientas => 'Herramientas';

  @override
  String get defaultCategoryNameCombustible => 'Combustible';

  @override
  String get defaultCategoryNameMantenimiento => 'Mantenimiento';

  @override
  String get defaultCategoryNameLuz => 'Luz';

  @override
  String get defaultCategoryNameLibros => 'Libros';

  @override
  String get defaultCategoryNameTelefono => 'Teléfono';

  @override
  String get defaultCategoryNameHijos => 'Hijos';

  @override
  String get defaultCategoryNameSalidas => 'Salidas';

  @override
  String get defaultCategoryNameFinanzas => 'Finanzas';

  @override
  String get defaultCategoryNameCuotas => 'Cuotas';

  @override
  String get defaultCategoryNameServicios => 'Servicios';

  @override
  String get defaultCategoryNameReparaciones => 'Reparaciones';

  @override
  String get defaultCategoryNameSuscripcionesEducativas =>
      'Suscripciones educativas';

  @override
  String get defaultCategoryNameTaxiRemis => 'Taxi / Remis';

  @override
  String get defaultCategoryNameDecoracion => 'Decoración';

  @override
  String get defaultCategoryNameTecnologia => 'Tecnología';

  @override
  String get defaultCategoryNameSalud => 'Salud';

  @override
  String get defaultCategoryNameIntereses => 'Intereses';

  @override
  String get defaultCategoryNameJuegos => 'Juegos';

  @override
  String get defaultCategoryNameSupermercado => 'Supermercado';

  @override
  String get defaultCategoryNameCalzado => 'Calzado';

  @override
  String get defaultCategoryNameViaje => 'Viaje';

  @override
  String get defaultCategoryNameCableTv => 'Cable / TV';

  @override
  String get defaultCategoryNamePeajes => 'Peajes';

  @override
  String get defaultCategoryNameVarios => 'Varios';

  @override
  String get defaultCategoryNameRestaurantes => 'Restaurantes';

  @override
  String get defaultCategoryNameMonotributoAutonomos =>
      'Monotributo / Autónomos';

  @override
  String get defaultCategoryNameEventos => 'Eventos';

  @override
  String get defaultCategoryNameAlimentos => 'Comida';

  @override
  String get defaultCategoryNameMascotas => 'Mascotas';

  @override
  String get defaultCategoryNameVacaciones => 'Vacaciones';

  @override
  String get defaultCategoryNameFondoDeEmergencia => 'Fondo de emergencia';

  @override
  String get defaultCategoryNameMedicamentos => 'Medicamentos';

  @override
  String get defaultCategoryNameTransporte => 'Transporte';

  @override
  String get defaultCategoryNameImprevistos => 'Imprevistos';

  @override
  String get defaultCategoryNameCapacitacion => 'Capacitación';

  @override
  String get defaultCategoryNameAgua => 'Agua';

  @override
  String get defaultCategoryNameEducacion => 'Educación';

  @override
  String get defaultCategoryNameFreelance => 'Freelance';

  @override
  String get defaultCategoryNameTarjetasDeCredito => 'Tarjetas de crédito';

  @override
  String get defaultCategoryNameCursos => 'Cursos';

  @override
  String get defaultCategoryNameRopa => 'Ropa';

  @override
  String get defaultCategoryNameComprasOnline => 'Compras online';

  @override
  String get defaultCategoryNameHogar => 'Hogar';

  @override
  String get defaultCategoryNameSeguroDelAuto => 'Seguro del auto';

  @override
  String get defaultCategoryNameStreaming => 'Streaming';

  @override
  String get defaultCategoryNameGas => 'Gas';

  @override
  String get defaultCategoryNameVenta => 'Venta';

  @override
  String get defaultCategoryNameDelivery => 'Delivery';

  @override
  String get defaultCategoryNameCarniceria => 'Carnicería';

  @override
  String get defaultCategoryNameNubeApps => 'Nube / Apps';

  @override
  String get defaultCategoryNameFamilia => 'Familia';

  @override
  String get defaultCategoryNameComidasLaborales => 'Comidas laborales';

  @override
  String get defaultCategoryNameTransporteLaboral => 'Transporte laboral';

  @override
  String get defaultCategoryNameAhorroGeneral => 'Ahorro general';

  @override
  String get defaultCategoryNameOtros => 'Otros';

  @override
  String technicalErrorDetails(Object error) {
    return 'Detalle técnico: $error';
  }

  @override
  String get currencyArsOption => 'ARS (\$)';

  @override
  String get currencyUsdOption => 'USD (US\$)';

  @override
  String get currencyEurOption => 'EUR (€)';
}
