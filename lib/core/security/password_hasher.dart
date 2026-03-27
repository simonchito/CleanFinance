import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

class StoredCredential {
  const StoredCredential({
    required this.hash,
    required this.salt,
    required this.iterations,
  });

  final String hash;
  final String salt;
  final int iterations;

  Map<String, dynamic> toJson() => {
        'hash': hash,
        'salt': salt,
        'iterations': iterations,
      };

  factory StoredCredential.fromJson(Map<String, dynamic> json) {
    return StoredCredential(
      hash: json['hash'] as String,
      salt: json['salt'] as String,
      iterations: json['iterations'] as int,
    );
  }
}

class PasswordHasher {
  static const _iterations = 120000;
  static const _saltLength = 16;
  static const _bits = 256;

  Future<StoredCredential> hashPin(String pin) async {
    return hashSecret(pin);
  }

  Future<bool> verifyPin(String pin, StoredCredential stored) async {
    return verifySecret(pin, stored);
  }

  Future<StoredCredential> hashSecret(String secret) async {
    final salt = _generateSalt();
    final hash = await _derive(secret, salt, _iterations);
    return StoredCredential(
      hash: base64Encode(hash),
      salt: base64Encode(salt),
      iterations: _iterations,
    );
  }

  Future<bool> verifySecret(String secret, StoredCredential stored) async {
    final derived = await _derive(
      secret,
      base64Decode(stored.salt),
      stored.iterations,
    );
    final storedHash = base64Decode(stored.hash);
    return const ListEquality().equals(derived, storedHash);
  }

  Uint8List _generateSalt() {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(_saltLength, (_) => random.nextInt(256)),
    );
  }

  Future<List<int>> _derive(String pin, List<int> salt, int iterations) async {
    final algorithm = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: iterations,
      bits: _bits,
    );
    final secretKey = await algorithm.deriveKey(
      secretKey: SecretKey(utf8.encode(pin)),
      nonce: salt,
    );
    return secretKey.extractBytes();
  }
}

class ListEquality {
  const ListEquality();

  bool equals(List<int> a, List<int> b) {
    if (a.length != b.length) {
      return false;
    }

    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a[i] ^ b[i];
    }
    return result == 0;
  }
}
