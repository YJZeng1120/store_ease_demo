import 'package:flutter/material.dart';

class Store {
  Store({
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
  final List<StoreOpeningHours> storeOpeningHoursList;

  factory Store.empty() {
    return Store(
      storeId: null,
      storeName: '',
      description: '',
      phone: '',
      address: '',
      timezone: 'UTC+08:00',
      isBreak: false,
      storeOpeningHoursList: [],
    );
  }

  Store copyWith({
    String? storeId,
    String? storeName,
    String? description,
    String? phone,
    String? address,
    String? timezone,
    bool? isBreak,
    List<StoreOpeningHours>? storeOpeningHoursList,
  }) {
    return Store(
      storeId: storeId ?? this.storeId,
      storeName: storeName ?? this.storeName,
      description: description ?? this.description,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      timezone: timezone ?? this.timezone,
      isBreak: isBreak ?? this.isBreak,
      storeOpeningHoursList:
          storeOpeningHoursList ?? this.storeOpeningHoursList,
    );
  }
}

class StoreOpeningHours {
  StoreOpeningHours({
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
  });
  final int dayOfWeek;
  final TimeOfDay? openTime;
  final TimeOfDay? closeTime;

  factory StoreOpeningHours.empty() {
    return StoreOpeningHours(
      dayOfWeek: 1,
      openTime: null,
      closeTime: null,
    );
  }

  StoreOpeningHours copyWith({
    int? dayOfWeek,
    TimeOfDay? openTime,
    TimeOfDay? closeTime,
  }) {
    return StoreOpeningHours(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
    );
  }
}
