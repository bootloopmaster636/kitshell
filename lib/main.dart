import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce/hive.dart';
import 'package:kitshell/data/source/hive/hive_registrar.g.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/injectable.dart';
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
    runApp(const MaterialApp(home: Center(child: Text('Not supported'))));
    return;
  }

  // BLoC init
  get<ScreenManagerBloc>().add(const ScreenManagerEventStarted());
  get<PanelManagerBloc>().add(const PanelManagerEventStarted());

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
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const ScreenManager(),
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
  colorSchemeSeed: Colors.lightBlue,
  brightness: Brightness.light,
  fontFamily: GoogleFonts.nunitoSans().fontFamily,
  progressIndicatorTheme: const ProgressIndicatorThemeData(year2023: false),
  sliderTheme: const SliderThemeData(
    year2023: false,
    padding: EdgeInsets.zero,
  ),
  splashFactory: InkSparkle.splashFactory,
);

ThemeData darkTheme = ThemeData(
  colorSchemeSeed: Colors.lightBlue,
  brightness: Brightness.dark,
  fontFamily: GoogleFonts.nunitoSans().fontFamily,
  progressIndicatorTheme: const ProgressIndicatorThemeData(year2023: false),
  sliderTheme: const SliderThemeData(
    year2023: false,
    padding: EdgeInsets.zero,
  ),
  splashFactory: InkSparkle.splashFactory,
);
