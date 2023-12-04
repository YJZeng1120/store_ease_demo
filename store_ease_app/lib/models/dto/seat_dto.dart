import '../seat.dart';

class SeatDto {
  SeatDto({
    this.seatId,
    required this.title,
  });
  final int? seatId;
  final String title;

  factory SeatDto.fromModel(
    Seat seat,
  ) {
    return SeatDto(
      title: seat.title,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
    };
  }

  factory SeatDto.fromJson(
    Map<String, dynamic> map,
  ) {
    return SeatDto(
      seatId: map['id'],
      title: map['title'],
    );
  }

  Seat toModel() {
    return Seat(
      seatId: seatId,
      title: title,
    );
  }
}
