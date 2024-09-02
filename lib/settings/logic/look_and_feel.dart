import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kitshell/settings/enums.dart';
import 'package:kitshell/settings/persistence/look_and_feel_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'look_and_feel.freezed.dart';
part 'look_and_feel.g.dart';

@Freezed()
class LookAndFeel with _$LookAndFeel {
  const factory LookAndFeel({
    required ThemeModeOption themeMode,
    required Color color,
  }) = _LookAndFeel;
}

@riverpod
class SettingsLookAndFeel extends _$SettingsLookAndFeel {
  @override
  Future<LookAndFeel> build() async {
    state = const AsyncLoading();
    final data = getLookAndFeelSettings();
    return data;
  }

  void changeColor(Color color) {
    state = AsyncData(
      state.value?.copyWith(color: color) ??
          const LookAndFeel(themeMode: ThemeModeOption.system, color: Colors.deepPurple),
    );
    storeLookAndFeelSettings(LookAndFeel(themeMode: state.value!.themeMode, color: color));
  }

  void changeThemeMode(ThemeModeOption? themeMode) {
    state = AsyncData(
      state.value?.copyWith(themeMode: themeMode ?? ThemeModeOption.system) ??
          const LookAndFeel(themeMode: ThemeModeOption.system, color: Colors.deepPurple),
    );
    storeLookAndFeelSettings(LookAndFeel(themeMode: themeMode ?? ThemeModeOption.system, color: state.value!.color));
  }
}
