import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

class BackupCipherService {
  static const int _saltLength = 16;
  static const int _nonceLength = 12;
  static const int _iterations = 120000;
  static const int _bits = 256;

  const BackupCipherService();

  Future<String> encryptJsonPayload(
    String payload, {
    required String password,
  }) async {
    final normalizedPassword = password.trim();
    if (normalizedPassword.isEmpty) {
      throw const FormatException(
        'La contraseña del backup no puede estar vacía.',
      );
    }

    final salt = _randomBytes(_saltLength);
    final nonce = _randomBytes(_nonceLength);
    final secretKey = await _deriveKey(normalizedPassword, salt);
    final secretBox = await AesGcm.with256bits().encrypt(
      utf8.encode(payload),
      secretKey: secretKey,
      nonce: nonce,
    );

    return const JsonEncoder.withIndent('  ').convert({
      'format': 'clean_finance_backup',
      'encrypted': true,
      'algorithm': 'aes-256-gcm',
      'kdf': {
        'name': 'pbkdf2-hmac-sha256',
        'iterations': _iterations,
        'salt': base64Encode(salt),
      },
      'nonce': base64Encode(secretBox.nonce),
      'ciphertext': base64Encode(secretBox.cipherText),
      'mac': base64Encode(secretBox.mac.bytes),
    });
  }

  Future<String> decryptPayload(
    String payload, {
    required String password,
  }) async {
    final decoded = jsonDecode(payload);
    if (decoded is! Map<String, dynamic> || decoded['encrypted'] != true) {
      return payload;
    }

    final normalizedPassword = password.trim();
    if (normalizedPassword.isEmpty) {
      throw const FormatException(
        'Este backup está protegido. Ingresá la contraseña para importarlo.',
      );
    }

    final kdf = decoded['kdf'];
    if (kdf is! Map<String, dynamic>) {
      throw const FormatException(
          'El backup cifrado no tiene metadatos válidos.');
    }

    final iterations = (kdf['iterations'] as num?)?.toInt() ?? _iterations;
    final salt = _requiredBase64(kdf['salt'], 'salt');
    final nonce = _requiredBase64(decoded['nonce'], 'nonce');
    final ciphertext = _requiredBase64(decoded['ciphertext'], 'ciphertext');
    final mac = _requiredBase64(decoded['mac'], 'mac');
    final secretKey = await _deriveKey(
      normalizedPassword,
      salt,
      iterations: iterations,
    );

    try {
      final clearBytes = await AesGcm.with256bits().decrypt(
        SecretBox(
          ciphertext,
          nonce: nonce,
          mac: Mac(mac),
        ),
        secretKey: secretKey,
      );
      return utf8.decode(clearBytes);
    } catch (_) {
      throw const FormatException(
        'No se pudo abrir el backup. Verificá la contraseña e intentá nuevamente.',
      );
    }
  }

  bool looksEncryptedPayload(String payload) {
    try {
      final decoded = jsonDecode(payload);
      return decoded is Map<String, dynamic> &&
          decoded['encrypted'] == true &&
          decoded['ciphertext'] is String;
    } catch (_) {
      return false;
    }
  }

  Future<SecretKey> _deriveKey(
    String password,
    List<int> salt, {
    int iterations = _iterations,
  }) {
    final algorithm = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: iterations,
      bits: _bits,
    );
    return algorithm.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );
  }

  Uint8List _randomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(length, (_) => random.nextInt(256)),
    );
  }

  List<int> _requiredBase64(Object? raw, String field) {
    if (raw is! String || raw.isEmpty) {
      throw FormatException('El backup cifrado no incluye "$field".');
    }
    try {
      return base64Decode(raw);
    } catch (_) {
      throw FormatException(
          'El campo "$field" del backup cifrado es inválido.');
    }
  }
}
