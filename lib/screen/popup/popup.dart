import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitshell/etc/utitity/config.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/screen_manager/panel_enum.dart';
import 'package:kitshell/logic/screen_manager/panel_gesture_cubit.dart';
import 'package:kitshell/logic/screen_manager/screen_manager_bloc.dart';

class PopupContainer extends StatelessWidget {
  const PopupContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScreenManagerBloc, ScreenManagerState>(
      bloc: get<ScreenManagerBloc>(),
      builder: (BuildContext context, ScreenManagerState state) {
        if (state is! ScreenManagerStateLoaded) return const SizedBox();
        return Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (context) => Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    get<ScreenManagerBloc>().add(
                      const ScreenManagerEventClosePopup(),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: PopupContent(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PopupContent extends StatelessWidget {
  const PopupContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScreenManagerBloc, ScreenManagerState>(
      bloc: get<ScreenManagerBloc>(),
      builder: (context, state) {
        if (state is! ScreenManagerStateLoaded) return const SizedBox();

        return AnimatedAlign(
              duration: Durations.medium4,
              curve: Curves.easeOutQuint,
              alignment: switch (state.position) {
                WidgetPosition.left => Alignment.bottomLeft,
                WidgetPosition.center => Alignment.bottomCenter,
                WidgetPosition.right => Alignment.bottomRight,
              },
              child: PopupChild(
                popup: state.popupShown,
              ),
            )
            .animate(
              target: state.popupShown != PopupWidget.none ? 1 : 0,
            )
            .slideY(
              begin: 0.2,
              end: 0,
              duration: popupOpenCloseDuration,
              curve: Easing.standard,
            );
      },
    );
  }
}

class PopupChild extends StatelessWidget {
  const PopupChild({required this.popup, super.key});

  final PopupWidget popup;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: BlocBuilder<PanelGestureCubit, PanelGestureState>(
        bloc: get<PanelGestureCubit>(),
        builder: (context, state) {
          return Container(
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainer.withValues(
                    alpha: popupBgOpacity,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: context.colorScheme.outlineVariant,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.colorScheme.shadow.withValues(
                        alpha: 0.6,
                      ),
                      blurRadius: 8,
                      blurStyle: BlurStyle.outer,
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: AnimatedSize(
                  duration: Durations.medium4,
                  curve: Curves.easeInOutCubicEmphasized,
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  child: Draggable(
                    key: ValueKey(popup.hashCode),
                    data: 'popup',
                    maxSimultaneousDrags: 1,
                    axis: Axis.vertical,
                    feedback: const SizedBox.shrink(),
                    child: popup.widget,
                  ),
                ),
              )
              .animate(target: state.readyToClose ? 1 : 0)
              .slideY(
                end: 0.1,
                duration: Durations.medium1,
                curve: Curves.easeInOutCubic,
              )
              .fade(
                begin: 1,
                end: 0.8,
                duration: Durations.medium1,
              );
        },
      ),
    );
  }
}
