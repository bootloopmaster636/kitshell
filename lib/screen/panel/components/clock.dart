import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:kitshell/etc/component/clickable_panel_component.dart';
import 'package:kitshell/etc/component/panel_enum.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/etc/utitity/gap.dart';
import 'package:kitshell/etc/utitity/hooks/callback_debounce_hook.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_components/clock_and_notif/datetime/datetime_cubit.dart';
import 'package:kitshell/logic/panel_components/clock_and_notif/notifications/notification_bloc.dart';
import 'package:kitshell/screen/panel/panel.dart';
import 'package:kitshell/src/rust/api/notifications.dart';

class ClockComponent extends HookWidget {
  const ClockComponent({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      get<DatetimeCubit>().startTimer();
      get<NotificationBloc>().add(const NotificationEventStarted());
      return () => get<DatetimeCubit>().stopTimer();
    }, []);

    return ClickablePanelComponent(
      content: const Row(
        children: [
          NotificationDataSource(),
          DateTimeComponent(),
        ],
      ),
      popupPosition: InheritedAlignment.of(context).position,
      popupToShow: PopupWidget.notifications,
    );
  }
}

class NotificationDataSource extends StatelessWidget {
  const NotificationDataSource({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      bloc: get<NotificationBloc>(),
      builder: (context, state) {
        if (state is! NotificationStateLoaded) return const SizedBox.shrink();
        if (state.notifications.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: NotificationComponent(notificationState: state),
        );
      },
    );
  }
}

class NotificationComponent extends HookWidget {
  const NotificationComponent({required this.notificationState, super.key});
  final NotificationStateLoaded notificationState;

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(false);
    useCallbackDebounced(
      duration: 3.seconds,
      onStart: () => isExpanded.value = true,
      onEnd: () => isExpanded.value = false,
      keys: [notificationState.notifications.length],
    );

    return AnimatedCrossFade(
      alignment: Alignment.centerLeft,
      firstChild: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.primary,
          borderRadius: BorderRadius.circular(999),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          notificationState.notifications.length.toString(),
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      secondChild: NotificationDisplay(
        data: notificationState.notifications.first,
      ),
      crossFadeState: isExpanded.value
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: Durations.medium3,
      sizeCurve: Easing.standard,
    );
  }
}

class NotificationDisplay extends StatelessWidget {
  const NotificationDisplay({required this.data, super.key});
  final NotificationData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer,
        border: Border.all(color: context.colorScheme.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Gaps.sm.value,
        children: [
          SizedBox(
            width: 8,
            child: ColoredBox(color: context.colorScheme.primary),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.appName,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  data.summary,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colorScheme.onPrimaryContainer,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DateTimeComponent extends StatelessWidget {
  const DateTimeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
