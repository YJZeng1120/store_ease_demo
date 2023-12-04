import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/enums/load_status_enum.dart';
import '../../../models/user.dart';
import '../../../services/api_user.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserApi _userApi;
  RegisterBloc(
    this._userApi,
  ) : super(RegisterState.initial()) {
    _onEvent();
  }

  void _onEvent() {
    // Register
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

    on<FirstNameEvent>((event, emit) {
      emit(state.copyWith(firstName: event.firstName));
    });

    on<LastNameEvent>((event, emit) {
      emit(state.copyWith(lastName: event.lastName));
    });

    on<CreateUserEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      final failureOption = await _userApi.createUser(
        User(
          emailAddress: event.emailAddress,
          password: state.password,
          firstName: state.firstName,
          lastName: state.lastName,
          languageId: event.languageId,
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
