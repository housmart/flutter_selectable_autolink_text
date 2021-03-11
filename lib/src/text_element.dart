enum TextElementType { text, link }

class TextElement {
  final TextElementType type;
  final String text;

  TextElement({required this.type, required this.text});
}
