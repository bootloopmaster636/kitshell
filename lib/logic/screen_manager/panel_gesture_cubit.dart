import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'panel_gesture_state.dart';
part 'panel_gesture_cubit.freezed.dart';

@singleton
class PanelGestureCubit extends Cubit<PanelGestureState> {
  PanelGestureCubit() : super(const PanelGestureState(readyToClose: false));

  void setPanelGestureState({required bool readyToClose}) {
    emit(PanelGestureState(readyToClose: readyToClose));
  }
}
