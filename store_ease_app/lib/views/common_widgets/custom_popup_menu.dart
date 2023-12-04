import 'package:flutter/material.dart';

import '../../models/core/theme.dart';

PopupMenuButton customPopupMenu({
  required List<PopupMenuEntry<dynamic>> itemBuilder,
  void Function(dynamic)? onSelected,
}) {
  return PopupMenuButton(
    constraints: const BoxConstraints(
      maxWidth: 250,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: AppBorderRadius.mediumRadius(),
    ),
    itemBuilder: (context) => itemBuilder,
    onSelected: onSelected,
  );
}

PopupMenuItem customPopupItem({
  required String title,
  required IconData icon,
  required int value,
}) {
  return PopupMenuItem(
    value: value,
    child: Row(
      children: [
        Icon(
          icon,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          title,
        ),
      ],
    ),
  );
}
