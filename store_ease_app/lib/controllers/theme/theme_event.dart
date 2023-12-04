part of 'theme_bloc.dart';

abstract class ThemeEvent {
  const ThemeEvent();
}

class InitialEvent extends ThemeEvent {
  const InitialEvent();
}

class ChangeLanguageEvent extends ThemeEvent {
  const ChangeLanguageEvent(this.languageCode);
  final String languageCode;
}
