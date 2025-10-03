import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kitshell/etc/utitity/logger.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/screen_manager/panel_enum.dart';
import 'package:kitshell/logic/screen_manager/screen_manager_bloc.dart';
import 'package:kitshell/screen/screen_manager.dart';
import 'package:kitshell/src/rust/api/ipc/ipc.dart';

part 'ipc_event.dart';
part 'ipc_state.dart';
part 'ipc_bloc.freezed.dart';

/// BLoC for watching IPC command from kitshell-cmd (to open popup, etc.)
@singleton
class IpcBloc extends Bloc<IpcEvent, IpcState> {
  IpcBloc() : super(const IpcState()) {
    on<IpcEventStarted>((event, emit) async {
      await emit.onEach(
        watchKitshellSocket(),
        onData: (data) {
          switch (data.opt1) {
            case 'popup':
              _handlePopup(data.opt2);
          }
        },
      );
    });
  }

  void _handlePopup(String? popupKind) {
    if (popupKind == null) return;

    PopupWidget? widget;
    final WidgetPosition position = WidgetPosition.center;
    switch (popupKind) {
      case 'notif':
        widget = PopupWidget.notifications;
      case 'quicksettings':
        widget = PopupWidget.quickSettings;
      case 'appmenu':
        widget = PopupWidget.appMenu;
      case 'mpris':
        widget = PopupWidget.mpris;
      case _:
        logger.e('IpcBloc: Popup kind not recognized!');
    }

    if (widget == null) return;
    get<ScreenManagerBloc>().add(
      ScreenManagerEvent.openPopup(
        popupToShow: widget,
        position: WidgetPosition.center,
      ),
    );
  }
}
