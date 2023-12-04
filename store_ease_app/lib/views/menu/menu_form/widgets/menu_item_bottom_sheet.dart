import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../controllers/menu/menu_bloc.dart';
import '../../../../functions/image_utility.dart';
import '../../../../models/core/screen.dart';
import '../../../../models/core/theme.dart';
import '../../../common_widgets/bottom_sheet_title.dart';
import '../../../common_widgets/custom_button.dart';
import '../../../common_widgets/custom_divider.dart';
import '../../../common_widgets/tap_out_dismiss_keyboard.dart';
import '../../../store/store_list/widgets/store_input.dart';
import 'get_image_dialog.dart';

dynamic menuItemBottomSheet(
  BuildContext context, {
  int index = 0,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          return TapOutDismissKeyboard(
            child: FractionallySizedBox(
              heightFactor: 0.9,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppPaddingSize.largeHorizontal,
                        AppPaddingSize.mediumVertical,
                        AppPaddingSize.largeHorizontal,
                        0,
                      ),
                      child: bottomSheetTitle(
                        context,
                        state.isMenuItemEditing
                            ? AppLocalizations.of(context)!.editMeal
                            : AppLocalizations.of(context)!.addMeal,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    storeInput(
                      title: AppLocalizations.of(context)!.mealTitle,
                      initialValue: state.menuItem.title,
                      hintText: AppLocalizations.of(context)!.enterMealTitle,
                      onChanged: (value) {
                        context.read<MenuBloc>().add(
                              UpdateMenuItemDataEvent(
                                state.menuItem.copyWith(
                                  title: value,
                                ),
                              ),
                            );
                      },
                    ),
                    descriptionInput(
                      title: AppLocalizations.of(context)!.mealDescription,
                      initialValue: state.menuItem.description,
                      hintText:
                          AppLocalizations.of(context)!.enterMealDescription,
                      onChanged: (value) {
                        context.read<MenuBloc>().add(
                              UpdateMenuItemDataEvent(
                                state.menuItem.copyWith(
                                  description: value,
                                ),
                              ),
                            );
                      },
                    ),
                    customDivider(),
                    storeInput(
                      title: AppLocalizations.of(context)!.quantity,
                      initialValue: state.isMenuItemEditing
                          ? '${state.menuItem.quantity}'
                          : null,
                      hintText: AppLocalizations.of(context)!.enterQuantity,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        context.read<MenuBloc>().add(
                              UpdateMenuItemDataEvent(
                                state.menuItem.copyWith(
                                  quantity: int.parse(value),
                                ),
                              ),
                            );
                      },
                    ),
                    storeInput(
                      title: AppLocalizations.of(context)!.price,
                      initialValue: state.isMenuItemEditing
                          ? '${state.menuItem.price}'
                          : null,
                      hintText: AppLocalizations.of(context)!.enterPrice,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        context.read<MenuBloc>().add(
                              UpdateMenuItemDataEvent(
                                state.menuItem.copyWith(
                                  price: int.parse(value),
                                ),
                              ),
                            );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 170,
                      alignment: Alignment.center,
                      child: state.menuItem.imageBytes.isEmpty ||
                              state.menuItem.imageBytes ==
                                  ImageHelper.imageBytesProxy
                          ? TextButton.icon(
                              onPressed: () {
                                getImageDialog(
                                  context,
                                );
                              },
                              icon: const Icon(
                                Icons.camera_alt_sharp,
                              ),
                              label: Text(
                                AppLocalizations.of(context)!.addPicture,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                getImageDialog(
                                  context,
                                );
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.memory(
                                    state.menuItem.imageBytes,
                                    fit: BoxFit.fitHeight,
                                    width: screenWidth / 2,
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.black54,
                                    child: Icon(
                                      Icons.replay_circle_filled_rounded,
                                      size: 40,
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    customButton(
                      context,
                      buttonName: state.isMenuItemEditing
                          ? AppLocalizations.of(context)!.save
                          : AppLocalizations.of(context)!.add,
                      horizontal: AppPaddingSize.largeHorizontal,
                      onPressed: state.menuItem.title.trim().isEmpty
                          ? null
                          : () {
                              if (state.isMenuItemEditing) {
                                BlocProvider.of<MenuBloc>(context)
                                    .add(EditMenuItemEvent(index));
                              } else {
                                BlocProvider.of<MenuBloc>(context).add(
                                  const AddMenuItemEvent(),
                                );
                              }
                              Navigator.of(context).pop();
                            },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (state.isMenuItemEditing) ...[
                      customButton(
                        context,
                        buttonName: AppLocalizations.of(context)!.delete,
                        horizontal: AppPaddingSize.largeHorizontal,
                        onPressed: () {
                          BlocProvider.of<MenuBloc>(context).add(
                            RemoveMenuItemEvent(
                              state.menuItem,
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ]
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
