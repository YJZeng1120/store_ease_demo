part of 'seat_bloc.dart';

class SeatState {
  SeatState({
    required this.seat,
    required this.getAllSeat,
    required this.imageStatus,
    required this.isDeleted,
    required this.isEditing,
    required this.status,
    required this.errorMessage,
  });

  // Create Seat
  final Seat seat;

  // Get Seat
  final List<Seat> getAllSeat;

  // Save OR Code Image
  final LoadStatus imageStatus;

  // Delete Seat
  final bool isDeleted;

  // Common
  final bool isEditing;
  final LoadStatus status;
  final String errorMessage;

  factory SeatState.initial() => SeatState(
        seat: Seat.empty(),
        getAllSeat: const <Seat>[],
        imageStatus: LoadStatus.initial,
        isDeleted: false,
        isEditing: false,
        status: LoadStatus.initial,
        errorMessage: '',
      );

  SeatState copyWith({
    Seat? seat,
    List<Seat>? getAllSeat,
    LoadStatus? imageStatus,
    bool? isDeleted,
    bool? isEditing,
    LoadStatus? status,
    String? errorMessage,
  }) {
    return SeatState(
      seat: seat ?? this.seat,
      getAllSeat: getAllSeat ?? this.getAllSeat,
      imageStatus: imageStatus ?? this.imageStatus,
      isDeleted: isDeleted ?? this.isDeleted,
      isEditing: isEditing ?? this.isEditing,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
