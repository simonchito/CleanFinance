import 'package:clean_finance/core/database/app_database.dart';
import 'package:clean_finance/features/finance/data/local_finance_repository.dart';
import 'package:clean_finance/features/finance/domain/entities/movement.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockDatabase database;
  late LocalFinanceRepository repository;

  setUpAll(() {
    registerFallbackValue(ConflictAlgorithm.abort);
  });

  setUp(() {
    database = _MockDatabase();
    repository = LocalFinanceRepository(_FakeAppDatabase(database));
  });

  test('upsertMovement canonicalizes paymentMethod before writing to DB',
      () async {
    final movement = Movement(
      id: 'movement-1',
      type: MovementType.expense,
      amount: 1500,
      categoryId: 'food',
      occurredOn: DateTime(2026, 4, 17),
      paymentMethod: 'codigo qr',
      createdAt: DateTime(2026, 4, 17, 10),
      updatedAt: DateTime(2026, 4, 17, 10),
    );

    when(
      () => database.insert(
        'movements',
        any(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      ),
    ).thenAnswer((_) async => 1);

    await repository.upsertMovement(movement);

    final captured = verify(
      () => database.insert(
        'movements',
        captureAny(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      ),
    ).captured.single as Map<String, Object?>;

    expect(captured['payment_method'], 'QR');
    expect(captured['type'], 'expense');
    expect(captured['amount'], 1500);
  });

  test('deleteMovement removes the movement by id', () async {
    when(
      () => database.delete(
        'movements',
        where: 'id = ?',
        whereArgs: ['movement-1'],
      ),
    ).thenAnswer((_) async => 1);

    await repository.deleteMovement('movement-1');

    verify(
      () => database.delete(
        'movements',
        where: 'id = ?',
        whereArgs: ['movement-1'],
      ),
    ).called(1);
  });
}

class _FakeAppDatabase extends AppDatabase {
  _FakeAppDatabase(this._database);

  final Database _database;

  @override
  Future<Database> get instance async => _database;
}

class _MockDatabase extends Mock implements Database {}
