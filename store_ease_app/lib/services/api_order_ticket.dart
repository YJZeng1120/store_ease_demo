import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../http.dart';
import '../models/core/api_config.dart';
import '../models/dto/order_ticket_dto.dart';
import '../models/order_ticket.dart';

class OrderTicketApi {
  Future<Either<String, List<OrderTicket>>> getAllByStoreId(
    String storeId,
  ) async {
    try {
      final String path =
          ApiConfig.storesWithId(storeId) + ApiConfig.orderTickets;
      final response = await dio.get(path);

      if (response.data is List<dynamic>) {
        final List<OrderTicket> orderTicketList =
            (response.data as List<dynamic>)
                .map(
                  (map) => OrderTicketDto.fromJson(map).toModel(),
                )
                .toList();

        return right(orderTicketList);
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

  Future<Option<String>> updateOrderTicket(
    OrderTicket orderTicket,
    String storeId,
  ) async {
    try {
      final String path = ApiConfig.storesWithId(storeId) +
          ApiConfig.orderTicketsWithId(orderTicket.id);
      await dio.patch(
        path,
        data: OrderTicketDto.fromModel(orderTicket).toJson(),
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

  Future<Option<String>> deleteOrderTicket(
    OrderTicket orderTicket,
    String storeId,
  ) async {
    try {
      final String path = ApiConfig.storesWithId(storeId) +
          ApiConfig.orderTicketsWithId(orderTicket.id);
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
