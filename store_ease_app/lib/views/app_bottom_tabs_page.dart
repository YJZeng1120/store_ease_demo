import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../controllers/bottom_tabs/bottom_tabs_bloc.dart';
import '../controllers/notification/notification_bloc.dart';
import '../functions/order_utility.dart';
import 'account/account_page.dart';
import 'common_widgets/build_page.dart';
import 'menu/menu_list/menu_list_page.dart';
import 'store/store_list/store_list_page.dart';

class AppBottomTabsPage extends StatelessWidget {
  const AppBottomTabsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomTabsBloc, BottomTabsState>(
      builder: (context, state) {
        return Scaffold(
          body: buildPage(
            index: state.appTabIndex,
            pageList: [
              const StoreListPage(),
              const MenuListPage(),
              const AccountPage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Theme.of(context).colorScheme.primary,
              currentIndex: state.appTabIndex,
              onTap: (value) {
                BlocProvider.of<BottomTabsBloc>(context)
                    .add(AppTabIndexEvent(value));
              },
              items: [
                BottomNavigationBarItem(
                  label: AppLocalizations.of(context)!.store,
                  icon: BlocBuilder<NotificationBloc, NotificationState>(
                    builder: (context, state) {
                      return notificationIcon(
                        isStoreListOrderNotificationVisible(context),
                        icon: Icons.store,
                      );
                    },
                  ),
                ),
                BottomNavigationBarItem(
                  label: AppLocalizations.of(context)!.menu,
                  icon: const Icon(
                    Icons.restaurant_menu,
                  ),
                ),
                BottomNavigationBarItem(
                  label: AppLocalizations.of(context)!.accountTitle,
                  icon: const Icon(
                    Icons.person,
                  ),
                )
              ]),
        );
      },
    );
  }
}
