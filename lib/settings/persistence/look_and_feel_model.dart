import 'package:flutter/material.dart';
import 'package:kitshell/main.dart';
import 'package:kitshell/settings/dropdown_value.dart';
import 'package:kitshell/settings/logic/look_and_feel/look_and_feel.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class LookAndFeelDb {
  @Id(assignable: true)
  late int id;

  late String themeMode;
  late int color;
}

void storeLookAndFeelSettings(LookAndFeel newSettings) {
  final lafBox = objectbox.store.box<LookAndFeelDb>();

  final themeModeConverted = newSettings.themeMode.value.toString();
  final colorConverted = newSettings.color.value;

  final object = LookAndFeelDb()
    ..id = 1
    ..themeMode = themeModeConverted
    ..color = colorConverted;

  lafBox.put(object);
}

LookAndFeel getLookAndFeelSettings() {
  final lafBox = objectbox.store.box<LookAndFeelDb>();
  final object = lafBox.get(1);

  var themeConverted = ThemeModeOption.system;
  switch (object?.themeMode) {
    case 'ThemeMode.system':
      themeConverted = ThemeModeOption.system;
    case 'ThemeMode.light':
      themeConverted = ThemeModeOption.light;
    case 'ThemeMode.dark':
      themeConverted = ThemeModeOption.dark;
  }
  final colorConverted = Color(object?.color ?? Colors.purple.value);

  return LookAndFeel(
    themeMode: themeConverted,
    color: colorConverted,
  );
}
