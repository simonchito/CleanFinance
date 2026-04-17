import 'package:clean_finance/features/finance/domain/entities/app_settings.dart';
import 'package:clean_finance/features/finance/domain/entities/app_theme_preference.dart';
import 'package:clean_finance/features/finance/domain/entities/dashboard_summary.dart';
import 'package:clean_finance/features/finance/domain/entities/movement.dart';
import 'package:clean_finance/features/finance/domain/entities/movement_filter.dart';
import 'package:clean_finance/features/finance/domain/entities/reports_snapshot.dart';
import 'package:clean_finance/features/finance/domain/repositories/movements_repository.dart';
import 'package:clean_finance/features/finance/domain/repositories/settings_repository.dart';
import 'package:clean_finance/features/finance/presentation/screens/movements_screen.dart';
import 'package:clean_finance/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('es');
  });

  testWidgets('renders paymentMethod metadata when a movement has one',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          movementsRepositoryProvider.overrideWithValue(
            _FakeMovementsRepository(
              movements: [
                Movement(
                  id: 'movement-1',
                  type: MovementType.expense,
                  amount: 3200,
                  categoryId: 'food',
                  occurredOn: DateTime(2026, 4, 17),
                  paymentMethod: 'QR',
                  categoryName: 'Alimentos',
                  createdAt: DateTime(2026, 4, 17, 10),
                  updatedAt: DateTime(2026, 4, 17, 10),
                ),
              ],
            ),
          ),
          settingsRepositoryProvider
              .overrideWithValue(_FakeSettingsRepository()),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          supportedLocales: [Locale('es'), Locale('en')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: MovementsScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('QR'), findsOneWidget);
    expect(find.text('Alimentos'), findsOneWidget);
  });

  testWidgets('does not render paymentMethod metadata when it is absent',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          movementsRepositoryProvider.overrideWithValue(
            _FakeMovementsRepository(
              movements: [
                Movement(
                  id: 'movement-2',
                  type: MovementType.expense,
                  amount: 3200,
                  categoryId: 'food',
                  occurredOn: DateTime(2026, 4, 17),
                  paymentMethod: null,
                  categoryName: 'Alimentos',
                  createdAt: DateTime(2026, 4, 17, 10),
                  updatedAt: DateTime(2026, 4, 17, 10),
                ),
              ],
            ),
          ),
          settingsRepositoryProvider
              .overrideWithValue(_FakeSettingsRepository()),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          supportedLocales: [Locale('es'), Locale('en')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: MovementsScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('QR'), findsNothing);
  });

  testWidgets('canonicalizes card payment methods in the list',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          movementsRepositoryProvider.overrideWithValue(
            _FakeMovementsRepository(
              movements: [
                Movement(
                  id: 'movement-3',
                  type: MovementType.expense,
                  amount: 4500,
                  categoryId: 'transport',
                  occurredOn: DateTime(2026, 4, 17),
                  paymentMethod: 'tarjeta debito',
                  categoryName: 'Transporte',
                  createdAt: DateTime(2026, 4, 17, 10),
                  updatedAt: DateTime(2026, 4, 17, 10),
                ),
              ],
            ),
          ),
          settingsRepositoryProvider
              .overrideWithValue(_FakeSettingsRepository()),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          supportedLocales: [Locale('es'), Locale('en')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: MovementsScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Tarjeta débito'), findsOneWidget);
  });
}

class _FakeMovementsRepository implements MovementsRepository {
  _FakeMovementsRepository({
    required this.movements,
  });

  final List<Movement> movements;

  @override
  Future<void> deleteMovement(String movementId) async {}

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
    return movements;
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
  Future<void> upsertMovement(Movement movement) async {}
}

class _FakeSettingsRepository implements SettingsRepository {
  @override
  Future<AppSettings> getSettings() async {
    return const AppSettings(
      currencyCode: 'ARS',
      currencySymbol: r'$',
      showSensitiveAmounts: true,
      themePreference: AppThemePreference.system,
      biometricEnabled: false,
      autoLockMinutes: 5,
      localeCode: 'es',
      paymentMethods: ['Transferencia', 'QR'],
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {}
}
