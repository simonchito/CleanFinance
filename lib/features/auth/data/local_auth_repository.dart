import '../domain/repositories/auth_repository.dart';
import 'local_security_repository.dart';

class LocalAuthRepository extends LocalSecurityRepository
    implements AuthRepository {
  LocalAuthRepository({
    required super.secureStorage,
    required super.passwordHasher,
    required super.biometricService,
    required super.settingsRepository,
  });
}
