import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../constants.dart';
import '../../../../controllers/store/store_bloc.dart';
import '../../../../functions/time_utility.dart';
import '../../../../models/core/screen.dart';
import '../../../../models/core/theme.dart';
import '../../../common_widgets/bottom_sheet_title.dart';
import '../../../common_widgets/custom_button.dart';
import 'opening_hours_widget.dart';

dynamic openingHoursBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      final List<String> dayOfWeekList =
          dayOfWeekConverterList(context, dayNumbers);
      return BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppPaddingSize.mediumVertical,
                  horizontal: AppPaddingSize.largeHorizontal,
                ),
                child: Column(
                  children: [
                    bottomSheetTitle(
                      context,
                      AppLocalizations.of(context)!.setStoreOpeningHours,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: AppBorderRadius.largeRadius(),
                            color: const Color.fromARGB(14, 0, 0, 0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppPaddingSize.smallHorizontal,
                            vertical: AppPaddingSize.extraTinyVertical,
                          ),
                          width: screenWidth / 3,
                          child: DropdownButtonHideUnderline(
                            // DropdownButton隱藏底線
                            child: DropdownButton(
                              isExpanded: true,
                              value: state.storeOpeningHours.dayOfWeek,
                              items: dayOfWeekList
                                  .asMap() // 使用asMap()獲取index
                                  .entries
                                  .map((entry) {
                                final index = entry.key;
                                final value = entry.value;
                                return DropdownMenuItem<int>(
                                  value: index + 1, // 使用index作為value
                                  child: FittedBox(
                                    child: Text(
                                      value,
                                      style: AppTextStyle.text(),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) =>
                                  context.read<StoreBloc>().add(
                                        UpdateStoreOpeningHoursDataEvent(
                                          state.storeOpeningHours.copyWith(
                                            dayOfWeek: value,
                                          ),
                                        ),
                                      ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        selectTime(
                          context,
                          time: state.storeOpeningHours.openTime,
                          hintText: AppLocalizations.of(context)!.openTime,
                          onTimeSelected: (newTime) =>
                              context.read<StoreBloc>().add(
                                    UpdateStoreOpeningHoursDataEvent(
                                      state.storeOpeningHours.copyWith(
                                        openTime: newTime,
                                      ),
                                    ),
                                  ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppPaddingSize.tinyHorizontal,
                          ),
                          child: Text('—'),
                        ),
                        selectTime(
                          context,
                          time: state.storeOpeningHours.closeTime,
                          hintText: AppLocalizations.of(context)!.closeTime,
                          onTimeSelected: (newTime) =>
                              context.read<StoreBloc>().add(
                                    UpdateStoreOpeningHoursDataEvent(
                                      state.storeOpeningHours.copyWith(
                                        closeTime: newTime,
                                      ),
                                    ),
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    customButton(
                      context,
                      buttonName: AppLocalizations.of(context)!.save,
                      onPressed: state.storeOpeningHours.closeTime == null ||
                              state.storeOpeningHours.openTime == null
                          ? null
                          : () {
                              BlocProvider.of<StoreBloc>(context)
                                  .add(const AddStoreOpeningHoursEvent());
                              Navigator.of(context).pop();
                            },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
