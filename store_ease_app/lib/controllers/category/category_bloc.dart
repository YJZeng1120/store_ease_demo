import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/category.dart';
import '../../models/core/cache_helper.dart';
import '../../models/enums/load_status_enum.dart';
import '../../models/menu.dart';
import '../../services/api_category.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryApi _categoryApi;
  CategoryBloc(
    this._categoryApi,
  ) : super(CategoryState.initial()) {
    _onEvent();
  }

  void _onEvent() {
    on<CategoryInitialEvent>((event, emit) {
      final bool isEditing = event.category.id != null;
      emit(
        state.copyWith(
          isEditing: isEditing,
          category: event.category,
        ),
      );
    });

    on<CategoryListInitialEvent>((event, emit) {
      emit(
        state.copyWith(
          selectCategoryList: event.categoryList,
        ),
      );
    });

    // Create Category
    on<CreateCategoryEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      final failureOption = await _categoryApi.createCategory(
        CacheHelper.getUserId(),
        state.category,
      );
      failureOption.fold(
        () => add(
          GetCategoryEvent(
            event.languageId,
          ),
        ),
        (f) => emit(
          state.copyWith(
            status: LoadStatus.failed,
            errorMessage: f,
          ),
        ),
      );
    });
    on<UpdateCategoryDataEvent>((event, emit) {
      emit(state.copyWith(category: event.category));
    });

    // Get Category
    on<GetCategoryEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      final failureOrSuccess = await _categoryApi.getAllByUserId(
        event.languageId,
        CacheHelper.getUserId(),
      );
      failureOrSuccess.fold(
          (f) => emit(
                state.copyWith(
                  status: LoadStatus.failed,
                  errorMessage: f,
                ),
              ), (allCategory) {
        emit(
          state.copyWith(
            status: LoadStatus.succeed,
            allCategoryList: allCategory,
          ),
        );
      });
    });

    on<FilteredCategoryListEvent>((event, emit) {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
        ),
      );
      // 使用Set刪除重複的CategoryId
      final List<int> filteredList = List<int>.from(
        event.menuItems.map((menuItem) => menuItem.categoryId).toSet(),
      );

      final List<Category> filteredCategoryList = state.allCategoryList
          .where((element) => filteredList.contains(element.id))
          .toList();

      emit(
        state.copyWith(
          filteredCategoryList: filteredCategoryList,
          status: LoadStatus.succeed,
        ),
      );
    });

    on<SelectCategoryEvent>((event, emit) {
      emit(state.copyWith(category: event.category));
    });

    on<AddCategoryEvent>((event, emit) {
      final updatedList = List.of(state.selectCategoryList); // 複製原始list
      updatedList.add(
        event.category,
      );

      // 使用Set刪除重複的CategoryId
      final List<int> filteredList = List<int>.from(
        updatedList.map((category) => category.id).toSet(),
      );

      final List<Category> selectCategoryList = state.allCategoryList
          .where((element) => filteredList.contains(element.id))
          .toList();

      emit(state.copyWith(selectCategoryList: selectCategoryList));
    });

    on<RemoveCategoryEvent>((event, emit) {
      final updatedList = List.of(state.selectCategoryList); // 複製原始list
      updatedList.remove(
        event.category,
      );
      emit(state.copyWith(selectCategoryList: updatedList));
    });

    // Update Category
    on<UpdateCategoryEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      final failureOption = await _categoryApi.updateCategory(
        CacheHelper.getUserId(),
        state.category.id ?? 0,
        state.category,
      );
      failureOption.fold(
        () => add(
          GetCategoryEvent(
            event.languageId,
          ),
        ),
        (f) => emit(
          state.copyWith(
            status: LoadStatus.failed,
            errorMessage: f,
          ),
        ),
      );
    });

    // Delete Category
    on<DeleteCategoryEvent>((event, emit) async {
      emit(
        state.copyWith(
          deleteStatus: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      final failureOption = await _categoryApi.deleteCategory(
        CacheHelper.getUserId(),
        event.categoryId,
      );
      failureOption.fold(
        () => emit(
          state.copyWith(
            deleteStatus: LoadStatus.succeed,
          ),
        ),
        (f) => emit(
          state.copyWith(
            deleteStatus: LoadStatus.failed,
            errorMessage: f,
          ),
        ),
      );
    });
  }
}
