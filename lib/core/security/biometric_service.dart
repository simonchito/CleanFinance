import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _localAuthentication;

  BiometricService({LocalAuthentication? localAuthentication})
      : _localAuthentication = localAuthentication ?? LocalAuthentication();

  Future<bool> isAvailable() async {
    final canCheck = await _localAuthentication.canCheckBiometrics;
    if (canCheck) {
      return true;
    }
    return _localAuthentication.isDeviceSupported();
  }

  Future<bool> authenticate() async {
    final available = await isAvailable();
    if (!available) {
      return false;
    }

    try {
      return _localAuthentication.authenticate(
        localizedReason: 'Usá tu biometría para desbloquear Clean Finance',
        biometricOnly: true,
      );
    } on LocalAuthException {
      return false;
    } catch (_) {
      return false;
    }
  }
}
