import 'package:flutter/material.dart';

import '../../../../models/core/theme.dart';

Widget storeOverviewItem({
  String? title,
  IconData? icon,
  double vertical = 12,
  double? width,
  List<Widget> columnChildren = const <Widget>[],
  List<Widget> rowChildren = const <Widget>[],
  CrossAxisAlignment rowCrossAxisAlignment = CrossAxisAlignment.start,
}) {
  return Container(
    padding: EdgeInsets.symmetric(
      vertical: vertical,
    ),
    width: width,
    child: Row(
      crossAxisAlignment: rowCrossAxisAlignment,
      children: [
        Icon(
          icon,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                FittedBox(
                  child: Text(
                    title,
                    style: AppTextStyle.heading4(),
                  ),
                ),
              ...columnChildren,
            ],
          ),
        ),
        ...rowChildren,
      ],
    ),
  );
}
