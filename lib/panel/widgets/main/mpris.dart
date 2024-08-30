import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kitshell/const.dart';
import 'package:kitshell/panel/logic/mpris/mpris.dart';
import 'package:kitshell/src/rust/api/mpris.dart';
import 'package:octo_image/octo_image.dart';

class Mpris extends HookConsumerWidget {
  const Mpris({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mprisData = ref.watch(mprisLogicProvider);
    final isHovered = useState(false);

    return RepaintBoundary(
      child: MouseRegion(
        onHover: (event) {
          isHovered.value = true;
        },
        onExit: (event) {
          isHovered.value = false;
        },
        child: mprisData.when(
          data: (data) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutExpo,
              width: isHovered.value ? panelWidth / 4 : panelWidth / 6,
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  ClipRect(
                    clipBehavior: Clip.antiAlias,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: OctoImage(
                        image: (mprisData.value!.imageUrl.startsWith('file://'))
                            ? FileImage(File(mprisData.value?.imageUrl.replaceFirst('file://', '') ?? ''))
                            : NetworkImage(mprisData.value?.imageUrl ?? ''),
                        fit: BoxFit.cover,
                        memCacheHeight: panelHeight.toInt(),
                        memCacheWidth: panelHeight.toInt(),
                      ),
                    ),
                  ),
                  ColoredBox(
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.75),
                    child: MprisContent(isHovered: isHovered),
                  ),
                ],
              ),
            );
          },
          loading: () {
            return const SizedBox();
          },
          error: (error, stackTrace) {
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class MprisContent extends ConsumerWidget {
  const MprisContent({required this.isHovered, super.key});

  final ValueNotifier<bool> isHovered;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mprisData = ref.watch(mprisLogicProvider);

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.3),
                  blurRadius: 4,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: OctoImage(
                image: (mprisData.value!.imageUrl.startsWith('file://'))
                    ? FileImage(File(mprisData.value?.imageUrl.replaceFirst('file://', '') ?? ''))
                    : NetworkImage(mprisData.value?.imageUrl ?? ''),
                memCacheHeight: panelHeight.toInt() * 2,
                memCacheWidth: panelHeight.toInt() * 2,
                progressIndicatorBuilder: (context, event) {
                  return Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mprisData.value?.title ?? 'Unknown Title',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                mprisData.value?.artist.join(', ') ?? 'Unknown Artist',
                style: const TextStyle(
                  fontSize: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (mprisData.value != null && mprisData.value?.duration != BigInt.zero)
                Column(
                  children: [
                    const Gap(4),
                    LinearProgressIndicator(
                      value: mprisData.value!.position / mprisData.value!.duration,
                      borderRadius: BorderRadius.circular(999),
                      minHeight: 2,
                      color: Theme.of(context).colorScheme.onSurface,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                    ),
                  ],
                ),
            ],
          ),
        ),
        const Gap(16),
        PlayerControls(isHovered: isHovered, mprisData: mprisData),
      ],
    );
  }
}

class PlayerControls extends StatelessWidget {
  const PlayerControls({
    required this.isHovered,
    required this.mprisData,
    super.key,
  });

  final ValueNotifier<bool> isHovered;
  final AsyncValue<MprisData> mprisData;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState: isHovered.value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 500),
      sizeCurve: Curves.easeOutExpo,
      alignment: Alignment.centerLeft,
      firstChild: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: mprisData.value!.canPrevious
                ? () async {
                    await playerPrevious();
                  }
                : null,
          ),
          IconButton(
            icon: Icon(mprisData.value!.isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: () async {
              if (mprisData.value!.isPlaying) {
                await playerPause();
              } else {
                await playerPlay();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: mprisData.value!.canNext
                ? () async {
                    await playerNext();
                  }
                : null,
          ),
        ],
      ),
      secondChild: const SizedBox(),
    );
  }
}
