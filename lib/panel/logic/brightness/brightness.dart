import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:process_run/process_run.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'brightness.freezed.dart';
part 'brightness.g.dart';

@Freezed()
class BrightnessInfo with _$BrightnessInfo {
  const factory BrightnessInfo({
    required int brightness,
    required int maxBrightness,
  }) = _BrightnessInfo;
}

@riverpod
class BrightnessLogic extends _$BrightnessLogic {
  @override
  Future<BrightnessInfo?> build() async {
    final shell = Shell(verbose: false);
    final stdoutMax = await shell.run('brightnessctl m');
    final maxBrightness = int.parse(stdoutMax.outText);

    await startPolling();

    return BrightnessInfo(
      brightness: 0,
      maxBrightness: maxBrightness,
    );
  }

  Future<void> startPolling() async {
    final shell = Shell(verbose: false);

    Timer.periodic(const Duration(seconds: 5), (timer) async {
      // get the volume and mute status
      final stdout = await shell.run('brightnessctl g');
      final brightness = int.parse(stdout.outText);

      state = AsyncValue.data(
        BrightnessInfo(
          brightness: brightness,
          maxBrightness: state.value?.maxBrightness ?? 100,
        ),
      );
    });
  }

  void setBrightness(int brightness) {
    state = AsyncValue.data(
      BrightnessInfo(
        brightness: brightness,
        maxBrightness: state.value?.maxBrightness ?? 100,
      ),
    );

    unawaited(Shell(verbose: false, options: ShellOptions(noStdoutResult: true))
        .run('brightnessctl s $brightness'),);
  }
}
