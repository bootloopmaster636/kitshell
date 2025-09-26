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
import 'package:kitshell/data/repository/appmenu/app_list_repo.dart' as _i637;
import 'package:kitshell/data/repository/appmenu/app_metadata_repo.dart'
    as _i52;
import 'package:kitshell/data/repository/launchbar/launchbar_repo.dart'
    as _i317;
import 'package:kitshell/data/repository/launchbar/wm_iface_repo.dart' as _i980;
import 'package:kitshell/logic/ipc/ipc_bloc.dart' as _i874;
import 'package:kitshell/logic/panel_components/appmenu/appmenu_bloc.dart'
    as _i81;
import 'package:kitshell/logic/panel_components/clock_and_notif/datetime/datetime_cubit.dart'
    as _i797;
import 'package:kitshell/logic/panel_components/clock_and_notif/notifications/notification_bloc.dart'
    as _i723;
import 'package:kitshell/logic/panel_components/launchbar/launchbar_bloc.dart'
    as _i487;
import 'package:kitshell/logic/panel_components/launchbar/workspaces_bloc.dart'
    as _i451;
import 'package:kitshell/logic/panel_components/mpris/cava_bloc.dart' as _i173;
import 'package:kitshell/logic/panel_components/mpris/mpris_bloc.dart' as _i331;
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
    gh.singleton<_i723.NotificationBloc>(() => _i723.NotificationBloc());
    gh.singleton<_i993.QsBrightnessBloc>(() => _i993.QsBrightnessBloc());
    gh.singleton<_i652.QsRoutingCubit>(() => _i652.QsRoutingCubit());
    gh.singleton<_i917.QsBatteryBloc>(() => _i917.QsBatteryBloc());
    gh.singleton<_i331.MprisBloc>(() => _i331.MprisBloc());
    gh.singleton<_i173.CavaBloc>(() => _i173.CavaBloc());
    gh.singleton<_i874.IpcBloc>(() => _i874.IpcBloc());
    gh.singleton<_i52.AppMetadataRepo>(() => _i52.AppMetadataRepo());
    gh.singleton<_i980.WmIfaceRepo>(() => _i980.WmIfaceRepo());
    gh.singleton<_i637.AppListRepo>(
      () => _i637.AppListRepo(appMetadataRepo: gh<_i52.AppMetadataRepo>()),
    );
    gh.singleton<_i451.WorkspacesBloc>(
      () => _i451.WorkspacesBloc(wmIfaceRepo: gh<_i980.WmIfaceRepo>()),
    );
    gh.singleton<_i81.AppmenuBloc>(
      () => _i81.AppmenuBloc(
        appListRepo: gh<_i637.AppListRepo>(),
        appMetadataRepo: gh<_i52.AppMetadataRepo>(),
      ),
    );
    gh.singleton<_i317.LaunchbarRepo>(
      () => _i317.LaunchbarRepo(appListRepo: gh<_i637.AppListRepo>()),
    );
    gh.singleton<_i487.LaunchbarBloc>(
      () => _i487.LaunchbarBloc(
        launcbarRepo: gh<_i317.LaunchbarRepo>(),
        wmIfaceRepo: gh<_i980.WmIfaceRepo>(),
        appListRepo: gh<_i637.AppListRepo>(),
      ),
    );
    return this;
  }
}
