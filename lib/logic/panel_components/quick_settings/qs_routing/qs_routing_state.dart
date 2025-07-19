part of 'qs_routing_cubit.dart';

@freezed
sealed class QsRoutingState with _$QsRoutingState {
  const factory QsRoutingState({
    Widget? openedDetailPage,
  }) = _QsRoutingState;
}
