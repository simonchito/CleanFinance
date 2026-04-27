import 'package:local_auth/local_auth.dart';
import 'package:flutter/foundation.dart';

class BiometricService {
  final LocalAuthentication _localAuthentication;

  BiometricService({LocalAuthentication? localAuthentication})
      : _localAuthentication = localAuthentication ?? LocalAuthentication();

  Future<bool> isAvailable() async {
    try {
      if (kDebugMode) {
        debugPrint('[startup] Checking biometric availability');
      }
      final canCheck = await _localAuthentication.canCheckBiometrics;
      if (canCheck) {
        return true;
      }
      return await _localAuthentication.isDeviceSupported();
    } on LocalAuthException catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('[startup] Biometric availability failed: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
      return false;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          '[startup] Unexpected biometric availability failure: $error',
        );
        debugPrintStack(stackTrace: stackTrace);
      }
      return false;
    }
  }

  Future<bool> authenticate() async {
    final available = await isAvailable();
    if (!available) {
      return false;
    }

    try {
      if (kDebugMode) {
        debugPrint('[startup] Starting biometric authentication');
      }
      return _localAuthentication.authenticate(
        localizedReason: 'Usá tu biometría para desbloquear Clean Finance',
        biometricOnly: true,
      );
    } on LocalAuthException catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('[startup] Biometric auth failed: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
      return false;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('[startup] Unexpected biometric auth failure: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
      return false;
    }
  }
}
