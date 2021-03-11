import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class _StyleHelper {
  final TextStyle? normalStyle;
  final TextStyle? highlightedStyle;
  var isHighlighted = false;

  TextStyle? get style =>
      (isHighlighted ? highlightedStyle : normalStyle) ?? normalStyle;

  _StyleHelper({this.normalStyle, this.highlightedStyle});
}

class HighlightedTextSpan extends TextSpan {
  final _StyleHelper _styleHelper;

  HighlightedTextSpan({
    String? text,
    List<InlineSpan>? children,
    TextStyle? style,
    GestureRecognizer? recognizer,
    String? semanticsLabel,
    TextStyle? highlightedStyle,
  })  : _styleHelper = _StyleHelper(
          normalStyle: style,
          highlightedStyle: highlightedStyle,
        ),
        super(
          text: text,
          children: children,
          style: style,
          recognizer: recognizer,
          semanticsLabel: semanticsLabel,
        );

  @override
  TextStyle? get style => _styleHelper.style;

  bool get isHighlighted => _styleHelper.isHighlighted;
  set isHighlighted(bool value) => _styleHelper.isHighlighted = value;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (super != other) return false;
    final HighlightedTextSpan typedOther = other;
    return typedOther.isHighlighted == isHighlighted;
  }

  @override
  int get hashCode => hashValues(isHighlighted, super.hashCode);

  static bool clearHighlight(TextSpan span) {
    var result = false;
    if (span is HighlightedTextSpan) {
      result = span.isHighlighted || result;
      span.isHighlighted = false;
    }
    result =
        span.children?.where((c) => clearHighlight(c as TextSpan))?.isNotEmpty == true ||
            result;
    return result;
  }

  @override
  InlineSpan? getSpanForPositionVisitor(
    TextPosition position,
    Accumulator offset,
  ) {
    if (text == null) return null;

    final targetOffset = position.offset;
    final startOffset = offset.value;
    final endOffset = offset.value + text!.length - 1;
    if (startOffset <= targetOffset && targetOffset <= endOffset) {
      return this;
    }
    offset.increment(text!.length);
    return null;
  }
}
