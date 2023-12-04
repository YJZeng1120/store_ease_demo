import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../controllers/seat/seat_bloc.dart';
import '../../../controllers/store/store_bloc.dart';
import '../../../models/enums/load_status_enum.dart';
import '../../../routes/app_router.dart';
import '../../common_widgets/custom_button.dart';
import '../../common_widgets/custom_dialog.dart';
import '../../common_widgets/loading_overlay.dart';
import '../../common_widgets/page_layout.dart';
import 'widgets/seat_input.dart';

class SeatFormPage extends StatelessWidget {
  const SeatFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SeatBloc, SeatState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == LoadStatus.succeed) {
          LoadingOverlay.hide();
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.storeBottomTabs,
          );
        } else if (state.status == LoadStatus.inProgress) {
          LoadingOverlay.show(context);
        } else if (state.status == LoadStatus.failed) {
          LoadingOverlay.hide();
          systemErrorDialog(context);
        }
      },
      child: BlocBuilder<SeatBloc, SeatState>(
        builder: (context, state) {
          final StoreState storeState = context.read<StoreBloc>().state;
          return PageLayout(
            appBarTitle: state.isEditing
                ? AppLocalizations.of(context)!.editTableNumber
                : AppLocalizations.of(context)!.addTableNumber,
            leading: backButton(
              context,
              previousRouteName: AppRoutes.storeBottomTabs,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                seatInput(
                  context,
                ),
                const SizedBox(
                  height: 100,
                ),
                state.isEditing
                    ? customButton(
                        context,
                        buttonName: AppLocalizations.of(context)!.save,
                        onPressed: () {
                          BlocProvider.of<SeatBloc>(context).add(
                            UpdateSeatEvent(
                              storeState.store.storeId ?? '',
                            ),
                          );
                        },
                      )
                    : customButton(
                        context,
                        buttonName: AppLocalizations.of(context)!.add,
                        onPressed: () {
                          BlocProvider.of<SeatBloc>(context).add(
                            CreateSeatEvent(
                              storeState.store.storeId ?? '',
                            ),
                          );
                        },
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
