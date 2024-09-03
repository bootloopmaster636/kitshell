import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitshell/const.dart';
import 'package:kitshell/panel/logic/utility_function.dart';
import 'package:kitshell/panel/widgets/main/mpris.dart';
import 'package:kitshell/panel/widgets/main/quick_settings.dart';
import 'package:kitshell/panel/widgets/main/time.dart';
import 'package:kitshell/panel/widgets/utility_widgets.dart';
import 'package:kitshell/settings/logic/look_and_feel.dart';
import 'package:kitshell/settings/persistence/objectbox.dart';
import 'package:kitshell/settings/settings_screen.dart';
import 'package:kitshell/src/rust/frb_generated.dart';
import 'package:toastification/toastification.dart';
import 'package:wayland_layer_shell/types.dart';
import 'package:wayland_layer_shell/wayland_layer_shell.dart';

late ObjectBox objectbox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  objectbox = await ObjectBox.create();

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

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ToastificationWrapper(
      child: MaterialApp(
        title: 'KITShell',
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: ref.watch(settingsLookAndFeelProvider).value?.color ?? Colors.purple),
          fontFamily: GoogleFonts.inter().fontFamily,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: ref.watch(settingsLookAndFeelProvider).value?.color ?? Colors.purple,
            brightness: Brightness.dark,
          ),
          brightness: Brightness.dark,
          fontFamily: GoogleFonts.inter().fontFamily,
          applyElevationOverlayColor: true,
        ),
        themeMode: ref.watch(settingsLookAndFeelProvider).value?.themeMode.value,
        themeAnimationStyle: AnimationStyle(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        ),
        home: ref.watch(settingsLookAndFeelProvider).isLoading ? const LoadingScreen() : const Main(),
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
                        Navigator.of(context).pop();
                        pushExpandedSubmenu(
                          context: context,
                          title: 'Settings',
                          child: const SettingsContent(),
                        );
                      },
                    ),
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
    ).animate().fadeIn(
          duration: 500.ms,
        );
  }
}
