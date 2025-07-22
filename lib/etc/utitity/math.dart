int getPercent(int value, int maxValue) {
  return (value / maxValue * 100).toInt();
}

/// Get the normalized value from [value] to [maxValue]
/// (0.0 to 1.0, e.g. if value is 40 and maxValue is 100, this
/// function will return 0.4)
double getNormalized(int value, int maxValue) {
  return value / maxValue;
}

/// Get an icon from icon list with specified percentage.
/// Icon list must be ordered from low to high
String getIconFromValue(List<String> iconList, int percentage) {
  final index = (percentage / 100 * iconList.length)
      .clamp(0, iconList.length - 1)
      .toInt();
  return iconList[index];
}
