import 'package:flutter/material.dart';

import '../../models/core/theme.dart';
import 'tap_out_dismiss_keyboard.dart';

class PageLayout extends StatelessWidget {
  const PageLayout({
    super.key,
    required this.body,
    required this.appBarTitle,
    this.leading,
    this.actions,
    this.horizontal = AppPaddingSize.largeHorizontal,
    this.topPadding = AppPaddingSize.top,
    this.physics,
  });

  final Widget body;
  final String appBarTitle;
  final Widget? leading;
  final double horizontal;
  final double topPadding;
  final List<Widget>? actions;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pageLayoutAppBar(
        context,
        leading: leading,
        actions: actions,
        appBarTitle: appBarTitle,
      ),
      body: TapOutDismissKeyboard(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontal,
            topPadding,
            horizontal,
            0,
          ),
          child: SingleChildScrollView(
            physics: physics,
            child: body,
          ),
        ),
      ),
    );
  }
}

Widget pageSubTitle(
  String headingTitle, {
  Widget? button,
  double? horizontal,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: horizontal ?? 0,
    ),
    child: Column(
      children: [
        button == null
            ? Text(
                headingTitle,
                style: AppTextStyle.heading2(
                  fontWeight: FontWeight.w600,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    headingTitle,
                    style: AppTextStyle.heading2(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  button,
                ],
              ),
        const SizedBox(
          height: 24,
        ),
      ],
    ),
  );
}

IconButton backButton(
  BuildContext context, {
  required String previousRouteName,
}) {
  return IconButton(
    onPressed: () =>
        Navigator.of(context).pushReplacementNamed(previousRouteName),
    icon: const Icon(
      Icons.arrow_back_rounded,
    ),
  );
}

AppBar pageLayoutAppBar(
  BuildContext context, {
  required String appBarTitle,
  final Widget? leading,
  final List<Widget>? actions,
}) {
  return AppBar(
    leading: leading,
    actions: actions,
    title: Text(
      appBarTitle,
    ),
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
  );
}
