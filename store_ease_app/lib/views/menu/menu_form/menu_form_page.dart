import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../controllers/category/category_bloc.dart';
import '../../../controllers/menu/menu_bloc.dart';
import '../../../controllers/theme/theme_bloc.dart';
import '../../../models/core/theme.dart';
import '../../../models/core/validators.dart';
import '../../../models/enums/load_status_enum.dart';
import '../../../routes/app_router.dart';
import '../../common_widgets/custom_dialog.dart';
import '../../common_widgets/custom_divider.dart';
import '../../common_widgets/loading_overlay.dart';
import '../../common_widgets/page_layout.dart';
import '../../store/store_list/widgets/store_input.dart';
import 'widgets/menu_item_tab.dart';

class MenuFormPage extends StatelessWidget {
  const MenuFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MenuBloc, MenuState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            if (state.status == LoadStatus.succeed) {
              if (state.isEditing) {
                BlocProvider.of<CategoryBloc>(context).add(
                  FilteredCategoryListEvent(
                    state.menu.menuItems,
                  ),
                );
                Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.menuOverview);
              } else {
                Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.appBottomTabs);
              }
              LoadingOverlay.hide();
            } else if (state.status == LoadStatus.inProgress) {
              LoadingOverlay.show(context);
            } else if (state.status == LoadStatus.failed) {
              LoadingOverlay.hide();
              systemErrorDialog(context);
            }
          },
        ),
      ],
      child: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          final ThemeState themeState = context.read<ThemeBloc>().state;
          return PageLayout(
            horizontal: 0,
            topPadding: 0,
            appBarTitle: state.isEditing
                ? AppLocalizations.of(context)!.editMenu
                : AppLocalizations.of(context)!.addMenu,
            leading: backButton(
              context,
              previousRouteName: state.isEditing
                  ? AppRoutes.menuOverview
                  : AppRoutes.appBottomTabs,
            ),
            actions: [
              state.isEditing
                  ? IconButton(
                      onPressed: () => BlocProvider.of<MenuBloc>(context).add(
                        UpdateMenuEvent(
                          state.menu.menuId ?? '',
                          themeState.languageId,
                        ),
                      ),
                      icon: const Icon(
                        Icons.done,
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        if (menuValidator(context)) {
                          customDialog(context,
                              title: AppLocalizations.of(context)!
                                  .completeStoreDialogTitle,
                              contentWidget: Text(
                                AppLocalizations.of(context)!
                                    .completeMenuDialogContent,
                              ),
                              actions: [
                                dialogButton(
                                  context,
                                  buttonText: AppLocalizations.of(context)!
                                      .confirmButton,
                                  onPressed: () => Navigator.of(context).pop(),
                                )
                              ]);
                        } else {
                          BlocProvider.of<MenuBloc>(context).add(
                            CreateMenuEvent(
                              themeState.languageId,
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.add,
                      ),
                    ),
            ],
            body: Column(
              children: [
                const SizedBox(
                  height: AppPaddingSize.top,
                ),
                storeInput(
                  initialValue: state.isEditing ? state.menu.title : null,
                  title: AppLocalizations.of(context)!.menuTitle,
                  hintText: AppLocalizations.of(context)!.enterMenuTitle,
                  onChanged: (value) {
                    context.read<MenuBloc>().add(
                          UpdateMenuDataEvent(
                            state.menu.copyWith(
                              title: value,
                            ),
                          ),
                        );
                  },
                ),
                descriptionInput(
                  initialValue: state.isEditing ? state.menu.description : null,
                  title: AppLocalizations.of(context)!.menuDescription,
                  hintText: AppLocalizations.of(context)!.enterMenuDescription,
                  onChanged: (value) {
                    context.read<MenuBloc>().add(
                          UpdateMenuDataEvent(
                            state.menu.copyWith(
                              description: value,
                            ),
                          ),
                        );
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                customDivider(
                  thickness: 6,
                ),
                MenuItemTab(
                  itemCount: state.menuItemList.length,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
