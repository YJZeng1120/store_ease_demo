import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../http.dart';
import '../models/category.dart';
import '../models/core/api_config.dart';
import '../models/dto/category_dto.dart';

class CategoryApi {
  Future<Either<String, List<Category>>> getAllByUserId(
    int languageId,
    String userId,
  ) async {
    try {
      final String params = '?${ApiConfig.languageParam(languageId)}';
      final String path =
          ApiConfig.usersWithId(userId) + ApiConfig.categories + params;
      final response = await dio.get(path);

      if (response.data is List<dynamic>) {
        final List<Category> categoryList = (response.data as List<dynamic>)
            .map(
              (map) => CategoryDto.fromJson(map).toModel(),
            )
            .toList();

        return right(categoryList);
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

  Future<Option<String>> createCategory(
    String userId,
    Category category,
  ) async {
    try {
      final String path = ApiConfig.usersWithId(userId) + ApiConfig.categories;
      await dio.post(
        path,
        data: CategoryDto.fromModel(category).toJson(),
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

  Future<Option<String>> updateCategory(
    String userId,
    int categoryId,
    Category category,
  ) async {
    try {
      final String path = ApiConfig.usersWithId(userId) +
          ApiConfig.categoriesWithId(categoryId);
      await dio.patch(
        path,
        data: CategoryDto.fromModel(category).toJson(),
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

  Future<Option<String>> deleteCategory(
    String userId,
    int categoryId,
  ) async {
    try {
      final String path = ApiConfig.usersWithId(userId) +
          ApiConfig.categoriesWithId(categoryId);
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
