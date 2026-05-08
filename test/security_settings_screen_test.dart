import 'package:clean_finance/features/auth/domain/entities/pin_security_state.dart';
import 'package:clean_finance/features/auth/domain/repositories/auth_repository.dart';
import 'package:clean_finance/features/auth/presentation/auth_state.dart';
import 'package:clean_finance/features/auth/presentation/providers/auth_providers.dart';
import 'package:clean_finance/features/finance/domain/entities/app_settings.dart';
import 'package:clean_finance/features/finance/domain/entities/app_theme_preference.dart';
import 'package:clean_finance/features/finance/domain/entities/category.dart';
import 'package:clean_finance/features/finance/domain/repositories/categories_repository.dart';
import 'package:clean_finance/features/finance/domain/repositories/settings_repository.dart';
import 'package:clean_finance/features/finance/presentation/providers/finance_providers.dart';
import 'package:clean_finance/features/finance/presentation/screens/settings_screen.dart';
import 'package:clean_finance/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows biometric switch disabled when biometrics are unavailable',
      (tester) async {
    final authRepository = _FakeAuthRepository(
      biometricAvailable: false,
      biometricEnabled: false,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          settingsRepositoryProvider
              .overrideWithValue(_FakeSettingsRepository()),
          categoriesRepositoryProvider.overrideWithValue(
            _FakeCategoriesRepository(),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          supportedLocales: [Locale('es'), Locale('en')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: SettingsScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pumpAndSettle();

    final biometricTitle = find.text('Desbloqueo con biometría');
    expect(biometricTitle, findsOneWidget);
    await tester.scrollUntilVisible(
      biometricTitle,
      300,
      scrollable: find.byType(Scrollable),
    );
    final biometricTileFinder = find.ancestor(
      of: biometricTitle,
      matching: find.byType(SwitchListTile),
    );
    final biometricTile = tester.widget<SwitchListTile>(biometricTileFinder);

    expect(biometricTile.onChanged, isNull);
    expect(
      find.text('Este dispositivo no tiene biometría disponible.'),
      findsOneWidget,
    );
  });

  testWidgets('keeps auth and settings in sync when toggling biometrics',
      (tester) async {
    final authRepository = _FakeAuthRepository(
      biometricAvailable: true,
      biometricEnabled: false,
    );
    final settingsRepository = _FakeSettingsRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          settingsRepositoryProvider.overrideWithValue(settingsRepository),
          categoriesRepositoryProvider.overrideWithValue(
            _FakeCategoriesRepository(),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          supportedLocales: [Locale('es'), Locale('en')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: SettingsScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pumpAndSettle();

    final biometricTitle = find.text('Desbloqueo con biometría');
    expect(biometricTitle, findsOneWidget);
    await tester.scrollUntilVisible(
      biometricTitle,
      300,
      scrollable: find.byType(Scrollable),
    );
    final biometricTileFinder = find.ancestor(
      of: biometricTitle,
      matching: find.byType(SwitchListTile),
    );
    final biometricTile = tester.widget<SwitchListTile>(biometricTileFinder);
    expect(biometricTile.onChanged, isNotNull);
    biometricTile.onChanged!(true);
    await tester.pumpAndSettle();

    expect(authRepository.lastSetBiometricEnabled, isTrue);
    expect(settingsRepository.savedBiometricEnabledValues, contains(true));

    final container = ProviderScope.containerOf(
      tester.element(find.byType(SettingsScreen)),
    );
    expect(container.read(authControllerProvider).biometricEnabled, isTrue);
    expect(
      container.read(settingsControllerProvider).valueOrNull?.biometricEnabled,
      isTrue,
    );
  });

  testWidgets('uses auth state as the real source for the biometric switch',
      (tester) async {
    final authRepository = _FakeAuthRepository(
      biometricAvailable: true,
      biometricEnabled: true,
    );
    final settingsRepository = _FakeSettingsRepository()
      ..current = settingsRepositoryCurrent.copyWith(biometricEnabled: false);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          settingsRepositoryProvider.overrideWithValue(settingsRepository),
          categoriesRepositoryProvider.overrideWithValue(
            _FakeCategoriesRepository(),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          supportedLocales: [Locale('es'), Locale('en')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: SettingsScreen(),
        ),
      ),
    );

    await tester.pump();
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
    expect(settingsRepository.current.biometricEnabled, isFalse);
  });

  testWidgets('exit app button locks, closes the app, and keeps data',
      (tester) async {
    final authRepository = _FakeAuthRepository(
      biometricAvailable: true,
      biometricEnabled: true,
    );
    final settingsRepository = _FakeSettingsRepository();
    var didRequestExit = false;

    const appChannel = MethodChannel('app.cleanfinance/app');
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      appChannel,
      (call) async {
        if (call.method == 'exitApp') {
          didRequestExit = true;
        }
        return null;
      },
    );
    addTearDown(() {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        appChannel,
        null,
      );
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          settingsRepositoryProvider.overrideWithValue(settingsRepository),
          categoriesRepositoryProvider.overrideWithValue(
            _FakeCategoriesRepository(),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          supportedLocales: [Locale('es'), Locale('en')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: SettingsScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(SettingsScreen)),
    );
    await container
        .read(authControllerProvider.notifier)
        .unlockWithPin('123456');
    await tester.pumpAndSettle();

    expect(container.read(authControllerProvider).status, AuthStatus.unlocked);
    expect(find.text('Salir de la app'), findsOneWidget);
    final exitButton = tester.widget<OutlinedButton>(
      find.ancestor(
        of: find.text('Salir de la app'),
        matching: find.byType(OutlinedButton),
      ),
    );
    expect(
      exitButton.style?.foregroundColor?.resolve({}),
      Theme.of(tester.element(find.byType(SettingsScreen))).colorScheme.error,
    );

    await tester.tap(find.text('Salir de la app'));
    await tester.pumpAndSettle();

    expect(container.read(authControllerProvider).status, AuthStatus.locked);
    expect(didRequestExit, isTrue);
    expect(authRepository.lastSetBiometricEnabled, isNull);
    expect(settingsRepository.current, settingsRepositoryCurrent);
  });
}

const settingsRepositoryCurrent = AppSettings(
  currencyCode: 'ARS',
  currencySymbol: r'$',
  showSensitiveAmounts: true,
  themePreference: AppThemePreference.system,
  biometricEnabled: false,
  autoLockMinutes: 5,
  localeCode: 'es',
  paymentMethods: ['Transferencia', 'QR'],
);

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({
    required this.biometricAvailable,
    required this.biometricEnabled,
  });

  final bool biometricAvailable;
  bool biometricEnabled;
  bool? lastSetBiometricEnabled;

  @override
  Future<bool> authenticateWithBiometrics() async => false;

  @override
  Future<PinSecurityState> getPinSecurityState() async =>
      const PinSecurityState.initial();

  @override
  Future<bool> hasCredential() async => true;

  @override
  Future<bool> hasRecoveryData() async => true;

  @override
  Future<bool> isBiometricAvailable() async => biometricAvailable;

  @override
  Future<bool> isBiometricEnabled() async => biometricEnabled;

  @override
  Future<void> savePin(String pin) async {}

  @override
  Future<void> saveRecoveryData({
    required String birthDate,
    required String documentId,
  }) async {}

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    biometricEnabled = enabled;
    lastSetBiometricEnabled = enabled;
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

class _FakeSettingsRepository implements SettingsRepository {
  AppSettings current = settingsRepositoryCurrent;

  final List<bool> savedBiometricEnabledValues = [];

  @override
  Future<AppSettings> getSettings() async => current;

  @override
  Future<void> saveSettings(AppSettings settings) async {
    current = settings;
    savedBiometricEnabledValues.add(settings.biometricEnabled);
  }
}

class _FakeCategoriesRepository implements CategoriesRepository {
  @override
  Future<void> deleteCategory(String categoryId) async {}

  @override
  Future<void> ensureSeedData() async {}

  @override
  Future<List<Category>> getCategories({CategoryScope? scope}) async =>
      const [];

  @override
  Future<Category?> getCategoryById(String categoryId) async => null;

  @override
  Future<Category?> getActiveExpenseReminderBySubcategory(
    String subcategoryId,
  ) async =>
      null;

  @override
  Future<Category> setExpenseSubcategoryMonthlyReminder({
    required String subcategoryId,
    required bool enabled,
    int? reminderDay,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> upsertCategory(Category category) async {}
}
