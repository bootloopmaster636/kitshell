import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/carbon.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:kitshell/etc/component/custom_inkwell.dart';
import 'package:kitshell/etc/component/text_icon.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/etc/utitity/gap.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_components/mpris/bloc/mpris_bloc.dart';
import 'package:kitshell/src/rust/api/mpris.dart';

class MprisComponent extends HookWidget {
  const MprisComponent({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      get<MprisBloc>().add(const MprisEventStarted());
      return () {};
    }, []);

    return BlocBuilder<MprisBloc, MprisState>(
      bloc: get<MprisBloc>(),
      builder: (context, state) {
        switch (state) {
          case MprisStateInitial():
          case MprisStateNotPlaying():
            return const NoMusicPlaying();
          case MprisStatePlaying():
            return SizedBox(
              width: 180,
              child: NowPlaying(data: state.trackProgress),
            );
        }
      },
    );
  }
}

class NowPlaying extends StatelessWidget {
  const NowPlaying({required this.data, super.key});
  final TrackProgress data;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(8),
      child: Stack(
        alignment: Alignment.centerLeft,
        fit: StackFit.expand,
        children: [
          BlurredBackground(uri: data.metadata.artUrl),
          TrackProgressbar(
            position: data.position,
            length: data.length,
          ),
          ColoredBox(color: context.colorScheme.scrim.withValues(alpha: 0.6)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              spacing: Gaps.sm.value,
              children: [
                AlbumArt(uri: data.metadata.artUrl),
                Expanded(child: TrackInfo(data: data)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TrackProgressbar extends StatelessWidget {
  const TrackProgressbar({
    required this.position,
    required this.length,
    super.key,
  });
  final Duration position;
  final Duration? length;

  @override
  Widget build(BuildContext context) {
    if (length != null) {
      final percent = position.inMilliseconds / length!.inMilliseconds;
      return FractionallySizedBox(
        widthFactor: percent,
        alignment: Alignment.centerLeft,
        child: ColoredBox(
          color: context.colorScheme.secondary.withValues(alpha: 0.5),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class TrackInfo extends StatelessWidget {
  const TrackInfo({required this.data, super.key});
  final TrackProgress data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          data.metadata.title ?? '',
          style: context.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          data.metadata.artists?.join(', ') ?? '',
          style: context.textTheme.labelSmall,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class AlbumArt extends StatelessWidget {
  const AlbumArt({required this.uri, this.dimension = 32, super.key});
  final String? uri;
  final double dimension;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: SizedBox.square(
        dimension: dimension,
        child: Builder(
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
                File(uri!),
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
  }
}

class BlurredBackground extends StatelessWidget {
  const BlurredBackground({required this.uri, super.key});
  final String? uri;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 8,
        sigmaY: 8,
      ),
      child: Builder(
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
              File(uri!),
              fit: BoxFit.cover,
            );
          } else {
            return ColoredBox(
              color: context.colorScheme.secondary,
            );
          }
        },
      ),
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
