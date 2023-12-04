import 'package:flutter/material.dart';

import '../../../../models/core/screen.dart';
import '../../../../models/core/theme.dart';
import '../../../common_widgets/custom_divider.dart';

Widget storeInput({
  required String title,
  required String hintText,
  TextInputType? keyboardType,
  required void Function(String) onChanged,
  String? initialValue,
}) {
  return Column(
    children: [
      storeInputContainer(
        child: Row(
          children: [
            storeInputText(
              title: title,
            ),
            const Spacer(),
            SizedBox(
              width: screenWidth / 1.6,
              child: TextFormField(
                initialValue: initialValue,
                textAlign: TextAlign.end,
                onChanged: onChanged,
                maxLines: 1,
                keyboardType: keyboardType,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintText: hintText,
                  hintStyle: AppTextStyle.hintText(),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      customDivider(),
    ],
  );
}

Text storeInputText({
  required String title,
}) {
  return Text(
    title,
    style: AppTextStyle.heading4(),
  );
}

Container storeInputContainer({
  required Widget child,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(
      vertical: AppPaddingSize.smallVertical,
      horizontal: AppPaddingSize.largeHorizontal,
    ),
    child: child,
  );
}

Widget descriptionInput({
  required String title,
  required String hintText,
  required void Function(String) onChanged,
  String? initialValue,
}) {
  return storeInputContainer(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        storeInputText(
          title: title,
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          height: 90,
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.8,
              color: Colors.grey,
            ),
            borderRadius: AppBorderRadius.smallRadius(),
          ),
          child: TextFormField(
            initialValue: initialValue,
            textInputAction: TextInputAction.done,
            maxLines: 4,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppPaddingSize.smallHorizontal,
                vertical: AppPaddingSize.compactVertical,
              ),
              hintText: hintText,
              hintStyle: AppTextStyle.hintText(),
              border: InputBorder.none,
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    ),
  );
}
