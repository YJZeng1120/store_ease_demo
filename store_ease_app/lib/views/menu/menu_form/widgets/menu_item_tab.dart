import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../controllers/category/category_bloc.dart';
import '../../../../controllers/theme/theme_bloc.dart';
import '../../../../models/core/screen.dart';
import '../../../../models/core/theme.dart';
import '../../../common_widgets/category_tab_bar.dart';
import 'category_dialog.dart';
import 'menu_item_grid_view.dart';

class MenuItemTab extends StatelessWidget {
  const MenuItemTab({
    super.key,
    required this.itemCount,
  });
  final int crossAxisCount = 3;
  final int itemCount;
  @override
  Widget build(BuildContext context) {
    final double itemHeight = screenWidth / crossAxisCount;
    final ThemeState themeState = context.read<ThemeBloc>().state;
    BlocProvider.of<CategoryBloc>(context).add(
      GetCategoryEvent(themeState.languageId),
    );
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return DefaultTabController(
          length: state.selectCategoryList.length,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      categoryTabBar(
                        context,
                        categoryList: state.selectCategoryList,
                        isMenuForm: true,
                      ),
                      InkWell(
                        onTap: () {
                          categoryDialog(context);
                          BlocProvider.of<CategoryBloc>(context).add(
                            SelectCategoryEvent(
                              state.allCategoryList.first,
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(
                          AppBorderRadius.large,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppPaddingSize.largeHorizontal,
                            vertical: AppPaddingSize.compactVertical,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.add_circle_outline,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                AppLocalizations.of(context)!.addCategory,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: itemHeight + itemHeight * (itemCount ~/ crossAxisCount),
                child: TabBarView(
                  children: [
                    ...state.selectCategoryList.map(
                      (category) => Tab(
                        child: buildCategoryGridView(
                          category,
                          crossAxisCount: crossAxisCount,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
