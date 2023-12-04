import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../controllers/seat/seat_bloc.dart';
import '../../../../controllers/store/store_bloc.dart';
import '../../../../models/core/theme.dart';
import '../../../../models/seat.dart';
import '../../../common_widgets/custom_card.dart';
import 'icon_title.dart';
import 'seat_dialog.dart';

Widget seatCard(
  BuildContext context, {
  required String title,
  required Seat seat,
}) {
  final StoreState storeState = context.read<StoreBloc>().state;
  return GestureDetector(
    onTap: () {
      seatDialog(
        context,
      );
      BlocProvider.of<SeatBloc>(context).add(
        SeatInitialEvent(
          seat,
        ),
      );
      BlocProvider.of<SeatBloc>(context).add(
        GetSeatDetailEvent(
          storeState.store.storeId ?? '',
          seat.seatId ?? 0,
        ),
      );
    },
    child: customCard(
      context,
      horizontal: AppPaddingSize.mediumHorizontal,
      bottom: 0,
      Column(
        children: [
          iconTitle(
            context,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyle.heading4(),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
