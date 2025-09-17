import 'dart:ui';

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
            child: NotifHeader(),
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
    }, []);

    final listKey = useState(GlobalKey<AnimatedListState>());
    final items = useState<List<NotificationData>>([]);

    final dndEnabled = useState(false);

    return BlocListener<NotificationBloc, NotificationState>(
      bloc: get<NotificationBloc>(),
      listener: (context, state) {
        if (state is! NotificationStateLoaded) return;
        dndEnabled.value = state.dndEnabled;

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
                position,
                duration: Durations.medium3,
              );
            },
            remove: (int position, int count) {
              listKey.value.currentState?.removeItem(
                position,
                (context, animation) => _buildTile(
                  context,
                  position,
                  animation.drive(
                    CurveTween(curve: Easing.emphasizedAccelerate),
                  ),
                  items.value,
                ),
                duration: Durations.medium1,
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
            : _buildList(
                context: context,
                listKey: listKey,
                items: items,
                dndEnabled: dndEnabled,
              ),
      ),
    );
  }

  Widget _buildList({
    required BuildContext context,
    required ValueNotifier<GlobalKey<AnimatedListState>> listKey,
    required ValueNotifier<List<NotificationData>> items,
    required ValueNotifier<bool> dndEnabled,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedList(
          key: listKey.value,
          initialItemCount: items.value.length,
          padding: const EdgeInsets.all(8),
          itemBuilder:
              (
                BuildContext context,
                int index,
                Animation<double> animation,
              ) => _buildTile(
                context,
                index,
                animation.drive(CurveTween(curve: Easing.standard)),
                items.value,
              ),
        ),
        if (dndEnabled.value) _dndNoticeBuilder(context),
      ],
    );
  }

  Widget _dndNoticeBuilder(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
        bottomLeft: Radius.circular(8),
        bottomRight: Radius.circular(8),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: double.infinity,
          color: context.colorScheme.surface.withValues(
            alpha: 0.6,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                [
                      Iconify(
                        Ic.outline_notifications_off,
                        size: 48,
                        color: context.colorScheme.onSurface,
                      ),
                      SizedBox(height: Gaps.sm.value),
                      Text(
                        t.dateTimeNotif.notification.doNotDisturbEnabled,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        t.dateTimeNotif.notification.doNotDisturbDesc,
                        style: context.textTheme.bodyMedium,
                      ),
                    ]
                    .animate(interval: 60.ms, delay: Durations.short1)
                    .slideY(
                      begin: -0.4,
                      end: 0,
                      duration: Durations.medium1,
                      curve: Easing.standard,
                    )
                    .fadeIn(duration: Durations.medium1),
          ),
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context,
    int index,
    Animation<double> animation,
    List<NotificationData> items,
  ) {
    if (items.isEmpty) return const SizedBox.shrink();
    return SizeTransition(
      sizeFactor: animation,
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
                    backgroundColor: context.colorScheme.surfaceContainerHigh,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () => get<NotificationBloc>().add(
                    NotificationEventClosed(data.id),
                  ),
                ),
              ),
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
          AnimatedSize(
            duration: Durations.medium2,
            curve: Curves.easeInOutCubic,
            alignment: Alignment.topCenter,
            child: isExpanded.value
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.colorScheme.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Html(data: data.body),
                    ),
                  )
                : const SizedBox(width: double.infinity, height: 0),
          ),
        ],
      ),
    );
  }
}

class NotifHeader extends StatelessWidget {
  const NotifHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatetimeCubit, DatetimeState>(
      bloc: get<DatetimeCubit>(),
      builder: (context, state) {
        if (state is! DatetimeLoaded) return const SizedBox();

        return const Row(
          children: [
            DateTimeSection(),
            Spacer(),
            ActionsSection(),
          ],
        );
      },
    );
  }
}

class DateTimeSection extends StatelessWidget {
  const DateTimeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatetimeCubit, DatetimeState>(
      bloc: get<DatetimeCubit>(),
      builder: (context, state) {
        if (state is! DatetimeLoaded) return const SizedBox();

        return Column(
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
        );
      },
    );
  }
}

class ActionsSection extends StatelessWidget {
  const ActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      bloc: get<NotificationBloc>(),
      builder: (context, state) {
        if (state is! NotificationStateLoaded) return const SizedBox();

        return Row(
          mainAxisSize: MainAxisSize.min,
          spacing: Gaps.sm.value,
          children: [
            // Clear all button
            AnimatedSize(
              duration: Durations.medium1,
              curve: Easing.emphasizedDecelerate,
              child: SizedBox.square(
                dimension: state.notifications.isNotEmpty ? 32 : 0,
                child: IconButton(
                  icon: Iconify(
                    Ic.round_clear_all,
                    size: 16,
                    color: context.colorScheme.onSurface,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor:
                        context.colorScheme.surfaceContainerHighest,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () => get<NotificationBloc>().add(
                    const NotificationEventCleared(),
                  ),
                ),
              ),
            ),

            // DND button
            SizedBox.square(
              dimension: 32,
              child: IconButton(
                icon: Iconify(
                  Ic.outline_notifications_off,
                  size: 16,
                  color: state.dndEnabled
                      ? context.colorScheme.onPrimary
                      : context.colorScheme.onSurface,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: state.dndEnabled
                      ? context.colorScheme.primary
                      : context.colorScheme.surfaceContainerHighest,
                ),
                padding: EdgeInsets.zero,
                onPressed: () => get<NotificationBloc>().add(
                  const NotificationEventDndToggled(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
