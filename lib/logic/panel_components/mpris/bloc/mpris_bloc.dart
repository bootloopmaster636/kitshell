import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kitshell/etc/utitity/logger.dart';
import 'package:kitshell/src/rust/api/mpris.dart';

part 'mpris_event.dart';
part 'mpris_state.dart';
part 'mpris_bloc.freezed.dart';

@singleton
class MprisBloc extends Bloc<MprisEvent, MprisState> {
  MprisBloc() : super(MprisStateInitial()) {
    on<MprisEventStarted>(_onStarted);
  }

  Future<void> _onStarted(
    MprisEventStarted event,
    Emitter<MprisState> emit,
  ) async {
    return emit.onEach(
      watchMediaPlayerEvents(),
      onData: (data) {
        emit(MprisStateLoaded(data));
      },
      onError: (e, s) {
        logger.e(e);
      },
    );
  }
}
