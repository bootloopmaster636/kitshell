import 'package:flutter/material.dart';
import 'package:kitshell/etc/utitity/buildcontext_extension.dart';

class WorkInProgress extends StatelessWidget {
  const WorkInProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('🏗️', style: context.textTheme.titleLarge),
        Text('Work in Progress 😄', style: context.textTheme.titleSmall),
      ],
    );
  }
}
