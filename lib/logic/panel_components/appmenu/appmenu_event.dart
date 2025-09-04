part of 'appmenu_bloc.dart';

@freezed
class AppmenuEvent with _$AppmenuEvent {
  const factory AppmenuEvent.load(String locale) = AppmenuLoad;
  const factory AppmenuEvent.search(String query) = AppmenuSearched;
  const factory AppmenuEvent.open({
    required String exec,
    required bool runInTerminal,
  }) = AppmenuAppExecuted;
}
