import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitshell/etc/component/panel_enum.dart';
import 'package:kitshell/etc/utitity/config.dart';
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
        return AnimatedAlign(
              duration: Durations.medium4,
              curve: Curves.easeOutQuart,
              alignment: switch (state.position) {
                WidgetPosition.left => Alignment.bottomLeft,
                WidgetPosition.center => Alignment.bottomCenter,
                WidgetPosition.right => Alignment.bottomRight,
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Material(
                  color: Colors.transparent,
                  child: AnimatedSwitcher(
                    duration: Durations.long1,
                    child: state.popupShown.widget,
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
            .fade(
              begin: 0,
              end: 1,
              duration: popupOpenCloseDuration,
            );
      },
    );
  }
}
