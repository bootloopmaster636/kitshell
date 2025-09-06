part of 'appmenu_bloc.dart';

@freezed
class AppmenuEvent with _$AppmenuEvent {
  const factory AppmenuEvent.load(String locale) = AppmenuLoad;

  const factory AppmenuEvent.togglePin(String id) = AppmenuPinToggled;

  const factory AppmenuEvent.resetRank(String id) = AppmenuRankReset;

  const factory AppmenuEvent.search(String query) = AppmenuSearched;

  const factory AppmenuEvent.open(AppInfoModel app) = AppmenuAppExecuted;
}
