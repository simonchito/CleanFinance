import 'package:clean_finance/core/security/backup_cipher_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const service = BackupCipherService();

  test('encrypts and decrypts backup payloads with password', () async {
    const payload = '{"movements":[{"id":"1"}]}';

    final encrypted = await service.encryptJsonPayload(
      payload,
      password: 'secreto123',
    );
    final decrypted = await service.decryptPayload(
      encrypted,
      password: 'secreto123',
    );

    expect(service.looksEncryptedPayload(encrypted), isTrue);
    expect(decrypted, payload);
  });

  test('rejects wrong password for encrypted backups', () async {
    const payload = '{"movements":[{"id":"1"}]}';
    final encrypted = await service.encryptJsonPayload(
      payload,
      password: 'secreto123',
    );

    await expectLater(
      () => service.decryptPayload(encrypted, password: 'otro-password'),
      throwsFormatException,
    );
  });

  test('leaves plain JSON payloads untouched', () async {
    const payload = '{"movements":[{"id":"1"}]}';

    final decrypted = await service.decryptPayload(payload, password: '');

    expect(service.looksEncryptedPayload(payload), isFalse);
    expect(decrypted, payload);
  });
}
