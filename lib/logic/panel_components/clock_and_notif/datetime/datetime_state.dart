part of 'datetime_cubit.dart';

@freezed
sealed class DatetimeState with _$DatetimeState {
  const factory DatetimeState.initial() = DatetimeInitial;
  const factory DatetimeState.loaded(DateTime now) = DatetimeLoaded;
}
