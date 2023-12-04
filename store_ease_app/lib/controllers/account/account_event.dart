part of 'account_bloc.dart';

abstract class AccountEvent {
  const AccountEvent();
}

// UserInfo
class GetUserInfoEvent extends AccountEvent {
  const GetUserInfoEvent();
}

class UpdateUserInfoEvent extends AccountEvent {
  const UpdateUserInfoEvent();
  // final int languageId;
}

class ResetFirstNameEvent extends AccountEvent {
  const ResetFirstNameEvent(this.resetFirstName);
  final String resetFirstName;
}

class ResetLastNameEvent extends AccountEvent {
  const ResetLastNameEvent(this.resetLastName);
  final String resetLastName;
}
