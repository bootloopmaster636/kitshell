import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kitshell/const.dart';
import 'package:kitshell/src/rust/api/battery.dart';
import 'package:process_run/process_run.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'battery.freezed.dart';
part 'battery.g.dart';

@Freezed()
class PowerProfilesInfo with _$PowerProfilesInfo {
  const factory PowerProfilesInfo({
    required PowerProfiles profile,
  }) = _PowerProfilesInfo;
}

@riverpod
class BatteryLogic extends _$BatteryLogic {
  @override
  Future<BatteryData> build() async {
    await startPolling();
    return BatteryData(
      capacityPercent: Float32List(1),
      drainRateWatt: Float32List(1),
      status: List.empty(),
    );
  }

  Future<void> startPolling() async {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      state = AsyncValue.data(
        await getBatteryData(),
      );
      log('Battery data updated');
    });
  }
}

@riverpod
class PowerProfilesLogic extends _$PowerProfilesLogic {
  @override
  Future<PowerProfilesInfo> build() async {
    await getPowerProfile();
    return state.value!;
  }

  Future<void> getPowerProfile() async {
    final shell = Shell();
    final result = await shell.run('powerprofilesctl get');
    final profile = result.outText;

    switch (profile) {
      case 'power-saver':
        state = const AsyncValue.data(
          PowerProfilesInfo(profile: PowerProfiles.powersave),
        );
      case 'performance':
        state = const AsyncValue.data(
          PowerProfilesInfo(profile: PowerProfiles.performance),
        );
      case 'balanced':
        state = const AsyncValue.data(
          PowerProfilesInfo(profile: PowerProfiles.balanced),
        );
      default:
        state = const AsyncValue.data(
          PowerProfilesInfo(profile: PowerProfiles.balanced),
        );
    }
  }

  Future<void> changePowerProfiles(PowerProfiles profile) async {
    var profileString = '';
    switch (profile) {
      case PowerProfiles.powersave:
        profileString = 'power-saver';
      case PowerProfiles.performance:
        profileString = 'performance';
      case PowerProfiles.balanced:
        profileString = 'balanced';
    }

    final shell = Shell();
    await shell.run('powerprofilesctl set $profileString');

    state = AsyncValue.data(PowerProfilesInfo(profile: profile));
  }
}
