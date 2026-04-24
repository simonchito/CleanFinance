import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../brand_logo_asset.dart';
import '../providers/auth_providers.dart';
import 'recover_access_screen.dart';

class UnlockScreen extends ConsumerStatefulWidget {
  const UnlockScreen({super.key});

  @override
  ConsumerState<UnlockScreen> createState() => _UnlockScreenState();
}

class _UnlockScreenState extends ConsumerState<UnlockScreen> {
  final _pinController = TextEditingController();
  bool _loading = false;
  bool _biometricAttempted = false;
  Timer? _lockRefreshTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authState = ref.read(authControllerProvider);
    if (_biometricAttempted ||
        !authState.biometricAvailable ||
        !authState.biometricEnabled) {
      return;
    }
    _biometricAttempted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _unlockWithBiometrics();
      }
    });
  }

  @override
  void dispose() {
    _lockRefreshTimer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _unlockWithPin() async {
    setState(() => _loading = true);
    final success = await ref
        .read(authControllerProvider.notifier)
        .unlockWithPin(_pinController.text.trim());
    setState(() => _loading = false);
    if (!success && mounted) {
      _showMessage(ref.read(authControllerProvider).errorMessage ?? 'Error.');
    }
  }

  Future<void> _unlockWithBiometrics() async {
    setState(() => _loading = true);
    final success =
        await ref.read(authControllerProvider.notifier).unlockWithBiometrics();
    setState(() => _loading = false);
    if (!success && mounted) {
      _showMessage(ref.read(authControllerProvider).errorMessage ?? 'Error.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _syncLockRefreshTimer(Duration remainingLock) {
    if (remainingLock > Duration.zero) {
      _lockRefreshTimer ??=
          Timer.periodic(const Duration(seconds: 1), (_) async {
        if (!mounted) {
          return;
        }
        setState(() {});
        final currentRemaining = ref
            .read(authControllerProvider)
            .pinSecurityState
            .remainingLockDuration;
        if (currentRemaining <= Duration.zero) {
          _lockRefreshTimer?.cancel();
          _lockRefreshTimer = null;
          await ref
              .read(authControllerProvider.notifier)
              .refreshPinSecurityState();
        }
      });
      return;
    }

    _lockRefreshTimer?.cancel();
    _lockRefreshTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final scheme = Theme.of(context).colorScheme;
    final remainingLock = authState.pinSecurityState.remainingLockDuration;
    final isPinLocked = remainingLock > Duration.zero;
    _syncLockRefreshTimer(remainingLock);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.2,
            colors: [
              scheme.primaryContainer.withValues(alpha: 0.42),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 42),
              const Center(child: BrandLogo(size: 74)),
              const SizedBox(height: 28),
              Text(
                'Bienvenido otra vez',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Entrá con tu PIN o usá biometría para acceder rápido a tus finanzas.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 26),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _pinController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      enabled: !_loading && !isPinLocked,
                      decoration: const InputDecoration(
                        labelText: 'PIN',
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                      ),
                      onSubmitted: (_) => _unlockWithPin(),
                    ),
                    if (isPinLocked) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Esperá ${remainingLock.inSeconds.ceil()}s para volver a intentar.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: scheme.error,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    if (authState.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: scheme.errorContainer.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          authState.errorMessage!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed:
                          _loading || isPinLocked ? null : _unlockWithPin,
                      child: Text(_loading ? 'Validando...' : 'Desbloquear'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _loading ||
                              !authState.biometricEnabled ||
                              !authState.biometricAvailable
                          ? null
                          : _unlockWithBiometrics,
                      icon: const Icon(Icons.fingerprint_rounded),
                      label: const Text('Usar biometría'),
                    ),
                    if (authState.recoveryConfigured) ...[
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: _loading
                            ? null
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const RecoverAccessScreen(),
                                  ),
                                );
                              },
                        child: const Text('Olvidé mi PIN'),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: scheme.surface.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  authState.biometricAvailable
                      ? 'Tip: si activaste biometría, entrar te lleva un toque.'
                      : 'La biometría no está disponible en este dispositivo, pero tu PIN sigue protegido localmente.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
