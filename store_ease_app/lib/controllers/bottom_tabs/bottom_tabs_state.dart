part of 'bottom_tabs_bloc.dart';

class BottomTabsState {
  BottomTabsState({
    required this.appTabIndex,
    required this.storeTabIndex,
  });
  final int appTabIndex;
  final int storeTabIndex;

  factory BottomTabsState.initial() => BottomTabsState(
        appTabIndex: 0,
        storeTabIndex: 0,
      );

  BottomTabsState copyWith({
    int? appTabIndex,
    int? storeTabIndex,
  }) {
    return BottomTabsState(
      appTabIndex: appTabIndex ?? this.appTabIndex,
      storeTabIndex: storeTabIndex ?? this.storeTabIndex,
    );
  }
}
