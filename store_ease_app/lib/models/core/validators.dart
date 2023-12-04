import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/menu/menu_bloc.dart';
import '../../controllers/store/store_bloc.dart';

typedef ValidatorFunction = String? Function(String?);

ValidatorFunction passwordValidator(
  BuildContext context,
) {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.enteredPassword;
    }
    if (value.length < 8) {
      return AppLocalizations.of(context)!.passwordLengthMessage;
    }
    return null;
  };
}

ValidatorFunction confirmPasswordValidator(
  BuildContext context,
  String password,
) {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.enteredPassword;
    }
    if (value != password) {
      return AppLocalizations.of(context)!.passwordError;
    }
    return null;
  };
}

ValidatorFunction loginPasswordValidator(
  BuildContext context,
) {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.passwordEmpty;
    }
    return null;
  };
}

ValidatorFunction userNameValidator(
  BuildContext context, {
  required String returnText,
}) {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return returnText;
    }
    return null;
  };
}

ValidatorFunction emailValidator(
  BuildContext context,
) {
  RegExp regex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  return (value) {
    if (value == null ||
        value.trim().isEmpty ||
        !regex.hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.emailValidator;
    }
    return null;
  };
}

bool storeValidator(BuildContext context) {
  final StoreState storeState = context.read<StoreBloc>().state;
  return (storeState.store.storeName.trim().isEmpty ||
      storeState.store.phone.trim().isEmpty ||
      storeState.store.address.trim().isEmpty);
}

bool menuValidator(BuildContext context) {
  final MenuState menuState = context.read<MenuBloc>().state;
  return (menuState.menu.title.trim().isEmpty);
}
