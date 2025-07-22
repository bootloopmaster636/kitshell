import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Run [onStart] at the start of the hooks, then after [duration] it will
/// call [onEnd].
///
/// This hook can be restarted by changing value on [keys]
void useCallbackDebounced({
  required Duration duration,
  required List<Object> keys,
  VoidCallback? onStart,
  VoidCallback? onEnd,
}) {
  return use(
    _CallbackDebounced(
      duration: duration,
      keys: keys,
      onStart: onStart,
      onEnd: onEnd,
    ),
  );
}

class _CallbackDebounced extends Hook<void> {
  const _CallbackDebounced({
    required this.duration,
    required List<Object> keys,
    this.onStart,
    this.onEnd,
  }) : super(keys: keys);
  final Duration duration;
  final VoidCallback? onStart;
  final VoidCallback? onEnd;

  @override
  _CallbackDebouncedState createState() => _CallbackDebouncedState();
}

class _CallbackDebouncedState extends HookState<void, _CallbackDebounced> {
  Timer? _timer;

  @override
  void initHook() {
    _timer = Timer(hook.duration, () {
      hook.onEnd?.call();
    });
  }

  @override
  void build(BuildContext context) {
    // Directly return if timer is active (means the callback is running)
    if (!_timer!.isActive) return;
    hook.onStart?.call();
  }

  @override
  void dispose() {
    if (_timer == null) return;
    _timer?.cancel();
  }
}
