import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/carbon.dart';
import 'package:kitshell/data/repository/appmenu/app_list_repo.dart';
import 'package:kitshell/etc/component/custom_inkwell.dart';
import 'package:kitshell/etc/component/text_icon.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/etc/utitity/gap.dart';
import 'package:kitshell/etc/utitity/image_provider.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_components/mpris/mpris_bloc.dart';
import 'package:kitshell/screen/panel/components/mpris.dart';
import 'package:kitshell/screen/popup/components/appmenu.dart';
import 'package:kitshell/src/rust/api/mpris/mpris.dart';
import 'package:kitshell/src/rust/third_party/mpris.dart';

class MprisPopup extends StatelessWidget {
  const MprisPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 380,
      child: BlocBuilder<MprisBloc, MprisState>(
        bloc: get<MprisBloc>(),
        builder: (context, state) {
          switch (state) {
            case MprisStateInitial():
            case MprisStateNotPlaying():
              return Center(child: Text(t.mpris.noPlaying));
            case MprisStatePlaying():
              return ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(8),
                child: const MprisPopupContainer(),
              );
          }
        },
      ),
    );
  }
}

class MprisPopupContent extends StatelessWidget {
  const MprisPopupContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.passthrough,
      children: [
        AlbumArtBg(),
        Padding(
          padding: EdgeInsets.all(16),
          child: MprisInformation(),
        ),
      ],
    );
  }
}

class MprisInformation extends StatelessWidget {
  const MprisInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlayerIcon(),
        InformationTitle(),
        InformationProgressAndControl(),
      ],
    );
  }
}

class InformationTitle extends StatelessWidget {
  const InformationTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MprisBloc, MprisState>(
      bloc: get<MprisBloc>(),
      builder: (context, state) {
        if (state is! MprisStatePlaying) return const SizedBox.shrink();
        final metadata = state.trackProgress.metadata;
        final playerInfo = state.trackProgress.player;
        final playbackStatus = state.trackProgress.playbackStatus;

        return Row(
          children: [
            // Track title, artist, and album
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (metadata.title?.isNotEmpty ?? false)
                    Text(
                      metadata.title ?? t.mpris.unknown.title,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (metadata.artists?.isNotEmpty ?? false)
                    Text(
                      metadata.artists?.join(', ') ?? t.mpris.unknown.artist,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (metadata.album?.isNotEmpty ?? false)
                    Text(
                      metadata.album ?? t.mpris.unknown.album,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            // Play pause button
            Gaps.sm.gap,
            if (playerInfo.canPause || playerInfo.canPlay)
              CustomInkwell(
                decoration: BoxDecoration(
                  color: context.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                onTap: () {
                  get<MprisBloc>().add(
                    const MprisEventDispatch(
                      PlayerOperations.togglePlayPause(),
                    ),
                  );
                },
                child: Iconify(
                  playbackStatus == PlaybackStatus.paused
                      ? Carbon.play
                      : Carbon.pause,
                  color: context.colorScheme.onPrimary,
                ),
              ),
          ],
        );
      },
    );
  }
}

class InformationProgressAndControl extends StatelessWidget {
  const InformationProgressAndControl({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MprisBloc, MprisState>(
      bloc: get<MprisBloc>(),
      builder: (context, state) {
        if (state is! MprisStatePlaying) return const SizedBox.shrink();

        return Row(
          children: [
            Expanded(
              child: TrackSeekbar(
                progress: state.trackProgress.progressNormalized,
                length: state.trackProgress.metadata.trackLength,
                progressDuration: state.trackProgress.progressDuration,
              ),
            ),
          ],
        );
      },
    );
  }
}

class TrackSeekbar extends HookWidget {
  const TrackSeekbar({
    required this.progress,
    this.progressDuration,
    this.length,
    super.key,
  });
  final double? progress;
  final Duration? progressDuration;
  final Duration? length;

  @override
  Widget build(BuildContext context) {
    // Use these variable to update slider whether we grab on
    // the handle for seeking, or let it play as usual.
    final interactiveValue = useState<double>(0);
    final currentlySeeking = useState(false);
    final progressEffective = useMemoized<double?>(() {
      if (currentlySeeking.value) {
        return interactiveValue.value;
      } else {
        return progress;
      }
    }, [progress, interactiveValue.value]);

    final startedSeekAt = useState<Duration>(Duration.zero);

    return SliderTheme(
      data:
          SliderTheme.of(
            context,
          ).copyWith(
            trackHeight: 8,
            thumbSize: WidgetStateProperty.resolveWith<Size?>((state) {
              if (state.contains(WidgetState.pressed) ||
                  state.contains(WidgetState.hovered)) {
                return const Size(2, 20);
              } else {
                return const Size(4, 20);
              }
            }),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Slider(
            value: progressEffective?.clamp(0, 1) ?? 1,
            onChanged: (val) {
              interactiveValue.value = val;
            },
            onChangeStart: (val) {
              currentlySeeking.value = true;
              startedSeekAt.value = progressDuration ?? Duration.zero;

              get<MprisBloc>().add(
                const MprisEventDispatch(
                  PlayerOperations.pause(),
                ),
              );
            },
            onChangeEnd: (val) {
              final finalSeekAtUs =
                  (length?.inMicroseconds ?? 1) * interactiveValue.value;
              final seekDelta =
                  finalSeekAtUs - startedSeekAt.value.inMicroseconds;

              get<MprisBloc>().add(
                MprisEventDispatch(
                  PlayerOperations.seek(offsetUs: seekDelta.toInt()),
                ),
              );

              currentlySeeking.value = false;
              get<MprisBloc>().add(
                const MprisEventDispatch(
                  PlayerOperations.play(),
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (progressDuration != null)
                Text(
                  progressDuration!.toHoursMinutesSeconds(),
                  style: context.textTheme.labelSmall,
                ),
              if (length != null)
                Text(
                  length!.toHoursMinutesSeconds(),
                  style: context.textTheme.labelSmall,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class PlayerIcon extends HookWidget {
  const PlayerIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final appName = useState<String?>(null);
    final iconPath = useState<String?>(null);

    return BlocListener<MprisBloc, MprisState>(
      bloc: get<MprisBloc>(),
      listener: (context, state) {
        if (state is! MprisStatePlaying) return;

        // Get app info
        final desktopEntry = state.trackProgress.player.desktopEntry;
        if (desktopEntry == null) return;
        final appInfo = get<AppListRepo>().getAppInfoFromDesktopEntry(
          desktopEntry,
        );

        appName.value = appInfo?.entry.name;
        iconPath.value = appInfo?.metadata.iconPath;
      },
      child: TextIcon(
        icon: iconPath.value != null
            ? ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(8),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    context.colorScheme.onPrimaryContainer,
                    BlendMode.color,
                  ),
                  child: AppIconBuilder(
                    icon: iconPath.value,
                    iconSize: 20,
                  ),
                ),
              )
            : const SizedBox.shrink(),
        text: Text(
          appName.value ?? '',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}

class AlbumArtBg extends StatelessWidget {
  const AlbumArtBg({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MprisBloc, MprisState>(
      bloc: get<MprisBloc>(),
      builder: (context, state) {
        if (state is! MprisStatePlaying) return const SizedBox.shrink();

        return Stack(
          fit: StackFit.expand,
          children: [
            AlbumArtBuilder(
              uri: state.trackProgress.metadata.artUrl,
            ),
            ColoredBox(
              color: context.colorScheme.scrim.withValues(
                alpha: 0.75,
              ),
            ),
          ],
        );
      },
    );
  }
}

class MprisPopupContainer extends HookWidget {
  const MprisPopupContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeAlbumArt = useState<ThemeData?>(null);

    return BlocConsumer<MprisBloc, MprisState>(
      bloc: get<MprisBloc>(),
      listenWhen: (prev, current) {
        if (prev is! MprisStatePlaying ||
            current is! MprisStatePlaying ||
            themeAlbumArt.value == null) {
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
      builder: (context, state) {
        if (state is! MprisStatePlaying) return const SizedBox.shrink();

        return Theme(
          data: themeAlbumArt.value ?? Theme.of(context),
          child: const MprisPopupContent(),
        );
      },
    );
  }
}
