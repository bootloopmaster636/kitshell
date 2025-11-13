import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce/hive.dart';
import 'package:kitshell/data/source/hive/hive_registrar.g.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/ipc/ipc_bloc.dart';
import 'package:kitshell/logic/panel_manager/panel_manager_bloc.dart';
import 'package:kitshell/logic/screen_manager/screen_manager_bloc.dart';
import 'package:kitshell/screen/screen_manager.dart';
import 'package:kitshell/src/rust/frb_generated.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wayland_layer_shell/wayland_layer_shell.dart';

Future<void> main() async {
  // Flutter and dart init
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  configureDependencies();
  await initDb();

  // Wl layer shell init
  final waylandLayerShellPlugin = WaylandLayerShell();
  final isSupported = await waylandLayerShellPlugin.initialize(48, 48);
  if (!isSupported) {
    runApp(TranslationProvider(child: const NotCompatibleWidget()));
    return;
  }

  // BLoC init
  get<ScreenManagerBloc>().add(const ScreenManagerEventStarted());
  get<PanelManagerBloc>().add(const PanelManagerEventStarted());
  get<IpcBloc>().add(const IpcEventStarted());

  // Run app
  runApp(TranslationProvider(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const ScreenManager(),
    );
  }
}

class NotCompatibleWidget extends StatelessWidget {
  const NotCompatibleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: ColoredBox(
        color: context.colorScheme.surface,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              t.failedToLoad.title,
              style: context.textTheme.titleLarge,
            ),
            Text(
              t.failedToLoad.hint,
              style: context.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> initDb() async {
  final dbDir = await getApplicationSupportDirectory();

  Hive
    ..init(dbDir.path)
    ..registerAdapters();
}

// TODO(bootloopmaster636): Add dynamic theme support
ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
  ),
  brightness: Brightness.light,
  fontFamily: GoogleFonts.nunitoSans().fontFamily,
  progressIndicatorTheme: const ProgressIndicatorThemeData(year2023: false),
  sliderTheme: const SliderThemeData(
    year2023: false,
    padding: EdgeInsets.zero,
  ),
  splashFactory: InkSparkle.splashFactory,
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
    },
  ),
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
  ),
  brightness: Brightness.dark,
  fontFamily: GoogleFonts.nunitoSans().fontFamily,
  progressIndicatorTheme: const ProgressIndicatorThemeData(year2023: false),
  sliderTheme: const SliderThemeData(
    year2023: false,
    padding: EdgeInsets.zero,
  ),
  splashFactory: InkSparkle.splashFactory,
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(
        backgroundColor: Colors.transparent,
      ),
    },
  ),
);
