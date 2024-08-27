import 'dart:async';

import 'package:kitshell/const.dart';
import 'package:kitshell/src/rust/api/mpris.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mpris.g.dart';

@riverpod
class MprisLogic extends _$MprisLogic {
  @override
  Future<MprisData> build() async {
    await startPolling();
    return MprisData(
      title: 'Title',
      artist: ['Artist'],
      album: 'Album',
      imageUrl: '',
      position: BigInt.zero,
      duration: BigInt.one,
      isPlaying: false,
      canNext: true,
      canPrevious: true,
    );
  }

  Future<void> startPolling() async {
    Timer.periodic(pollingRate, (timer) async {
      try {
        state = AsyncData(await getMprisData());
      } catch (e) {
        state = AsyncError(e, StackTrace.current);
      }
    });
  }
}