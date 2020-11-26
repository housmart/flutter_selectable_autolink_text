import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'autolink_utils.dart';
import 'highlighted_text_span.dart';
import 'link_attr.dart';
import 'selectable_text_ex.dart';
import 'tap_and_long_press.dart';
import 'text_element.dart';

typedef OnOpenLinkFunction = void Function(String link);
typedef OnTransformLinkFunction = String Function(String link);
typedef OnTransformLinkAttributeFunction = LinkAttribute Function(String text);
typedef OnDebugMatchFunction = void Function(Match match);

class SelectableAutoLinkText extends StatefulWidget {
  /// Text to be auto link
  final String text;

  /// Regular expression for link
  /// If null, defaults RegExp([AutoLinkUtils._defaultLinkRegExpPattern]).
  final RegExp linkRegExp;

  /// Transform the display of Link
  /// Called when Link is displayed
  final OnTransformLinkAttributeFunction onTransformDisplayLink;

  /// Called when the user taps on link.
  final OnOpenLinkFunction onTap;

  /// Called when the user long-press on link.
  final OnOpenLinkFunction onLongPress;

  /// Called when the user taps on non-link.
  final GesturePointCallback onTapOther;

  /// Called when the user long-press on non-link.
  final GesturePointCallback onLongPressOther;

  /// Style of link text
  final TextStyle linkStyle;

  /// Style of highlighted link text
  final TextStyle highlightedLinkStyle;

  /// {@macro flutter.material.SelectableText.focusNode}
  final FocusNode focusNode;

  /// {@macro flutter.material.SelectableText.style}
  final TextStyle style;

  /// {@macro flutter.material.SelectableText.strutStyle}
  final StrutStyle strutStyle;

  /// {@macro flutter.material.SelectableText.textAlign}
  final TextAlign textAlign;

  /// {@macro flutter.material.SelectableText.textDirection}
  final TextDirection textDirection;

  /// {@macro flutter.widgets.editableText.textScaleFactor}
  final double textScaleFactor;

  /// {@macro flutter.material.SelectableText.autofocus}
  final bool autofocus;

  /// {@macro flutter.widgets.editableText.minLines}
  final int minLines;

  /// {@macro flutter.material.SelectableText.maxLines}
  final int maxLines;

  /// {@macro flutter.material.SelectableText.showCursor}
  final bool showCursor;

  /// {@macro flutter.material.SelectableText.cursorWidth}
  final double cursorWidth;

  /// {@macro flutter.widgets.editableText.cursorHeight}
  final double cursorHeight;

  /// {@macro flutter.material.SelectableText.cursorRadius}
  final Radius cursorRadius;

  /// {@macro flutter.material.SelectableText.cursorColor}
  final Color cursorColor;

  /// {@macro flutter.material.SelectableText.enableInteractiveSelection}
  final bool enableInteractiveSelection;

  /// {@macro flutter.material.SelectableText.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.material.SelectableText.toolbarOptions}
  final ToolbarOptions toolbarOptions;

  /// {@macro flutter.material.SelectableText.scrollPhysics}
  final ScrollPhysics scrollPhysics;

  /// {@macro flutter.material.SelectableText.textWidthBasis}
  final TextWidthBasis textWidthBasis;

  /// For debugging linkRegExp
  final OnDebugMatchFunction onDebugMatch;

  SelectableAutoLinkText(
    this.text, {
    Key key,
    String linkRegExpPattern,
    this.onTransformDisplayLink,
    this.onTap,
    this.onLongPress,
    this.onTapOther,
    this.onLongPressOther,
    this.linkStyle,
    this.highlightedLinkStyle,
    this.focusNode,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.textScaleFactor,
    this.autofocus = false,
    this.minLines,
    this.maxLines,
    this.showCursor = false,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.enableInteractiveSelection = true,
    this.dragStartBehavior = DragStartBehavior.start,
    this.toolbarOptions,
    this.scrollPhysics,
    this.textWidthBasis,
    this.onDebugMatch,
  })  : linkRegExp =
            RegExp(linkRegExpPattern ?? AutoLinkUtils.defaultLinkRegExpPattern),
        super(key: key);

  @override
  _SelectableAutoLinkTextState createState() => _SelectableAutoLinkTextState();
}

class _SelectableAutoLinkTextState extends State<SelectableAutoLinkText> {
  final _gestureRecognizers = <TapAndLongPressGestureRecognizer>[];

  @override
  void dispose() {
    _clearGestureRecognizers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SelectableTextEx.rich(
      TextSpan(
        children: _createTextSpans(),
      ),
      focusNode: widget.focusNode,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      textScaleFactor: widget.textScaleFactor,
      autofocus: widget.autofocus,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      showCursor: widget.showCursor,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorColor: widget.cursorColor,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      dragStartBehavior: widget.dragStartBehavior,
      toolbarOptions: widget.toolbarOptions,
      scrollPhysics: widget.scrollPhysics,
      textWidthBasis: widget.textWidthBasis,
      onTap: widget.onTapOther,
      onLongPress: widget.onLongPressOther,
    );
  }

  List<TextElement> _generateElements(String text) {
    if (text.isNotEmpty != true) return [];

    final elements = <TextElement>[];

    final matches = widget.linkRegExp.allMatches(text);

    if (matches.isEmpty) {
      elements.add(TextElement(
        type: TextElementType.text,
        text: text,
      ));
    } else {
      var index = 0;
      matches.forEach((match) {
        if (widget.onDebugMatch != null) {
          widget.onDebugMatch(match);
        }

        if (match.start != 0) {
          elements.add(TextElement(
            type: TextElementType.text,
            text: text.substring(index, match.start),
          ));
        }
        elements.add(TextElement(
          type: TextElementType.link,
          text: match.group(0),
        ));
        index = match.end;
      });

      if (index < text.length) {
        elements.add(TextElement(
          type: TextElementType.text,
          text: text.substring(index),
        ));
      }
    }

    return elements;
  }

  List<TextSpan> _createTextSpans() {
    _clearGestureRecognizers();
    return _generateElements(widget.text).map(
      (e) {
        var isLink = e.type == TextElementType.link;
        final linkAttr = (isLink && widget.onTransformDisplayLink != null)
            ? widget.onTransformDisplayLink(e.text)
            : null;
        final link = linkAttr != null ? linkAttr?.link : e.text;
        isLink &= link != null;

        return HighlightedTextSpan(
          text: linkAttr?.text ?? e.text,
          style: linkAttr?.style ?? (isLink ? widget.linkStyle : widget.style),
          highlightedStyle: isLink
              ? (linkAttr?.highlightedStyle ?? widget.highlightedLinkStyle)
              : null,
          recognizer: isLink ? _createGestureRecognizer(link) : null,
        );
      },
    ).toList();
  }

  TapAndLongPressGestureRecognizer _createGestureRecognizer(String link) {
    if (widget.onTap == null && widget.onLongPress == null) {
      return null;
    }
    final recognizer = TapAndLongPressGestureRecognizer();
    _gestureRecognizers.add(recognizer);
    if (widget.onTap != null) {
      recognizer.onTap = () => widget.onTap(link);
    }
    if (widget.onLongPress != null) {
      recognizer.onLongPress = () => widget.onLongPress(link);
    }
    return recognizer;
  }

  void _clearGestureRecognizers() {
    _gestureRecognizers.forEach((r) => r.dispose());
    _gestureRecognizers.clear();
  }
}
