import 'link_attr.dart';

class AutoLinkUtils {
  AutoLinkUtils._();

  static const urlRegExpPattern =
      r'https?://([\w-]+\.)+[\w-]+(/[\w-./?%&@\$=~#+]*)?';
  static const phoneNumberRegExpPattern = r'[+0]\d+[\d-]+\d';
  static const emailRegExpPattern = r'[^@\s]+@([^@\s]+\.)+[^@\W]+';
  static const defaultLinkRegExpPattern =
      '($urlRegExpPattern|$phoneNumberRegExpPattern|$emailRegExpPattern)';

  static LinkAttribute shrinkUrl(String url) {
    final text = () {
      try {
        final uri = Uri.parse(url);
        final displayUrl = '${uri.host}${uri.path}';
        if (displayUrl.isEmpty) {
          return url;
        } else if (displayUrl.length > 30) {
          return '${displayUrl.substring(0, 29)}…';
        } else {
          return displayUrl;
        }
      } on FormatException catch (_) {
        return url;
      }
    }();
    return LinkAttribute(text, link: url);
  }
}
