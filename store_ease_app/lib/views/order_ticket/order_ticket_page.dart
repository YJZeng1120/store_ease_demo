import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/notification/notification_bloc.dart';
import '../../controllers/order_ticket/order_ticket_bloc.dart';
import '../../controllers/store/store_bloc.dart';
import '../../models/core/screen.dart';
import '../../models/enums/load_status_enum.dart';
import '../../models/enums/order_status_enum.dart';
import '../../models/order_ticket.dart';
import '../../routes/app_router.dart';
import '../common_widgets/empty_data_widget.dart';
import '../common_widgets/loading_overlay.dart';
import '../common_widgets/page_layout.dart';
import 'widgets/order_expansion_tile.dart';
import 'widgets/order_status_tab_bar.dart';

class OrderTicketPage extends StatelessWidget {
  const OrderTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final StoreState storeState = context.read<StoreBloc>().state;
    context.read<NotificationBloc>().add(
          RemoveRemoteMessageListEvent(
            storeState.store.storeId ?? '',
          ),
        );
    return MultiBlocListener(
      listeners: [
        BlocListener<OrderTicketBloc, OrderTicketState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            if (state.status == LoadStatus.succeed) {
              context.read<NotificationBloc>().add(
                    RemoveRemoteMessageListEvent(
                      storeState.store.storeId ?? '',
                    ),
                  );
              LoadingOverlay.hide();
            } else if (state.status == LoadStatus.inProgress) {
              LoadingOverlay.show(context);
            }
          },
        ),
      ],
      child: BlocBuilder<OrderTicketBloc, OrderTicketState>(
        builder: (context, state) {
          return PageLayout(
            topPadding: 0,
            horizontal: 0,
            physics: const NeverScrollableScrollPhysics(),
            appBarTitle: AppLocalizations.of(context)!.orderTicket,
            leading: backButton(
              context,
              previousRouteName: AppRoutes.appBottomTabs,
            ),
            body: DefaultTabController(
              length: OrderStatus.values.length,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  orderStatusTabBar(
                    context,
                  ),
                  SizedBox(
                    height: bodyHeight - bottomNavigationHeight - tabBarHeight,
                    child: TabBarView(children: [
                      ...OrderStatus.values.map(
                        (orderStatus) {
                          List<OrderTicket> filterOrderTicketList =
                              state.getAllOrderTicket
                                  .where(
                                    (orderTicket) =>
                                        orderTicket.orderStatus == orderStatus,
                                  )
                                  .toList();
                          if (filterOrderTicketList.isEmpty) {
                            return Center(
                              child: noDataWidget(
                                icon: Icons.no_meals,
                                title:
                                    AppLocalizations.of(context)!.noOrderData,
                              ),
                            );
                          }
                          return Scrollbar(
                            child: ListView.builder(
                              itemCount: filterOrderTicketList.length,
                              itemBuilder: (context, index) =>
                                  orderExpansionTile(
                                context,
                                filterOrderTicketList[index],
                                orderStatus,
                              ),
                            ),
                          );
                        },
                      ),
                    ]),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
