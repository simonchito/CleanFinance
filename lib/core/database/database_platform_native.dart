import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

bool _configured = false;

void configureDatabasePlatform() {
  if (_configured) {
    return;
  }

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    if (kDebugMode) {
      debugPrint('[startup] SQLite FFI configured for desktop');
    }
  }

  _configured = true;
}

Future<String> databasePathFor(String databaseName) async {
  configureDatabasePlatform();

  if (Platform.isWindows || Platform.isLinux) {
    final supportDirectory = await getApplicationSupportDirectory();
    final databaseDirectory = Directory(supportDirectory.path);
    if (!await databaseDirectory.exists()) {
      await databaseDirectory.create(recursive: true);
    }
    final path = p.join(databaseDirectory.path, databaseName);
    if (kDebugMode) {
      debugPrint('[startup] Desktop database path resolved to $path');
    }
    return path;
  }

  final databasesPath = await getDatabasesPath();
  final path = p.join(databasesPath, databaseName);
  if (kDebugMode) {
    debugPrint('[startup] Native database path resolved to $path');
  }
  return path;
}

Future<void> deleteDatabasePath(String path) {
  configureDatabasePlatform();
  return deleteDatabase(path);
}
