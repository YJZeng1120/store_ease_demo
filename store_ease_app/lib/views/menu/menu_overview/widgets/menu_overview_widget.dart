import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../models/category.dart';
import '../../../../models/core/screen.dart';
import '../../../../models/core/theme.dart';
import '../../../../models/menu.dart';
import '../../../common_widgets/category_tab_bar.dart';
import '../../../common_widgets/custom_divider.dart';
import '../../../common_widgets/empty_data_widget.dart';
import '../../../common_widgets/page_layout.dart';
import 'menu_list_tile.dart';

Widget menuOverviewWidget(
  BuildContext context, {
  required List<Category> categoryList,
  required Menu menu,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(
        height: AppPaddingSize.top,
      ),
      pageSubTitle(
        menu.title,
        horizontal: AppPaddingSize.largeHorizontal,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPaddingSize.largeHorizontal,
        ),
        child: Text(
          menu.description,
          style: AppTextStyle.text(),
        ),
      ),
      const SizedBox(
        height: 12,
      ),
      customDivider(
        thickness: 6,
      ),
      categoryList.isEmpty
          ? Padding(
              padding: EdgeInsets.only(
                top: screenHeight / 4,
              ),
              child: noDataWidget(
                icon: Icons.edit_note,
                title: AppLocalizations.of(context)!.noMealData,
              ),
            )
          : DefaultTabController(
              length: categoryList.length,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  categoryTabBar(
                    context,
                    categoryList: categoryList,
                    isMenuForm: false,
                  ),
                  SizedBox(
                    width: screenWidth,
                    height: menu.menuItems.isEmpty
                        ? 130
                        : menu.menuItems.length * 130,
                    child: TabBarView(
                      children: [
                        ...categoryList.map(
                          (category) {
                            List<MenuItem> filterMenuItemList = menu.menuItems
                                .where(
                                  (menu) => menu.categoryId == category.id,
                                )
                                .toList();
                            return ListView.builder(
                              physics:
                                  const NeverScrollableScrollPhysics(), // 不干擾主頁的SingleChildScrollView的滾動事件
                              itemCount: filterMenuItemList.length,
                              itemBuilder: (context, index) => menuListTile(
                                context,
                                menuItem: filterMenuItemList[index],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    ],
  );
}
