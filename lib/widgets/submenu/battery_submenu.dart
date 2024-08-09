import 'package:flutter/material.dart';
import 'package:kitshell/const.dart';
import 'package:kitshell/widgets/utility.dart';

class BatterySubmenu extends StatelessWidget {
  const BatterySubmenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Submenu(
      icon: Icons.battery_0_bar_rounded,
      title: 'Battery',
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: panelHeight / 4),
        child: Text('Work In Progress :D'),
      ),
    );
  }
}
