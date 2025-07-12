import 'package:flutter/material.dart';
import 'package:kitshell/screen/panel/panel.dart';

class ScreenManager extends StatelessWidget {
  const ScreenManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MainPanel(),
      ],
    );
  }
}
