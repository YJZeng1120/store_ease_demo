import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../controllers/account/account_bloc.dart';
import '../../../../controllers/store/store_bloc.dart';
import '../../../../controllers/user_watcher/user_watcher_bloc.dart';
import '../../../../routes/app_router.dart';
import '../../../common_widgets/custom_dialog.dart';
import '../../../common_widgets/custom_popup_menu.dart';
import '../../../common_widgets/tap_out_dismiss_keyboard.dart';

Widget storeOverviewPopupMenu(
  BuildContext context,
) {
  return BlocBuilder<StoreBloc, StoreState>(
    builder: (context, state) {
      return customPopupMenu(
        itemBuilder: [
          customPopupItem(
            title: AppLocalizations.of(context)!.editStore,
            icon: Icons.mode_edit_outlined,
            value: 1,
          ),
          customPopupItem(
            title: AppLocalizations.of(context)!.deleteStore,
            icon: Icons.delete_outline,
            value: 2,
          ),
        ],
        onSelected: (value) {
          switch (value) {
            case 1:
              Navigator.of(context).pushReplacementNamed(AppRoutes.storeForm);
              BlocProvider.of<StoreBloc>(context)
                  .add(StoreInitialEvent(state.store));
              break;
            case 2:
              showDialog(
                context: context,
                builder: (context) =>
                    BlocBuilder<UserWatcherBloc, UserWatcherState>(
                  builder: (context, state) {
                    final AccountState accountState =
                        context.read<AccountBloc>().state;
                    return TapOutDismissKeyboard(
                      child: customAlertDialog(context,
                          title: AppLocalizations.of(context)!
                              .deleteStoreDialogTitle,
                          contentWidget: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .deleteStoreDialogContent,
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
                              buttonText: AppLocalizations.of(context)!.delete,
                              onPressed: () {
                                BlocProvider.of<UserWatcherBloc>(context).add(
                                  DeleteVerifyEvent(
                                    accountState.userInfo.emailAddress,
                                    state.password,
                                  ),
                                );
                              },
                            ),
                          ]),
                    );
                  },
                ),
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
