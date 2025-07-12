import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Gap widget preset
enum Gaps {
  /// 2 pixels gap size
  xxs(
    Gap(2),
    SliverGap(2),
    SizedBox(height: 2),
    SizedBox(width: 2),
    2,
  ),

  /// 4 pixels gap size
  xs(
    Gap(4),
    SliverGap(4),
    SizedBox(height: 4),
    SizedBox(width: 4),
    4,
  ),

  /// 8 pixels gap size
  sm(
    Gap(8),
    SliverGap(8),
    SizedBox(height: 8),
    SizedBox(width: 8),
    8,
  ),

  /// 16 pixels gap size
  md(
    Gap(16),
    SliverGap(16),
    SizedBox(height: 16),
    SizedBox(width: 16),
    16,
  ),

  /// 32 pixels gap size
  lg(
    Gap(32),
    SliverGap(32),
    SizedBox(height: 32),
    SizedBox(width: 32),
    32,
  ),

  /// 48 pixels gap size
  xl(
    Gap(48),
    SliverGap(48),
    SizedBox(height: 48),
    SizedBox(width: 48),
    48,
  ),

  /// 64 pixels gap size
  xl2(
    Gap(64),
    SliverGap(64),
    SizedBox(height: 64),
    SizedBox(width: 64),
    64,
  ),

  /// 96 pixels gap size
  xl3(
    Gap(96),
    SliverGap(96),
    SizedBox(height: 96),
    SizedBox(width: 96),
    96,
  ),

  /// 128 pixels gap size
  xl4(
    Gap(128),
    SliverGap(128),
    SizedBox(height: 128),
    SizedBox(width: 128),
    128,
  );

  /// Gap widget preset enum
  const Gaps(this.gap, this.sliverGap, this.boxV, this.boxH, this.value);

  /// Gap widget used in render box type list
  final Gap gap;

  /// Gap widget used in render sliver type list
  final SliverGap sliverGap;

  /// Sized box widget with width parameter set to gap value
  final SizedBox boxH;

  /// Sized box widget with height parameter set to gap value
  final SizedBox boxV;

  /// Pixel value
  final double value;
}
