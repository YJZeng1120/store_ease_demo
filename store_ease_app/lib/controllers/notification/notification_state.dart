part of 'notification_bloc.dart';

class NotificationState {
  NotificationState({
    required this.remoteMessageList,
    required this.isReceivingRemoteMessage,
    required this.getOrderStoreId,
    required this.receiveStatus,
    required this.deleteStatus,
    required this.status,
    required this.errorMessage,
  });
  // Remote Message
  final List<RemoteMessage?> remoteMessageList;
  final bool isReceivingRemoteMessage;
  final String getOrderStoreId;
  final LoadStatus receiveStatus;

  // Delete FCM Token
  final LoadStatus deleteStatus;

  // Common
  final LoadStatus status;
  final String errorMessage;

  factory NotificationState.initial() => NotificationState(
        remoteMessageList: const <RemoteMessage?>[],
        isReceivingRemoteMessage: false,
        getOrderStoreId: '',
        receiveStatus: LoadStatus.initial,
        deleteStatus: LoadStatus.initial,
        status: LoadStatus.initial,
        errorMessage: '',
      );

  NotificationState copyWith({
    List<RemoteMessage?>? remoteMessageList,
    bool? isReceivingRemoteMessage,
    String? getOrderStoreId,
    LoadStatus? receiveStatus,
    LoadStatus? deleteStatus,
    LoadStatus? status,
    String? errorMessage,
  }) {
    return NotificationState(
      remoteMessageList: remoteMessageList ?? this.remoteMessageList,
      isReceivingRemoteMessage:
          isReceivingRemoteMessage ?? this.isReceivingRemoteMessage,
      getOrderStoreId: getOrderStoreId ?? this.getOrderStoreId,
      receiveStatus: receiveStatus ?? this.receiveStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
