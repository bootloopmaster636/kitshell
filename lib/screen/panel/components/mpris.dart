import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/carbon.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:kitshell/etc/component/custom_inkwell.dart';
import 'package:kitshell/etc/component/text_icon.dart';
import 'package:kitshell/etc/utitity/config.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/etc/utitity/gap.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_components/mpris/bloc/mpris_bloc.dart';
import 'package:kitshell/src/rust/third_party/mpris.dart';

class MprisComponent extends HookWidget {
  const MprisComponent({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      get<MprisBloc>().add(const MprisEventStarted());
      return () {};
    }, []);

    return RepaintBoundary(
      child: BlocBuilder<MprisBloc, MprisState>(
        bloc: get<MprisBloc>(),
        buildWhen: (prev, current) {
          return prev.runtimeType != current.runtimeType;
        },
        builder: (context, state) {
          switch (state) {
            case MprisStateInitial():
            case MprisStateNotPlaying():
              return const NoMusicPlaying();
            case MprisStatePlaying():
              return const NowPlayingContainer();
          }
        },
      ),
    );
  }
}

class NowPlayingContainer extends HookWidget {
  const NowPlayingContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);

    return CustomInkwell(
      onHover: (_) => isHovered.value = !isHovered.value,
      onPointerEnter: (_) => isHovered.value = true,
      onPointerExit: (_) => isHovered.value = false,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: AnimatedContainer(
        width: isHovered.value ? 240 : 180,
        duration: Durations.medium2,
        curve: Easing.standard,
        alignment: Alignment.centerLeft,
        child: Stack(
          children: [
            const NowPlaying(),
            Align(
              alignment: Alignment.centerRight,
              child: AnimatedCrossFade(
                duration: Durations.medium2,
                sizeCurve: Easing.standard,
                alignment: Alignment.centerRight,
                crossFadeState: isHovered.value
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: const NowPlayingControls(),
                secondChild: const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NowPlayingControls extends StatelessWidget {
  const NowPlayingControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MprisBloc, MprisState>(
      bloc: get<MprisBloc>(),
      buildWhen: (prev, current) {
        if (prev is! MprisStatePlaying || current is! MprisStatePlaying) {
          return true;
        }
        final prevProgress = prev.trackProgress;
        final currentProgress = current.trackProgress;

        if (prevProgress.playbackStatus != currentProgress.playbackStatus) {
          return true;
        }
        if (prevProgress.player.canGoNext != currentProgress.player.canGoNext) {
          return true;
        }
        if (prevProgress.player.canGoPrev != currentProgress.player.canGoPrev) {
          return true;
        }

        return false;
      },
      builder: (context, state) {
        if (state is! MprisStatePlaying) return const SizedBox.shrink();
        final playerInfo = state.trackProgress.player;

        return Container(
          height: panelDefaultHeightPx.toDouble(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.colorScheme.surfaceBright.withValues(alpha: 0),
                context.colorScheme.surfaceBright.withValues(alpha: 0.8),
              ],
              stops: const [0, 0.6],
            ),
          ),
          child: playerInfo.canBeControlled
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Gaps.lg.gap,
                    if (playerInfo.canGoPrev)
                      IconButton(
                        onPressed: () {},
                        icon: Iconify(
                          Carbon.chevron_left,
                          color: context.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    if (playerInfo.canPause && playerInfo.canPlay)
                      IconButton(
                        onPressed: () {},
                        icon: Iconify(
                          switch (state.trackProgress.playbackStatus) {
                            PlaybackStatus.playing => Carbon.pause,
                            PlaybackStatus.paused ||
                            PlaybackStatus.stopped => Carbon.play,
                          },
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    if (playerInfo.canGoNext)
                      IconButton(
                        onPressed: () {},
                        icon: Iconify(
                          Carbon.chevron_right,
                          color: context.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    Gaps.sm.gap,
                  ],
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}

class NowPlaying extends StatelessWidget {
  const NowPlaying({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      fit: StackFit.expand,
      children: [
        const BlurredBackground(),
        const TrackProgressbar(),
        ColoredBox(
          color: context.colorScheme.surface.withValues(alpha: 0.5),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            spacing: Gaps.sm.value,
            children: const [
              AlbumArt(),
              Expanded(
                child: TrackInfo(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TrackProgressbar extends StatelessWidget {
  const TrackProgressbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MprisBloc, MprisState>(
      bloc: get<MprisBloc>(),
      buildWhen: (prev, current) {
        if (prev is! MprisStatePlaying || current is! MprisStatePlaying) {
          return true;
        }
        return prev.trackProgress.progress != current.trackProgress.progress;
      },
      builder: (context, state) {
        if (state is! MprisStatePlaying) return const SizedBox.shrink();
        final progress = state.trackProgress.progress;

        if (progress != null) {
          return FractionallySizedBox(
            widthFactor: progress.clamp(0, 1),
            alignment: Alignment.centerLeft,
            child: ColoredBox(
              color: context.colorScheme.onSurfaceVariant.withValues(
                alpha: 0.3,
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class TrackInfo extends StatelessWidget {
  const TrackInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MprisBloc, MprisState>(
      bloc: get<MprisBloc>(),
      buildWhen: (prev, current) {
        if (prev is! MprisStatePlaying || current is! MprisStatePlaying) {
          return true;
        }
        final prevMetadata = prev.trackProgress.metadata;
        final currentMetadata = current.trackProgress.metadata;

        return prevMetadata.title.hashCode != currentMetadata.title.hashCode ||
            prevMetadata.artists.toString() !=
                currentMetadata.artists.toString();
      },
      builder: (context, state) {
        if (state is! MprisStatePlaying) return const SizedBox.shrink();
        final metadata = state.trackProgress.metadata;

        return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  metadata.title ?? '',
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  metadata.artists?.join(', ') ?? '',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
            .animate(key: ValueKey(metadata.title))
            .scaleXY(
              begin: 0.8,
              end: 1,
              alignment: Alignment.centerLeft,
              duration: Durations.medium3,
              curve: Easing.emphasizedDecelerate,
            )
            .fadeIn(
              duration: Durations.medium2,
            );
      },
    );
  }
}

class AlbumArt extends StatelessWidget {
  const AlbumArt({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MprisBloc, MprisState>(
      bloc: get<MprisBloc>(),
      buildWhen: (prev, current) {
        if (prev is! MprisStatePlaying || current is! MprisStatePlaying) {
          return true;
        }
        return prev.trackProgress.metadata.artUrl !=
            current.trackProgress.metadata.artUrl;
      },
      builder: (context, state) {
        if (state is! MprisStatePlaying) return const SizedBox.shrink();
        final uri = state.trackProgress.metadata.artUrl;

        return SizedBox.square(
          dimension: 32,
          child: AnimatedSwitcher(
            duration: Durations.medium1,
            child: Builder(
              key: ValueKey(uri),
              builder: (context) {
                if (uri == null) {
                  return ColoredBox(
                    color: context.colorScheme.secondary,
                    child: Iconify(
                      Carbon.music,
                      color: context.colorScheme.onSecondary,
                    ),
                  );
                } else if (uri!.startsWith('http')) {
                  return Image.network(
                    uri!,
                    fit: BoxFit.cover,
                  );
                } else if (uri!.startsWith('file')) {
                  return Image.file(
                    File(uri!.replaceFirst('file://', '')),
                    fit: BoxFit.cover,
                  );
                } else {
                  return ColoredBox(
                    color: context.colorScheme.secondary,
                    child: Iconify(
                      Ic.question_answer,
                      color: context.colorScheme.onSecondary,
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class BlurredBackground extends StatelessWidget {
  const BlurredBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MprisBloc, MprisState>(
      bloc: get<MprisBloc>(),
      buildWhen: (prev, current) {
        if (prev is! MprisStatePlaying || current is! MprisStatePlaying) {
          return true;
        }
        return prev.trackProgress.metadata.artUrl !=
            current.trackProgress.metadata.artUrl;
      },
      builder: (context, state) {
        if (state is! MprisStatePlaying) return const SizedBox.shrink();
        final uri = state.trackProgress.metadata.artUrl;

        return ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: 4,
            sigmaY: 4,
          ),
          child: AnimatedSwitcher(
            duration: Durations.medium1,
            child: Builder(
              key: ValueKey(uri),
              builder: (context) {
                if (uri == null) {
                  return ColoredBox(
                    color: context.colorScheme.secondary,
                  );
                } else if (uri!.startsWith('http')) {
                  return Image.network(
                    uri!,
                    fit: BoxFit.cover,
                  );
                } else if (uri!.startsWith('file')) {
                  return Image.file(
                    File(uri!.replaceFirst('file://', '')),
                    fit: BoxFit.cover,
                  );
                } else {
                  return ColoredBox(
                    color: context.colorScheme.secondary,
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class NoMusicPlaying extends HookWidget {
  const NoMusicPlaying({super.key});

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);

    return AnimatedSize(
      duration: Durations.medium1,
      curve: Easing.standard,
      child: CustomInkwell(
        onPointerEnter: (_) => isHovered.value = true,
        onPointerExit: (_) => isHovered.value = false,
        child: TextIcon(
          icon: Iconify(
            Carbon.music_remove,
            color: context.colorScheme.onSurface,
            size: 16,
          ),
          spacing: 0,
          text: isHovered.value
              ? Padding(
                  padding: EdgeInsets.only(left: Gaps.sm.value),
                  child: Text(t.mpris.noPlaying),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
