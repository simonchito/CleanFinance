import 'package:clean_finance/core/security/biometric_service.dart';
import 'package:clean_finance/core/security/password_hasher.dart';
import 'package:clean_finance/core/security/secure_storage_service.dart';
import 'package:clean_finance/features/auth/data/local_auth_repository.dart';
import 'package:clean_finance/features/finance/domain/entities/app_settings.dart';
import 'package:clean_finance/features/finance/domain/entities/app_theme_preference.dart';
import 'package:clean_finance/features/finance/domain/repositories/settings_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockFlutterSecureStorage storage;
  late _FakeSettingsRepository settingsRepository;

  setUp(() {
    storage = _MockFlutterSecureStorage();
    settingsRepository = _FakeSettingsRepository();
  });

  test('migrates legacy biometric flag into settings when available', () async {
    when(
      () => storage.read(key: 'auth.biometric_enabled'),
    ).thenAnswer((_) async => '1');
    when(() => storage.delete(key: 'auth.biometric_enabled'))
        .thenAnswer((_) async {});

    final repository = LocalAuthRepository(
      secureStorage: SecureStorageService(storage: storage),
      passwordHasher: PasswordHasher(),
      biometricService: _FakeBiometricService(available: true),
      settingsRepository: settingsRepository,
    );

    final enabled = await repository.isBiometricEnabled();

    expect(enabled, isTrue);
    expect(settingsRepository.current.biometricEnabled, isTrue);
    verify(() => storage.delete(key: 'auth.biometric_enabled')).called(1);
  });

  test(
      'disables persisted biometric preference when biometrics are unavailable',
      () async {
    settingsRepository.current =
        settingsRepository.current.copyWith(biometricEnabled: true);
    when(
      () => storage.read(key: 'auth.biometric_enabled'),
    ).thenAnswer((_) async => null);
    when(() => storage.delete(key: 'auth.biometric_enabled'))
        .thenAnswer((_) async {});

    final repository = LocalAuthRepository(
      secureStorage: SecureStorageService(storage: storage),
      passwordHasher: PasswordHasher(),
      biometricService: _FakeBiometricService(available: false),
      settingsRepository: settingsRepository,
    );

    final enabled = await repository.isBiometricEnabled();

    expect(enabled, isFalse);
    expect(settingsRepository.current.biometricEnabled, isFalse);
  });

  test('setBiometricEnabled persists a single source of truth in settings',
      () async {
    when(() => storage.delete(key: 'auth.biometric_enabled'))
        .thenAnswer((_) async {});

    final repository = LocalAuthRepository(
      secureStorage: SecureStorageService(storage: storage),
      passwordHasher: PasswordHasher(),
      biometricService: _FakeBiometricService(available: true),
      settingsRepository: settingsRepository,
    );

    await repository.setBiometricEnabled(true);

    expect(settingsRepository.current.biometricEnabled, isTrue);
    verify(() => storage.delete(key: 'auth.biometric_enabled')).called(1);
  });
}

class _FakeSettingsRepository implements SettingsRepository {
  AppSettings current = const AppSettings(
    currencyCode: 'ARS',
    currencySymbol: r'$',
    showSensitiveAmounts: true,
    themePreference: AppThemePreference.system,
    biometricEnabled: false,
    autoLockMinutes: 5,
    localeCode: 'es',
    paymentMethods: ['Transferencia', 'QR'],
  );

  @override
  Future<AppSettings> getSettings() async => current;

  @override
  Future<void> saveSettings(AppSettings settings) async {
    current = settings;
  }
}

class _FakeBiometricService extends BiometricService {
  _FakeBiometricService({
    required this.available,
  });

  final bool available;

  @override
  Future<bool> isAvailable() async => available;
}

class _MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}
