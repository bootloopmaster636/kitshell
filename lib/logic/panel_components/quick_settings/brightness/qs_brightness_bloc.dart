import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kitshell/etc/utitity/logger.dart';
import 'package:kitshell/src/rust/api/quick_settings/display_brightness.dart';

part 'qs_brightness_bloc.freezed.dart';
part 'qs_brightness_event.dart';
part 'qs_brightness_state.dart';

@singleton
class QsBrightnessBloc extends Bloc<QsBrightnessEvent, QsBrightnessState> {
  QsBrightnessBloc() : super(const QsBrightnessStateInitial()) {
    on<QsBrightnessEventStarted>(_onBrightnessChanged);
  }

  Future<void> _onBrightnessChanged(
    QsBrightnessEventStarted event,
    Emitter<QsBrightnessState> emit,
  ) async {
    logger.i('QsBrightnessBloc: Watching for brightness changes event');
    await emit.forEach(
      watchBacklightEvent(),
      onData: (data) {
        return QsBrightnessStateLoaded(data);
      },
    );
  }
}
