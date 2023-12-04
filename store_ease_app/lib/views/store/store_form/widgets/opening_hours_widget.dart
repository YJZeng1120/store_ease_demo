import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../controllers/store/store_bloc.dart';
import '../../../../functions/time_utility.dart';
import '../../../../models/core/screen.dart';
import '../../../../models/core/theme.dart';
import '../../../../models/store.dart';
import '../../store_list/widgets/store_input.dart';

Widget openingHours(
  BuildContext context,
  StoreOpeningHours storeOpeningHours,
) {
  String dayOfWeek = dayOfWeekConverter(
    context,
    storeOpeningHours.dayOfWeek,
  );

  return Row(
    children: [
      IconButton(
        onPressed: () {
          BlocProvider.of<StoreBloc>(context)
              .add(RemoveStoreOpeningHoursEvent(storeOpeningHours));
        },
        icon: const Icon(
          Icons.do_disturb_on_outlined,
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      storeInputText(title: dayOfWeek),
      const Spacer(),
      storeInputText(
        title: formatTimeOfDay(
          storeOpeningHours.openTime ?? TimeOfDay.now(),
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPaddingSize.smallHorizontal,
        ),
        child: const Text('—'),
      ),
      storeInputText(
        title: formatTimeOfDay(
          storeOpeningHours.closeTime ?? TimeOfDay.now(),
        ),
      ),
    ],
  );
}

typedef TimeSelectionCallback = void Function(
  TimeOfDay newTime,
);

GestureDetector selectTime(
  BuildContext context, {
  required TimeOfDay? time,
  required String hintText,
  required TimeSelectionCallback onTimeSelected,
}) {
  return GestureDetector(
    onTap: () async {
      TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime: time ?? TimeOfDay.now(),
      );
      if (newTime == null) return;
      onTimeSelected(newTime);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppPaddingSize.tinyVertical,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.8,
            color: Colors.grey,
          ),
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        width: screenWidth / 4.8,
        height: 30,
        child: Text(
          time == null ? hintText : formatTimeOfDay(time),
          style: AppTextStyle.text(
            color: time == null ? Colors.grey : Colors.black,
          ),
        ),
      ),
    ),
  );
}
