import 'package:kitshell/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

class ObjectBox {
  ObjectBox._create(this.store) {
    // Add any additional setup code, e.g. build queries.
  }

  late final Store store;

  static Future<ObjectBox> create() async {
    final local = await getApplicationSupportDirectory();
    final store = await openStore(directory: local.path);
    return ObjectBox._create(store);
  }
}
