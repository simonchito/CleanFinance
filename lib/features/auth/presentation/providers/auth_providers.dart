import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers.dart';
import '../auth_controller.dart';
import '../auth_state.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final controller = AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    categoriesRepository: ref.watch(categoriesRepositoryProvider),
  );
  Future.microtask(controller.bootstrap);
  return controller;
});
