import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/auth_flow/verify/verify_bloc.dart';
import '../../routes/app_router.dart';
import 'widgets/verify_page_widget.dart';

class ResetPasswordVerifyPage extends StatelessWidget {
  const ResetPasswordVerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyBloc, VerifyState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: verifyListener(
        nextRouteName: AppRoutes.resetPassword,
      ),
      child: BlocBuilder<VerifyBloc, VerifyState>(
        builder: (context, state) {
          return VerifyWidget(
            title: AppLocalizations.of(context)!.resetPasswordVerifyTitle,
            previousRouteName: AppRoutes.login,
            number: state.verifyAttempts,
          );
        },
      ),
    );
  }
}
