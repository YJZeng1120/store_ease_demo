import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../controllers/account/account_bloc.dart';
import '../../../controllers/user_watcher/user_watcher_bloc.dart';
import '../../common_widgets/custom_dialog.dart';
import '../../common_widgets/tap_out_dismiss_keyboard.dart';

dynamic logoutDialog(BuildContext context) {
  return customDialog(
    context,
    title: AppLocalizations.of(context)!.logoutDialogTitle,
    contentWidget: Text(AppLocalizations.of(context)!.logoutDialogContent),
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    actions: [
      cancelDialogButton(
        context,
      ),
      dialogButton(
        context,
        buttonText: AppLocalizations.of(context)!.logout,
        onPressed: () => BlocProvider.of<UserWatcherBloc>(context).add(
          const LogoutEvent(),
        ),
      ),
    ],
  );
}

dynamic deleteAccountDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => BlocBuilder<UserWatcherBloc, UserWatcherState>(
      builder: (context, state) {
        final AccountState accountState = context.read<AccountBloc>().state;
        return TapOutDismissKeyboard(
          child: customAlertDialog(
            context,
            insetPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 40,
            ),
            title: AppLocalizations.of(context)!.deleteAccountDialogTitle,
            contentWidget: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.deleteAccountDialogContent,
                ),
                const SizedBox(
                  height: 30,
                ),
                confirmPasswordDialogWidget(
                  context,
                ),
              ],
            ),
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            ],
          ),
        );
      },
    ),
  ).then(
    (_) => BlocProvider.of<UserWatcherBloc>(context)
        .add(const ResetErrorMessageEvent()),
  );
}
