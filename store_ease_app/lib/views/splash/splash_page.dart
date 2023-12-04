import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/account/account_bloc.dart';
import '../../controllers/category/category_bloc.dart';
import '../../controllers/menu/menu_bloc.dart';
import '../../controllers/notification/notification_bloc.dart';
import '../../controllers/store/store_bloc.dart';
import '../../controllers/theme/theme_bloc.dart';
import '../../controllers/user_watcher/user_watcher_bloc.dart';
import '../../models/core/theme.dart';
import '../../models/enums/load_status_enum.dart';
import '../../routes/app_router.dart';
import '../common_widgets/custom_dialog.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeState themeState = context.read<ThemeBloc>().state;

    context.read<ThemeBloc>().add(
          const InitialEvent(),
        );
    context.read<UserWatcherBloc>().add(
          const CacheLoginInfoEvent(),
        );
    context.read<NotificationBloc>().add(
          const CreateFcmListenerEvent(),
        );

    return MultiBlocListener(
      listeners: [
        BlocListener<UserWatcherBloc, UserWatcherState>(
          listenWhen: (p, c) => p.authStatus != c.authStatus,
          listener: (context, state) {
            if (state.authStatus == LoadStatus.succeed) {
              if (state.loggedIn) {
                context.read<AccountBloc>().add(
                      const GetUserInfoEvent(),
                    );
                context.read<StoreBloc>().add(
                      const GetAllStoreEvent(),
                    );
                context.read<MenuBloc>().add(
                      GetAllMenuEvent(
                        themeState.languageId,
                      ),
                    );
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.auth,
                  (route) => false,
                );
              }
            } else if (state.authStatus == LoadStatus.failed) {
              systemErrorDialog(context);
            }
          },
        ),
        BlocListener<MenuBloc, MenuState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            if (state.status == LoadStatus.succeed) {
              context.read<CategoryBloc>().add(
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
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.appBottomTabs,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.inversePrimary,
                const Color.fromARGB(255, 253, 104, 58),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.storefront_outlined,
                size: 66,
                color: Colors.white,
              ),
              const SizedBox(
                height: 6,
              ),
              FittedBox(
                child: Text(
                  AppLocalizations.of(context)!.appTitle.toUpperCase(),
                  style: AppTextStyle.heading1(
                    color: Colors.white,
                    fontWeight: themeState.languageCode == 'en'
                        ? FontWeight.w900
                        : FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
