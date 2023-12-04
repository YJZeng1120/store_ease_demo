import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../http.dart';
import '../models/core/api_config.dart';
import '../models/dto/store_dto.dart';
import '../models/store.dart';

class StoreApi {
  Future<Option<String>> createStore(
    Store store,
    String userId,
  ) async {
    try {
      final String path = ApiConfig.usersWithId(userId) + ApiConfig.stores;
      await dio.post(
        path,
        data: StoreDto.fromModel(store).toJson(),
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

  Future<Either<String, List<Store>>> getAllByUserId(
    String userId,
  ) async {
    try {
      final String path = ApiConfig.usersWithId(userId) + ApiConfig.stores;
      final response = await dio.get(path);

      if (response.data is List<dynamic>) {
        final List<Store> storeList = (response.data as List<dynamic>)
            .map(
              (map) => StoreDto.fromJson(map).toModel(),
            )
            .toList();

        return right(storeList);
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

  Future<Either<String, Store>> getByStoreId(
    String userId,
    String storeId,
  ) async {
    try {
      final String path =
          ApiConfig.usersWithId(userId) + ApiConfig.storesWithId(storeId);
      final response = await dio.get(path);

      final Store store = StoreDto.fromJson(response.data).toModel();

      return right(store);
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

  Future<Option<String>> updateStore(
    Store store,
    String userId,
    String storeId,
  ) async {
    try {
      final String path =
          ApiConfig.usersWithId(userId) + ApiConfig.storesWithId(storeId);
      await dio.patch(
        path,
        data: StoreDto.fromModel(store).toJson(),
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

  Future<Option<String>> deleteStore(
    String userId,
    String storeId,
  ) async {
    try {
      final String path =
          ApiConfig.usersWithId(userId) + ApiConfig.storesWithId(storeId);
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
