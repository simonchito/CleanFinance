import 'dart:convert';

import 'package:clean_finance/core/security/password_hasher.dart';
import 'package:clean_finance/core/security/secure_storage_service.dart';
import 'package:clean_finance/features/auth/data/local_auth_repository.dart';
import 'package:clean_finance/features/auth/domain/entities/pin_security_state.dart';
import 'package:clean_finance/features/finance/domain/entities/app_settings.dart';
import 'package:clean_finance/features/finance/domain/entities/app_theme_preference.dart';
import 'package:clean_finance/features/finance/domain/repositories/settings_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clean_finance/core/security/biometric_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _InMemoryFlutterSecureStorage storage;
  late LocalAuthRepository repository;

  setUp(() {
    storage = _InMemoryFlutterSecureStorage();
    repository = LocalAuthRepository(
      secureStorage: SecureStorageService(storage: storage),
      passwordHasher: PasswordHasher(),
      biometricService: _FakeBiometricService(),
      settingsRepository: _FakeSettingsRepository(),
    );
  });

  test('locks PIN verification after repeated failed attempts', () async {
    await repository.savePin('123456');

    for (var attempt = 0; attempt < 4; attempt++) {
      final result = await repository.verifyPin('000000');
      expect(result.status, PinVerificationStatus.invalidPin);
      expect(result.securityState.failedAttempts, attempt + 1);
    }

    final lockedResult = await repository.verifyPin('000000');

    expect(lockedResult.status, PinVerificationStatus.locked);
    expect(lockedResult.securityState.isLocked, isTrue);
    expect(lockedResult.securityState.lockoutLevel, 1);
  });

  test('successful PIN verification clears persisted failure state', () async {
    await repository.savePin('123456');
    await repository.verifyPin('000000');
    await repository.verifyPin('000000');

    final result = await repository.verifyPin('123456');

    expect(result.status, PinVerificationStatus.success);
    expect(result.securityState.failedAttempts, 0);
    expect(result.securityState.lockoutLevel, 0);
    expect(result.securityState.lockedUntil, isNull);
  });

  test('expired lock state is normalized when bootstrapping from storage',
      () async {
    await storage.write(
      key: 'auth.pin_security_state',
      value: jsonEncode({
        'failedAttempts': 0,
        'lockoutLevel': 2,
        'lockedUntil': DateTime.now()
            .subtract(const Duration(seconds: 5))
            .toIso8601String(),
      }),
    );

    final state = await repository.getPinSecurityState();

    expect(state.isLocked, isFalse);
    expect(state.lockedUntil, isNull);
    expect(state.lockoutLevel, 2);
  });
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

class _FakeBiometricService extends BiometricService {
  @override
  Future<bool> isAvailable() async => false;
}

class _InMemoryFlutterSecureStorage implements FlutterSecureStorage {
  final Map<String, String> _values = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WebOptions? webOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      _values.remove(key);
      return;
    }
    _values[key] = value;
  }

  @override
  Future<String?> read({
    required String key,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WebOptions? webOptions,
    WindowsOptions? wOptions,
  }) async {
    return _values[key];
  }

  @override
  Future<void> delete({
    required String key,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WebOptions? webOptions,
    WindowsOptions? wOptions,
  }) async {
    _values.remove(key);
  }

  @override
  Future<void> deleteAll({
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WebOptions? webOptions,
    WindowsOptions? wOptions,
  }) async {
    _values.clear();
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
