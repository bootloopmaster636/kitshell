part of 'internet_cubit.dart';

@freezed
sealed class InternetState with _$InternetState {
  const factory InternetState.initial() = InternetStateInitial;
  const factory InternetState.loaded({required List<WlanBloc> wlanDevices}) =
      InternetStateLoaded;
  const factory InternetState.unsuported() = InternetStateUnsupported;
}
