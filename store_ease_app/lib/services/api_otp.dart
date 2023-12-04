import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../http.dart';
import '../models/core/api_config.dart';

class OTPApi {
  Future<Option<String>> createOTP(
    String email,
    String token,
  ) async {
    try {
      const String path = ApiConfig.otp + ApiConfig.create;
      await dio.post(
        path,
        data: {"token": token, "email": email},
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

  Future<Option<String>> verifyOTP(
    String token,
    String verificationCode,
  ) async {
    try {
      const String path = ApiConfig.otp + ApiConfig.verify;
      await dio.post(
        path,
        data: {"token": token, "password": verificationCode},
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
