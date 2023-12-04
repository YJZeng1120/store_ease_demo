import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../models/enums/load_status_enum.dart';
import '../../../services/api_otp.dart';

part 'verify_event.dart';
part 'verify_state.dart';

class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  final OTPApi _otpApi;
  VerifyBloc(
    this._otpApi,
  ) : super(VerifyState.initial()) {
    _onEvent();
  }

  void _onEvent() {
    // Verify
    on<SendOTPEvent>((event, emit) async {
      emit(
        state.copyWith(
          errorMessage: '',
        ),
      );
      final failureOption = await _otpApi.createOTP(
        event.emailAddress,
        state.token!, // token為自動產生
      );
      failureOption.fold(
        () => log(
          'Success, create:${state.token!}',
        ),
        (f) => emit(
          state.copyWith(
            errorMessage: f,
          ),
        ),
      );
    });

    on<VerifyOTPEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      final failureOption = await _otpApi.verifyOTP(
        state.token!,
        state.verificationCode,
      );
      failureOption.fold(
        () => emit(
          state.copyWith(
            status: LoadStatus.succeed,
          ),
        ),
        (f) => emit(
          state.copyWith(
            verifyAttempts: state.verifyAttempts += 1,
            status: LoadStatus.failed,
            errorMessage: f,
          ),
        ),
      );
    });

    on<VerificationCodeEvent>((event, emit) {
      emit(
        state.copyWith(
          verificationCode: event.verificationCode,
        ),
      );
    });

    // Reset Verify Step
    on<ResetAuthProcessEvent>((event, emit) {
      emit(
        state.copyWith(
          token: const Uuid().v4(),
          verifyAttempts: 0,
        ),
      );
    });
  }
}
