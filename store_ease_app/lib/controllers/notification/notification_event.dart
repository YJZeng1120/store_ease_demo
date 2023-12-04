part of 'notification_bloc.dart';

abstract class NotificationEvent {
  const NotificationEvent();
}

// Create FCM Token
class CreateTokenEvent extends NotificationEvent {
  const CreateTokenEvent();
}

// Update FCM Message
class CreateFcmListenerEvent extends NotificationEvent {
  const CreateFcmListenerEvent();
}

class IsReceivingRemoteMessageEvent extends NotificationEvent {
  const IsReceivingRemoteMessageEvent(this.isReceivingRemoteMessage);
  final bool isReceivingRemoteMessage;
}

class AddRemoteMessageListEvent extends NotificationEvent {
  const AddRemoteMessageListEvent(this.message);
  final RemoteMessage? message;
}

class RemoveRemoteMessageListEvent extends NotificationEvent {
  const RemoveRemoteMessageListEvent(this.storeId);
  final String storeId;
}

// Delete FCM Token
class DeleteTokenEvent extends NotificationEvent {
  const DeleteTokenEvent();
}
