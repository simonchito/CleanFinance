import 'dart:convert';
import 'dart:io';

import 'package:clean_finance/core/constants/app_constants.dart';
import 'package:clean_finance/core/localization/app_locale_mode.dart';
import 'package:clean_finance/core/localization/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('l10n configuration', () {
    test('keeps source ARB files aligned with supported locales', () {
      final arbDir = Directory('lib/l10n');
      final arbFiles = arbDir
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.arb'))
          .map((file) => file.uri.pathSegments.last)
          .toSet();

      expect(arbFiles, {'app_es.arb', 'app_en.arb'});

      final spanish = _loadMessages(File('lib/l10n/app_es.arb'));
      final english = _loadMessages(File('lib/l10n/app_en.arb'));

      expect(english.keys.toSet(), spanish.keys.toSet());
    });

    test('does not expose retired Portuguese preferences', () {
      expect(AppConstants.supportedLocaleCodes, ['es', 'en']);
      expect(AppConstants.supportedLocalePreferenceCodes, [
        'system',
        'es',
        'en',
      ]);
      expect(AppLocaleMode.supportedLocales, const [
        Locale('es'),
        Locale('en'),
      ]);
      expect(AppLocalizations.supportedLocales, const [
        Locale('en'),
        Locale('es'),
      ]);
      expect(AppConstants.normalizeLocalePreferenceCode('pt_BR'), 'system');
      expect(AppConstants.normalizeLocalePreferenceCode('pt'), 'system');
    });
  });
}

Map<String, Object?> _loadMessages(File file) {
  final decoded = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  return Map<String, Object?>.fromEntries(
    decoded.entries.where((entry) => !entry.key.startsWith('@')),
  );
}
