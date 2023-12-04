import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../controllers/store/store_bloc.dart';
import '../../../models/core/validators.dart';
import '../../../models/enums/load_status_enum.dart';
import '../../../routes/app_router.dart';
import '../../common_widgets/custom_dialog.dart';
import '../../common_widgets/custom_divider.dart';
import '../../common_widgets/loading_overlay.dart';
import '../../common_widgets/page_layout.dart';
import '../store_list/widgets/store_input.dart';
import 'widgets/opening_hours_bottom_sheet.dart';
import 'widgets/opening_hours_widget.dart';

class StoreFormPage extends StatelessWidget {
  const StoreFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<StoreBloc, StoreState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == LoadStatus.succeed) {
          if (state.isEditing) {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.storeBottomTabs,
            );
          } else {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.appBottomTabs,
            );
          }
          LoadingOverlay.hide();
        } else if (state.status == LoadStatus.inProgress) {
          LoadingOverlay.show(context);
        } else if (state.status == LoadStatus.failed) {
          LoadingOverlay.hide();
          systemErrorDialog(context);
        }
      },
      child: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          return PageLayout(
            horizontal: 0,
            appBarTitle: state.isEditing
                ? AppLocalizations.of(context)!.editStore
                : AppLocalizations.of(context)!.addStore,
            leading: backButton(
              context,
              previousRouteName: state.isEditing
                  ? AppRoutes.storeBottomTabs
                  : AppRoutes.appBottomTabs,
            ),
            actions: [
              state.isEditing
                  ? IconButton(
                      onPressed: () {
                        BlocProvider.of<StoreBloc>(context).add(
                          UpdateStoreEvent(
                            state.store.storeId ?? '',
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.done,
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        if (storeValidator(context)) {
                          customDialog(context,
                              title: AppLocalizations.of(context)!
                                  .completeStoreDialogTitle,
                              contentWidget: Text(
                                AppLocalizations.of(context)!
                                    .completeStoreDialogContent,
                              ),
                              actions: [
                                dialogButton(
                                  context,
                                  buttonText: AppLocalizations.of(context)!
                                      .confirmButton,
                                  onPressed: () => Navigator.of(context).pop(),
                                )
                              ]);
                        } else {
                          BlocProvider.of<StoreBloc>(context)
                              .add(const CreateStoreEvent());
                        }
                      },
                      icon: const Icon(
                        Icons.add,
                      ),
                    ),
            ],
            body: Column(
              children: [
                storeInput(
                  initialValue: state.isEditing ? state.store.storeName : null,
                  title: AppLocalizations.of(context)!.storeName,
                  hintText: AppLocalizations.of(context)!.enterStoreName,
                  onChanged: (value) => context.read<StoreBloc>().add(
                        UpdateStoreDataEvent(
                          state.store.copyWith(
                            storeName: value,
                          ),
                        ),
                      ),
                ),
                storeInput(
                  initialValue: state.isEditing ? state.store.phone : null,
                  title: AppLocalizations.of(context)!.phone,
                  hintText: AppLocalizations.of(context)!.enterPhone,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => context.read<StoreBloc>().add(
                        UpdateStoreDataEvent(
                          state.store.copyWith(
                            phone: value,
                          ),
                        ),
                      ),
                ),
                storeInput(
                  initialValue: state.isEditing ? state.store.address : null,
                  title: AppLocalizations.of(context)!.address,
                  hintText: AppLocalizations.of(context)!.enterAddress,
                  onChanged: (value) => context.read<StoreBloc>().add(
                        UpdateStoreDataEvent(
                          state.store.copyWith(
                            address: value,
                          ),
                        ),
                      ),
                ),
                descriptionInput(
                  title: AppLocalizations.of(context)!.storeDescription,
                  initialValue:
                      state.isEditing ? state.store.description : null,
                  hintText: AppLocalizations.of(context)!.enterStoreDescription,
                  onChanged: (value) => context.read<StoreBloc>().add(
                        UpdateStoreDataEvent(
                          state.store.copyWith(
                            description: value,
                          ),
                        ),
                      ),
                ),
                const SizedBox(
                  height: 14,
                ),
                customDivider(
                  thickness: 6,
                ),
                storeInputContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          storeInputText(
                            title: AppLocalizations.of(context)!
                                .addStoreOpeningHours,
                          ),
                          IconButton(
                            onPressed: () {
                              openingHoursBottomSheet(context);
                            },
                            icon: const Icon(
                              Icons.add_circle_outline,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Column(
                        children: state.storeOpeningHoursList
                            .map<Widget>(
                              (storeOpeningHours) => openingHours(
                                context,
                                storeOpeningHours,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
