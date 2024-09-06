import 'package:kitshell/src/rust/api/appmenu.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'appmenu.g.dart';

@Riverpod(keepAlive: true)
class AppmenuLogic extends _$AppmenuLogic {
  @override
  Future<List<AppData>> build() async {
    state = const AsyncLoading();
    final data = await getAllApps();

    return data;
  }
}
