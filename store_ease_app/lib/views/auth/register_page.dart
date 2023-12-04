import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ordering_system/controllers/user_watcher/user_watcher_bloc.dart';

import '../../controllers/account/account_bloc.dart';
import '../../controllers/auth_flow/auth/auth_bloc.dart';
import '../../controllers/auth_flow/login/login_bloc.dart';
import '../../controllers/auth_flow/register/register_bloc.dart';
import '../../controllers/menu/menu_bloc.dart';
import '../../controllers/store/store_bloc.dart';
import '../../controllers/theme/theme_bloc.dart';
import '../../models/core/validators.dart';
import '../../models/enums/load_status_enum.dart';
import '../../routes/app_router.dart';
import '../../services/api_firebase.dart';
import '../../services/api_user.dart';
import '../common_widgets/custom_button.dart';
import '../common_widgets/custom_dialog.dart';
import '../common_widgets/loading_overlay.dart';
import 'widgets/auth_page_layout.dart';
import 'widgets/auth_text_input.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  final TextEditingController emailController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ThemeState themeState = context.read<ThemeBloc>().state;
    final AuthState authState = context.read<AuthBloc>().state;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(
            context.read<UserApi>(),
          ),
        ),
        BlocProvider(
          create: (context) => LoginBloc(
            context.read<FirebaseApi>(),
            context.read<UserApi>(),
          ),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<RegisterBloc, RegisterState>(
            listenWhen: (p, c) => p.status != c.status,
            listener: (context, state) {
              if (state.status == LoadStatus.succeed) {
                BlocProvider.of<LoginBloc>(context).add(
                  LoginWithEmailEvent(
                    authState.emailAddress, state.password,
                    '', // register時userId會是空值
                  ),
                );
              } else if (state.status == LoadStatus.inProgress) {
                LoadingOverlay.show(context);
              } else if (state.status == LoadStatus.failed) {
                if (state.errorMessage == 'email has already existed') {
                  customDialog(
                    context,
                    title:
                        AppLocalizations.of(context)!.errorRegisterDialogTitle,
                    contentWidget: Text(
                      AppLocalizations.of(context)!.errorRegisterContent,
                    ),
                    actions: [
                      dialogButton(
                        context,
                        buttonText: AppLocalizations.of(context)!.confirmButton,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  );
                } else {
                  LoadingOverlay.hide();
                  systemErrorDialog(context);
                }
              }
            },
          ),
          BlocListener<LoginBloc, LoginState>(
            listenWhen: (p, c) =>
                p.userId != c.userId, // 等GetUserIdByUidEvent抓到userId
            listener: (context, state) {
              if (state.userId != '') {
                BlocProvider.of<AccountBloc>(context).add(
                  const GetUserInfoEvent(),
                );
                BlocProvider.of<StoreBloc>(context).add(
                  const GetAllStoreEvent(),
                );
                BlocProvider.of<MenuBloc>(context).add(
                  GetAllMenuEvent(
                    themeState.languageId,
                  ),
                );
              }
            },
          ),
          BlocListener<AccountBloc, AccountState>(
            listenWhen: (p, c) =>
                p.status != c.status, // 等GetUserInfoEvent結束再轉跳頁面
            listener: (context, state) {
              if (state.status == LoadStatus.succeed) {
                BlocProvider.of<UserWatcherBloc>(context).add(
                  const CacheLoginInfoEvent(),
                );
              }
            },
          ),
          BlocListener<UserWatcherBloc, UserWatcherState>(
            listenWhen: (p, c) =>
                p.authStatus != c.authStatus, // 等GetUserInfoEvent結束再轉跳頁面
            listener: (context, state) {
              if (state.authStatus == LoadStatus.succeed) {
                LoadingOverlay.hide();
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.appBottomTabs,
                );
              }
            },
          )
        ],
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            return AuthPageLayout(
              form: _form,
              appBarTitle: AppLocalizations.of(context)!.appTitle,
              leading: IconButton(
                onPressed: () {
                  customDialog(
                    context,
                    title:
                        AppLocalizations.of(context)!.leaveRegisterDialogTitle,
                    contentWidget: Text(
                      AppLocalizations.of(context)!.leaveRegisterContent,
                    ),
                    mainAxisAlignment: MainAxisAlignment.end,
                    actions: [
                      dialogButton(
                        context,
                        buttonText: AppLocalizations.of(context)!.leaveButton,
                        textColor: Colors.grey,
                        onPressed: () {
                          if (Platform.isAndroid) {
                            SystemNavigator.pop();
                          } else if (Platform.isIOS) {
                            exit(0);
                          }
                        },
                      ),
                      dialogButton(
                        context,
                        buttonText:
                            AppLocalizations.of(context)!.continueButton,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  );
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                ),
              ),
              headingTitle: AppLocalizations.of(context)!.registerTitle,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  passwordConfirmWidget(
                    context,
                    password: state.password,
                    isPasswordVisible: state.isPasswordVisible,
                    isConfirmPasswordVisible: state.isConfirmPasswordVisible,
                    onChangedPassword: (value) =>
                        BlocProvider.of<RegisterBloc>(context).add(
                      PasswordEvent(value),
                    ),
                    onPressedPassword: () =>
                        BlocProvider.of<RegisterBloc>(context).add(
                      const PasswordVisibleEvent(),
                    ),
                    onChangedConfirmPassword: (value) =>
                        BlocProvider.of<RegisterBloc>(context).add(
                      ConfirmPasswordEvent(value),
                    ),
                    onPressedConfirmPassword: () =>
                        BlocProvider.of<RegisterBloc>(context).add(
                      const ConfirmPasswordVisibleEvent(),
                    ),
                  ),
                  registerTextFormField(
                    title: AppLocalizations.of(context)!.lastName,
                    hintText: AppLocalizations.of(context)!.lastNameHintText,
                    onChanged: (value) =>
                        BlocProvider.of<RegisterBloc>(context).add(
                      LastNameEvent(value),
                    ),
                    validator: userNameValidator(
                      context,
                      returnText:
                          AppLocalizations.of(context)!.lastNameHintText,
                    ),
                  ),
                  registerTextFormField(
                    title: AppLocalizations.of(context)!.firstName,
                    hintText: AppLocalizations.of(context)!.firstNameHintText,
                    onChanged: (value) =>
                        BlocProvider.of<RegisterBloc>(context).add(
                      FirstNameEvent(value),
                    ),
                    validator: userNameValidator(
                      context,
                      returnText:
                          AppLocalizations.of(context)!.firstNameHintText,
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  customButton(
                    context,
                    buttonName: AppLocalizations.of(context)!.registerButton,
                    onPressed: () {
                      if (_form.currentState!.validate()) {
                        BlocProvider.of<RegisterBloc>(context).add(
                          CreateUserEvent(
                            themeState.languageId,
                            authState.emailAddress,
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
