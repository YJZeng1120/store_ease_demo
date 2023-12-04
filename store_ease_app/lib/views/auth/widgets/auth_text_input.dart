import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/core/theme.dart';
import '../../../models/core/validators.dart';

TextFormField authTextFormField({
  TextEditingController? textEditingController,
  TextInputType? keyboardType,
  required void Function(String)? onChanged,
  bool obscureText = false,
  String? Function(String?)? validator,
  Widget? suffixIcon,
  required String labelText,
}) {
  return TextFormField(
    controller: textEditingController,
    keyboardType: keyboardType,
    obscureText: obscureText,
    maxLines: 1,
    onChanged: onChanged,
    validator: validator,
    decoration: InputDecoration(
      suffixIcon: suffixIcon,
      helperText: '', // 固定TextFormField高度，避免errorText改變高度
      labelText: labelText,
      labelStyle: AppTextStyle.text(
        color: Colors.grey,
      ),
      isDense: true,
      contentPadding: const EdgeInsets.all(
        AppPaddingSize.smallAll,
      ),
    ),
  );
}

Widget registerTextFormField({
  required String title,
  required String hintText,
  String? Function(String?)? validator,
  TextInputType? keyboardType,
  void Function(String)? onChanged,
  int? maxLength,
  bool obscureText = false,
  void Function()? onPressed,
  IconData? buttonIcon,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        title,
        style: AppTextStyle.text(
          color: Colors.grey,
        ),
      ),
      TextFormField(
        onChanged: onChanged,
        validator: validator,
        maxLines: 1,
        maxLength: maxLength,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: AppTextStyle.heading3(),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: AppPaddingSize.smallVertical,
          ),
          helperText: '',
          hintText: hintText,
          hintStyle: AppTextStyle.hintText(),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          suffixIcon: maxLength == null
              ? null
              : IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    buttonIcon,
                    size: 24,
                  ),
                ),
        ),
      ),
      const SizedBox(
        height: 12,
      ),
    ],
  );
}

Widget passwordConfirmWidget(
  BuildContext context, {
  required String password,
  required bool isPasswordVisible,
  required bool isConfirmPasswordVisible,
  required void Function(String) onChangedPassword,
  required void Function()? onPressedPassword,
  required void Function(String) onChangedConfirmPassword,
  required void Function()? onPressedConfirmPassword,
}) {
  return Column(
    children: [
      registerTextFormField(
        title: AppLocalizations.of(context)!.setPassword,
        hintText: AppLocalizations.of(context)!.passwordHintText,
        maxLength: 16,
        obscureText: !isPasswordVisible,
        onChanged: onChangedPassword,
        onPressed: onPressedPassword,
        buttonIcon: isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        validator: passwordValidator(context),
      ),
      registerTextFormField(
        title: AppLocalizations.of(context)!.confirmPassword,
        hintText: AppLocalizations.of(context)!.passwordHintText,
        maxLength: 16,
        obscureText: !isConfirmPasswordVisible,
        onChanged: onChangedConfirmPassword,
        onPressed: onPressedConfirmPassword,
        buttonIcon:
            isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
        validator: confirmPasswordValidator(
          context,
          password,
        ),
      ),
    ],
  );
}
