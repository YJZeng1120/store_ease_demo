import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/core/cache_helper.dart';
import '../../../models/enums/load_status_enum.dart';
import '../../../services/api_firebase.dart';
import '../../../services/api_user.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseApi _firebaseApi;
  final UserApi _userApi;
  LoginBloc(
    this._firebaseApi,
    this._userApi,
  ) : super(LoginState.initial()) {
    _onEvent();
  }

  void _onEvent() {
    on<LoginPasswordEvent>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<LoginPasswordVisibleEvent>((event, emit) {
      bool visible = state.isPasswordVisible;
      visible = !visible;
      emit(
        state.copyWith(
          isPasswordVisible: visible,
        ),
      );
    });

    on<LoginWithEmailEvent>((event, emit) async {
      emit(
        state.copyWith(
          errorMessage: '',
          status: LoadStatus.inProgress,
        ),
      );
      final failureOption = await _firebaseApi.loginUser(
        event.emailAddress,
        event.password,
      );
      failureOption.fold(
        () {
          if (event.userId != '' && event.userId != null) {
            CacheHelper.saveUserId(event.userId!);
          } else {
            add(
              const GetUserIdByUidEvent(),
            ); // Register並登入時使用此Event
          }
          emit(
            state.copyWith(
              status: LoadStatus.succeed,
            ),
          );
        },
        (f) => emit(
          state.copyWith(
            errorMessage: f,
            status: LoadStatus.failed,
          ),
        ),
      );
    });

    on<GetUserIdByUidEvent>((event, emit) async {
      emit(
        state.copyWith(
          userId: '',
        ),
      );
      final String uid = await _firebaseApi.getUid();
      log('uid: $uid');
      final failureOption = await _userApi.getUserIdByUid(uid);
      failureOption.fold(
        (f) => log("$f"),
        (userId) {
          CacheHelper.saveUserId(userId);
          emit(
            state.copyWith(
              userId: userId,
            ),
          );
        },
      );
    });
  }
}
