import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../controllers/category/category_bloc.dart';
import '../../../../models/core/theme.dart';

TextFormField categoryInput(
  BuildContext context,
) {
  CategoryState categoryState = context.read<CategoryBloc>().state;
  return TextFormField(
    initialValue: categoryState.isEditing ? categoryState.category.title : null,
    onChanged: (value) {
      context.read<CategoryBloc>().add(
            UpdateCategoryDataEvent(
              categoryState.category.copyWith(
                title: value,
              ),
            ),
          );
    },
    maxLength: 6,
    decoration: InputDecoration(
      hintText: AppLocalizations.of(context)!.enterCategoryName,
      hintStyle: AppTextStyle.hintText(),
    ),
  );
}
