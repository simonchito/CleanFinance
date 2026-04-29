import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

bool _configured = false;

void configureDatabasePlatform() {
  if (_configured) {
    return;
  }
  databaseFactory = databaseFactoryFfiWeb;
  _configured = true;
}

Future<String> databasePathFor(String databaseName) async {
  configureDatabasePlatform();
  return databaseName;
}

Future<void> deleteDatabasePath(String path) {
  configureDatabasePlatform();
  return databaseFactory.deleteDatabase(path);
}
