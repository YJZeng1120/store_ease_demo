import 'package:flutter/material.dart';

class AppTextStyle {
  static const double heading1Size = 22;
  static const double heading2Size = 20;
  static const double heading3Size = 18;
  static const double heading4Size = 16;
  static const double heading5Size = 15;
  static const double textSize = 14;
  static const double smallTextSize = 12;
  static const double dialogContentSize = 17;

  static TextStyle heading1({
    double fontSize = heading1Size,
    Color? color = Colors.black,
    FontWeight? fontWeight,
  }) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      );

  static TextStyle heading2({
    double fontSize = heading2Size,
    Color? color = Colors.black,
    FontWeight? fontWeight,
  }) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      );

  static TextStyle heading3({
    double fontSize = heading3Size,
    Color? color = Colors.black,
    FontWeight? fontWeight,
  }) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      );

  static TextStyle heading4({
    double fontSize = heading4Size,
    Color? color = Colors.black,
    FontWeight? fontWeight,
  }) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      );

  static TextStyle heading5({
    double fontSize = heading5Size,
    Color? color = Colors.black,
    FontWeight? fontWeight,
  }) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      );

  static TextStyle text({
    double? fontSize = textSize,
    Color? color = Colors.black,
    FontWeight? fontWeight,
    TextDecoration? decoration,
  }) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        decoration: decoration,
      );

  static TextStyle smallText({
    double? fontSize = smallTextSize,
    Color? color = Colors.black,
    FontWeight? fontWeight,
    TextDecoration? decoration,
  }) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        decoration: decoration,
      );

  static TextStyle dialogContent({
    double fontSize = dialogContentSize,
    Color? color = Colors.black,
  }) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
      );

  static TextStyle hintText({
    double fontSize = heading4Size,
    Color? color = Colors.grey,
    FontWeight? fontWeight = FontWeight.normal,
  }) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      );
}

class AppPaddingSize {
  static const double largeHorizontal = 22;
  static const double mediumHorizontal = 14;
  static const double smallHorizontal = 10;
  static const double tinyHorizontal = 8;
  static const double top = 24;
  static const double largeVertical = 22;
  static const double mediumVertical = 16;
  static const double smallVertical = 10;
  static const double compactVertical = 8;
  static const double tinyVertical = 4;
  static const double extraTinyVertical = 2;
  static const double smallAll = 4;
  static const double mediumAll = 12;
}

class AppBorderRadius {
  static const double large = 16;
  static const double medium = 10;
  static const double small = 8;

  static BorderRadiusGeometry largeRadius({
    double radius = large,
  }) =>
      BorderRadius.circular(radius);

  static BorderRadiusGeometry mediumRadius({
    double radius = medium,
  }) =>
      BorderRadius.circular(radius);

  static BorderRadiusGeometry smallRadius({
    double radius = small,
  }) =>
      BorderRadius.circular(radius);
}

class AppIcon {
  static const Icon arrowForward = Icon(
    Icons.arrow_forward_ios,
    size: 16,
    color: Color.fromARGB(255, 92, 92, 92),
  );
}
