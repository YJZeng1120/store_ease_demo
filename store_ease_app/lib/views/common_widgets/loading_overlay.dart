import 'package:flutter/material.dart';

class LoadingOverlay {
  static late OverlayEntry? _overlay;
  const LoadingOverlay();
  // static OverlayEntry? _overlay;
  static void init() {
    _overlay = OverlayEntry(
      builder: (BuildContext context) {
        return Container();
      },
    );
  }

  static void show(BuildContext context) {
    _overlay = OverlayEntry(
      builder: (context) => const ColoredBox(
        color: Color(0x80000000),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        ),
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context).insert(_overlay!);
    });
  }

  static void hide() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_overlay != null && _overlay!.mounted) {
        _overlay?.remove();
        _overlay = null;
      }
    });
  }

  // static Future<void> hideF() async {
  //   await Future.delayed(const Duration(milliseconds: 200), () {
  //     if (_overlay != null && _overlay!.mounted) {
  //       _overlay?.remove();
  //       _overlay = null;
  //     }
  //   });
  // }
}
