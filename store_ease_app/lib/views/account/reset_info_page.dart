import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/account/account_bloc.dart';
import '../../models/enums/load_status_enum.dart';
import '../../routes/app_router.dart';
import '../auth/widgets/auth_page_layout.dart';
import '../auth/widgets/auth_text_input.dart';
import '../common_widgets/custom_button.dart';
import '../common_widgets/custom_dialog.dart';
import '../common_widgets/loading_overlay.dart';
import '../common_widgets/page_layout.dart';

class ResetInfoPage extends StatelessWidget {
  const ResetInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == LoadStatus.succeed) {
          LoadingOverlay.hide();
          Navigator.of(context).pushReplacementNamed(AppRoutes.appBottomTabs);
        } else if (state.status == LoadStatus.failed) {
          LoadingOverlay.hide();
          systemErrorDialog(context);
        } else if (state.status == LoadStatus.inProgress) {
          LoadingOverlay.show(context);
        }
      },
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          return AuthPageLayout(
              headingTitle: AppLocalizations.of(context)!.resetName,
              appBarTitle: AppLocalizations.of(context)!.settings,
              leading: backButton(
                context,
                previousRouteName: AppRoutes.appBottomTabs,
              ),
              content: Column(
                children: [
                  registerTextFormField(
                    title: AppLocalizations.of(context)!.lastName,
                    hintText: AppLocalizations.of(context)!.lastNameHintText,
                    onChanged: (value) => BlocProvider.of<AccountBloc>(context)
                        .add(ResetLastNameEvent(value)),
                  ),
                  registerTextFormField(
                    title: AppLocalizations.of(context)!.firstName,
                    hintText: AppLocalizations.of(context)!.firstNameHintText,
                    onChanged: (value) => BlocProvider.of<AccountBloc>(context)
                        .add(ResetFirstNameEvent(value)),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  customButton(
                    context,
                    buttonName: AppLocalizations.of(context)!.save,
                    onPressed: () {
                      BlocProvider.of<AccountBloc>(context)
                          .add(const UpdateUserInfoEvent());
                    },
                  ),
                ],
              ));
        },
      ),
    );
  }
}
