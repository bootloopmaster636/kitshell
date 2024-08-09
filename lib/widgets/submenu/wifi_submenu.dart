import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kitshell/const.dart';
import 'package:kitshell/widgets/utility.dart';

class WifiSubmenu extends StatelessWidget {
  const WifiSubmenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Submenu(
      icon: FontAwesomeIcons.wifi,
      title: 'Wi-Fi',
      action: Switch(value: true, onChanged: (value) {}),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: panelHeight / 4),
        child: Text('Work In Progress :D'),
      ),
    );
  }
}
