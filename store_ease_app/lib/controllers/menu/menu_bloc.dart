import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../functions/image_utility.dart';
import '../../models/core/cache_helper.dart';
import '../../models/enums/load_status_enum.dart';
import '../../models/menu.dart';
import '../../services/api_menu.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuApi _menuApi;

  MenuBloc(
    this._menuApi,
  ) : super(MenuState.initial()) {
    _onEvent();
  }
  void _onEvent() {
    on<MenuInitialEvent>((event, emit) {
      final bool isEditing = event.menu.menuId != null;
      emit(
        state.copyWith(
          isEditing: isEditing,
          menu: event.menu,
          menuItemList: event.menu.menuItems,
          menuItem: MenuItem.empty(),
        ),
      );
    });

    on<MenuItemInitialEvent>((event, emit) {
      final bool isMenuItemEditing = event.isEditing;
      emit(
        state.copyWith(
          isMenuItemEditing: isMenuItemEditing,
          menuItem: event.menuItem,
        ),
      );
    });

    //Create Menu
    on<UpdateMenuDataEvent>((event, emit) {
      emit(state.copyWith(menu: event.menu));
    });

    on<UpdateMenuItemDataEvent>((event, emit) {
      emit(state.copyWith(menuItem: event.menuItem));
    });

    on<GetImageFromCameraEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
        ),
      );
      final getImage = await getImageFromCamera();
      getImage.fold(
        () => emit(
          state.copyWith(
            status: LoadStatus.succeed,
          ),
        ), // 處理使用者取消操作的情況
        (imageBytes) => emit(
          state.copyWith(
            status: LoadStatus.succeed,
            menuItem: state.menuItem.copyWith(
              imageBytes: imageBytes,
            ),
          ),
        ),
      );
    });

    on<GetImageFromGalleryEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
        ),
      );
      final getImage = await getImageFromGallery();
      getImage.fold(
        () => emit(
          state.copyWith(
            status: LoadStatus.succeed,
          ),
        ), // 處理使用者取消操作的情況
        (imageBytes) => emit(
          state.copyWith(
            status: LoadStatus.succeed,
            menuItem: state.menuItem.copyWith(
              imageBytes: imageBytes,
            ),
          ),
        ),
      );
    });

    on<AddMenuItemEvent>((event, emit) {
      final updatedList = List.of(state.menuItemList); // 複製原始list
      updatedList.add(
        state.menuItem,
      );
      emit(state.copyWith(menuItemList: updatedList));
    });

    on<EditMenuItemEvent>((event, emit) {
      final updatedList = List.of(state.menuItemList); // 複製原始list
      final int indexToEdit = event.index;
      if (indexToEdit >= 0 && indexToEdit < updatedList.length) {
        updatedList[indexToEdit] = state.menuItem;
        emit(
          state.copyWith(
            menuItemList: updatedList,
          ),
        );
      } else {
        log('MenuItem Error');
      }
    });

    on<RemoveMenuItemEvent>((event, emit) {
      final updatedList = List.of(state.menuItemList); // 複製原始list
      updatedList.remove(
        event.menuItem,
      );
      emit(state.copyWith(menuItemList: updatedList));
    });

    on<CreateMenuEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      final failureOption = await _menuApi.createMenu(
        state.menu.copyWith(
          menuItems: state.menuItemList,
        ),
        CacheHelper.getUserId(),
      );
      failureOption.fold(
        () => add(
          GetAllMenuEvent(
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

    // Get Menu
    on<GetAllMenuEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      final failureOrSuccess = await _menuApi.getAllByUserId(
        event.languageId,
        CacheHelper.getUserId(),
      );
      failureOrSuccess.fold(
        (f) => emit(
          state.copyWith(
            status: LoadStatus.failed,
            errorMessage: f,
          ),
        ),
        (allMenu) => emit(
          state.copyWith(
            status: LoadStatus.succeed,
            getAllMenu: allMenu,
          ),
        ),
      );
    });

    on<GetMenuDetailEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
        ),
      );
      final failureOrSuccess = await _menuApi.getAllByMenuId(
        event.menuId,
        event.languageId,
        CacheHelper.getUserId(),
      );
      failureOrSuccess.fold(
        (f) => emit(
          state.copyWith(
            status: LoadStatus.failed,
          ),
        ),
        (menu) => emit(
          state.copyWith(
            menu: menu,
            status: LoadStatus.succeed,
          ),
        ),
      );
    });

    // Update Menu
    on<UpdateMenuEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      final failureOption = await _menuApi.updateMenu(
        state.menu.copyWith(
          menuItems: state.menuItemList,
        ),
        CacheHelper.getUserId(),
        event.menuId,
      );
      failureOption.fold(
        () => {
          add(
            GetAllMenuEvent(
              event.languageId,
            ),
          ),
          add(
            GetMenuDetailEvent(
              event.menuId,
              event.languageId,
            ),
          ),
        },
        (f) => emit(
          state.copyWith(
            status: LoadStatus.failed,
            errorMessage: f,
          ),
        ),
      );
    });

    // Delete Menu
    on<DeleteMenuEvent>((event, emit) async {
      emit(
        state.copyWith(
          isDeleted: false,
          errorMessage: '',
        ),
      );
      final failureOption = await _menuApi.deleteMenu(
        CacheHelper.getUserId(),
        event.menuId,
      );
      failureOption.fold(
        () => emit(
          state.copyWith(
            isDeleted: true,
          ),
        ),
        (f) => emit(
          state.copyWith(
            isDeleted: false,
            errorMessage: f,
          ),
        ),
      );
    });
  }
}
