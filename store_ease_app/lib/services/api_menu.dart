import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../http.dart';
import '../models/core/api_config.dart';
import '../models/dto/menu_dto.dart';
import '../models/menu.dart';

class MenuApi {
  Future<Option<String>> createMenu(
    Menu menu,
    String userId,
  ) async {
    try {
      final String path = ApiConfig.usersWithId(userId) + ApiConfig.menus;
      await dio.post(
        path,
        data: MenuDto.fromModel(menu).toJson(),
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

  Future<Either<String, List<Menu>>> getAllByUserId(
    int languageId,
    String userId,
  ) async {
    try {
      final String params = '?${ApiConfig.languageParam(languageId)}';
      final String path =
          ApiConfig.usersWithId(userId) + ApiConfig.menus + params;
      final response = await dio.get(path);

      if (response.data is List<dynamic>) {
        final List<Menu> menuList = (response.data as List<dynamic>)
            .map(
              (map) => MenuDto.fromJson(map).toModel(),
            )
            .toList();

        return right(menuList);
      } else {
        return const Left("Invalid data format");
      }
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

  Future<Either<String, Menu>> getAllByMenuId(
    String menuId,
    int languageId,
    String userId,
  ) async {
    try {
      final String params = '?${ApiConfig.languageParam(languageId)}';
      final String path = ApiConfig.usersWithId(userId) +
          ApiConfig.menusWithId(menuId) +
          params;
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

  Future<Option<String>> updateMenu(
    Menu menu,
    String userId,
    String menuId,
  ) async {
    try {
      final String path =
          ApiConfig.usersWithId(userId) + ApiConfig.menusWithId(menuId);
      await dio.patch(
        path,
        data: MenuDto.fromModel(menu).toJson(),
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

  Future<Option<String>> deleteMenu(
    String userId,
    String menuId,
  ) async {
    try {
      final String path =
          ApiConfig.usersWithId(userId) + ApiConfig.menusWithId(menuId);
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
