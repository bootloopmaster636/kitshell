import 'package:kitshell/main.dart';
import 'package:kitshell/objectbox.g.dart'; //ignore: unused_import
import 'package:kitshell/panel/logic/appmenu/appmenu.dart';
import 'package:kitshell/src/rust/api/appmenu.dart';
import 'package:objectbox/objectbox.dart'; // ignore: unused_import

@Entity()
class AppmenuDb {
  @Id()
  int id = 0;

  late String name;
  late String description;
  late List<String> exec;
  late String icon;
  late bool useTerminal;
  late bool isFavorite;
  late int frequency;
}

Future<void> addToAppmenuDb(List<AppData> appDataList) async {
  final box = objectbox.store.box<AppmenuDb>();

  for (final appData in appDataList) {
    final newData = AppmenuDb()
      ..name = appData.name
      ..description = appData.description
      ..exec = appData.exec
      ..icon = appData.icon
      ..useTerminal = appData.useTerminal
      ..isFavorite = false
      ..frequency = 0;

    //check for existing app in db so we don't have to reset db everytime we add new apps
    final queryApp = box.query(AppmenuDb_.name.equals(newData.name)).build();
    if (queryApp.find().isEmpty) {
      // replace icon name with icon path
      newData.icon = await findIconPathFromIconName(iconName: newData.icon);
      box.put(newData);
    }
  }
}

void incrementFrequency(int id) {
  final box = objectbox.store.box<AppmenuDb>();
  final app = box.get(id);
  if (app != null) {
    app.frequency++;
    box.put(app);
  }
}

void changeFavorite(int id, {required bool isFavorite}) {
  final box = objectbox.store.box<AppmenuDb>();
  final app = box.get(id);
  if (app != null) {
    app.isFavorite = isFavorite;
    box.put(app);
  }
}

List<AppmenuInfo> getAllAppsFromCache({required bool isFavorite}) {
  final box = objectbox.store.box<AppmenuDb>();
  final apps = box
      .query(AppmenuDb_.isFavorite.equals(isFavorite))
      .order(
        AppmenuDb_.frequency,
        flags: Order.descending,
      )
      .build();

  return apps.find().map((app) {
    return AppmenuInfo(
      id: app.id,
      name: app.name,
      description: app.description,
      exec: app.exec,
      icon: app.icon,
      useTerminal: app.useTerminal,
      isFavorite: app.isFavorite,
      frequency: app.frequency,
    );
  }).toList();
}

void deleteAll() {
  objectbox.store.box<AppmenuDb>().removeAll();
}
