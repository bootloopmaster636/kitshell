import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitshell/panel/logic/utility_function.dart';
import 'package:kitshell/panel/widgets/main/hyprland.dart';
import 'package:kitshell/panel/widgets/main/mpris.dart';
import 'package:kitshell/panel/widgets/main/quick_settings.dart';
import 'package:kitshell/panel/widgets/main/time.dart';
import 'package:kitshell/panel/widgets/utility_widgets.dart';
import 'package:kitshell/settings/logic/layer_shell/layer_shell.dart';
import 'package:kitshell/settings/logic/look_and_feel/look_and_feel.dart';
import 'package:kitshell/settings/persistence/objectbox.dart';
import 'package:kitshell/settings/settings_screen.dart';
import 'package:kitshell/src/rust/frb_generated.dart';
import 'package:toastification/toastification.dart';
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
        home: Init(
          child: ref.watch(settingsLookAndFeelProvider).isLoading || ref.watch(layerShellLogicProvider).isLoading
              ? const LoadingScreen()
              : const Main(),
        ),
      ),
    );
  }
}

class Init extends ConsumerWidget {
  const Init({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(layerShellLogicProvider);
    return child;
  }
}

class Main extends ConsumerWidget {
  const Main({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: DefaultTextStyle(
        style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
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
                    ref: ref,
                    title: 'Settings',
                    child: const SettingsContent(),
                  );
                },
              ),
            ];
          },
          verticalPadding: 0,
          width: 200,
          child: ColoredBox(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                const Row(
                  children: [
                    TimeWidget(),
                    QuickSettingsContainer(),
                    Spacer(),
                    Mpris(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: () {
                        pushExpandedSubmenu(
                          context: context,
                          ref: ref,
                          title: 'Apps',
                          child: Placeholder(),
                        );
                      },
                      child: const Row(
                        children: [
                          FaIcon(FontAwesomeIcons.boxesStacked, size: 12),
                          Gap(8),
                          Text('Apps'),
                        ],
                      ),
                    ),
                    const Gap(8),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Hyprland(),
                    ),
                  ],
                ).animate(delay: 800.ms).scaleX(
                      begin: 0,
                      end: 1,
                      duration: 800.ms,
                      curve: Curves.easeOutExpo,
                    ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(
          duration: 500.ms,
        );
  }
}
