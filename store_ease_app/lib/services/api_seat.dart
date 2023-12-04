import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../http.dart';
import '../models/core/api_config.dart';
import '../models/dto/seat_dto.dart';
import '../models/seat.dart';

class SeatApi {
  Future<Option<String>> createSeat(
    Seat seat,
    String storeId,
  ) async {
    try {
      final String path = ApiConfig.storesWithId(storeId) + ApiConfig.seats;
      await dio.post(
        path,
        data: SeatDto.fromModel(seat).toJson(),
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

  Future<Either<String, List<Seat>>> getAllByStoreId(
    String storeId,
  ) async {
    try {
      final String path = ApiConfig.storesWithId(storeId) + ApiConfig.seats;
      final response = await dio.get(path);

      if (response.data is List<dynamic>) {
        final List<Seat> seatList = (response.data as List<dynamic>)
            .map((map) => SeatDto.fromJson(map).toModel())
            .toList();

        return right(seatList);
      } else {
        return left("Invalid data format");
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

  Future<Either<String, Seat>> getBySeatId(
    String storeId,
    int seatId,
  ) async {
    try {
      final String path =
          ApiConfig.storesWithId(storeId) + ApiConfig.seatsWithId(seatId);
      final response = await dio.get(path);

      final Seat seat = SeatDto.fromJson(response.data).toModel();

      return right(seat);
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

  Future<Option<String>> updateSeat(
    Seat seat,
    String storeId,
    int seatId,
  ) async {
    try {
      final String path =
          ApiConfig.storesWithId(storeId) + ApiConfig.seatsWithId(seatId);
      await dio.patch(
        path,
        data: SeatDto.fromModel(seat).toJson(),
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

  Future<Option<String>> deleteSeat(
    String storeId,
    int seatId,
  ) async {
    try {
      final String path =
          ApiConfig.storesWithId(storeId) + ApiConfig.seatsWithId(seatId);
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
