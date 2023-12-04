import 'package:flutter/material.dart';

import '../../../models/core/theme.dart';
import '../../../models/enums/order_status_enum.dart';

TabBar orderStatusTabBar(BuildContext context) {
  return TabBar(
    isScrollable: true,
    labelPadding: const EdgeInsets.symmetric(
      horizontal: AppPaddingSize.largeHorizontal,
    ),
    tabs: [
      ...OrderStatus.values.map(
        (orderStatus) => Tab(
          child: SizedBox(
            child: Text(
              OrderStatusExtension(orderStatus).statusText(context),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ],
  );
}
