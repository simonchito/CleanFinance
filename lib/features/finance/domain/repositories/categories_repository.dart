import '../entities/category.dart';

abstract class CategoriesRepository {
  Future<void> ensureSeedData();
  Future<List<Category>> getCategories({CategoryScope? scope});
  Future<void> upsertCategory(Category category);
  Future<void> deleteCategory(String categoryId);
}
