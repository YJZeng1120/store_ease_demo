import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../controllers/order_ticket/order_ticket_bloc.dart';
import '../../../functions/time_utility.dart';
import '../../../models/core/theme.dart';
import '../../../models/enums/order_status_enum.dart';
import '../../../models/order_ticket.dart';
import '../../common_widgets/custom_divider.dart';
import '../../seat/seat_list/widgets/icon_title.dart';
import 'order_dialog.dart';

Widget orderExpansionTile(
  BuildContext context,
  OrderTicket orderTicket,
  OrderStatus orderStatusTab,
) {
  return BlocBuilder<OrderTicketBloc, OrderTicketState>(
    builder: (context, state) {
      return Column(
        children: [
          ExpansionTile(
            childrenPadding: EdgeInsets.zero,
            tilePadding: const EdgeInsets.symmetric(
              vertical: AppPaddingSize.compactVertical,
              horizontal: AppPaddingSize.largeHorizontal,
            ),
            shape: Border.all(
              color: Colors.transparent,
            ),
            title: orderExpansionTitle(
              context,
              orderTicket,
              orderStatusTab,
            ),
            children: [
              ...orderTicket.orderTicketItems.map(
                (order) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPaddingSize.largeHorizontal,
                    vertical: AppPaddingSize.compactVertical,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${order.quantity}',
                        style: AppTextStyle.heading4(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' × ${order.productName}',
                        style: AppTextStyle.heading5(),
                      ),
                      const Spacer(),
                      Text(
                        '\$ ${(order.productPrice * order.quantity)}',
                        style: AppTextStyle.heading5(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          customDivider(),
        ],
      );
    },
  );
}

Widget orderExpansionTitle(
  BuildContext context,
  OrderTicket orderTicket,
  OrderStatus orderStatusTab,
) {
  return Row(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          iconTitle(
            context,
            suffixWidget: Text(
              orderTicket.seatTitle,
              style: AppTextStyle.heading4(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            DateTimeConverter(orderTicket.createdAt).toLocalTimeString(),
            style: AppTextStyle.smallText(),
          ),
          const SizedBox(
            height: 18,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: orderStatusTab == OrderStatus.cancelled ||
                        orderStatusTab == OrderStatus.done
                    ? null
                    : () {
                        if (orderStatusTab == OrderStatus.open) {
                          BlocProvider.of<OrderTicketBloc>(context).add(
                            SelectedIndexEvent(
                              OrderStatus.inProgress.index,
                            ),
                          );
                        }
                        if (orderStatusTab == OrderStatus.inProgress) {
                          BlocProvider.of<OrderTicketBloc>(context).add(
                            SelectedIndexEvent(
                              OrderStatus.done.index,
                            ),
                          );
                        }
                        orderStatusDialog(
                          context,
                          orderTicket: orderTicket,
                          orderStatusTab: orderStatusTab,
                        );
                      },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: AppBorderRadius.mediumRadius(),
                    color: OrderStatusExtension(
                      orderTicket.orderStatus,
                    ).statusColor,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPaddingSize.smallHorizontal,
                  ),
                  child: Row(
                    children: [
                      Text(
                        OrderStatusExtension(
                          orderTicket.orderStatus,
                        ).statusText(
                          context,
                        ),
                        style: AppTextStyle.heading5(),
                      ),
                      if (orderStatusTab == OrderStatus.open ||
                          orderStatusTab == OrderStatus.inProgress)
                        const Icon(
                          Icons.arrow_drop_down_sharp,
                        )
                    ],
                  ),
                ),
              ),
              if (orderStatusTab == OrderStatus.open ||
                  orderStatusTab == OrderStatus.inProgress) ...[
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    deleteOrderDialog(
                      context,
                      orderTicket: orderTicket,
                    );
                  },
                  child: const Icon(
                    Icons.delete_outline,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
      const Spacer(),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.totalPrice,
            style: AppTextStyle.text(
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            '\$ ${orderTicket.totalPrice}',
            style: AppTextStyle.heading1(
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      )
    ],
  );
}
