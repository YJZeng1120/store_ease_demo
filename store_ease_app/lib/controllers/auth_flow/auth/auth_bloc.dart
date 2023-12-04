import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/enums/load_status_enum.dart';
import '../../../services/api_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserApi _userApi;

  AuthBloc(
    this._userApi,
  ) : super(AuthState.initial()) {
    _onEvent();
  }

  void _onEvent() {
    // Auth
    on<EmailAddressEvent>((event, emit) {
      emit(state.copyWith(emailAddress: event.emailAddress));
    });

    on<CheckHasUserEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
        ),
      );
      final failureOrSuccess = await _userApi.getUserIdByEmail(
        state.emailAddress,
      );
      failureOrSuccess.fold(
        (f) => emit(
          state.copyWith(
            status: LoadStatus.failed,
          ),
        ),
        (userId) => emit(
          state.copyWith(
            userId: userId,
            status: LoadStatus.succeed,
          ),
        ),
      );
    });
  }
}
