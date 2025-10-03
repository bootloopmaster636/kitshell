part of 'ipc_bloc.dart';

@freezed
class IpcState with _$IpcState {
  /// We dont really need state in IPC
  const factory IpcState() = _IpcState;
}
