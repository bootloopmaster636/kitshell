import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kitshell/settings/enums.dart';
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
    return const LookAndFeel(
      themeMode: ThemeModeOption.system,
      color: Colors.deepPurple,
    );
  }

  void changeColor(Color color) {
    state = AsyncData(
      state.value?.copyWith(color: color) ??
          const LookAndFeel(themeMode: ThemeModeOption.system, color: Colors.deepPurple),
    );
  }

  void changeThemeMode(ThemeModeOption? themeMode) {
    state = AsyncData(
      state.value?.copyWith(themeMode: themeMode ?? ThemeModeOption.system) ??
          const LookAndFeel(themeMode: ThemeModeOption.system, color: Colors.deepPurple),
    );
  }
}
