import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../controllers/order_ticket/order_ticket_bloc.dart';
import '../../../controllers/store/store_bloc.dart';
import '../../../models/core/theme.dart';
import '../../../models/enums/load_status_enum.dart';
import '../../../models/enums/order_status_enum.dart';
import '../../../models/order_ticket.dart';
import '../../common_widgets/custom_dialog.dart';
import '../../common_widgets/loading_overlay.dart';

dynamic orderStatusDialog(
  BuildContext context, {
  required OrderTicket orderTicket,
  required OrderStatus orderStatusTab,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return BlocListener<OrderTicketBloc, OrderTicketState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status == LoadStatus.succeed) {
            Navigator.of(context).pop();
          } else if (state.status == LoadStatus.failed) {
            LoadingOverlay.hide();
            systemErrorDialog(
              context,
            );
          }
        },
        child: BlocBuilder<OrderTicketBloc, OrderTicketState>(
          builder: (context, state) {
            final StoreState storeState = context.read<StoreBloc>().state;
            return customAlertDialog(
              context,
              title: AppLocalizations.of(context)!.orderStatus,
              contentWidget: Column(
                children: OrderStatus.values.asMap().entries.where((entry) {
                  final item = entry.value;
                  if (orderStatusTab == OrderStatus.open) {
                    return item == OrderStatus.inProgress ||
                        item == OrderStatus.cancelled;
                  }
                  if (orderStatusTab == OrderStatus.inProgress) {
                    return item == OrderStatus.done ||
                        item == OrderStatus.cancelled;
                  }
                  return false; // 隱藏其他Status
                }).map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return GestureDetector(
                    onTap: () {
                      BlocProvider.of<OrderTicketBloc>(context).add(
                        SelectedIndexEvent(index),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppPaddingSize.largeVertical,
                      ),
                      child: Text(
                        OrderStatusExtension(item).orderOptionText(context),
                        style: AppTextStyle.heading3(
                          color: state.selectedIndex == index
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              actions: [
                cancelDialogButton(
                  context,
                ),
                dialogButton(
                  context,
                  buttonText: AppLocalizations.of(context)!.confirmButton,
                  onPressed: () {
                    BlocProvider.of<OrderTicketBloc>(context).add(
                      UpdateOrderTicketEvent(
                        storeState.store.storeId ?? '',
                        orderTicket.copyWith(
                          orderStatus: OrderStatus.values[state.selectedIndex],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

dynamic deleteOrderDialog(
  BuildContext context, {
  required OrderTicket orderTicket,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return BlocListener<OrderTicketBloc, OrderTicketState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status == LoadStatus.succeed) {
            Navigator.of(context).pop();
          } else if (state.status == LoadStatus.failed) {
            LoadingOverlay.hide();
            systemErrorDialog(
              context,
            );
          }
        },
        child: BlocBuilder<OrderTicketBloc, OrderTicketState>(
          builder: (context, state) {
            final StoreState storeState = context.read<StoreBloc>().state;
            return customAlertDialog(
              context,
              title: AppLocalizations.of(context)!.deleteOrder,
              contentWidget: Text(
                AppLocalizations.of(context)!.deleteOrderContent,
              ),
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              actions: [
                cancelDialogButton(
                  context,
                ),
                dialogButton(
                  context,
                  buttonText: AppLocalizations.of(context)!.confirmButton,
                  onPressed: () {
                    BlocProvider.of<OrderTicketBloc>(context).add(
                      DeleteOrderTicketEvent(
                        storeState.store.storeId ?? '',
                        orderTicket,
                      ),
                    );
                  },
                )
              ],
            );
          },
        ),
      );
    },
  );
}
