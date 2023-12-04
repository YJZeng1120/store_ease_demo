import 'package:flutter/material.dart';

import '../../models/core/theme.dart';
import 'custom_button.dart';

Widget emptyDataWidget(
  BuildContext context, {
  required String title,
  required String content,
  required String buttonName,
  required void Function()? onPressed,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: AppTextStyle.heading3(
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        content,
        style: AppTextStyle.heading4(),
      ),
      const SizedBox(
        height: 100,
      ),
      customButton(
        context,
        buttonName: buttonName,
        onPressed: onPressed,
      )
    ],
  );
}

Widget noDataWidget({
  required IconData icon,
  required String title,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        icon,
        size: 30,
        color: Colors.grey,
      ),
      const SizedBox(
        width: 6,
      ),
      Text(
        title,
        style: AppTextStyle.heading3(
          color: Colors.grey,
        ),
      )
    ],
  );
}
