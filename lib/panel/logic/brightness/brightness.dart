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
    await startPolling();
    return BrightnessData(
      brightness: Uint32List(1),
      deviceName: ['Display'],
    );
  }

  Future<void> startPolling() async {
    Timer.periodic(pollingRate, (timer) async {
      state = AsyncData(await getBrightness());
    });
  }
}
