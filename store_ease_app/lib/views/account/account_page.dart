import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/account/account_bloc.dart';
import '../../controllers/auth_flow/verify/verify_bloc.dart';
import '../../controllers/notification/notification_bloc.dart';
import '../../controllers/user_watcher/user_watcher_bloc.dart';
import '../../models/enums/load_status_enum.dart';
import '../../routes/app_router.dart';
import '../common_widgets/custom_dialog.dart';
import '../common_widgets/custom_divider.dart';
import '../common_widgets/loading_overlay.dart';
import '../common_widgets/page_layout.dart';
import 'widgets/account_dialog.dart';
import 'widgets/account_item.dart';
import 'widgets/user_info_item.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserWatcherBloc, UserWatcherState>(
          listenWhen: (p, c) => p.authStatus != c.authStatus,
          listener: (context, state) {
            if (state.authStatus == LoadStatus.succeed) {
              if (state.loggedIn == false) {
                BlocProvider.of<NotificationBloc>(context).add(
                  const DeleteTokenEvent(),
                );
                // LoadingOverlay.hide();
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //   AppRoutes.auth,
                //   (route) => false,
                // );
              }
            } else if (state.authStatus == LoadStatus.failed) {
              LoadingOverlay.hide();
              systemErrorDialog(context);
            } else if (state.authStatus == LoadStatus.inProgress) {
              LoadingOverlay.show(context);
            }
          },
        ),
        BlocListener<UserWatcherBloc, UserWatcherState>(
          listenWhen: (p, c) => p.deleteStatus != c.deleteStatus,
          listener: (context, state) {
            if (state.deleteStatus == LoadStatus.succeed) {
              BlocProvider.of<NotificationBloc>(context).add(
                const DeleteTokenEvent(),
              );
              if (state.isDeleted) {
                LoadingOverlay.show(context);
                BlocProvider.of<VerifyBloc>(context)
                    .add(const ResetAuthProcessEvent()); // 重新產生token
                BlocProvider.of<UserWatcherBloc>(context)
                    .add(const DeleteUserEvent());
              }
            }
          },
        ),
        BlocListener<NotificationBloc, NotificationState>(
          listenWhen: (p, c) => p.deleteStatus != c.deleteStatus,
          listener: (context, state) {
            if (state.deleteStatus == LoadStatus.succeed) {
              print('logout');
              LoadingOverlay.hide();
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.auth,
                (route) => false,
              );
            }
          },
        )
      ],
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          return PageLayout(
            horizontal: 0,
            appBarTitle: AppLocalizations.of(context)!.accountTitle,
            body: Column(
              children: [
                emailInfoItem(),
                customDivider(),
                userInfoButton(),
                customDivider(),
                // 更改密碼
                accountItem(
                  icon: Icons.lock_person,
                  title: AppLocalizations.of(context)!.resetPasswordTitle,
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoutes.resetPassword);
                  },
                ),
                customDivider(),
                // 更改語言
                accountItem(
                  icon: Icons.language,
                  title: AppLocalizations.of(context)!.language,
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoutes.setLanguage);
                  },
                ),
                customDivider(
                  thickness: 6,
                ),
                // 登出按鈕
                accountButton(
                  title: AppLocalizations.of(context)!.logout,
                  onTap: () {
                    logoutDialog(context);
                  },
                ),
                customDivider(),
                // 刪除帳戶按鈕
                accountButton(
                  title: AppLocalizations.of(context)!.deleteAccount,
                  onTap: () {
                    deleteAccountDialog(context);
                  },
                ),
                customDivider(
                  thickness: 6,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
