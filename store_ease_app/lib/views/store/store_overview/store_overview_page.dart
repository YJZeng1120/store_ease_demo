import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants.dart';
import '../../../controllers/store/store_bloc.dart';
import '../../../controllers/user_watcher/user_watcher_bloc.dart';
import '../../../functions/time_utility.dart';
import '../../../models/core/screen.dart';
import '../../../models/core/theme.dart';
import '../../../models/enums/load_status_enum.dart';
import '../../../routes/app_router.dart';
import '../../common_widgets/check_box_button.dart';
import '../../common_widgets/custom_dialog.dart';
import '../../common_widgets/custom_divider.dart';
import '../../common_widgets/loading_overlay.dart';
import '../../common_widgets/page_layout.dart';
import 'widgets/store_overview_item.dart';
import 'widgets/store_overview_popup_menu.dart';

class StoreOverviewPage extends StatelessWidget {
  const StoreOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserWatcherBloc, UserWatcherState>(
          listenWhen: (p, c) => p.deleteStatus != c.deleteStatus,
          listener: (context, state) {
            final StoreState storeState = context.read<StoreBloc>().state;
            if (state.deleteStatus == LoadStatus.succeed) {
              if (state.isDeleted) {
                LoadingOverlay.show(context);
                BlocProvider.of<StoreBloc>(context).add(
                  DeleteStoreEvent(
                    storeState.store.storeId ?? '',
                  ),
                );
              }
            } else if (state.deleteStatus == LoadStatus.failed) {
              LoadingOverlay.hide();
            }
          },
        ),
        BlocListener<StoreBloc, StoreState>(
          listenWhen: (p, c) => p.isDeleted != c.isDeleted,
          listener: (context, state) {
            if (state.isDeleted) {
              BlocProvider.of<StoreBloc>(context).add(
                const GetAllStoreEvent(),
              );
            }
          },
        ),
        BlocListener<StoreBloc, StoreState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            if (state.status == LoadStatus.succeed) {
              if (state.isDeleted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.appBottomTabs,
                  (route) => false,
                );
              }
              LoadingOverlay.hide();
            } else if (state.status == LoadStatus.failed) {
              LoadingOverlay.hide();
              systemErrorDialog(context);
            }
          },
        ),
      ],
      child: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          final List<String> dayOfWeekList =
              dayOfWeekConverterList(context, dayNumbers);
          final Color isBreakColor =
              state.store.isBreak ? Colors.black : Colors.grey;
          final Color isBreakColorInvert =
              state.store.isBreak ? Colors.grey : Colors.black;
          return PageLayout(
            appBarTitle: AppLocalizations.of(context)!.storeOverview,
            leading: backButton(
              context,
              previousRouteName: AppRoutes.appBottomTabs,
            ),
            actions: [
              storeOverviewPopupMenu(
                context,
              ),
            ],
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                pageSubTitle(
                  state.store.storeName,
                ),
                Text(
                  state.store.description,
                  style: AppTextStyle.text(),
                ),
                const SizedBox(
                  height: 12,
                ),
                customDivider(),
                storeOverviewItem(
                  title: state.store.address,
                  icon: Icons.location_on_outlined,
                ),
                storeOverviewItem(
                  title: state.store.phone,
                  icon: Icons.phone,
                ),
                customDivider(),
                storeOverviewItem(
                  title: AppLocalizations.of(context)!.openingHours,
                  icon: Icons.schedule,
                  width: screenWidth * 0.75,
                  rowChildren: [
                    checkBoxButton(
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppPaddingSize.smallHorizontal,
                        ),
                        value: state.store.isBreak,
                        onChanged: (value) {
                          LoadingOverlay.show(context);
                          BlocProvider.of<StoreBloc>(context).add(
                            IsBreakStoreEvent(
                              state.store.storeId ?? '',
                              value ?? false,
                            ),
                          );
                        },
                        title: AppLocalizations.of(context)!.tempClosed,
                        boxColor: isBreakColor,
                        textStyle: AppTextStyle.heading4(
                          color: isBreakColor,
                        )),
                  ],
                  columnChildren: [
                    Text(
                      '( UTC+08:00 )',
                      style: AppTextStyle.heading5(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
                // 顯示Business Hours
                storeOverviewItem(
                  vertical: 0,
                  icon: null,
                  columnChildren: [
                    ...dayOfWeekList.asMap().entries.map(
                      (entry) {
                        final index = entry.key + 1;
                        final value = entry.value;
                        List<Widget> openingHoursWidgets = [];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppPaddingSize.compactVertical,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text(
                                  value,
                                  style: AppTextStyle.text(
                                    color: isBreakColorInvert,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: screenWidth / 7,
                              ),
                              ...state.store.storeOpeningHoursList.map(
                                (e) {
                                  if (e.dayOfWeek == index) {
                                    openingHoursWidgets.addAll(
                                      [
                                        SizedBox(
                                          width: 130,
                                          child: FittedBox(
                                            child: Text(
                                              '${formatTimeOfDay(e.openTime!)} — ${formatTimeOfDay(e.closeTime!)} ',
                                              textAlign: TextAlign.center,
                                              style: AppTextStyle.text(
                                                color: isBreakColorInvert,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                      ],
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                              if (openingHoursWidgets.isNotEmpty)
                                Column(
                                  children: openingHoursWidgets,
                                ),
                              if (openingHoursWidgets.isEmpty)
                                SizedBox(
                                  width: 130,
                                  child: Text(
                                    AppLocalizations.of(context)!.closed,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.text(
                                      color: isBreakColorInvert,
                                    ),
                                  ),
                                )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
