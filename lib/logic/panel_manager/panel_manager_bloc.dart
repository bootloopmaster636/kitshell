import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kitshell/screen/panel/components/clock.dart';
import 'package:kitshell/screen/panel/components/statusbar.dart';

part 'panel_manager_bloc.freezed.dart';
part 'panel_manager_event.dart';
part 'panel_manager_state.dart';

// TODO(bootloopmaster636): Make component location customizable
@singleton
class PanelManagerBloc extends Bloc<PanelManagerEvent, PanelManagerState> {
  PanelManagerBloc() : super(const PanelManagerStateInitial()) {
    on<PanelManagerEventStarted>(_onStarted);
  }

  Future<void> _onStarted(
    PanelManagerEventStarted event,
    Emitter<PanelManagerState> emit,
  ) async {
    emit(
      const PanelManagerStateLoaded(
        componentsLeft: [ClockComponent()],
        componentsCenter: [Placeholder(color: Colors.green)],
        componentsRight: [StatusbarComponent()],
      ),
    );
  }
}
