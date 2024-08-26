import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kitshell/const.dart';

class Mpris extends StatelessWidget {
  const Mpris({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: panelWidth / 6,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRect(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Image.asset(
                'assets/kujou.jpg',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.6),
            padding: const EdgeInsets.all(8),
            child: const MprisContent(),
          ),
        ],
      ),
    );
  }
}

class MprisContent extends StatelessWidget {
  const MprisContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(
            'assets/kujou.jpg',
          ),
        ),
        const Gap(8),
        const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ichiban Kagayaku Hoshi',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Alya (CV: Uesaka Sumire)',
              style: TextStyle(fontSize: 10),
            ),
          ],
        )
      ],
    );
  }
}
