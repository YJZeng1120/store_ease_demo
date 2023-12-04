import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/menu/menu_bloc.dart';
import '../../controllers/store_menu/store_menu_bloc.dart';
import '../../models/core/api_error_message.dart';
import '../../routes/app_router.dart';
import '../common_widgets/page_layout.dart';
import 'widgets/build_store_menu_body.dart';
import 'widgets/select_menu_dialog.dart';

class StoreMenuPage extends StatelessWidget {
  const StoreMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MenuState menuState = context.read<MenuBloc>().state;
    return BlocBuilder<StoreMenuBloc, StoreMenuState>(
      builder: (context, state) {
        return PageLayout(
          appBarTitle: AppLocalizations.of(context)!.storeMenu,
          horizontal: 0,
          topPadding: 0,
          leading: backButton(
            context,
            previousRouteName: AppRoutes.appBottomTabs,
          ),
          actions: state.errorMessage == ApiErrorMessage.storeMenuNotFound
              ? []
              : [
                  IconButton(
                    onPressed: () {
                      selectMenuDialog(context);
                      // 如果已選擇菜單就會highlight選擇的菜單，沒有的話就會顯示List的第一個菜單
                      BlocProvider.of<StoreMenuBloc>(context).add(
                        SelectedMenuIdEvent(
                          state.menu.menuId ??
                              menuState.getAllMenu.first.menuId ??
                              '',
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.change_circle_outlined,
                    ),
                  ),
                ],
          body: buildStoreMenuBody(
            context,
          ),
        );
      },
    );
  }
}
