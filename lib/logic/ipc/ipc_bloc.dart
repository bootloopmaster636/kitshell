import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'ipc_event.dart';
part 'ipc_state.dart';
part 'ipc_bloc.freezed.dart';

/// BLoC for watching IPC command from kitshell-cmd (to open popup, etc.)
@singleton
class IpcBloc extends Bloc<IpcEvent, IpcState> {
  IpcBloc() : super(const IpcState.initial()) {
    on<IpcEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
