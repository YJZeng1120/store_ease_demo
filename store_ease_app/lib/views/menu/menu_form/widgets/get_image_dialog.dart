import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../controllers/menu/menu_bloc.dart';
import '../../../../models/enums/load_status_enum.dart';
import '../../../common_widgets/custom_button.dart';
import '../../../common_widgets/custom_dialog.dart';

dynamic getImageDialog(
  BuildContext context,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return BlocListener<MenuBloc, MenuState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status == LoadStatus.succeed) {
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<MenuBloc, MenuState>(
          builder: (context, state) {
            return customAlertDialog(
              context,
              title: AppLocalizations.of(context)!.mealPhotoDialogTitle,
              contentWidget: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.mealPhotoDialogContent,
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  customButton(
                    context,
                    buttonName: AppLocalizations.of(context)!.image,
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    onPressed: () => BlocProvider.of<MenuBloc>(context).add(
                      const GetImageFromGalleryEvent(),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  customButton(
                    context,
                    buttonName: AppLocalizations.of(context)!.camera,
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    onPressed: () => BlocProvider.of<MenuBloc>(context).add(
                      const GetImageFromCameraEvent(),
                    ),
                  ),
                  if (state.menuItem.imageBytes.isNotEmpty)
                    const SizedBox(
                      height: 6,
                    ),
                  if (state.menuItem.imageBytes.isNotEmpty)
                    customButton(
                      context,
                      buttonName: AppLocalizations.of(context)!.removeImage,
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary,
                      onPressed: () {
                        BlocProvider.of<MenuBloc>(context).add(
                          UpdateMenuItemDataEvent(
                            state.menuItem.copyWith(
                              imageBytes: Uint8List(0),
                            ),
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
