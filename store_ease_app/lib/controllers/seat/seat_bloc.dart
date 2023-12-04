import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';

import '../../functions/image_utility.dart';
import '../../models/enums/load_status_enum.dart';
import '../../models/seat.dart';
import '../../services/api_seat.dart';

part 'seat_event.dart';
part 'seat_state.dart';

class SeatBloc extends Bloc<SeatEvent, SeatState> {
  final SeatApi _seatApi;
  SeatBloc(
    this._seatApi,
  ) : super(SeatState.initial()) {
    _onEvent();
  }
  void _onEvent() {
    on<SeatInitialEvent>((event, emit) {
      final bool isEditing = event.seat.seatId != null;
      emit(
        state.copyWith(
          isEditing: isEditing,
          seat: event.seat,
        ),
      );
    });

    // Create Seat
    on<CreateSeatEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      final failureOption = await _seatApi.createSeat(
        state.seat,
        event.storeId,
      );

      failureOption.fold(
        () => add(
          GetAllSeatEvent(
            event.storeId,
          ),
        ),
        (f) => emit(
          state.copyWith(
            status: LoadStatus.failed,
            errorMessage: f,
          ),
        ),
      );
    });

    on<UpdateSeatDataEvent>((event, emit) {
      emit(state.copyWith(seat: event.seat));
    });

    // Get Seat
    on<GetAllSeatEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      final failureOrSuccess = await _seatApi.getAllByStoreId(
        event.storeId,
      );
      failureOrSuccess.fold(
        (f) => emit(
          state.copyWith(
            status: LoadStatus.failed,
            errorMessage: f,
          ),
        ),
        (allSeat) => emit(
          state.copyWith(
            status: LoadStatus.succeed,
            getAllSeat: allSeat,
          ),
        ),
      );
    });

    on<GetSeatDetailEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
        ),
      );
      final failureOrSuccess = await _seatApi.getBySeatId(
        event.storeId,
        event.seatId,
      );
      failureOrSuccess.fold(
        (f) => emit(
          state.copyWith(
            status: LoadStatus.failed,
          ),
        ),
        (seat) => emit(
          state.copyWith(
            status: LoadStatus.succeed,
            seat: seat,
          ),
        ),
      );
    });

    // Update Seat
    on<UpdateSeatEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: LoadStatus.inProgress,
          errorMessage: '',
        ),
      );
      final failureOption = await _seatApi.updateSeat(
        state.seat,
        event.storeId,
        state.seat.seatId ?? 0,
      );
      failureOption.fold(
        () {
          add(
            GetAllSeatEvent(event.storeId),
          );
          add(
            GetSeatDetailEvent(
              event.storeId,
              state.seat.seatId ?? 0,
            ),
          );
        },
        (f) => emit(
          state.copyWith(
            status: LoadStatus.failed,
            errorMessage: f,
          ),
        ),
      );
    });

    // Save OR Code Image
    on<SaveImageEvent>((event, emit) async {
      emit(
        state.copyWith(
          imageStatus: LoadStatus.inProgress,
        ),
      );
      try {
        await saveImageToGallery(
          event.screenshotController,
          event.title,
        );
        emit(
          state.copyWith(
            imageStatus: LoadStatus.succeed,
          ),
        );
      } catch (error) {
        emit(
          state.copyWith(
            imageStatus: LoadStatus.failed,
          ),
        );
      }
    });

    // Delete Seat
    on<DeleteSeatEvent>((event, emit) async {
      emit(
        state.copyWith(
          isDeleted: false,
          errorMessage: '',
        ),
      );
      final failureOption = await _seatApi.deleteSeat(
        event.storeId,
        event.seatId,
      );
      failureOption.fold(
        () => emit(
          state.copyWith(
            isDeleted: true,
          ),
        ),
        (f) => emit(
          state.copyWith(
            isDeleted: false,
            errorMessage: f,
          ),
        ),
      );
    });

    on<ResetIsDeletedEvent>((event, emit) {
      emit(state.copyWith(isDeleted: false));
    });
  }
}
