part of 'order_ticket_bloc.dart';

abstract class OrderTicketEvent {
  const OrderTicketEvent();
}

// Get OrderTicket
class GetAllOrderTicketEvent extends OrderTicketEvent {
  const GetAllOrderTicketEvent(this.storeId);
  final String storeId;
}

// Select OrderStatus
class SelectedIndexEvent extends OrderTicketEvent {
  const SelectedIndexEvent(this.selectedIndex);
  final int selectedIndex;
}

// Update OrderTicket
class UpdateOrderTicketEvent extends OrderTicketEvent {
  const UpdateOrderTicketEvent(
    this.storeId,
    this.orderTicket,
  );
  final String storeId;
  final OrderTicket orderTicket;
}

// Delete OrderTicket
class DeleteOrderTicketEvent extends OrderTicketEvent {
  const DeleteOrderTicketEvent(
    this.storeId,
    this.orderTicket,
  );
  final String storeId;
  final OrderTicket orderTicket;
}
