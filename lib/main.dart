import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitshell/const.dart';
import 'package:kitshell/logic/time.dart';
import 'package:kitshell/widgets/main/quick_settings.dart';
import 'package:kitshell/widgets/main/time.dart';
import 'package:wayland_layer_shell/types.dart';
import 'package:wayland_layer_shell/wayland_layer_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      themeMode: ThemeMode.light,
      home: const Init(
        child: Main(),
      ),
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
        color: Theme.of(context).colorScheme.surface,
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
          Gap(8),
          QuickSettingsContainer(),
        ],
      ),
    );
  }
}

class Init extends ConsumerWidget {
  const Init({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(timeLogicProvider.notifier).startTime();

    return child;
  }
}
