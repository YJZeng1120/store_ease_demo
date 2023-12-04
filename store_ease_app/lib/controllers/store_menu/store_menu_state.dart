part of 'store_menu_bloc.dart';

class StoreMenuState {
  StoreMenuState({
    required this.selectedMenuId,
    required this.menu,
    required this.errorMessage,
    required this.status,
  });

  // Select Menu
  final String selectedMenuId;

  // Get Menu
  final Menu menu;

  // Common
  final String errorMessage;
  final LoadStatus status;

  factory StoreMenuState.initial() => StoreMenuState(
        selectedMenuId: '',
        menu: Menu.empty(),
        errorMessage: '',
        status: LoadStatus.initial,
      );

  StoreMenuState copyWith({
    String? selectedMenuId,
    Menu? menu,
    String? errorMessage,
    LoadStatus? status,
  }) {
    return StoreMenuState(
      selectedMenuId: selectedMenuId ?? this.selectedMenuId,
      menu: menu ?? this.menu,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}
