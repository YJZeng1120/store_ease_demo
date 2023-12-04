import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/core/cache_helper.dart';
import '../../models/enums/load_status_enum.dart';
import '../../models/menu.dart';
import '../../services/api_store_menu.dart';

part 'store_menu_event.dart';
part 'store_menu_state.dart';

class StoreMenuBloc extends Bloc<StoreMenuEvent, StoreMenuState> {
  final StoreMenuApi _storeMenuApi;
  StoreMenuBloc(
    this._storeMenuApi,
  ) : super(StoreMenuState.initial()) {
    _onEvent();
  }

  void _onEvent() {
    // Select Menu
    on<CreateStoreMenuEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      final failureOption = await _storeMenuApi.createReference(
        CacheHelper.getUserId(),
        event.storeId,
        state.selectedMenuId,
      );
      failureOption.fold(
        () {
          add(
            GetStoreMenuEvent(
              event.storeId,
              event.languageId,
            ),
          );
        },
        (f) => emit(
          state.copyWith(
            errorMessage: f,
            status: LoadStatus.failed,
          ),
        ),
      );
    });

    on<SelectedMenuIdEvent>((event, emit) {
      emit(state.copyWith(selectedMenuId: event.selectedMenuId));
    });

    // Get Menu
    on<GetStoreMenuEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );

      final failureOrSuccess = await _storeMenuApi.getMenuByStoreId(
        event.storeId,
        event.languageId,
      );
      failureOrSuccess.fold(
        (f) => emit(
          state.copyWith(
            status: LoadStatus.failed,
            errorMessage: f,
          ),
        ),
        (menu) => emit(
          state.copyWith(
            status: LoadStatus.succeed,
            menu: menu,
          ),
        ),
      );
    });

    // Update Menu
    on<UpdateStoreMenuEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      final failureOption = await _storeMenuApi.updateReference(
        CacheHelper.getUserId(),
        event.storeId,
        state.selectedMenuId,
      );
      failureOption.fold(
        () {
          add(
            GetStoreMenuEvent(
              event.storeId,
              event.languageId,
            ),
          );
        },
        (f) => emit(
          state.copyWith(
            errorMessage: f,
            status: LoadStatus.failed,
          ),
        ),
      );
    });
  }
}
