import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../controllers/menu/menu_bloc.dart';
import '../../../../functions/image_utility.dart';
import '../../../../models/category.dart';
import '../../../../models/core/theme.dart';
import '../../../../models/menu.dart';
import 'menu_item_bottom_sheet.dart';

Widget buildCategoryGridView(
  Category category, {
  required int crossAxisCount,
}) {
  return BlocBuilder<MenuBloc, MenuState>(
    builder: (context, state) {
      return GridView(
        physics:
            const NeverScrollableScrollPhysics(), // 不干擾主頁的SingleChildScrollView的滾動事件
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 1,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
        ),
        children: [
          ...state.menuItemList.asMap().entries.where((entry) {
            // 使用asMap()獲取index
            final menuItem = entry.value;
            return menuItem.categoryId == category.id;
          }).map((entry) {
            final index = entry.key;
            final filteredMenuItem = entry.value;
            return buildMenuItemStack(context, filteredMenuItem, () {
              menuItemBottomSheet(
                context,
                index: index,
              );
              context.read<MenuBloc>().add(
                    MenuItemInitialEvent(filteredMenuItem, true),
                  );
            });
          }),
          IconButton(
            onPressed: () {
              menuItemBottomSheet(
                context,
              );
              context.read<MenuBloc>().add(
                    MenuItemInitialEvent(
                      MenuItem.empty(
                        categoryId: category.id ?? 0,
                      ),
                      false,
                    ),
                  );
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      );
    },
  );
}

Widget buildMenuItemStack(
  BuildContext context,
  MenuItem filteredMenuItem,
  void Function()? onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Stack(
      children: [
        Image.memory(
          filteredMenuItem.imageBytes.isEmpty
              ? ImageHelper.imageBytesProxy
              : filteredMenuItem.imageBytes,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.black54,
            padding: const EdgeInsets.symmetric(
              vertical: AppPaddingSize.tinyVertical,
              horizontal: AppPaddingSize.smallHorizontal,
            ),
            child: Column(
              children: [
                Text(
                  filteredMenuItem.title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.text(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  '\$ ${filteredMenuItem.price}',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.text(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
