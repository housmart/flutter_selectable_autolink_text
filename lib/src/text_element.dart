enum TextElementType { text, link }

class TextElement {
  final TextElementType type;
  final String text;

  TextElement({this.type, this.text});
}
