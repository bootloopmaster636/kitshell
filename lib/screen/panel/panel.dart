import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitshell/etc/buildcontext_extension.dart';
import 'package:kitshell/etc/panel_enum.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_manager/panel_manager_bloc.dart';

class MainPanel extends StatelessWidget {
  const MainPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ColoredBox(
        color: context.colorScheme.surface.withValues(alpha: 0.9),
        child: BlocBuilder<PanelManagerBloc, PanelManagerState>(
          bloc: get<PanelManagerBloc>(),
          builder: (context, state) {
            if (state is! PanelManagerStateLoaded) return const SizedBox();
            return Stack(
              fit: StackFit.expand,
              children: [
                // Left section
                SectionRow(
                  position: WidgetPosition.left,
                  components: state.componentsLeft,
                ).animate().slideX(
                  begin: -1,
                  end: 0,
                  delay: Durations.long3,
                  duration: Durations.long4,
                  curve: Easing.emphasizedDecelerate,
                ),

                // Mid section
                SectionRow(
                  position: WidgetPosition.center,
                  components: state.componentsCenter,
                ).animate().slideY(
                  begin: 1,
                  end: 0,
                  delay: Durations.long3,
                  duration: Durations.long4,
                  curve: Easing.emphasizedDecelerate,
                ),

                // Right section
                SectionRow(
                  position: WidgetPosition.right,
                  components: state.componentsRight,
                ).animate().slideX(
                  begin: 1,
                  end: 0,
                  delay: Durations.long3,
                  duration: Durations.long4,
                  curve: Easing.emphasizedDecelerate,
                ),
              ],
            );
          },
        ),
      ),
    ).animate().slideY(
      begin: 1,
      end: 0,
      duration: Durations.long4,
      curve: Easing.emphasizedDecelerate,
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
      child: Row(
        mainAxisAlignment: switch (position) {
          WidgetPosition.left => MainAxisAlignment.start,
          WidgetPosition.center => MainAxisAlignment.center,
          WidgetPosition.right => MainAxisAlignment.end,
        },
        children: components,
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
