import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../controllers/menu/menu_bloc.dart';
import '../../../../controllers/notification/notification_bloc.dart';
import '../../../../controllers/order_ticket/order_ticket_bloc.dart';
import '../../../../controllers/seat/seat_bloc.dart';
import '../../../../controllers/store/store_bloc.dart';
import '../../../../controllers/store_menu/store_menu_bloc.dart';
import '../../../../controllers/theme/theme_bloc.dart';
import '../../../../functions/order_utility.dart';
import '../../../../models/core/theme.dart';
import '../../../../models/store.dart';
import '../../../common_widgets/custom_card.dart';

class StoreCard extends StatelessWidget {
  const StoreCard({
    super.key,
    required this.store,
  });

  final Store store;

  @override
  Widget build(BuildContext context) {
    final ThemeState themeState = context.read<ThemeBloc>().state;
    final MenuState menuState = context.read<MenuBloc>().state;
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context.read<StoreBloc>()
              ..add(
                GetStoreDetailEvent(store.storeId ?? ''),
              )
              ..add(
                StoreInitialEvent(store),
              );

            context.read<MenuBloc>()
              ..add(
                UpdateMenuDataEvent(
                  menuState.menu.copyWith(storeId: store.storeId ?? ''),
                ),
              )
              ..add(
                GetAllMenuEvent(themeState.languageId),
              );

            BlocProvider.of<StoreMenuBloc>(context).add(
              GetStoreMenuEvent(
                store.storeId ?? '',
                themeState.languageId,
              ),
            );

            BlocProvider.of<SeatBloc>(context).add(
              GetAllSeatEvent(
                store.storeId ?? '',
              ),
            );

            BlocProvider.of<OrderTicketBloc>(context).add(
              GetAllOrderTicketEvent(
                store.storeId ?? '',
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPaddingSize.largeHorizontal,
            ),
            child: customCard(
              context,
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                store.storeName,
                                style: AppTextStyle.heading2(),
                              ),
                              if (isOrderNotificationVisible(
                                context,
                                storeId: store.storeId ?? '',
                              ))
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppPaddingSize.smallHorizontal,
                                  ),
                                  child: CircleAvatar(
                                    radius: 5,
                                    backgroundColor: Colors.red,
                                  ),
                                )
                            ],
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  store.address,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.text(),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  AppIcon.arrowForward,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
