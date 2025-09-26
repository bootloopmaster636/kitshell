import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kitshell/src/rust/api/mpris/cava.dart';
import 'package:kitshell/src/rust/lib.dart';

part 'cava_event.dart';
part 'cava_state.dart';
part 'cava_bloc.freezed.dart';

@singleton
class CavaBloc extends Bloc<CavaEvent, CavaState> {
  CavaBloc() : super(CavaStateInitial()) {
    on<CavaEventStarted>(_onStarted);
  }

  Future<void> _onStarted(
    CavaEventStarted event,
    Emitter<CavaState> emit,
  ) async {
    return emit.onEach(
      listenToCava(),
      onData: (data) {
        emit(
          CavaStateLoaded(
            data: data.data,
            barCount: data.barCount,
            cavaPid: data.cavaPid,
          ),
        );
      },
    );
  }
}
