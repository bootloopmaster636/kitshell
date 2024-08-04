import 'package:flutter/material.dart';
import 'package:wayland_layer_shell/types.dart';
import 'package:wayland_layer_shell/wayland_layer_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final waylandLayerShellPlugin = WaylandLayerShell();
  bool isSupported = await waylandLayerShellPlugin.initialize(650, 600);
  if (!isSupported) {
    runApp(const MaterialApp(home: Center(child: Text('Not supported'))));
    return;
  }
  await waylandLayerShellPlugin.setAnchor(ShellEdge.edgeBottom, true);
  await waylandLayerShellPlugin.setExclusiveZone(48);
  await waylandLayerShellPlugin.initialize(1366, 48);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KITShell',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Hello World!',
          ),
        ),
      ),
    );
  }
}
