import 'package:flutter/material.dart';

import '../../../../functions/image_utility.dart';
import '../../../../models/core/screen.dart';
import '../../../../models/core/theme.dart';
import '../../../../models/menu.dart';

Container menuListTile(
  BuildContext context, {
  required MenuItem menuItem,
}) {
  return Container(
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 1.1,
          color: Color.fromARGB(255, 224, 224, 224),
        ),
      ),
    ),
    padding: const EdgeInsets.symmetric(
      vertical: AppPaddingSize.mediumVertical,
      horizontal: AppPaddingSize.largeHorizontal,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              menuItem.title,
              style: AppTextStyle.heading3(),
            ),
            const SizedBox(
              height: 3,
            ),
            SizedBox(
              width: screenWidth / 1.6,
              child: Text(
                menuItem.description,
                style: AppTextStyle.text(
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              '\$ ${menuItem.price}',
              style: AppTextStyle.heading3(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Spacer(),
        ClipRRect(
          borderRadius: AppBorderRadius.smallRadius(),
          child: Image.memory(
            menuItem.imageBytes.isEmpty
                ? ImageHelper.imageBytesProxy
                : menuItem.imageBytes,
            fit: BoxFit.cover,
            width: screenWidth / 5,
            height: screenWidth / 5,
          ),
        ),
      ],
    ),
  );
}
