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
import 'package:clean_finance/features/finance/presentation/screens/movement_form_screen.dart';
import 'package:clean_finance/features/finance/presentation/widgets/selection_sheet_field.dart';
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
    await initializeDateFormatting('en');
  });

  testWidgets(
    'does not preselect a category or subcategory silently',
    (tester) async {
      final now = DateTime(2026, 4, 17);
      final categories = [
        Category(
          id: 'food',
          name: 'Alimentos',
          iconKey: 'restaurant',
          scope: CategoryScope.expense,
          isDefault: true,
          createdAt: now,
          updatedAt: now,
        ),
        Category(
          id: 'groceries',
          name: 'Supermercado',
          iconKey: 'shopping_cart',
          scope: CategoryScope.expense,
          parentId: 'food',
          isDefault: true,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoriesRepositoryProvider.overrideWithValue(
              _FakeCategoriesRepository(categories),
            ),
            movementsRepositoryProvider.overrideWithValue(
              _FakeMovementsRepository(),
            ),
            settingsRepositoryProvider.overrideWithValue(
              _FakeSettingsRepository(),
            ),
            savingsGoalsRepositoryProvider.overrideWithValue(
              _FakeSavingsGoalsRepository(),
            ),
          ],
          child: const MaterialApp(
            locale: Locale('es'),
            supportedLocales: [Locale('es'), Locale('en')],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            home: MovementFormScreen(initialType: MovementType.expense),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final selectionFields = tester
          .widgetList(
            find.byWidgetPredicate(
              (widget) => widget.runtimeType
                  .toString()
                  .startsWith('SelectionSheetField'),
            ),
          )
          .toList();
      final categoryField = selectionFields[1] as SelectionSheetField<String>;
      expect(categoryField.value, isNull);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is SelectionSheetField &&
              widget.label == 'Subcategoría (opcional)',
        ),
        findsNothing,
      );
    },
  );

  testWidgets(
    'shows reminder switch after selecting an expense subcategory',
    (tester) async {
      final now = DateTime(2026, 4, 17);
      final categories = [
        Category(
          id: 'services',
          name: 'Servicios',
          iconKey: 'bolt',
          scope: CategoryScope.expense,
          isDefault: true,
          createdAt: now,
          updatedAt: now,
        ),
        Category(
          id: 'internet',
          name: 'Internet',
          iconKey: 'wifi',
          scope: CategoryScope.expense,
          parentId: 'services',
          isDefault: true,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoriesRepositoryProvider.overrideWithValue(
              _FakeCategoriesRepository(categories),
            ),
            movementsRepositoryProvider.overrideWithValue(
              _FakeMovementsRepository(),
            ),
            settingsRepositoryProvider.overrideWithValue(
              _FakeSettingsRepository(),
            ),
            savingsGoalsRepositoryProvider.overrideWithValue(
              _FakeSavingsGoalsRepository(),
            ),
          ],
          child: const MaterialApp(
            locale: Locale('es'),
            supportedLocales: [Locale('es'), Locale('en')],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            home: MovementFormScreen(initialType: MovementType.expense),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      var selectionFields = find.byWidgetPredicate(
        (widget) =>
            widget.runtimeType.toString().startsWith('SelectionSheetField'),
      );
      await tester.tap(selectionFields.at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Servicios').last);
      await tester.pumpAndSettle();

      selectionFields = find.byWidgetPredicate(
        (widget) =>
            widget.runtimeType.toString().startsWith('SelectionSheetField'),
      );
      await tester.tap(selectionFields.at(2));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Internet').last);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 100));

      expect(
          find.text('Recordarme este gasto todos los meses'), findsOneWidget);
      expect(find.text('Te avisaremos cerca del día de este movimiento.'),
          findsOneWidget);
      expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
    },
  );

  testWidgets(
    'shows active localized reminder text in English',
    (tester) async {
      final now = DateTime(2026, 4, 17);
      final categories = [
        Category(
          id: 'services',
          name: 'Services',
          iconKey: 'bolt',
          scope: CategoryScope.expense,
          isDefault: true,
          createdAt: now,
          updatedAt: now,
        ),
        Category(
          id: 'internet',
          name: 'Internet',
          iconKey: 'wifi',
          scope: CategoryScope.expense,
          parentId: 'services',
          isDefault: true,
          reminderEnabled: true,
          reminderDay: 26,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoriesRepositoryProvider.overrideWithValue(
              _FakeCategoriesRepository(categories),
            ),
            movementsRepositoryProvider.overrideWithValue(
              _FakeMovementsRepository(),
            ),
            settingsRepositoryProvider.overrideWithValue(
              _FakeSettingsRepository(localeCode: 'en'),
            ),
            savingsGoalsRepositoryProvider.overrideWithValue(
              _FakeSavingsGoalsRepository(),
            ),
          ],
          child: MaterialApp(
            locale: const Locale('en'),
            supportedLocales: const [Locale('es'), Locale('en')],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            home: MovementFormScreen(
              initialMovement: Movement(
                id: 'movement-1',
                type: MovementType.expense,
                amount: 1500,
                categoryId: 'services',
                subcategoryId: 'internet',
                occurredOn: DateTime(2026, 4, 26),
                createdAt: now,
                updatedAt: now,
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Remind me about this expense every month'),
          findsOneWidget);
      expect(find.text('Day 26 of every month'), findsOneWidget);
      expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
    },
  );

  testWidgets(
    'shows the current payment method in preview even if it is not configured anymore',
    (tester) async {
      final now = DateTime(2026, 4, 17);
      final categories = [
        Category(
          id: 'food',
          name: 'Alimentos',
          iconKey: 'restaurant',
          scope: CategoryScope.expense,
          isDefault: true,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoriesRepositoryProvider.overrideWithValue(
              _FakeCategoriesRepository(categories),
            ),
            movementsRepositoryProvider.overrideWithValue(
              _FakeMovementsRepository(),
            ),
            settingsRepositoryProvider.overrideWithValue(
              _FakeSettingsRepository(
                paymentMethods: const ['Transferencia', 'QR'],
              ),
            ),
            savingsGoalsRepositoryProvider.overrideWithValue(
              _FakeSavingsGoalsRepository(),
            ),
          ],
          child: MaterialApp(
            locale: const Locale('es'),
            supportedLocales: const [Locale('es'), Locale('en')],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            home: MovementFormScreen(
              initialMovement: Movement(
                id: 'movement-1',
                type: MovementType.expense,
                amount: 1800,
                categoryId: 'food',
                occurredOn: now,
                paymentMethod: 'Efectivo',
                createdAt: now,
                updatedAt: now,
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Efectivo'), findsWidgets);
    },
  );

  testWidgets(
    'shows a clear error before saving when no category was selected',
    (tester) async {
      final now = DateTime(2026, 4, 17);
      final categories = [
        Category(
          id: 'food',
          name: 'Alimentos',
          iconKey: 'restaurant',
          scope: CategoryScope.expense,
          isDefault: true,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoriesRepositoryProvider.overrideWithValue(
              _FakeCategoriesRepository(categories),
            ),
            movementsRepositoryProvider.overrideWithValue(
              _FakeMovementsRepository(),
            ),
            settingsRepositoryProvider.overrideWithValue(
              _FakeSettingsRepository(),
            ),
            savingsGoalsRepositoryProvider.overrideWithValue(
              _FakeSavingsGoalsRepository(),
            ),
          ],
          child: const MaterialApp(
            locale: Locale('es'),
            supportedLocales: [Locale('es'), Locale('en')],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            home: MovementFormScreen(initialType: MovementType.expense),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(find.byType(TextFormField).first, '2500');
      await tester.drag(find.byType(ListView).first, const Offset(0, -600));
      await tester.pumpAndSettle();
      final saveButtons =
          find.byWidgetPredicate((widget) => widget is ButtonStyleButton);
      await tester.tap(
        saveButtons.last,
      );
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              (widget.data == 'Select a category before saving.' ||
                  widget.data == 'Seleccioná una categoría antes de guardar.'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'updates the selected payment method label immediately',
    (tester) async {
      final now = DateTime(2026, 4, 17);
      final categories = [
        Category(
          id: 'food',
          name: 'Alimentos',
          iconKey: 'restaurant',
          scope: CategoryScope.expense,
          isDefault: true,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoriesRepositoryProvider.overrideWithValue(
              _FakeCategoriesRepository(categories),
            ),
            movementsRepositoryProvider.overrideWithValue(
              _FakeMovementsRepository(),
            ),
            settingsRepositoryProvider.overrideWithValue(
              _FakeSettingsRepository(
                paymentMethods: const ['Transferencia', 'QR'],
              ),
            ),
            savingsGoalsRepositoryProvider.overrideWithValue(
              _FakeSavingsGoalsRepository(),
            ),
          ],
          child: const MaterialApp(
            locale: Locale('es'),
            supportedLocales: [Locale('es'), Locale('en')],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            home: MovementFormScreen(initialType: MovementType.expense),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final selectionFields = find.byWidgetPredicate(
        (widget) =>
            widget.runtimeType.toString().startsWith('SelectionSheetField'),
      );

      expect(selectionFields, findsAtLeastNWidgets(3));

      await tester.ensureVisible(selectionFields.last);
      await tester.tap(selectionFields.last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('QR').last);
      await tester.pumpAndSettle();

      expect(find.text('QR'), findsWidgets);
    },
  );

  testWidgets(
    'localizes default payment method options when the app is in English',
    (tester) async {
      final now = DateTime(2026, 4, 17);
      final categories = [
        Category(
          id: 'food',
          name: 'Alimentos',
          iconKey: 'restaurant',
          scope: CategoryScope.expense,
          isDefault: true,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoriesRepositoryProvider.overrideWithValue(
              _FakeCategoriesRepository(categories),
            ),
            movementsRepositoryProvider.overrideWithValue(
              _FakeMovementsRepository(),
            ),
            settingsRepositoryProvider.overrideWithValue(
              _FakeSettingsRepository(
                localeCode: 'en',
                paymentMethods: const [
                  'Transferencia',
                  'Tarjeta débito',
                  'Efectivo',
                  'QR',
                ],
              ),
            ),
            savingsGoalsRepositoryProvider.overrideWithValue(
              _FakeSavingsGoalsRepository(),
            ),
          ],
          child: const MaterialApp(
            locale: Locale('en'),
            supportedLocales: [Locale('es'), Locale('en')],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            home: MovementFormScreen(initialType: MovementType.expense),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final selectionFields = find.byWidgetPredicate(
        (widget) =>
            widget.runtimeType.toString().startsWith('SelectionSheetField'),
      );
      await tester.tap(selectionFields.last);
      await tester.pumpAndSettle();

      expect(find.text('Bank transfer'), findsOneWidget);
      expect(find.text('Debit card'), findsOneWidget);
      expect(find.text('Cash'), findsOneWidget);
      expect(find.text('Transferencia'), findsNothing);
      expect(find.text('Tarjeta débito'), findsNothing);
      expect(find.text('Efectivo'), findsNothing);
    },
  );
}

class _FakeCategoriesRepository implements CategoriesRepository {
  _FakeCategoriesRepository(this.categories);

  final List<Category> categories;

  @override
  Future<void> deleteCategory(String categoryId) async {}

  @override
  Future<void> ensureSeedData() async {}

  @override
  Future<List<Category>> getCategories({CategoryScope? scope}) async {
    if (scope == null || scope == CategoryScope.all) {
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
    final updated = categories[index].copyWith(
      reminderEnabled: enabled,
      reminderDay: enabled ? reminderDay : null,
      clearReminderDay: !enabled,
      updatedAt: DateTime.now(),
    );
    categories[index] = updated;
    return updated;
  }

  @override
  Future<void> upsertCategory(Category category) async {}
}

class _FakeMovementsRepository implements MovementsRepository {
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
    return const [];
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

class _FakeSavingsGoalsRepository implements SavingsGoalsRepository {
  @override
  Future<void> deleteSavingsGoal(String goalId) async {}

  @override
  Future<List<SavingsGoalProgress>> getSavingsGoals() async {
    return const [];
  }

  @override
  Future<void> upsertSavingsGoal(SavingsGoal goal) async {}
}

class _FakeSettingsRepository implements SettingsRepository {
  _FakeSettingsRepository({
    this.paymentMethods = const [],
    this.localeCode = 'es',
  });

  final List<String> paymentMethods;
  final String localeCode;

  @override
  Future<AppSettings> getSettings() async {
    return AppSettings(
      currencyCode: 'ARS',
      currencySymbol: r'$',
      showSensitiveAmounts: true,
      themePreference: AppThemePreference.system,
      biometricEnabled: false,
      autoLockMinutes: 0,
      localeCode: localeCode,
      paymentMethods: paymentMethods,
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {}
}
