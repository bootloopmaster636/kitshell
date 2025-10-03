import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/carbon.dart';
import 'package:kitshell/etc/component/custom_inkwell.dart';
import 'package:kitshell/etc/component/text_icon.dart';
import 'package:kitshell/etc/component/visualizer.dart';
import 'package:kitshell/etc/utitity/config.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/etc/utitity/gap.dart';
import 'package:kitshell/etc/utitity/image_provider.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_components/mpris/cava_bloc.dart';
import 'package:kitshell/logic/panel_components/mpris/mpris_bloc.dart';
import 'package:kitshell/logic/screen_manager/panel_enum.dart';
import 'package:kitshell/logic/screen_manager/screen_manager_bloc.dart';
import 'package:kitshell/screen/panel/panel.dart';
import 'package:kitshell/src/rust/api/mpris/mpris.dart';
import 'package:kitshell/src/rust/third_party/mpris.dart';

class MprisComponent extends HookWidget {
  const MprisComponent({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      get<MprisBloc>().add(const MprisEventStarted());
      return () {};
    }, []);
    final themeAlbumArt = useState(Theme.of(context));

    return RepaintBoundary(
      child: BlocConsumer<MprisBloc, MprisState>(
        bloc: get<MprisBloc>(),
        listenWhen: (prev, current) {
          if (prev is! MprisStatePlaying || current is! MprisStatePlaying) {
            return true;
          }

          return prev.trackProgress.metadata.artUrl !=
              current.trackProgress.metadata.artUrl;
        },
        listener: (context, state) async {
          if (state is! MprisStatePlaying) return;

          final uri = state.trackProgress.metadata.artUrl;
          if (uri == null) {
            themeAlbumArt.value = Theme.of(context);
            return;
          }

          final provider = getImageProviderFromUri(uri);
          if (provider == null) {
            themeAlbumArt.value = Theme.of(context);
            return;
          }

          final colorScheme = await ColorScheme.fromImageProvider(
            provider: provider,
            brightness: Theme.of(context).brightness,
          );

          if (!context.mounted) return;
          themeAlbumArt.value = Theme.of(
            context,
          ).copyWith(colorScheme: colorScheme);
        },
        buildWhen: (prev, current) {
          return prev.runtimeType != current.runtimeType;
        },
        builder: (context, state) {
          switch (state) {
            case MprisStateInitial():
            case MprisStateNotPlaying():
              return const NoMusicPlaying();
            case MprisStatePlaying():
              return Theme(
                data: themeAlbumArt.value,
                child: const NowPlayingContainer(),
              );
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
      onPointerEnter: (_) => isHovered.value = true,
      onPointerExit: (_) => isHovered.value = false,
      onTap: () {
        get<ScreenManagerBloc>().add(
          ScreenManagerEventOpenPopup(
            popupToShow: PopupWidget.mpris,
            position: InheritedAlignment.of(context).position,
          ),
        );
      },
      padding: EdgeInsets.zero,
      child: AnimatedContainer(
        width: isHovered.value ? 260 : 180,
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
                context.colorScheme.secondaryContainer.withValues(alpha: 0),
                context.colorScheme.secondaryContainer.withValues(alpha: 0.8),
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
                        onPressed: () {
                          get<MprisBloc>().add(
                            const MprisEventDispatch(
                              PlayerOperations.prevTrack(),
                            ),
                          );
                        },
                        icon: Iconify(
                          Carbon.chevron_left,
                          color: context.colorScheme.onSecondaryContainer,
                          size: 20,
                        ),
                      ),
                    if (playerInfo.canPause && playerInfo.canPlay)
                      IconButton(
                        onPressed: () {
                          get<MprisBloc>().add(
                            const MprisEventDispatch(
                              PlayerOperations.togglePlayPause(),
                            ),
                          );
                        },
                        icon: Iconify(
                          switch (state.trackProgress.playbackStatus) {
                            PlaybackStatus.playing => Carbon.pause,
                            PlaybackStatus.paused ||
                            PlaybackStatus.stopped => Carbon.play,
                          },
                          color: context.colorScheme.onSecondaryContainer,
                        ),
                      ),
                    if (playerInfo.canGoNext)
                      IconButton(
                        onPressed: () {
                          get<MprisBloc>().add(
                            const MprisEventDispatch(
                              PlayerOperations.nextTrack(),
                            ),
                          );
                        },
                        icon: Iconify(
                          Carbon.chevron_right,
                          color: context.colorScheme.onSecondaryContainer,
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
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: context.colorScheme.primaryContainer.withValues(alpha: 0.6),
        ),
        const SongVisualizer(),
        const Align(
          alignment: Alignment.bottomCenter,
          child: TrackProgressbar(),
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
        return prev.trackProgress.progressNormalized !=
            current.trackProgress.progressNormalized;
      },
      builder: (context, state) {
        if (state is! MprisStatePlaying) return const SizedBox.shrink();
        final progress = state.trackProgress.progressNormalized;

        if (progress != null) {
          return LinearProgressIndicator(
            value: progress,
            minHeight: 3,
            color: context.colorScheme.secondary.withValues(alpha: 0.8),
            backgroundColor: context.colorScheme.secondaryContainer.withValues(
              alpha: 0.8,
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
                    color: context.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  metadata.artists?.join(', ') ?? '',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
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
              duration: Durations.medium3,
            );
      },
    );
  }
}

class AlbumArt extends StatelessWidget {
  const AlbumArt({this.dimension = 32, super.key});
  final double dimension;

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
          dimension: dimension,
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.shadow.withValues(alpha: 0.4),
                  blurRadius: 4,
                ),
              ],
            ),
            child: AlbumArtBuilder(uri: uri),
          ),
        );
      },
    );
  }
}

class SongVisualizer extends HookWidget {
  const SongVisualizer({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      get<CavaBloc>().add(const CavaEventStarted());
      return () {};
    }, []);

    return BlocBuilder<CavaBloc, CavaState>(
      bloc: get<CavaBloc>(),
      builder: (context, state) {
        if (state is! CavaStateLoaded) return const SizedBox.shrink();

        return Visualizer(
          data: state.data,
          color: context.colorScheme.secondary.withValues(alpha: 0.3),
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

class AlbumArtBuilder extends StatelessWidget {
  const AlbumArtBuilder({
    this.uri,
    this.cacheDimension,
    this.blurPx,
    super.key,
  });
  final String? uri;
  final int? cacheDimension;
  final double? blurPx;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Durations.medium1,
      layoutBuilder: (currentChild, previousChildren) => Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.center,
        children: [...previousChildren, ?currentChild],
      ),
      child: Builder(
        key: ValueKey(uri),
        builder: (context) {
          if (uri == null) {
            return ColoredBox(
              color: context.colorScheme.secondary,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Iconify(
                  Carbon.music,
                  color: context.colorScheme.onSecondary,
                ),
              ),
            );
          } else if (uri!.startsWith('http')) {
            return Image.network(
              uri!,
              fit: BoxFit.cover,
              cacheHeight: cacheDimension,
              cacheWidth: cacheDimension,
            );
          } else if (uri!.startsWith('file') || uri!.startsWith('/')) {
            return Image.file(
              File(Uri.decodeFull(uri!).replaceFirst('file://', '')),
              fit: BoxFit.cover,
              cacheHeight: cacheDimension,
              cacheWidth: cacheDimension,
            );
          } else {
            return ColoredBox(
              color: context.colorScheme.secondary,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Iconify(
                  Carbon.music,
                  color: context.colorScheme.onSecondary,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
