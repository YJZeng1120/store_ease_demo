import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_tabs_event.dart';
part 'bottom_tabs_state.dart';

class BottomTabsBloc extends Bloc<BottomTabsEvent, BottomTabsState> {
  BottomTabsBloc() : super(BottomTabsState.initial()) {
    _onEvent();
  }

  void _onEvent() {
    on<AppTabIndexEvent>((event, emit) {
      emit(state.copyWith(appTabIndex: event.appTabIndex));
    });

    on<StoreTabIndexEvent>((event, emit) {
      emit(state.copyWith(storeTabIndex: event.storeTabIndex));
    });
  }
}
