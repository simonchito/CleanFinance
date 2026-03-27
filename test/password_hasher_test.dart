import 'package:clean_finance/core/security/password_hasher.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PasswordHasher', () {
    test('genera un hash verificable para el mismo PIN', () async {
      final hasher = PasswordHasher();
      const pin = '123456';

      final stored = await hasher.hashPin(pin);
      final matches = await hasher.verifyPin(pin, stored);

      expect(matches, isTrue);
    });

    test('rechaza un PIN diferente', () async {
      final hasher = PasswordHasher();
      final stored = await hasher.hashPin('123456');

      final matches = await hasher.verifyPin('654321', stored);

      expect(matches, isFalse);
    });
  });
}
