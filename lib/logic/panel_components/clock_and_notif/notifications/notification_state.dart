part of 'notification_bloc.dart';

@freezed
sealed class NotificationState with _$NotificationState {
  const factory NotificationState.initial() = NotificationStateInitial;
  const factory NotificationState.loaded({
    required List<NotificationData> notifications,
    required bool dndEnabled,
  }) = NotificationStateLoaded;
}
