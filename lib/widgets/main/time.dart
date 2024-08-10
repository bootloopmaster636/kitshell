import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitshell/logic/time/time.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ColoredBox(
        color: Theme.of(context).colorScheme.primaryContainer,
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
  const TimePart({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = ref.watch(timeInfoLogicProvider);
    return DefaultTextStyle(
      style: TextStyle(
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      child: Row(
        children: [
          AnimatedFlipCounter(
            value: time.time.hour,
            wholeDigits: 2,
            curve: Curves.easeOutQuad,
          ),
          const Text(':'),
          AnimatedFlipCounter(
            value: time.time.minute,
            wholeDigits: 2,
            curve: Curves.easeOutQuad,
          ),
          const Text(':'),
          AnimatedFlipCounter(
            value: time.time.second,
            wholeDigits: 2,
            curve: Curves.easeOutQuad,
          ),
        ],
      ),
    );
  }
}

class DatePart extends ConsumerWidget {
  const DatePart({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = ref.watch(timeInfoLogicProvider);
    return DefaultTextStyle(
      style: TextStyle(
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontSize: 10,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      child: Row(
        children: [
          AnimatedFlipCounter(
            value: time.time.day,
            wholeDigits: 2,
            curve: Curves.easeOutQuad,
          ),
          const Text('/'),
          AnimatedFlipCounter(
            value: time.time.month,
            wholeDigits: 2,
            curve: Curves.easeOutQuad,
          ),
          const Text('/'),
          AnimatedFlipCounter(
            value: time.time.year,
            wholeDigits: 4,
            curve: Curves.easeOutQuad,
          ),
        ],
      ),
    );
  }
}
