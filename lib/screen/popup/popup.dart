import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kitshell/etc/buildcontext_extension.dart';
import 'package:kitshell/etc/config.dart';
import 'package:kitshell/etc/panel_enum.dart';
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
            ColoredBox(
                  color: context.colorScheme.shadow.withValues(alpha: 0.1),
                )
                .animate(target: state.isPopupShown ? 1 : 0)
                .fade(begin: 0, end: 1, duration: popupOpenCloseDuration),
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

class PopupContent extends HookWidget {
  const PopupContent({super.key});

  @override
  Widget build(BuildContext context) {
    final widgetShown = useState<Widget>(const Placeholder());
    final popupPosition = useState(WidgetPosition.center);

    return BlocConsumer<ScreenManagerBloc, ScreenManagerState>(
      bloc: get<ScreenManagerBloc>(),
      listener: (context, state) {
        // This is to prevent widget suddenly disappear when closing
        if (state is! ScreenManagerStateLoaded) return;

        if (state.popupShown?.widget != null) {
          widgetShown.value = state.popupShown!.widget;
          popupPosition.value = state.position!;
        }
      },
      builder: (context, state) {
        if (state is! ScreenManagerStateLoaded) return const SizedBox();

        return Align(
              alignment: switch (popupPosition.value) {
                WidgetPosition.left => Alignment.bottomLeft,
                WidgetPosition.center => Alignment.bottomCenter,
                WidgetPosition.right => Alignment.bottomRight,
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: widgetShown.value,
              ),
            )
            .animate(target: state.isPopupShown ? 1 : 0)
            .slideY(
              begin: 0.8,
              end: 0,
              duration: popupOpenCloseDuration,
              curve: Curves.easeInOutCubicEmphasized,
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
