import 'package:clean_finance/core/database/app_database.dart';
import 'package:clean_finance/core/security/secure_storage_service.dart';
import 'package:clean_finance/features/finance/data/local_finance_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockDatabase database;

  setUp(() {
    database = _MockDatabase();
  });

  test('importData rejects invalid relationships before touching the database',
      () async {
    final repository = LocalFinanceRepository(_FakeAppDatabase(database));

    await expectLater(
      () => repository.importData('''
{
  "categories": [],
  "movements": [
    {
      "id": "movement-1",
      "type": "expense",
      "amount": 1200,
      "category_id": "missing-category",
      "occurred_on": "2026-04-17T00:00:00.000",
      "created_at": "2026-04-17T00:00:00.000",
      "updated_at": "2026-04-17T00:00:00.000"
    }
  ],
  "savingsGoals": []
}
'''),
      throwsFormatException,
    );

    verifyZeroInteractions(database);
  });

  test('clearAllData resets the database and secure storage', () async {
    final appDatabase = _ResettableFakeAppDatabase(database);
    final secureStorage = _MockSecureStorageService();
    when(() => secureStorage.clearAll()).thenAnswer((_) async {});

    final repository = LocalFinanceRepository(
      appDatabase,
      secureStorage: secureStorage,
    );

    await repository.clearAllData();

    expect(appDatabase.resetCalled, isTrue);
    verify(() => secureStorage.clearAll()).called(1);
  });
}

class _FakeAppDatabase extends AppDatabase {
  _FakeAppDatabase(this._database);

  final Database _database;

  @override
  Future<Database> get instance async => _database;
}

class _ResettableFakeAppDatabase extends _FakeAppDatabase {
  _ResettableFakeAppDatabase(super.database);

  bool resetCalled = false;

  @override
  Future<void> reset() async {
    resetCalled = true;
  }
}

class _MockDatabase extends Mock implements Database {}

class _MockSecureStorageService extends Mock implements SecureStorageService {}
