import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

final FlutterView window =
    WidgetsBinding.instance.platformDispatcher.views.first;
final Size physicalSize = window.physicalSize;
final double devicePixelRatio = window.devicePixelRatio;
final double screenHeight = physicalSize.height / devicePixelRatio;
final double screenWidth = physicalSize.width / devicePixelRatio;
final double statusBarHeight = Get.statusBarHeight / devicePixelRatio;
final double appBarHeight = AppBar().preferredSize.height;
const double bottomNavigationHeight = kBottomNavigationBarHeight;
final double tabBarHeight = statusBarHeight + appBarHeight - kToolbarHeight;

final double bodyHeight = screenHeight - statusBarHeight - appBarHeight;
