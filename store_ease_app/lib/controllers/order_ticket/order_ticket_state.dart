part of 'order_ticket_bloc.dart';

class OrderTicketState {
  OrderTicketState({
    required this.getAllOrderTicket,
    required this.selectedIndex,
    required this.status,
    required this.errorMessage,
  });

  // Get OrderTicket
  final List<OrderTicket> getAllOrderTicket;

  // Select OrderStatus
  final int selectedIndex;

  // Common
  final LoadStatus status;
  final String errorMessage;

  factory OrderTicketState.initial() => OrderTicketState(
        getAllOrderTicket: const <OrderTicket>[],
        selectedIndex: 0,
        status: LoadStatus.initial,
        errorMessage: '',
      );

  OrderTicketState copyWith({
    List<OrderTicket>? getAllOrderTicket,
    bool? isAccept,
    int? selectedIndex,
    LoadStatus? status,
    String? errorMessage,
  }) {
    return OrderTicketState(
      getAllOrderTicket: getAllOrderTicket ?? this.getAllOrderTicket,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
