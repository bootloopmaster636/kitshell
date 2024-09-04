import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kitshell/const.dart';
import 'package:kitshell/panel/logic/time/time.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        height: panelHeight,
        color: Theme.of(context).colorScheme.secondary,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TimePart(),
              DatePart(),
            ],
          ),
        ),
      ),
    );
  }
}

class TimePart extends ConsumerWidget {
  const TimePart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = ref.watch(timeInfoLogicProvider);

    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
      child: Row(
        children: [
          AnimatedFlipCounter(
            value: time.time.hour ?? 0,
            wholeDigits: 2,
            curve: Curves.easeOutQuad,
          ),
          const Text(':'),
          AnimatedFlipCounter(
            value: time.time.minute ?? 0,
            wholeDigits: 2,
            curve: Curves.easeOutQuad,
          ),
          const Text(':'),
          AnimatedFlipCounter(
            value: time.time.second ?? 0,
            wholeDigits: 2,
            curve: Curves.easeOutQuad,
          ),
        ],
      ),
    );
  }
}

class DatePart extends ConsumerWidget {
  const DatePart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = ref.watch(timeInfoLogicProvider);

    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 10,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
      child: Row(
        children: [
          AnimatedFlipCounter(
            value: time.time.day ?? 0,
            wholeDigits: 2,
            curve: Curves.easeOutQuad,
          ),
          const Text('/'),
          AnimatedFlipCounter(
            value: time.time.month ?? 0,
            wholeDigits: 2,
            curve: Curves.easeOutQuad,
          ),
          const Text('/'),
          AnimatedFlipCounter(
            value: time.time.year ?? 0,
            wholeDigits: 4,
            curve: Curves.easeOutQuad,
          ),
        ],
      ),
    );
  }
}
