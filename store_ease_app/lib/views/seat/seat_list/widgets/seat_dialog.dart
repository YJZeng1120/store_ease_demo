import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ordering_system/models/enums/load_status_enum.dart';
import 'package:ordering_system/views/common_widgets/loading_overlay.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../controllers/seat/seat_bloc.dart';
import '../../../../controllers/store/store_bloc.dart';
import '../../../../models/core/screen.dart';
import '../../../../models/core/theme.dart';
import '../../../../routes/app_router.dart';
import '../../../common_widgets/custom_dialog.dart';

dynamic seatDialog(
  BuildContext context,
) {
  return showDialog(
    context: context,
    builder: (context) {
      final SeatState seatState = context.read<SeatBloc>().state;
      final StoreState storeState = context.read<StoreBloc>().state;
      final ScreenshotController screenshotController = ScreenshotController();
      return BlocListener<SeatBloc, SeatState>(
        listenWhen: (p, c) => p.imageStatus != c.imageStatus,
        listener: (context, state) {
          if (state.imageStatus == LoadStatus.succeed) {
            LoadingOverlay.hide();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.saveQRCode,
                ),
              ),
            );
          } else if (state.imageStatus == LoadStatus.inProgress) {
            LoadingOverlay.show(context);
          } else if (state.imageStatus == LoadStatus.failed) {
            LoadingOverlay.hide();
            systemErrorDialog(context);
          }
        },
        child: customAlertDialog(
          context,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          contentWidget: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppPaddingSize.mediumVertical,
                ),
                child: Row(
                  children: [
                    // Save QRcode
                    InkWell(
                      borderRadius: BorderRadius.circular(
                        AppBorderRadius.large,
                      ),
                      onTap: () => BlocProvider.of<SeatBloc>(context).add(
                        SaveImageEvent(
                          screenshotController,
                          seatState.seat.title,
                        ),
                      ),
                      child: const Icon(
                        Icons.download,
                      ),
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    // Delete seat
                    InkWell(
                      borderRadius: BorderRadius.circular(
                        AppBorderRadius.large,
                      ),
                      onTap: () {
                        customDialog(context,
                            title: AppLocalizations.of(context)!.deleteSeat,
                            contentWidget: Text(
                              AppLocalizations.of(context)!.deleteSeatContent,
                            ),
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            actions: [
                              cancelDialogButton(
                                context,
                              ),
                              dialogButton(
                                context,
                                buttonText:
                                    AppLocalizations.of(context)!.delete,
                                onPressed: () {
                                  BlocProvider.of<SeatBloc>(context).add(
                                    DeleteSeatEvent(
                                      storeState.store.storeId ?? '',
                                      seatState.seat.seatId ?? 0,
                                    ),
                                  );
                                },
                              ),
                            ]);
                      },
                      child: const Icon(
                        Icons.delete_outline,
                      ),
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    // Edit seat
                    InkWell(
                      borderRadius: BorderRadius.circular(
                        AppBorderRadius.large,
                      ),
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.seatForm,
                          (route) => false,
                        );
                      },
                      child: const Icon(
                        Icons.edit,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close,
                      ),
                    ),
                  ],
                ),
              ),
              Screenshot(
                controller: screenshotController,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        width: screenWidth / 1.5,
                        height: screenWidth / 1.5,
                        child: QrImageView(
                          data:
                              '${storeState.store.storeId}_${seatState.seat.seatId}',
                          version: QrVersions.auto,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppPaddingSize.largeVertical,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.room_service_outlined,
                              size: 22,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              seatState.seat.title,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
