import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'time.freezed.dart';
part 'time.g.dart';

@Freezed()
class Time with _$Time {
  const factory Time({
    required DateTime time,
  }) = _Time;
}

@riverpod
class TimeLogic extends _$TimeLogic {
  @override
  Time build() {
    return Time(time: DateTime.now());
  }

  void startTime() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      state = Time(time: DateTime.now());
    });
  }
}
