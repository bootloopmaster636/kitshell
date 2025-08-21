import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/screen_manager/screen_manager_bloc.dart';
import 'package:kitshell/screen/panel/panel.dart';
import 'package:kitshell/screen/popup/popup.dart';

class ScreenManager extends StatelessWidget {
  const ScreenManager({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScreenManagerBloc, ScreenManagerState>(
      bloc: get<ScreenManagerBloc>(),
      builder: (context, state) {
        if (state is! ScreenManagerStateLoaded) return const SizedBox();
        return const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(child: PopupContainer()),
            MainPanel(),
          ],
        );
      },
    );
  }
}
