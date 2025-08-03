import 'package:diffutil_dart/diffutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:intl/intl.dart';
import 'package:kitshell/etc/component/custom_inkwell.dart';
import 'package:kitshell/etc/utitity/config.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/etc/utitity/gap.dart';
import 'package:kitshell/etc/utitity/hooks/periodic_hooks.dart';
import 'package:kitshell/etc/utitity/logger.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_components/clock_and_notif/datetime/datetime_cubit.dart';
import 'package:kitshell/logic/panel_components/clock_and_notif/notifications/notification_bloc.dart';
import 'package:kitshell/src/rust/api/notifications.dart';

class NotificationsPopup extends StatelessWidget {
  const NotificationsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 560,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer.withValues(
          alpha: popupBgOpacity,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: ClockAndDate(),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.colorScheme.shadow.withValues(alpha: 0.2),
                    blurRadius: 2,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: const NotificationContent(),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationContent extends HookWidget {
  const NotificationContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Reemit state to fill the list when widget rebuild
    useEffect(() {
      get<NotificationBloc>().add(const NotificationEventRefreshed());
      return () {};
    });

    final listKey = useState(GlobalKey<AnimatedListState>());
    final items = useState<List<NotificationData>>([]);

    return BlocListener<NotificationBloc, NotificationState>(
      bloc: get<NotificationBloc>(),
      listener: (context, state) {
        if (state is! NotificationStateLoaded) return;

        // Get previous list difference
        final diff = calculateListDiff<NotificationData>(
          items.value,
          state.notifications,
          equalityChecker: (prev, now) => prev.id == now.id,
        ).getUpdates();

        // Update this widget list
        items.value = state.notifications;

        // Handle update event
        for (final update in diff) {
          update.when(
            insert: (int position, int count) {
              listKey.value.currentState?.insertItem(
                0,
              );
            },
            remove: (int position, int count) {
              listKey.value.currentState?.removeItem(
                position,
                (context, animation) =>
                    listBuilder(context, position, animation, items.value),
              );
            },
            change: (int position, Object? payload) {},
            move: (int from, int to) {},
          );
        }
      },
      child: AnimatedSwitcher(
        duration: Durations.medium3,
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeOutExpo,
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation.drive(Tween(begin: 0.8, end: 1)),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: items.value.isEmpty
            ? Center(
                child: Text(
                  t.dateTimeNotif.notification.noNotification,
                  style: context.textTheme.bodyMedium,
                ),
              )
            : AnimatedList(
                key: listKey.value,
                initialItemCount: items.value.length,
                itemBuilder:
                    (
                      BuildContext context,
                      int index,
                      Animation<double> animation,
                    ) => listBuilder(context, index, animation, items.value),
              ),
      ),
    );
  }

  Widget listBuilder(
    BuildContext context,
    int index,
    Animation<double> animation,
    List<NotificationData> items,
  ) {
    if (items.isEmpty) return const SizedBox.shrink();
    return SizeTransition(
      sizeFactor: animation.drive(
        CurveTween(curve: Curves.easeInOutQuart),
      ),
      axisAlignment: -1,
      child: Padding(
        key: ValueKey(items[index].hashCode),
        padding: const EdgeInsets.all(4).copyWith(
          bottom: Gaps.xs.value,
        ),
        child: NotificationTile(
          data: items[index],
          index: index,
        ),
      ),
    );
  }
}

class NotificationTile extends HookWidget {
  const NotificationTile({required this.data, required this.index, super.key});
  final NotificationData data;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(false);
    final timeAgo = useState(Duration.zero);

    // Refresh "time ago" every 5 seconds
    usePeriodic(
      duration: 5.seconds,
      callback: () {
        timeAgo.value = DateTime.now().difference(data.addedAt);
      },
    );

    // Expand notif for the first 3 notification
    useEffect(() {
      isExpanded.value = index < 3;
      return () {};
    }, [index]);

    return CustomInkwell(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      onTap: () => isExpanded.value = !isExpanded.value,
      hoverColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                data.appName,
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 4,
                child: VerticalDivider(
                  radius: BorderRadius.circular(8),
                  width: 16,
                  color: context.colorScheme.outlineVariant,
                  thickness: 4,
                ),
              ),
              Text(
                timeAgo.value.toDynamicTime(
                  t,
                ),
                style: context.textTheme.bodySmall,
              ),
              const Spacer(),
              SizedBox.square(
                    dimension: 20,
                    child: IconButton(
                      icon: Iconify(
                        Ic.round_close,
                        size: 12,
                        color: context.colorScheme.onSurface,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor:
                            context.colorScheme.surfaceContainerHigh,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () => get<NotificationBloc>().add(
                        NotificationEventClosed(data.id),
                      ),
                    ),
                  )
                  .animate(target: isExpanded.value ? 1 : 0)
                  .fade(begin: 0.2, end: 1, duration: Durations.medium1),
            ],
          ),

          // Summary
          AnimatedDefaultTextStyle(
            duration: Durations.medium1,
            curve: Easing.standard,
            style:
                (isExpanded.value
                    ? context.textTheme.bodySmall
                    : context.textTheme.bodyMedium) ??
                context.textTheme.bodyMedium!,
            child: Text(
              data.summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Content
          AnimatedCrossFade(
            duration: Durations.medium1,
            sizeCurve: Easing.standard,
            alignment: Alignment.topLeft,
            crossFadeState: isExpanded.value
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Container(
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Html(
                  data: data.body,
                ),
              ),
            ),
            secondChild: const SizedBox(width: double.infinity, height: 0),
          ),
        ],
      ),
    );
  }
}

class ClockAndDate extends StatelessWidget {
  const ClockAndDate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatetimeCubit, DatetimeState>(
      bloc: get<DatetimeCubit>(),
      builder: (context, state) {
        if (state is! DatetimeLoaded) return const SizedBox();

        return Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat.Hms(t.locale).format(state.now),
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat.yMMMMEEEEd(t.locale).format(state.now),
                  style: context.textTheme.titleSmall,
                ),
              ],
            ),
            const Spacer(),
            SizedBox.square(
              dimension: 32,
              child: IconButton(
                icon: Iconify(
                  Ic.round_clear_all,
                  size: 16,
                  color: context.colorScheme.onSurface,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: context.colorScheme.surfaceContainerHighest,
                ),
                padding: EdgeInsets.zero,
                onPressed: () => get<NotificationBloc>().add(
                  const NotificationEventCleared(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
