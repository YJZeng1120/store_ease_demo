import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../http.dart';
import '../models/core/api_config.dart';
import '../models/dto/user_dto.dart';
import '../models/user.dart';

class UserApi {
  Future<Either<bool, String>> getUserIdByEmail(
    String userEmail,
  ) async {
    try {
      final String params =
          '?${ApiConfig.userTypeParam()}&${ApiConfig.methodParam(ApiMethod.email)}&${ApiConfig.emailParam(userEmail)}';
      final String path = ApiConfig.users + ApiConfig.login + params;
      final response = await dio.get(path);

      return right(response.data);
    } catch (e) {
      if (e is DioException && e.response != null) {
        logger.w(e.response?.data);
        return left(false);
      } else {
        logger.e(e);
        return left(false);
      }
    }
  }

  Future<Either<bool, String>> getUserIdByUid(
    String uid,
  ) async {
    try {
      final String params =
          '?${ApiConfig.userTypeParam()}&${ApiConfig.methodParam(ApiMethod.uid)}&${ApiConfig.uidParam(uid)}';
      final String path = ApiConfig.users + ApiConfig.login + params;
      final response = await dio.get(path);

      return right(response.data);
    } catch (e) {
      if (e is DioException && e.response != null) {
        logger.w(e.response?.data);
        return left(false);
      } else {
        logger.e(e);
        return left(false);
      }
    }
  }

  Future<Option<String>> createUser(
    User user,
  ) async {
    try {
      const String path = ApiConfig.users;
      await dio.post(
        path,
        data: UserDto.fromModel(user).toCreateJson(),
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

  Future<Option<String>> resetPassword(
    String userId,
    User user,
  ) async {
    try {
      const String path = ApiConfig.users + ApiConfig.resetPassword;
      await dio.post(
        path,
        data: UserDto.fromModel(user).toResetPasswordJson(userId),
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

  Future<Either<String, User>> getUserInfoById(
    String userId,
  ) async {
    try {
      final String path = ApiConfig.usersWithId(userId);
      final response = await dio.get(path);

      final User userInfo = UserDto.fromJson(response.data).toModel();

      return right(userInfo);
    } catch (e) {
      if (e is DioException && e.response != null) {
        logger.w(e.response?.data);
        final String errorMessage = e.response?.data['message'];
        return left(errorMessage);
      } else {
        logger.e(e);
        return left('Unexpected Error');
      }
    }
  }

  Future<Option<String>> updateUserInfo(
    String userId,
    User user,
  ) async {
    try {
      final String path = ApiConfig.usersWithId(userId);
      await dio.patch(
        path,
        data: UserDto.fromModel(user).toUpdateJson(),
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

  Future<Option<String>> deleteUser(
    String userId,
  ) async {
    try {
      final String path = ApiConfig.usersWithId(userId);
      await dio.delete(path);

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
