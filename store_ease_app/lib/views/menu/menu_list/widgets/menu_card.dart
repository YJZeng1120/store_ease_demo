import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../controllers/category/category_bloc.dart';
import '../../../../controllers/menu/menu_bloc.dart';
import '../../../../controllers/theme/theme_bloc.dart';
import '../../../../models/core/theme.dart';
import '../../../../models/menu.dart';
import '../../../common_widgets/custom_card.dart';

Widget menuCard(
  BuildContext context, {
  required Menu menu,
}) {
  final ThemeState themeState = context.read<ThemeBloc>().state;
  return GestureDetector(
    onTap: () {
      BlocProvider.of<CategoryBloc>(context).add(
        FilteredCategoryListEvent(
          menu.menuItems,
        ),
      );
      BlocProvider.of<MenuBloc>(context).add(
        GetMenuDetailEvent(
          menu.menuId ?? '',
          themeState.languageId,
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPaddingSize.largeHorizontal,
      ),
      child: customCard(
        context,
        Row(
          children: [
            const Icon(
              Icons.menu_book,
              color: Colors.black87,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              menu.title,
              textAlign: TextAlign.center,
              style: AppTextStyle.heading3(),
            ),
            const Spacer(),
            AppIcon.arrowForward,
          ],
        ),
      ),
    ),
  );
}
