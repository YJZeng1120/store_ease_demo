import 'package:flutter/material.dart';

import '../../../models/core/theme.dart';
import '../../common_widgets/page_layout.dart';
import '../../common_widgets/tap_out_dismiss_keyboard.dart';

class AuthPageLayout extends StatelessWidget {
  const AuthPageLayout({
    super.key,
    required this.headingTitle,
    this.leading,
    this.form,
    required this.content,
    required this.appBarTitle,
  });
  final String headingTitle;
  final Widget? leading;
  final GlobalKey<FormState>? form;
  final Widget content;
  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: leading,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          appBarTitle,
        ),
      ),
      body: TapOutDismissKeyboard(
        child: Form(
          key: form,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppPaddingSize.largeHorizontal,
              AppPaddingSize.top,
              AppPaddingSize.largeHorizontal,
              0,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  pageSubTitle(
                    headingTitle,
                  ),
                  content,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
