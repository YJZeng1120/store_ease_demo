import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/account/account_bloc.dart';
import '../../controllers/auth_flow/auth/auth_bloc.dart';
import '../../controllers/auth_flow/login/login_bloc.dart';
import '../../controllers/auth_flow/verify/verify_bloc.dart';
import '../../controllers/bottom_tabs/bottom_tabs_bloc.dart';
import '../../controllers/category/category_bloc.dart';
import '../../controllers/menu/menu_bloc.dart';
import '../../controllers/notification/notification_bloc.dart';
import '../../controllers/store/store_bloc.dart';
import '../../controllers/theme/theme_bloc.dart';
import '../../controllers/user_watcher/user_watcher_bloc.dart';
import '../../models/core/theme.dart';
import '../../models/core/validators.dart';
import '../../models/enums/load_status_enum.dart';
import '../../routes/app_router.dart';
import '../../services/api_firebase.dart';
import '../../services/api_user.dart';
import '../common_widgets/custom_button.dart';
import '../common_widgets/loading_overlay.dart';
import '../common_widgets/page_layout.dart';
import 'widgets/auth_page_layout.dart';
import 'widgets/auth_text_input.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController passwordController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ThemeState themeState = context.read<ThemeBloc>().state;
    final AuthState authState = context.read<AuthBloc>().state;
    final UserWatcherState userWatcherState =
        context.read<UserWatcherBloc>().state;
    return BlocProvider(
      create: (context) => LoginBloc(
        context.read<FirebaseApi>(),
        context.read<UserApi>(),
      ),
      child: MultiBlocListener(
        listeners: [
          BlocListener<LoginBloc, LoginState>(
            listenWhen: (p, c) => p.status != c.status,
            listener: (context, state) {
              if (state.status == LoadStatus.succeed) {
                BlocProvider.of<StoreBloc>(context).add(
                  const GetAllStoreEvent(),
                );
                BlocProvider.of<MenuBloc>(context).add(
                  GetAllMenuEvent(
                    themeState.languageId,
                  ),
                );
                BlocProvider.of<BottomTabsBloc>(context).add(
                  const AppTabIndexEvent(0),
                );
                if (userWatcherState.loggedIn == false) {
                  //Login時，抓取 _firebaseApi.getCurrentUser資訊
                  BlocProvider.of<UserWatcherBloc>(context).add(
                    const CacheLoginInfoEvent(),
                  );
                }
              } else if (state.status == LoadStatus.inProgress) {
                LoadingOverlay.show(context);
              } else if (state.status == LoadStatus.failed) {
                if (state.errorMessage == 'wrong-password') {
                  LoadingOverlay.hide();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.passwordError,
                      ),
                    ),
                  );
                } else if (state.errorMessage == 'too-many-requests') {
                  LoadingOverlay.hide();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.passwordErrorTooMany,
                      ),
                    ),
                  );
                } else {
                  LoadingOverlay.hide();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          AppLocalizations.of(context)!.systemErrorContent),
                    ),
                  );
                }
              }
            },
          ),
          BlocListener<MenuBloc, MenuState>(
            listenWhen: (p, c) => p.status != c.status,
            listener: (context, state) {
              if (state.status == LoadStatus.succeed) {
                BlocProvider.of<AccountBloc>(context).add(
                  const GetUserInfoEvent(),
                );
              }
            },
          ),
          BlocListener<AccountBloc, AccountState>(
            listenWhen: (p, c) => p.status != c.status,
            listener: (context, state) {
              if (state.status == LoadStatus.succeed) {
                BlocProvider.of<CategoryBloc>(context).add(
                  GetCategoryEvent(
                    themeState.languageId,
                  ),
                );
              }
            },
          ),
          BlocListener<CategoryBloc, CategoryState>(
            listenWhen: (p, c) => p.status != c.status,
            listener: (context, state) {
              if (state.status == LoadStatus.succeed) {
                LoadingOverlay.hide();
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.appBottomTabs,
                );
                BlocProvider.of<NotificationBloc>(context).add(
                  const CreateTokenEvent(),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return AuthPageLayout(
              form: _form,
              appBarTitle: AppLocalizations.of(context)!.appTitle,
              leading: backButton(
                context,
                previousRouteName: AppRoutes.auth,
              ),
              headingTitle: AppLocalizations.of(context)!.loginTitle,
              content: Column(
                children: [
                  authTextFormField(
                    onChanged: (value) =>
                        BlocProvider.of<LoginBloc>(context).add(
                      LoginPasswordEvent(value),
                    ),
                    validator: loginPasswordValidator(context),
                    labelText: AppLocalizations.of(context)!.enteredPassword,
                    obscureText: !state.isPasswordVisible,
                    suffixIcon: IconButton(
                      onPressed: () => BlocProvider.of<LoginBloc>(context).add(
                        const LoginPasswordVisibleEvent(),
                      ),
                      icon: Icon(
                        state.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<VerifyBloc>(context).add(
                        SendOTPEvent(
                          authState.emailAddress,
                        ),
                      );
                      Navigator.of(context)
                          .pushReplacementNamed(AppRoutes.resetPasswordVerify);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.forgotPassword,
                      style: AppTextStyle.text(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  customButton(
                    context,
                    buttonName: AppLocalizations.of(context)!.loginButton,
                    onPressed: () {
                      if (_form.currentState!.validate()) {
                        BlocProvider.of<LoginBloc>(context).add(
                          LoginWithEmailEvent(
                            authState.emailAddress,
                            state.password,
                            authState.userId, // 使用_userApi.getUserIdByEmail
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
