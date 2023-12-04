import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../controllers/category/category_bloc.dart';
import '../../../controllers/menu/menu_bloc.dart';
import '../../../controllers/store/store_bloc.dart';
import '../../../controllers/store_menu/store_menu_bloc.dart';
import '../../../controllers/theme/theme_bloc.dart';
import '../../../models/core/api_error_message.dart';
import '../../../models/core/screen.dart';
import '../../../models/core/theme.dart';
import '../../../models/enums/load_status_enum.dart';
import '../../common_widgets/custom_dialog.dart';
import '../../common_widgets/loading_overlay.dart';

dynamic selectMenuDialog(
  BuildContext context,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return MultiBlocListener(
        listeners: [
          BlocListener<StoreMenuBloc, StoreMenuState>(
            listenWhen: (p, c) => p.status != c.status,
            listener: (context, state) {
              if (state.status == LoadStatus.succeed) {
                BlocProvider.of<CategoryBloc>(context).add(
                  FilteredCategoryListEvent(
                    state.menu.menuItems,
                  ),
                );
                LoadingOverlay.hide();
              } else if (state.status == LoadStatus.inProgress) {
                LoadingOverlay.show(context);
              } else if (state.status == LoadStatus.failed) {
                LoadingOverlay.hide();
                systemErrorDialog(context);
              }
            },
          ),
          BlocListener<CategoryBloc, CategoryState>(
            listenWhen: (p, c) => p.status != c.status,
            listener: (context, state) {
              if (state.status == LoadStatus.succeed) {
                Navigator.of(context).pop();
              } else if (state.status == LoadStatus.failed) {
                systemErrorDialog(context);
              }
            },
          ),
        ],
        child: BlocBuilder<StoreMenuBloc, StoreMenuState>(
          builder: (context, state) {
            final StoreState storeState = context.read<StoreBloc>().state;
            final MenuState menuState = context.read<MenuBloc>().state;
            final ThemeState themeState = context.read<ThemeBloc>().state;
            return menuState.getAllMenu.isEmpty
                ? customAlertDialog(
                    context,
                    title: AppLocalizations.of(context)!.menuNotFound,
                    contentWidget: Text(
                      AppLocalizations.of(context)!.menuNotFoundContent,
                    ),
                    actions: [
                      dialogButton(
                        context,
                        buttonText: AppLocalizations.of(context)!.confirmButton,
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  )
                : customAlertDialog(
                    context,
                    title: AppLocalizations.of(context)!.selectStoreMenu,
                    contentWidget: Container(
                      alignment: Alignment.centerLeft,
                      height: screenHeight / 3,
                      width: screenWidth / 2,
                      child: Scrollbar(
                        child: ListView.builder(
                          itemCount: menuState.getAllMenu.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                BlocProvider.of<StoreMenuBloc>(context).add(
                                  SelectedMenuIdEvent(
                                    menuState.getAllMenu[index].menuId ?? '',
                                  ),
                                );
                              },
                              behavior: HitTestBehavior.translucent,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppPaddingSize.smallVertical,
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      child: const Icon(
                                        Icons.menu_book,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      menuState.getAllMenu[index].title,
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.heading3(
                                        color: menuState
                                                    .getAllMenu[index].menuId ==
                                                state.selectedMenuId
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    actions: [
                      cancelDialogButton(
                        context,
                      ),
                      dialogButton(
                        context,
                        buttonText: AppLocalizations.of(context)!.confirmButton,
                        onPressed: state.errorMessage ==
                                ApiErrorMessage.storeMenuNotFound
                            ? () {
                                // 找不到ref菜單時，就會create ref菜單
                                BlocProvider.of<StoreMenuBloc>(context).add(
                                  CreateStoreMenuEvent(
                                    storeState.store.storeId ?? '',
                                    themeState.languageId,
                                  ),
                                );
                              }
                            : () {
                                BlocProvider.of<StoreMenuBloc>(context).add(
                                  UpdateStoreMenuEvent(
                                    storeState.store.storeId ?? '',
                                    themeState.languageId,
                                  ),
                                );
                              },
                      )
                    ],
                  );
          },
        ),
      );
    },
  );
}
