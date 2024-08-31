import 'dart:async';
import 'dart:typed_data';

import 'package:kitshell/src/rust/api/battery.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'battery.g.dart';

@riverpod
class BatteryLogic extends _$BatteryLogic {
  @override
  Future<BatteryData> build() async {
    await startPolling();
    return BatteryData(
      capacityPercent: Uint8List(1),
      drainRateWatt: Float32List(1),
      status: List.empty(),
    );
  }

  @override
  bool updateShouldNotify(AsyncValue<BatteryData> previous, AsyncValue<BatteryData> next) {
    bool shouldUpdate = false;

    for (int i = 0; i < next.value!.capacityPercent.length; i++) {
      if (((next.value!.drainRateWatt[i]) * 10).round() != (previous.value!.drainRateWatt[i] * 10).round()) {
        shouldUpdate = true;
        break;
      }
    }

    return shouldUpdate;
  }

  Future<void> startPolling() async {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      state = AsyncValue.data(
        await getBatteryData(),
      );
    });
  }
}

@riverpod
class PowerProfilesLogic extends _$PowerProfilesLogic {
  @override
  Future<PowerProfiles> build() async {
    await readPowerProfile();
    return state.value!;
  }

  Future<void> readPowerProfile() async {
    try {
      state = AsyncData(await getPowerProfile());
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> changePowerProfiles(PowerProfiles profile) async {
    try {
      await setPowerProfile(profile: profile);
      state = AsyncData(profile);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
