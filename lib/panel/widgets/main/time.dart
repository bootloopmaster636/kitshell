import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitshell/src/rust/api/time.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
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

class TimePart extends StatefulWidget {
  const TimePart({
    super.key,
  });

  @override
  State<TimePart> createState() => _TimePartState();
}

class _TimePartState extends State<TimePart> {
  late Stream<DateTime> time;

  @override
  void initState() {
    super.initState();
    time = timeStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: time,
      builder: (context, snap) {
        return DefaultTextStyle(
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          child: Row(
            children: [
              AnimatedFlipCounter(
                value: snap.data?.hour ?? 0,
                wholeDigits: 2,
                curve: Curves.easeOutQuad,
              ),
              const Text(':'),
              AnimatedFlipCounter(
                value: snap.data?.minute ?? 0,
                wholeDigits: 2,
                curve: Curves.easeOutQuad,
              ),
              const Text(':'),
              AnimatedFlipCounter(
                value: snap.data?.second ?? 0,
                wholeDigits: 2,
                curve: Curves.easeOutQuad,
              ),
            ],
          ),
        );
      },
    );
  }
}

class DatePart extends StatefulWidget {
  const DatePart({
    super.key,
  });

  @override
  State<DatePart> createState() => _DatePartState();
}

class _DatePartState extends State<DatePart> {
  late Stream<DateTime> time;

  @override
  void initState() {
    super.initState();
    time = timeStream();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontSize: 10,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      child: StreamBuilder(
          stream: time,
          builder: (context, snap) {
            return Row(
              children: [
                AnimatedFlipCounter(
                  value: snap.data?.day ?? 0,
                  wholeDigits: 2,
                  curve: Curves.easeOutQuad,
                ),
                const Text('/'),
                AnimatedFlipCounter(
                  value: snap.data?.month ?? 0,
                  wholeDigits: 2,
                  curve: Curves.easeOutQuad,
                ),
                const Text('/'),
                AnimatedFlipCounter(
                  value: snap.data?.year ?? 0,
                  wholeDigits: 4,
                  curve: Curves.easeOutQuad,
                ),
              ],
            );
          }),
    );
  }
}
