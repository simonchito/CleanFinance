abstract class BackupRepository {
  Future<String> exportData();
  Future<void> importData(String payload);
  Future<void> clearAllData();
}
