import 'package:kitshell/src/rust/api/quick_settings/network/wlan.dart';

/// Determines whether the given AP flags resolve to an open AP security or not
bool isAccessPointOpen({
  required ApSecurityFlag wpaFlag,
  required ApSecurityFlag rsnFlag,
  required bool isFlagPrivacy,
}) {
  final wpaVerdict = wpaFlag != .none && wpaFlag != .unknown;
  final rsnVerdict = rsnFlag != .none && rsnFlag != .unknown;

  return wpaVerdict && rsnVerdict && !isFlagPrivacy;
}
