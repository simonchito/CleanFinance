import 'package:flutter/widgets.dart';

import '../../../app/app_strings.dart';
import '../../../core/constants/app_constants.dart';
import 'auth_state.dart';

String localizeAuthError(BuildContext context, AuthErrorState? error) {
  final strings = AppStrings.of(context);
  if (error == null) {
    return strings.t('errorInesperado');
  }

  switch (error.code) {
    case AuthErrorCode.pinLengthInvalid:
      return strings.authPinLengthInvalid(AppConstants.defaultPinLength);
    case AuthErrorCode.recoveryDataInvalid:
      return strings.t('revisaTusDatosDeRecuperacionEIntenta');
    case AuthErrorCode.incorrectPin:
      return strings.t('pinIncorrecto');
    case AuthErrorCode.biometricUnavailable:
      return strings.t('laBiometriaNoEstaDisponibleEnEste');
    case AuthErrorCode.biometricAuthUnavailable:
      return strings.t('noSePudoUsarLaBiometriaConfigura');
    case AuthErrorCode.biometricAuthFailed:
      return strings.t('noSePudoValidarLaBiometriaVerifica');
    case AuthErrorCode.recoveryVerificationFailed:
      return strings.t('noSePudoVerificarLaRecuperacionRevisa');
    case AuthErrorCode.startupSafetyMode:
      return strings.t('algunasValidacionesDeSeguridadNoPudieronInicializarse');
    case AuthErrorCode.lockoutActive:
      final seconds = error.lockSeconds ?? 1;
      return strings.authLockoutActive(seconds);
  }
}
