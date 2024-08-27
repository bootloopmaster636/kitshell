// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.2.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

Future<MprisData> getMprisData() =>
    RustLib.instance.api.crateApiMprisGetMprisData();

Future<void> playerPause() => RustLib.instance.api.crateApiMprisPlayerPause();

Future<void> playerPlay() => RustLib.instance.api.crateApiMprisPlayerPlay();

Future<void> playerNext() => RustLib.instance.api.crateApiMprisPlayerNext();

Future<void> playerPrevious() =>
    RustLib.instance.api.crateApiMprisPlayerPrevious();

class MprisData {
  final String title;
  final List<String> artist;
  final String album;
  final String imageUrl;
  final BigInt duration;
  final BigInt position;
  final bool isPlaying;
  final bool canNext;
  final bool canPrevious;

  const MprisData({
    required this.title,
    required this.artist,
    required this.album,
    required this.imageUrl,
    required this.duration,
    required this.position,
    required this.isPlaying,
    required this.canNext,
    required this.canPrevious,
  });

  @override
  int get hashCode =>
      title.hashCode ^
      artist.hashCode ^
      album.hashCode ^
      imageUrl.hashCode ^
      duration.hashCode ^
      position.hashCode ^
      isPlaying.hashCode ^
      canNext.hashCode ^
      canPrevious.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MprisData &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          artist == other.artist &&
          album == other.album &&
          imageUrl == other.imageUrl &&
          duration == other.duration &&
          position == other.position &&
          isPlaying == other.isPlaying &&
          canNext == other.canNext &&
          canPrevious == other.canPrevious;
}