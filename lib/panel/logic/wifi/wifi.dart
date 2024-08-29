import 'package:kitshell/src/rust/api/wifi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wifi.g.dart';

@riverpod
class WifiList extends _$WifiList {
  @override
  Future<List<WifiData>> build() async {
    state = const AsyncLoading();

    try {
      final data = await getWifiList(rescan: false);
      return data;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return [];
    }
  }

  Future<void> scanWifi() async {
    state = const AsyncLoading();

    try {
      final data = await getWifiList(rescan: true);
      state = AsyncData(data);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
