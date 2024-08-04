import 'package:freezed_annotation/freezed_annotation.dart';

part 'time.freezed.dart';

@Freezed()
class Time with _$Time {
  const factory Time({
    required DateTime time,
  }) = _Time;
}