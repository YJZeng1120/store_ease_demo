import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum OrderStatus {
  open,
  inProgress,
  done,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  // 根據狀態回傳文字
  String statusText(
    BuildContext context,
  ) {
    switch (this) {
      case OrderStatus.open:
        return AppLocalizations.of(context)!.open;
      case OrderStatus.inProgress:
        return AppLocalizations.of(context)!.inProgress;
      case OrderStatus.done:
        return AppLocalizations.of(context)!.done;
      case OrderStatus.cancelled:
        return AppLocalizations.of(context)!.cancelled;

      default:
        return 'unknown';
    }
  }

  // 根據狀態回傳文字
  String orderOptionText(
    BuildContext context,
  ) {
    switch (this) {
      case OrderStatus.inProgress:
        return AppLocalizations.of(context)!.acceptOrder;
      case OrderStatus.cancelled:
        return AppLocalizations.of(context)!.cancelOrder;
      case OrderStatus.done:
        return AppLocalizations.of(context)!.completeOrder;
      default:
        return 'unknown';
    }
  }

// 根據狀態回傳顏色
  Color get statusColor {
    switch (this) {
      case OrderStatus.open:
        return const Color.fromARGB(255, 255, 203, 48);
      case OrderStatus.inProgress:
        return const Color.fromARGB(255, 129, 236, 255);
      case OrderStatus.cancelled:
        return const Color.fromARGB(255, 255, 134, 125);
      case OrderStatus.done:
        return const Color.fromARGB(255, 158, 255, 120);
      default:
        return Colors.black;
    }
  }
}
