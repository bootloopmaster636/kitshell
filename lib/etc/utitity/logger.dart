import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Global instance of logger
final logger = Logger(printer: SimplePrinter(), filter: DevFilter());

/// Make logs only available on debug and profile mode
class DevFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (kDebugMode || kProfileMode) {
      return true;
    }
    return false;
  }
}
