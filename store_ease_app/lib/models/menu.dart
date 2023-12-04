import 'dart:typed_data';

class Menu {
  const Menu({
    this.menuId,
    required this.storeId,
    required this.title,
    required this.description,
    required this.menuItems,
  });
  final String? menuId;
  final String storeId;
  final String title;
  final String description;
  final List<MenuItem> menuItems;

  factory Menu.empty({
    String storeId = '',
  }) {
    return Menu(
      menuId: null,
      storeId: storeId,
      title: '',
      description: '',
      menuItems: <MenuItem>[],
    );
  }

  Menu copyWith({
    String? menuId,
    String? storeId,
    String? title,
    String? description,
    List<MenuItem>? menuItems,
  }) {
    return Menu(
      menuId: menuId ?? this.menuId,
      storeId: storeId ?? this.storeId,
      title: title ?? this.title,
      description: description ?? this.description,
      menuItems: menuItems ?? this.menuItems,
    );
  }
}

class MenuItem {
  MenuItem({
    this.menuItemId,
    required this.title,
    required this.description,
    required this.quantity,
    required this.price,
    required this.categoryId,
    required this.imageBytes,
  });
  final int? menuItemId;
  final String title;
  final String description;
  final int quantity;
  final int price;
  final int categoryId;
  final Uint8List imageBytes;

  factory MenuItem.empty({
    int categoryId = 1,
  }) {
    return MenuItem(
      menuItemId: null,
      title: '',
      description: '',
      quantity: 0,
      price: 0,
      categoryId: categoryId,
      imageBytes: Uint8List(0),
    );
  }

  MenuItem copyWith({
    int? menuItemId,
    String? title,
    String? description,
    int? quantity,
    int? price,
    int? categoryId,
    Uint8List? imageBytes,
  }) {
    return MenuItem(
      menuItemId: menuItemId ?? this.menuItemId,
      title: title ?? this.title,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
      imageBytes: imageBytes ?? this.imageBytes,
    );
  }
}
