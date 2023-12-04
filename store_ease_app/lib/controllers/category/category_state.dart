part of 'category_bloc.dart';

class CategoryState {
  CategoryState({
    required this.category,
    required this.allCategoryList,
    required this.selectCategoryList,
    required this.filteredCategoryList,
    required this.deleteStatus,
    required this.isEditing,
    required this.errorMessage,
    required this.status,
  });

  // Category
  final Category category;
  final List<Category> allCategoryList;
  final List<Category> selectCategoryList;
  final List<Category> filteredCategoryList;

  // Delete Category
  final LoadStatus deleteStatus;

  // Common
  final bool isEditing;
  final String errorMessage;
  final LoadStatus status;

  factory CategoryState.initial() => CategoryState(
        category: Category.empty(),
        allCategoryList: const <Category>[],
        selectCategoryList: const <Category>[],
        filteredCategoryList: const <Category>[],
        deleteStatus: LoadStatus.initial,
        isEditing: false,
        errorMessage: '',
        status: LoadStatus.initial,
      );

  CategoryState copyWith({
    Category? category,
    List<Category>? allCategoryList,
    List<Category>? selectCategoryList,
    List<Category>? filteredCategoryList,
    LoadStatus? deleteStatus,
    bool? isEditing,
    String? errorMessage,
    LoadStatus? status,
  }) {
    return CategoryState(
      category: category ?? this.category,
      allCategoryList: allCategoryList ?? this.allCategoryList,
      selectCategoryList: selectCategoryList ?? this.selectCategoryList,
      filteredCategoryList: filteredCategoryList ?? this.filteredCategoryList,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      isEditing: isEditing ?? this.isEditing,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}
