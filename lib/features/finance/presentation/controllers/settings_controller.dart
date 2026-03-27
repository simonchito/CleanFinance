import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/finance_repository.dart';

class SettingsController extends StateNotifier<AsyncValue<AppSettings>> {
  SettingsController({
    required FinanceRepository financeRepository,
  })  : _financeRepository = financeRepository,
        super(const AsyncLoading());

  final FinanceRepository _financeRepository;

  Future<void> load() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_financeRepository.getSettings);
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final current = state.valueOrNull ?? await _financeRepository.getSettings();
    final updated = current.copyWith(themeMode: themeMode);
    await _financeRepository.saveSettings(updated);
    state = AsyncData(updated);
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    final current = state.valueOrNull ?? await _financeRepository.getSettings();
    final updated = current.copyWith(biometricEnabled: enabled);
    await _financeRepository.saveSettings(updated);
    state = AsyncData(updated);
  }

  Future<void> setAutoLockMinutes(int minutes) async {
    final current = state.valueOrNull ?? await _financeRepository.getSettings();
    final updated = current.copyWith(autoLockMinutes: minutes);
    await _financeRepository.saveSettings(updated);
    state = AsyncData(updated);
  }

  Future<void> setCurrency({
    required String code,
    required String symbol,
  }) async {
    final current = state.valueOrNull ?? await _financeRepository.getSettings();
    final updated = current.copyWith(
      currencyCode: code,
      currencySymbol: symbol,
    );
    await _financeRepository.saveSettings(updated);
    state = AsyncData(updated);
  }

  Future<void> setLocaleCode(String localeCode) async {
    final current = state.valueOrNull ?? await _financeRepository.getSettings();
    final updated = current.copyWith(localeCode: localeCode);
    await _financeRepository.saveSettings(updated);
    state = AsyncData(updated);
  }

  Future<void> setPaymentMethods(List<String> paymentMethods) async {
    final current = state.valueOrNull ?? await _financeRepository.getSettings();
    final updated = current.copyWith(paymentMethods: paymentMethods);
    await _financeRepository.saveSettings(updated);
    state = AsyncData(updated);
  }
}
