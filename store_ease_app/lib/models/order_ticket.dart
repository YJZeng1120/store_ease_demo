import 'enums/order_status_enum.dart';

class OrderTicket {
  OrderTicket({
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
  final OrderStatus orderStatus;
  final DateTime createdAt;
  final List<OrderTicketItem> orderTicketItems;

  factory OrderTicket.empty() {
    return OrderTicket(
      id: 0,
      seatTitle: '',
      totalPrice: 0,
      orderStatus: OrderStatus.open,
      createdAt: DateTime.now(),
      orderTicketItems: const <OrderTicketItem>[],
    );
  }

  OrderTicket copyWith({
    int? id,
    String? seatTitle,
    int? totalPrice,
    OrderStatus? orderStatus,
    DateTime? createdAt,
    List<OrderTicketItem>? orderTicketItems,
  }) {
    return OrderTicket(
      id: id ?? this.id,
      seatTitle: seatTitle ?? this.seatTitle,
      totalPrice: totalPrice ?? this.totalPrice,
      orderStatus: orderStatus ?? this.orderStatus,
      createdAt: createdAt ?? this.createdAt,
      orderTicketItems: orderTicketItems ?? this.orderTicketItems,
    );
  }
}

class OrderTicketItem {
  OrderTicketItem({
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

  factory OrderTicketItem.empty() {
    return OrderTicketItem(
      id: 0,
      productId: 0,
      productName: '',
      productPrice: 0,
      quantity: 0,
    );
  }

  OrderTicketItem copyWith({
    int? id,
    int? productId,
    String? productName,
    int? productPrice,
    int? quantity,
  }) {
    return OrderTicketItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      quantity: quantity ?? this.quantity,
    );
  }
}
