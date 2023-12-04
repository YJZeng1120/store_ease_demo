part of 'seat_bloc.dart';

abstract class SeatEvent {
  const SeatEvent();
}

class SeatInitialEvent extends SeatEvent {
  const SeatInitialEvent(this.seat);
  final Seat seat;
}

// Create Seat
class CreateSeatEvent extends SeatEvent {
  const CreateSeatEvent(this.storeId);
  final String storeId;
}

class UpdateSeatDataEvent extends SeatEvent {
  const UpdateSeatDataEvent(this.seat);
  final Seat seat;
}

// Get Seat
class GetAllSeatEvent extends SeatEvent {
  const GetAllSeatEvent(this.storeId);
  final String storeId;
}

class GetSeatDetailEvent extends SeatEvent {
  const GetSeatDetailEvent(
    this.storeId,
    this.seatId,
  );
  final String storeId;
  final int seatId;
}

// Update Seat
class UpdateSeatEvent extends SeatEvent {
  const UpdateSeatEvent(
    this.storeId,
  );

  final String storeId;
}

// Save OR Code Image
class SaveImageEvent extends SeatEvent {
  const SaveImageEvent(
    this.screenshotController,
    this.title,
  );
  final ScreenshotController screenshotController;
  final String title;
}

// Delete Seat
class DeleteSeatEvent extends SeatEvent {
  const DeleteSeatEvent(
    this.storeId,
    this.seatId,
  );
  final String storeId;
  final int seatId;
}

class ResetIsDeletedEvent extends SeatEvent {
  const ResetIsDeletedEvent();
}
