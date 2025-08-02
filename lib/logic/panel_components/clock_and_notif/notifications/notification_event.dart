part of 'notification_bloc.dart';

@freezed
sealed class NotificationEvent with _$NotificationEvent {
  const factory NotificationEvent.started() = NotificationEventStarted;
  const factory NotificationEvent.close(int id) = NotificationEventClosed;
  const factory NotificationEvent.clear() = NotificationEventCleared;
}
