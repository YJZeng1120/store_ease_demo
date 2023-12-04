import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../controllers/category/category_bloc.dart';
import '../../../../controllers/theme/theme_bloc.dart';
import '../../../../models/category.dart';
import '../../../../models/core/api_error_message.dart';
import '../../../../models/core/screen.dart';
import '../../../../models/core/theme.dart';
import '../../../../models/enums/load_status_enum.dart';
import '../../../common_widgets/custom_dialog.dart';
import '../../../common_widgets/loading_overlay.dart';
import '../../../common_widgets/tap_out_dismiss_keyboard.dart';
import 'category_input.dart';

dynamic categoryDialog(
  BuildContext context,
) {
  return showDialog(
    context: context,
    builder: (context) {
      ThemeState themeState = context.read<ThemeBloc>().state;
      return MultiBlocListener(
        listeners: [
          BlocListener<CategoryBloc, CategoryState>(
            listenWhen: (p, c) => p.deleteStatus != c.deleteStatus,
            listener: (context, state) {
              if (state.deleteStatus == LoadStatus.succeed) {
                BlocProvider.of<CategoryBloc>(context).add(
                  GetCategoryEvent(
                    themeState.languageId,
                  ),
                );
              } else if (state.deleteStatus == LoadStatus.inProgress) {
                LoadingOverlay.show(context);
              } else if (state.deleteStatus == LoadStatus.failed) {
                LoadingOverlay.hide();
                if (state.errorMessage ==
                    ApiErrorMessage.categoryIsAlreadyUsed) {
                  customDialog(context,
                      title: AppLocalizations.of(context)!.unableDelete,
                      contentWidget: Text(
                        AppLocalizations.of(context)!.unableDeleteContent,
                      ),
                      actions: [
                        dialogButton(
                          context,
                          buttonText:
                              AppLocalizations.of(context)!.confirmButton,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ]);
                }
              }
            },
          ),
          BlocListener<CategoryBloc, CategoryState>(
            listenWhen: (p, c) => p.status != c.status,
            listener: (context, state) {
              if (state.status == LoadStatus.succeed) {
                LoadingOverlay.hide();
              }
            },
          ),
        ],
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            return customAlertDialog(context,
                insetPadding: EdgeInsets.zero,
                title: AppLocalizations.of(context)!.selectCategory,
                contentWidget: Container(
                  alignment: Alignment.centerLeft,
                  height: screenHeight / 3,
                  width: screenWidth / 2,
                  child: Scrollbar(
                    child: ListView.builder(
                        itemCount: state.allCategoryList.length,
                        itemBuilder: (context, index) {
                          final Category category =
                              state.allCategoryList[index];
                          final bool isSelected = state.category == category;
                          final bool isDefault = category.isDefault ?? false;
                          final bool isLast =
                              index == state.allCategoryList.length - 1;
                          return GestureDetector(
                            onTap: () {
                              BlocProvider.of<CategoryBloc>(context).add(
                                SelectCategoryEvent(
                                  category,
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: AppPaddingSize.smallVertical,
                                      ),
                                      child: Text(
                                        category.title.toUpperCase(),
                                        overflow: TextOverflow.clip,
                                        style: AppTextStyle.heading3(
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.grey,
                                        ),
                                      ),
                                    ),
                                    if (isDefault == false) ...[
                                      const Spacer(),
                                      // 刪除Category按鈕x
                                      GestureDetector(
                                        onTap: () {
                                          BlocProvider.of<CategoryBloc>(context)
                                              .add(
                                            DeleteCategoryEvent(
                                              category.id ?? 0,
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.delete_outline,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 14,
                                      ),
                                      // 編輯Category按鈕
                                      GestureDetector(
                                        onTap: () {
                                          BlocProvider.of<CategoryBloc>(context)
                                              .add(
                                            CategoryInitialEvent(
                                              category,
                                            ),
                                          );
                                          categoryFormDialog(context);
                                        },
                                        child: const Icon(
                                          Icons.edit,
                                        ),
                                      )
                                    ],
                                  ],
                                ),
                                if (isLast)
                                  // 新增Category按鈕
                                  GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<CategoryBloc>(context)
                                          .add(
                                        CategoryInitialEvent(
                                          Category.empty(),
                                        ),
                                      );
                                      categoryFormDialog(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: AppPaddingSize.mediumVertical,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.add_circle_outline,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!.add,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          );
                        }),
                  ),
                ),
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                actions: [
                  cancelDialogButton(
                    context,
                  ),
                  dialogButton(
                    context,
                    buttonText: AppLocalizations.of(context)!.add,
                    onPressed: () {
                      BlocProvider.of<CategoryBloc>(context).add(
                        AddCategoryEvent(
                          state.category,
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                  )
                ]);
          },
        ),
      );
    },
  );
}

dynamic categoryFormDialog(
  BuildContext context,
) {
  return showDialog(
    context: context,
    builder: (context) {
      ThemeState themeState = context.read<ThemeBloc>().state;
      return BlocListener<CategoryBloc, CategoryState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status == LoadStatus.succeed) {
            LoadingOverlay.hide();
            Navigator.of(context).pop();
          } else if (state.status == LoadStatus.inProgress) {
            LoadingOverlay.show(context);
          } else if (state.status == LoadStatus.failed) {
            LoadingOverlay.hide();
            systemErrorDialog(context);
          }
        },
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            return TapOutDismissKeyboard(
              child: customAlertDialog(context,
                  title: state.isEditing
                      ? AppLocalizations.of(context)!.editCategory
                      : AppLocalizations.of(context)!.addCategory,
                  contentWidget: categoryInput(context),
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  actions: [
                    cancelDialogButton(context),
                    state.isEditing
                        ? dialogButton(
                            context,
                            buttonText:
                                AppLocalizations.of(context)!.confirmButton,
                            onPressed: () {
                              BlocProvider.of<CategoryBloc>(context).add(
                                UpdateCategoryEvent(
                                  themeState.languageId,
                                ),
                              );
                            },
                          )
                        : dialogButton(
                            context,
                            buttonText: AppLocalizations.of(context)!.add,
                            onPressed: () {
                              BlocProvider.of<CategoryBloc>(context).add(
                                CreateCategoryEvent(
                                  themeState.languageId,
                                ),
                              );
                            },
                          ),
                  ]),
            );
          },
        ),
      );
    },
  );
}
