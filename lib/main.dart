import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitshell/const.dart';
import 'package:kitshell/panel/widgets/main/mpris.dart';
import 'package:kitshell/panel/widgets/main/quick_settings.dart';
import 'package:kitshell/panel/widgets/main/time.dart';
import 'package:kitshell/panel/widgets/utility_widgets.dart';
import 'package:kitshell/src/rust/frb_generated.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toastification/toastification.dart';
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
  await waylandLayerShellPlugin.enableAutoExclusiveZone();
  await waylandLayerShellPlugin.setAnchor(ShellEdge.edgeBottom, true);
  await waylandLayerShellPlugin.setLayer(ShellLayer.layerTop);
  await waylandLayerShellPlugin.setKeyboardMode(ShellKeyboardMode.keyboardModeOnDemand);

  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        title: 'KITShell',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
          brightness: Brightness.dark,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        home: const Main(),
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
      child: DefaultTextStyle(
        style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
        child: Row(
          children: [
            const TimeWidget(),
            Expanded(
              child: ContextMenuArea(
                builder: (BuildContext context) {
                  return [
                    ListTile(
                      dense: true,
                      title: const Text('Kitshell Settings'),
                      leading: const Icon(Icons.settings_outlined),
                      onTap: () {
                        WaylandLayerShell().initialize(panelWidth.toInt(), expandedPanelHeight.toInt());
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.bottomToTop,
                            duration: const Duration(milliseconds: 100),
                            reverseDuration: const Duration(milliseconds: 120),
                            curve: Curves.easeOutExpo,
                            child: const ExpandedSubmenu(
                              title: 'Settings',
                            ),
                          ),
                        );
                      },
                    )
                  ];
                },
                verticalPadding: 0,
                width: panelWidth / 6,
                child: ColoredBox(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: const QuickSettingsContainer(),
                ),
              ),
            ),
            const Mpris(),
          ],
        ),
      ),
    );
  }
}
