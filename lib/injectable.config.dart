// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:kitshell/logic/panel_components/clock_and_notif/datetime/datetime_cubit.dart'
    as _i797;
import 'package:kitshell/logic/panel_components/quick_settings/battery/qs_battery_bloc.dart'
    as _i917;
import 'package:kitshell/logic/panel_components/quick_settings/brightness/qs_brightness_bloc.dart'
    as _i993;
import 'package:kitshell/logic/panel_components/quick_settings/qs_routing/qs_routing_cubit.dart'
    as _i652;
import 'package:kitshell/logic/panel_manager/panel_manager_bloc.dart' as _i1073;
import 'package:kitshell/logic/screen_manager/screen_manager_bloc.dart'
    as _i491;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i1073.PanelManagerBloc>(() => _i1073.PanelManagerBloc());
    gh.singleton<_i491.ScreenManagerBloc>(() => _i491.ScreenManagerBloc());
    gh.singleton<_i797.DatetimeCubit>(() => _i797.DatetimeCubit());
    gh.singleton<_i993.QsBrightnessBloc>(() => _i993.QsBrightnessBloc());
    gh.singleton<_i652.QsRoutingCubit>(() => _i652.QsRoutingCubit());
    gh.singleton<_i917.QsBatteryBloc>(() => _i917.QsBatteryBloc());
    return this;
  }
}
