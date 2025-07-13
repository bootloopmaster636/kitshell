import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:kitshell/etc/buildcontext_extension.dart';
import 'package:kitshell/etc/config.dart';
import 'package:kitshell/etc/gap.dart';
import 'package:kitshell/etc/utiltity_widget.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_components/clock_and_notif/datetime/datetime_cubit.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarAndNotifPopup extends StatelessWidget {
  const CalendarAndNotifPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 680,
      height: 560,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(16),
      child: const CalendarAndNotifContent(),
    );
  }
}

class CalendarAndNotifContent extends StatelessWidget {
  const CalendarAndNotifContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Gaps.sm.value,
      children: const [
        Expanded(child: ClockAndCalendar()),
        Expanded(child: NotificationContent()),
      ],
    );
  }
}

class NotificationContent extends StatelessWidget {
  const NotificationContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const WorkInProgress();
  }
}

class ClockAndCalendar extends StatelessWidget {
  const ClockAndCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatetimeCubit, DatetimeState>(
      bloc: get<DatetimeCubit>(),
      builder: (context, state) {
        if (state is! DatetimeLoaded) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              [
                    Text(
                      DateFormat.Hms(t.locale).format(state.now),
                      style: context.textTheme.displaySmall,
                    ),
                    Text(
                      DateFormat.yMMMMEEEEd(t.locale).format(state.now),
                      style: context.textTheme.titleMedium,
                    ),
                    SizedBox(height: Gaps.md.value),
                    Container(
                      decoration: BoxDecoration(
                        color: context.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: context.colorScheme.shadow.withValues(
                              alpha: 0.2,
                            ),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Calendar(),
                    ),
                  ]
                  .animate(
                    interval: 20.ms,
                    delay: popupOpenCloseDuration ~/ 2,
                  )
                  .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: Durations.long1,
                    curve: Curves.easeOutCubic,
                  )
                  .fadeIn(
                    duration: Durations.long1,
                  ),
        );
      },
    );
  }
}

class Calendar extends HookWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    final focusedDay = useState(DateTime.now());
    final selectedDay = useState(DateTime.now());

    return TableCalendar<void>(
      locale: t.locale,
      focusedDay: focusedDay.value,
      firstDay: focusedDay.value.subtract(const Duration(days: 365 * 3)),
      lastDay: focusedDay.value.add(const Duration(days: 365 * 3)),
      onPageChanged: (focusedDayVal) => focusedDay.value = focusedDayVal,
      selectedDayPredicate: (day) => isSameDay(selectedDay.value, day),
      onDaySelected: (selectedDayVal, focusedDayVal) {
        focusedDay.value = focusedDayVal;
        selectedDay.value = selectedDayVal;
      },
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        leftChevronMargin: EdgeInsets.zero,
        leftChevronPadding: EdgeInsets.symmetric(horizontal: 4),
        rightChevronMargin: EdgeInsets.zero,
        rightChevronPadding: EdgeInsets.symmetric(horizontal: 4),
        titleCentered: true,
      ),
    );
  }
}
