part of 'cava_bloc.dart';

@freezed
sealed class CavaState with _$CavaState {
  const factory CavaState.initial() = CavaStateInitial;
  const factory CavaState.loaded({
    required U8Array32 data,
    required int barCount,
    required int cavaPid,
  }) = CavaStateLoaded;
}
