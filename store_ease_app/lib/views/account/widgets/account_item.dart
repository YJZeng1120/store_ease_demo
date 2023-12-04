import 'package:flutter/material.dart';

import '../../../models/core/theme.dart';

Widget accountItem({
  required String title,
  required void Function()? onTap,
  required IconData icon,
}) {
  return InkWell(
    highlightColor: const Color.fromARGB(255, 197, 197, 197),
    splashFactory: NoSplash.splashFactory,
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppPaddingSize.smallVertical,
        horizontal: AppPaddingSize.largeHorizontal,
      ),
      child: Row(
        children: [
          Icon(
            icon,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: AppTextStyle.heading4(),
          ),
          const Spacer(),
          AppIcon.arrowForward,
        ],
      ),
    ),
  );
}

Widget accountButton({
  required String title,
  required void Function()? onTap,
  Widget? suffixWidget,
}) {
  return InkWell(
    highlightColor: const Color.fromARGB(255, 197, 197, 197),
    splashFactory: NoSplash.splashFactory,
    onTap: onTap,
    child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: AppPaddingSize.smallVertical,
          horizontal: AppPaddingSize.largeHorizontal,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyle.heading4(),
            ),
            if (suffixWidget != null) suffixWidget,
          ],
        )),
  );
}
