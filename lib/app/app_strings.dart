import 'package:flutter/widgets.dart';

import '../core/localization/app_locale_mode.dart';
import '../core/utils/payment_method_utils.dart';

class AppStrings {
  AppStrings._(this.languageCode);

  factory AppStrings.of(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return AppStrings._(AppLocaleMode.fromLocale(locale).preferenceCode);
  }

  final String languageCode;

  bool get isEnglish => languageCode == 'en';
  bool get isPortugueseBrazil => languageCode == 'pt_BR';

  String localized({
    required String es,
    required String en,
    String? pt,
  }) {
    switch (languageCode) {
      case 'en':
        return en;
      case 'pt_BR':
        return pt ?? _ptFallbackBySpanish[es] ?? es;
      default:
        return es;
    }
  }

  Locale get locale =>
      AppLocaleMode.fromPreferenceCode(languageCode).locale ??
      AppLocaleMode.fallback.locale!;

  String get appName => 'CleanFinance';
  String get spanish => localized(es: 'Español', en: 'Spanish', pt: 'Espanhol');
  String get english => localized(es: 'Inglés', en: 'English', pt: 'Inglês');
  String get portugueseBrazil => localized(
        es: 'Portugués de Brasil',
        en: 'Portuguese (Brazil)',
        pt: 'Português do Brasil',
      );
  String get useDeviceLanguage => localized(
        es: 'Usar idioma del dispositivo',
        en: 'Use device language',
        pt: 'Usar idioma do dispositivo',
      );
  String get settings =>
      localized(es: 'Ajustes', en: 'Settings', pt: 'Configurações');
  String get appearance =>
      localized(es: 'Apariencia', en: 'Appearance', pt: 'Aparência');
  String get privacy =>
      localized(es: 'Privacidad', en: 'Privacy', pt: 'Privacidade');
  String get privacyPolicy => localized(
        es: 'Política de privacidad',
        en: 'Privacy policy',
        pt: 'Política de privacidade',
      );
  String get security =>
      localized(es: 'Seguridad', en: 'Security', pt: 'Segurança');
  String get data => localized(es: 'Datos', en: 'Data', pt: 'Dados');
  String get language => localized(es: 'Idioma', en: 'Language', pt: 'Idioma');
  String get paymentMethods => localized(
        es: 'Medios de pago',
        en: 'Payment methods',
        pt: 'Meios de pagamento',
      );
  String get managePaymentMethods => localized(
        es: 'Gestionar medios de pago',
        en: 'Manage payment methods',
        pt: 'Gerenciar meios de pagamento',
      );
  String get manageReminders => localized(
        es: 'Gestionar recordatorios',
        en: 'Manage reminders',
        pt: 'Gerenciar lembretes',
      );
  String get addPaymentMethod => localized(
        es: 'Agregar medio de pago',
        en: 'Add payment method',
        pt: 'Adicionar meio de pagamento',
      );
  String get movementPaymentMethod => localized(
        es: 'Medio de pago',
        en: 'Payment method',
        pt: 'Meio de pagamento',
      );
  String get paymentMethodTransfer => localized(
        es: 'Transferencia',
        en: 'Bank transfer',
        pt: 'Transferência',
      );
  String get paymentMethodDebitCard => localized(
        es: 'Tarjeta débito',
        en: 'Debit card',
        pt: 'Cartão de débito',
      );
  String get paymentMethodCreditCard => localized(
        es: 'Tarjeta crédito',
        en: 'Credit card',
        pt: 'Cartão de crédito',
      );
  String get paymentMethodCash =>
      localized(es: 'Efectivo', en: 'Cash', pt: 'Dinheiro');
  String get paymentMethodQr => 'QR';
  String get paymentMethodUnspecified => localized(
        es: 'Sin definir',
        en: 'Unspecified',
        pt: 'Não definido',
      );

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

  String get monthlyReminder => localized(
        es: 'Recordatorio mensual',
        en: 'Monthly reminder',
        pt: 'Lembrete mensal',
      );
  String get monthlyReminderDescription => localized(
        es: 'Usalo para gastos mensuales recurrentes y verlos como pendientes hasta registrar el pago.',
        en: 'Use this for recurring monthly expenses so they appear as pending until you register the payment.',
        pt: 'Use para despesas mensais recorrentes e veja-as como pendentes até registrar o pagamento.',
      );
  String get reminderDay => localized(
        es: 'Día de recordatorio',
        en: 'Reminder day',
        pt: 'Dia do lembrete',
      );
  String get pendingThisMonth => localized(
        es: 'Pendientes este mes',
        en: 'Pending this month',
        pt: 'Pendentes este mês',
      );
  String get reminderDayPrefix => localized(es: 'Día', en: 'Day', pt: 'Dia');
  String get reminderRegisterPayment => localized(
        es: 'Registrar pago',
        en: 'Register payment',
        pt: 'Registrar pagamento',
      );
  String get reminderLastRegistered => localized(
        es: 'Último registro',
        en: 'Last registered',
        pt: 'Último registro',
      );
  String get noSubcategory => localized(
        es: 'Sin subcategoría',
        en: 'No subcategory',
        pt: 'Sem subcategoria',
      );
  String get noGoal => localized(es: 'Sin meta', en: 'No goal', pt: 'Sem meta');
  String get category =>
      localized(es: 'Categoría', en: 'Category', pt: 'Categoria');
  String get subcategory =>
      localized(es: 'Subcategoría', en: 'Subcategory', pt: 'Subcategoria');
  String get amount => localized(es: 'Monto', en: 'Amount', pt: 'Valor');
  String get note => localized(es: 'Nota', en: 'Note', pt: 'Nota');
  String get type => localized(es: 'Tipo', en: 'Type', pt: 'Tipo');
  String get date => localized(es: 'Fecha', en: 'Date', pt: 'Data');
  String get savingGoal => localized(
        es: 'Meta de ahorro',
        en: 'Savings goal',
        pt: 'Meta de economia',
      );
  String get movement =>
      localized(es: 'Movimiento', en: 'Movement', pt: 'Movimentação');
  String get newMovement => localized(
        es: 'Nuevo movimiento',
        en: 'New movement',
        pt: 'Nova movimentação',
      );
  String get editMovement => localized(
        es: 'Editar movimiento',
        en: 'Edit movement',
        pt: 'Editar movimentação',
      );
  String get saveMovement => localized(
        es: 'Guardar movimiento',
        en: 'Save movement',
        pt: 'Salvar movimentação',
      );
  String get saveChanges => localized(
        es: 'Guardar cambios',
        en: 'Save changes',
        pt: 'Salvar alterações',
      );
  String get income => localized(es: 'Ingreso', en: 'Income', pt: 'Receita');
  String get expense => localized(es: 'Gasto', en: 'Expense', pt: 'Despesa');
  String get saving => localized(es: 'Ahorro', en: 'Saving', pt: 'Economia');
  String get dashboard => localized(es: 'Inicio', en: 'Home', pt: 'Início');
  String get movements =>
      localized(es: 'Movimientos', en: 'Movements', pt: 'Movimentações');
  String get movementsTab =>
      localized(es: 'Movs.', en: 'Activity', pt: 'Movs.');
  String get savings =>
      localized(es: 'Ahorros', en: 'Savings', pt: 'Economias');
  String get reports =>
      localized(es: 'Reportes', en: 'Reports', pt: 'Relatórios');
  String get createGoal =>
      localized(es: 'Crear meta', en: 'Create goal', pt: 'Criar meta');
  String get newGoal =>
      localized(es: 'Nueva meta', en: 'New goal', pt: 'Nova meta');
  String get editGoal =>
      localized(es: 'Editar meta', en: 'Edit goal', pt: 'Editar meta');
  String get completed =>
      localized(es: 'Completadas', en: 'Completed', pt: 'Concluídas');
  String get activeGoals =>
      localized(es: 'Metas activas', en: 'Active goals', pt: 'Metas ativas');
  String get achieved =>
      localized(es: 'Lograda', en: 'Achieved', pt: 'Atingida');
  String get contribute =>
      localized(es: 'Aportar', en: 'Contribute', pt: 'Contribuir');
  String get unlimitedDate => localized(
        es: 'Sin fecha límite',
        en: 'No deadline',
        pt: 'Sem prazo',
      );
  String get biometric => localized(
        es: 'Desbloqueo con biometría',
        en: 'Biometric unlock',
        pt: 'Desbloqueio por biometria',
      );
  String get exportBackup => localized(
        es: 'Exportar backup',
        en: 'Export backup',
        pt: 'Exportar backup',
      );
  String get importBackup => localized(
        es: 'Importar backup',
        en: 'Import backup',
        pt: 'Importar backup',
      );
  String get manageCategories => localized(
        es: 'Gestionar categorías',
        en: 'Manage categories',
        pt: 'Gerenciar categorias',
      );
  String get noCategories => localized(
        es: 'No hay categorías.',
        en: 'No categories yet.',
        pt: 'Ainda não há categorias.',
      );
  String get defaultCategory =>
      localized(es: 'Predefinida', en: 'Default', pt: 'Padrão');
  String get customCategory =>
      localized(es: 'Personalizada', en: 'Custom', pt: 'Personalizada');
  String get mainCategory => localized(
        es: 'Categoría principal',
        en: 'Main category',
        pt: 'Categoria principal',
      );
  String get addSubcategory => localized(
        es: 'Agregar subcategoría',
        en: 'Add subcategory',
        pt: 'Adicionar subcategoria',
      );
  String get budgets =>
      localized(es: 'Presupuestos', en: 'Budgets', pt: 'Orçamentos');
  String get manageBudgets => localized(
        es: 'Gestionar presupuestos',
        en: 'Manage budgets',
        pt: 'Gerenciar orçamentos',
      );
  String get showAmounts => localized(
      es: 'Mostrar montos', en: 'Show amounts', pt: 'Mostrar valores');
  String get hideAmounts => localized(
      es: 'Ocultar montos', en: 'Hide amounts', pt: 'Ocultar valores');
  String get amountPrivacy => localized(
        es: 'Privacidad de montos',
        en: 'Amount privacy',
        pt: 'Privacidade dos valores',
      );
  String get amountPrivacyDescription => localized(
        es: 'Ocultá saldos y resúmenes cuando usás la app en público.',
        en: 'Hide balances and summaries when using the app in public.',
        pt: 'Oculte saldos e resumos quando usar o app em público.',
      );
  String get newBudget => localized(
        es: 'Nuevo presupuesto',
        en: 'New budget',
        pt: 'Novo orçamento',
      );
  String get editBudget => localized(
        es: 'Editar presupuesto',
        en: 'Edit budget',
        pt: 'Editar orçamento',
      );
  String get monthlyLimit => localized(
        es: 'Límite mensual',
        en: 'Monthly limit',
        pt: 'Limite mensal',
      );
  String get spent => localized(es: 'Gastado', en: 'Spent', pt: 'Gasto');
  String get remaining =>
      localized(es: 'Disponible', en: 'Remaining', pt: 'Disponível');
  String get lockNow =>
      localized(es: 'Bloquear ahora', en: 'Lock now', pt: 'Bloquear agora');
  String get add => localized(es: 'Agregar', en: 'Add', pt: 'Adicionar');
  String get cancel => localized(es: 'Cancelar', en: 'Cancel', pt: 'Cancelar');
  String get save => localized(es: 'Guardar', en: 'Save', pt: 'Salvar');
  String get all => localized(es: 'Todos', en: 'All', pt: 'Todos');
  String get from => localized(es: 'Desde', en: 'From', pt: 'De');
  String get to => localized(es: 'Hasta', en: 'To', pt: 'Até');
  String get clear => localized(es: 'Limpiar', en: 'Clear', pt: 'Limpar');
  String get apply => localized(es: 'Aplicar', en: 'Apply', pt: 'Aplicar');
  String get filters => localized(es: 'Filtros', en: 'Filters', pt: 'Filtros');
  String get searchByNote => localized(
        es: 'Buscar por nota o referencia',
        en: 'Search by note or reference',
        pt: 'Buscar por nota ou referência',
      );
  String get setupTitle => localized(
        es: 'Tu dinero, claro y bajo control',
        en: 'Your money, clear and under control',
        pt: 'Seu dinheiro, claro e sob controle',
      );
  String get unlockTitle => localized(
        es: 'Bienvenido otra vez',
        en: 'Welcome back',
        pt: 'Boas-vindas de volta',
      );
  String get forgotPin => localized(
      es: 'Olvidé mi PIN', en: 'I forgot my PIN', pt: 'Esqueci meu PIN');
  String get recoverAccess => localized(
        es: 'Recuperar acceso',
        en: 'Recover access',
        pt: 'Recuperar acesso',
      );
  String get birthDate => localized(
      es: 'Fecha de nacimiento', en: 'Birth date', pt: 'Data de nascimento');
  String get documentId => localized(
        es: 'Documento personal',
        en: 'Personal document',
        pt: 'Documento pessoal',
      );

  static const Map<String, String> _ptFallbackBySpanish = {
    '1 minuto': '1 minuto',
    '5 minutos': '5 minutos',
    '15 minutos': '15 minutos',
    '30 minutos': '30 minutos',
    'Ahorro general': 'Economias gerais',
    'Atención': 'Atenção',
    'Agregar movimiento': 'Adicionar movimentação',
    'Borrar todo': 'Excluir tudo',
    'Borrar todos los datos': 'Excluir todos os dados',
    'Claro': 'Claro',
    'Confirmar PIN': 'Confirmar PIN',
    'Crear meta': 'Criar meta',
    'Desbloquear': 'Desbloquear',
    'Editar categoría': 'Editar categoria',
    'Elegí un ícono': 'Escolha um ícone',
    'Eliminar': 'Excluir',
    'Eliminar categoría': 'Excluir categoria',
    'Eliminar meta': 'Excluir meta',
    'Eliminar movimiento': 'Excluir movimentação',
    'Eliminar presupuesto': 'Excluir orçamento',
    'Empezar': 'Começar',
    'En rango': 'No caminho',
    'Error inesperado.': 'Erro inesperado.',
    'Estado': 'Status',
    'Evolución mensual': 'Evolução mensal',
    'Excedido': 'Excedido',
    'General savings': 'Economias gerais',
    'Guardar meta': 'Salvar meta',
    'Guardando...': 'Salvando...',
    'Importar backup': 'Importar backup',
    'Lectura rápida': 'Leitura rápida',
    'Meta de ahorro': 'Meta de economia',
    'Metas de ahorro': 'Metas de economia',
    'Moneda': 'Moeda',
    'Monto objetivo': 'Valor da meta',
    'Movimientos recientes': 'Movimentações recentes',
    'Neto estimado': 'Saldo estimado',
    'Nombre': 'Nome',
    'Nombre de la meta': 'Nome da meta',
    'Normal': 'Normal',
    'Notificaciones': 'Notificações',
    'Nueva categoría': 'Nova categoria',
    'Nuevo': 'Novo',
    'Nuevo PIN': 'Novo PIN',
    'Objetivo': 'Meta',
    'Organización': 'Organização',
    'Oscuro': 'Escuro',
    'PIN incorrecto.': 'PIN incorreto.',
    'Personalizada': 'Personalizada',
    'Predefinida': 'Padrão',
    'Proteger backup': 'Proteger backup',
    'Proyección': 'Projeção',
    'Recordatorios de ahorro': 'Lembretes de economia',
    'Recordatorios de gastos': 'Lembretes de despesas',
    'Recomendaciones': 'Recomendações',
    'Reintentar': 'Tentar novamente',
    'Riesgo': 'Risco',
    'Ritmo de gasto': 'Ritmo de gastos',
    'Seleccionar': 'Selecionar',
    'Sin estimación todavía': 'Ainda sem estimativa',
    'Tocá para cambiar': 'Toque para alterar',
    'Tema': 'Tema',
    'Total': 'Total',
    'Validando...': 'Validando...',
    'Ícono': 'Ícone',
  };
}
