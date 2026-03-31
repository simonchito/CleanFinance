import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/errors/app_error_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppErrorHandler.configure();
  await AppErrorHandler.run(() async {
    runApp(const ProviderScope(child: CleanFinanceApp()));
  });
}
