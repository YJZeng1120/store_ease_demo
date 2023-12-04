import 'package:flutter/material.dart';

import '../../models/core/theme.dart';

Widget customCard(
  BuildContext context,
  Widget child, {
  double top = 0,
  double bottom = 19,
  double horizontal = AppPaddingSize.largeHorizontal,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.background,
      borderRadius: AppBorderRadius.mediumRadius(),
      boxShadow: const [
        BoxShadow(
          color: Color.fromARGB(255, 190, 190, 190),
          blurRadius: 3.5,
        ),
      ],
    ),
    margin: EdgeInsets.only(
      top: top,
      bottom: bottom,
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: AppPaddingSize.mediumVertical,
      ),
      child: child,
    ),
  );
}
