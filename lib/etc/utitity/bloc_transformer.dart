import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/transformers.dart';

/// Debounce the request so that when user spams event, it will only receive
/// the latest event specified by the [duration]
EventTransformer<Event> debounced<Event>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}

/// Throttle the request so that the event can only be submitted
/// once every [duration]
EventTransformer<Event> throttled<Event>(Duration duration) {
  return (events, mapper) => events.throttleTime(duration).flatMap(mapper);
}
