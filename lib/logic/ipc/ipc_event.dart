part of 'ipc_bloc.dart';

@freezed
class IpcEvent with _$IpcEvent {
  const factory IpcEvent.started() = IpcEventStarted;
}
