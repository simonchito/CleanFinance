import '../entities/category.dart';

abstract class CategoriesRepository {
  Future<void> ensureSeedData();
  Future<List<Category>> getCategories({CategoryScope? scope});
  Future<Category?> getCategoryById(String categoryId);
  Future<Category?> getActiveExpenseReminderBySubcategory(String subcategoryId);
  Future<Category> setExpenseSubcategoryMonthlyReminder({
    required String subcategoryId,
    required bool enabled,
    int? reminderDay,
  });
  Future<void> upsertCategory(Category category);
  Future<void> deleteCategory(String categoryId);
}
