import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'time.freezed.dart';

part 'time.g.dart';

@Freezed()
class TimeInfo with _$TimeInfo {
  const factory TimeInfo({
    required DateTime time,
  }) = _TimeInfo;
}

@riverpod
class TimeInfoLogic extends _$TimeInfoLogic {
  @override
  TimeInfo build() {
    startPolling();
    return TimeInfo(time: DateTime.now());
  }

  void startPolling() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      state = TimeInfo(time: DateTime.now());
    });
  }
}
