import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitshell/logic/screen_manager/panel_enum.dart';
import 'package:kitshell/etc/utitity/config.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/screen_manager/screen_manager_bloc.dart';

class PopupContainer extends StatelessWidget {
  const PopupContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScreenManagerBloc, ScreenManagerState>(
      bloc: get<ScreenManagerBloc>(),
      builder: (BuildContext context, ScreenManagerState state) {
        if (state is! ScreenManagerStateLoaded) return const SizedBox();
        return Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: () {
                get<ScreenManagerBloc>().add(
                  const ScreenManagerEventClosePopup(),
                );
              },
            ),
            const PopupContent(),
          ],
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
        return Padding(
              padding: const EdgeInsets.all(8),
              child: AnimatedAlign(
                duration: Durations.long1,
                curve: Curves.easeOutQuint,
                alignment: switch (state.position) {
                  WidgetPosition.left => Alignment.bottomLeft,
                  WidgetPosition.center => Alignment.bottomCenter,
                  WidgetPosition.right => Alignment.bottomRight,
                },
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colorScheme.surfaceContainer.withValues(
                        alpha: popupBgOpacity,
                      ),
                      borderRadius: BorderRadius.circular(8),
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
                    child: AnimatedSize(
                      duration: Durations.long1,
                      curve: Curves.easeOutQuint,
                      alignment: Alignment.bottomCenter,
                      child: AnimatedSwitcher(
                        duration: Durations.medium1,
                        switchInCurve: Curves.easeInSine,
                        switchOutCurve: Curves.easeOutSine,
                        child: state.popupShown.widget,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .animate(
              target: state.isPopupShown ? 1 : 0,
            )
            .slideY(
              begin: 0.2,
              end: 0,
              duration: popupOpenCloseDuration,
              curve: Easing.standard,
            )
            .fadeIn(
              duration: popupOpenCloseDuration,
            );
      },
    );
  }
}
