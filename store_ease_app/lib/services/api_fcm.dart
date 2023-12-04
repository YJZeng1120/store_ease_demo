import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../http.dart';
import '../models/core/api_config.dart';

class FCMApi {
  Future<Option<String>> createFcmToken(
    String userId,
    String token,
  ) async {
    try {
      const String path = ApiConfig.fcmTokens;
      await dio.post(
        path,
        data: {"userId": userId, "token": token},
      );

      return none();
    } catch (e) {
      if (e is DioException && e.response != null) {
        logger.w(e.response?.data);
        final String errorMessage = e.response?.data['message'];
        return some(errorMessage);
      } else {
        logger.e(e);
        return some('Unexpected Error');
      }
    }
  }

  Future<Option<String>> deleteFcmToken(
    String userId,
    String token,
  ) async {
    try {
      const String path = ApiConfig.fcmTokens;
      await dio.delete(
        path,
        data: {"userId": userId, "token": token},
      );

      return none();
    } catch (e) {
      if (e is DioException && e.response != null) {
        logger.w(e.response?.data);
        final String errorMessage = e.response?.data['message'];
        return some(errorMessage);
      } else {
        logger.e(e);
        return some('Unexpected Error');
      }
    }
  }
}
