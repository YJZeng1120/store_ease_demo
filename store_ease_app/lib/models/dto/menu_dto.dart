import 'dart:convert';
import 'dart:typed_data';

import '../menu.dart';

class MenuDto {
  MenuDto({
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
  final List<MenuItemDto> menuItems;

  factory MenuDto.fromModel(
    Menu menu,
  ) {
    return MenuDto(
      storeId: menu.storeId,
      title: menu.title,
      description: menu.description,
      menuItems: menu.menuItems
          .map(
            (menuItem) => MenuItemDto.fromModel(menuItem),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "storeId": storeId,
      "title": title,
      "description": description,
      "menuItems": menuItems
          .map(
            (dto) => dto.toJson(),
          )
          .toList()
    };
  }

  factory MenuDto.fromJson(
    Map<String, dynamic> map,
  ) {
    List menuItems = map['menuItems'];
    return MenuDto(
      menuId: map['id'],
      storeId: map['storeId'] ?? '', //storeId?
      title: map['title'],
      description: map['description'],
      menuItems: menuItems.map((e) => MenuItemDto.fromJson(e)).toList(),
    );
  }

  Menu toModel() {
    return Menu(
      menuId: menuId,
      storeId: storeId,
      title: title,
      description: description,
      menuItems: menuItems.map((dto) => dto.toModel()).toList(),
    );
  }
}

class MenuItemDto {
  MenuItemDto({
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
  final dynamic imageBytes;

  factory MenuItemDto.fromModel(
    MenuItem menuItem,
  ) {
    return MenuItemDto(
      title: menuItem.title,
      description: menuItem.description,
      quantity: menuItem.quantity,
      price: menuItem.price,
      categoryId: menuItem.categoryId,
      imageBytes: menuItem.imageBytes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "quantity": quantity,
      "price": price,
      "categoryId": categoryId,
      "imageBytes": imageBytes,
    };
  }

  factory MenuItemDto.fromJson(
    Map<String, dynamic> map,
  ) {
    return MenuItemDto(
      menuItemId: map['id'],
      title: map['title'],
      description: map['description'],
      quantity: map['quantity'],
      price: map['price'],
      categoryId: map['category']['id'],
      imageBytes: map['imageBytes'],
    );
  }

  MenuItem toModel() {
    Uint8List decodeBase64Image =
        base64Decode(imageBytes); // 將base64轉換為Uint8List

    return MenuItem(
      menuItemId: menuItemId,
      title: title,
      description: description,
      quantity: quantity,
      price: price,
      categoryId: categoryId,
      imageBytes: decodeBase64Image,
    );
  }
}
