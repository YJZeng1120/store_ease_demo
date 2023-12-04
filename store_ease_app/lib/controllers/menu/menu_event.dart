// import '../../models/menu.dart';
part of 'menu_bloc.dart';

abstract class MenuEvent {
  const MenuEvent();
}

class MenuInitialEvent extends MenuEvent {
  const MenuInitialEvent(this.menu);
  final Menu menu;
}

class MenuItemInitialEvent extends MenuEvent {
  const MenuItemInitialEvent(
    this.menuItem,
    this.isEditing,
  );
  final MenuItem menuItem;
  final bool isEditing;
}

// Create Menu
class UpdateMenuDataEvent extends MenuEvent {
  const UpdateMenuDataEvent(
    this.menu,
  );
  final Menu menu;
}

class CreateMenuEvent extends MenuEvent {
  const CreateMenuEvent(
    this.languageId,
  );
  final int languageId;
}

class UpdateMenuItemDataEvent extends MenuEvent {
  const UpdateMenuItemDataEvent(this.menuItem);
  final MenuItem menuItem;
}

class AddMenuItemEvent extends MenuEvent {
  const AddMenuItemEvent();
}

class EditMenuItemEvent extends MenuEvent {
  const EditMenuItemEvent(this.index);
  final int index;
}

class RemoveMenuItemEvent extends MenuEvent {
  const RemoveMenuItemEvent(this.menuItem);
  final MenuItem menuItem;
}

class GetImageFromCameraEvent extends MenuEvent {
  const GetImageFromCameraEvent();
}

class GetImageFromGalleryEvent extends MenuEvent {
  const GetImageFromGalleryEvent();
}

// Get Menu
class GetAllMenuEvent extends MenuEvent {
  const GetAllMenuEvent(this.languageId);
  final int languageId;
}

class GetMenuDetailEvent extends MenuEvent {
  const GetMenuDetailEvent(
    this.menuId,
    this.languageId,
  );
  final String menuId;
  final int languageId;
}

// Update Menu
class UpdateMenuEvent extends MenuEvent {
  const UpdateMenuEvent(
    this.menuId,
    this.languageId,
  );
  final String menuId;
  final int languageId;
}

// Delete Menu
class DeleteMenuEvent extends MenuEvent {
  const DeleteMenuEvent(
    this.menuId,
    this.languageId,
  );
  final String menuId;
  final int languageId;
}
