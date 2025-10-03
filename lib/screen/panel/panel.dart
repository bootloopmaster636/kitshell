import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitshell/etc/utitity/config.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_manager/panel_manager_bloc.dart';
import 'package:kitshell/logic/screen_manager/panel_enum.dart';
import 'package:kitshell/logic/screen_manager/panel_gesture_cubit.dart';
import 'package:kitshell/logic/screen_manager/screen_manager_bloc.dart';

class MainPanel extends StatelessWidget {
  const MainPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PanelManagerBloc, PanelManagerState>(
      bloc: get<PanelManagerBloc>(),
      builder: (context, state) {
        if (state is! PanelManagerStateLoaded) return const SizedBox();

        return Material(
          color: Colors.transparent,
          child: PanelPopupDragTarget(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Stack(
                children: [
                  // Left section
                  RepaintBoundary(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child:
                          SectionRow(
                            position: WidgetPosition.left,
                            components: state.componentsLeft,
                          ).animate().slideX(
                            begin: -1,
                            end: 0,
                            duration: Durations.long4,
                            curve: Easing.emphasizedDecelerate,
                          ),
                    ),
                  ),

                  // Mid section
                  RepaintBoundary(
                    child: Align(
                      child:
                          SectionRow(
                            position: WidgetPosition.center,
                            components: state.componentsCenter,
                          ).animate().slideY(
                            begin: 1,
                            end: 0,
                            duration: Durations.long4,
                            curve: Easing.emphasizedDecelerate,
                          ),
                    ),
                  ),

                  // Right section
                  RepaintBoundary(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child:
                          SectionRow(
                            position: WidgetPosition.right,
                            components: state.componentsRight,
                          ).animate().slideX(
                            begin: 1,
                            end: 0,
                            duration: Durations.long4,
                            curve: Easing.emphasizedDecelerate,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class PanelPopupDragTarget extends StatelessWidget {
  const PanelPopupDragTarget({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onAcceptWithDetails: (_) {
        get<ScreenManagerBloc>().add(const ScreenManagerEventClosePopup());
        get<PanelGestureCubit>().setPanelGestureState(readyToClose: false);
      },
      onWillAcceptWithDetails: (details) {
        get<PanelGestureCubit>().setPanelGestureState(readyToClose: true);
        return details.data == 'popup';
      },
      onLeave: (_) {
        get<PanelGestureCubit>().setPanelGestureState(readyToClose: false);
      },
      builder: (context, candidateData, rejectedData) {
        return Stack(
          children: [
            child
                .animate(target: candidateData.isNotEmpty ? 1 : 0)
                .slideY(
                  end: 0.1,
                  duration: Durations.medium1,
                  curve: Curves.easeInOutCubic,
                )
                .fade(
                  end: 0.6,
                  begin: 1,
                  duration: Durations.medium1,
                ),
            if (candidateData.isNotEmpty)
              Container(
                    width: double.infinity,
                    height: panelDefaultHeightPx.toDouble() + 16,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          context.colorScheme.primaryContainer.withValues(
                            alpha: 0,
                          ),
                          context.colorScheme.primaryContainer.withValues(
                            alpha: 0.6,
                          ),
                          context.colorScheme.surfaceContainer.withValues(
                            alpha: 0.8,
                          ),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      t.general.closePopup,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  )
                  .animate(
                    target: candidateData.isNotEmpty ? 1 : 0,
                    delay: 1.seconds,
                  )
                  .slideY(
                    begin: 1,
                    duration: Durations.medium1,
                    curve: Easing.standard,
                  )
                  .fadeIn(
                    begin: 0.4,
                  ),
          ],
        );
      },
    );
  }
}

class SectionRow extends StatelessWidget {
  const SectionRow({
    required this.position,
    required this.components,
    super.key,
  });

  final WidgetPosition position;
  final List<Widget> components;

  @override
  Widget build(BuildContext context) {
    return InheritedAlignment(
      position: position,
      child: Container(
        height: panelDefaultHeightPx.toDouble(),
        decoration: BoxDecoration(
          color: context.colorScheme.surface.withValues(alpha: 0.76),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow.withValues(alpha: 0.5),
              blurRadius: 4,
              blurStyle: BlurStyle.outer,
            ),
            BoxShadow(
              color: context.colorScheme.primaryContainer.withValues(
                alpha: 0.5,
              ),
              blurStyle: BlurStyle.solid,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisAlignment: switch (position) {
            WidgetPosition.left => MainAxisAlignment.start,
            WidgetPosition.center => MainAxisAlignment.center,
            WidgetPosition.right => MainAxisAlignment.end,
          },
          mainAxisSize: MainAxisSize.min,
          children: components,
        ),
      ),
    );
  }
}

class InheritedAlignment extends InheritedWidget {
  const InheritedAlignment({
    required this.position,
    required super.child,
    super.key,
  });

  final WidgetPosition position;

  static InheritedAlignment? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedAlignment>();
  }

  static InheritedAlignment of(BuildContext context) {
    final result = maybeOf(context);
    assert(
      result != null,
      'No alignment inherited widget found in this context!',
    );
    return result!;
  }

  @override
  bool updateShouldNotify(InheritedAlignment oldWidget) =>
      position != oldWidget.position;
}
