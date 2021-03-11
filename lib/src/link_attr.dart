import 'package:flutter/widgets.dart';

class LinkAttribute {
  final String text;
  final String? link;
  final TextStyle? style;
  final TextStyle? highlightedStyle;

  LinkAttribute(
    this.text, {
    this.link,
    this.style,
    this.highlightedStyle,
  });
}
