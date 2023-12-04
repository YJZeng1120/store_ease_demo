import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants.dart';
import '../../controllers/account/account_bloc.dart';
import '../../controllers/theme/theme_bloc.dart';
import '../../models/core/theme.dart';
import '../../models/enums/load_status_enum.dart';
import '../../routes/app_router.dart';
import '../common_widgets/custom_divider.dart';
import '../common_widgets/loading_overlay.dart';
import '../common_widgets/page_layout.dart';
import 'widgets/account_item.dart';

class SetLanguagePage extends StatelessWidget {
  const SetLanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ThemeBloc, ThemeState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == LoadStatus.succeed) {
          LoadingOverlay.hide();
          BlocProvider.of<AccountBloc>(context).add(
            const GetUserInfoEvent(),
          );
        } else if (state.status == LoadStatus.inProgress) {
          LoadingOverlay.show(context);
        }
      },
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return PageLayout(
            horizontal: 0,
            appBarTitle: AppLocalizations.of(context)!.settings,
            leading: backButton(
              context,
              previousRouteName: AppRoutes.appBottomTabs,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPaddingSize.largeHorizontal,
                  ),
                  child: pageSubTitle(
                    AppLocalizations.of(context)!.language,
                  ),
                ),
                customDivider(),
                ...localeMapList.map(
                  (item) => Column(
                    children: [
                      accountButton(
                        title: item['title'],
                        onTap: () {
                          BlocProvider.of<ThemeBloc>(context).add(
                            ChangeLanguageEvent(
                              item['languageCode'],
                            ),
                          );
                        },
                        suffixWidget: state.languageCode == item['languageCode']
                            ? const Icon(
                                Icons.done,
                              )
                            : null,
                      ),
                      customDivider(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
