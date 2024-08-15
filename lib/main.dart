import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitshell/const.dart';
import 'package:kitshell/panel/widgets/main/quick_settings.dart';
import 'package:kitshell/panel/widgets/main/time.dart';
import 'package:kitshell/src/rust/frb_generated.dart';
import 'package:wayland_layer_shell/types.dart';
import 'package:wayland_layer_shell/wayland_layer_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();

  final waylandLayerShellPlugin = WaylandLayerShell();
  final isSupported = await waylandLayerShellPlugin.initialize(1, 1);
  if (!isSupported) {
    runApp(const MaterialApp(home: Center(child: Text('Not supported'))));
    return;
  }
  await waylandLayerShellPlugin.initialize(panelWidth.toInt(), panelHeight.toInt());
  await waylandLayerShellPlugin.setAnchor(ShellEdge.edgeBottom, true);
  await waylandLayerShellPlugin.setExclusiveZone(panelHeight.toInt());

  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KITShell',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        brightness: Brightness.dark,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      themeMode: ThemeMode.dark,
      home: const Main(),
    );
  }
}

class Main extends StatelessWidget {
  const Main({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ColoredBox(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: const MainContent(),
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
      child: const Row(
        children: [
          TimeWidget(),
          Gap(4),
          QuickSettingsContainer(),
        ],
      ),
    );
  }
}
