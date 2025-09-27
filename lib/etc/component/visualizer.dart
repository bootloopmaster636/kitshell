import 'package:flutter/material.dart';
import 'package:kitshell/src/rust/lib.dart';

/// Visualizer component used in MPRIS widget
class Visualizer extends LeafRenderObjectWidget {
  const Visualizer({
    required this.data,
    required this.color,
    super.key,
  });

  /// Visualizer data from CAVA
  final U8Array32 data;

  /// Visualizer color
  final Color color;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return VisualizerRenderObject(
      data: data,
      color: color,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    VisualizerRenderObject renderObject,
  ) {
    renderObject
      ..data = data
      ..color = color;
  }
}

class VisualizerRenderObject extends RenderBox {
  VisualizerRenderObject({
    required U8Array32 data,
    required Color color,
  }) {
    _data = data;
    _color = color;
  }

  late U8Array32 _data;
  late Color _color;
  late double _barSpacing;

  // Getter setter

  /// Data from CAVA
  U8Array32 get data => _data;
  set data(U8Array32 value) {
    if (_data != value) {
      _data = value;
      markNeedsPaint();
    }
  }

  /// Visualizer color
  Color get color => _color;
  set color(Color value) {
    if (_color != value) {
      _color = value;
      markNeedsPaint();
    }
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return width;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return width * 2;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return height * 2;
  }

  @override
  void performLayout() {
    size = constraints.constrain(
      Size(
        constraints.maxWidth,
        constraints.maxHeight,
      ),
    );
    _barSpacing = size.width / 32;
  }

  double _getHeightMultiplier(int data) {
    // Because flutter coordinate has 0 on top side, we want to inverse /
    // give 0 if data is 255 (max), and 1 if data is 0 (min)
    return 1 - (data / 255);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final path = Path()
      // Draw first element
      // v coordinate 0, 0
      // ---------------------------------
      // |                               |
      // | <- starts here (bottom left)  |
      // ---------------------------------
      //                                  ^ coordinate width, height
      ..moveTo(offset.dx, offset.dy + size.height)
      ..lineTo(
        offset.dx,
        offset.dy + (size.height * _getHeightMultiplier(data[0])),
      );

    // Draw data from index 1 to 30
    for (var i = 1; i <= 30; i += 2) {
      final x1 = offset.dx + _barSpacing * i;
      final y1 = offset.dy + (size.height * _getHeightMultiplier(data[i]));

      final x2 = offset.dx + _barSpacing * (i + 1);
      final y2 = offset.dy + (size.height * _getHeightMultiplier(data[i + 1]));

      path.conicTo(x1, y1, x2, y2, 0.2);
    }

    // Draw the last data
    path
      ..lineTo(
        offset.dx + size.width,
        offset.dy + (size.height * (_getHeightMultiplier(data[31]))),
      )
      // Then go to bottom right corner and finally close the path
      ..lineTo(
        offset.dx + size.width,
        offset.dy + size.height,
      )
      ..close();

    context.canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.fill
        ..color = color
        ..strokeWidth = 2,
    );
  }
}
