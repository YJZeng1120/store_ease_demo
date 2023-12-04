import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/auth_flow/auth/auth_bloc.dart';
import '../../controllers/auth_flow/forgot_password/forgot_password_bloc.dart';
import '../../controllers/user_watcher/user_watcher_bloc.dart';
import '../../models/core/cache_helper.dart';
import '../../models/enums/load_status_enum.dart';
import '../../routes/app_router.dart';
import '../../services/api_user.dart';
import '../common_widgets/custom_button.dart';
import '../common_widgets/custom_dialog.dart';
import '../common_widgets/loading_overlay.dart';
import '../common_widgets/page_layout.dart';
import 'widgets/auth_page_layout.dart';
import 'widgets/auth_text_input.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({super.key});
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AuthState authState = context.read<AuthBloc>().state;
    final UserWatcherState userWatcherState =
        context.read<UserWatcherBloc>().state;
    return BlocProvider(
      create: (context) => ForgotPasswordBloc(
        context.read<UserApi>(),
      ),
      child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status == LoadStatus.succeed) {
            Navigator.of(context).pushReplacementNamed(
              userWatcherState.loggedIn
                  ? AppRoutes.appBottomTabs
                  : AppRoutes.login,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.resetPasswordSucceed,
                ),
              ),
            );
            LoadingOverlay.hide();
          } else if (state.status == LoadStatus.inProgress) {
            LoadingOverlay.show(context);
          } else if (state.status == LoadStatus.failed) {
            LoadingOverlay.hide();
            systemErrorDialog(context); // 目前只有系統錯誤
          }
        },
        child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
          builder: (context, state) {
            return AuthPageLayout(
              form: _form,
              appBarTitle: userWatcherState.loggedIn
                  ? AppLocalizations.of(context)!.settings
                  : AppLocalizations.of(context)!.appTitle,
              leading: backButton(
                context,
                previousRouteName: userWatcherState.loggedIn
                    ? AppRoutes.appBottomTabs
                    : AppRoutes.resetPasswordVerify,
              ),
              headingTitle: AppLocalizations.of(context)!.resetPasswordTitle,
              content: Column(
                children: [
                  passwordConfirmWidget(
                    context,
                    password: state.password,
                    isPasswordVisible: state.isPasswordVisible,
                    isConfirmPasswordVisible: state.isConfirmPasswordVisible,
                    onChangedPassword: (value) =>
                        BlocProvider.of<ForgotPasswordBloc>(context).add(
                      PasswordEvent(value),
                    ),
                    onPressedPassword: () =>
                        BlocProvider.of<ForgotPasswordBloc>(context).add(
                      const PasswordVisibleEvent(),
                    ),
                    onChangedConfirmPassword: (value) =>
                        BlocProvider.of<ForgotPasswordBloc>(context).add(
                      ConfirmPasswordEvent(value),
                    ),
                    onPressedConfirmPassword: () =>
                        BlocProvider.of<ForgotPasswordBloc>(context).add(
                      const ConfirmPasswordVisibleEvent(),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  customButton(
                    context,
                    buttonName: AppLocalizations.of(context)!.confirmButton,
                    onPressed: () {
                      if (_form.currentState!.validate()) {
                        BlocProvider.of<ForgotPasswordBloc>(context).add(
                          ResetPasswordEvent(
                            userWatcherState.loggedIn
                                ? CacheHelper.getUserId()
                                : authState.userId,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
