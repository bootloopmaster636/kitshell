import 'dart:async';

import 'package:kitshell/const.dart';
import 'package:kitshell/src/rust/api/wireplumber.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sound.g.dart';

@riverpod
class SoundLogic extends _$SoundLogic {
  @override
  Future<WireplumberData> build() async {
    await startPolling();

    return const WireplumberData(
      volume: 0,
    );
  }

  Future<void> startPolling() async {
    Timer.periodic(pollingRate, (timer) async {
      state = AsyncValue.data(
        await getVolume(),
      );
    });
  }
}
