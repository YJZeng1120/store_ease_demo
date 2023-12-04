import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/category/category_bloc.dart';
import '../../controllers/menu/menu_bloc.dart';
import '../../models/category.dart';
import '../../models/core/theme.dart';

Widget categoryTabBar(
  BuildContext context, {
  required List<Category> categoryList,
  required bool isMenuForm,
}) {
  MenuState menuState = context.read<MenuBloc>().state;
  return BlocBuilder<CategoryBloc, CategoryState>(
    builder: (context, state) {
      return TabBar(
        isScrollable: true,
        labelPadding: const EdgeInsets.symmetric(
          horizontal: AppPaddingSize.largeHorizontal,
        ),
        tabs: [
          ...categoryList.map((category) {
            // 比對Tab的Category是否有menuItem，如果有的話就不能在Tab刪除category
            final itemList = menuState.menuItemList
                .where((menuItem) => menuItem.categoryId == category.id)
                .toList();
            return Tab(
              child: isMenuForm
                  ? SizedBox(
                      child: Row(
                        children: [
                          if (itemList.isEmpty)
                            InkWell(
                              onTap: () {
                                BlocProvider.of<CategoryBloc>(context).add(
                                  RemoveCategoryEvent(
                                    category,
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.do_disturb_on_outlined,
                              ),
                            ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            category.title.toUpperCase(),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      child: Text(
                        category.title.toUpperCase(),
                        textAlign: TextAlign.center,
                      ),
                    ),
            );
          }),
        ],
      );
    },
  );
}
