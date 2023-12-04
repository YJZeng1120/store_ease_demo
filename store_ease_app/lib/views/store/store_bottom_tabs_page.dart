import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/bottom_tabs/bottom_tabs_bloc.dart';
import '../../controllers/notification/notification_bloc.dart';
import '../../controllers/store/store_bloc.dart';
import '../../functions/order_utility.dart';
import '../common_widgets/build_page.dart';
import '../order_ticket/order_ticket_page.dart';
import '../seat/seat_list/seat_list_page.dart';
import '../store_menu/store_menu_page.dart';
import 'store_overview/store_overview_page.dart';

class StoreBottomTabsPage extends StatelessWidget {
  const StoreBottomTabsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomTabsBloc, BottomTabsState>(
      builder: (context, state) {
        return Scaffold(
          body: buildPage(
            index: state.storeTabIndex,
            pageList: [
              const OrderTicketPage(),
              const StoreOverviewPage(),
              const StoreMenuPage(),
              const SeatListPage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Theme.of(context).colorScheme.primary,
              // 讓BottomNavigationBar可以包含三個以上的item
              type: BottomNavigationBarType.fixed,
              currentIndex: state.storeTabIndex,
              onTap: (value) {
                BlocProvider.of<BottomTabsBloc>(context)
                    .add(StoreTabIndexEvent(value));
              },
              items: [
                BottomNavigationBarItem(
                  label: AppLocalizations.of(context)!.order,
                  icon: BlocBuilder<NotificationBloc, NotificationState>(
                    builder: (context, state) {
                      final StoreState storeState =
                          context.read<StoreBloc>().state;
                      return notificationIcon(
                        isOrderNotificationVisible(
                          context,
                          storeId: storeState.store.storeId ?? '',
                        ),
                        icon: Icons.library_books_outlined,
                      );
                    },
                  ),
                ),
                BottomNavigationBarItem(
                  label: AppLocalizations.of(context)!.overview,
                  icon: const Icon(
                    Icons.book,
                  ),
                ),
                BottomNavigationBarItem(
                  label: AppLocalizations.of(context)!.selectMenu,
                  icon: const Icon(
                    Icons.set_meal_outlined,
                  ),
                ),
                BottomNavigationBarItem(
                  label: AppLocalizations.of(context)!.seat,
                  icon: const Icon(
                    Icons.chair_alt,
                  ),
                )
              ]),
        );
      },
    );
  }
}
