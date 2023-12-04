import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../controllers/category/category_bloc.dart';
import '../../../controllers/store/store_bloc.dart';
import '../../../controllers/store_menu/store_menu_bloc.dart';
import '../../../controllers/theme/theme_bloc.dart';
import '../../../models/core/theme.dart';
import '../../../models/enums/load_status_enum.dart';
import '../../../models/store.dart';
import '../../../routes/app_router.dart';
import '../../common_widgets/custom_button.dart';
import '../../common_widgets/empty_data_widget.dart';
import '../../common_widgets/loading_overlay.dart';
import '../../common_widgets/page_layout.dart';
import 'widgets/store_card.dart';

class StoreListPage extends StatelessWidget {
  const StoreListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeState themeState = context.read<ThemeBloc>().state;

    return MultiBlocListener(
      listeners: [
        BlocListener<StoreBloc, StoreState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            if (state.status == LoadStatus.inProgress) {
              LoadingOverlay.show(context);
            }
          },
        ),
        BlocListener<StoreMenuBloc, StoreMenuState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            if (state.status == LoadStatus.succeed) {
              BlocProvider.of<CategoryBloc>(context).add(
                GetCategoryEvent(
                  themeState.languageId,
                ),
              );
              BlocProvider.of<CategoryBloc>(context).add(
                FilteredCategoryListEvent(
                  state.menu.menuItems,
                ),
              );
            } else if (state.status == LoadStatus.failed) {
              BlocProvider.of<CategoryBloc>(context).add(
                const FilteredCategoryListEvent(
                  [],
                ),
              );
            }
          },
        ),
        BlocListener<CategoryBloc, CategoryState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            if (state.status == LoadStatus.succeed) {
              LoadingOverlay.hide();
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.storeBottomTabs,
              );
            }
          },
        ),
      ],
      child: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          return PageLayout(
            horizontal: 0,
            appBarTitle: AppLocalizations.of(context)!.store,
            body: state.getAllStore.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPaddingSize.largeHorizontal,
                    ),
                    child: emptyDataWidget(
                      context,
                      title: AppLocalizations.of(context)!.storeListIsEmpty,
                      content:
                          AppLocalizations.of(context)!.storeListIsEmptyContent,
                      buttonName: AppLocalizations.of(context)!.addStore,
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.storeForm);
                        BlocProvider.of<StoreBloc>(context).add(
                          StoreInitialEvent(
                            Store.empty(),
                          ),
                        );
                      },
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      pageSubTitle(
                        AppLocalizations.of(context)!.storeList,
                        horizontal: AppPaddingSize.largeHorizontal,
                        button: smallButton(
                          context,
                          title: AppLocalizations.of(context)!.addStore,
                          icon: Icons.add_business,
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(AppRoutes.storeForm);
                            BlocProvider.of<StoreBloc>(context).add(
                              StoreInitialEvent(
                                Store.empty(),
                              ),
                            );
                          },
                        ),
                      ),
                      ...state.getAllStore.map(
                        (store) => StoreCard(
                          store: store,
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
