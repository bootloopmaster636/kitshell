import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kitshell/etc/utitity/logger.dart';
import 'package:kitshell/src/rust/api/notifications.dart';

part 'notification_bloc.freezed.dart';
part 'notification_event.dart';
part 'notification_state.dart';

@singleton
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationStateInitial()) {
    on<NotificationEventStarted>(_onSubscribed);
    on<NotificationEventClosed>(_onClosedNotification);
    on<NotificationEventCleared>(_onClearedNotification);
  }

  Future<void> _onSubscribed(
    NotificationEventStarted event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationStateLoaded([]));
    return emit.forEach(
      watchNotificationBus(),
      onData: (data) {
        logger.i('NotificationBloc: Notification received: $data');
        final currentNotifList = <NotificationData>[
          ...(state as NotificationStateLoaded).notifications,
        ];

        // Replace notification if replaces ID is not 0
        // See: https://specifications.freedesktop.org/notification-spec/latest/protocol.html#command-notify
        if (data.replacesId == 0) {
          currentNotifList.insert(0, data);
        } else {
          final index = currentNotifList.indexWhere(
            (e) => e.id == data.replacesId,
          );
          currentNotifList[index] = data;
        }

        return NotificationStateLoaded(currentNotifList);
      },
    );
  }

  Future<void> _onClosedNotification(
    NotificationEventClosed event,
    Emitter<NotificationState> emit,
  ) async {
    // Send "notification closed" signal
    // await dismissNotification(id: event.id);

    // Remove specified notification from list
    final currentNotifList = <NotificationData>[
      ...(state as NotificationStateLoaded).notifications,
    ]..removeWhere((e) => e.id == event.id);
    emit(NotificationStateLoaded(currentNotifList));
  }

  Future<void> _onClearedNotification(
    NotificationEventCleared event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationStateLoaded([]));
  }
}
