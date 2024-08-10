import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kitshell/const.dart';
import 'package:process_run/process_run.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'battery.freezed.dart';

part 'battery.g.dart';

@Freezed()
class BatteryInfo with _$BatteryInfo {
  const factory BatteryInfo({
    required int level,
    required BatteryState state,
    required IconData icon,
  }) = _BatteryInfo;
}

@Freezed()
class PowerProfilesInfo with _$PowerProfilesInfo {
  const factory PowerProfilesInfo({
    required PowerProfiles profile,
  }) = _PowerProfilesInfo;
}

@riverpod
class BatteryLogic extends _$BatteryLogic {
  @override
  Future<BatteryInfo> build() async {
    final battery = Battery();

    return Future.value(
      BatteryInfo(
        level: await battery.batteryLevel, state: await battery.batteryState, icon: FontAwesomeIcons.batteryEmpty,),
    );
  }

  Future<void> startPolling() async {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      final battery = Battery();
      final batteryState = await battery.batteryState;
      final batteryLevel = await battery.batteryLevel;

      var icon = Icons.battery_unknown;
      if (batteryLevel >= 90) {
        icon = FontAwesomeIcons.batteryFull;
      } else if (batteryLevel >= 70) {
        icon = FontAwesomeIcons.batteryThreeQuarters;
      } else if (batteryLevel >= 40) {
        icon = FontAwesomeIcons.batteryHalf;
      } else if (batteryLevel >= 15) {
        icon = FontAwesomeIcons.batteryQuarter;
      } else {
        icon = FontAwesomeIcons.batteryEmpty;
      }

      state = AsyncValue.data(BatteryInfo(
        level: batteryLevel,
        state: batteryState,
        icon: icon,
      ),);
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
        state = const AsyncValue.data(PowerProfilesInfo(profile: PowerProfiles.powersave));
      case 'performance':
        state = const AsyncValue.data(PowerProfilesInfo(profile: PowerProfiles.performance));
      case 'balanced':
        state = const AsyncValue.data(PowerProfilesInfo(profile: PowerProfiles.balanced));
      default:
        state = const AsyncValue.data(PowerProfilesInfo(profile: PowerProfiles.balanced));
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
