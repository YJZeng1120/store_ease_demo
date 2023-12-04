import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../controllers/category/category_bloc.dart';
import '../../../controllers/menu/menu_bloc.dart';
import '../../../routes/app_router.dart';
import '../../common_widgets/page_layout.dart';
import 'widgets/menu_overview_popup_menu.dart';
import 'widgets/menu_overview_widget.dart';

class MenuOverviewPage extends StatelessWidget {
  const MenuOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, state) {
        return PageLayout(
          appBarTitle: AppLocalizations.of(context)!.menuOverview,
          horizontal: 0,
          topPadding: 0,
          leading: backButton(
            context,
            previousRouteName: AppRoutes.appBottomTabs,
          ),
          actions: [
            menuOverviewPopupMenu(
              context,
            ),
          ],
          body: menuOverviewWidget(
            context,
            categoryList:
                context.read<CategoryBloc>().state.filteredCategoryList,
            menu: state.menu,
          ),
        );
      },
    );
  }
}
