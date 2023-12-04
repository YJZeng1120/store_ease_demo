import 'package:flutter/material.dart';

Widget buildPage({
  required int index,
  required List<Widget> pageList,
}) {
  List<Widget> page = pageList;
  return page[index];
}
