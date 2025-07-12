import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_manager/panel_manager_bloc.dart';
import 'package:kitshell/logic/screen_manager/screen_manager_bloc.dart';
import 'package:kitshell/screen/screen_manager.dart';
import 'package:kitshell/src/rust/frb_generated.dart';
import 'package:wayland_layer_shell/wayland_layer_shell.dart';

Future<void> main() async {
  // Flutter init
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  configureDependencies();

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
      home: const ScreenManager(),
    );
  }
}
