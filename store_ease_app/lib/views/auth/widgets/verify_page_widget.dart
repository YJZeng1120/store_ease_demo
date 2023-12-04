import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

import '../../../controllers/auth_flow/verify/verify_bloc.dart';
import '../../../models/core/theme.dart';
import '../../../models/enums/load_status_enum.dart';
import '../../../routes/app_router.dart';
import '../../common_widgets/custom_button.dart';
import '../../common_widgets/custom_dialog.dart';
import 'auth_page_layout.dart';

class VerifyWidget extends StatelessWidget {
  const VerifyWidget({
    super.key,
    required this.title,
    required this.previousRouteName,
    required this.number,
  });
  final String title;
  final String previousRouteName;
  final int number;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerifyBloc, VerifyState>(
      builder: (context, state) {
        return AuthPageLayout(
          appBarTitle: AppLocalizations.of(context)!.appTitle,
          leading: IconButton(
            onPressed: () {
              BlocProvider.of<VerifyBloc>(context).add(
                const ResetAuthProcessEvent(),
              );
              Navigator.of(context).pushReplacementNamed(
                previousRouteName,
              );
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
            ),
          ),
          headingTitle: title,
          content: Column(
            children: [
              FittedBox(
                child: VerificationCode(
                  length: 6,
                  itemSize: 56,
                  underlineUnfocusedColor:
                      const Color.fromARGB(255, 212, 212, 212),
                  underlineWidth: 2,
                  textStyle: AppTextStyle.heading2(),
                  clearAll: Padding(
                    padding: const EdgeInsets.all(
                      AppPaddingSize.mediumAll,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.clearVerificationCode,
                      style: AppTextStyle.text(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  onCompleted: (value) {
                    BlocProvider.of<VerifyBloc>(context).add(
                      VerificationCodeEvent(value),
                    );
                  },
                  onEditing: (value) {
                    final bool onEditing = value;
                    if (!onEditing) FocusScope.of(context).unfocus();
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                '${AppLocalizations.of(context)!.verifyAttempts}: ${3 - number}',
                style: AppTextStyle.text(),
              ),
              const SizedBox(
                height: 100,
              ),
              customButton(
                context,
                buttonName: AppLocalizations.of(context)!.confirmButton,
                onPressed: () {
                  BlocProvider.of<VerifyBloc>(context).add(
                    const VerifyOTPEvent(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

void Function(BuildContext, VerifyState) verifyListener({
  required String nextRouteName,
}) {
  return (context, state) {
    if (state.status == LoadStatus.succeed) {
      BlocProvider.of<VerifyBloc>(context).add(
        const ResetAuthProcessEvent(),
      );
      Navigator.of(context).pushReplacementNamed(
        nextRouteName,
      );
    } else if (state.status == LoadStatus.failed) {
      if (state.errorMessage == 'invalid otp code') {
        customDialog(
          context,
          title: AppLocalizations.of(context)!.verifyErrorDialogTitle,
          contentWidget: Text(
            AppLocalizations.of(context)!.verifyErrorContent,
          ),
          actions: [
            dialogButton(
              context,
              buttonText: AppLocalizations.of(context)!.confirmButton,
              onPressed: () {
                if (state.verifyAttempts >= 3) {
                  BlocProvider.of<VerifyBloc>(context).add(
                    const ResetAuthProcessEvent(),
                  );
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.auth,
                    (route) => false,
                  );
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      } else {
        systemErrorDialog(context);
      }
    }
  };
}
