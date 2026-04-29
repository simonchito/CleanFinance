import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

void configureDatabasePlatform() {}

Future<String> databasePathFor(String databaseName) async {
  final databasesPath = await getDatabasesPath();
  return p.join(databasesPath, databaseName);
}

Future<void> deleteDatabasePath(String path) {
  return deleteDatabase(path);
}
