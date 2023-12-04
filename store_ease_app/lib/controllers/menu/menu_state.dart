part of 'menu_bloc.dart';

class MenuState {
  MenuState({
    required this.menu,
    required this.menuItemList,
    required this.menuItem,
    required this.getAllMenu,
    required this.isDeleted,
    required this.isEditing,
    required this.isMenuItemEditing,
    required this.errorMessage,
    required this.status,
  });

  // Create Menu
  final Menu menu;
  final List<MenuItem> menuItemList;
  final MenuItem menuItem;

  // Get Menu
  final List<Menu> getAllMenu;

  // Delete Menu
  final bool isDeleted;

  // Common
  final bool isEditing;
  final bool isMenuItemEditing;
  final String errorMessage;
  final LoadStatus status;

  factory MenuState.initial() => MenuState(
        menu: Menu.empty(),
        menuItemList: const <MenuItem>[],
        menuItem: MenuItem.empty(),
        getAllMenu: const <Menu>[],
        isDeleted: false,
        isEditing: false,
        isMenuItemEditing: false,
        errorMessage: '',
        status: LoadStatus.initial,
      );

  MenuState copyWith({
    Menu? menu,
    List<MenuItem>? menuItemList,
    MenuItem? menuItem,
    List<Menu>? getAllMenu,
    bool? isDeleted,
    bool? isEditing,
    bool? isMenuItemEditing,
    String? errorMessage,
    LoadStatus? status,
  }) {
    return MenuState(
      menu: menu ?? this.menu,
      menuItemList: menuItemList ?? this.menuItemList,
      menuItem: menuItem ?? this.menuItem,
      getAllMenu: getAllMenu ?? this.getAllMenu,
      isDeleted: isDeleted ?? this.isDeleted,
      isEditing: isEditing ?? this.isEditing,
      isMenuItemEditing: isMenuItemEditing ?? this.isMenuItemEditing,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}
