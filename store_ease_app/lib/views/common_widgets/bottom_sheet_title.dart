import 'package:flutter/material.dart';

import '../../models/core/theme.dart';

Widget bottomSheetTitle(
  BuildContext context,
  String title,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: AppTextStyle.heading3(),
      ),
      IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.close,
        ),
      ),
    ],
  );
}
