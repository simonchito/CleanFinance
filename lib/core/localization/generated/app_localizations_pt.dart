// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'CleanFinance';

  @override
  String get settings => 'Configurações';

  @override
  String get language => 'Idioma';

  @override
  String get useDeviceLanguage => 'Usar idioma do dispositivo';

  @override
  String get spanish => 'Espanhol';

  @override
  String get english => 'Inglês';

  @override
  String get portuguese => 'Português';

  @override
  String get dashboard => 'Início';

  @override
  String get movements => 'Movimentações';

  @override
  String get savings => 'Economias';

  @override
  String get reports => 'Relatórios';

  @override
  String get income => 'Receita';

  @override
  String get expense => 'Despesa';

  @override
  String get saving => 'Economia';

  @override
  String get category => 'Categoria';

  @override
  String get subcategory => 'Subcategoria';

  @override
  String get savingGoal => 'Meta de economia';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get apply => 'Aplicar';

  @override
  String get clear => 'Limpar';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get paymentMethods => 'Meios de pagamento';

  @override
  String get managePaymentMethods => 'Gerenciar meios de pagamento';

  @override
  String get manageReminders => 'Gerenciar lembretes';

  @override
  String get addPaymentMethod => 'Adicionar meio de pagamento';

  @override
  String get movementPaymentMethod => 'Meio de pagamento';

  @override
  String get paymentMethodTransfer => 'Transferência';

  @override
  String get paymentMethodDebitCard => 'Cartão de débito';

  @override
  String get paymentMethodCreditCard => 'Cartão de crédito';

  @override
  String get paymentMethodUnspecified => 'Não definido';

  @override
  String get monthlyReminder => 'Lembrete mensal';

  @override
  String get monthlyReminderDescription =>
      'Use para despesas mensais recorrentes e veja-as como pendentes até registrar o pagamento.';

  @override
  String get movementReminderTitle => 'Lembrar esta despesa todos os meses';

  @override
  String get movementReminderSubtitle =>
      'Vamos avisar perto do dia deste movimento.';

  @override
  String get movementReminderActive => 'Lembrete ativo';

  @override
  String get movementReminderDisabled => 'Lembrete desativado';

  @override
  String movementReminderMonthlyDay(Object day) {
    return 'Dia $day de cada mês';
  }

  @override
  String get movementReminderSettingsHint =>
      'Este lembrete também pode ser alterado em Ajustes.';

  @override
  String get reminderDay => 'Dia do lembrete';

  @override
  String get pendingThisMonth => 'Pendentes este mês';

  @override
  String get reminderRegisterPayment => 'Registrar pagamento';

  @override
  String get reminderLastRegistered => 'Último registro';

  @override
  String get noSubcategory => 'Sem subcategoria';

  @override
  String get newMovement => 'Nova movimentação';

  @override
  String get editMovement => 'Editar movimentação';

  @override
  String get saveMovement => 'Salvar movimentação';

  @override
  String get saveChanges => 'Salvar alterações';

  @override
  String get unlimitedDate => 'Sem prazo';

  @override
  String get biometric => 'Desbloqueio por biometria';

  @override
  String get exportBackup => 'Exportar backup';

  @override
  String get importBackup => 'Importar backup';

  @override
  String get manageCategories => 'Gerenciar categorias';

  @override
  String get noCategories => 'Ainda não há categorias.';

  @override
  String get mainCategory => 'Categoria principal';

  @override
  String get addSubcategory => 'Adicionar subcategoria';

  @override
  String get manageBudgets => 'Gerenciar orçamentos';

  @override
  String get amountPrivacy => 'Privacidade dos valores';

  @override
  String get amountPrivacyDescription =>
      'Oculte saldos e resumos quando usar o app em público.';

  @override
  String get newBudget => 'Novo orçamento';

  @override
  String get editBudget => 'Editar orçamento';

  @override
  String get monthlyLimit => 'Limite mensal';

  @override
  String get searchByNote => 'Buscar por nota ou referência';

  @override
  String get setupTitle => 'Seu dinheiro, claro e sob controle';

  @override
  String get unlockTitle => 'Boas-vindas de volta';

  @override
  String get recoverAccess => 'Recuperar acesso';

  @override
  String get documentId => 'Documento pessoal';

  @override
  String get paymentMethodQr => 'QR';

  @override
  String get text => 'Atenção';

  @override
  String get text2 => 'Resumo';

  @override
  String get text3 => 'Diagnóstico';

  @override
  String get text4 => 'Projeção';

  @override
  String get text5 => 'Ação';

  @override
  String get text6 => 'Metas';

  @override
  String get appearance => 'Aparência';

  @override
  String get privacy => 'Privacidade';

  @override
  String get security => 'Segurança';

  @override
  String get data => 'Dados';

  @override
  String get paymentMethodCash => 'Dinheiro';

  @override
  String get reminderDayPrefix => 'Dia';

  @override
  String get noGoal => 'Sem meta';

  @override
  String get amount => 'Valor';

  @override
  String get note => 'Nota';

  @override
  String get type => 'Tipo';

  @override
  String get date => 'Data';

  @override
  String get movement => 'Movimentação';

  @override
  String get movementFallbackTitle => 'Movimentação';

  @override
  String get recentMovementUntitled => 'Movimentação';

  @override
  String get movementNoDescription => 'Sem descrição';

  @override
  String get movementsTab => 'Movs.';

  @override
  String get createGoal => 'Criar meta';

  @override
  String get newGoal => 'Nova meta';

  @override
  String get editGoal => 'Editar meta';

  @override
  String get completed => 'Concluídas';

  @override
  String get activeGoals => 'Metas ativas';

  @override
  String get achieved => 'Atingida';

  @override
  String get contribute => 'Contribuir';

  @override
  String get defaultCategory => 'Padrão';

  @override
  String get customCategory => 'Personalizada';

  @override
  String get budgets => 'Orçamentos';

  @override
  String get showAmounts => 'Mostrar valores';

  @override
  String get hideAmounts => 'Ocultar valores';

  @override
  String get spent => 'Gasto';

  @override
  String get remaining => 'Disponível';

  @override
  String get lockNow => 'Bloquear agora';

  @override
  String get add => 'Adicionar';

  @override
  String get all => 'Todos';

  @override
  String get from => 'De';

  @override
  String get to => 'Até';

  @override
  String get filters => 'Filtros';

  @override
  String get forgotPin => 'Esqueci meu PIN';

  @override
  String get birthDate => 'Data de nascimento';

  @override
  String get todaviaNoHaySuficienteActividadEsteMes =>
      'Ainda não há atividade suficiente neste mês para uma projeção confiável.';

  @override
  String get vasEnCaminoACerrarElMes =>
      'Você está no caminho para fechar o mês com saldo positivo se mantiver esse ritmo.';

  @override
  String get tuRitmoActualPodriaDejarteConMuy =>
      'Seu ritmo atual pode deixar pouca margem até o fim do mês.';

  @override
  String get siElGastoSigueAEsteRitmo =>
      'Se os gastos continuarem nesse ritmo, o mês pode fechar no negativo.';

  @override
  String get muySaludable => 'Muito saudável';

  @override
  String get tuMesVieneEquilibradoYConBuen =>
      'Seu mês está equilibrado e com boa margem para imprevistos.';

  @override
  String get tusNumerosEstanBastanteControladosConAlgunos =>
      'Seus números estão bem controlados, com alguns pontos para acompanhar.';

  @override
  String get tuFlujoSigueFuncionandoPeroConvieneAjustar =>
      'Seu fluxo ainda funciona, mas vale ajustar antes que o mês aperte.';

  @override
  String get elRitmoActualPuedeDejarteSinMargen =>
      'O ritmo atual pode deixar você com pouca margem antes do fim do mês.';

  @override
  String get masDeLoQueEntra => 'Mais do que entra';

  @override
  String get mesConMargen => 'Mês com folga';

  @override
  String get categoriaDominante => 'Categoria dominante';

  @override
  String get cambioBruscoDeGasto => 'Mudança forte nos gastos';

  @override
  String get buenAjuste => 'Bom ajuste';

  @override
  String get riesgoDeFinDeMes => 'Risco no fim do mês';

  @override
  String get ritmoBajoControl => 'Ritmo sob controle';

  @override
  String get gastoAtipico => 'Despesa atípica';

  @override
  String get ahorroSaludable => 'Economia saudável';

  @override
  String get sugerenciaSimple => 'Sugestão simples';

  @override
  String get mesEnMejora => 'Mês melhorando';

  @override
  String get mesMasExigente => 'Mês mais apertado';

  @override
  String get metaEncaminada => 'Meta no caminho';

  @override
  String get despuesDeGastarYAhorrarTodaviaTe =>
      'Depois de gastar e economizar, ainda sobra uma margem positiva neste mês.';

  @override
  String get tuProyeccionDeGastoCierraDentroDel =>
      'Sua projeção de gastos ainda fecha dentro da margem disponível para este mês.';

  @override
  String get reservarAunqueSeaUn5AlCobrar =>
      'Separar até 5% ao receber pode dar mais folga até o fim do mês.';

  @override
  String get tuResultadoMensualVieneMejorQueEl =>
      'Seu resultado mensal está melhor que o do período anterior.';

  @override
  String get tuMargenBajoFrenteAlMesAnterior =>
      'Sua margem caiu em relação ao mês anterior. Vale revisar o ritmo.';

  @override
  String get actualizaTuRegistro => 'Atualize seu registro';

  @override
  String get registraUnMovimientoEnSegundos =>
      'Registre uma movimentação em segundos';

  @override
  String get usaLenguajeSimpleYDejaSoloLa =>
      'Use uma linguagem simples e mantenha só o necessário.';

  @override
  String get elegiQueTipoDeMovimientoQueresRegistrar =>
      'Escolha o tipo de movimentação que deseja registrar.';

  @override
  String get ingresaUnMontoValido => 'Informe um valor válido.';

  @override
  String get elegiUnaCategoria => 'Escolha uma categoria';

  @override
  String get elegiLaCategoriaPrincipal => 'Escolha a categoria principal.';

  @override
  String get subcategoriaOpcional => 'Subcategoria (opcional)';

  @override
  String get siAplicaElegiUnDetalleMasEspecifico =>
      'Se fizer sentido, escolha um detalhe mais específico.';

  @override
  String get vinculaElMovimientoConUnaDeTus =>
      'Vincule a movimentação a uma das suas metas de economia.';

  @override
  String get siGuardasAhoraQuedaraEnAhorroGeneral =>
      'Se economizar agora, isso aparecerá em Economias gerais e você poderá criar uma meta depois.';

  @override
  String get tipSiElegisUnaMetaVasA =>
      'Dica: se escolher uma meta, você acompanha o progresso mais rápido em Economias.';

  @override
  String get elegiUnMedioDePago => 'Escolha um meio de pagamento';

  @override
  String get ejemploCompraSemanalOPagoDeServicio =>
      'Exemplo: compras da semana ou conta de serviço';

  @override
  String get protegerBackup => 'Proteger backup';

  @override
  String get agregaUnaContrasenaOpcionalSiLaDejas =>
      'Adicione uma senha opcional. Se deixar vazio, o backup será exportado como JSON legível.';

  @override
  String get backupLocalDeCleanfinance => 'Backup local do CleanFinance';

  @override
  String get estaAccionReemplazaraTusDatosLocalesActuales =>
      'Esta ação substituirá seus dados locais atuais. O arquivo será validado antes da importação para manter seus dados intactos se algo estiver errado.';

  @override
  String get siEsteBackupFueProtegidoConContrasena =>
      'Se este backup foi protegido com senha, informe agora. Deixe vazio para backups em JSON simples.';

  @override
  String get datosImportadosCorrectamente => 'Dados importados com sucesso.';

  @override
  String get borrarTodosLosDatos => 'Excluir todos os dados';

  @override
  String get estoEliminaraLaBaseLocalCompletaEl =>
      'Isso removerá todo o banco local, PIN, dados de recuperação e biometria, deixando o app como uma instalação limpa.';

  @override
  String get borrarTodo => 'Excluir tudo';

  @override
  String get seBorraronTodosLosDatosLocalesLa =>
      'Todos os dados locais foram excluídos. O app voltou ao estado inicial.';

  @override
  String get contrasenaOpcional => 'Senha (opcional)';

  @override
  String get unaAppSimplePrivadaYClara => 'Um app simples, privado e claro';

  @override
  String get configuraLaExperienciaParaQueSeSienta =>
      'Ajuste a experiência para que ela fique do seu jeito.';

  @override
  String get manteneAccesoRapidoSinPerderPrivacidad =>
      'Mantenha o acesso rápido sem perder privacidade.';

  @override
  String get usaHuellaOReconocimientoFacialSiEsta =>
      'Use digital ou reconhecimento facial se estiver disponível.';

  @override
  String get esteDispositivoNoTieneBiometriaDisponible =>
      'Este dispositivo não tem biometria disponível.';

  @override
  String get bloqueoAutomatico => 'Bloqueio automático';

  @override
  String get revisaQueGuardaCleanfinanceDeFormaLocal =>
      'Veja o que o CleanFinance guarda localmente, como os backups funcionam e o que nunca é enviado a servidores.';

  @override
  String get seguirSistema => 'Seguir sistema';

  @override
  String get recibiRecordatoriosMensualesEnEsteTelefono =>
      'Receba lembretes mensais neste dispositivo.';

  @override
  String get notificacionesDelSistema => 'Notificações do sistema';

  @override
  String get horaDeRecordatorio => 'Hora do lembrete';

  @override
  String get personalizaLasListasQueUsasTodosLos =>
      'Personalize as listas que você usa todos os dias para registrar dados com rapidez e clareza.';

  @override
  String get tusDatosVivenEnTuDispositivoPodes =>
      'Seus dados ficam no dispositivo. Você pode exportar ou restaurar quando precisar.';

  @override
  String get notaDeSeguridadLosBackupsLocalesPueden =>
      'Nota de segurança: backups locais podem ser exportados como JSON simples. Agora você pode adicionar uma senha opcional, mas os dados no SQLite do dispositivo ainda não têm criptografia de banco.';

  @override
  String get privacidadPrimeroNoHayTrackingNoSe =>
      'Privacidade em primeiro lugar: sem rastreamento, sem envio de dados financeiros e tudo sob seu controle local.';

  @override
  String get noSePudieronCargarLosAjustes =>
      'Não foi possível carregar as configurações';

  @override
  String get revisandoPermiso => 'Verificando permissão...';

  @override
  String get noSePudoRevisarElPermiso =>
      'Não foi possível verificar a permissão';

  @override
  String get notificacionesDesactivadas => 'Notificações desativadas';

  @override
  String get notificacionesActivadas => 'Notificações ativadas';

  @override
  String get permisoPendiente => 'Permissão pendente';

  @override
  String get permisoDenegado => 'Permissão negada';

  @override
  String get noDisponibleEnEstaPlataforma => 'Não disponível nesta plataforma';

  @override
  String get errorInesperado => 'Erro inesperado.';

  @override
  String get pinIncorrecto => 'PIN incorreto.';

  @override
  String get nuevoPin => 'Novo PIN';

  @override
  String get confirmarPin => 'Confirmar PIN';

  @override
  String get validando => 'Validando...';

  @override
  String get empezar => 'Começar';

  @override
  String get desbloquear => 'Desbloquear';

  @override
  String get eliminarPresupuesto => 'Excluir orçamento';

  @override
  String get eliminar => 'Excluir';

  @override
  String get guardando => 'Salvando...';

  @override
  String get reintentar => 'Tentar novamente';

  @override
  String get atencion => 'Atenção';

  @override
  String get excedido => 'Excedido';

  @override
  String get normal => 'Normal';

  @override
  String get bajo => 'Baixo';

  @override
  String get medio => 'Médio';

  @override
  String get alto => 'Alto';

  @override
  String get estable => 'Estável';

  @override
  String get enRiesgo => 'Em risco';

  @override
  String get eliminarCategoria => 'Excluir categoria';

  @override
  String get nuevaCategoria => 'Nova categoria';

  @override
  String get editarCategoria => 'Editar categoria';

  @override
  String get nombre => 'Nome';

  @override
  String get recomendaciones => 'Recomendações';

  @override
  String get movimientosRecientes => 'Movimentações recentes';

  @override
  String get recordatoriosDeGastos => 'Lembretes de despesas';

  @override
  String get recordatoriosDeAhorro => 'Lembretes de economia';

  @override
  String get eliminarMovimiento => 'Excluir movimentação';

  @override
  String get agregarMovimiento => 'Adicionar movimentação';

  @override
  String get evolucionMensual => 'Evolução mensal';

  @override
  String get ritmoDeGasto => 'Ritmo de gastos';

  @override
  String get proyeccion => 'Projeção';

  @override
  String get estado => 'Estado';

  @override
  String get metasDeAhorro => 'Metas de economia';

  @override
  String get lecturaRapida => 'Leitura rápida';

  @override
  String get enRango => 'Dentro do esperado';

  @override
  String get atencion2 => 'Atenção';

  @override
  String get riesgo => 'Riesgo';

  @override
  String get nuevo => 'Nuevo';

  @override
  String get sinEstimacionTodavia => 'Ainda sem estimativa';

  @override
  String get nombreDeLaMeta => 'Nome da meta';

  @override
  String get montoObjetivo => 'Valor objetivo';

  @override
  String get guardarMeta => 'Salvar meta';

  @override
  String get eliminarMeta => 'Excluir meta';

  @override
  String get ahorroGeneral => 'Economia geral';

  @override
  String get objetivo => 'Objetivo';

  @override
  String get advertenciaElArchivoNoEstaCifrado =>
      'Aviso: o arquivo não está criptografado.';

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
  String get moneda => 'Moeda';

  @override
  String get notificaciones => 'Notificações';

  @override
  String get organizacion => 'Organização';

  @override
  String get netoEstimado => 'Líquido estimado';

  @override
  String get icono => 'Ícone';

  @override
  String get tocaParaCambiar => 'Toque para alterar';

  @override
  String get elegiUnIcono => 'Escolha um ícone';

  @override
  String get seleccionar => 'Selecionar';

  @override
  String get total => 'Total';

  @override
  String get movementFormMissingCategory =>
      'Selecione uma categoria antes de salvar.';

  @override
  String movementFormLoadCategoriesError(Object error) {
    return 'Não foi possível carregar as categorias: $error';
  }

  @override
  String financeInsightOvercommittedMessage(Object percentage) {
    return 'Suas despesas e economias já consumiram $percentage% da receita do mês.';
  }

  @override
  String financeInsightDominantCategoryMessage(
      Object percentage, Object categoryName) {
    return '$categoryName concentra $percentage% dos seus gastos do mês.';
  }

  @override
  String financeInsightExpenseIncreaseMessage(
      Object percentage, Object categoryName) {
    return '$categoryName subiu $percentage% em relação ao mês anterior.';
  }

  @override
  String financeInsightExpenseDecreaseMessage(
      Object percentage, Object categoryName) {
    return '$categoryName caiu $percentage% em relação ao mês anterior.';
  }

  @override
  String financeInsightEndOfMonthRiskMessage(Object amount) {
    return 'Se mantiver esse ritmo, você pode fechar cerca de $amount abaixo de zero.';
  }

  @override
  String financeInsightAtypicalExpenseMessage(Object percentage) {
    return 'Uma única compra representou $percentage% da receita do mês.';
  }

  @override
  String financeInsightHealthySavingsMessage(Object percentage) {
    return 'Você já separou $percentage% da receita do mês.';
  }

  @override
  String financeInsightGoalOnTrackMessage(Object percentage, Object goalName) {
    return '$goalName já chegou a $percentage% e mantém um bom ritmo.';
  }

  @override
  String get authRecoveryDocumentExample => 'Exemplo: 12345678';

  @override
  String get authUseBiometrics => 'Usar biometria';

  @override
  String get authUnlockWithPinOrBiometrics =>
      'Entre com seu PIN ou use biometria para acessar suas finanças rapidamente.';

  @override
  String authWaitBeforeRetry(Object seconds) {
    return 'Aguarde ${seconds}s antes de tentar novamente.';
  }

  @override
  String get authBiometricsEnabledTip =>
      'Dica: se a biometria estiver ativa, entrar leva só um toque.';

  @override
  String get authBiometricsUnavailablePinProtected =>
      'A biometria não está disponível neste dispositivo, mas seu PIN continua protegido localmente.';

  @override
  String get estaCategoria => 'Esta categoria';

  @override
  String get tuMeta => 'Sua meta';

  @override
  String get revisaTusDatosDeRecuperacionEIntenta =>
      'Revise seus dados de recuperação e tente novamente.';

  @override
  String get laBiometriaNoEstaDisponibleEnEste =>
      'A biometria não está disponível neste dispositivo.';

  @override
  String get noSePudoUsarLaBiometriaConfigura =>
      'Não foi possível usar a biometria. Configure digital/rosto e bloqueio de tela.';

  @override
  String get noSePudoValidarLaBiometriaVerifica =>
      'Não foi possível validar a biometria. Verifique a configuração do dispositivo.';

  @override
  String get noSePudoVerificarLaRecuperacionRevisa =>
      'Não foi possível verificar a recuperação. Revise seus dados e tente novamente.';

  @override
  String get algunasValidacionesDeSeguridadNoPudieronInicializarse =>
      'Algumas validações de segurança não puderam ser inicializadas. O app está em modo seguro.';

  @override
  String get completaAmbasRespuestasDeRecuperacion =>
      'Preencha as duas respostas de recuperação.';

  @override
  String get usaUnaFechaValidaYUnDocumento =>
      'Use uma data válida e um documento com pelo menos 6 caracteres.';

  @override
  String get losPinNoCoinciden => 'Os PINs não coincidem.';

  @override
  String get recuperaTuAccesoSinComplicarte =>
      'Recupere seu acesso sem complicação';

  @override
  String get respondeTusDosPreguntasPersonalesYElegi =>
      'Responda às duas perguntas pessoais e escolha um novo PIN.';

  @override
  String get laRecuperacionLocalEsMenosRobustaQue =>
      'A recuperação local é menos robusta que seu PIN. Se alguém conhecer esses dados e tiver o dispositivo, poderá tentar redefinir o acesso.';

  @override
  String get ejemplo10021996 => 'Exemplo: 10/02/1996';

  @override
  String get activarHuellaParaProximosAccesos =>
      'Ativar biometria para próximos acessos';

  @override
  String get asiVasAPoderEntrarMasRapido =>
      'Assim você poderá entrar mais rápido depois de recuperar sua conta.';

  @override
  String get completaTusDosPreguntasDeRecuperacion =>
      'Preencha suas duas perguntas de recuperação.';

  @override
  String get creaUnPinCortoParaProtegerTus =>
      'Crie um PIN curto para proteger seus dados. Tudo fica salvo apenas no seu dispositivo.';

  @override
  String get elegiTuPin => 'Escolha seu PIN';

  @override
  String get repetiTuPin => 'Repita seu PIN';

  @override
  String get activarHuellaParaEntrarMasRapido =>
      'Ativar biometria para entrar mais rápido';

  @override
  String get laAppTeLaVaAOfrecer =>
      'O app vai oferecer isso no próximo desbloqueio.';

  @override
  String get configurando => 'Configurando...';

  @override
  String get guardamosEstasRespuestasSoloParaAyudarteA =>
      'Guardamos estas respostas apenas para ajudar você a recuperar o acesso se esquecer seu PIN.';

  @override
  String get lasRespuestasDeRecuperacionSonMasDebiles =>
      'As respostas de recuperação são mais fracas que seu PIN. Use dados reais, mas lembre que alguém que os conheça poderia tentar redefinir o acesso neste dispositivo.';

  @override
  String get estePresupuestoMensualSeEliminaraYEl =>
      'Este orçamento mensal será excluído e o acompanhamento desta categoria ficará pausado até você criar um novo.';

  @override
  String get seleccionaUnaCategoria => 'Selecione uma categoria.';

  @override
  String get primeroCreaUnaCategoriaDeGasto =>
      'Primeiro crie uma categoria de despesa';

  @override
  String get losPresupuestosSeCreanAPartirDe =>
      'Os orçamentos são criados a partir das categorias de despesa existentes.';

  @override
  String get ajustaEstePresupuestoMensual => 'Ajuste este orçamento mensal';

  @override
  String get creaUnPresupuestoMensualPorCategoria =>
      'Crie um orçamento mensal por categoria';

  @override
  String get losPresupuestosSeGuardanLocalmenteYSe =>
      'Os orçamentos são salvos localmente e comparados com seus gastos do mês atual.';

  @override
  String get elegiLaCategoriaDeGastoParaEste =>
      'Escolha a categoria de despesa para este orçamento mensal.';

  @override
  String get ingresaUnLimiteMensualValido => 'Informe um limite mensal válido.';

  @override
  String get presupuestosMensuales => 'Orçamentos mensais';

  @override
  String get seguiComoVieneCadaCategoriaEsteMes =>
      'Acompanhe como cada categoria está neste mês e ajuste os limites quando precisar.';

  @override
  String get creaTuPrimerPresupuesto => 'Crie seu primeiro orçamento';

  @override
  String get definiUnLimiteMensualParaUnaCategoria =>
      'Defina um limite mensal para uma categoria de despesa e vamos acompanhar quanto você já gastou.';

  @override
  String get agregarPresupuesto => 'Adicionar orçamento';

  @override
  String get noSePudieronCargarLosPresupuestos =>
      'Não foi possível carregar os orçamentos';

  @override
  String get eliminarSubcategoria => 'Excluir subcategoria';

  @override
  String get categoriaPadre => 'Categoria principal';

  @override
  String get sinCategoriaPadre => 'Sem categoria principal';

  @override
  String get elegiUnaCategoriaPrincipalSoloSiQueres =>
      'Escolha uma categoria principal apenas se quiser criar uma subcategoria.';

  @override
  String get usaEstaSubcategoriaParaServiciosOGastos =>
      'Use esta subcategoria para serviços ou despesas recorrentes.';

  @override
  String get saldoActual => 'Saldo atual';

  @override
  String get ahorroTotal => 'Economia total';

  @override
  String get todaviaNoHayRecomendaciones => 'Ainda não há recomendações';

  @override
  String get cargaAlgunosMovimientosParaVerAlertasY =>
      'Registre algumas movimentações para ver alertas e recomendações simples.';

  @override
  String get ingresosVsGastos => 'Receitas vs despesas';

  @override
  String get unaLecturaRapidaDeComoVieneEl =>
      'Uma leitura rápida de como o mês está indo.';

  @override
  String get comparaTusIngresosYGastosDeLos =>
      'Compare suas receitas e despesas dos últimos 6 meses.';

  @override
  String get gastosPorCategoria => 'Despesas por categoria';

  @override
  String get simpleClaroYFacilDeLeer => 'Simples, claro e fácil de ler.';

  @override
  String get todaviaNoHayGastosSuficientes =>
      'Ainda não há despesas suficientes';

  @override
  String get cuandoRegistresGastosVasAVerTus =>
      'Quando registrar despesas, você verá suas categorias principais aqui.';

  @override
  String get agregarGasto => 'Adicionar despesa';

  @override
  String get empezaConTuPrimerMovimiento =>
      'Comece com sua primeira movimentação';

  @override
  String get cargarGastosEIngresosTeVaA =>
      'Registrar despesas e receitas permite ver resumo, alertas e gráficos.';

  @override
  String get noPudimosCargarElInicio => 'Não foi possível carregar o início';

  @override
  String get sinCategoria => 'Sem categoria';

  @override
  String get revisaTusRecordatoriosMensualesActivos =>
      'Revise seus lembretes mensais ativos';

  @override
  String get losRecordatoriosDeGastoSalenDeSubcategorias =>
      'Os lembretes de despesa vêm de subcategorias e os de economia vêm de metas.';

  @override
  String get noHayRecordatoriosDeGastoActivos =>
      'Não há lembretes de despesa ativos';

  @override
  String get activaRecordatoriosAlCrearOEditarUna =>
      'Ative lembretes ao criar ou editar uma subcategoria de despesas.';

  @override
  String get noSePudieronCargarLosRecordatoriosDe =>
      'Não foi possível carregar os lembretes de despesa';

  @override
  String get noHayRecordatoriosDeAhorroActivos =>
      'Não há lembretes de economia ativos';

  @override
  String get activaRecordatoriosAlCrearOEditarUna2 =>
      'Ative lembretes ao criar ou editar uma meta de economia.';

  @override
  String get metaCompletada => 'Meta concluída';

  @override
  String get noSePudieronCargarLosRecordatoriosDe2 =>
      'Não foi possível carregar os lembretes de economia';

  @override
  String get elegiElDiaDelMesParaEl => 'Escolha o dia do mês para o lembrete.';

  @override
  String get seEliminaraEsteMovimientoDeFormaPermanente =>
      'Esta movimentação será excluída permanentemente. Verifique os dados antes de continuar.';

  @override
  String get elegiSoloLoNecesarioParaEncontrarRapido =>
      'Escolha apenas o necessário para encontrar rapidamente o que procura.';

  @override
  String get filtraPorUnaCategoriaPrincipalParaAcotar =>
      'Filtre por uma categoria principal para restringir a busca.';

  @override
  String get noEncontramosMovimientos => 'Não encontramos movimentações';

  @override
  String get probaCambiandoElFiltroOAgregandoUn =>
      'Tente alterar o filtro ou adicionar um novo registro.';

  @override
  String get noSePudieronCargarLosMovimientos =>
      'Não foi possível carregar as movimentações';

  @override
  String get editarMedioDePago => 'Editar meio de pagamento';

  @override
  String get ejemploQrTransferenciaOEfectivo =>
      'Exemplo: QR, transferência ou dinheiro';

  @override
  String get elegiSoloLosMediosDePagoQue =>
      'Escolha apenas os meios de pagamento que você realmente usa';

  @override
  String get estasOpcionesVanAAparecerComoDesplegable =>
      'Estas opções aparecerão como lista suspensa ao registrar uma movimentação.';

  @override
  String get todaviaNoHayMediosDePago => 'Ainda não há meios de pagamento';

  @override
  String get agregaTusOpcionesHabitualesComoTransferenciaDebito =>
      'Adicione suas opções habituais, como transferência, débito ou dinheiro.';

  @override
  String get saludFinanciera => 'Saúde financeira';

  @override
  String get cashflowMensual => 'Fluxo mensal';

  @override
  String get unResumenRapidoParaEntenderCuantoEntro =>
      'Um resumo rápido para entender quanto entrou, quanto saiu e qual margem sobrou.';

  @override
  String get saldoNeto => 'Saldo líquido';

  @override
  String get comparaComoVienenTusIngresosYGastos =>
      'Compare como estão suas receitas e despesas nos últimos meses.';

  @override
  String get topCategoriasDelMes => 'Principais categorias do mês';

  @override
  String get vasAVerEnQueSeFue =>
      'Você verá onde foi gasto mais dinheiro e como isso mudou em relação ao mês anterior.';

  @override
  String get sinDatosTodavia => 'Ainda sem dados';

  @override
  String get cuandoRegistresGastosVasAVerAca =>
      'Quando registrar despesas, você verá aqui em quais categorias foi gasto mais dinheiro.';

  @override
  String get teMuestraSiElGastoAcumuladoVa =>
      'Mostra se o gasto acumulado está dentro da margem esperada para este momento do mês.';

  @override
  String get esperadoHoy => 'Esperado hoje';

  @override
  String get elRitmoActualEsExigenteParaTu =>
      'O ritmo atual é exigente para sua margem disponível.';

  @override
  String get vasCercaDelLimiteConvieneMirarCon =>
      'Você está perto do limite. Convém observar com atenção a segunda metade do mês.';

  @override
  String get tuGastoVieneEnUnaZonaSaludable =>
      'Seu gasto está em uma zona saudável para este momento do mês.';

  @override
  String get seguimientoSimpleDelAvanceRitmoDeAporte =>
      'Acompanhamento simples do avanço, ritmo de aporte e data estimada de conclusão.';

  @override
  String get todaviaNoHayMetasParaAnalizar =>
      'Ainda não há metas para analisar';

  @override
  String get cuandoTengasMetasYAportesVasA =>
      'Quando tiver metas e aportes, você verá aqui o ritmo de avanço.';

  @override
  String get gastosPorMedioDePago => 'Despesas por meio de pagamento';

  @override
  String get teAyudaAVerQueMetodoEstas =>
      'Ajuda você a ver qual método está usando mais no mês.';

  @override
  String get noSePudieronCargarLosReportes =>
      'Não foi possível carregar os relatórios';

  @override
  String get elegiUnDiaDeRecordatorioValido =>
      'Escolha um dia de lembrete válido.';

  @override
  String get definiUnaMetaSimpleYVisible => 'Defina uma meta simples e visível';

  @override
  String get nombreClaroMontoObjetivoYFechaOpcional =>
      'Nome claro, valor objetivo e data opcional. Nada mais.';

  @override
  String get ingresaUnNombre => 'Informe um nome.';

  @override
  String get agregarFechaObjetivo => 'Adicionar data objetivo';

  @override
  String get teAyudaANoOlvidarteDelAporte =>
      'Ajuda você a não esquecer o aporte mensal para esta meta.';

  @override
  String get elegiElDiaDelMesEnEl =>
      'Escolha o dia do mês em que deseja receber o lembrete.';

  @override
  String get todaviaNoTenesAhorroRegistrado =>
      'Ainda não há economia registrada';

  @override
  String get creaUnaMetaORegistraUnAporte =>
      'Crie uma meta ou registre um aporte para começar a organizar suas economias.';

  @override
  String get totalAhorrado => 'Total economizado';

  @override
  String get todoLoQueAhorrasteEstaOrganizadoEn =>
      'Tudo o que você economizou está organizado em metas.';

  @override
  String get logradas => 'Concluídas';

  @override
  String get metasLogradas => 'Metas concluídas';

  @override
  String get noPudimosCargarTusMetas => 'Não foi possível carregar suas metas';

  @override
  String get noPudimosCargarAhorros => 'Não foi possível carregar economias';

  @override
  String get dineroGuardadoSinUnaMetaEspecifica =>
      'Dinheiro guardado sem uma meta específica.';

  @override
  String get creaUnaMetaParaOrganizarMejorTus =>
      'Crie uma meta para organizar melhor suas economias.';

  @override
  String get excelenteYaAlcanzasteEstaMeta =>
      'Excelente. Você já alcançou esta meta.';

  @override
  String get proyeccionDeFinDeMes => 'Projeção de fim de mês';

  @override
  String get gastoProyectado => 'Gasto projetado';

  @override
  String get usaUnaOpcionClaraParaReconocerMas =>
      'Use uma opção clara para reconhecer a categoria mais rápido.';

  @override
  String get iconoSeleccionado => 'Ícone selecionado';

  @override
  String get todaviaTeQuedaPagarOAhorrarPara =>
      'Ainda falta pagar ou economizar para:';

  @override
  String get pinLabel => 'PIN';

  @override
  String authPinLengthInvalid(Object length) {
    return 'O PIN deve ter $length dígitos.';
  }

  @override
  String authLockoutActive(Object seconds) {
    return 'Muitas tentativas incorretas. Aguarde $seconds segundos antes de tentar novamente.';
  }

  @override
  String categoriesLoadError(Object error) {
    return 'Não foi possível carregar as categorias: $error';
  }

  @override
  String deleteSubcategoryMessage(Object name) {
    return 'A subcategoria \"$name\" será excluída. Se houver transações ou dependências vinculadas, o app bloqueará a exclusão.';
  }

  @override
  String deleteCategoryMessage(Object name) {
    return 'A categoria \"$name\" será excluída. Se houver transações, subcategorias ou orçamentos vinculados, o app bloqueará a exclusão.';
  }

  @override
  String dashboardRemainingPositive(Object amount) {
    return 'Você ainda tem $amount disponível este mês.';
  }

  @override
  String dashboardRemainingNegative(Object amount) {
    return 'Este mês você está $amount acima da sua margem.';
  }

  @override
  String projectionAverageExpensePace(Object amount, Object days) {
    return 'Ritmo médio: $amount/dia. Faltam $days dias.';
  }

  @override
  String reportsShareOfTotal(Object percentage) {
    return '$percentage% do total';
  }

  @override
  String reportsPreviousMonth(Object amount) {
    return 'Mês anterior: $amount';
  }

  @override
  String savingsGoalProgress(Object saved, Object target) {
    return '$saved de $target';
  }

  @override
  String goalAverageContribution(Object amount) {
    return 'Contribuição média: $amount por mês';
  }

  @override
  String goalContributionThisMonth(Object amount) {
    return 'Contribuição neste mês: $amount';
  }

  @override
  String goalEstimatedDate(Object date) {
    return 'Data estimada: $date';
  }

  @override
  String deleteSavingsGoalMessage(Object name) {
    return 'A meta \"$name\" será excluída. As contribuições já registradas continuarão existindo, mas não ficarão mais vinculadas a esta meta.';
  }

  @override
  String savingsGeneralIncluded(Object amount) {
    return 'Inclui $amount em economias gerais.';
  }

  @override
  String savingsContributionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contribuições registradas.',
      one: '1 contribuição registrada.',
    );
    return '$_temp0';
  }

  @override
  String savingsContributionCountWithDate(num count, Object date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contribuições · última: $date.',
      one: '1 contribuição · última: $date.',
    );
    return '$_temp0';
  }

  @override
  String savingsGoalTargetDate(Object date) {
    return 'Objetivo: $date';
  }

  @override
  String savingsGoalRemaining(Object amount) {
    return 'Falta $amount para alcançar.';
  }

  @override
  String get privacySummaryTitle => 'Resumo';

  @override
  String get privacySummaryBody1 =>
      'CleanFinance é um app de finanças pessoais offline-first. O app não cria contas online, não envia seus registros financeiros para servidores do desenvolvedor e não inclui SDKs de análise, publicidade ou rastreamento.';

  @override
  String get privacySummaryBody2 =>
      'Esta política dentro do app resume o tratamento de dados que pode ser confirmado pelo código-fonte atual. A URL pública da política de privacidade publicada no Google Play deve refletir este mesmo conteúdo e incluir os dados finais de contato do desenvolvedor.';

  @override
  String get privacyStoredDataTitle => 'Dados armazenados no seu dispositivo';

  @override
  String get privacyStoredDataBody1 =>
      'CleanFinance armazena suas categorias, transações, metas de economia, orçamentos, meios de pagamento, idioma, tema, preferência de visibilidade de valores, bloqueio automático e biometria em um banco SQLite local no dispositivo.';

  @override
  String get privacyStoredDataBody2 =>
      'O app também armazena, no armazenamento seguro do Android, um PIN com hash, respostas de recuperação com hash para data de nascimento e documento pessoal, e o estado de bloqueio por tentativas incorretas. As respostas de recuperação são solicitadas apenas para redefinir o acesso neste mesmo dispositivo caso você esqueça o PIN.';

  @override
  String get privacyBiometricsTitle => 'Biometria e permissões';

  @override
  String get privacyBiometricsBody1 =>
      'Se você ativar o desbloqueio biométrico, CleanFinance solicita ao Android que valide sua digital ou rosto localmente no dispositivo. O app não recebe nem armazena seu modelo biométrico.';

  @override
  String get privacyBiometricsBody2 =>
      'A versão Android solicita a permissão biométrica necessária para mostrar o diálogo do sistema. O manifest principal não declara permissões de localização, contatos, câmera, microfone, SMS, telefone ou publicidade.';

  @override
  String get privacyBackupsTitle => 'Backups e compartilhamento de arquivos';

  @override
  String get privacyBackupsBody1 =>
      'Você pode exportar seus dados manualmente em Configurações. A exportação inclui seu banco financeiro local e as configurações. Se deixar a senha em branco, o arquivo será salvo como JSON legível. Se informar uma senha, o arquivo será criptografado antes de compartilhar ou armazenar.';

  @override
  String get privacyBackupsBody2 =>
      'As importações são iniciadas por você e substituem o banco local atual somente após a validação do arquivo. CleanFinance não sincroniza backups automaticamente com servidores do desenvolvedor.';

  @override
  String get privacySharingTitle => 'Compartilhamento, retenção e exclusão';

  @override
  String get privacySharingBody1 =>
      'O app não compartilha dados pessoais nem financeiros com o desenvolvedor ou terceiros. Os dados permanecem no dispositivo, a menos que você exporte e compartilhe um backup manualmente.';

  @override
  String get privacySharingBody2 =>
      'Seus dados permanecem no dispositivo até que você os exclua, limpe o app, desinstale o app ou use a ação interna para apagar todos os dados locais. Apagar todos os dados remove o banco SQLite, credenciais no armazenamento seguro, dados de recuperação e sinalizações de biometria.';

  @override
  String get privacySecurityTitle => 'Notas de segurança';

  @override
  String get privacySecurityBody1 =>
      'Os dados financeiros armazenados em SQLite são locais, mas não têm criptografia no nível do arquivo do banco de dados. Dados sensíveis de autenticação são armazenados com hash em armazenamento seguro. Builds release também desativam o backup em nuvem do Android para reduzir cópias indesejadas dos dados financeiros locais.';

  @override
  String get privacySecurityBody2 =>
      'Como a recuperação usa data de nascimento e documento pessoal, alguém que conheça esses dados e tenha o dispositivo poderia tentar uma redefinição local. Por isso é importante proteger o aparelho com bloqueio de tela do Android.';

  @override
  String get privacyContactTitle => 'Contato de privacidade';

  @override
  String get privacyContactBody1 =>
      'O canal oficial de contato de privacidade para o app publicado deve ser o e-mail do desenvolvedor exibido na ficha do CleanFinance no Google Play. Antes do lançamento em produção, confirme que a política pública hospedada inclua esse endereço exato.';

  @override
  String get iconOptionCategory => 'Geral';

  @override
  String get iconOptionHome => 'Casa';

  @override
  String get iconOptionBolt => 'Serviços';

  @override
  String get iconOptionRestaurant => 'Comida';

  @override
  String get iconOptionCar => 'Transporte';

  @override
  String get iconOptionHealth => 'Saúde';

  @override
  String get iconOptionEducation => 'Educação';

  @override
  String get iconOptionShopping => 'Compras';

  @override
  String get iconOptionEntertainment => 'Lazer';

  @override
  String get iconOptionFinance => 'Finanças';

  @override
  String get iconOptionFamily => 'Família';

  @override
  String get iconOptionWork => 'Trabalho';

  @override
  String get iconOptionPayments => 'Pagamentos';

  @override
  String get iconOptionStorefront => 'Vendas';

  @override
  String get iconOptionSavings => 'Economias';

  @override
  String get iconOptionShield => 'Proteção';

  @override
  String get iconOptionFlight => 'Viagens';

  @override
  String get iconOptionPalette => 'Decoração';

  @override
  String get iconOptionKitchen => 'Cozinha';

  @override
  String get iconOptionReceipt => 'Contas';

  @override
  String get iconOptionCleaningServices => 'Limpeza';

  @override
  String get iconOptionBuild => 'Manutenção';

  @override
  String get iconOptionChair => 'Móveis';

  @override
  String get iconOptionHandyman => 'Reparos';

  @override
  String get iconOptionWaterDrop => 'Água';

  @override
  String get iconOptionTv => 'TV';

  @override
  String get iconOptionLocalFireDepartment => 'Gás';

  @override
  String get iconOptionWifi => 'Internet';

  @override
  String get iconOptionElectricBolt => 'Luz';

  @override
  String get iconOptionCloud => 'Apps';

  @override
  String get iconOptionPlayCircle => 'Streaming';

  @override
  String get iconOptionPhone => 'Telefone';

  @override
  String get iconOptionCoffee => 'Cafeteria';

  @override
  String get iconOptionSetMeal => 'Açougue';

  @override
  String get iconOptionDeliveryDining => 'Delivery';

  @override
  String get iconOptionBakeryDining => 'Padaria';

  @override
  String get iconOptionRestaurantMenu => 'Restaurantes';

  @override
  String get iconOptionShoppingCart => 'Supermercado';

  @override
  String get iconOptionEco => 'Hortifruti';

  @override
  String get iconOptionLocalGasStation => 'Combustível';

  @override
  String get iconOptionLocalParking => 'Estacionamento';

  @override
  String get iconOptionToll => 'Pedágios';

  @override
  String get iconOptionSecurity => 'Seguro';

  @override
  String get iconOptionLocalTaxi => 'Táxi';

  @override
  String get iconOptionDirectionsBus => 'Ônibus';

  @override
  String get iconOptionEmojiTransportation => 'Mobilidade';

  @override
  String get iconOptionMedicalServices => 'Consultas';

  @override
  String get iconOptionScience => 'Exames';

  @override
  String get iconOptionMedication => 'Medicamentos';

  @override
  String get iconOptionHealthAndSafety => 'Plano de saúde';

  @override
  String get iconOptionMood => 'Odontologia';

  @override
  String get iconOptionVisibility => 'Ótica';

  @override
  String get iconOptionMenuBook => 'Cursos';

  @override
  String get iconOptionBook => 'Livros';

  @override
  String get iconOptionEdit => 'Materiais';

  @override
  String get iconOptionSchool => 'Capacitação';

  @override
  String get iconOptionHiking => 'Calçados';

  @override
  String get iconOptionLanguage => 'Online';

  @override
  String get iconOptionCardGiftcard => 'Presentes';

  @override
  String get iconOptionCheckroom => 'Roupas';

  @override
  String get iconOptionDevices => 'Tecnologia';

  @override
  String get iconOptionMovie => 'Cinema';

  @override
  String get iconOptionEvent => 'Eventos';

  @override
  String get iconOptionSportsEsports => 'Jogos';

  @override
  String get iconOptionNightlife => 'Saídas';

  @override
  String get iconOptionAccountBalanceWallet => 'Tarifas';

  @override
  String get iconOptionReceiptLong => 'Impostos';

  @override
  String get iconOptionPercent => 'Juros';

  @override
  String get iconOptionBusiness => 'Imposto autônomo';

  @override
  String get iconOptionCreditCard => 'Cartões';

  @override
  String get iconOptionSelfImprovement => 'Pessoal';

  @override
  String get iconOptionChildCare => 'Creche';

  @override
  String get iconOptionChildFriendly => 'Filhos';

  @override
  String get iconOptionPets => 'Pets';

  @override
  String get iconOptionLunchDining => 'Refeições';

  @override
  String get iconOptionCommute => 'Deslocamentos';

  @override
  String get iconOptionVolunteerActivism => 'Doações';

  @override
  String get iconOptionWarning => 'Imprevistos';

  @override
  String get iconOptionMoreHoriz => 'Diversos';

  @override
  String get defaultCategoryNameHobbies => 'Hobbies';

  @override
  String get defaultCategoryNameCompras => 'Compras';

  @override
  String get defaultCategoryNameImpuestos => 'Impostos';

  @override
  String get defaultCategoryNameLimpieza => 'Limpeza';

  @override
  String get defaultCategoryNameMuebles => 'Móveis';

  @override
  String get defaultCategoryNameMantenimientoDelVehiculo =>
      'Manutenção do veículo';

  @override
  String get defaultCategoryNameMateriales => 'Materiais';

  @override
  String get defaultCategoryNameExpensas => 'Condomínio';

  @override
  String get defaultCategoryNameInternet => 'Internet';

  @override
  String get defaultCategoryNameAlquiler => 'Aluguel';

  @override
  String get defaultCategoryNamePanaderia => 'Padaria';

  @override
  String get defaultCategoryNameComisionesBancarias => 'Tarifas bancárias';

  @override
  String get defaultCategoryNameDonaciones => 'Doações';

  @override
  String get defaultCategoryNameElectrodomesticos => 'Eletrodomésticos';

  @override
  String get defaultCategoryNameEstacionamiento => 'Estacionamento';

  @override
  String get defaultCategoryNameTransportePublico => 'Transporte público';

  @override
  String get defaultCategoryNameOdontologia => 'Odontologia';

  @override
  String get defaultCategoryNameTrabajo => 'Trabalho';

  @override
  String get defaultCategoryNameOcio => 'Entretenimento';

  @override
  String get defaultCategoryNameVerduleria => 'Hortifruti';

  @override
  String get defaultCategoryNameSueldo => 'Salário';

  @override
  String get defaultCategoryNameOptica => 'Ótica';

  @override
  String get defaultCategoryNameUberCabify => 'Uber / Cabify';

  @override
  String get defaultCategoryNameCafeteria => 'Cafeteria';

  @override
  String get defaultCategoryNameRegalos => 'Presentes';

  @override
  String get defaultCategoryNameObraSocialPrepaga => 'Plano de saúde';

  @override
  String get defaultCategoryNameConsultasMedicas => 'Consultas médicas';

  @override
  String get defaultCategoryNameEstudios => 'Exames';

  @override
  String get defaultCategoryNameCine => 'Cinema';

  @override
  String get defaultCategoryNameAlimentacion => 'Alimentação';

  @override
  String get defaultCategoryNameCuidadoPersonal => 'Cuidados pessoais';

  @override
  String get defaultCategoryNameGuarderiaColegio => 'Creche / Escola';

  @override
  String get defaultCategoryNameHerramientas => 'Ferramentas';

  @override
  String get defaultCategoryNameCombustible => 'Combustível';

  @override
  String get defaultCategoryNameMantenimiento => 'Manutenção';

  @override
  String get defaultCategoryNameLuz => 'Luz';

  @override
  String get defaultCategoryNameLibros => 'Livros';

  @override
  String get defaultCategoryNameTelefono => 'Telefone';

  @override
  String get defaultCategoryNameHijos => 'Filhos';

  @override
  String get defaultCategoryNameSalidas => 'Saídas';

  @override
  String get defaultCategoryNameFinanzas => 'Finanças';

  @override
  String get defaultCategoryNameCuotas => 'Mensalidades';

  @override
  String get defaultCategoryNameServicios => 'Serviços';

  @override
  String get defaultCategoryNameReparaciones => 'Reparos';

  @override
  String get defaultCategoryNameSuscripcionesEducativas =>
      'Assinaturas educativas';

  @override
  String get defaultCategoryNameTaxiRemis => 'Táxi / App';

  @override
  String get defaultCategoryNameDecoracion => 'Decoração';

  @override
  String get defaultCategoryNameTecnologia => 'Tecnologia';

  @override
  String get defaultCategoryNameSalud => 'Saúde';

  @override
  String get defaultCategoryNameIntereses => 'Juros';

  @override
  String get defaultCategoryNameJuegos => 'Jogos';

  @override
  String get defaultCategoryNameSupermercado => 'Supermercado';

  @override
  String get defaultCategoryNameCalzado => 'Calçados';

  @override
  String get defaultCategoryNameViaje => 'Viagem';

  @override
  String get defaultCategoryNameCableTv => 'TV a cabo';

  @override
  String get defaultCategoryNamePeajes => 'Pedágios';

  @override
  String get defaultCategoryNameVarios => 'Diversos';

  @override
  String get defaultCategoryNameRestaurantes => 'Restaurantes';

  @override
  String get defaultCategoryNameMonotributoAutonomos => 'Impostos de autônomo';

  @override
  String get defaultCategoryNameEventos => 'Eventos';

  @override
  String get defaultCategoryNameAlimentos => 'Alimentação';

  @override
  String get defaultCategoryNameMascotas => 'Pets';

  @override
  String get defaultCategoryNameVacaciones => 'Férias';

  @override
  String get defaultCategoryNameFondoDeEmergencia => 'Reserva de emergência';

  @override
  String get defaultCategoryNameMedicamentos => 'Medicamentos';

  @override
  String get defaultCategoryNameTransporte => 'Transporte';

  @override
  String get defaultCategoryNameImprevistos => 'Imprevistos';

  @override
  String get defaultCategoryNameCapacitacion => 'Capacitação';

  @override
  String get defaultCategoryNameAgua => 'Água';

  @override
  String get defaultCategoryNameEducacion => 'Educação';

  @override
  String get defaultCategoryNameFreelance => 'Freelance';

  @override
  String get defaultCategoryNameTarjetasDeCredito => 'Cartões de crédito';

  @override
  String get defaultCategoryNameCursos => 'Cursos';

  @override
  String get defaultCategoryNameRopa => 'Roupas';

  @override
  String get defaultCategoryNameComprasOnline => 'Compras online';

  @override
  String get defaultCategoryNameHogar => 'Casa';

  @override
  String get defaultCategoryNameSeguroDelAuto => 'Seguro do carro';

  @override
  String get defaultCategoryNameStreaming => 'Streaming';

  @override
  String get defaultCategoryNameGas => 'Gás';

  @override
  String get defaultCategoryNameVenta => 'Venda';

  @override
  String get defaultCategoryNameDelivery => 'Delivery';

  @override
  String get defaultCategoryNameCarniceria => 'Açougue';

  @override
  String get defaultCategoryNameNubeApps => 'Nuvem / Apps';

  @override
  String get defaultCategoryNameFamilia => 'Família';

  @override
  String get defaultCategoryNameComidasLaborales => 'Refeições de trabalho';

  @override
  String get defaultCategoryNameTransporteLaboral => 'Transporte de trabalho';

  @override
  String get defaultCategoryNameAhorroGeneral => 'Economias gerais';

  @override
  String get defaultCategoryNameOtros => 'Outros';

  @override
  String technicalErrorDetails(Object error) {
    return 'Detalhe técnico: $error';
  }

  @override
  String get currencyArsOption => 'ARS (\$)';

  @override
  String get currencyUsdOption => 'USD (US\$)';

  @override
  String get currencyEurOption => 'EUR (€)';
}
