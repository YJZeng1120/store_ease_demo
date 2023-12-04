import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../controllers/seat/seat_bloc.dart';
import '../../../controllers/store/store_bloc.dart';
import '../../../models/core/theme.dart';
import '../../../models/enums/load_status_enum.dart';
import '../../../models/seat.dart';
import '../../../routes/app_router.dart';
import '../../common_widgets/custom_dialog.dart';
import '../../common_widgets/empty_data_widget.dart';
import '../../common_widgets/page_layout.dart';
import 'widgets/seat_card.dart';

class SeatListPage extends StatelessWidget {
  const SeatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final StoreState storeState = context.read<StoreBloc>().state;
    return MultiBlocListener(
      listeners: [
        BlocListener<SeatBloc, SeatState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            if (state.status == LoadStatus.succeed) {
              if (state.isDeleted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.storeBottomTabs,
                  (route) => false,
                );
                BlocProvider.of<SeatBloc>(context).add(
                  const ResetIsDeletedEvent(),
                );
              } else if (state.status == LoadStatus.failed) {
                systemErrorDialog(context);
              }
            }
          },
        ),
        BlocListener<SeatBloc, SeatState>(
          listenWhen: (p, c) => p.isDeleted != c.isDeleted,
          listener: (context, state) {
            if (state.isDeleted) {
              BlocProvider.of<SeatBloc>(context).add(
                GetAllSeatEvent(
                  storeState.store.storeId ?? '',
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<SeatBloc, SeatState>(
        builder: (context, state) {
          return Scaffold(
            appBar: pageLayoutAppBar(
              context,
              appBarTitle: AppLocalizations.of(context)!.seat,
              actions: state.getAllSeat.isEmpty
                  ? []
                  : [
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.seatForm);
                          BlocProvider.of<SeatBloc>(context).add(
                            SeatInitialEvent(
                              Seat.empty(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.add,
                        ),
                      ),
                    ],
              leading: backButton(
                context,
                previousRouteName: AppRoutes.appBottomTabs,
              ),
            ),
            body: state.getAllSeat.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPaddingSize.largeHorizontal,
                      vertical: AppPaddingSize.top,
                    ),
                    child: emptyDataWidget(
                      context,
                      title: AppLocalizations.of(context)!.seatEmpty,
                      content: AppLocalizations.of(context)!.seatEmptyContent,
                      buttonName: AppLocalizations.of(context)!.addTableNumber,
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.seatForm);
                        BlocProvider.of<SeatBloc>(context).add(
                          SeatInitialEvent(
                            Seat.empty(),
                          ),
                        );
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPaddingSize.largeHorizontal,
                      vertical: AppPaddingSize.top,
                    ),
                    child: GridView.builder(
                      clipBehavior: Clip.none, // fix cropped shadow
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.7,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: state.getAllSeat.length,
                      itemBuilder: (context, index) {
                        return seatCard(
                          context,
                          title: state.getAllSeat[index].title,
                          seat: state.getAllSeat[index],
                        );
                      },
                    ),
                  ),
          );
        },
      ),
    );
  }
}
