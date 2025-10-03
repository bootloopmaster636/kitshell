part of 'ipc_bloc.dart';

@freezed
sealed class IpcEvent with _$IpcEvent {
  const factory IpcEvent.started() = IpcEventStarted;
}
