import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/enums/load_status_enum.dart';
import '../../../models/user.dart';
import '../../../services/api_user.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final UserApi _userApi;
  ForgotPasswordBloc(
    this._userApi,
  ) : super(ForgotPasswordState.initial()) {
    _onEvent();
  }

  void _onEvent() {
    on<PasswordEvent>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<PasswordVisibleEvent>((event, emit) {
      bool visible = state.isPasswordVisible;
      visible = !visible;
      emit(
        state.copyWith(
          isPasswordVisible: visible,
        ),
      );
    });

    on<ConfirmPasswordEvent>((event, emit) {
      emit(state.copyWith(confirmPassword: event.confirmPassword));
    });

    on<ConfirmPasswordVisibleEvent>((event, emit) {
      bool visible = state.isConfirmPasswordVisible;
      visible = !visible;
      emit(
        state.copyWith(
          isConfirmPasswordVisible: visible,
        ),
      );
    });

    on<ResetPasswordEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      final failureOption = await _userApi.resetPassword(
        event.userId,
        User.empty().copyWith(
          password: state.password,
        ),
      );
      failureOption.fold(
        () => emit(
          state.copyWith(
            status: LoadStatus.succeed,
          ),
        ),
        (f) => emit(
          state.copyWith(
            status: LoadStatus.failed,
            errorMessage: f,
          ),
        ),
      );
    });
  }
}
