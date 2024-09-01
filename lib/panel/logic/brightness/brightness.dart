import 'dart:async';
import 'dart:typed_data';

import 'package:kitshell/const.dart';
import 'package:kitshell/src/rust/api/brightness.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'brightness.g.dart';

@riverpod
class BrightnessLogic extends _$BrightnessLogic {
  @override
  Future<BrightnessData> build() async {
    state = const AsyncLoading();
    await startPolling();
    return BrightnessData(
      brightness: Uint32List(1),
      deviceName: ['Display'],
    );
  }

  @override
  bool updateShouldNotify(AsyncValue<BrightnessData> previous, AsyncValue<BrightnessData> next) {
    var shouldNotify = false;

    if (previous.value == null) return true;

    for (var i = 0; i < previous.value!.brightness.length; i++) {
      if (previous.value!.brightness[i] != next.value!.brightness[i]) {
        shouldNotify = true;
        break;
      }
    }
    return shouldNotify;
  }

  Future<void> startPolling() async {
    Timer.periodic(pollingRate, (timer) async {
      state = AsyncData(await getBrightness());
    });
  }

  Future<void> updateValue() async {
    state = AsyncData(await getBrightness());
  }
}
