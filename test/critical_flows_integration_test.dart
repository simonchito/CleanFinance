import 'package:clean_finance/features/auth/domain/entities/pin_security_state.dart';
import 'package:clean_finance/features/auth/domain/repositories/auth_repository.dart';
import 'package:clean_finance/features/auth/presentation/screens/setup_pin_screen.dart';
import 'package:clean_finance/features/finance/domain/entities/app_settings.dart';
import 'package:clean_finance/features/finance/domain/entities/app_theme_preference.dart';
import 'package:clean_finance/features/finance/domain/entities/category.dart';
import 'package:clean_finance/features/finance/domain/entities/dashboard_summary.dart';
import 'package:clean_finance/features/finance/domain/entities/movement.dart';
import 'package:clean_finance/features/finance/domain/entities/movement_filter.dart';
import 'package:clean_finance/features/finance/domain/entities/reports_snapshot.dart';
import 'package:clean_finance/features/finance/domain/entities/savings_goal.dart';
import 'package:clean_finance/features/finance/domain/repositories/categories_repository.dart';
import 'package:clean_finance/features/finance/domain/repositories/movements_repository.dart';
import 'package:clean_finance/features/finance/domain/repositories/savings_goals_repository.dart';
import 'package:clean_finance/features/finance/domain/repositories/settings_repository.dart';
import 'package:clean_finance/features/finance/presentation/screens/movements_screen.dart';
import 'package:clean_finance/features/finance/presentation/screens/settings_screen.dart';
import 'package:clean_finance/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('es');
  });

  testWidgets('creates a complete expense and shows it back in the list',
      (tester) async {
    final movementsRepository = _MemoryMovementsRepository();
    final categoriesRepository = _FakeCategoriesRepository([
      Category(
        id: 'food',
        name: 'Alimentos',
        iconKey: 'restaurant',
        scope: CategoryScope.expense,
        isDefault: true,
        createdAt: DateTime(2026, 4, 17),
        updatedAt: DateTime(2026, 4, 17),
      ),
    ]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          movementRepositoryProvider.overrideWithValue(movementsRepository),
          movementsRepositoryProvider.overrideWithValue(movementsRepository),
          categoriesRepositoryProvider.overrideWithValue(categoriesRepository),
          savingsGoalsRepositoryProvider.overrideWithValue(
            _FakeSavingsGoalsRepository(),
          ),
          settingsRepositoryProvider.overrideWithValue(
            _FakeSettingsRepository(),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          supportedLocales: [Locale('es'), Locale('en')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: MovementsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Agregar movimiento'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, '3250');
    final selectionFields = find.byWidgetPredicate(
      (widget) =>
          widget.runtimeType.toString().startsWith('SelectionSheetField'),
    );

    await tester.tap(selectionFields.at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Comida').last);
    await tester.pumpAndSettle();

    await tester.tap(selectionFields.last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('QR').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).last, 'Compra semanal');
    await tester.drag(find.byType(ListView).first, const Offset(0, -600));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar movimiento'));
    await tester.pumpAndSettle();

    expect(movementsRepository.savedMovements, hasLength(1));
    expect(find.text('QR'), findsOneWidget);
    expect(find.textContaining('Compra semanal'), findsOneWidget);
    expect(find.text('Comida'), findsOneWidget);
  });

  testWidgets('enables biometrics during onboarding and keeps settings in sync',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final settingsRepository = _FakeSettingsRepository();
    final authRepository = _IntegratedAuthRepository(
      settingsRepository: settingsRepository,
    );
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        settingsRepositoryProvider.overrideWithValue(settingsRepository),
        categoriesRepositoryProvider.overrideWithValue(
          _FakeCategoriesRepository(const []),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          locale: Locale('es'),
          supportedLocales: [Locale('es'), Locale('en')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: SetupPinScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), '123456');
    await tester.enterText(find.byType(TextField).at(1), '123456');
    await tester.tap(find.byType(TextField).at(2));
    await tester.pumpAndSettle();
    final datePickerContext = tester.element(find.byType(DatePickerDialog));
    await tester.tap(
      find.text(MaterialLocalizations.of(datePickerContext).okButtonLabel),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(3), '12345678');
    final onboardingBiometricText =
        find.text('Activar huella para entrar más rápido');
    await tester.tap(onboardingBiometricText);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Empezar'));
    await tester.pumpAndSettle();

    expect(authRepository.lastBiometricEnabledValue, isTrue);
    expect(settingsRepository.current.biometricEnabled, isTrue);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          locale: Locale('es'),
          supportedLocales: [Locale('es'), Locale('en')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: SettingsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final biometricTitle = find.text('Desbloqueo con biometría');
    await tester.scrollUntilVisible(
      biometricTitle,
      300,
      scrollable: find.byType(Scrollable),
    );
    final biometricTile = tester.widget<SwitchListTile>(
      find.ancestor(
        of: biometricTitle,
        matching: find.byType(SwitchListTile),
      ),
    );

    expect(biometricTile.value, isTrue);
  });
}

class _MemoryMovementsRepository implements MovementsRepository {
  final List<Movement> savedMovements = [];

  @override
  Future<void> deleteMovement(String movementId) async {
    savedMovements.removeWhere((movement) => movement.id == movementId);
  }

  @override
  Future<DashboardSummary> getDashboardSummary(DateTime month) async {
    return const DashboardSummary(
      availableBalance: 0,
      incomeMonth: 0,
      expenseMonth: 0,
      savingsAccumulated: 0,
      savingsMonth: 0,
      currentMonthMovementCount: 0,
    );
  }

  @override
  Future<List<Movement>> getMovements({
    MovementFilter filter = const MovementFilter(),
  }) async {
    return savedMovements
        .map(
          (movement) => movement.copyWith(
            categoryName: movement.categoryId == 'food' ? 'Alimentos' : null,
            categoryIsDefault: movement.categoryId == 'food',
          ),
        )
        .toList()
      ..sort((left, right) => right.occurredOn.compareTo(left.occurredOn));
  }

  @override
  Future<ReportsSnapshot> getReportsSnapshot(DateTime month) async {
    return const ReportsSnapshot(
      incomeMonth: 0,
      expenseMonth: 0,
      savingsMonth: 0,
      netMonth: 0,
      previousNetMonth: 0,
      topExpenseCategories: [],
    );
  }

  @override
  Future<void> upsertMovement(Movement movement) async {
    savedMovements.removeWhere((item) => item.id == movement.id);
    savedMovements.add(movement);
  }
}

class _FakeCategoriesRepository implements CategoriesRepository {
  const _FakeCategoriesRepository(this.categories);

  final List<Category> categories;

  @override
  Future<void> deleteCategory(String categoryId) async {}

  @override
  Future<void> ensureSeedData() async {}

  @override
  Future<List<Category>> getCategories({CategoryScope? scope}) async {
    if (scope == null) {
      return categories;
    }
    return categories.where((category) => category.scope == scope).toList();
  }

  @override
  Future<Category?> getCategoryById(String categoryId) async {
    return categories.cast<Category?>().firstWhere(
          (category) => category?.id == categoryId,
          orElse: () => null,
        );
  }

  @override
  Future<Category?> getActiveExpenseReminderBySubcategory(
    String subcategoryId,
  ) async {
    final category = await getCategoryById(subcategoryId);
    if (category == null ||
        category.scope != CategoryScope.expense ||
        !category.isSubcategory ||
        !category.reminderEnabled) {
      return null;
    }
    return category;
  }

  @override
  Future<Category> setExpenseSubcategoryMonthlyReminder({
    required String subcategoryId,
    required bool enabled,
    int? reminderDay,
  }) async {
    final index =
        categories.indexWhere((category) => category.id == subcategoryId);
    if (index == -1) {
      throw StateError('missing category');
    }
    return categories[index].copyWith(
      reminderEnabled: enabled,
      reminderDay: enabled ? reminderDay : null,
      clearReminderDay: !enabled,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> upsertCategory(Category category) async {}
}

class _FakeSavingsGoalsRepository implements SavingsGoalsRepository {
  @override
  Future<void> deleteSavingsGoal(String goalId) async {}

  @override
  Future<List<SavingsGoalProgress>> getSavingsGoals() async => const [];

  @override
  Future<void> upsertSavingsGoal(SavingsGoal goal) async {}
}

class _FakeSettingsRepository implements SettingsRepository {
  AppSettings current = const AppSettings(
    currencyCode: 'ARS',
    currencySymbol: r'$',
    showSensitiveAmounts: true,
    themePreference: AppThemePreference.system,
    biometricEnabled: false,
    autoLockMinutes: 5,
    localeCode: 'es',
    paymentMethods: ['Transferencia', 'QR', 'Efectivo'],
  );

  @override
  Future<AppSettings> getSettings() async => current;

  @override
  Future<void> saveSettings(AppSettings settings) async {
    current = settings;
  }
}

class _IntegratedAuthRepository implements AuthRepository {
  _IntegratedAuthRepository({
    required _FakeSettingsRepository settingsRepository,
  }) : _settingsRepository = settingsRepository;

  final _FakeSettingsRepository _settingsRepository;
  bool hasCredentialValue = false;
  bool recoveryConfigured = false;
  bool biometricAvailable = true;
  bool biometricEnabled = false;
  bool? lastBiometricEnabledValue;

  @override
  Future<bool> authenticateWithBiometrics() async => biometricEnabled;

  @override
  Future<PinSecurityState> getPinSecurityState() async =>
      const PinSecurityState.initial();

  @override
  Future<bool> hasCredential() async => hasCredentialValue;

  @override
  Future<bool> hasRecoveryData() async => recoveryConfigured;

  @override
  Future<bool> isBiometricAvailable() async => biometricAvailable;

  @override
  Future<bool> isBiometricEnabled() async => biometricEnabled;

  @override
  Future<void> savePin(String pin) async {
    hasCredentialValue = true;
  }

  @override
  Future<void> saveRecoveryData({
    required String birthDate,
    required String documentId,
  }) async {
    recoveryConfigured = true;
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    biometricEnabled = enabled;
    lastBiometricEnabledValue = enabled;
    await _settingsRepository.saveSettings(
      _settingsRepository.current.copyWith(biometricEnabled: enabled),
    );
  }

  @override
  Future<PinVerificationResult> verifyPin(String pin) async =>
      const PinVerificationResult(
        status: PinVerificationStatus.success,
        securityState: PinSecurityState.initial(),
      );

  @override
  Future<bool> verifyRecoveryData({
    required String birthDate,
    required String documentId,
  }) async {
    return true;
  }
}
