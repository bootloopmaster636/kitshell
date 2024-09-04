import 'package:flutter/material.dart';
import 'package:wayland_layer_shell/types.dart';

enum ThemeModeOption {
  system,
  light,
  dark;

  const ThemeModeOption();

  ThemeMode get value {
    switch (this) {
      case ThemeModeOption.system:
        return ThemeMode.system;
      case ThemeModeOption.light:
        return ThemeMode.light;
      case ThemeModeOption.dark:
        return ThemeMode.dark;
    }
  }

  String get label {
    switch (this) {
      case ThemeModeOption.system:
        return 'System';
      case ThemeModeOption.light:
        return 'Light';
      case ThemeModeOption.dark:
        return 'Dark';
    }
  }
}

enum ShellLayerOption {
  layerBackground,
  layerBottom,
  layerTop,
  layerOverlay;

  const ShellLayerOption();

  ShellLayer get value {
    switch (this) {
      case ShellLayerOption.layerBackground:
        return ShellLayer.layerBackground;
      case ShellLayerOption.layerBottom:
        return ShellLayer.layerBottom;
      case ShellLayerOption.layerTop:
        return ShellLayer.layerTop;
      case ShellLayerOption.layerOverlay:
        return ShellLayer.layerOverlay;
    }
  }

  String get label {
    switch (this) {
      case ShellLayerOption.layerBackground:
        return 'Background';
      case ShellLayerOption.layerBottom:
        return 'Bottom';
      case ShellLayerOption.layerTop:
        return 'Top';
      case ShellLayerOption.layerOverlay:
        return 'Overlay';
    }
  }
}
