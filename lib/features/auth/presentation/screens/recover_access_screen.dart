import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_strings.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../brand_logo_asset.dart';
import '../../../finance/presentation/providers/finance_providers.dart';
import '../auth_error_localizer.dart';
import '../providers/auth_providers.dart';

class RecoverAccessScreen extends ConsumerStatefulWidget {
  const RecoverAccessScreen({super.key});

  @override
  ConsumerState<RecoverAccessScreen> createState() =>
      _RecoverAccessScreenState();
}

class _RecoverAccessScreenState extends ConsumerState<RecoverAccessScreen> {
  final _birthDateController = TextEditingController();
  final _documentController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _enableBiometrics = false;
  bool _loading = false;

  @override
  void dispose() {
    _birthDateController.dispose();
    _documentController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _recover() async {
    final birthDate = _birthDateController.text.trim();
    final document = _documentController.text.trim();
    final newPin = _newPinController.text.trim();
    final confirmPin = _confirmPinController.text.trim();

    if (birthDate.isEmpty || document.isEmpty) {
      _showMessage(
        AppStrings.of(context).t('completaAmbasRespuestasDeRecuperacion'),
      );
      return;
    }
    if (!_isValidBirthDate(birthDate) || !_isValidDocument(document)) {
      _showMessage(
        AppStrings.of(context).t('usaUnaFechaValidaYUnDocumento'),
      );
      return;
    }
    if (newPin != confirmPin) {
      _showMessage(
        AppStrings.of(context).t('losPinNoCoinciden'),
      );
      return;
    }

    setState(() => _loading = true);
    final success =
        await ref.read(authControllerProvider.notifier).recoverAccess(
              birthDate: birthDate,
              documentId: document,
              newPin: newPin,
              enableBiometrics: _enableBiometrics,
            );
    setState(() => _loading = false);

    if (!success && mounted) {
      _showMessage(
        localizeAuthError(context, ref.read(authControllerProvider).error),
      );
      return;
    }

    ref.invalidate(settingsControllerProvider);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool _isValidBirthDate(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '').length == 8;
  }

  bool _isValidDocument(String value) {
    final normalized =
        value.replaceAll(RegExp(r'[^0-9a-zA-Z]'), '').toUpperCase();
    return normalized.length >= 6 && normalized.length <= 16;
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final biometricAvailable =
        ref.watch(authControllerProvider).biometricAvailable;

    return Scaffold(
      appBar: AppBar(title: Text(strings.recoverAccess)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 32),
        children: [
          const Center(child: BrandLogo(size: 64)),
          const SizedBox(height: 20),
          Text(
            strings.t('recuperaTuAccesoSinComplicarte'),
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            strings.t('respondeTusDosPreguntasPersonalesYElegi'),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .errorContainer
                  .withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              strings.t('laRecuperacionLocalEsMenosRobustaQue'),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _birthDateController,
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(
              labelText: strings.birthDate,
              hintText: strings.t('ejemplo10021996'),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _documentController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: strings.documentId,
              hintText: strings.authRecoveryDocumentExample,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _newPinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: AppConstants.maxPinLength,
            decoration: InputDecoration(
              labelText: strings.t('nuevoPin'),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _confirmPinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: AppConstants.maxPinLength,
            decoration: InputDecoration(
              labelText: strings.t('confirmarPin'),
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _enableBiometrics,
            onChanged: biometricAvailable
                ? (value) => setState(() => _enableBiometrics = value)
                : null,
            title: Text(
              strings.t('activarHuellaParaProximosAccesos'),
            ),
            subtitle: Text(
              biometricAvailable
                  ? (strings.t('asiVasAPoderEntrarMasRapido'))
                  : (strings.t('laBiometriaNoEstaDisponibleEnEste')),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _loading ? null : _recover,
            child: Text(
              _loading ? (strings.t('validando')) : strings.recoverAccess,
            ),
          ),
        ],
      ),
    );
  }
}
