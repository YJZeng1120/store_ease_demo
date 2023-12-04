import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../http.dart';
import '../models/core/api_config.dart';
import '../models/dto/menu_dto.dart';
import '../models/menu.dart';

class StoreMenuApi {
  Future<Option<String>> createReference(
    String userId,
    String storeId,
    String menuId,
  ) async {
    try {
      final String path = ApiConfig.usersWithId(userId) +
          ApiConfig.storesWithId(storeId) +
          ApiConfig.menusWithId(menuId);
      await dio.post(path);

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

  Future<Either<String, Menu>> getMenuByStoreId(
    String storeId,
    int languageId,
  ) async {
    try {
      final String params =
          '?${ApiConfig.languageParam(languageId)}&${ApiConfig.userTypeParam()}';
      final String path =
          ApiConfig.storesWithId(storeId) + ApiConfig.menus + params;
      final response = await dio.get(path);

      final Menu menu = MenuDto.fromJson(response.data).toModel();

      return right(menu);
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

  Future<Option<String>> updateReference(
    String userId,
    String storeId,
    String menuId,
  ) async {
    try {
      final String path = ApiConfig.usersWithId(userId) +
          ApiConfig.storesWithId(storeId) +
          ApiConfig.menusWithId(menuId);
      await dio.patch(path);

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
