part of 'category_bloc.dart';

abstract class CategoryEvent {
  const CategoryEvent();
}

class CategoryInitialEvent extends CategoryEvent {
  const CategoryInitialEvent(this.category);
  final Category category;
}

class CategoryListInitialEvent extends CategoryEvent {
  const CategoryListInitialEvent(this.categoryList);
  final List<Category> categoryList;
}

// Create Category

class CreateCategoryEvent extends CategoryEvent {
  const CreateCategoryEvent(this.languageId);
  final int languageId;
}

class UpdateCategoryDataEvent extends CategoryEvent {
  const UpdateCategoryDataEvent(this.category);
  final Category category;
}

// Get Category
class GetCategoryEvent extends CategoryEvent {
  const GetCategoryEvent(this.languageId);
  final int languageId;
}

class FilteredCategoryListEvent extends CategoryEvent {
  const FilteredCategoryListEvent(this.menuItems);
  final List<MenuItem> menuItems;
}

class SelectCategoryEvent extends CategoryEvent {
  const SelectCategoryEvent(this.category);
  final Category category;
}

class AddCategoryEvent extends CategoryEvent {
  const AddCategoryEvent(this.category);
  final Category category;
}

class EditCategoryEvent extends CategoryEvent {
  const EditCategoryEvent();
}

class RemoveCategoryEvent extends CategoryEvent {
  const RemoveCategoryEvent(this.category);
  final Category category;
}

// Update Category
class UpdateCategoryEvent extends CategoryEvent {
  const UpdateCategoryEvent(this.languageId);
  final int languageId;
}

// Delete Category
class DeleteCategoryEvent extends CategoryEvent {
  const DeleteCategoryEvent(this.categoryId);
  final int categoryId;
}
