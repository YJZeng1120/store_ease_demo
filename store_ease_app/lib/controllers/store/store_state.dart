part of 'store_bloc.dart';

class StoreState {
  StoreState({
    required this.store,
    required this.storeOpeningHoursList,
    required this.storeOpeningHours,
    required this.getAllStore,
    required this.isDeleted,
    required this.isEditing,
    required this.errorMessage,
    required this.status,
  });

  // Create store
  final Store store;
  final List<StoreOpeningHours> storeOpeningHoursList;
  final StoreOpeningHours storeOpeningHours;

  // Get Store
  final List<Store> getAllStore;

  // Delete Store
  final bool isDeleted;

  // Common
  final bool isEditing;
  final String errorMessage;
  final LoadStatus status;

  factory StoreState.initial() => StoreState(
        store: Store.empty(),
        storeOpeningHoursList: const <StoreOpeningHours>[],
        storeOpeningHours: StoreOpeningHours.empty(),
        getAllStore: const <Store>[],
        isDeleted: false,
        isEditing: false,
        errorMessage: '',
        status: LoadStatus.initial,
      );

  StoreState copyWith({
    Store? store,
    List<StoreOpeningHours>? storeOpeningHoursList,
    StoreOpeningHours? storeOpeningHours,
    List<Store>? getAllStore,
    bool? isDeleted,
    bool? isEditing,
    String? errorMessage,
    LoadStatus? status,
  }) {
    return StoreState(
      store: store ?? this.store,
      storeOpeningHoursList:
          storeOpeningHoursList ?? this.storeOpeningHoursList,
      storeOpeningHours: storeOpeningHours ?? this.storeOpeningHours,
      getAllStore: getAllStore ?? this.getAllStore,
      isDeleted: isDeleted ?? this.isDeleted,
      isEditing: isEditing ?? this.isEditing,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}
