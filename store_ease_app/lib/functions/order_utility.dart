import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controllers/notification/notification_bloc.dart';
import '../controllers/store/store_bloc.dart';

bool isOrderNotificationVisible(
  BuildContext context, {
  required final String storeId,
}) {
  final bool showNewOrderNotification =
      context.read<NotificationBloc>().state.remoteMessageList.any(
            (remoteMessage) => remoteMessage?.notification?.body == storeId,
          );
  return showNewOrderNotification;
}

bool isStoreListOrderNotificationVisible(
  BuildContext context,
) {
  final StoreState storeState = context.read<StoreBloc>().state;
  final bool showNewOrderNotification =
      context.read<NotificationBloc>().state.remoteMessageList.any(
    (remoteMessage) {
      final String? remoteStoreId = remoteMessage?.notification?.body;
      return remoteStoreId != null &&
          storeState.getAllStore.any((store) => store.storeId == remoteStoreId);
    },
  );
  return showNewOrderNotification;
}

Widget notificationIcon(
  final bool isShowNotification, {
  required final IconData icon,
}) {
  return isShowNotification
      ? Badge(
          smallSize: 8,
          child: Icon(
            icon,
          ),
        )
      : Icon(
          icon,
        );
}
