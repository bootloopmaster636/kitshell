import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kitshell/etc/utitity/logger.dart';

/// Slider height
const double largeSliderHeight = 56;

/// How many scroll steps for the slider from min to max
const double scrollStep = 40;

/// Material 3 styled slider with XL size, usually seen on volume panel
/// of AOSP Android 15
class LargeSlider extends LeafRenderObjectWidget {
  const LargeSlider({
    required this.insetIcon,
    required this.label,
    required this.onChanged,
    required this.value,
    this.minValue = 0,
    this.maxValue = 1,
    this.textStyle,
    super.key,
  });

  final IconData insetIcon;
  final String label;
  final double value;
  final double? minValue;
  final double? maxValue;
  final void Function(double) onChanged;
  final TextStyle? textStyle;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    var effectiveTextStyle = textStyle;
    if (textStyle == null || textStyle!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(textStyle);
    }

    return LargeSliderRenderObject(
      insetIcon: insetIcon,
      label: label,
      value: value,
      minValue: minValue ?? 0,
      maxValue: maxValue ?? 1,
      onChanged: onChanged,
      textStyle: effectiveTextStyle,
      colorScheme: Theme.of(context).colorScheme,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    LargeSliderRenderObject renderObject,
  ) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    var effectiveTextStyle = textStyle;
    if (textStyle == null || textStyle!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(textStyle);
    }

    renderObject
      ..insetIcon = insetIcon
      ..label = label
      ..value = value
      ..minValue = minValue ?? 0
      ..maxValue = maxValue ?? 1
      ..onChanged = onChanged
      ..textStyle = effectiveTextStyle
      ..colorScheme = Theme.of(context).colorScheme;
  }
}

class LargeSliderRenderObject extends RenderBox {
  LargeSliderRenderObject({
    // Content
    required IconData insetIcon,
    required String label,
    required double value,
    required void Function(double) onChanged,

    // Layout
    required double minValue,
    required double maxValue,

    // Styling
    required ColorScheme colorScheme,
    TextStyle? textStyle,
  }) {
    // Initialize properties
    _insetIcon = insetIcon;
    _label = label;
    _value = value;
    _minValue = minValue;
    _maxValue = maxValue;
    _onChanged = onChanged;
    _textStyle = textStyle;
    _colorScheme = colorScheme;

    // Initialize gesture
    _calculateValueFromDrag();
  }

  // Contents
  late IconData _insetIcon;
  late String _label;
  late double _value;
  late double _minValue;
  late double _maxValue;
  late void Function(double) _onChanged;

  // Styling
  late TextStyle? _textStyle;
  late ColorScheme _colorScheme;

  // Painting
  late TextPainter _labelPainter;
  late TextPainter _valuePainter;
  late TextPainter _iconPainter;
  late TextSpan _labelTextSpan;
  late TextSpan _valueTextSpan;
  late TextSpan _iconTextSpan;

  // Layout
  late double _activeTrackWidth;
  late bool _doesLabelFitInsideSlider;

  // Interaction recognition
  final _tapGestureDetector = TapGestureRecognizer();
  final _dragGestureDetector = HorizontalDragGestureRecognizer();
  void _calculateValueFromDrag() {
    void onInteractionEvent(double dx) {
      final percent =
          ((dx - largeSliderHeight / 2) / (size.width - largeSliderHeight))
              .clamp(0, 1);
      final range = _maxValue - _minValue;
      final newValue = _minValue + (percent * range);
      if (newValue != _value) {
        _onChanged(newValue);
        markNeedsPaint();
      }
    }

    _dragGestureDetector.onUpdate = (DragUpdateDetails details) =>
        onInteractionEvent(details.localPosition.dx);

    _tapGestureDetector.onTapUp = (TapUpDetails details) =>
        onInteractionEvent(details.localPosition.dx);
  }

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    switch (event) {
      case PointerDownEvent():
        // When pointer is down, we want to start tracking the gesture
        _tapGestureDetector.addPointer(event);
        _dragGestureDetector.addPointer(event);
      case PointerMoveEvent():
      case PointerUpEvent():
        _tapGestureDetector.handleEvent(event);
        _dragGestureDetector.handleEvent(event);
      case PointerScrollEvent():
        if (event.scrollDelta.dy != 0) {
          final range = _maxValue - _minValue;
          final plusMinus = event.scrollDelta.dy >= 0 ? 1 : -1;
          final newValue = (_value + (plusMinus * range / scrollStep)).clamp(
            _minValue,
            _maxValue,
          );
          if (newValue != _value) {
            _onChanged(newValue);
            markNeedsPaint();
          }
        }
      default:
        // Ignore other pointer events
        break;
    }
  }

  // Getter & Setters
  IconData get insetIcon => _insetIcon;
  set insetIcon(IconData value) {
    if (_insetIcon != value) {
      _insetIcon = value;
      markNeedsPaint();
    }
  }

  String get label => _label;
  set label(String value) {
    if (_label != value) {
      _label = value;
      markNeedsPaint();
    }
  }

  double get value => _value;
  set value(double value) {
    if (_value != value) {
      _value = value;
      markNeedsPaint();
    }
  }

  double get minValue => _minValue;
  set minValue(double value) {
    if (_minValue != value) {
      _minValue = value;
      markNeedsPaint();
    }
  }

  double get maxValue => _maxValue;
  set maxValue(double value) {
    if (_maxValue != value) {
      _maxValue = value;
      markNeedsPaint();
    }
  }

  void Function(double) get onChanged => _onChanged;
  set onChanged(void Function(double) value) {
    if (_onChanged != value) {
      _onChanged = value;
      markNeedsPaint();
    }
  }

  TextStyle? get textStyle => _textStyle;
  set textStyle(TextStyle? value) {
    if (_textStyle != value) {
      _textStyle = value;
      markNeedsPaint();
    }
  }

  ColorScheme get colorScheme => _colorScheme;
  set colorScheme(ColorScheme value) {
    if (_colorScheme != value) {
      _colorScheme = value;
      markNeedsPaint();
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return 200;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return largeSliderHeight;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return 400;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return largeSliderHeight;
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    if (baseline == TextBaseline.alphabetic) {
      return largeSliderHeight / 2;
    }
    return null;
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  void detach() {
    _dragGestureDetector.dispose();
    _tapGestureDetector.dispose();
    super.detach();
  }

  @override
  void performLayout() {
    _iconTextSpan = TextSpan(
      text: String.fromCharCode(_insetIcon.codePoint),
      style: _textStyle?.copyWith(
        fontFamily: _insetIcon.fontFamily,
        fontSize: 20,
        color: _colorScheme.onPrimary,
      ),
    );
    _iconPainter = TextPainter(
      text: _iconTextSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    _iconPainter.layout();

    _labelTextSpan = TextSpan(
      text: _label,
      style: _textStyle,
    );
    _labelPainter = TextPainter(
      text: _labelTextSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );
    _labelPainter.layout();

    _valueTextSpan = TextSpan(
      text: _value.toStringAsFixed(2),
      style: _textStyle,
    );
    _valuePainter = TextPainter(
      text: _valueTextSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );
    _valuePainter.layout();

    size = constraints.constrain(Size(constraints.maxWidth, largeSliderHeight));
  }

  void _updatePositioning() {
    // Calculate the width of the active track based on the value
    assert(_minValue < _maxValue, 'minValue must be less than maxValue');
    assert(
      _value >= _minValue && _value <= _maxValue,
      'value must be between minValue and maxValue',
    );

    // _activeTrackWidth =
    //     (size.width * ((_value - _minValue) / (_maxValue - _minValue))).clamp(
    //       _minValue + largeSliderHeight,
    //       _maxValue - largeSliderHeight,
    //     );
    final multiplier = (_value - _minValue) / (_maxValue - _minValue);
    _activeTrackWidth =
        largeSliderHeight + ((size.width - largeSliderHeight) * multiplier);

    // Calculate the width of the label text
    final textWidth = _labelPainter.size.width;

    // Check if the label fits inside the slider (largeSliderHeight here
    // is also the icon size)
    _doesLabelFitInsideSlider =
        _activeTrackWidth >= textWidth + largeSliderHeight;

    // Change label color depending on where the label's position on
    // slider active track.
    //
    // Use onPrimary if inside, use onPrimaryContainer if outside.
    _labelPainter.text = TextSpan(
      text: _label,
      style: _textStyle?.copyWith(
        color: _doesLabelFitInsideSlider
            ? _colorScheme.onPrimary
            : _colorScheme.onSecondaryContainer,
      ),
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _updatePositioning();

    // Draw the background track
    context.canvas
      ..drawRRect(
        RRect.fromLTRBR(
          offset.dx,
          offset.dy,
          offset.dx + size.width,
          offset.dy + size.height,
          const Radius.circular(16),
        ),
        Paint()
          ..style = PaintingStyle.fill
          ..color = _colorScheme.secondaryContainer,
      )
      ..drawCircle(
        Offset(
          offset.dx + size.width - 8,
          offset.dy + size.height / 2,
        ),
        2,
        Paint()
          ..style = PaintingStyle.fill
          ..color = _colorScheme.secondary,
      );

    // Draw the active track
    context.canvas
      ..drawRRect(
        RRect.fromLTRBR(
          offset.dx,
          offset.dy,
          offset.dx + _activeTrackWidth,
          offset.dy + size.height,
          const Radius.circular(16),
        ),
        Paint()
          ..style = PaintingStyle.fill
          ..color = _colorScheme.primary,
      )
      ..drawCircle(
        Offset(
          offset.dx + _activeTrackWidth - largeSliderHeight / 2,
          offset.dy + size.height / 2,
        ),
        2,
        Paint()
          ..style = PaintingStyle.fill
          ..color = _colorScheme.onPrimary.withValues(
            alpha: _doesLabelFitInsideSlider
                ? 1
                : _activeTrackWidth - largeSliderHeight,
          ),
      );

    // Draw the inset icon
    _iconPainter.paint(
      context.canvas,
      Offset(
        offset.dx + (largeSliderHeight - _iconPainter.size.width) / 2,
        offset.dy + (size.height - _iconPainter.size.height) / 2,
      ),
    );

    // Draw the label
    if (_doesLabelFitInsideSlider) {
      _labelPainter.paint(
        context.canvas,
        Offset(
          offset.dx + largeSliderHeight - 8,
          offset.dy + (size.height - _labelPainter.size.height) / 2,
        ),
      );
    } else {
      // If the label does not fit, draw it at the end of the active track
      _labelPainter.paint(
        context.canvas,
        Offset(
          offset.dx + _activeTrackWidth + 8,
          offset.dy + (size.height - _labelPainter.size.height) / 2,
        ),
      );
    }
  }
}
