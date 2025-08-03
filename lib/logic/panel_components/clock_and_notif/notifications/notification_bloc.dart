import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
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
    on<NotificationEventRefreshed>(_onRefreshedNotification);
    on<NotificationEventClosed>(_onClosedNotification);
    on<NotificationEventCleared>(_onClearedNotification);
  }

  Future<void> _onSubscribed(
    NotificationEventStarted event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationStateLoaded(notifications: [], dndEnabled: false));

    return emit.forEach(
      watchNotificationBus(),
      onData: (data) {
        logger.i('NotificationBloc: Notification received: $data');
        final loadedNotifState = state as NotificationStateLoaded;

        final currentNotifList = <NotificationData>[
          ...loadedNotifState.notifications,
        ];

        // Replace notification if replaces ID is not 0
        // See: https://specifications.freedesktop.org/notification-spec/latest/protocol.html#command-notify
        if (data.replacesId == 0) {
          currentNotifList.insert(0, data);
        } else {
          // Insert notification if not added yet (just in case...
          // but it should not be possible to do)
          if (loadedNotifState.notifications
              .where((e) => e.id == data.id)
              .toList()
              .isEmpty) {
            currentNotifList.insert(0, data);
          } else {
            final index = currentNotifList.indexWhere(
              (e) => e.id == data.replacesId,
            );
            currentNotifList[index] = data;
          }
        }

        return loadedNotifState.copyWith(notifications: currentNotifList);
      },
    );
  }

  void _onRefreshedNotification(
    NotificationEventRefreshed event,
    Emitter<NotificationState> emit,
  ) {
    if (state is! NotificationStateLoaded) return;
    final loadedState = state as NotificationStateLoaded;
    final notifications = loadedState.notifications;

    // TODO(bootloopmaster636): fix this hacky way to emit new state
    emit(loadedState.copyWith(notifications: []));
    emit(loadedState.copyWith(notifications: notifications));
  }

  Future<void> _onClosedNotification(
    NotificationEventClosed event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is! NotificationStateLoaded) return;
    final loadedState = state as NotificationStateLoaded;

    // Remove specified notification from list
    final currentNotifList = <NotificationData>[
      ...loadedState.notifications,
    ]..removeWhere((e) => e.id == event.id);
    emit(loadedState.copyWith(notifications: currentNotifList));
  }

  Future<void> _onClearedNotification(
    NotificationEventCleared event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is! NotificationStateLoaded) return;
    final loadedState = state as NotificationStateLoaded;

    emit(loadedState.copyWith(notifications: []));
  }
}
