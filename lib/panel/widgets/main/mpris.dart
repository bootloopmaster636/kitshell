import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kitshell/panel/logic/mpris/mpris.dart';
import 'package:kitshell/settings/logic/layer_shell/layer_shell.dart';
import 'package:kitshell/src/rust/api/mpris.dart';
import 'package:octo_image/octo_image.dart';

class Mpris extends HookConsumerWidget {
  const Mpris({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mprisData = ref.watch(mprisLogicProvider);
    final isHovered = useState(false);
    final panelWidth =
        ref.watch(layerShellLogicProvider).value!.panelWidth.toDouble();
    final panelHeight = ref.watch(layerShellLogicProvider).value!.panelHeight;

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
            if (data.imageUrl.isEmpty) {
              return const NoPlayer();
            }
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutExpo,
              height: ref
                  .watch(layerShellLogicProvider)
                  .value
                  ?.panelHeight
                  .toDouble(),
              width: isHovered.value ? panelWidth / 5 : panelWidth / 6,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  ClipRect(
                    clipBehavior: Clip.antiAlias,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: OctoImage(
                        image: (mprisData.value!.imageUrl.startsWith('file://'))
                            ? FileImage(
                                File(mprisData.value?.imageUrl
                                        .replaceFirst('file://', '') ??
                                    '',),
                              )
                            : NetworkImage(mprisData.value?.imageUrl ?? ''),
                        fit: BoxFit.cover,
                        memCacheHeight: panelHeight,
                        memCacheWidth: panelHeight,
                      ),
                    ),
                  ),
                  ColoredBox(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.6),
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
            return const NoPlayer();
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
    final panelHeight = ref.watch(layerShellLogicProvider).value!.panelHeight;

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.3),
                  blurRadius: 4,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: OctoImage(
                image: (mprisData.value!.imageUrl.startsWith('file://'))
                    ? FileImage(File(
                        mprisData.value?.imageUrl.replaceFirst('file://', '') ??
                            '',),)
                    : NetworkImage(mprisData.value?.imageUrl ?? ''),
                memCacheHeight: panelHeight * 2,
                memCacheWidth: panelHeight * 2,
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
              if (mprisData.value != null &&
                  mprisData.value?.duration != BigInt.zero)
                Column(
                  children: [
                    const Gap(4),
                    LinearProgressIndicator(
                      value:
                          mprisData.value!.position / mprisData.value!.duration,
                      borderRadius: BorderRadius.circular(999),
                      minHeight: 2,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
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

class PlayerControls extends ConsumerWidget {
  const PlayerControls({
    required this.isHovered,
    required this.mprisData,
    super.key,
  });

  final ValueNotifier<bool> isHovered;
  final AsyncValue<MprisData> mprisData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panelHeight =
        ref.watch(layerShellLogicProvider).value!.panelHeight.toDouble();

    return AnimatedCrossFade(
      crossFadeState: isHovered.value
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 500),
      sizeCurve: Curves.easeOutExpo,
      alignment: Alignment.centerLeft,
      firstChild: Row(
        children: [
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.backward,
              size: panelHeight / 4,
            ),
            onPressed: mprisData.value!.canPrevious
                ? () async {
                    await playerPrevious();
                  }
                : null,
          ),
          IconButton(
            icon: FaIcon(mprisData.value!.isPlaying
                ? FontAwesomeIcons.pause
                : FontAwesomeIcons.play,),
            onPressed: () async {
              await playerTogglePause();
            },
          ),
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.forward,
              size: panelHeight / 4,
            ),
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

class NoPlayer extends ConsumerWidget {
  const NoPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      height: ref.watch(layerShellLogicProvider).value?.panelHeight.toDouble(),
      padding: const EdgeInsets.all(8),
      child: Icon(
        Icons.music_off_outlined,
        color: Theme.of(context).colorScheme.onTertiaryContainer,
      ),
    );
  }
}
