abstract class BackupRepository {
  Future<String> exportData({String? password});
  Future<void> importData(String payload, {String? password});
  Future<void> clearAllData();
}
