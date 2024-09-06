import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:kitshell/panel/logic/appmenu/appmenu.dart';
import 'package:kitshell/src/rust/api/appmenu.dart';

class AppMenuContent extends ConsumerWidget {
  const AppMenuContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(appmenuLogicProvider);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: data.isLoading || data.value == null
          ? const Center(
              child: Column(
              children: [
                CircularProgressIndicator(),
                Gap(8),
                Text('Loading apps, this might take a while...'),
              ],
            ))
          : GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              children: data.value!.map((AppData e) => AppmenuItem(app: e)).toList(),
            ),
    );
  }
}

class AppmenuItem extends StatelessWidget {
  const AppmenuItem({required this.app, super.key});

  final AppData app;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  app.name,
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                ),
                Text(
                  app.icon,
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
