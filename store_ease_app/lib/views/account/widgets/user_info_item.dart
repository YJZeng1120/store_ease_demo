import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../controllers/account/account_bloc.dart';
import '../../../models/core/theme.dart';
import '../../../routes/app_router.dart';

Widget userInfoItem({
  required String title,
  required String userInfo,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: AppTextStyle.text(
          color: const Color.fromARGB(255, 92, 92, 92),
        ),
      ),
      const SizedBox(
        height: 4,
      ),
      Row(
        children: [
          Text(
            userInfo,
            style: AppTextStyle.heading3(),
          ),
        ],
      )
    ],
  );
}

Widget emailInfoItem() {
  return BlocBuilder<AccountBloc, AccountState>(
    builder: (context, state) {
      return Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppPaddingSize.compactVertical,
          horizontal: AppPaddingSize.largeHorizontal,
        ),
        child: Row(
          children: [
            userInfoItem(
              title: AppLocalizations.of(context)!.email,
              userInfo: state.userInfo.emailAddress,
            ),
            const Spacer(),
            const Icon(
              Icons.lock,
              size: 16,
              color: Color.fromARGB(255, 92, 92, 92),
            ),
          ],
        ),
      );
    },
  );
}

Widget userInfoButton() {
  return BlocBuilder<AccountBloc, AccountState>(
    builder: (context, state) {
      return InkWell(
        highlightColor: const Color.fromARGB(255, 197, 197, 197),
        splashFactory: NoSplash.splashFactory,
        onTap: () {
          Navigator.of(context).pushReplacementNamed(AppRoutes.resetInfo);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppPaddingSize.compactVertical,
            horizontal: AppPaddingSize.largeHorizontal,
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userInfoItem(
                    title: AppLocalizations.of(context)!.lastName,
                    userInfo: state.userInfo.lastName,
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  userInfoItem(
                    title: AppLocalizations.of(context)!.firstName,
                    userInfo: state.userInfo.firstName,
                  ),
                ],
              ),
              const Spacer(),
              AppIcon.arrowForward,
            ],
          ),
        ),
      );
    },
  );
}
