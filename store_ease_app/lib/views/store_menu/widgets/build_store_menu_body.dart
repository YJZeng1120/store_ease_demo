import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../controllers/category/category_bloc.dart';
import '../../../controllers/store_menu/store_menu_bloc.dart';
import '../../../models/core/api_error_message.dart';
import '../../../models/core/theme.dart';
import '../../../models/enums/load_status_enum.dart';
import '../../common_widgets/empty_data_widget.dart';
import '../../menu/menu_overview/widgets/menu_overview_widget.dart';
import 'select_menu_dialog.dart';

Widget buildStoreMenuBody(
  BuildContext context,
) {
  final CategoryState categoryState = context.read<CategoryBloc>().state;
  final StoreMenuState storeMenuState = context.read<StoreMenuBloc>().state;

  if (storeMenuState.status != LoadStatus.succeed) {
    if (storeMenuState.errorMessage == ApiErrorMessage.storeMenuNotFound) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPaddingSize.largeHorizontal,
          vertical: AppPaddingSize.top,
        ),
        child: emptyDataWidget(
          context,
          title: AppLocalizations.of(context)!.storeMenuEmpty,
          content: AppLocalizations.of(context)!.storeMenuEmptyContent,
          buttonName: AppLocalizations.of(context)!.addStoreMenu,
          onPressed: () {
            selectMenuDialog(
              context,
            );
          },
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  } else {
    return menuOverviewWidget(
      context,
      categoryList: categoryState.filteredCategoryList,
      menu: storeMenuState.menu,
    );
  }
}
