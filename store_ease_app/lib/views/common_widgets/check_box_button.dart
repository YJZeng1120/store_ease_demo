import 'package:flutter/material.dart';

Widget checkBoxButton({
  required EdgeInsets margin,
  required void Function(bool?)? onChanged,
  required bool? value,
  required String title,
  required Color boxColor,
  required TextStyle? textStyle,
}) {
  return Row(
    children: [
      Container(
        margin: margin,
        width: 20,
        height: 20,
        child: Checkbox(
          value: value,
          side: BorderSide(
            width: 2,
            color: boxColor,
          ),
          onChanged: onChanged,
        ),
      ),
      Text(
        title,
        style: textStyle,
      ),
    ],
  );
}
