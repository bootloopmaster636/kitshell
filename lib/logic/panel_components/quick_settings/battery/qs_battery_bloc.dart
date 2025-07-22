import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kitshell/src/rust/api/quick_settings/battery.dart';

part 'qs_battery_bloc.freezed.dart';
part 'qs_battery_event.dart';
part 'qs_battery_state.dart';

@singleton
class QsBatteryBloc extends Bloc<QsBatteryEvent, QsBatteryState> {
  QsBatteryBloc() : super(const QsBatteryStateInitial()) {
    on<QsBatteryEventStarted>(_getBatteryData);
  }

  Future<void> _getBatteryData(
    QsBatteryEventStarted event,
    Emitter<QsBatteryState> emit,
  ) async {
    return emit.forEach(
      watchBatteryEvent(),
      onData: (data) {
        return QsBatteryStateLoaded(data);
      },
    );
  }
}
