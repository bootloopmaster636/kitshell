import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:intl/intl.dart';
import 'package:kitshell/etc/component/clickable_panel_component.dart';
import 'package:kitshell/etc/utitity/config.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/etc/utitity/gap.dart';
import 'package:kitshell/etc/utitity/hooks/callback_debounce_hook.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_components/clock_and_notif/datetime/datetime_cubit.dart';
import 'package:kitshell/logic/panel_components/clock_and_notif/notifications/notification_bloc.dart';
import 'package:kitshell/logic/screen_manager/panel_enum.dart';
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
      content: Stack(
        children: [
          // Date time and notif count
          const Row(
            children: [
              NotificationCount(),
              DateTimeComponent(),
            ],
          ),

          // Notif toast
          Align(
            alignment: switch (InheritedAlignment.of(context).position) {
              WidgetPosition.left => Alignment.centerLeft,
              WidgetPosition.center => Alignment.center,
              WidgetPosition.right => Alignment.centerRight,
            },
            child: const NotificationToast(),
          ),
        ],
      ),
      popupPosition: InheritedAlignment.of(context).position,
      popupToShow: PopupWidget.notifications,
    );
  }
}

class NotificationCount extends StatelessWidget {
  const NotificationCount({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      bloc: get<NotificationBloc>(),
      builder: (context, state) {
        if (state is! NotificationStateLoaded) return const SizedBox.shrink();
        if (state.notifications.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: EdgeInsets.only(right: Gaps.sm.value),
          child: AnimatedCrossFade(
            duration: Durations.medium1,
            sizeCurve: Easing.standard,
            crossFadeState: state.dndEnabled
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Container(
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                state.notifications.length.toString(),
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            secondChild: Iconify(
              Ic.outline_notifications_off,
              size: 16,
              color: context.colorScheme.onSurface,
            ),
          ),
        );
      },
    );
  }
}

class NotificationToast extends HookWidget {
  const NotificationToast({super.key});

  @override
  Widget build(BuildContext context) {
    final isShown = useState(false);
    final count = useState(0);

    useCallbackDebounced(
      duration: notificationToastDuration + Durations.medium1,
      onStart: () => isShown.value = true,
      onEnd: () => isShown.value = false,
      keys: [count.value],
    );

    return BlocConsumer<NotificationBloc, NotificationState>(
      bloc: get<NotificationBloc>(),
      listenWhen: (old, now) {
        if (old is! NotificationStateLoaded) return false;
        if (now is! NotificationStateLoaded) return false;

        // Prevent showing notification toast when dismissing notif
        return now.notifications.length > old.notifications.length;
      },
      listener: (context, state) {
        if (state is! NotificationStateLoaded) return;

        // Prevent showing toast when DND active
        if (state.dndEnabled) return;
        count.value = state.notifications.length;
      },
      builder: (context, state) {
        if (state is! NotificationStateLoaded) return const SizedBox.shrink();
        if (state.notifications.isEmpty) return const SizedBox.shrink();
        final notifToShow = state.notifications.first;

        return AnimatedCrossFade(
          crossFadeState: isShown.value
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild:
              Container(
                    constraints: const BoxConstraints(maxWidth: 250),
                    decoration: BoxDecoration(
                      color: context.colorScheme.surfaceContainerHigh,
                      border: Border(
                        left: BorderSide(
                          color: context.colorScheme.primary,
                          width: 4,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _notificationContent(context, notifToShow),
                  )
                  .animate(key: ValueKey(notifToShow.hashCode))
                  .shimmer(
                    duration: Durations.long2,
                    color: context.colorScheme.primary.withValues(alpha: 0.6),
                  )
                  .then(delay: notificationToastDuration)
                  .scaleXY(
                    begin: 1,
                    end: 0.8,
                    duration: Durations.medium1,
                    curve: Easing.standard,
                  )
                  .slideX(
                    begin: 0,
                    end: -0.4,
                    duration: Durations.medium1,
                    curve: Easing.standard,
                  )
                  .fade(
                    begin: 1,
                    end: 0,
                    duration: Durations.medium1,
                    curve: Easing.standard,
                  ),
          secondChild: const SizedBox(),
          sizeCurve: Easing.standard,
          duration: Durations.medium1,
        );
      },
    );
  }

  Widget _notificationContent(BuildContext context, NotificationData data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          [
                Text(
                  '${data.summary} | ${data.appName}',
                  style: context.textTheme.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  data.body,
                  style: context.textTheme.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ]
              .animate(delay: Durations.short4, interval: 60.ms)
              .slideY(
                begin: 1,
                end: 0,
                curve: Easing.standard,
                duration: Durations.medium1,
              )
              .fadeIn(
                curve: Easing.standard,
                duration: Durations.medium1,
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
      buildWhen: (previous, current) {
        if (previous is! DatetimeLoaded) return true;
        if (current is! DatetimeLoaded) return true;

        return previous.now.minute != current.now.minute;
      },
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
