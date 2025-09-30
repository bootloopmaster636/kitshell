import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/etc/utitity/image_provider.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_components/mpris/mpris_bloc.dart';

class MprisPopup extends StatelessWidget {
  const MprisPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 460,
      child: BlocBuilder<MprisBloc, MprisState>(
        bloc: get<MprisBloc>(),
        builder: (context, state) {
          switch (state) {
            case MprisStateInitial():
            case MprisStateNotPlaying():
              return Center(child: Text(t.mpris.noPlaying));
            case MprisStatePlaying():
              return const MprisPopupContainer();
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
    return ColoredBox(
      color: context.colorScheme.primaryContainer,
      child: const Placeholder(),
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
