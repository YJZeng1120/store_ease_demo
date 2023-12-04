import 'package:flutter/material.dart';

import '../store.dart';

class StoreDto {
  StoreDto({
    this.storeId,
    required this.storeName,
    required this.description,
    required this.phone,
    required this.address,
    required this.timezone,
    required this.isBreak,
    required this.storeOpeningHoursList,
  });
  final String? storeId;
  final String storeName;
  final String description;
  final String phone;
  final String address;
  final String timezone;
  final bool isBreak;
  final List<StoreOpeningHoursDto> storeOpeningHoursList;

  factory StoreDto.fromModel(
    Store store,
  ) {
    return StoreDto(
      storeName: store.storeName,
      description: store.description,
      phone: store.phone,
      address: store.address,
      timezone: store.timezone,
      isBreak: store.isBreak,
      storeOpeningHoursList: store.storeOpeningHoursList
          .map(
            (model) => StoreOpeningHoursDto.fromModel(model),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": storeName,
      "description": description,
      "phone": phone,
      "address": address,
      "timezone": timezone,
      "isBreak": isBreak,
      "storeOpeningHours": storeOpeningHoursList
          .map(
            (dto) => dto.toJson(),
          )
          .toList()
    };
  }

  factory StoreDto.fromJson(
    Map<String, dynamic> map,
  ) {
    List storeOpeningHoursMapList = map['storeOpeningHours'];
    return StoreDto(
      storeId: map['id'],
      storeName: map['name'],
      description: map['description'],
      phone: map['phone'],
      address: map['address'],
      timezone: map['timezone'],
      isBreak: map['isBreak'],
      storeOpeningHoursList: storeOpeningHoursMapList
          .map((e) => StoreOpeningHoursDto.fromJson(e))
          .toList(),
    );
  }

  Store toModel() {
    return Store(
      storeId: storeId,
      storeName: storeName,
      description: description,
      phone: phone,
      address: address,
      timezone: timezone,
      isBreak: isBreak,
      storeOpeningHoursList:
          storeOpeningHoursList.map((dto) => dto.toModel()).toList(),
    );
  }
}

class StoreOpeningHoursDto {
  StoreOpeningHoursDto({
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
  });

  final int dayOfWeek;
  final TimeOfDay? openTime;
  final TimeOfDay? closeTime;

  factory StoreOpeningHoursDto.fromModel(
    StoreOpeningHours storeOpeningHours,
  ) {
    return StoreOpeningHoursDto(
      dayOfWeek: storeOpeningHours.dayOfWeek,
      openTime: storeOpeningHours.openTime,
      closeTime: storeOpeningHours.closeTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "dayOfWeek": dayOfWeek,
      "openTime": '${openTime!.hour}:${openTime!.minute}:00',
      "closeTime": '${closeTime!.hour}:${closeTime!.minute}:00',
    };
  }

  factory StoreOpeningHoursDto.fromJson(
    Map<String, dynamic> map,
  ) {
    return StoreOpeningHoursDto(
      dayOfWeek: map['dayOfWeek'],
      openTime: TimeOfDay(
        hour: int.parse(
          map['openTime'].split(':')[0],
        ),
        minute: int.parse(
          map['openTime'].split(':')[1],
        ),
      ),
      closeTime: TimeOfDay(
        hour: int.parse(
          map['closeTime'].split(':')[0],
        ),
        minute: int.parse(
          map['closeTime'].split(':')[1],
        ),
      ),
    );
  }

  StoreOpeningHours toModel() {
    return StoreOpeningHours(
      dayOfWeek: dayOfWeek,
      openTime: openTime,
      closeTime: closeTime,
    );
  }
}
