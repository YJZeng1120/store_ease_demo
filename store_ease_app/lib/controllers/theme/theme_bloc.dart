import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import '../../functions/language_utility.dart';
import '../../models/core/cache_helper.dart';
import '../../models/enums/load_status_enum.dart';
import '../../models/user.dart';
import '../../services/api_user.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final UserApi _userApi;
  ThemeBloc(
    this._userApi,
  ) : super(ThemeState.initial()) {
    _onEvent();
  }
  void _onEvent() {
    on<InitialEvent>((event, emit) {
      final Locale deviceLocale = PlatformDispatcher.instance.locale;
      final String appLanguage = CacheHelper.getLanguageCode();

      // 預設值為裝置locale，如prefs有存就讀prefs
      final String languageCodeToUse = appLanguage.isEmpty
          ? (supportedLocale.contains(deviceLocale)
              ? deviceLocale.languageCode // 如果系統預設語言在支援清單中，使用系統預設語言
              : supportedLocale.first.languageCode) // 否則，使用支援清單中的第一個語言
          : appLanguage;

      final int languageId = getLanguageIdByCode(languageCodeToUse);
      emit(
        state.copyWith(
          languageCode: languageCodeToUse,
          languageId: languageId,
        ),
      );
    });

    on<ChangeLanguageEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
        ),
      );
      CacheHelper.saveLanguageCode(event.languageCode);
      final String userId = CacheHelper.getUserId();
      final int languageId = getLanguageIdByCode(event.languageCode);

      final failureOption = await _userApi.updateUserInfo(
        userId,
        User.empty().copyWith(
          languageId: languageId,
        ),
      );

      failureOption.fold(
        () => emit(
          state.copyWith(
            status: LoadStatus.succeed,
            languageCode: event.languageCode,
            languageId: languageId,
          ),
        ),
        (f) => emit(
          state.copyWith(
            status: LoadStatus.failed,
          ),
        ),
      );
    });
  }
}
