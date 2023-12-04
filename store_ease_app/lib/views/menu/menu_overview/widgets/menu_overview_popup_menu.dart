import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../controllers/account/account_bloc.dart';
import '../../../../controllers/category/category_bloc.dart';
import '../../../../controllers/menu/menu_bloc.dart';
import '../../../../controllers/theme/theme_bloc.dart';
import '../../../../controllers/user_watcher/user_watcher_bloc.dart';
import '../../../../models/enums/load_status_enum.dart';
import '../../../../routes/app_router.dart';
import '../../../common_widgets/custom_dialog.dart';
import '../../../common_widgets/custom_popup_menu.dart';
import '../../../common_widgets/loading_overlay.dart';

Widget menuOverviewPopupMenu(
  BuildContext context,
) {
  return BlocBuilder<MenuBloc, MenuState>(
    builder: (context, state) {
      CategoryState categoryState = context.read<CategoryBloc>().state;
      return customPopupMenu(
        itemBuilder: [
          customPopupItem(
            title: AppLocalizations.of(context)!.editMenu,
            icon: Icons.mode_edit_outlined,
            value: 1,
          ),
          customPopupItem(
            title: AppLocalizations.of(context)!.deleteMenu,
            icon: Icons.delete_outline,
            value: 2,
          ),
        ],
        onSelected: (value) {
          switch (value) {
            case 1:
              Navigator.of(context).pushReplacementNamed(AppRoutes.menuForm);
              BlocProvider.of<MenuBloc>(context).add(
                MenuInitialEvent(
                  state.menu,
                ),
              );
              BlocProvider.of<CategoryBloc>(context).add(
                CategoryListInitialEvent(
                  categoryState.filteredCategoryList,
                ),
              );
              break;
            case 2:
              showDialog(
                context: context,
                builder: (context) {
                  final MenuState menuState = context.read<MenuBloc>().state;
                  final ThemeState themeState = context.read<ThemeBloc>().state;
                  return MultiBlocListener(
                    listeners: [
                      BlocListener<UserWatcherBloc, UserWatcherState>(
                        listenWhen: (p, c) => p.deleteStatus != c.deleteStatus,
                        listener: (context, state) {
                          if (state.deleteStatus == LoadStatus.succeed) {
                            if (state.isDeleted) {
                              LoadingOverlay.show(context);
                              BlocProvider.of<MenuBloc>(context).add(
                                DeleteMenuEvent(
                                  menuState.menu.menuId ?? '',
                                  themeState.languageId,
                                ),
                              );
                            }
                          } else if (state.deleteStatus == LoadStatus.failed) {
                            LoadingOverlay.hide();
                          }
                        },
                      ),
                      BlocListener<MenuBloc, MenuState>(
                        listenWhen: (p, c) => p.isDeleted != c.isDeleted,
                        listener: (context, state) {
                          if (state.isDeleted) {
                            BlocProvider.of<MenuBloc>(context).add(
                              GetAllMenuEvent(
                                themeState.languageId,
                              ),
                            );
                          }
                        },
                      ),
                      BlocListener<MenuBloc, MenuState>(
                        listenWhen: (p, c) => p.status != c.status,
                        listener: (context, state) {
                          if (state.status == LoadStatus.succeed) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.appBottomTabs,
                              (route) => false,
                            );
                            LoadingOverlay.hide();
                          } else if (state.status == LoadStatus.failed) {
                            LoadingOverlay.hide();
                            systemErrorDialog(context);
                          }
                        },
                      ),
                    ],
                    child: BlocBuilder<UserWatcherBloc, UserWatcherState>(
                      builder: (context, state) {
                        final AccountState accountState =
                            context.read<AccountBloc>().state;
                        return customAlertDialog(context,
                            title: AppLocalizations.of(context)!
                                .deleteMenuDialogTitle,
                            contentWidget: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .deleteMenuDialogContent,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                confirmPasswordDialogWidget(
                                  context,
                                ),
                              ],
                            ),
                            actions: [
                              cancelDialogButton(
                                context,
                              ),
                              dialogButton(
                                context,
                                buttonText:
                                    AppLocalizations.of(context)!.delete,
                                onPressed: () {
                                  BlocProvider.of<UserWatcherBloc>(context).add(
                                    DeleteVerifyEvent(
                                      accountState.userInfo.emailAddress,
                                      state.password,
                                    ),
                                  );
                                },
                              ),
                            ]);
                      },
                    ),
                  );
                },
              ).then(
                (_) => BlocProvider.of<UserWatcherBloc>(context)
                    .add(const ResetErrorMessageEvent()),
              );
              break;
            default:
              {
                log("Invalid choice");
              }
              break;
          }
        },
      );
    },
  );
}
