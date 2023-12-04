part of 'verify_bloc.dart';

abstract class VerifyEvent {
  const VerifyEvent();
}

// Verify
class SendOTPEvent extends VerifyEvent {
  const SendOTPEvent(this.emailAddress);
  final String emailAddress;
}

class VerifyOTPEvent extends VerifyEvent {
  const VerifyOTPEvent();
}

class VerificationCodeEvent extends VerifyEvent {
  const VerificationCodeEvent(this.verificationCode);
  final String verificationCode;
}

// Reset Verify Step
class ResetAuthProcessEvent extends VerifyEvent {
  const ResetAuthProcessEvent();
}
