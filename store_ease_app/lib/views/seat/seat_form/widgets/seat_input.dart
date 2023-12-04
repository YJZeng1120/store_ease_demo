import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../controllers/seat/seat_bloc.dart';
import '../../../../models/core/theme.dart';

Widget seatInput(
  BuildContext context,
) {
  final SeatState seatState = context.read<SeatBloc>().state;

  return TextFormField(
    initialValue: seatState.isEditing ? seatState.seat.title : null,
    onChanged: (value) => context.read<SeatBloc>().add(
          UpdateSeatDataEvent(
            seatState.seat.copyWith(
              title: value,
            ),
          ),
        ),
    maxLength: 10,
    maxLines: 1,
    decoration: InputDecoration(
      hintText: AppLocalizations.of(context)!.enterTableNumber,
      hintStyle: AppTextStyle.hintText(),
      prefixIcon: const Icon(
        Icons.room_service_outlined,
      ),
    ),
  );
}
