import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kitshell/const.dart';
import 'package:kitshell/widgets/utility.dart';

class BatterySubmenu extends StatelessWidget {
  const BatterySubmenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Submenu(
      icon: FontAwesomeIcons.batteryThreeQuarters,
      title: 'Battery',
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: panelHeight / 4),
        child: Text('Work In Progress :D'),
      ),
    );
  }
}
