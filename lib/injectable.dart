import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:kitshell/injectable.config.dart';

/// Global GetIt instance
final GetIt get = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
/// Initialize GetIt instance, run this function before the start of the application
void configureDependencies() => get.init();
