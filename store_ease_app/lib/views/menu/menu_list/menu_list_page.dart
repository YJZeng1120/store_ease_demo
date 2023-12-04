import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../controllers/category/category_bloc.dart';
import '../../../controllers/menu/menu_bloc.dart';
import '../../../models/category.dart';
import '../../../models/core/theme.dart';
import '../../../models/enums/load_status_enum.dart';
import '../../../models/menu.dart';
import '../../../routes/app_router.dart';
import '../../common_widgets/custom_button.dart';
import '../../common_widgets/custom_dialog.dart';
import '../../common_widgets/empty_data_widget.dart';
import '../../common_widgets/loading_overlay.dart';
import '../../common_widgets/page_layout.dart';
import 'widgets/menu_card.dart';

class MenuListPage extends StatelessWidget {
  const MenuListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MenuBloc, MenuState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == LoadStatus.succeed) {
          LoadingOverlay.hide();
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.menuOverview,
          );
        } else if (state.status == LoadStatus.failed) {
          LoadingOverlay.hide();
          systemErrorDialog(context);
        } else if (state.status == LoadStatus.inProgress) {
          LoadingOverlay.show(context);
        }
      },
      child: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          return PageLayout(
            appBarTitle: AppLocalizations.of(context)!.menu,
            horizontal: 0,
            body: state.getAllMenu.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPaddingSize.largeHorizontal,
                    ),
                    child: emptyDataWidget(
                      context,
                      title: AppLocalizations.of(context)!.menuEmpty,
                      content: AppLocalizations.of(context)!.menuEmptyContent,
                      buttonName: AppLocalizations.of(context)!.addMenu,
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.menuForm);
                        BlocProvider.of<MenuBloc>(context).add(
                          MenuInitialEvent(
                            Menu.empty(
                              storeId: state.menu.storeId, // 保留storeId
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      pageSubTitle(
                        AppLocalizations.of(context)!.menuList,
                        horizontal: AppPaddingSize.largeHorizontal,
                        button: smallButton(
                          context,
                          title: AppLocalizations.of(context)!.addMenu,
                          icon: Icons.post_add_outlined,
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(AppRoutes.menuForm);
                            BlocProvider.of<MenuBloc>(context).add(
                              MenuInitialEvent(
                                Menu.empty(
                                  storeId: state.menu.storeId, // 保留storeId
                                ),
                              ),
                            );
                            BlocProvider.of<CategoryBloc>(context).add(
                              const CategoryListInitialEvent(<Category>[]),
                            );
                          },
                        ),
                      ),
                      ...state.getAllMenu.map((menu) {
                        return menuCard(
                          context,
                          menu: menu,
                        );
                      }),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
