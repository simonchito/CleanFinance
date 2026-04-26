import 'package:clean_finance/core/database/app_database.dart';
import 'package:clean_finance/features/finance/data/local_category_repository.dart';
import 'package:clean_finance/features/finance/data/local_finance_support.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockDatabase database;
  late LocalCategoryRepository repository;

  setUpAll(() {
    registerFallbackValue(ConflictAlgorithm.abort);
  });

  setUp(() {
    database = _MockDatabase();
    repository = LocalCategoryRepository(
      LocalFinanceSupport(_FakeAppDatabase(database)),
    );
  });

  test('setExpenseSubcategoryMonthlyReminder enables without duplicating',
      () async {
    when(
      () => database.query(
        'categories',
        where: any(named: 'where'),
        whereArgs: any(named: 'whereArgs'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => [_categoryRow()]);
    when(
      () => database.insert(
        'categories',
        any(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      ),
    ).thenAnswer((_) async => 1);

    final updated = await repository.setExpenseSubcategoryMonthlyReminder(
      subcategoryId: 'internet',
      enabled: true,
      reminderDay: 26,
    );

    final captured = verify(
      () => database.insert(
        'categories',
        captureAny(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      ),
    ).captured.single as Map<String, Object?>;
    expect(updated.reminderEnabled, isTrue);
    expect(updated.reminderDay, 26);
    expect(captured['id'], 'internet');
    expect(captured['reminder_enabled'], 1);
    expect(captured['reminder_day'], 26);
  });

  test('setExpenseSubcategoryMonthlyReminder disables and clears day',
      () async {
    when(
      () => database.query(
        'categories',
        where: any(named: 'where'),
        whereArgs: any(named: 'whereArgs'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer(
      (_) async => [_categoryRow(reminderEnabled: true, reminderDay: 26)],
    );
    when(
      () => database.insert(
        'categories',
        any(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      ),
    ).thenAnswer((_) async => 1);

    final updated = await repository.setExpenseSubcategoryMonthlyReminder(
      subcategoryId: 'internet',
      enabled: false,
    );

    final captured = verify(
      () => database.insert(
        'categories',
        captureAny(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      ),
    ).captured.single as Map<String, Object?>;
    expect(updated.reminderEnabled, isFalse);
    expect(updated.reminderDay, isNull);
    expect(captured['reminder_enabled'], 0);
    expect(captured['reminder_day'], isNull);
  });
}

Map<String, Object?> _categoryRow({
  bool reminderEnabled = false,
  int? reminderDay,
}) {
  return {
    'id': 'internet',
    'name': 'Internet',
    'icon_key': 'wifi',
    'scope': 'expense',
    'parent_id': 'services',
    'is_default': 0,
    'reminder_enabled': reminderEnabled ? 1 : 0,
    'reminder_day': reminderDay,
    'created_at': DateTime(2026, 4, 1).toIso8601String(),
    'updated_at': DateTime(2026, 4, 1).toIso8601String(),
  };
}

class _FakeAppDatabase extends AppDatabase {
  _FakeAppDatabase(this._database);

  final Database _database;

  @override
  Future<Database> get instance async => _database;
}

class _MockDatabase extends Mock implements Database {}
