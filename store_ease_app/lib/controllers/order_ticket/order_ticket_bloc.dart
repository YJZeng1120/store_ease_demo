import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/enums/load_status_enum.dart';
import '../../models/order_ticket.dart';
import '../../services/api_order_ticket.dart';

part 'order_ticket_event.dart';
part 'order_ticket_state.dart';

class OrderTicketBloc extends Bloc<OrderTicketEvent, OrderTicketState> {
  final OrderTicketApi _orderTicketApi;
  OrderTicketBloc(
    this._orderTicketApi,
  ) : super(OrderTicketState.initial()) {
    _onEvent();
  }
  void _onEvent() {
    // Get OrderTicket
    on<GetAllOrderTicketEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      final failureOrSuccess = await _orderTicketApi.getAllByStoreId(
        event.storeId,
      );
      failureOrSuccess.fold(
        (f) => emit(
          state.copyWith(
            status: LoadStatus.failed,
            errorMessage: f,
          ),
        ),
        (allOrderTicket) => emit(
          state.copyWith(
            status: LoadStatus.succeed,
            getAllOrderTicket: allOrderTicket,
          ),
        ),
      );
    });

    // Select OrderStatus
    on<SelectedIndexEvent>((event, emit) {
      emit(state.copyWith(selectedIndex: event.selectedIndex));
    });

    // Update OrderTicket
    on<UpdateOrderTicketEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      final failureOption = await _orderTicketApi.updateOrderTicket(
        event.orderTicket,
        event.storeId,
      );
      failureOption.fold(
        () => add(
          GetAllOrderTicketEvent(
            event.storeId,
          ),
        ),
        (f) => emit(
          state.copyWith(
            status: LoadStatus.failed,
            errorMessage: '',
          ),
        ),
      );
    });

    // Delete OrderTicket
    on<DeleteOrderTicketEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      final failureOption = await _orderTicketApi.deleteOrderTicket(
        event.orderTicket,
        event.storeId,
      );
      failureOption.fold(
        () => add(
          GetAllOrderTicketEvent(
            event.storeId,
          ),
        ),
        (f) => emit(
          state.copyWith(
            status: LoadStatus.failed,
            errorMessage: '',
          ),
        ),
      );
    });
  }
}
