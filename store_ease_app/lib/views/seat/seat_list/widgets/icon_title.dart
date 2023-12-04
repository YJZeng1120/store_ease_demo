import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../models/core/theme.dart';

Widget iconTitle(
  BuildContext context, {
  Widget? suffixWidget,
}) {
  return FittedBox(
    child: Row(
      children: [
        const Icon(
          Icons.room_service_outlined,
          size: 22,
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          '${AppLocalizations.of(context)!.tableNumber} : ',
          style: AppTextStyle.text(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (suffixWidget != null) suffixWidget,
      ],
    ),
  );
}
