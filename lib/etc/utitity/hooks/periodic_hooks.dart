import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Runs [callback] every [duration]
void usePeriodic({
  required Duration duration,
  required VoidCallback callback,
}) {
  return use(
    _PeriodicCallback(
      duration: duration,
      callback: callback,
    ),
  );
}

class _PeriodicCallback extends Hook<void> {
  const _PeriodicCallback({
    required this.duration,
    required this.callback,
  });
  final Duration duration;
  final VoidCallback callback;

  @override
  _PeriodicCallbackState createState() => _PeriodicCallbackState();
}

class _PeriodicCallbackState extends HookState<void, _PeriodicCallback> {
  Timer? _timer;

  @override
  void initHook() {
    hook.callback.call(); // first time call
    _timer = Timer.periodic(hook.duration, (_) {
      hook.callback.call();
    });
  }

  @override
  void build(BuildContext context) {}

  @override
  void dispose() {
    if (_timer == null) return;
    _timer?.cancel();
  }
}
