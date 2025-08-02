import 'package:flutter/material.dart';
import 'package:kitshell/i18n/strings.g.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;
}

extension DurationExtensions on Duration {
  /// Converts the duration into a readable string
  /// 05:15
  String toHoursMinutes() {
    final twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    return '${_toTwoDigits(inHours)}:$twoDigitMinutes';
  }

  /// Converts the duration into a readable string
  /// 05:15:35
  String toHoursMinutesSeconds() {
    final twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    final twoDigitSeconds = _toTwoDigits(inSeconds.remainder(60));
    return '${_toTwoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  /// Converts duration to dynamic time string
  /// e.g. now, 1 min, 1 hour, 1 day
  String toDynamicTime(Translations t) {
    switch (this) {
      case < const Duration(seconds: 60):
        return t.general.time.short.now;
      case >= const Duration(seconds: 60) && < const Duration(minutes: 60):
        return t.general.time.short.xMins(min: inMinutes);
      case >= const Duration(minutes: 60) && < const Duration(hours: 24):
        return t.general.time.short.xHours(hour: inHours);
      case >= const Duration(hours: 24):
        return t.general.time.short.xDays(day: inDays);
      default:
        return '';
    }
  }

  String _toTwoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }
}
