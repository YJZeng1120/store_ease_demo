import '../enums/order_status_enum.dart';
import '../order_ticket.dart';

class OrderTicketDto {
  OrderTicketDto({
    required this.id,
    required this.seatTitle,
    required this.totalPrice,
    required this.orderStatus,
    required this.createdAt,
    required this.orderTicketItems,
  });
  final int id;
  final String seatTitle;
  final int totalPrice;
  final String orderStatus;
  final DateTime createdAt;
  final List<OrderTicketItemDto> orderTicketItems;

  factory OrderTicketDto.fromModel(
    OrderTicket orderTicket,
  ) {
    return OrderTicketDto(
      id: orderTicket.id,
      seatTitle: orderTicket.seatTitle,
      totalPrice: orderTicket.totalPrice,
      orderStatus: orderTicket.orderStatus.name,
      createdAt: orderTicket.createdAt,
      orderTicketItems: orderTicket.orderTicketItems
          .map((model) => OrderTicketItemDto.fromModel(model))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "orderStatus": orderStatus,
    };
  }

  factory OrderTicketDto.fromJson(
    Map<String, dynamic> map,
  ) {
    List orderTicketList = map['orderItems'];
    return OrderTicketDto(
      id: map['id'],
      seatTitle: map['seatTitle'],
      totalPrice: map['totalPrice'],
      orderStatus: map['orderStatus'],
      createdAt: DateTime.parse(map['createdAt']),
      orderTicketItems:
          orderTicketList.map((e) => OrderTicketItemDto.fromJson(e)).toList(),
    );
  }

  OrderTicket toModel() {
    return OrderTicket(
      id: id,
      seatTitle: seatTitle,
      totalPrice: totalPrice,
      orderStatus: OrderStatus.values.byName(orderStatus),
      createdAt: createdAt,
      orderTicketItems: orderTicketItems.map((dto) => dto.toModel()).toList(),
    );
  }
}

class OrderTicketItemDto {
  OrderTicketItemDto({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
  });
  final int id;
  final int productId;
  final String productName;
  final int productPrice;
  final int quantity;

  factory OrderTicketItemDto.fromModel(
    OrderTicketItem orderTicketItem,
  ) {
    return OrderTicketItemDto(
      id: orderTicketItem.id,
      productId: orderTicketItem.productId,
      productName: orderTicketItem.productName,
      productPrice: orderTicketItem.productPrice,
      quantity: orderTicketItem.quantity,
    );
  }

  factory OrderTicketItemDto.fromJson(
    Map<String, dynamic> map,
  ) {
    return OrderTicketItemDto(
      id: map['id'],
      productId: map['productId'],
      productName: map['productName'],
      productPrice: map['productPrice'],
      quantity: map['quantity'],
    );
  }

  OrderTicketItem toModel() {
    return OrderTicketItem(
      id: id,
      productId: productId,
      productName: productName,
      productPrice: productPrice,
      quantity: quantity,
    );
  }
}
