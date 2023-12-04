import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/user_watcher/user_watcher_bloc.dart';
import '../../models/core/theme.dart';

dynamic customDialog(
  BuildContext context, {
  MainAxisAlignment? mainAxisAlignment,
  required String title,
  required Widget contentWidget,
  List<Widget>? actions,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return customAlertDialog(
        context,
        title: title,
        contentWidget: contentWidget,
        actions: actions,
        mainAxisAlignment: mainAxisAlignment,
      );
    },
  );
}

AlertDialog customAlertDialog(
  BuildContext context, {
  MainAxisAlignment? mainAxisAlignment,
  String? title,
  required Widget contentWidget,
  List<Widget>? actions,
  Color? surfaceTintColor,
  Color? backgroundColor,
  EdgeInsets insetPadding =
      const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
}) {
  return AlertDialog(
    insetPadding: insetPadding,
    surfaceTintColor: surfaceTintColor,
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: AppBorderRadius.largeRadius(),
    ),
    title: title == null
        ? null
        : Text(
            title,
          ),
    titlePadding: const EdgeInsets.fromLTRB(22, 30, 30, 20),
    titleTextStyle: AppTextStyle.heading2(
      fontWeight: FontWeight.bold,
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        contentWidget,
      ],
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppPaddingSize.largeHorizontal,
      vertical: AppPaddingSize.tinyVertical,
    ),
    contentTextStyle: AppTextStyle.dialogContent(),
    actionsPadding: const EdgeInsets.symmetric(
      vertical: AppPaddingSize.mediumVertical,
      horizontal: AppPaddingSize.largeHorizontal,
    ),
    actionsAlignment: mainAxisAlignment,
    actions: actions,
  );
}

TextButton cancelDialogButton(
  BuildContext context,
) {
  return dialogButton(
    context,
    buttonText: AppLocalizations.of(context)!.cancel,
    textColor: Colors.grey,
    onPressed: () => Navigator.pop(context),
  );
}

TextButton dialogButton(
  BuildContext context, {
  required String buttonText,
  required void Function()? onPressed,
  Color? textColor,
}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      buttonText,
      style: AppTextStyle.heading4(
        color: textColor,
      ),
    ),
  );
}

dynamic systemErrorDialog(BuildContext context) {
  return customDialog(
    context,
    title: AppLocalizations.of(context)!.systemErrorDialogTitle,
    contentWidget: Text(
      AppLocalizations.of(context)!.systemErrorContent,
    ),
    actions: [
      dialogButton(
        context,
        buttonText: AppLocalizations.of(context)!.confirmButton,
        onPressed: () => Navigator.of(context).pop(),
      ),
    ],
  );
}

Widget confirmPasswordDialogWidget(BuildContext context) {
  final UserWatcherState state = context.read<UserWatcherBloc>().state;
  return Column(
    children: [
      TextFormField(
        onChanged: (value) {
          BlocProvider.of<UserWatcherBloc>(context)
              .add(VerifyPasswordEvent(value));
        },
        obscureText: true,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.verifyPassword,
          hintStyle: AppTextStyle.hintText(
            fontSize: AppTextStyle.textSize,
          ),
          prefixIcon: const Icon(
            Icons.lock,
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        state.errorMessage == 'wrong-password'
            ? AppLocalizations.of(context)!.passwordError
            : '',
        style: AppTextStyle.text(
          color: const Color.fromARGB(255, 153, 10, 0),
        ),
      ),
    ],
  );
}
