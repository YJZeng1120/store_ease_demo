import 'package:flutter/material.dart';

import '../../models/core/theme.dart';

Padding customButton(
  BuildContext context, {
  required String buttonName,
  required void Function()? onPressed,
  double horizontal = 0,
  Color? backgroundColor,
}) {
  backgroundColor ??= Theme.of(context).colorScheme.primaryContainer;
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: horizontal,
    ),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        backgroundColor: backgroundColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.mediumRadius(),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: Text(
          buttonName,
          style: AppTextStyle.heading4(),
        ),
      ),
    ),
  );
}

ElevatedButton smallButton(BuildContext context,
    {required String title,
    required IconData icon,
    required void Function()? onPressed}) {
  return ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.mediumRadius(),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppPaddingSize.mediumHorizontal,
      ),
    ),
    onPressed: onPressed,
    icon: Icon(
      icon,
    ),
    label: Text(
      title,
    ),
  );
}
