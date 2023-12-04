part of 'theme_bloc.dart';

class ThemeState {
  ThemeState({
    required this.languageCode,
    required this.languageId,
    required this.status,
  });
  final String languageCode;
  final int languageId;
  final LoadStatus status;

  factory ThemeState.initial() => ThemeState(
        languageCode: 'en',
        languageId: 1,
        status: LoadStatus.initial,
      );

  ThemeState copyWith({
    String? languageCode,
    int? languageId,
    LoadStatus? status,
  }) {
    return ThemeState(
      languageCode: languageCode ?? this.languageCode,
      languageId: languageId ?? this.languageId,
      status: status ?? this.status,
    );
  }
}
