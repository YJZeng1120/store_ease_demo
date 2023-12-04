import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/auth_flow/auth/auth_bloc.dart';
import '../../controllers/auth_flow/verify/verify_bloc.dart';
import '../../models/core/validators.dart';
import '../../models/enums/load_status_enum.dart';
import '../../routes/app_router.dart';
import '../common_widgets/custom_button.dart';
import '../common_widgets/custom_dialog.dart';
import '../common_widgets/loading_overlay.dart';
import 'widgets/auth_page_layout.dart';
import 'widgets/auth_text_input.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});
  final TextEditingController emailController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            if (state.status == LoadStatus.succeed) {
              if (state.userId != '') {
                Navigator.of(context).pushReplacementNamed(AppRoutes.login);
              } else {
                log('Unregistered email address');
                BlocProvider.of<VerifyBloc>(context).add(
                  SendOTPEvent(
                    state.emailAddress,
                  ),
                );
                Navigator.of(context).pushReplacementNamed(AppRoutes.verify);
              }
              LoadingOverlay.hide();
            } else if (state.status == LoadStatus.failed) {
              LoadingOverlay.hide();
              systemErrorDialog(context);
            } else if (state.status == LoadStatus.inProgress) {
              LoadingOverlay.show(context);
            }
          },
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return AuthPageLayout(
            headingTitle: AppLocalizations.of(context)!.authTitle,
            form: _form,
            appBarTitle: AppLocalizations.of(context)!.appTitle,
            content: Column(
              children: [
                authTextFormField(
                  textEditingController: emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => BlocProvider.of<AuthBloc>(context).add(
                    EmailAddressEvent(value.trim()),
                  ),
                  labelText: AppLocalizations.of(context)!.email,
                  suffixIcon: state.emailAddress == ''
                      ? null
                      : IconButton(
                          onPressed: () {
                            emailController.clear();
                            BlocProvider.of<AuthBloc>(context).add(
                              const EmailAddressEvent(''),
                            );
                          },
                          icon: const Icon(
                            Icons.clear,
                          ),
                        ),
                  validator: emailValidator(context),
                ),
                const SizedBox(
                  height: 6,
                ),
                SizedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.warning_rounded,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.authWarning,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                customButton(
                  context,
                  buttonName: AppLocalizations.of(context)!.authTitle,
                  onPressed: () {
                    if (_form.currentState!.validate()) {
                      BlocProvider.of<AuthBloc>(context)
                          .add(const CheckHasUserEvent());
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
