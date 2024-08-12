import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:process_run/process_run.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sound.freezed.dart';
part 'sound.g.dart';

@Freezed()
class SoundInfo with _$SoundInfo {
  const factory SoundInfo({
    required double volume,
    required bool isMuted,
  }) = _SoundInfo;
}

@riverpod
class SoundLogic extends _$SoundLogic {
  @override
  Future<SoundInfo?> build() async {
    // get the volume and mute status
    final shell = Shell();
    final stdout = await shell.run('wpctl get-volume @DEFAULT_AUDIO_SINK@');
    final volume = double.parse(stdout.outText.split(' ')[1]);

    return SoundInfo(
      volume: volume,
      isMuted: false,
    );
  }

  Future<void> startPolling() async {
    final shell = Shell(verbose: false);

    Timer.periodic(const Duration(seconds: 5), (timer) async {
      final stdout = await shell.run('wpctl get-volume @DEFAULT_AUDIO_SINK@');
      final volume = double.parse(stdout.outText.split(' ')[1]);

      state = AsyncValue.data(
        SoundInfo(
          volume: volume,
          isMuted: false,
        ),
      );
    });
  }

  void setVolume(double volume) {
    state = AsyncValue.data(
      SoundInfo(
        volume: volume,
        isMuted: false,
      ),
    );

    unawaited(Shell(verbose: false, options: ShellOptions(noStdoutResult: true))
        .run('wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ $volume'));
  }
}
