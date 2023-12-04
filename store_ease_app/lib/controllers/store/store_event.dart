part of 'store_bloc.dart';

abstract class StoreEvent {
  const StoreEvent();
}

class StoreInitialEvent extends StoreEvent {
  const StoreInitialEvent(this.store);
  final Store store;
}

// Create store
class UpdateStoreDataEvent extends StoreEvent {
  const UpdateStoreDataEvent(this.store);
  final Store store;
}

class CreateStoreEvent extends StoreEvent {
  const CreateStoreEvent();
}

class AddStoreOpeningHoursEvent extends StoreEvent {
  const AddStoreOpeningHoursEvent();
}

class UpdateStoreOpeningHoursDataEvent extends StoreEvent {
  const UpdateStoreOpeningHoursDataEvent(this.storeOpeningHours);
  final StoreOpeningHours storeOpeningHours;
}

class RemoveStoreOpeningHoursEvent extends StoreEvent {
  const RemoveStoreOpeningHoursEvent(this.storeOpeningHours);
  final StoreOpeningHours storeOpeningHours;
}

// Get Store
class GetAllStoreEvent extends StoreEvent {
  const GetAllStoreEvent();
}

class GetStoreDetailEvent extends StoreEvent {
  const GetStoreDetailEvent(this.storeId);
  final String storeId;
}

// Update Store
class UpdateStoreEvent extends StoreEvent {
  const UpdateStoreEvent(this.storeId);
  final String storeId;
}

class IsBreakStoreEvent extends StoreEvent {
  const IsBreakStoreEvent(
    this.storeId,
    this.isBreak,
  );

  final String storeId;
  final bool isBreak;
}

// Delete Store
class DeleteStoreEvent extends StoreEvent {
  const DeleteStoreEvent(this.storeId);
  final String storeId;
}
