import 'package:flutter/widgets.dart';

import '../../../app/app_strings.dart';
import '../../../core/constants/app_constants.dart';
import 'auth_state.dart';

String localizeAuthError(BuildContext context, AuthErrorState? error) {
  final strings = AppStrings.of(context);
  if (error == null) {
    return strings.isEnglish ? 'Unexpected error.' : 'Error inesperado.';
  }

  switch (error.code) {
    case AuthErrorCode.pinLengthInvalid:
      return strings.isEnglish
          ? 'PIN must be ${AppConstants.defaultPinLength} digits.'
          : 'El PIN debe tener ${AppConstants.defaultPinLength} dígitos.';
    case AuthErrorCode.recoveryDataInvalid:
      return strings.isEnglish
          ? 'Check your recovery data and try again.'
          : 'Revisá tus datos de recuperación e intentá nuevamente.';
    case AuthErrorCode.incorrectPin:
      return strings.isEnglish ? 'Incorrect PIN.' : 'PIN incorrecto.';
    case AuthErrorCode.biometricUnavailable:
      return strings.isEnglish
          ? 'Biometrics are not available on this device.'
          : 'La biometría no está disponible en este dispositivo.';
    case AuthErrorCode.biometricAuthUnavailable:
      return strings.isEnglish
          ? 'Could not use biometrics. Configure fingerprint/face and screen lock.'
          : 'No se pudo usar la biometría. Configurá huella/rostro y bloqueo de pantalla.';
    case AuthErrorCode.biometricAuthFailed:
      return strings.isEnglish
          ? 'Biometric validation failed. Verify device biometric setup.'
          : 'No se pudo validar la biometría. Verificá la configuración del dispositivo.';
    case AuthErrorCode.recoveryVerificationFailed:
      return strings.isEnglish
          ? 'Recovery verification failed. Check your answers and try again.'
          : 'No se pudo verificar la recuperación. Revisá tus datos e intentá nuevamente.';
    case AuthErrorCode.startupSafetyMode:
      return strings.isEnglish
          ? 'Some security checks failed to initialize. The app is running in safe mode.'
          : 'Algunas validaciones de seguridad no pudieron inicializarse. La app está en modo seguro.';
    case AuthErrorCode.lockoutActive:
      final seconds = error.lockSeconds ?? 1;
      return strings.isEnglish
          ? 'Too many failed attempts. Wait $seconds seconds before trying again.'
          : 'Demasiados intentos fallidos. Esperá $seconds segundos antes de volver a intentar.';
  }
}
