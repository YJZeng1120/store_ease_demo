part of 'bottom_tabs_bloc.dart';

abstract class BottomTabsEvent {
  const BottomTabsEvent();
}

class AppTabIndexEvent extends BottomTabsEvent {
  const AppTabIndexEvent(this.appTabIndex);
  final int appTabIndex;
}

class StoreTabIndexEvent extends BottomTabsEvent {
  const StoreTabIndexEvent(this.storeTabIndex);
  final int storeTabIndex;
}
