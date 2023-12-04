import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/core/cache_helper.dart';
import '../../models/enums/load_status_enum.dart';
import '../../models/store.dart';
import '../../services/api_store.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final StoreApi _storeApi;
  StoreBloc(
    this._storeApi,
  ) : super(StoreState.initial()) {
    _onEvent();
  }
  void _onEvent() {
    on<StoreInitialEvent>((event, emit) {
      final bool isEditing = event.store.storeId != null;
      emit(
        state.copyWith(
          isEditing: isEditing,
          store: event.store,
          storeOpeningHoursList: event.store.storeOpeningHoursList,
          storeOpeningHours: StoreOpeningHours.empty(), // 開啟BottomSheet時，值歸零
        ),
      );
    });

    // Create store
    on<UpdateStoreDataEvent>((event, emit) {
      emit(state.copyWith(store: event.store));
    });

    on<CreateStoreEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      final failureOption = await _storeApi.createStore(
        state.store.copyWith(
          isBreak: false, // 創建時isBreak永遠為false
          storeOpeningHoursList: state.storeOpeningHoursList,
        ),
        CacheHelper.getUserId(),
      );
      failureOption.fold(
        () => add(
          const GetAllStoreEvent(),
        ),
        (f) => emit(
          state.copyWith(
            status: LoadStatus.failed,
            errorMessage: f,
          ),
        ),
      );
    });

    on<AddStoreOpeningHoursEvent>((event, emit) {
      final updatedList = List.of(state.storeOpeningHoursList); // 複製原始list
      updatedList.add(
        state.storeOpeningHours,
      ); // 新增element
      emit(state.copyWith(storeOpeningHoursList: updatedList));
    });

    on<UpdateStoreOpeningHoursDataEvent>((event, emit) {
      emit(state.copyWith(storeOpeningHours: event.storeOpeningHours));
    });

    on<RemoveStoreOpeningHoursEvent>((event, emit) {
      final updatedList = List.of(state.storeOpeningHoursList); // 複製原始list
      updatedList.remove(
        event.storeOpeningHours,
      );
      emit(state.copyWith(storeOpeningHoursList: updatedList));
    });

    // Get Store
    on<GetAllStoreEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      final failureOrSuccess = await _storeApi.getAllByUserId(
        CacheHelper.getUserId(),
      );
      failureOrSuccess.fold(
        (f) => emit(
          state.copyWith(
            status: LoadStatus.failed,
            errorMessage: f,
          ),
        ),
        (allStore) => emit(
          state.copyWith(
            getAllStore: allStore,
            status: LoadStatus.succeed,
          ),
        ),
      );
    });

    on<GetStoreDetailEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
        ),
      );
      final failureOrSuccess = await _storeApi.getByStoreId(
        CacheHelper.getUserId(),
        event.storeId,
      );
      failureOrSuccess.fold(
        (f) => emit(
          state.copyWith(
            status: LoadStatus.failed,
          ),
        ),
        (store) => emit(
          state.copyWith(
            store: store,
            status: LoadStatus.succeed,
          ),
        ),
      );
    });

    // Update Store
    on<UpdateStoreEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      final failureOption = await _storeApi.updateStore(
        state.store.copyWith(
          storeOpeningHoursList: state.storeOpeningHoursList,
        ),
        CacheHelper.getUserId(),
        event.storeId,
      );
      failureOption.fold(
        () {
          add(
            const GetAllStoreEvent(),
          );
          add(
            GetStoreDetailEvent(event.storeId),
          );
        },
        (f) => emit(
          state.copyWith(
            status: LoadStatus.failed,
            errorMessage: f,
          ),
        ),
      );
    });

    on<IsBreakStoreEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      final failureOption = await _storeApi.updateStore(
        state.store.copyWith(
          isBreak: event.isBreak,
        ),
        CacheHelper.getUserId(),
        event.storeId,
      );
      failureOption.fold(
        () {
          add(
            GetStoreDetailEvent(event.storeId),
          );
        },
        (f) => emit(
          state.copyWith(
            status: LoadStatus.failed,
            errorMessage: f,
          ),
        ),
      );
    });

    // Delete Store
    on<DeleteStoreEvent>((event, emit) async {
      emit(
        state.copyWith(
          isDeleted: false,
          errorMessage: '',
        ),
      );
      final failureOption = await _storeApi.deleteStore(
        CacheHelper.getUserId(),
        event.storeId,
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
