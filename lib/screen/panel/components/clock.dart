import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:kitshell/etc/component/clickable_panel_component.dart';
import 'package:kitshell/etc/component/panel_enum.dart';
import 'package:kitshell/etc/utitity/buildcontext_extension.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_components/clock_and_notif/datetime/datetime_cubit.dart';
import 'package:kitshell/screen/panel/panel.dart';

class ClockComponent extends HookWidget {
  const ClockComponent({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      get<DatetimeCubit>().startTimer();
      return () => get<DatetimeCubit>().stopTimer();
    }, []);

    return ClickablePanelComponent(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: switch (InheritedAlignment.of(context).position) {
          WidgetPosition.left => CrossAxisAlignment.start,
          WidgetPosition.center => CrossAxisAlignment.center,
          WidgetPosition.right => CrossAxisAlignment.end,
        },
        children: const [
          ClockPart(),
          DatePart(),
        ],
      ),
      popupPosition: InheritedAlignment.of(context).position,
      popupToShow: PopupWidget.calendar,
    );
  }
}

class ClockPart extends StatelessWidget {
  const ClockPart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatetimeCubit, DatetimeState>(
      bloc: get<DatetimeCubit>(),
      buildWhen: (old, current) {
        if (current is! DatetimeLoaded || old is! DatetimeLoaded) return true;
        return current.now.minute != old.now.minute;
      },
      builder: (context, state) {
        if (state is! DatetimeLoaded) return const SizedBox();

        return Row(
          children: [
            AnimatedFlipCounter(
              value: state.now.hour,
              duration: Durations.medium1,
              curve: Easing.standard,
              wholeDigits: 2,
              textStyle: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ':',
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AnimatedFlipCounter(
              value: state.now.minute,
              duration: Durations.medium1,
              curve: Easing.standard,
              wholeDigits: 2,
              textStyle: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }
}

class DatePart extends StatelessWidget {
  const DatePart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatetimeCubit, DatetimeState>(
      bloc: get<DatetimeCubit>(),
      builder: (context, state) {
        if (state is! DatetimeLoaded) return const SizedBox();

        return Text(
          DateFormat.yMMMEd(t.locale).format(state.now),
          style: context.textTheme.bodySmall,
        );
      },
    );
  }
}
