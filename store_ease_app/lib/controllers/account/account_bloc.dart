import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/core/cache_helper.dart';
import '../../models/enums/load_status_enum.dart';
import '../../models/user.dart';
import '../../services/api_user.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final UserApi _userApi;

  AccountBloc(
    this._userApi,
  ) : super(AccountState.initial()) {
    _onEvent();
  }

  void _onEvent() {
    on<GetUserInfoEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
        ),
      );
      final String userId = CacheHelper.getUserId();
      final failureOrSuccess = await _userApi.getUserInfoById(userId);
      failureOrSuccess.fold(
        (f) => emit(
          state.copyWith(
            status: LoadStatus.failed,
          ),
        ),
        (userInfo) => emit(
          state.copyWith(
            userInfo: userInfo,
            status: LoadStatus.succeed,
          ),
        ),
      );
    });

    on<UpdateUserInfoEvent>((event, emit) async {
      emit(
        state.copyWith(
          errorMessage: '',
        ),
      );
      final String userId = CacheHelper.getUserId();

      final failureOption = await _userApi.updateUserInfo(
        userId,
        state.userInfo.copyWith(
          firstName: state.resetFirstName,
          lastName: state.resetLastName,
        ),
      );
      failureOption.fold(
        () => add(
          const GetUserInfoEvent(),
        ),
        (f) => emit(
          state.copyWith(
            errorMessage: f,
          ),
        ),
      );
    });

    on<ResetFirstNameEvent>((event, emit) {
      emit(state.copyWith(resetFirstName: event.resetFirstName));
    });

    on<ResetLastNameEvent>((event, emit) {
      emit(state.copyWith(resetLastName: event.resetLastName));
    });
  }
}
