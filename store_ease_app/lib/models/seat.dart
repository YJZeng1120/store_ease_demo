class Seat {
  Seat({
    this.seatId,
    required this.title,
  });
  final int? seatId;
  final String title;

  factory Seat.empty() {
    return Seat(
      seatId: null,
      title: '',
    );
  }

  Seat copyWith({
    int? seatId,
    String? title,
  }) {
    return Seat(
      seatId: seatId ?? this.seatId,
      title: title ?? this.title,
    );
  }
}
