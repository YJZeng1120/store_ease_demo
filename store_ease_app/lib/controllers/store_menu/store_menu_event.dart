part of 'store_menu_bloc.dart';

abstract class StoreMenuEvent {
  const StoreMenuEvent();
}

// Select StoreMenu
class CreateStoreMenuEvent extends StoreMenuEvent {
  const CreateStoreMenuEvent(
    this.storeId,
    this.languageId,
  );

  final String storeId;
  final int languageId;
}

class SelectedMenuIdEvent extends StoreMenuEvent {
  const SelectedMenuIdEvent(this.selectedMenuId);
  final String selectedMenuId;
}

// Get StoreMenu
class GetStoreMenuEvent extends StoreMenuEvent {
  const GetStoreMenuEvent(this.storeId, this.languageId);
  final String storeId;
  final int languageId;
}

// Update
class UpdateStoreMenuEvent extends StoreMenuEvent {
  const UpdateStoreMenuEvent(
    this.storeId,
    this.languageId,
  );
  final String storeId;
  final int languageId;
}
