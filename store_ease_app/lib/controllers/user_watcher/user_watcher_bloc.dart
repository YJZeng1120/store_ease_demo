import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/core/cache_helper.dart';
import '../../models/enums/load_status_enum.dart';
import '../../services/api_firebase.dart';
import '../../services/api_user.dart';

part 'user_watcher_event.dart';
part 'user_watcher_state.dart';

class UserWatcherBloc extends Bloc<UserWatcherEvent, UserWatcherState> {
  final FirebaseApi _firebaseApi;
  final UserApi _userApi;

  UserWatcherBloc(
    this._firebaseApi,
    this._userApi,
  ) : super(UserWatcherState.initial()) {
    _onEvent();
  }

  void _onEvent() {
    // LoginCache
    on<CacheLoginInfoEvent>((event, emit) async {
      emit(
        state.copyWith(
          authStatus: LoadStatus.inProgress,
        ),
      );
      final firebaseCurrentUser = _firebaseApi.getCurrentUser();
      await Future.delayed(
        const Duration(
          seconds: 1,
        ),
      );
      if (firebaseCurrentUser != null) {
        emit(
          state.copyWith(
            loggedIn: true,
            authStatus: LoadStatus.succeed,
          ),
        );
      } else {
        emit(
          state.copyWith(
            loggedIn: false,
            authStatus: LoadStatus.succeed,
          ),
        );
      }
    });

    // Logout
    on<LogoutEvent>((event, emit) async {
      emit(
        state.copyWith(
          authStatus: LoadStatus.inProgress,
        ),
      );
      await _firebaseApi.logOut();
      emit(
        state.copyWith(
          authStatus: LoadStatus.succeed,
          loggedIn: false,
        ),
      );
    });

    // Delete account
    on<VerifyPasswordEvent>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<DeleteVerifyEvent>((event, emit) async {
      emit(
        state.copyWith(
          deleteStatus: LoadStatus.inProgress,
          errorMessage: '',
          isDeleted: false,
        ),
      );
      final failureOption = await _firebaseApi.verifyUser(
        event.email,
        event.password,
      );
      failureOption.fold(
        () => emit(
          state.copyWith(
            isDeleted: true,
            deleteStatus: LoadStatus.succeed,
          ),
        ),
        (f) => emit(
          state.copyWith(
            errorMessage: f,
            isDeleted: false,
            deleteStatus: LoadStatus.failed,
            //  deleteStatus: LoadStatus.succeed,
          ),
        ),
      );
    });

    on<DeleteUserEvent>((event, emit) async {
      final String userId = CacheHelper.getUserId();
      final failureOption = await _userApi.deleteUser(
        userId,
      );

      failureOption.fold(
        () async {
          emit(
            state.copyWith(
              loggedIn: false,
            ),
          );
          CacheHelper.removeUserId;
          await _firebaseApi.logOut();
        },
        (f) => log(f),
      );
    });

    on<ResetErrorMessageEvent>(
      (event, emit) => emit(
        state.copyWith(errorMessage: ''),
      ),
    );
  }
}
