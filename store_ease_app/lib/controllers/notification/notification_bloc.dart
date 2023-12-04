import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/core/cache_helper.dart';
import '../../models/core/fcm_helper.dart';
import '../../models/enums/load_status_enum.dart';
import '../../services/api_fcm.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final FCMApi _fcmApi;
  NotificationBloc(
    this._fcmApi,
  ) : super(NotificationState.initial()) {
    _onEvent();
  }

  void _onEvent() {
    // Create FCM Token
    on<CreateTokenEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      String? token = await NotificationHelper.getFcmToken();
      if (token != null) {
        final failureOption = await _fcmApi.createFcmToken(
          CacheHelper.getUserId(),
          token,
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
      }
    });

    // Update FCM Message
    on<CreateFcmListenerEvent>((event, emit) async {
      await NotificationHelper.getFcmToken();
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        add(
          const IsReceivingRemoteMessageEvent(true),
        );
        add(
          AddRemoteMessageListEvent(
            message,
          ),
        );
      });
    });

    on<IsReceivingRemoteMessageEvent>((event, emit) {
      emit(
        state.copyWith(
          isReceivingRemoteMessage: event.isReceivingRemoteMessage,
        ),
      );
    });

    on<AddRemoteMessageListEvent>((event, emit) {
      emit(
        state.copyWith(
          receiveStatus: LoadStatus.inProgress,
        ),
      );
      final updatedList = List.of(state.remoteMessageList);
      updatedList.add(
        event.message,
      );
      final String getOrderStoreId = event.message?.notification!.body ?? '';
      emit(
        state.copyWith(
          receiveStatus: LoadStatus.succeed,
          getOrderStoreId: getOrderStoreId,
          remoteMessageList: updatedList,
        ),
      );
    });

    on<RemoveRemoteMessageListEvent>((event, emit) {
      final updatedList = List.of(state.remoteMessageList);
      updatedList.removeWhere(
        (message) => message?.notification!.body == event.storeId,
      );
      emit(state.copyWith(remoteMessageList: updatedList));
    });

    // Delete FCM Token
    on<DeleteTokenEvent>((event, emit) async {
      emit(
        state.copyWith(
          deleteStatus: LoadStatus.inProgress,
        ),
      );
      String? token = await NotificationHelper.getFcmToken();
      if (token != null) {
        final failureOption = await _fcmApi.deleteFcmToken(
          CacheHelper.getUserId(),
          token,
        );
        await NotificationHelper.deleteFcmToken();
        await CacheHelper.removeUserId();
        failureOption.fold(
          () => emit(
            state.copyWith(
              deleteStatus: LoadStatus.succeed,
            ),
          ),
          (f) => emit(
            state.copyWith(
              deleteStatus: LoadStatus.failed,
              errorMessage: f,
            ),
          ),
        );
      }
    });
  }
}
