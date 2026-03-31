import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/entities/app_theme_preference.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsController extends StateNotifier<AsyncValue<AppSettings>> {
  SettingsController({
    required SettingsRepository settingsRepository,
  })  : _settingsRepository = settingsRepository,
        super(const AsyncLoading());

  final SettingsRepository _settingsRepository;

  Future<void> load() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_settingsRepository.getSettings);
  }

  Future<void> setThemePreference(AppThemePreference themePreference) async {
    final current = state.valueOrNull ?? await _settingsRepository.getSettings();
    final updated = current.copyWith(themePreference: themePreference);
    await _settingsRepository.saveSettings(updated);
    state = AsyncData(updated);
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    final current = state.valueOrNull ?? await _settingsRepository.getSettings();
    final updated = current.copyWith(biometricEnabled: enabled);
    await _settingsRepository.saveSettings(updated);
    state = AsyncData(updated);
  }

  Future<void> setAutoLockMinutes(int minutes) async {
    final current = state.valueOrNull ?? await _settingsRepository.getSettings();
    final updated = current.copyWith(autoLockMinutes: minutes);
    await _settingsRepository.saveSettings(updated);
    state = AsyncData(updated);
  }

  Future<void> setCurrency({
    required String code,
    required String symbol,
  }) async {
    final current = state.valueOrNull ?? await _settingsRepository.getSettings();
    final updated = current.copyWith(
      currencyCode: code,
      currencySymbol: symbol,
    );
    await _settingsRepository.saveSettings(updated);
    state = AsyncData(updated);
  }

  Future<void> setShowSensitiveAmounts(bool visible) async {
    final current = state.valueOrNull ?? await _settingsRepository.getSettings();
    final updated = current.copyWith(showSensitiveAmounts: visible);
    await _settingsRepository.saveSettings(updated);
    state = AsyncData(updated);
  }

  Future<void> setLocaleCode(String localeCode) async {
    final current = state.valueOrNull ?? await _settingsRepository.getSettings();
    final updated = current.copyWith(localeCode: localeCode);
    await _settingsRepository.saveSettings(updated);
    state = AsyncData(updated);
  }

  Future<void> setPaymentMethods(List<String> paymentMethods) async {
    final current = state.valueOrNull ?? await _settingsRepository.getSettings();
    final updated = current.copyWith(paymentMethods: paymentMethods);
    await _settingsRepository.saveSettings(updated);
    state = AsyncData(updated);
  }
}

